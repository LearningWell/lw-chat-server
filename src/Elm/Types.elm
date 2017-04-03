module Types exposing (..)

import Date exposing (Date)


type Msg
    = NewChatMessage String
    | SetUsername String
    | SetUserColor String
    | SetChatMessage String
    | ChatMessageKeyDown Int
    | PostChatMessage


type alias ChatMessage =
    { date : Date
    , username : String
    , userColor : String
    , message : String
    }


type alias Model =
    { url : String
    , messagesAreaId : String
    , colors : List String
    , username : String
    , userColor : String
    , chatMessage : String
    , chatMessages : List ChatMessage
    }
