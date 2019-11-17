module View exposing (sidebarId, view, viewerId)

import File
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy4, lazy5, lazy6)
import Html.Parser
import Html.Parser.Util
import InfiniteList as IL
import Json.Decode as Decode exposing (Decoder)
import List
    exposing
        ( concat
        , filter
        , foldr
        , head
        , isEmpty
        , length
        , member
        , reverse
        )
import Maybe exposing (andThen, withDefault)
import Model exposing (Author, Entry, Filter(..), Model, Tag, Title)
import Msg exposing (..)
import Regex
import Set
import String exposing (fromChar, fromInt, slice, toList)
import Utils exposing (ClickWithKeys, formatNumber, getEntryHeight, needsTitles, queryCharMin)


view : Model -> Html Msg
view model =
    let
        noEntries =
            isEmpty model.entries

        entryCount =
            length <|
                case model.shownEntries of
                    Just entries ->
                        entries

                    _ ->
                        model.entries
    in
    div
        [ id "container"
        , classList
            [ ( "focus-mode", model.focusMode )
            , ( "empty", noEntries )
            ]
        , on "dragenter" (Decode.succeed DragEnter)
        , on "dragover" (Decode.succeed DragEnter)
        , on "dragleave" (Decode.succeed DragLeave)
        , on "drop" dropDecoder
        ]
        [ header
            []
            [ div []
                [ img
                    [ src "logo.svg"
                    , draggable "false"
                    , onClick ToggleAboutMode
                    ]
                    []
                , if noEntries then
                    text ""

                  else
                    div [ id "entry-count", onClick Sort ]
                        [ text <|
                            formatNumber entryCount
                                ++ " excerpt"
                                ++ (if entryCount == 1 then
                                        " "

                                    else
                                        "s "
                                   )
                        , span []
                            [ text <|
                                if model.reverseList then
                                    "▲"

                                else
                                    "▼"
                            ]
                        ]
                ]
            , div [ id "tools" ]
                [ div [ id "filters", classList [ ( "hidden", noEntries ) ] ]
                    [ nav [ id "filter-links" ]
                        (map
                            (\( mode, label ) ->
                                span
                                    [ onClick <| FilterBy mode ""
                                    , classList
                                        [ ( "active"
                                          , model.filterType == mode
                                          )
                                        ]
                                    ]
                                    [ text label ]
                            )
                            [ ( TitleFilter, "title" )
                            , ( AuthorFilter, "author" )
                            , ( TagFilter, "tag" )
                            , ( TextFilter, "text" )
                            ]
                        )
                    , div [ id "filter-controls" ]
                        [ case model.filterType of
                            TitleFilter ->
                                lazy4
                                    selectMenu
                                    model.titles
                                    model.filterValue
                                    (FilterBy TitleFilter)
                                    "titles"

                            AuthorFilter ->
                                lazy4
                                    selectMenu
                                    model.authors
                                    model.filterValue
                                    (FilterBy AuthorFilter)
                                    "authors"

                            TagFilter ->
                                lazy4
                                    selectMenu
                                    model.tags
                                    model.filterValue
                                    (FilterBy TagFilter)
                                    "tags"

                            TextFilter ->
                                div [ id "search" ]
                                    [ span
                                        [ classList
                                            [ ( "x", True )
                                            , ( "hidden"
                                              , model.filterValue == Nothing
                                              )
                                            ]
                                        , onClick <| FilterBy TextFilter ""
                                        ]
                                        [ text "×" ]
                                    , input
                                        [ onInput <| FilterBy TextFilter
                                        , onFocus <| SetInputFocus True
                                        , onBlur <| SetInputFocus False
                                        , id "search-input"
                                        , value <|
                                            Maybe.withDefault
                                                ""
                                                model.filterValue
                                        , placeholder "search"
                                        , autocomplete False
                                        , spellcheck False
                                        ]
                                        []
                                    ]
                        ]
                    ]
                , div [ id "actions" ]
                    (map
                        (\( s, action ) ->
                            div [ onClick action ]
                                [ img
                                    [ src <| s ++ ".svg"
                                    , draggable "false"
                                    ]
                                    []
                                , label []
                                    [ text <|
                                        if s == "about" then
                                            "&c."

                                        else
                                            s
                                    ]
                                ]
                        )
                        [ ( "focus", ToggleFocusMode )
                        , ( "random", ShowRandom )
                        , ( "about", ToggleAboutMode )
                        ]
                    )
                ]
            ]
        , main_ []
            [ if noEntries then
                text ""

              else
                lazy6
                    sidebar
                    model.infiniteList
                    model.uiSize
                    ((if model.reverseList then
                        reverse

                      else
                        identity
                     )
                        (withDefault model.entries model.shownEntries)
                    )
                    (if model.filterType == TextFilter then
                        model.filterValue

                     else
                        Nothing
                    )
                    (needsTitles model)
                    model.selectedEntries
            , lazy5
                viewer
                model.selectedEntries
                model.parsingError
                noEntries
                model.tags
                model.pendingTag
            , if model.aboutMode then
                lazy4
                    aboutView
                    model.entries
                    model.titles
                    model.authors
                    model.tags

              else
                text ""
            ]
        ]


