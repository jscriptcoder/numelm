module GettingSettingTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Getting and Setting"
        [ test "Getting"
            (\_ ->
                let
                    ndaResult =
                        NumElm.diag Int16 [ 2, 4, 3, 1 ]
                in
                    case ndaResult of
                        Ok nda ->
                            let
                                maybeValue =
                                    NumElm.get [ 2, 2 ] nda
                            in
                                case maybeValue of
                                    Just value ->
                                        Expect.equal value 3

                                    Nothing ->
                                        Expect.fail "Wrong location"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Getting nothing"
            (\_ ->
                let
                    ndaResult =
                        NumElm.diag Int16 [ 2, 4, 3, 1 ]

                    maybeValue =
                        case ndaResult of
                            Ok nda ->
                                NumElm.get [ 1, 8 ] nda

                            Err _ ->
                                Nothing
                in
                    case maybeValue of
                        Just value ->
                            Expect.fail "This should not happen"

                        Nothing ->
                            Expect.pass
            )
        , test "Slicing"
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

                    maybeSlicedNda =
                        case ndaResult of
                            Ok nda ->
                                {-
                                   [ [ [  7,  8 ] ]
                                   , [ [ 11, 12 ] ]
                                   ]
                                -}
                                NumElm.getn [ 1, 1, 0 ] [ 3, 2, 2 ] nda

                            Err _ ->
                                Nothing
                in
                    case maybeSlicedNda of
                        Just slicedNda ->
                            NumElm.dataToString slicedNda
                                |> Expect.equal "[7,8,11,12]"

                        Nothing ->
                            Expect.fail "This should not happen"
            )
        , test "Slicing without end"
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

                    maybeSlicedNda =
                        case ndaResult of
                            Ok nda ->
                                {-
                                   [ [ [ 6 ]
                                     , [ 8 ]
                                     ]
                                   , [ [ 10 ]
                                     , [ 12 ]
                                     ]
                                   ]
                                -}
                                NumElm.getn [ 1, 0, 1 ] [] nda

                            Err _ ->
                                Nothing
                in
                    case maybeSlicedNda of
                        Just slicedNda ->
                            NumElm.shape slicedNda
                                |> Expect.equal [ 2, 2, 1 ]

                        Nothing ->
                            Expect.fail "This should not happen"
            )
        , test "More slicing without end"
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

                    maybeSlicedNda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.getn [ 1, 0, 1 ] [] nda

                            Err _ ->
                                Nothing
                in
                    case maybeSlicedNda of
                        Just slicedNda ->
                            NumElm.shape slicedNda
                                |> Expect.equal [ 2, 2, 1 ]

                        Nothing ->
                            Expect.fail "This should not happen"
            )
        , test "Slicing with end offset"
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

                    maybeSlicedNda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.getn [ -1, -1 ] [] nda

                            Err _ ->
                                Nothing
                in
                    case maybeSlicedNda of
                        Just slicedNda ->
                            NumElm.dataToString slicedNda
                                |> Expect.equal "[11,12]"

                        Nothing ->
                            Expect.fail "This should not happen"
            )
        , test "Slicing without start"
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

                    maybeSlicedNda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.getn [] [ -1, -1, -1 ] nda

                            Err _ ->
                                Nothing
                in
                    case maybeSlicedNda of
                        Just slicedNda ->
                            NumElm.dataToString slicedNda
                                |> Expect.equal "[1,5]"

                        Nothing ->
                            Expect.fail "This should not happen"
            )
        , test "Slicing and getting nothing"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix
                            Int8
                            [ [ 1, 2 ], [ 3, 4 ] ]

                    maybeSlicedNda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.getn [ 2, 0 ] [] nda

                            Err _ ->
                                Nothing
                in
                    case maybeSlicedNda of
                        Just slicedNda ->
                            Expect.fail "This should not happen"

                        Nothing ->
                            Expect.pass
            )
        , test "Slicing a transposed matrix"
            (\_ ->
                let
                    matrixResult =
                        NumElm.matrix Int8 [ [ 1, 2, 3 ], [ 4, 5, 6 ] ]

                    matrixTResult =
                        Result.map
                            (\matrix -> NumElm.transpose matrix)
                            matrixResult

                    slicedNdaMaybeResult =
                        Result.map
                            (\matrixT -> getn [ 2, 0 ] [] matrixT)
                            matrixTResult

                    strMatrixResult =
                        Result.map
                            (\slicedNdaMaybe ->
                                case slicedNdaMaybe of
                                    Just slicedNda ->
                                        NumElm.dataToString slicedNda

                                    Nothing ->
                                        "This should not happen"
                            )
                            slicedNdaMaybeResult
                in
                    case strMatrixResult of
                        Ok strMatrix ->
                            Expect.equal strMatrix "[3,6]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Setting"
            (\_ ->
                let
                    ndaResult =
                        NumElm.eye Int16 3

                    newNdaResult =
                        case ndaResult of
                            Ok nda ->
                                NumElm.set 8 [ 2, 1 ] nda

                            Err msg ->
                                Result.Err msg
                in
                    case newNdaResult of
                        Ok newNda ->
                            Expect.equal "[1,0,0,0,1,0,0,8,1]" <|
                                NumElm.dataToString newNda

                        Err msg ->
                            Expect.fail msg
            )
        , test "Setting with wrong location"
            (\_ ->
                let
                    ndaResult =
                        NumElm.eye Int16 3

                    newNdaResult =
                        case ndaResult of
                            Ok nda ->
                                NumElm.set 8 [ 9, 1 ] nda

                            Err msg ->
                                Result.Err msg
                in
                    case newNdaResult of
                        Ok newNda ->
                            Expect.fail "This should not happen"

                        Err _ ->
                            Expect.pass
            )
        , test "Concatenation"
            (\_ ->
                let
                    nda1Result =
                        NumElm.matrix3d
                            Int8
                            [ [ [ 1, 2 ]
                              , [ 3, 4 ]
                              , [ 5, 6 ]
                              ]
                            , [ [ 7, 8 ]
                              , [ 9, 10 ]
                              , [ 11, 12 ]
                              ]
                            ]

                    nda2Result =
                        NumElm.matrix3d
                            Int8
                            [ [ [ 13, 14 ]
                              , [ 15, 16 ]
                              ]
                            , [ [ 17, 18 ]
                              , [ 19, 20 ]
                              ]
                            ]

                    strdataResult =
                        Result.map2
                            (\nda1 nda2 ->
                                let
                                    concatResult =
                                        NumElm.concatenateAxis 1 nda1 nda2
                                in
                                    case concatResult of
                                        Ok concat ->
                                            NumElm.dataToString concat

                                        Err msg ->
                                            msg
                            )
                            nda1Result
                            nda2Result
                in
                    case strdataResult of
                        Ok strdata ->
                            strdata
                                |> Expect.equal "[1,2,3,4,5,6,13,14,15,16,7,8,9,10,11,12,17,18,19,20]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Concatenation with transpose"
            (\_ ->
                let
                    nda1Result =
                        NumElm.matrix
                            Int8
                            [ [ 1, 2, 3 ]
                            , [ 4, 5, 6 ]
                            ]
                            |> Result.map (\matrix -> NumElm.trans matrix)

                    {-
                       [ [1, 4]
                       , [2, 5]
                       , [3, 6]
                    -}
                    nda2Result =
                        NumElm.matrix
                            Int8
                            [ [ 7, 8 ]
                            , [ 9, 10 ]
                            , [ 11, 12 ]
                            ]

                    strdataResult =
                        Result.map2
                            (\nda1 nda2 ->
                                let
                                    concatResult =
                                        NumElm.concatenateAxis 1 nda1 nda2
                                in
                                    case concatResult of
                                        Ok concat ->
                                            NumElm.dataToString concat

                                        Err msg ->
                                            msg
                            )
                            nda1Result
                            nda2Result
                in
                    case strdataResult of
                        Ok strdata ->
                            strdata
                                |> Expect.equal "[1,4,7,8,2,5,9,10,3,6,11,12]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Concatenation in 0 axis"
            (\_ ->
                let
                    nda1Result =
                        NumElm.matrix
                            Int8
                            [ [ 1, 2, 3 ]
                            , [ 4, 5, 6 ]
                            ]

                    nda2Result =
                        NumElm.matrix
                            Int8
                            [ [ 7, 8, 9 ]
                            ]

                    strdataResult =
                        Result.map2
                            (\nda1 nda2 ->
                                let
                                    concatResult =
                                        NumElm.concat nda1 nda2
                                in
                                    case concatResult of
                                        Ok concat ->
                                            NumElm.dataToString concat

                                        Err msg ->
                                            msg
                            )
                            nda1Result
                            nda2Result
                in
                    case strdataResult of
                        Ok strdata ->
                            strdata
                                |> Expect.equal "[1,2,3,4,5,6,7,8,9]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Complex concatenation with transposed 3D matrix"
            (\_ ->
                let
                    nda1Result =
                        NumElm.matrix3d
                            Int8
                            [ [ [ 1, 2 ]
                              , [ 3, 4 ]
                              , [ 5, 6 ]
                              ]
                            , [ [ 7, 8 ]
                              , [ 9, 10 ]
                              , [ 11, 12 ]
                              ]
                            ]

                    nda2Result =
                        NumElm.matrix3d
                            Int8
                            [ [ [ 13, 14 ]
                              , [ 15, 16 ]
                              ]
                            , [ [ 17, 18 ]
                              , [ 19, 20 ]
                              ]
                            , [ [ 21, 22 ]
                              , [ 23, 24 ]
                              ]
                            ]
                            |> Result.map (\matrix -> NumElm.trans matrix)

                    strdataResult =
                        Result.map2
                            (\nda1 nda2 ->
                                let
                                    concatResult =
                                        NumElm.concat nda1 nda2
                                in
                                    case concatResult of
                                        Ok concat ->
                                            NumElm.dataToString concat

                                        Err msg ->
                                            msg
                            )
                            nda1Result
                            nda2Result
                in
                    case strdataResult of
                        Ok strdata ->
                            strdata
                                |> Expect.equal "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Concatenation with incompatible shapes"
            (\_ ->
                let
                    nda1Result =
                        NumElm.matrix
                            Int8
                            [ [ 1, 2, 3 ]
                            , [ 4, 5, 6 ]
                            ]

                    nda2Result =
                        NumElm.matrix
                            Int8
                            [ [ 7, 8 ]
                            ]

                    strMsgResult =
                        Result.map2
                            (\nda1 nda2 ->
                                let
                                    concatResult =
                                        NumElm.concat nda1 nda2
                                in
                                    case concatResult of
                                        Ok concat ->
                                            "Ok"

                                        Err msg ->
                                            msg
                            )
                            nda1Result
                            nda2Result
                in
                    case strMsgResult of
                        Ok strMsg ->
                            strMsg
                                |> Expect.equal "NdArray#concat - Incompatible shapes: The shape of nda1 is 2×3, but nda2 says 1×2 on axis 0"

                        Err msg ->
                            Expect.fail "This should no happen"
            )
        ]
