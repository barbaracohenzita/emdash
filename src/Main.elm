port module Main exposing (main)

import Browser exposing (document)
import Browser.Dom exposing (getElement, getViewportOf, setViewportOf)
import Browser.Events exposing (onKeyDown)
import File
import File.Select as Select
import Json.Decode as Decode
import List exposing (drop, filter, head, isEmpty, length, map, member)
import Maybe exposing (withDefault)
import Model exposing (Model, StoredModel, initialModel, initialStoredModel)
import Msg exposing (..)
import Parser
import Platform.Cmd exposing (none)
import Random exposing (generate)
import Set exposing (insert)
import String exposing (toLower, trim)
import Task exposing (andThen, attempt, sequence, succeed)
import Utils
    exposing
        ( getIndex
        , getNextIndex
        , getPrevIndex
        , insertOnce
        , queryCharMin
        , removeItem
        , updateItem
        )
import View exposing (sidebarId, view)


main : Program (Maybe StoredModel) Model Msg
main =
    document
        { init = init
        , update = updateWithStorage
        , view =
            \m ->
                { title = "Marginalia"
                , body = [ view m ]
                }
        , subscriptions =
            \_ ->
                Decode.field "key" Decode.string
                    |> Decode.map KeyDown
                    |> onKeyDown
        }


init : Maybe StoredModel -> ( Model, Cmd Msg )
init maybeModel =
    let
        restored =
            withDefault initialStoredModel maybeModel
    in
    ( { initialModel
        | entries = restored.entries
        , currentEntry = restored.currentEntry
        , titles = Parser.getTitles restored.entries
        , tags = Parser.getTags restored.entries
      }
    , none
    )


port setStorage : StoredModel -> Cmd msg


updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
    let
        ( newModel, cmds ) =
            update msg model
    in
    ( newModel
    , Cmd.batch
        [ setStorage
            { entries = newModel.entries
            , currentEntry = newModel.currentEntry
            , hiddenEntries = Set.toList newModel.hiddenEntries
            , tags = newModel.tags
            }
        , cmds
        ]
    )


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

        GotFiles file _ ->
            ( { model | isDragging = False }
            , Task.perform FileLoad (File.toString file)
            )

        PickFile ->
            ( model, Select.files [ "text/plain" ] GotFiles )

        FileLoad text ->
            let
                entries =
                    Parser.process text
            in
            if entries == [] then
                ( { model | parsingError = True }, none )

            else
                ( { model
                    | parsingError = False
                    , entries = entries
                    , titles = Parser.getTitles entries
                  }
                , none
                )

        ShowEntry entry ->
            ( { model | currentEntry = Just entry }, none )

        ShowByIndex i ->
            case
                drop i (withDefault model.entries model.shownEntries)
                    |> head
            of
                Just entry ->
                    let
                        sidebarView =
                            getViewportOf sidebarId

                        entryElement =
                            getElement entry.id
                    in
                    ( { model | currentEntry = Just entry }
                    , attempt GotDomEl
                        (sequence
                            [ Task.map (.viewport >> .y) sidebarView
                            , Task.map (.viewport >> .height) sidebarView
                            , Task.map (.element >> .y) (getElement sidebarId)
                            , Task.map (.element >> .y) entryElement
                            , Task.map (.element >> .height) entryElement
                            ]
                        )
                    )

                _ ->
                    noOp

        ShowNext ->
            case model.currentEntry of
                Just entry ->
                    update
                        (ShowByIndex <|
                            getNextIndex
                                (withDefault model.entries model.shownEntries)
                                entry
                        )
                        model

                _ ->
                    noOp

        ShowPrev ->
            case model.currentEntry of
                Just entry ->
                    update
                        (ShowByIndex <|
                            getPrevIndex
                                (withDefault model.entries model.shownEntries)
                                entry
                        )
                        model

                _ ->
                    noOp

        ShowRandom ->
            let
                list =
                    withDefault model.entries model.shownEntries

                len =
                    length list
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
                            case model.currentEntry of
                                Just entry ->
                                    if n == getIndex list entry then
                                        ShowRandom

                                    else
                                        ShowByIndex n

                                _ ->
                                    ShowByIndex n
                        )
                        (Random.int 0 (len - 1))
                    )

        FilterBySearch rawTerm ->
            let
                term =
                    toLower rawTerm
            in
            if trim term == "" then
                ( { model
                    | shownEntries = Nothing
                    , searchFilter = Nothing
                  }
                , none
                )

            else if String.length rawTerm < queryCharMin then
                ( { model | searchFilter = Just term }, none )

            else
                ( { model
                    | searchFilter = Just term
                    , shownEntries =
                        Just <|
                            filter
                                (\entry ->
                                    String.contains term (toLower entry.text)
                                )
                                model.entries
                  }
                , none
                )

        SetInputFocus bool ->
            ( { model | inputFocused = bool, pendingTag = Nothing }, none )

        FilterByTitle title ->
            if title == "*" then
                ( { model
                    | shownEntries = Nothing
                    , titleFilter = Nothing
                  }
                , none
                )

            else
                ( { model
                    | titleFilter = Just title
                    , shownEntries =
                        Just <|
                            filter
                                (\entry -> entry.title == title)
                                model.entries
                  }
                , none
                )

        FilterByTag tag ->
            ( { model
                | shownEntries =
                    Just <|
                        filter (\ent -> member tag ent.tags) model.entries
              }
            , none
            )

        UpdatePendingTag text ->
            ( { model | pendingTag = Just text }, none )

        AddTag tag ->
            let
                tagN =
                    tag |> trim |> toLower
            in
            if tagN == "" then
                ( { model | pendingTag = Nothing }, none )

            else
                case model.currentEntry of
                    Just entry ->
                        let
                            newEntry =
                                { entry | tags = insertOnce entry.tags tagN }
                        in
                        ( { model
                            | tags = insertOnce model.tags tagN
                            , entries = updateItem model.entries entry newEntry
                            , shownEntries =
                                Maybe.map
                                    (\entries ->
                                        updateItem entries entry newEntry
                                    )
                                    model.shownEntries
                            , currentEntry = Just newEntry
                            , pendingTag = Nothing
                          }
                        , none
                        )

                    _ ->
                        noOp

        RemoveTag tag ->
            case model.currentEntry of
                Just entry ->
                    let
                        newEntry =
                            { entry | tags = removeItem entry.tags tag }

                        newEntries =
                            updateItem model.entries entry newEntry
                    in
                    ( { model
                        | entries = newEntries
                        , tags = Parser.getTags newEntries
                        , currentEntry = Just newEntry
                        , shownEntries =
                            Maybe.map
                                (\entries ->
                                    updateItem entries entry newEntry
                                )
                                model.shownEntries
                      }
                    , none
                    )

                _ ->
                    noOp

        ToggleFocusMode ->
            ( { model | focusMode = not model.focusMode }, none )

        HideEntry entry ->
            let
                list =
                    withDefault model.entries model.shownEntries

                idx =
                    getIndex list entry

                fn =
                    filter ((/=) entry)
            in
            update
                (ShowByIndex <|
                    if idx == length list - 1 then
                        idx - 1

                    else
                        idx
                )
                { model
                    | hiddenEntries = insert entry.id model.hiddenEntries
                    , entries = fn model.entries
                    , shownEntries = Maybe.map fn model.shownEntries
                }

        GotDomEl result ->
            case result of
                Ok [ offset, height, parentY, childY, elHeight ] ->
                    let
                        targetY =
                            childY - parentY
                    in
                    if targetY + elHeight > height || targetY < 0 then
                        ( model
                        , Task.attempt
                            DidScroll
                            (setViewportOf
                                sidebarId
                                0
                                (offset + targetY)
                            )
                        )

                    else
                        noOp

                Ok _ ->
                    noOp

                Err _ ->
                    noOp

        DidScroll _ ->
            noOp

        KeyDown key ->
            if model.inputFocused then
                case key of
                    "Enter" ->
                        case model.pendingTag of
                            Just tag ->
                                update (AddTag tag) model

                            _ ->
                                noOp

                    _ ->
                        noOp

            else
                case key of
                    "ArrowRight" ->
                        update ShowNext model

                    "ArrowLeft" ->
                        update ShowPrev model

                    "r" ->
                        update ShowRandom model

                    "f" ->
                        update ToggleFocusMode model

                    _ ->
                        noOp
