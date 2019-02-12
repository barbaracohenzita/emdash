port module Main exposing (main)

import Browser exposing (document)
import Browser.Events exposing (onKeyDown)
import File
import File.Select as Select
import Json.Decode as Decode
import List exposing (drop, filter, head, length, map)
import Model exposing (Model, StoredModel, initialModel, initialStoredModel)
import Msg exposing (..)
import Parser
import Random exposing (generate)
import Task
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
            Maybe.withDefault initialStoredModel maybeModel
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
            }
        , cmds
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
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
                    drop i model.entries |> head
              }
            , Cmd.none
            )

        ShowRandom ->
            ( model
            , generate
                ShowByIndex
              <|
                Random.int 0 (length model.entries - 1)
            )

        FilterBySearch rawTerm ->
            let
                term =
                    rawTerm |> String.trim |> String.toLower
            in
            if term == "" then
                ( { model
                    | shownEntries = []
                    , searchFilter = Nothing
                  }
                , Cmd.none
                )

            else
                ( { model
                    | searchFilter = Just term
                    , shownEntries =
                        filter
                            (\entry ->
                                String.contains
                                    term
                                    (String.toLower entry.text)
                            )
                            model.entries
                  }
                , Cmd.none
                )

        SetInputFocus bool ->
            ( { model | inputFocused = bool }, Cmd.none )

        FilterByTitle title ->
            if title == "*" then
                ( { model
                    | shownEntries = []
                    , titleFilter = Nothing
                  }
                , Cmd.none
                )

            else
                ( { model
                    | titleFilter = Just title
                    , shownEntries =
                        filter (\entry -> entry.title == title) model.entries
                  }
                , Cmd.none
                )

        -- FilterByAuthor name ->
        ToggleFocusMode ->
            ( { model | focusMode = not model.focusMode }, Cmd.none )

        KeyDown key ->
            if model.inputFocused then
                ( model, Cmd.none )

            else
                case key of
                    "r" ->
                        update ShowRandom model

                    _ ->
                        ( model, Cmd.none )
