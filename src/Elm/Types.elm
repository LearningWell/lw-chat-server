module Types exposing (..)

import Date exposing (Date)


type Msg
    = NewChatMessage String
    | SetUsername String
    | SetChatMessage String
    | ChatMessageKeyDown Int
    | PostChatMessage


type alias ChatMessage =
    { date : Date
    , username : String
    , message : String
    }


type alias Model =
    { url : String
    , messagesAreaId : String
    , username : String
    , chatMessage : String
    , chatMessages : List ChatMessage
    }