viewer :
    List Entry
    -> Bool
    -> Bool
    -> List Tag
    -> Maybe Tag
    -> Html Msg
viewer selectedEntries parsingError noEntries tags pendingTag =
    div
        (id "viewer"
            :: (if parsingError then
                    [ onClick ResetError ]

                else
                    []
               )
        )
        [ case selectedEntries of
            [ entry ] ->
                div []
                    [ blockquote [] [ text entry.text ]
                    , Html.cite [ id "meta" ]
                        [ div
                            [ onClick <| FilterBy TitleFilter entry.title
                            , class "title"
                            ]
                            [ text entry.title ]
                        , div
                            [ onClick <| FilterBy AuthorFilter entry.author
                            , class "author"
                            ]
                            [ text entry.author ]
                        , case entry.page of
                            Just n ->
                                div
                                    [ class "page" ]
                                    [ text <| "p. " ++ String.fromInt n ]

                            _ ->
                                text ""
                        ]
                    , div
                        [ id "entry-tools" ]
                        [ tagSection entry.tags pendingTag
                        , section []
                            [ h5 [] [ text "notes:" ]
                            , textarea
                                [ onFocus <| SetInputFocus True
                                , onBlurVal UpdateNotes
                                , value entry.notes
                                ]
                                [ text entry.notes ]
                            ]
                        , hideButton [ entry ]
                        ]
                    ]

            [] ->
                div [ id "intro", class "info-page" ]
                    [ if parsingError then
                        p [ class "error" ] [ text "Error parsing file." ]

                      else if noEntries then
                        introView

                      else
                        text ""
                    ]

            entries ->
                let
                    titleCount =
                        entries
                            |> map .title
                            |> Set.fromList
                            |> Set.size
                in
                div []
                    [ h3 []
                        [ text <|
                            (entries |> length |> fromInt)
                                ++ " entries from "
                        , if titleCount > 1 then
                            text <| fromInt titleCount ++ " titles"

                          else
                            case entries of
                                entry :: _ ->
                                    em [] [ text entry.title ]

                                _ ->
                                    text ""
                        ]
                    , div [ id "entry-tools" ]
                        [ tagSection
                            (foldr
                                (\entry set ->
                                    Set.intersect set (Set.fromList entry.tags)
                                )
                                (withDefault
                                    Set.empty
                                    (entries
                                        |> head
                                        |> Maybe.map (.tags >> Set.fromList)
                                    )
                                )
                                entries
                                |> Set.toList
                            )
                            pendingTag
                        , hideButton entries
                        ]
                    ]
        ]


tagSection : List Tag -> Maybe Tag -> Html Msg
tagSection tags pendingTag =
    let
        pendTag =
            Maybe.withDefault "" pendingTag
    in
    section []
        [ h5 [] [ text "tags:" ]
        , if length tags > 0 then
            div
                [ id "tags" ]
                [ ul
                    []
                    (map
                        (\tag ->
                            li
                                [ class "tag" ]
                                [ span
                                    [ onClick <| RemoveTag tag
                                    , class "x"
                                    ]
                                    [ text "×" ]
                                , span
                                    [ onClick <| FilterBy TagFilter tag
                                    , class "tag-title"
                                    ]
                                    [ text tag ]
                                ]
                        )
                        tags
                    )
                ]

          else
            text ""
        , div [ class "tag-input" ]
            [ input
                [ onInput UpdatePendingTag
                , onFocus <| SetInputFocus True
                , onBlur <| SetInputFocus False
                , value pendTag
                , placeholder "add tag"
                , autocomplete False
                , spellcheck False
                ]
                []
            , let
                tagList =
                    filter
                        (\tag ->
                            member tag tags
                                |> not
                                |> (&&) (String.contains pendTag tag)
                        )
                        tags
              in
              if length tagList > 0 then
                ul
                    [ class "tag-list" ]
                    (map
                        (\tag -> li [ onClick <| AddTag tag ] [ text tag ])
                        tagList
                    )

              else
                text ""
            ]
        ]


