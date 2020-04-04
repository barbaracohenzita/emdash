port module Main exposing (main)

import Browser exposing (document)
import Browser.Dom
    exposing
        ( getViewport
        , getViewportOf
        , setViewportOf
        )
import Browser.Events exposing (onKeyDown, onResize)
import Dict
import Epub
import File
import File.Select as Select
import Json.Decode as Decode
import List
    exposing
        ( drop
        , filter
        , head
        , isEmpty
        , length
        , map
        , member
        , reverse
        , take
        )
import Maybe exposing (andThen, withDefault)
import Model
    exposing
        ( Entry
        , Filter(..)
        , InputFocus(..)
        , Model
        , StoredModel
        , initialModel
        , initialStoredModel
        , stringToFilter
        )
import Msg exposing (Msg(..))
import Parser
import Platform.Cmd exposing (batch, none)
import Random exposing (generate)
import Regex
import Set exposing (union)
import String exposing (toLower, trim)
import Task exposing (attempt, perform, sequence)
import Tuple exposing (first)
import Utils
    exposing
        ( KeyEvent
        , getEntryHeight
        , getIndex
        , getNextIndex
        , getPrevIndex
        , insertOnce
        , modelToStoredModel
        , needsTitles
        , queryCharMin
        , removeItem
        , rx
        , updateItem
        , updateItems
        )
import View exposing (sidebarId, view, viewerId)


port setStorage : StoredModel -> Cmd msg


port exportJson : StoredModel -> Cmd msg


port importJson : String -> Cmd msg


main : Program (Maybe StoredModel) Model Msg
main =
    document
        { init = init
        , update = update
        , view =
            \m ->
                { title = "Marginalia"
                , body = [ view m ]
                }
        , subscriptions =
            \_ ->
                Sub.batch
                    [ onResize (\w h -> Resize ( w, h ))
                    , Decode.map3 KeyEvent
                        (Decode.field "key" Decode.string)
                        (Decode.field "ctrlKey" Decode.bool)
                        (Decode.field "metaKey" Decode.bool)
                        |> Decode.map KeyDown
                        |> onKeyDown
                    ]
        }


init : Maybe StoredModel -> ( Model, Cmd Msg )
init maybeModel =
    let
        restored =
            withDefault initialStoredModel maybeModel

        filterType =
            stringToFilter restored.filterType

        selectedIds =
            Set.fromList restored.selectedEntries

        model_ =
            { initialModel
                | entries = restored.entries
                , hiddenEntries = Set.fromList restored.hiddenEntries
                , selectedEntries =
                    filter
                        (\entry -> Set.member entry.id selectedIds)
                        restored.entries
                , titles = Parser.getTitles restored.entries
                , authors = Parser.getAuthors restored.entries
                , tags = Parser.getTags restored.entries
                , filterType = filterType
                , focusMode = restored.focusMode
                , reverseList = restored.reverseList
            }

        model =
            case restored.filterValue of
                Just val ->
                    first <| update (FilterBy filterType val) model_

                _ ->
                    model_

        getSize =
            perform Resize
                (Task.map
                    (.viewport
                        >> (\v ->
                                ( v |> .width |> floor
                                , v |> .height |> floor
                                )
                           )
                    )
                    getViewport
                )
    in
    if isEmpty restored.selectedEntries then
        ( model, getSize )

    else
        let
            ( m, cmd ) =
                update (SelectEntries model.selectedEntries) model
        in
        ( m, batch [ getSize, cmd ] )


store : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
store ( model, cmd ) =
    ( model, batch [ cmd, model |> modelToStoredModel |> setStorage ] )


