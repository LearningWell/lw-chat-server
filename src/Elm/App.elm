module App exposing (main)

import Html
import Types exposing (..)
import Init exposing (init, subscriptions)
import Update exposing (update)
import View exposing (view)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