hideButton : List Entry -> Html Msg
hideButton entries =
    section []
        [ div
            [ class "hide-button", onClick <| HideEntries entries ]
            [ div [] [ text "×" ]
            , span []
                [ text <|
                    "delete entr"
                        ++ (case entries of
                                [ _ ] ->
                                    "y"

                                _ ->
                                    "ies"
                           )
                ]
            ]
        ]


sidebar :
    IL.Model
    -> ( Int, Int )
    -> List Entry
    -> Maybe String
    -> Bool
    -> List Entry
    -> Html Msg
sidebar infiniteList ( _, h ) entries query showTitles selectedEntries =
    div
        [ id sidebarId
        , classList [ ( "no-titles", not showTitles ) ]
        , IL.onScroll InfList
        ]
        [ if length entries == 0 then
            div [ class "no-results" ] [ text "no results" ]

          else
            IL.view
                (IL.config
                    { itemView = listEntry query showTitles selectedEntries
                    , itemHeight =
                        IL.withConstantHeight <| getEntryHeight showTitles
                    , containerHeight = h
                    }
                    |> IL.withCustomContainer entriesContainer
                )
                infiniteList
                entries
        ]


entriesContainer : List ( String, String ) -> List (Html msg) -> Html msg
entriesContainer styles children =
    ul (map (\( k, v ) -> style k v) styles) children


takeExcerpt : String -> String
takeExcerpt text =
    let
        f acc chars n =
            case chars of
                x :: xs ->
                    if n < charLimit || n >= charLimit && x /= ' ' then
                        f (acc ++ fromChar x) xs (n + 1)

                    else
                        acc

                [] ->
                    acc
    in
    f "" (toList text) 0 ++ " …"


addHighlighting : String -> String -> List (Html msg)
addHighlighting str query =
    let
        rx =
            Regex.fromStringWith
                { caseInsensitive = True, multiline = False }
                ("\\b" ++ query)
                |> Maybe.withDefault Regex.never

        index =
            Regex.find rx str |> map .index |> head |> withDefault 0

        addTag m =
            "<span class=\"highlight\">" ++ .match m ++ "</span>"

        excerpt =
            let
                trunc =
                    if (index + String.length query) > charLimit then
                        "…" ++ slice index (String.length str) str

                    else
                        str
            in
            trunc
    in
    case Html.Parser.run <| Regex.replace rx addTag excerpt of
        Ok parsedNodes ->
            Html.Parser.Util.toVirtualDom parsedNodes

        _ ->
            [ text str ]


listEntry :
    Maybe String
    -> Bool
    -> List Entry
    -> Int
    -> Int
    -> Entry
    -> Html Msg
listEntry query showTitles selectedEntries idx listIdx entry =
    let
        selectedIds =
            selectedEntries |> map .id |> Set.fromList
    in
    li
        [ id entry.id
        , Decode.map3 ClickWithKeys
            (Decode.field "ctrlKey" Decode.bool)
            (Decode.field "metaKey" Decode.bool)
            (Decode.field "shiftKey" Decode.bool)
            |> Decode.map (EntryClick entry)
            |> on "click"
        ]
        [ if Set.member entry.id selectedIds then
            div [ class "active-entry" ] []

          else
            text ""
        , blockquote
            []
            (case query of
                Nothing ->
                    [ text entry.text ]

                Just q ->
                    if String.length q < queryCharMin then
                        [ text entry.text ]

                    else
                        addHighlighting entry.text q
            )
        , if showTitles then
            Html.cite [ class "title" ] [ text entry.title ]

          else
            text ""
        ]


selectMenu :
    List String
    -> Maybe String
    -> (String -> Msg)
    -> String
    -> Html Msg
selectMenu values mState inputFn default =
    let
        defaultLabel =
            "(all " ++ default ++ ")"
    in
    div [ class "select" ]
        [ span
            [ classList
                [ ( "x", True )
                , ( "hidden", mState == Nothing )
                ]
            , onClick <| inputFn ""
            ]
            [ text "×" ]
        , div [ class <| "select-" ++ default ]
            [ select
                [ onInput inputFn
                , value <|
                    case mState of
                        Just state ->
                            state

                        _ ->
                            ""
                ]
                (option
                    [ value "" ]
                    [ text defaultLabel ]
                    :: map (\t -> option [ value t ] [ text t ]) values
                )
            , h5 [ classList [ ( "no-filter", mState == Nothing ) ] ]
                [ text <|
                    case mState of
                        Just state ->
                            state

                        _ ->
                            defaultLabel
                ]
            ]
        ]


