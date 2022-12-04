module Parser exposing (getAuthorRouteMap, getTitleRouteMap, process)

import Base64 exposing (fromBytes)
import Bytes.Encode exposing (encode, sequence, unsignedInt8)
import Char exposing (isDigit)
import DateTime exposing (fromRawParts, toPosix)
import Dict exposing (Dict, get, insert, update)
import List exposing (all, foldr, head, map, reverse, sortBy)
import MD5 exposing (bytes)
import Maybe exposing (andThen, withDefault)
import Model exposing (Author, Book, BookMap, EntryMap, Id)
import Regex exposing (Match, Regex, replace)
import Router exposing (slugify)
import String exposing (lines, repeat, right, split, startsWith, toInt, trim)
import Time exposing (Month(..), posixToMillis)
import Utils exposing (juxt, rx, rx_)


process : String -> ( EntryMap, BookMap )
process =
    lines
        >> foldr folder ( [], [] )
        >> (\( xs, x ) -> x :: xs)
        >> foldr findNotes []
        >> makeDicts


separator : String
separator =
    repeat 10 "="


hashId : String -> String
hashId =
    bytes
        >> map unsignedInt8
        >> sequence
        >> encode
        >> fromBytes
        >> withDefault ""
        >> String.replace "==" ""
        >> String.replace "+" "-"
        >> String.replace "/" "_"


folder :
    String
    -> ( List (List String), List String )
    -> ( List (List String), List String )
folder line ( blocks, currentBlock ) =
    if line == "" then
        ( blocks, currentBlock )

    else if line == separator then
        ( currentBlock :: blocks, [] )

    else
        ( blocks, currentBlock ++ [ line ] )


findNotes :
    List String
    -> List ( List String, String )
    -> List ( List String, String )
findNotes block acc =
    case block of
        [ text, meta, _ ] ->
            if text == limitNotice then
                acc

            else if isNote meta then
                case acc of
                    [ ( x, _ ) ] ->
                        [ ( x, text ) ]

                    ( x, _ ) :: xs ->
                        ( x, text ) :: xs

                    _ ->
                        acc

            else
                ( block, "" ) :: acc

        _ ->
            acc


isNote : String -> Bool
isNote =
    startsWith "- Your Note on Page "


limitNotice : String
limitNotice =
    " <You have reached the clipping limit for this item>"


titleAuthorRx : Regex
titleAuthorRx =
    rx "(.+) \\((.+)\\)"


pageRx : Regex
pageRx =
    rx_ " on page (\\d+)"


dateRx : Regex
dateRx =
    rx " \\| Added on \\w+, (\\w+) (\\d+), (\\d+) (\\d+):(\\d+):(\\d+) (\\w+)"


footnoteRx : Regex
footnoteRx =
    rx "([^\\s\\d]{2,})(\\d+)"


footnoteReplacer : Match -> String
footnoteReplacer match =
    String.concat <|
        map
            (\sub ->
                let
                    s =
                        withDefault "" sub
                in
                if all isDigit (String.toList s) then
                    ""

                else
                    s
            )
            match.submatches


apostropheRx : Regex
apostropheRx =
    rx "(\\w)(')(\\w)"


apostropheReplacer : Match -> String
apostropheReplacer match =
    String.concat <|
        map
            (\sub ->
                let
                    s =
                        withDefault "" sub
                in
                if s == "'" then
                    "’"

                else
                    s
            )
            match.submatches


replaceApostrophes : String -> String
replaceApostrophes =
    replace apostropheRx apostropheReplacer