getEntries : Model -> List Entry
getEntries model =
    withDefault model.entries model.shownEntries


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    let
        noOp =
            ( model, none )
    in
    case message of
        DragEnter ->
            ( { model | isDragging = True }, none )

        DragLeave ->
            ( { model | isDragging = False }, none )

        GotFiles msg file _ ->
            ( { model | isDragging = False }
            , perform msg (File.toString file)
            )

        PickFile ->
            ( model, Select.files [ "text/plain" ] (GotFiles FileLoad) )

        FileLoad text ->
            let
                ids =
                    Set.fromList <| map .id model.entries

                new =
                    Parser.process text

                entries =
                    filter
                        (\entry ->
                            (not <| Set.member entry.id model.hiddenEntries)
                                && (not <| Set.member entry.id ids)
                        )
                        new
                        ++ model.entries
            in
            if isEmpty new then
                ( { model | parsingError = True }, none )

            else
                store
                    ( { model
                        | parsingError = False
                        , entries = entries
                        , selectedEntries =
                            case head entries of
                                Just entry ->
                                    [ entry ]

                                _ ->
                                    []
                        , titles = Parser.getTitles entries
                        , authors = Parser.getAuthors entries
                      }
                    , none
                    )

        ResetError ->
            ( { model | parsingError = False }, none )

        SelectEntries entries ->
            let
                sidebarView =
                    getViewportOf sidebarId
            in
            store
                ( { model | selectedEntries = entries }
                , if length entries == 1 then
                    batch
                        [ attempt
                            GotDomEl
                            (sequence
                                [ Task.map (.viewport >> .y) sidebarView
                                , Task.map (.viewport >> .height) sidebarView
                                ]
                            )
                        , attempt
                            DidScroll
                            (setViewportOf viewerId 0 0)
                        ]

                  else
                    none
                )

        EntryClick entry { control, meta, shift } ->
            if shift then
                let
                    entries =
                        (if model.reverseList then
                            reverse

                         else
                            identity
                        )
                        <|
                            getEntries model

                    selectedIndices =
                        map (getIndex entries) model.selectedEntries

                    targetIndex =
                        getIndex entries entry

                    minIndex =
                        withDefault 0 (List.minimum selectedIndices)

                    maxIndex =
                        withDefault 0 (List.maximum selectedIndices)

                    start =
                        if targetIndex < minIndex then
                            targetIndex

                        else
                            minIndex

                    end =
                        if targetIndex < minIndex then
                            maxIndex

                        else
                            targetIndex
                in
                update
                    (SelectEntries
                        (entries
                            |> drop start
                            |> take (end - start + 1)
                        )
                    )
                    model

            else if control || meta then
                update
                    (SelectEntries <|
                        (if List.member entry model.selectedEntries then
                            filter ((/=) entry)

                         else
                            (::) entry
                        )
                            model.selectedEntries
                    )
                    model

            else
                update (SelectEntries [ entry ]) model

        ShowByIndex i ->
            case
                drop i (getEntries model)
                    |> head
            of
                Just entry ->
                    update (SelectEntries [ entry ]) model

                _ ->
                    noOp

        ShowNext ->
            case model.selectedEntries of
                entry :: _ ->
                    update
                        (ShowByIndex <|
                            getNextIndex
                                (getEntries model)
                                entry
                        )
                        model

                [] ->
                    noOp

        ShowPrev ->
            case model.selectedEntries of
                entry :: _ ->
                    update
                        (ShowByIndex <|
                            getPrevIndex
                                (getEntries model)
                                entry
                        )
                        model

                _ ->
                    noOp

        ShowRandom ->
            let
                list =
                    getEntries model

                len =
                    length list

                currentIndex =
                    model.selectedEntries
                        |> head
                        |> andThen (getIndex list >> Just)
            in
            case len of
                0 ->
                    noOp

                1 ->
                    noOp

                2 ->
                    update ShowNext model

                _ ->
                    ( model
                    , generate
                        (\n ->
                            case currentIndex of
                                Just index ->
                                    if n == index then
                                        ShowRandom

                                    else
                                        ShowByIndex n

                                _ ->
                                    ShowByIndex n
                        )
                        (Random.int 0 (len - 1))
                    )

        SetInputFocus focus ->
            ( { model | inputFocused = focus }, none )

        FilterBy filterType val ->
            let
                applyFilter fn =
                    if val == "" then
                        ( { model
                            | shownEntries = Nothing
                            , filterValue = Nothing
                            , filterType = filterType
                          }
                        , none
                        )

                    else
                        ( { model
                            | filterValue = Just val
                            , shownEntries = Just <| filter fn model.entries
                            , filterType = filterType
                          }
                        , none
                        )
            in
            store <|
                case filterType of
                    TitleFilter ->
                        applyFilter <| .title >> (==) val

                    AuthorFilter ->
                        applyFilter <| .author >> (==) val

                    TagFilter ->
                        applyFilter <| .tags >> member val

                    TextFilter ->
                        let
                            term =
                                toLower val
                        in
                        if trim term == "" then
                            ( { model
                                | filterValue = Nothing
                                , shownEntries = Nothing
                                , filterType = filterType
                              }
                            , none
                            )

                        else if String.length term < queryCharMin then
                            ( { model
                                | filterValue = Just val
                                , filterType = filterType
                              }
                            , none
                            )

                        else
                            applyFilter <|
                                \entry ->
                                    Regex.contains
                                        (rx <| "\\b" ++ term)
                                        (toLower entry.text)

        UpdateNotes text ->
            case model.selectedEntries of
                [ entry ] ->
                    let
                        newEntry =
                            { entry | notes = text }
                    in
                    store
                        ( { model
                            | entries =
                                updateItem
                                    model.entries
                                    entry
                                    newEntry
                            , shownEntries =
                                Maybe.map
                                    (\entries ->
                                        updateItem
                                            entries
                                            entry
                                            newEntry
                                    )
                                    model.shownEntries
                            , selectedEntries = [ newEntry ]
                            , inputFocused = Nothing
                          }
                        , none
                        )

                _ ->
                    ( { model | inputFocused = Nothing }, none )

        UpdatePendingTag text ->
            ( { model | pendingTag = Just text }, none )

        AddTag ->
            case model.pendingTag of
                Just tag ->
                    let
                        tagN =
                            tag |> trim |> toLower
                    in
                    if tagN == "" then
                        ( { model | pendingTag = Nothing }, none )

                    else
                        let
                            updatedSelection =
                                map
                                    (\entry ->
                                        { entry
                                            | tags =
                                                insertOnce
                                                    entry.tags
                                                    tagN
                                        }
                                    )
                                    model.selectedEntries

                            updateMapping =
                                map
                                    (\entry -> ( entry.id, entry ))
                                    updatedSelection
                                    |> Dict.fromList
                        in
                        store
                            ( { model
                                | tags = insertOnce model.tags tagN
                                , entries =
                                    updateItems
                                        model.entries
                                        updateMapping
                                , shownEntries =
                                    Maybe.map
                                        (\entries ->
                                            updateItems
                                                entries
                                                updateMapping
                                        )
                                        model.shownEntries
                                , selectedEntries = updatedSelection
                                , pendingTag = Nothing
                              }
                            , none
                            )

                _ ->
                    noOp

        RemoveTag tag ->
            let
                updatedSelection =
                    map
                        (\entry ->
                            { entry | tags = removeItem entry.tags tag }
                        )
                        model.selectedEntries

                updateMapping =
                    map (\entry -> ( entry.id, entry )) updatedSelection
                        |> Dict.fromList

                newEntries =
                    updateItems
                        model.entries
                        updateMapping
            in
            store
                ( { model
                    | entries = newEntries
                    , tags = Parser.getTags newEntries
                    , selectedEntries = updatedSelection
                    , shownEntries =
                        Maybe.map
                            (\entries -> updateItems entries updateMapping)
                            model.shownEntries
                  }
                , none
                )

        ToggleFocusMode ->
            store ( { model | focusMode = not model.focusMode }, none )

        ToggleAboutMode ->
            ( { model | aboutMode = not model.aboutMode }, none )

        HideEntries entries ->
            let
                list =
                    getEntries model

                idx =
                    withDefault 0 (entries |> head |> Maybe.map (getIndex list))

                fn =
                    filter (\entry -> member entry entries |> not)

                len =
                    length list

                soleEntry =
                    len == 1
            in
            update
                (ShowByIndex <|
                    if soleEntry then
                        0

                    else if idx == len - 1 then
                        idx - 1

                    else
                        idx
                )
                { model
                    | hiddenEntries =
                        union
                            (entries |> map .id |> Set.fromList)
                            model.hiddenEntries
                    , entries = fn model.entries
                    , shownEntries =
                        if soleEntry then
                            Nothing

                        else
                            Maybe.map fn model.shownEntries
                    , filterValue =
                        if soleEntry then
                            Nothing

                        else
                            model.filterValue
                }

        Sort ->
            store ( { model | reverseList = not model.reverseList }, none )

        GotDomEl result ->
            case result of
                Ok [ offset, height ] ->
                    case
                        model.selectedEntries
                    of
                        entry :: _ ->
                            let
                                elHeight =
                                    needsTitles model
                                        |> getEntryHeight
                                        |> toFloat

                                targetY =
                                    getIndex
                                        ((if model.reverseList then
                                            reverse

                                          else
                                            identity
                                         )
                                            (withDefault
                                                model.entries
                                                model.shownEntries
                                            )
                                        )
                                        entry
                                        |> toFloat
                                        |> (*) elHeight
                            in
                            if
                                targetY
                                    + elHeight
                                    > (offset + height)
                                    || targetY
                                    < offset
                            then
                                ( model
                                , attempt
                                    DidScroll
                                    (setViewportOf sidebarId 0 targetY)
                                )

                            else
                                noOp

                        _ ->
                            noOp

                Ok _ ->
                    noOp

                Err _ ->
                    noOp

        DidScroll _ ->
            noOp

        InfList infiniteList ->
            ( { model | infiniteList = infiniteList }, none )

        ExportJson ->
            ( model, model |> modelToStoredModel |> exportJson )

        ImportJson ->
            ( model
            , Select.files [ "application/json" ] (GotFiles JsonFileLoad)
            )

        JsonFileLoad jsonText ->
            ( model, importJson jsonText )

        KeyDown { key, control, meta } ->
            if control || meta then
                case key of
                    "a" ->
                        update
                            (SelectEntries <|
                                withDefault
                                    model.entries
                                    model.shownEntries
                            )
                            model

                    _ ->
                        noOp

            else if model.inputFocused /= Nothing then
                if key == "Enter" && model.inputFocused == Just TagFocus then
                    update AddTag model

                else
                    noOp

            else
                case key of
                    "ArrowRight" ->
                        update
                            (if model.reverseList then
                                ShowPrev

                             else
                                ShowNext
                            )
                            model

                    "ArrowLeft" ->
                        update
                            (if model.reverseList then
                                ShowNext

                             else
                                ShowPrev
                            )
                            model

                    "r" ->
                        update ShowRandom model

                    "f" ->
                        update ToggleFocusMode model

                    "s" ->
                        update Sort model

                    "1" ->
                        update (FilterBy TitleFilter "") model

                    "2" ->
                        update (FilterBy AuthorFilter "") model

                    "3" ->
                        update (FilterBy TagFilter "") model

                    "4" ->
                        update (FilterBy TextFilter "") model

                    "Escape" ->
                        update
                            (if model.aboutMode then
                                ToggleAboutMode

                             else
                                FilterBy model.filterType ""
                            )
                            model

                    _ ->
                        noOp

        Resize size ->
            ( { model | uiSize = size }, none )

        ExportEpub ->
            ( model, Epub.export model.titles model.entries )
