module TransformingNdArrayTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Transforming NdArray"
        [ test "map (a -> a^2) <| vector Int8 [1, 2, 3]"
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
        , test "transpose <| matrix Float32 [[1, 2, 3], [4, 5, 6]]"
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
        , test "transpose <| matrix3d Int8 [ [ [ 1 ], [ 2 ], [ 3 ] ], [ [ 4 ], [ 5 ], [ 6 ] ] ]"
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
        , test "transpose <| matrix Int8 [ [ 1, 2, 3 ], [ 4, 5, 6 ] ]"
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
        , test "inv <| matrix Float32 [ [ 8, 1, 6 ], [ 3, 5, 7 ], [ 4, 9, 2 ] ]"
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
                            Expect.equal "[0.14722222089767456,-0.14444445073604584,0.06388888508081436,-0.06111111119389534,0.022222211584448814,0.10555555671453476,-0.01944444142282009,0.18888890743255615,-0.10277777910232544]" <|
                                NumElm.dataToString matrixInv

                        Err msg ->
                            Expect.fail msg
            )
        , test "inverse <| matrix Float32 [ [ 2, 3, 7 ], [ 1, 3, 2 ] ] --> Error"
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
                    Expect.equal errMsg "NdArray#inverse: NdArray must be square"
            )
        , test "inverse <| matrix Float32 [ [ 2, 3 ], [ 0, 0 ] ] --> Error"
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
                    Expect.equal errMsg "NdArray#inverse: NdArray not inversable"
            )
        ]
