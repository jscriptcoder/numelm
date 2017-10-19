module Main exposing (..)

import Html exposing (text)
import NumElm exposing (..)


main =
    let
        ndaResult =
            matrix Float32
                [ [ 0.1, 0.2 ]
                , [ 0.3, 0.4 ]
                ]
                |> Result.map (\nda -> NumElm.arctanh nda)
    in
        text <|
            case ndaResult of
                Ok nda ->
                    NumElm.dataToString nda

                Err msg ->
                    msg
