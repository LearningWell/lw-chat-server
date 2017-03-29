module View exposing (view)

import Html exposing (Html, main_, div, span, input, button, textarea, text)
import Html.Attributes exposing (id, class, type_, value, placeholder, disabled, rows)
import Html.Events exposing (on, keyCode, onClick, onInput)
import Json.Decode as Json
import Date exposing (Date, hour, minute, second)
import Types exposing (..)


view : Model -> Html Msg
view model =
    main_ [ class "container" ]
        [ topBar model
        , chatMessagesArea model.messagesAreaId model.chatMessages
        , chatMessageBar model
        ]


topBar : Model -> Html Msg
topBar model =
    div [ class "navbar navbar-default" ]
        [ div [ class "container-fluid" ]
            [ div [ class "navbar-header" ]
                [ span [ class "navbar-brand" ] [ text "LearningWell Chat" ] ]
            , div [ class "navbar-form navbar-right" ]
                [ div [ class "input-group" ]
                    [ span [ class "input-group-addon" ] [ text "@" ]
                    , input
                        [ type_ "text"
                        , class "form-control"
                        , placeholder "Username"
                        , onInput SetUsername
                        , value model.username
                        ]
                        []
                    ]
                ]
            ]
        ]


chatMessagesArea : String -> List ChatMessage -> Html Msg
chatMessagesArea areaId chatMessages =
    let
        formattedMessages =
            chatMessages
                |> List.map formatChatMessage
                |> List.intersperse "\x0D"
                |> String.concat
    in
        div [ class "row" ]
            [ div [ class "col-md-12" ]
                [ div [ class "form-group" ]
                    [ textarea
                        [ id areaId
                        , class "form-control"
                        , disabled True
                        , rows 20
                        , value formattedMessages
                        ]
                        []
                    ]
                ]
            ]


formatChatMessage : ChatMessage -> String
formatChatMessage chatMessage =
    "[" ++ (formatTime chatMessage.date) ++ "] " ++ chatMessage.username ++ ": " ++ chatMessage.message


chatMessageBar : Model -> Html Msg
chatMessageBar model =
    div [ class "row" ]
        [ div [ class "col-md-12" ]
            [ div [ class "input-group" ]
                [ span [ class "input-group-addon" ] [ text ">" ]
                , input
                    [ type_ "text"
                    , class "form-control"
                    , placeholder "Message"
                    , disabled (not <| canChangeChatMessage model)
                    , onInput SetChatMessage
                    , onKeyDown ChatMessageKeyDown
                    , value model.chatMessage
                    ]
                    []
                , div [ class "input-group-btn" ]
                    [ button
                        [ class "btn btn-default"
                        , disabled (not <| canSendChatMessage model)
                        ]
                        [ text "Spam" ]
                    ]
                ]
            ]
        ]


canChangeChatMessage : Model -> Bool
canChangeChatMessage model =
    (not << String.isEmpty) model.username


canSendChatMessage : Model -> Bool
canSendChatMessage model =
    canChangeChatMessage model && (not << String.isEmpty) model.chatMessage


onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown msg =
    on "keydown" (Json.map msg keyCode)


padNumber : number -> String
padNumber dateNumber =
    ((String.padLeft 2 '0') << toString) dateNumber


formatTime : Date -> String
formatTime date =
    (padNumber << hour) date
        ++ ":"
        ++ (padNumber << minute) date
        ++ ":"
        ++ (padNumber << second) date
