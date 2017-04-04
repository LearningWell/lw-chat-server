module Utils exposing (..)

import Html exposing (Attribute)
import Html.Events exposing (on, keyCode, targetValue)
import Date exposing (Date, hour, minute, second)
import Json.Decode as Json


notEmpty : String -> Bool
notEmpty string =
    (not << String.isEmpty << String.trim) string


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


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown msg =
    customOn "keydown" keyCode msg


onChange : (String -> msg) -> Attribute msg
onChange msg =
    customOn "change" targetValue msg


customOn : String -> Json.Decoder a -> (a -> msg) -> Attribute msg
customOn event decoder msg =
    on event <| Json.map msg decoder
