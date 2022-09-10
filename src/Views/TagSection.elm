module Views.TagSection exposing (tagSection)

import Html
    exposing
        ( Html
        , a
        , button
        , datalist
        , div
        , h5
        , input
        , li
        , option
        , text
        , ul
        )
import Html.Attributes
    exposing
        ( autocomplete
        , class
        , disabled
        , href
        , id
        , list
        , placeholder
        , spellcheck
        , value
        )
import Html.Events exposing (onBlur, onClick, onFocus, onInput)
import List exposing (filter, length, map, member)
import Model exposing (Filter(..), InputFocus(..), Tag)
import Msg exposing (Msg(..))
import Router exposing (tagToRoute)


tagSection : List Tag -> List Tag -> Maybe Tag -> Html Msg
tagSection tags globalTags pendingTag =
    div []
        [ h5 [] [ text "Tags" ]
        , if length tags > 0 then
            div
                [ class "tags" ]
                [ ul
                    []
                    (map
                        (\tag ->
                            li
                                [ class "tag" ]
                                [ a
                                    [ href <| tagToRoute tag ]
                                    [ text tag ]
                                , button
                                    [ onClick <| RemoveTag tag
                                    , class "tagDelete"
                                    ]
                                    [ text "×" ]
                                ]
                        )
                        tags
                    )
                ]

          else
            text ""
        , let
            datalistId =
                "tagDatalist"

            pendTag =
                Maybe.withDefault "" pendingTag
          in
          div [ class "tagInput" ]
            [ datalist [ id datalistId ]
                (map
                    (\tag -> option [ value tag ] [])
                    (filter
                        (\tag ->
                            member tag tags
                                |> not
                                |> (&&) (String.contains pendTag tag)
                        )
                        globalTags
                    )
                )
            , input
                [ onInput UpdatePendingTag
                , onFocus <| SetInputFocus (Just TagFocus)
                , onBlur <| SetInputFocus Nothing
                , value pendTag
                , list datalistId
                , placeholder "add tag"
                , autocomplete False
                , spellcheck False
                ]
                []
            , button
                [ class "button", onClick AddTag, disabled <| pendTag == "" ]
                [ text "+" ]
            ]
        ]
