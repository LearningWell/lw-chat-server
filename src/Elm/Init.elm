module Init exposing (init, subscriptions)

import Types exposing (..)


init : ( Model, Cmd Msg )
init =
    {} ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
