module Types exposing
    ( Author
    , Book
    , BookMap
    , BookSort(..)
    , Excerpt
    , ExcerptMap
    , ExcerptSort(..)
    , ExcerptTab(..)
    , Id
    , NeighborMap
    , Page(..)
    , PendingExcerpt
    , ScorePairs
    , SearchMode(..)
    , StoredModel
    , Tag
    , TagSort(..)
    , Title
    )

import Dict exposing (Dict)


type alias Id =
    String


type alias Title =
    String


type alias Author =
    String


type alias Tag =
    String


type alias ScorePairs =
    List ( Id, Float )


type alias Book =
    { id : Id
    , title : Title
    , authors : List Author
    , rating : Float
    , sortIndex : Int
    , tags : List Tag
    , slug : String
    }


type alias Excerpt =
    { id : Id
    , text : String
    , bookId : Id
    , date : Int
    , page : Int
    , notes : String
    , isFavorite : Bool
    , sourceUrl : Maybe String
    }


type alias PendingExcerpt =
    { title : Title
    , author : Author
    , text : String
    , page : Maybe Int
    , sourceUrl : String
    }


type alias ExcerptMap =
    Dict Id Excerpt


type alias BookMap =
    Dict Id Book


type alias NeighborMap =
    Dict Id ScorePairs


type alias StoredModel =
    { excerpts : List Excerpt
    , books : List Book
    , hiddenExcerpts : List Id
    , bookmarks : List ( Id, Id )
    }


type Page
    = MainPage (List Book) (Maybe Tag)
    | SearchPage String SearchMode (List Book) (List Excerpt) ScorePairs
    | TitlePage Book (List Excerpt) Bool
    | AuthorPage Author (List Book)
    | ExcerptPage Excerpt Book
    | NotFoundPage String
    | SettingsPage
    | LandingPage (List Book) (Dict Id Int) Bool
    | ImportPage
    | CreatePage PendingExcerpt (List Title) (List Author)


type BookSort
    = RecencySort
    | TitleSort
    | NumSort
    | RatingSort
    | FavSort


type ExcerptSort
    = ExcerptPageSort
    | ExcerptFavSort
    | ExcerptSemanticSort


type TagSort
    = TagAlphaSort
    | TagNumSort


type ExcerptTab
    = Related
    | Notes
    | Etc


type SearchMode
    = TextMatches
    | SemanticMatches
