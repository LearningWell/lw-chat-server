module Init exposing (init, subscriptions)

import WebSocket
import Types exposing (..)


init : ( Model, Cmd Msg )
init =
    { url = "wss://lw-chat-server.herokuapp.com/"
    , messagesAreaId = "chat-messages"
    , username = ""
    , chatMessage = ""
    , chatMessages = []
    }
        ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen model.url NewChatMessage
