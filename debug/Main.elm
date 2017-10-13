module Main exposing (..)

import Html exposing (text)
import NumElm exposing (..)


main =
    let
        matrixResult =
            matrix Float32
                [ [ 1.4564, -2.1271 ]
                , [ -3.6544, 4.3221 ]
                ]
                |> Result.map (\matrix -> NumElm.ceil matrix)
    in
        case matrixResult of
            Ok matrix ->
                NumElm.dataToString matrix
                    |> text

            Err msg ->
                text msg
