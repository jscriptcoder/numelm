module Main exposing (..)

import Html exposing (text)
import NumElm exposing (..)


main =
    let
        nda1Result =
            matrix Int16
                [ [ 1, 2, 3 ]
                , [ 3, 10, 5 ]
                ]

        nda2Result =
            matrix Int16
                [ [ 0, 2, 2 ]
                , [ 5, 4, 0 ]
                ]

        valResult =
            Result.map2
                (\nd1 nd2 -> NumElm.all nd1)
                nda1Result
                nda2Result
    in
        case valResult of
            Ok val ->
                Basics.toString val
                    |> text

            Err msg ->
                text msg
