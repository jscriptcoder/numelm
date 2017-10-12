module Main exposing (..)

import Html exposing (text)
import NumElm exposing (..)


main =
    let
        nda1Result =
            NumElm.matrix
                Int8
                [ [ 1, 4 ]
                , [ 2, 5 ]
                , [ 3, 6 ]
                ]

        -- |> Result.map (\nda1 -> NumElm.trans nda1)
        nda2Result =
            NumElm.matrix
                Int8
                [ [ 7, 8, 9 ]
                ]
                |> Result.map (\nda2 -> NumElm.trans nda2)

        strdataResult =
            Result.map2
                (\nda1 nda2 ->
                    let
                        concatResult =
                            NumElm.concatenateAxis 1 nda1 nda2
                    in
                        case concatResult of
                            Ok concat ->
                                NumElm.dataToString concat

                            Err msg ->
                                msg
                )
                nda1Result
                nda2Result
    in
        text <|
            case strdataResult of
                Ok strdata ->
                    strdata

                Err msg ->
                    msg
