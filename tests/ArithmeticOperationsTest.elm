module ArithmeticOperationsTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Arithmetic operations"
        [ test "Adding"
            (\_ ->
                let
                    nda1Result =
                        NumElm.ndarray Int8 [ 2, 2 ] [ 1, 2, 3, 4 ]

                    nda2Result =
                        NumElm.ndarray Int8 [ 2, 2 ] [ 5, 2, 9, 0 ]

                    ndaAddResult =
                        Result.map2
                            (\nd1 nd2 -> NumElm.add nd1 nd2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opAddResult -> Result.map Basics.identity opAddResult)
                in
                    case ndaAddResult of
                        Ok ndaAdd ->
                            NumElm.dataToString ndaAdd
                                |> Expect.equal "[6,4,12,4]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Adding incompatible shapes"
            (\_ ->
                let
                    nda1Result =
                        NumElm.ndarray Int8 [ 2, 3 ] [ 1, 2, 3, 4, 5, 6 ]

                    nda2Result =
                        NumElm.ndarray Int8 [ 2, 2 ] [ 5, 2, 9, 0 ]

                    ndaAddResult =
                        Result.map2
                            (\nd1 nd2 -> NumElm.add nd1 nd2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opAddResult -> Result.map Basics.identity opAddResult)
                in
                    case ndaAddResult of
                        Ok ndaAdd ->
                            Expect.fail "This should not happen"

                        Err msg ->
                            msg
                                |> Expect.equal "NdArray#elementWise - Incompatible shapes: The shape of nda1 is 2×3, but nda2 says 2×2"
            )
        , test "Scalar addition"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Int8 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| nda .+ 5

                            Err msg ->
                                msg
                in
                    Expect.equal strdata "[6,7,8,9,10,11]"
            )
        , test "Substracting"
            (\_ ->
                let
                    nda1Result =
                        NumElm.ndarray Int8 [ 2, 2 ] [ 1, 2, 3, 4 ]

                    nda2Result =
                        NumElm.ndarray Int8 [ 2, 2 ] [ 5, 2, 9, 0 ]

                    ndaAddResult =
                        Result.map2
                            (\nd1 nd2 -> NumElm.sub nd1 nd2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opAddResult -> Result.map Basics.identity opAddResult)
                in
                    case ndaAddResult of
                        Ok ndaAdd ->
                            NumElm.dataToString ndaAdd
                                |> Expect.equal "[-4,0,-6,4]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Scalar substraction"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Int8 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| nda .- 3

                            Err msg ->
                                msg
                in
                    Expect.equal strdata "[-2,-1,0,1,2,3]"
            )
        , test "Multiplication"
            (\_ ->
                let
                    nda1Result =
                        NumElm.ndarray Int8 [ 2, 2 ] [ 1, 2, 3, 4 ]

                    nda2Result =
                        NumElm.ndarray Int8 [ 2, 2 ] [ 5, 2, 9, 0 ]

                    ndaAddResult =
                        Result.map2
                            (\nd1 nd2 -> NumElm.mul nd1 nd2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opAddResult -> Result.map Basics.identity opAddResult)
                in
                    case ndaAddResult of
                        Ok ndaAdd ->
                            NumElm.dataToString ndaAdd
                                |> Expect.equal "[5,4,27,0]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Scalar multiplication"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Int8 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| nda .* 2

                            Err msg ->
                                msg
                in
                    Expect.equal strdata "[2,4,6,8,10,12]"
            )
        , test "Division"
            (\_ ->
                let
                    nda1Result =
                        NumElm.ndarray Float32 [ 2, 2 ] [ 1, 2, 3, 4 ]

                    nda2Result =
                        NumElm.ndarray Float32 [ 2, 2 ] [ 5, 2, 9, 0 ]

                    ndaAddResult =
                        Result.map2
                            (\nd1 nd2 -> NumElm.div nd1 nd2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opAddResult -> Result.map Basics.identity opAddResult)
                in
                    case ndaAddResult of
                        Ok ndaAdd ->
                            NumElm.dataToString ndaAdd
                                |> Expect.equal "[0.20000000298023224,1,0.3333333432674408,Infinity]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Scalar division"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Float32 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| nda ./ 3

                            Err msg ->
                                msg
                in
                    strdata
                        |> Expect.equal "[0.3333333432674408,0.6666666865348816,1,1.3333333730697632,1.6666666269302368,2]"
            )
        , test "Power"
            (\_ ->
                let
                    nda1Result =
                        NumElm.ndarray Float32 [ 2, 2 ] [ 1, 2, 3, 4 ]

                    nda2Result =
                        NumElm.ndarray Float32 [ 2, 2 ] [ 2, 2, 2, 3 ]

                    ndaAddResult =
                        Result.map2
                            (\nd1 nd2 -> NumElm.power nd1 nd2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opAddResult -> Result.map Basics.identity opAddResult)
                in
                    case ndaAddResult of
                        Ok ndaAdd ->
                            NumElm.dataToString ndaAdd
                                |> Expect.equal "[1,4,9,64]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Scalar power"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Float32 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| nda .^ 2

                            Err msg ->
                                msg
                in
                    Expect.equal strdata "[1,4,9,16,25,36]"
            )
        , test "Module"
            (\_ ->
                let
                    nda1Result =
                        NumElm.ndarray Int8 [ 2, 2 ] [ 1, 2, 9, 53 ]

                    nda2Result =
                        NumElm.ndarray Int8 [ 2, 2 ] [ 5, 2, 3, 3 ]

                    ndaModResult =
                        Result.map2
                            (\nd1 nd2 -> NumElm.mod nd1 nd2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opModResult -> Result.map Basics.identity opModResult)
                in
                    case ndaModResult of
                        Ok ndaMod ->
                            NumElm.dataToString ndaMod
                                |> Expect.equal "[1,0,0,2]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Scalar module"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Int8 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| nda .% 2

                            Err msg ->
                                msg
                in
                    Expect.equal strdata "[1,0,1,0,1,0]"
            )
        , test "Absolute"
            (\_ ->
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
                    Expect.equal strdata "[1.4,2,3,4,5.1,6]"
            )
        ]