makeDicts : List ( List String, String ) -> ( EntryMap, BookMap )
makeDicts =
    foldr
        (\( raw, notes ) ( entries, books ) ->
            let
                noOp =
                    ( entries, books )
            in
            case raw of
                [ text, meta, titleAuthor ] ->
                    let
                        pair =
                            (if right 1 titleAuthor == ")" then
                                Regex.find titleAuthorRx titleAuthor
                                    |> map .submatches
                                    |> head
                                    |> withDefault []
                                    |> map (withDefault "")

                             else
                                split "-" titleAuthor
                            )
                                |> map trim

                        page =
                            Regex.find pageRx meta
                                |> head
                                |> Maybe.map .submatches
                                |> andThen head
                                |> andThen identity
                                |> andThen toInt

                        dateRaw =
                            case
                                Regex.find dateRx meta
                                    |> head
                                    |> Maybe.map .submatches
                            of
                                Just [ Just month, Just dayRaw, Just yearRaw, Just hourRaw, Just minuteRaw, Just secondRaw, Just meridian ] ->
                                    case [ toInt yearRaw, toInt dayRaw, toInt hourRaw, toInt minuteRaw, toInt secondRaw ] of
                                        [ Just year, Just day, Just hour, Just minute, Just second ] ->
                                            fromRawParts
                                                { day = day
                                                , month =
                                                    case month of
                                                        "January" ->
                                                            Jan

                                                        "February" ->
                                                            Feb

                                                        "March" ->
                                                            Mar

                                                        "April" ->
                                                            Apr

                                                        "May" ->
                                                            May

                                                        "June" ->
                                                            Jun

                                                        "July" ->
                                                            Jul

                                                        "August" ->
                                                            Aug

                                                        "September" ->
                                                            Sep

                                                        "October" ->
                                                            Oct

                                                        "November" ->
                                                            Nov

                                                        _ ->
                                                            Dec
                                                , year = year
                                                }
                                                { hours =
                                                    hour
                                                        + (if meridian == "AM" then
                                                            0

                                                           else if hour < 12 then
                                                            12

                                                           else
                                                            0
                                                          )
                                                , minutes = minute
                                                , seconds = second
                                                , milliseconds = 0
                                                }
                                                |> Maybe.map
                                                    (toPosix >> posixToMillis)

                                        _ ->
                                            Just 0

                                _ ->
                                    Just 0
                    in
                    case pair of
                        [ titleRaw, authorRaw ] ->
                            let
                                id =
                                    hashId <| text ++ meta

                                title =
                                    replaceApostrophes titleRaw

                                author =
                                    replaceApostrophes authorRaw

                                bookId =
                                    hashId <| title ++ " " ++ author

                                date =
                                    withDefault 0 dateRaw
                            in
                            ( insert
                                id
                                { id = id
                                , text = replace footnoteRx footnoteReplacer text
                                , bookId = bookId
                                , date = date
                                , page = withDefault -1 page
                                , notes = notes
                                }
                                entries
                            , update bookId
                                (\mBook ->
                                    Just <|
                                        case mBook of
                                            Just book ->
                                                { book
                                                    | sortIndex =
                                                        max
                                                            book.sortIndex
                                                            date
                                                }

                                            _ ->
                                                { id = bookId
                                                , title = title
                                                , author = author
                                                , count = 0
                                                , rating = 0
                                                , sortIndex = date
                                                , tags = []
                                                , slug = ""
                                                }
                                )
                                books
                            )

                        _ ->
                            noOp

                _ ->
                    noOp
        )
        ( Dict.empty, Dict.empty )


getTitleRouteMap : List Book -> ( Dict String Id, List Book )
getTitleRouteMap =
    sortBy .sortIndex
        >> reverse
        >> foldr
            (\book ( slugToId, newBooks ) ->
                let
                    slug =
                        case get (slugify book.title) slugToId of
                            Just _ ->
                                slugify (book.title ++ " by " ++ book.author)

                            _ ->
                                slugify book.title
                in
                ( insert slug book.id slugToId
                , { book | slug = slug } :: newBooks
                )
            )
            ( Dict.empty, [] )


getAuthorRouteMap : List Book -> Dict String Author
getAuthorRouteMap =
    map (juxt (.author >> slugify) .author) >> Dict.fromList
