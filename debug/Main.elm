module Main exposing (..)

import Html exposing (text)
import NumElm exposing (..)


main =
    let
        valResult =
            matrix3d
                Int16
                [ [ [ 1, -2 ]
                  , [ -6, 3 ]
                  , [ 3, -7 ]
                  ]
                , [ [ 10, -6 ]
                  , [ -3, 12 ]
                  , [ -8, 7 ]
                  ]
                , [ [ 0, 3 ]
                  , [ 1, 15 ]
                  , [ 5, 7 ]
                  ]
                ]
                --|> Result.map (\nda -> NumElm.sum nda)
                |>
                    Result.andThen (\nda -> NumElm.sumAxis 2 nda)
                |> Result.map Basics.identity
    in
        case valResult of
            Ok val ->
                val
                    --|> Basics.toString
                    |>
                        NumElm.dataToString
                    --|> NumElm.toString
                    |>
                        text

            Err msg ->
                text msg