introView : Html Msg
introView =
    div []
        [ p [ class "big" ]
            [ text <|
                "This is Marginalia, a tool to organize excerpts from ebooks "
                    ++ "with tags, notes, and search."
            ]
        , h4 [] [ text "To begin:" ]
        , div [ id "instructions" ]
            [ p []
                [ text <|
                    "Drop a clippings text file onto this page to import "
                        ++ "its excerpts."
                ]
            , p []
                [ text "Or, "
                , a [ onClick PickFile ] [ text "click here" ]
                , text " to browse for the file."
                ]
            ]
        , h4 [] [ em [] [ text "Nota bene:" ] ]
        , ol []
            [ li []
                [ text <|
                    "Marginalia works entirely on your device and stores all "
                        ++ "your data there."
                ]
            , li []
                [ text <|
                    "You can easily export your data (tags, notes, &c.) as "
                , span [ class "small-caps" ] [ text "json" ]
                , text "."
                ]
            , li []
                [ text "It works offline." ]
            , li []
                [ text "It’s "
                , a [ href repoUrl, target "_blank" ] [ text "open source" ]
                , text "."
                ]
            , li [] [ text "You might like it." ]
            ]
        , p [] [ text "❦" ]
        , footer [] [ text "Habent sua fata libelli" ]
        ]


aboutView : List Entry -> List Title -> List Author -> List Tag -> Html Msg
aboutView entries titles authors tags =
    div [ id "about" ]
        [ div [ class "info-page" ]
            [ div
                [ class "hide-button", onClick ToggleAboutMode ]
                [ div [] [ text "×" ] ]
            , p [ class "big" ]
                [ text
                    "Marginalia is an open source tool created by "
                , a [ href "https://oxism.com", target "_blank" ]
                    [ text "Dan Motzenbecker" ]
                , text "."
                ]
            , div
                [ class "col-2" ]
                [ div []
                    [ h4 [] [ text "Actions" ]
                    , p []
                        [ a
                            [ href repoUrl
                            , target "_blank"
                            ]
                            [ text "Read the source" ]
                        ]
                    , p []
                        [ a [ onClick ExportJson ]
                            [ text "Export "
                            , span [ class "small-caps" ] [ text "json" ]
                            ]
                        ]
                    , p []
                        [ a [ onClick ImportJson ]
                            [ text "Import "
                            , span [ class "small-caps" ] [ text "json" ]
                            ]
                        ]
                    ]
                , div []
                    [ h4 [] [ text "Statistics" ]
                    , ol []
                        (map
                            (\( name, n ) ->
                                li []
                                    [ text <|
                                        formatNumber n
                                            ++ " "
                                            ++ name
                                            ++ (if n /= 1 then
                                                    "s"

                                                else
                                                    ""
                                               )
                                    ]
                            )
                            [ ( "excerpt", length entries )
                            , ( "title", length titles )
                            , ( "author", length authors )
                            , ( "tag", length tags )
                            ]
                        )
                    ]
                ]
            , h4 [] [ text "Colophon" ]
            , p []
                [ text "Marginalia is written in "
                , a
                    [ href "https://elm-lang.org/", target "_blank" ]
                    [ text "Elm" ]
                , text " and typeset in "
                , a
                    [ href "https://github.com/impallari/Libre-Baskerville"
                    , target "_blank"
                    ]
                    [ text "Libre Baskerville" ]
                , text "."
                ]
            , p [] [ text "❦" ]
            , footer [] [ text "Habent sua fata libelli" ]
            ]
        ]


dropDecoder : Decoder Msg
dropDecoder =
    Decode.at
        [ "dataTransfer", "files" ]
        (Decode.oneOrMore (GotFiles FileLoad) File.decoder)


hijack : msg -> ( msg, Bool )
hijack msg =
    ( msg, True )


on : String -> Decoder msg -> Attribute msg
on event decoder =
    preventDefaultOn event (Decode.map hijack decoder)


onBlurVal : (String -> msg) -> Attribute msg
onBlurVal ev =
    on "blur" (Decode.map ev targetValue)


charLimit : Int
charLimit =
    42


repoUrl : String
repoUrl =
    "https://github.com/dmotz/marginalia"


viewerId : String
viewerId =
    "viewer"


sidebarId : String
sidebarId =
    "sidebar"


map : (a -> b) -> List a -> List b
map =
    List.map
