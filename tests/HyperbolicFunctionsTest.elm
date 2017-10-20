module HyperbolicFunctionsTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Hyperbolic functions"
        [ test "Hyperbolic sine"
            (\_ ->
                let
                    ndaResult =
                        matrix Float32
                            [ [ 1, 2 ]
                            , [ 3, 4 ]
                            ]
                            |> Result.andThen
                                (\nda -> Ok (NumElm.sinh nda))
                in
                    case ndaResult of
                        Ok nda ->
                            nda
                                |> NumElm.dataToString
                                |> Expect.equal "[1.175201177597046,3.6268603801727295,10.017874717712402,27.2899169921875]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Inverse hyperbolic sine"
            (\_ ->
                let
                    ndaResult =
                        matrix Float32
                            [ [ 1, 2 ]
                            , [ 3, 4 ]
                            ]
                            |> Result.andThen
                                (\nda -> Ok (NumElm.asinh nda))
                in
                    case ndaResult of
                        Ok nda ->
                            nda
                                |> NumElm.dataToString
                                |> Expect.equal "[0.8813735842704773,1.4436354637145996,1.8184465169906616,2.094712495803833]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Hyperbolic cosine"
            (\_ ->
                let
                    ndaResult =
                        matrix Float32
                            [ [ 1, 2 ]
                            , [ 3, 4 ]
                            ]
                            |> Result.andThen
                                (\nda -> Ok (NumElm.cosh nda))
                in
                    case ndaResult of
                        Ok nda ->
                            nda
                                |> NumElm.dataToString
                                |> Expect.equal "[1.5430806875228882,3.762195587158203,10.067662239074707,27.3082332611084]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Inverse hyperbolic cosine"
            (\_ ->
                let
                    ndaResult =
                        matrix Float32
                            [ [ 1, 2 ]
                            , [ 3, 4 ]
                            ]
                            |> Result.andThen
                                (\nda -> Ok (NumElm.acosh nda))
                in
                    case ndaResult of
                        Ok nda ->
                            nda
                                |> NumElm.dataToString
                                |> Expect.equal "[0,1.316957950592041,1.7627471685409546,2.063436985015869]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Hyperbolic tangent"
            (\_ ->
                let
                    ndaResult =
                        matrix Float32
                            [ [ 1, 2 ]
                            , [ 3, 4 ]
                            ]
                            |> Result.andThen
                                (\nda -> Ok (NumElm.tanh nda))
                in
                    case ndaResult of
                        Ok nda ->
                            nda
                                |> NumElm.dataToString
                                |> Expect.equal "[0.7615941762924194,0.9640275835990906,0.9950547814369202,0.9993293285369873]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Inverse hyperbolic tangent"
            (\_ ->
                let
                    ndaResult =
                        matrix Float32
                            [ [ 0.1, 0.2 ]
                            , [ 0.3, 0.4 ]
                            ]
                            |> Result.andThen
                                (\nda -> Ok (NumElm.atanh nda))
                in
                    case ndaResult of
                        Ok nda ->
                            nda
                                |> NumElm.dataToString
                                |> Expect.equal "[0.10033535212278366,0.20273256301879883,0.30951961874961853,0.4236489236354828]"

                        Err msg ->
                            Expect.fail msg
            )
        ]
