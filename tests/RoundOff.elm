module RoundOff exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Round off"
        [ test "Around"
            (\_ ->
                let
                    matrixResult =
                        matrix Float64
                            [ [ 1.4564, -2.1271 ]
                            , [ -3.6544, 4.3221 ]
                            ]
                            |> Result.map (\matrix -> NumElm.around 2 matrix)
                in
                    case matrixResult of
                        Ok matrix ->
                            NumElm.dataToString matrix
                                |> Expect.equal "[1.46,-2.13,-3.65,4.32]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Ceil"
            (\_ ->
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
                                |> Expect.equal "[2,-2,-3,5]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Floor"
            (\_ ->
                let
                    matrixResult =
                        matrix Float32
                            [ [ 1.4564, -2.1271 ]
                            , [ -3.6544, 4.3221 ]
                            ]
                            |> Result.map (\matrix -> NumElm.floor matrix)
                in
                    case matrixResult of
                        Ok matrix ->
                            NumElm.dataToString matrix
                                |> Expect.equal "[1,-3,-4,4]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Trunc"
            (\_ ->
                let
                    matrixResult =
                        matrix Float32
                            [ [ 1.4564, -2.1271 ]
                            , [ -3.6544, 4.3221 ]
                            ]
                            |> Result.map (\matrix -> NumElm.trunc matrix)
                in
                    case matrixResult of
                        Ok matrix ->
                            NumElm.dataToString matrix
                                |> Expect.equal "[1,-2,-3,4]"

                        Err msg ->
                            Expect.fail msg
            )
        ]
