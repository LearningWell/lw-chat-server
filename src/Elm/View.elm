module View exposing (view)

import Html exposing (Html, main_, div, span, strong, input, button, br, select, option, text)
import Html.Attributes exposing (id, class, style, type_, value, placeholder, selected, disabled)
import Html.Events exposing (onClick, onInput)
import Types exposing (..)
import Utils exposing (notEmpty, formatTime, onKeyDown, onChange)


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
                [ div [ class "col-md-8" ]
                    [ usernameInput model.username ]
                , div [ class "col-md-4" ]
                    [ colorSelect model.userColor model.colors ]
                ]
            ]
        ]


usernameInput : String -> Html Msg
usernameInput username =
    div [ class "input-group" ]
        [ span [ class "input-group-addon" ] [ text "@" ]
        , input
            [ type_ "text"
            , class "form-control"
            , placeholder "Username"
            , onInput SetUsername
            , value username
            ]
            []
        ]


colorSelect : String -> List String -> Html Msg
colorSelect selectedColor colors =
    select
        [ class "form-control"
        , style (colorStyles selectedColor)
        , onChange SetUserColor
        ]
        (List.map (colorOption selectedColor) colors)


colorOption : String -> String -> Html Msg
colorOption selectedColor itemColor =
    option
        [ selected (selectedColor == itemColor)
        , class "color-option"
        , style (colorStyles itemColor)
        ]
        [ text itemColor ]


colorStyles : String -> List ( String, String )
colorStyles styleColor =
    [ ( "background-color", styleColor ), ( "color", styleColor ) ]


chatMessagesArea : String -> List ChatMessage -> Html Msg
chatMessagesArea areaId chatMessages =
    let
        formattedMessages =
            chatMessages
                |> List.map formatChatMessage
                |> List.intersperse [ br [] [] ]
                |> List.concat
    in
        div [ class "row" ]
            [ div [ class "col-md-12" ]
                [ div [ class "messages-outer" ]
                    [ div [ id areaId, class "messages-inner" ] formattedMessages ]
                ]
            ]


formatChatMessage : ChatMessage -> List (Html a)
formatChatMessage chatMessage =
    [ text <| "[" ++ (formatTime chatMessage.date) ++ "] "
    , strong [ style [ ( "color", chatMessage.userColor ) ] ] [ text <| chatMessage.username ++ ": " ]
    , text chatMessage.message
    ]


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
    notEmpty model.username


canSendChatMessage : Model -> Bool
canSendChatMessage model =
    canChangeChatMessage model && notEmpty model.chatMessage
