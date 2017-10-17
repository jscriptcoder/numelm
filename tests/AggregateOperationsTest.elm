module AggregateOperationsTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Aggregate operations"
        [ test "Max value"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix3d Int16
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

                    maxResult =
                        Result.map
                            (\nda -> NumElm.max nda)
                            ndaResult

                    max =
                        Result.withDefault 0 maxResult
                in
                    Expect.equal max 15
            )
        , test "Max value on axis"
            (\_ ->
                let
                    ndaMaxDataResult =
                        NumElm.matrix3d Int16
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
                            |> Result.andThen
                                (\nda -> NumElm.maxAxis 1 nda)
                            |> Result.andThen
                                (\ndaMax -> Ok (NumElm.dataToString ndaMax))
                in
                    case ndaMaxDataResult of
                        Ok ndaMaxData ->
                            Expect.equal ndaMaxData "[3,3,10,12,5,15]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Min value"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix3d Int16
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

                    minResult =
                        Result.map
                            (\nda -> NumElm.min nda)
                            ndaResult

                    min =
                        Result.withDefault 0 minResult
                in
                    Expect.equal min -8
            )
        , test "Min value on axis"
            (\_ ->
                let
                    ndaMinDataResult =
                        NumElm.matrix3d Int16
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
                            |> Result.andThen
                                (\nda -> NumElm.minAxis 0 nda)
                            |> Result.andThen
                                (\ndaMin -> Ok (NumElm.dataToString ndaMin))
                in
                    case ndaMinDataResult of
                        Ok ndaMinData ->
                            Expect.equal ndaMinData "[0,-6,-6,3,-8,-7]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Total sum"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix3d Int16
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

                    sumResult =
                        Result.map
                            (\nda -> NumElm.sum nda)
                            ndaResult

                    sum =
                        Result.withDefault 0 sumResult
                in
                    Expect.equal sum 35
            )
        , test "Total sum on axis"
            (\_ ->
                let
                    ndaSumDataResult =
                        NumElm.matrix3d Int16
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
                            |> Result.andThen
                                (\nda -> NumElm.sumAxis 2 nda)
                            |> Result.andThen
                                (\ndaSum -> Ok (NumElm.dataToString ndaSum))
                in
                    case ndaSumDataResult of
                        Ok ndaSumData ->
                            Expect.equal ndaSumData "[-1,-3,-4,4,9,-1,3,16,12]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Total sum with error"
            (\_ ->
                let
                    ndaSumDataResult =
                        NumElm.ndarray
                            Int16
                            [ 3 ]
                            [ 1, 2, 3 ]
                            |> Result.andThen
                                (\nda -> NumElm.sumAxis 2 nda)
                            |> Result.andThen
                                (\ndaSum -> Ok (NumElm.dataToString ndaSum))
                in
                    case ndaSumDataResult of
                        Ok ndaSumData ->
                            Expect.fail "This should not happen"

                        Err msg ->
                            msg
                                |> Expect.equal "NdArray#mapAxis - Axis does not exist: The shape of nda is 3×1, trying to loop along axis 2"
            )
        ]
