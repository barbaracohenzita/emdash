module Views.Create exposing (createView)

import Html
    exposing
        ( Html
        , button
        , datalist
        , div
        , form
        , h1
        , input
        , label
        , option
        , span
        , text
        , textarea
        )
import Html.Attributes as H
    exposing
        ( class
        , disabled
        , id
        , list
        , spellcheck
        , type_
        , value
        )
import Html.Events exposing (onBlur, onClick, onInput)
import List exposing (map)
import Maybe exposing (withDefault)
import Model exposing (Author, PendingEntry, Title)
import Msg exposing (Msg(..))
import String exposing (isEmpty)


createView : PendingEntry -> List Title -> List Author -> Html Msg
createView pendingEntry titles authors =
    div
        [ class "createPage" ]
        [ h1 [] [ text "Create a new excerpt" ]
        , form
            []
            [ label
                []
                [ textarea
                    [ value pendingEntry.text
                    , onInput
                        (\s ->
                            UpdatePendingEntry
                                { pendingEntry | text = s }
                        )
                    , spellcheck False
                    ]
                    []
                , text "Excerpt text"
                ]
            , let
                listId =
                    "titleList"
              in
              label
                []
                [ input
                    [ value pendingEntry.title
                    , list listId
                    , onInput
                        (\s ->
                            UpdatePendingEntry
                                { pendingEntry | title = s }
                        )
                    , onBlur PendingTitleBlur
                    , spellcheck False
                    ]
                    []
                , text "Book / Title"
                , datalist
                    [ id listId ]
                    (map (\t -> option [ value t ] []) titles)
                ]
            , let
                listId =
                    "authorList"
              in
              label
                []
                [ input
                    [ value pendingEntry.author
                    , list listId
                    , onInput
                        (\s ->
                            UpdatePendingEntry
                                { pendingEntry | author = s }
                        )
                    , spellcheck False
                    ]
                    []
                , text "Author"
                , datalist
                    [ id listId ]
                    (map (\t -> option [ value t ] []) authors)
                ]
            , label
                []
                [ input
                    [ type_ "number"
                    , H.min "0"
                    , value <|
                        if pendingEntry.page > -1 then
                            String.fromInt pendingEntry.page

                        else
                            ""
                    , onInput
                        (\s ->
                            UpdatePendingEntry
                                { pendingEntry
                                    | page = withDefault -1 (String.toInt s)
                                }
                        )
                    ]
                    []
                , text "Page № "
                , span [] [ text "(optional)" ]
                ]
            ]
        , button
            [ class "button"
            , onClick (GetTime (CreateEntry pendingEntry))
            , disabled
                (isEmpty pendingEntry.text
                    || isEmpty pendingEntry.title
                    || isEmpty pendingEntry.author
                )
            ]
            [ text "Create" ]
        ]
