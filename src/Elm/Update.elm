module Update exposing (update)

import Date exposing (Date, fromTime)
import Json.Decode as Decode
import Json.Encode as Encode
import WebSocket
import Types exposing (..)
import Ports exposing (scrollToBottom)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewChatMessage message ->
            case Decode.decodeString decodeChatMessage message of
                Ok decodedChatMessage ->
                    ( { model | chatMessages = model.chatMessages ++ [ decodedChatMessage ] }, scrollToBottom model.messagesAreaId )

                Err _ ->
                    model ! []

        SetUsername username ->
            { model | username = String.trim username } ! []

        SetChatMessage chatMessage ->
            { model | chatMessage = chatMessage } ! []

        ChatMessageKeyDown key ->
            case key of
                13 ->
                    sendChatMessage model

                _ ->
                    model ! []

        PostChatMessage ->
            sendChatMessage model


sendChatMessage : Model -> ( Model, Cmd Msg )
sendChatMessage model =
    if ((not << String.isEmpty << String.trim) model.chatMessage) then
        let
            encodedMessage =
                encodeChatMessage model.username model.chatMessage |> Encode.encode 0
        in
            ( { model | chatMessage = "" }, WebSocket.send model.url encodedMessage )
    else
        model ! []


decodeChatMessage : Decode.Decoder ChatMessage
decodeChatMessage =
    Decode.map3 ChatMessage (Decode.field "time" (Decode.float |> Decode.map fromTime)) (Decode.field "username" Decode.string) (Decode.field "message" Decode.string)


encodeChatMessage : String -> String -> Encode.Value
encodeChatMessage username chatMessage =
    Encode.object
        [ ( "username", Encode.string username )
        , ( "message", Encode.string chatMessage )
        ]
