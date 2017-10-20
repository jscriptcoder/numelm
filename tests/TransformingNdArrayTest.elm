module TransformingNdArrayTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Transforming NdArray"
        [ test "Map function"
            (\_ ->
                let
                    vecResult =
                        NumElm.vector Int8 [ 1, 2, 3 ]
                in
                    case vecResult of
                        Ok vec ->
                            let
                                vecPow2 =
                                    NumElm.map (\a _ _ -> a ^ 2) vec
                            in
                                Expect.equal "[1,4,9]" <| NumElm.dataToString vecPow2

                        Err msg ->
                            Expect.fail msg
            )
        , test "Transpose"
            (\_ ->
                let
                    matrixResult =
                        NumElm.matrix Float32 [ [ 1, 2, 3 ], [ 4, 5, 6 ] ]
                in
                    case matrixResult of
                        Ok matrix ->
                            let
                                matrixT =
                                    NumElm.transpose matrix

                                shapeT =
                                    NumElm.shape matrixT
                            in
                                Expect.equalLists shapeT [ 3, 2 ]

                        Err msg ->
                            Expect.fail msg
            )
        , test "Transpose 3D matrix"
            (\_ ->
                let
                    matrixResult =
                        NumElm.matrix3d
                            Int8
                            [ [ [ 1 ], [ 2 ], [ 3 ] ], [ [ 4 ], [ 5 ], [ 6 ] ] ]
                in
                    case matrixResult of
                        Ok matrix ->
                            let
                                matrixT =
                                    NumElm.transpose matrix

                                shapeT =
                                    NumElm.shape matrixT
                            in
                                {-
                                   shape matrix
                                       --> [2, 3, 1]

                                   shape <| transpose matrix
                                       --> [3, 2, 1]
                                -}
                                Expect.equalLists shapeT [ 3, 2, 1 ]

                        Err msg ->
                            Expect.fail msg
            )
        , test "More transposing"
            (\_ ->
                let
                    matrixResult =
                        NumElm.matrix Int8 [ [ 1, 2, 3 ], [ 4, 5, 6 ] ]
                in
                    case matrixResult of
                        Ok matrix ->
                            let
                                matrixT =
                                    NumElm.transpose matrix

                                strMatrix =
                                    NumElm.dataToString matrixT
                            in
                                {-
                                   matrix
                                       --> [ [ 1, 2, 3 ]
                                           , [ 4, 5, 6 ]
                                           ]

                                   transpose matrix
                                       --> [ [ 1, 4 ]
                                           , [ 2, 5 ]
                                           , [ 3, 6 ]
                                           ]
                                -}
                                Expect.equal strMatrix "[1,4,2,5,3,6]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Reshaping"
            (\_ ->
                let
                    ndaResult =
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
                            |> Result.andThen
                                (\nda -> NumElm.reshape [ 2, 6 ] nda)
                in
                    case ndaResult of
                        Ok nda ->
                            nda
                                |> NumElm.shape
                                |> Expect.equal [ 2, 6 ]

                        Err msg ->
                            Expect.fail msg
            )
        , test "More reshaping"
            (\_ ->
                let
                    ndaResult =
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
                            |> Result.andThen
                                (\nda -> NumElm.reshape [ 3, 4 ] nda)
                in
                    case ndaResult of
                        Ok nda ->
                            nda
                                |> NumElm.shape
                                |> Expect.equal [ 3, 4 ]

                        Err msg ->
                            Expect.fail msg
            )
        , test "Reshaping and dot product"
            (\_ ->
                let
                    ndaResult =
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

                    nda2x6Result =
                        Result.map
                            (\nda -> NumElm.reshape [ 2, 6 ] nda)
                            ndaResult
                            |> Result.andThen
                                (\resResult -> Result.map Basics.identity resResult)

                    nda6x2Result =
                        Result.map
                            (\nda -> NumElm.reshape [ 6, 2 ] nda)
                            ndaResult
                            |> Result.andThen
                                (\resResult -> Result.map Basics.identity resResult)

                    ndaDotResult =
                        Result.map2
                            (\nda2x6 nda6x2 -> NumElm.dot nda2x6 nda6x2)
                            nda2x6Result
                            nda6x2Result
                            |> Result.andThen
                                (\opDotResult -> Result.map Basics.identity opDotResult)
                in
                    case ndaDotResult of
                        Ok ndaDot ->
                            ndaDot
                                |> NumElm.shape
                                |> Expect.equal [ 2, 2 ]

                        Err msg ->
                            Expect.fail msg
            )
        , test "Calculate inverse"
            (\_ ->
                let
                    matrixResult =
                        NumElm.matrix Float32 [ [ 8, 1, 6 ], [ 3, 5, 7 ], [ 4, 9, 2 ] ]

                    matrixInvResult =
                        Result.map
                            (\matrix -> NumElm.inv matrix)
                            matrixResult
                            |> Result.andThen
                                (\opInvResult -> Result.map Basics.identity opInvResult)
                in
                    case matrixInvResult of
                        Ok matrixInv ->
                            NumElm.dataToString matrixInv
                                |> Expect.equal "[0.14722222089767456,-0.14444445073604584,0.06388888508081436,-0.06111111119389534,0.022222211584448814,0.10555555671453476,-0.01944444142282009,0.18888890743255615,-0.10277777910232544]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Inverse with wrong shape"
            (\_ ->
                let
                    matrixResult =
                        NumElm.matrix Float32 [ [ 2, 3, 7 ], [ 1, 3, 2 ] ]

                    matrixInvResult =
                        Result.map
                            (\matrix -> NumElm.inv matrix)
                            matrixResult
                            |> Result.andThen
                                (\opInvResult -> Result.map Basics.identity opInvResult)

                    errMsg =
                        case matrixInvResult of
                            Ok matrixInv ->
                                "Ok"

                            Err msg ->
                                msg
                in
                    errMsg
                        |> Expect.equal "NdArray#inverse - Wrong shape: NdArray must be square"
            )
        , test "Not inversable matrix"
            (\_ ->
                let
                    matrixResult =
                        NumElm.matrix Float32 [ [ 2, 3 ], [ 0, 0 ] ]

                    matrixInvResult =
                        Result.map
                            (\matrix -> NumElm.inv matrix)
                            matrixResult
                            |> Result.andThen
                                (\opInvResult -> Result.map Basics.identity opInvResult)

                    errMsg =
                        case matrixInvResult of
                            Ok matrixInv ->
                                "Ok"

                            Err msg ->
                                msg
                in
                    errMsg
                        |> Expect.equal "NdArray#inverse - Forbidden operation: NdArray not inversable"
            )
        ]
