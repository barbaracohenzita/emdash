port module Main exposing (main)

import Browser exposing (document)
import Browser.Events exposing (onKeyDown)
import File
import File.Select as Select
import Json.Decode as Decode
import List exposing (drop, filter, head, isEmpty, length, map)
import Maybe exposing (withDefault)
import Model exposing (Model, StoredModel, initialModel, initialStoredModel)
import Msg exposing (..)
import Parser
import Random exposing (generate)
import Set exposing (insert)
import String exposing (toLower, trim)
import Task
import Utils
    exposing
        ( getIndex
        , getNextIndex
        , getPrevIndex
        , insertOnce
        , updateItem
        )
import View exposing (view)


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
      }
    , Cmd.none
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
            ( model, Cmd.none )
    in
    case message of
        DragEnter ->
            ( { model | isDragging = True }, Cmd.none )

        DragLeave ->
            ( { model | isDragging = False }, Cmd.none )

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
                ( { model | parsingError = True }, Cmd.none )

            else
                ( { model
                    | parsingError = False
                    , entries = entries
                    , titles = Parser.getTitles entries
                  }
                , Cmd.none
                )

        ShowEntry entry ->
            ( { model | currentEntry = Just entry }, Cmd.none )

        ShowByIndex i ->
            ( { model
                | currentEntry =
                    drop i (withDefault model.entries model.shownEntries)
                        |> head
              }
            , Cmd.none
            )

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
            ( model
            , generate
                ShowByIndex
              <|
                Random.int
                    0
                    (length (withDefault model.entries model.shownEntries) - 1)
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
                , Cmd.none
                )

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
                , Cmd.none
                )

        SetInputFocus bool ->
            ( { model | inputFocused = bool, pendingTag = Nothing }, Cmd.none )

        FilterByTitle title ->
            if title == "*" then
                ( { model
                    | shownEntries = Nothing
                    , titleFilter = Nothing
                  }
                , Cmd.none
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
                , Cmd.none
                )

        UpdatePendingTag text ->
            ( { model | pendingTag = Just text }, Cmd.none )

        AddTag tag ->
            let
                tagN =
                    tag |> trim |> toLower
            in
            if tagN == "" then
                ( { model | pendingTag = Nothing }, Cmd.none )

            else
                case model.currentEntry of
                    Just entry ->
                        let
                            newTags =
                                insertOnce entry.tags tagN

                            newEntry =
                                { entry | tags = newTags }
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
                        , Cmd.none
                        )

                    _ ->
                        noOp

        ToggleFocusMode ->
            ( { model | focusMode = not model.focusMode }, Cmd.none )

        HideEntry entry ->
            let
                idx =
                    getIndex model.entries entry

                entries =
                    filter ((/=) entry) model.entries
            in
            update
                (ShowByIndex <|
                    if idx == length entries then
                        idx - 1

                    else
                        idx
                )
                { model
                    | hiddenEntries = insert entry.id model.hiddenEntries
                    , entries = entries
                }

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
                    "r" ->
                        update ShowRandom model

                    "ArrowRight" ->
                        update ShowNext model

                    "ArrowLeft" ->
                        update ShowPrev model

                    _ ->
                        noOp
