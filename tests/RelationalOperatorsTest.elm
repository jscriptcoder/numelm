module RelationalOperatorsTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Relational operators"
        [ test "Equal"
            (\_ ->
                let
                    nda1Result =
                        matrix Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 4, 5 ]
                            ]

                    nda2Result =
                        matrix Int16
                            [ [ 2, 2, 2 ]
                            , [ 5, 4, 5 ]
                            ]

                    ndaEqResult =
                        Result.map2
                            (\nd1 nd2 -> NumElm.eq nd1 nd2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opEqResult -> Result.map Basics.identity opEqResult)
                in
                    case ndaEqResult of
                        Ok ndaEq ->
                            NumElm.dataToString ndaEq
                                |> Expect.equal "[0,1,0,0,1,1]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Scalar equal"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix
                            Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 4, 5 ]
                            ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| nda .== 3

                            Err msg ->
                                msg
                in
                    Expect.equal strdata "[0,0,1,1,0,0]"
            )
        , test "Less"
            (\_ ->
                let
                    nda1Result =
                        matrix Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 4, 5 ]
                            ]

                    nda2Result =
                        matrix Int16
                            [ [ 2, 2, 2 ]
                            , [ 5, 4, 5 ]
                            ]

                    ndaLtResult =
                        Result.map2
                            (\nd1 nd2 -> NumElm.lt nd1 nd2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opLtResult -> Result.map Basics.identity opLtResult)
                in
                    case ndaLtResult of
                        Ok ndaLt ->
                            NumElm.dataToString ndaLt
                                |> Expect.equal "[1,0,0,1,0,0]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Scalar less"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix
                            Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 4, 5 ]
                            ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| nda .< 3

                            Err msg ->
                                msg
                in
                    Expect.equal strdata "[1,1,0,0,0,0]"
            )
        , test "Greater"
            (\_ ->
                let
                    nda1Result =
                        matrix Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 4, 5 ]
                            ]

                    nda2Result =
                        matrix Int16
                            [ [ 2, 2, 2 ]
                            , [ 5, 4, 5 ]
                            ]

                    ndaGtResult =
                        Result.map2
                            (\nd1 nd2 -> NumElm.gt nd1 nd2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opGtResult -> Result.map Basics.identity opGtResult)
                in
                    case ndaGtResult of
                        Ok ndaGt ->
                            NumElm.dataToString ndaGt
                                |> Expect.equal "[0,0,1,0,0,0]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Scalar greater"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix
                            Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 4, 5 ]
                            ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| nda .> 3

                            Err msg ->
                                msg
                in
                    Expect.equal strdata "[0,0,0,0,1,1]"
            )
        , test "Less or equal"
            (\_ ->
                let
                    nda1Result =
                        matrix Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 4, 5 ]
                            ]

                    nda2Result =
                        matrix Int16
                            [ [ 2, 2, 2 ]
                            , [ 5, 4, 5 ]
                            ]

                    ndaLteResult =
                        Result.map2
                            (\nd1 nd2 -> NumElm.lte nd1 nd2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opLteResult -> Result.map Basics.identity opLteResult)
                in
                    case ndaLteResult of
                        Ok ndaLte ->
                            NumElm.dataToString ndaLte
                                |> Expect.equal "[1,1,0,1,1,1]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Scalar less or equal"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix
                            Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 4, 5 ]
                            ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| nda .<= 3

                            Err msg ->
                                msg
                in
                    Expect.equal strdata "[1,1,1,1,0,0]"
            )
        , test "Greater or equal"
            (\_ ->
                let
                    nda1Result =
                        matrix Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 4, 5 ]
                            ]

                    nda2Result =
                        matrix Int16
                            [ [ 2, 2, 2 ]
                            , [ 5, 4, 5 ]
                            ]

                    ndaGteResult =
                        Result.map2
                            (\nd1 nd2 -> NumElm.gte nd1 nd2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opGteResult -> Result.map Basics.identity opGteResult)
                in
                    case ndaGteResult of
                        Ok ndaGte ->
                            NumElm.dataToString ndaGte
                                |> Expect.equal "[0,1,1,0,1,1]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Scalar greater or equal"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix
                            Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 4, 5 ]
                            ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| nda .>= 3

                            Err msg ->
                                msg
                in
                    Expect.equal strdata "[0,0,1,1,1,1]"
            )
        , test "Not equal"
            (\_ ->
                let
                    nda1Result =
                        matrix Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 4, 5 ]
                            ]

                    nda2Result =
                        matrix Int16
                            [ [ 2, 2, 2 ]
                            , [ 5, 4, 5 ]
                            ]

                    ndaNeqResult =
                        Result.map2
                            (\nd1 nd2 -> NumElm.neq nd1 nd2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opNeqResult -> Result.map Basics.identity opNeqResult)
                in
                    case ndaNeqResult of
                        Ok ndaNeq ->
                            NumElm.dataToString ndaNeq
                                |> Expect.equal "[1,0,1,1,0,0]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Scalar not equal"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix
                            Int16
                            [ [ 1, 2, 3 ]
                            , [ 3, 4, 5 ]
                            ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| nda ./= 3

                            Err msg ->
                                msg
                in
                    Expect.equal strdata "[1,1,0,0,1,1]"
            )
        ]
