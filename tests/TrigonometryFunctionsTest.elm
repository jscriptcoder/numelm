module TrigonometryFunctionsTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Trigonometry functions"
        [ test "Sine"
            (\_ ->
                let
                    ndaResult =
                        matrix Float32
                            [ [ 1, 2 ]
                            , [ 3, 4 ]
                            ]
                            |> Result.andThen
                                (\nda -> Ok (NumElm.sin nda))
                in
                    case ndaResult of
                        Ok nda ->
                            nda
                                |> NumElm.dataToString
                                |> Expect.equal "[0.8414709568023682,0.9092974066734314,0.14112000167369843,-0.756802499294281]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Inverse sine"
            (\_ ->
                let
                    ndaResult =
                        matrix Float32
                            [ [ 0.1, 0.5 ]
                            , [ 0.8, 1 ]
                            ]
                            |> Result.andThen
                                (\nda -> Ok (NumElm.asin nda))
                in
                    case ndaResult of
                        Ok nda ->
                            nda
                                |> NumElm.dataToString
                                |> Expect.equal "[0.1001674234867096,0.5235987901687622,0.9272952675819397,1.5707963705062866]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Cosine"
            (\_ ->
                let
                    ndaResult =
                        matrix Float32
                            [ [ 1, 2 ]
                            , [ 3, 4 ]
                            ]
                            |> Result.andThen
                                (\nda -> Ok (NumElm.cos nda))
                in
                    case ndaResult of
                        Ok nda ->
                            nda
                                |> NumElm.dataToString
                                |> Expect.equal "[0.5403022766113281,-0.416146844625473,-0.9899924993515015,-0.6536436080932617]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Inverse cosine"
            (\_ ->
                let
                    ndaResult =
                        matrix Float32
                            [ [ 0.1, 0.5 ]
                            , [ 0.8, 1 ]
                            ]
                            |> Result.andThen
                                (\nda -> Ok (NumElm.acos nda))
                in
                    case ndaResult of
                        Ok nda ->
                            nda
                                |> NumElm.dataToString
                                |> Expect.equal "[1.4706288576126099,1.0471975803375244,0.6435011029243469,0]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Tangent"
            (\_ ->
                let
                    ndaResult =
                        matrix Float32
                            [ [ 1, 2 ]
                            , [ 3, 4 ]
                            ]
                            |> Result.andThen
                                (\nda -> Ok (NumElm.tan nda))
                in
                    case ndaResult of
                        Ok nda ->
                            nda
                                |> NumElm.dataToString
                                |> Expect.equal "[1.5574077367782593,-2.185039758682251,-0.14254654943943024,1.1578212976455688]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Inverse tangent"
            (\_ ->
                let
                    ndaResult =
                        matrix Float32
                            [ [ 0.1, 0.5 ]
                            , [ 0.8, 1 ]
                            ]
                            |> Result.andThen
                                (\nda -> Ok (NumElm.atan nda))
                in
                    case ndaResult of
                        Ok nda ->
                            nda
                                |> NumElm.dataToString
                                |> Expect.equal "[0.09966865181922913,0.46364760398864746,0.6747409701347351,0.7853981852531433]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Arc tangent of nda1/nda2"
            (\_ ->
                let
                    nda1Result =
                        matrix Float32
                            [ [ 9, 2 ]
                            , [ 7, 4 ]
                            ]

                    nda2Result =
                        matrix Float32
                            [ [ 3, 8 ]
                            , [ 4, 6 ]
                            ]

                    ndaAtan2Result =
                        Result.map2
                            (\nda1 nda2 -> NumElm.atan2 nda1 nda2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\fAtan2Result -> Result.map Basics.identity fAtan2Result)
                in
                    case ndaAtan2Result of
                        Ok ndaAtan2 ->
                            ndaAtan2
                                |> NumElm.dataToString
                                |> Expect.equal "[1.249045729637146,0.244978666305542,1.0516501665115356,0.588002622127533]"

                        Err msg ->
                            Expect.fail msg
            )
        ]
