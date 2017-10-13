module Main exposing (..)

import Html exposing (text)
import NumElm exposing (..)


main =
    let
        strdataResult =
            NumElm.matrix3d
                Int8
                [ [ [ 1, 2 ]
                  , [ 3, 4 ]
                  ]
                , [ [ 5, 6 ]
                  , [ 7, 8 ]
                  ]
                , [ [ 9, 10 ]
                  , [ 11, 12 ]
                  ]
                ]
                |> Result.map (\matrix -> NumElm.trans matrix)
                |> Result.andThen (\matrixT -> Ok (NumElm.dataToString matrixT))
    in
        text <|
            case strdataResult of
                Ok strdata ->
                    strdata

                Err msg ->
                    msg
