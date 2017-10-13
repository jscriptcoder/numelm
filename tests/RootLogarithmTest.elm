module RootLogarithmTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Root and Logarithm"
        [ test "Square root"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Float32 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| NumElm.sqrt nda

                            Err msg ->
                                msg
                in
                    strdata
                        |> Expect.equal "[1,1.4142135381698608,1.7320507764816284,2,2.2360680103302,2.4494898319244385]"
            )
        , test "Logarithm with base"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Float32 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| NumElm.logBase 3 nda

                            Err msg ->
                                msg
                in
                    strdata
                        |> Expect.equal "[0,0.6309297680854797,1,1.2618595361709595,1.4649735689163208,1.630929708480835]"
            )
        , test "Logarithm"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Float32 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| NumElm.log nda

                            Err msg ->
                                msg
                in
                    strdata
                        |> Expect.equal "[0,0.6931471824645996,1.0986123085021973,1.3862943649291992,1.6094379425048828,1.7917594909667969]"
            )
        , test "Logarithm base 2"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Float32 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| NumElm.log2 nda

                            Err msg ->
                                msg
                in
                    strdata
                        |> Expect.equal "[0,1,1.5849624872207642,2,2.321928024291992,2.5849626064300537]"
            )
        , test "Logarithm base 10"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Float32 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| NumElm.log10 nda

                            Err msg ->
                                msg
                in
                    strdata
                        |> Expect.equal "[0,0.3010300099849701,0.4771212637424469,0.6020600199699402,0.6989700198173523,0.778151273727417]"
            )
        , test "Exponential"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Float32 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <| NumElm.exp nda

                            Err msg ->
                                msg
                in
                    strdata
                        |> Expect.equal "[2.7182817459106445,7.389056205749512,20.08553695678711,54.598148345947266,148.4131622314453,403.4288024902344]"
            )
        , test "Logarithm and exponential"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Float32 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strdata =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString <|
                                    NumElm.map (\val _ _ -> Basics.round val) <|
                                        NumElm.log <|
                                            NumElm.exp nda

                            Err msg ->
                                msg
                in
                    Expect.equal strdata "[1,2,3,4,5,6]"
            )
        ]
