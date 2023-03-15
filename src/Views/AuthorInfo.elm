module Views.AuthorInfo exposing (authorInfo)

import Dict exposing (get)
import Html exposing (Html, a, div, h1, h2, h5, li, text, ul)
import Html.Attributes exposing (class, href)
import List exposing (foldl, length, map)
import Msg exposing (Msg)
import Router exposing (authorToRoute)
import Types exposing (Book, NeighborMap)
import Utils exposing (excerptCountLabel, titleCountLabel)


authorInfo : String -> List Book -> NeighborMap -> Html Msg
authorInfo author books neighborMap =
    div
        [ class "authorInfo" ]
        [ h1 [] [ text author ]
        , h2
            []
            [ titleCountLabel
                (length books)
                ++ ", "
                ++ (books
                        |> foldl (\{ count } acc -> acc + count) 0
                        |> excerptCountLabel
                   )
                |> text
            ]
        , div
            [ class "related" ]
            [ h5 [] [ text "Related: " ]
            , ul []
                (case get author neighborMap of
                    Just ids ->
                        map
                            (\( neighbor, _ ) ->
                                li
                                    []
                                    [ a
                                        [ href <| authorToRoute neighbor ]
                                        [ text neighbor ]
                                    ]
                            )
                            ids

                    _ ->
                        [ li [ class "wait" ] [ text "…" ] ]
                )
            ]
        ]
