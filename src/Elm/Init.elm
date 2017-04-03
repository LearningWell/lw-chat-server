module Init exposing (init, subscriptions)

import WebSocket
import Types exposing (..)


init : ( Model, Cmd Msg )
init =
    { url = "wss://lw-chat-server.herokuapp.com/"
    , messagesAreaId = "chat-messages"
    , colors = getUserColors
    , username = ""
    , userColor = "#000000"
    , chatMessage = ""
    , chatMessages = []
    }
        ! []


getUserColors : List String
getUserColors =
    [ "#000000", "#ff0000", "#0040ff", "#e6e600", "#ff8000", "#ffbf00", "#808080", "#009933", "#00e64d", "#00ff55", "invalid" ]


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen model.url NewChatMessage
