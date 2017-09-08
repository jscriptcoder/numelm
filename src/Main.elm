module Main exposing (..)

import Html exposing (text)
import NumElm exposing (..)


main =
    text <| toString <| ndarray [ 1, 2, 3, 4 ] [ 2, 2 ] Int8
