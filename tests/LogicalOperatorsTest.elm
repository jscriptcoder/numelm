module LogicalOperatorsTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Logical operators"
        [ test "And"
            (\_ ->
                let
                    nda1Result =
                        matrix Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 0, 5 ]
                            ]

                    nda2Result =
                        matrix Int16
                            [ [ 0, 2, 2 ]
                            , [ 5, 4, 0 ]
                            ]

                    ndaAndResult =
                        Result.map2
                            (\nda1 nda2 -> NumElm.and nda1 nda2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opAndResult -> Result.map Basics.identity opAndResult)
                in
                    case ndaAndResult of
                        Ok ndaAnd ->
                            ndaAnd
                                |> NumElm.dataToString
                                |> Expect.equal "[0,1,1,1,0,0]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Or"
            (\_ ->
                let
                    nda1Result =
                        matrix Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 0, 5 ]
                            ]

                    nda2Result =
                        matrix Int16
                            [ [ 0, 2, 2 ]
                            , [ 5, 0, 0 ]
                            ]

                    ndaOrResult =
                        Result.map2
                            (\nda1 nda2 -> NumElm.or nda1 nda2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opOrResult -> Result.map Basics.identity opOrResult)
                in
                    case ndaOrResult of
                        Ok ndaOr ->
                            ndaOr
                                |> NumElm.dataToString
                                |> Expect.equal "[1,1,1,1,0,1]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Not"
            (\_ ->
                let
                    ndaResult =
                        matrix Int16
                            [ [ 1, 2, 0 ]
                            , [ 3, 0, 5 ]
                            ]

                    ndaNotResult =
                        Result.map
                            (\nda -> NumElm.not nda)
                            ndaResult
                in
                    case ndaNotResult of
                        Ok ndaNot ->
                            ndaNot
                                |> NumElm.dataToString
                                |> Expect.equal "[0,0,1,0,1,0]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Xor"
            (\_ ->
                let
                    nda1Result =
                        matrix Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 0, 5 ]
                            ]

                    nda2Result =
                        matrix Int16
                            [ [ 0, 2, 2 ]
                            , [ 5, 0, 0 ]
                            ]

                    ndaXorResult =
                        Result.map2
                            (\nda1 nda2 -> NumElm.xor nda1 nda2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opXorResult -> Result.map Basics.identity opXorResult)
                in
                    case ndaXorResult of
                        Ok ndaXor ->
                            ndaXor
                                |> NumElm.dataToString
                                |> Expect.equal "[1,0,0,0,0,1]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Any True"
            (\_ ->
                let
                    ndaResult =
                        matrix Int16
                            [ [ 1, 2, 0 ]
                            , [ 3, 0, 5 ]
                            ]

                    anyResult =
                        Result.map
                            (\nda -> NumElm.any nda)
                            ndaResult
                in
                    case anyResult of
                        Ok any ->
                            Expect.equal any True

                        Err msg ->
                            Expect.fail msg
            )
        , test "Any False"
            (\_ ->
                let
                    ndaResult =
                        NumElm.zeros Int8 [ 4, 4 ]

                    anyResult =
                        Result.map
                            (\nda -> NumElm.any nda)
                            ndaResult
                in
                    case anyResult of
                        Ok any ->
                            Expect.equal any False

                        Err msg ->
                            Expect.fail msg
            )
        , test "All True"
            (\_ ->
                let
                    ndaResult =
                        matrix Int16
                            [ [ 1, 2, 2 ]
                            , [ 3, 8, 5 ]
                            ]

                    allResult =
                        Result.map
                            (\nda -> NumElm.all nda)
                            ndaResult
                in
                    case allResult of
                        Ok all ->
                            Expect.equal all True

                        Err msg ->
                            Expect.fail msg
            )
        , test "All False"
            (\_ ->
                let
                    ndaResult =
                        matrix Int16
                            [ [ 1, 2, 2 ]
                            , [ 3, 0, 5 ]
                            ]

                    allResult =
                        Result.map
                            (\nda -> NumElm.all nda)
                            ndaResult
                in
                    case allResult of
                        Ok all ->
                            Expect.equal all False

                        Err msg ->
                            Expect.fail msg
            )
        ]
