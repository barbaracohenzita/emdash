module Views.Citation exposing (citation)

import Html exposing (Html, a, cite, div, meter, span, text)
import Html.Attributes exposing (class, href, value)
import Html.Events exposing (stopPropagationOn)
import Json.Decode exposing (succeed)
import List exposing (intersperse, map)
import Model exposing (Book, Entry)
import Msg exposing (Msg(..))
import Router exposing (authorToRoute, titleSlugToRoute)
import String exposing (fromFloat, fromInt)
import Utils exposing (getEntryDomId)


citation : Entry -> Book -> Maybe Float -> Html Msg
citation entry book mScore =
    cite []
        ([ a
            [ class "title", href <| titleSlugToRoute book.slug, stopLinkProp ]
            [ text book.title ]
         , span [ class "divider" ] [ text " • " ]
         , div
            []
            (map
                (\author ->
                    a
                        [ href <| authorToRoute author, stopLinkProp ]
                        [ text author ]
                )
                book.authors
                |> intersperse (text " / ")
            )
         ]
            ++ (if entry.page /= -1 then
                    [ span [ class "divider" ] [ text " • " ]
                    , a
                        [ href <|
                            titleSlugToRoute book.slug
                                ++ "#"
                                ++ getEntryDomId entry.id
                        , stopLinkProp
                        ]
                        [ text <| "p. " ++ fromInt entry.page ]
                    ]

                else
                    []
               )
            ++ (case mScore of
                    Just score ->
                        [ div
                            [ class "score" ]
                            [ span [] [ text (score * 100 |> round |> fromInt) ]
                            , meter [ score |> fromFloat |> value ] []
                            ]
                        ]

                    _ ->
                        []
               )
        )


stopLinkProp : Html.Attribute Msg
stopLinkProp =
    stopPropagationOn "click" (succeed ( NoOp, True ))
