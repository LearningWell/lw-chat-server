module View exposing (view)

import Html exposing (Html, text)
import Types exposing (..)


view : Model -> Html Msg
view model =
    text "Yes, this is chat server?"
