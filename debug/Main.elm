module Main exposing (..)

import Html exposing (text)
import NumElm exposing (..)


main =
    let
        ndaResult =
            NumElm.matrix
                Float64
                [ [ -1.4, 2 ]
                , [ 3, -4 ]
                , [ 5.1, -6 ]
                ]

        strdata =
            case ndaResult of
                Ok nda ->
                    NumElm.abs nda
                        |> NumElm.dataToString

                Err msg ->
                    msg
    in
        text strdata
