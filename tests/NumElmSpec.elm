module NumElmSpec exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import NumElm exposing (..)


creatingNdArray : Test
creatingNdArray =
    describe "Creating a NdArray"
        [ test "ndarray Int8 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]" <|
            (\_ ->
                let
                    ndaResult =
                        ndarray Int8 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    Expect.equal strnda "NdArray[length=6,shape=3×2,dtype=Int8]"
            )
        , test "ndarray Float32 [ 2, 2 ] [ 1, 2, 3, 4 ]"
            (\_ ->
                let
                    ndaResult =
                        ndarray Float32 [ 2, 2 ] [ 1, 2, 3, 4 ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    Expect.equal strnda "NdArray[length=4,shape=2×2,dtype=Float32]"
            )
        , test "ndarray Int32 [ 2, 2 ] [ 1, 2, 3, 4, 6 ] --> Error"
            (\_ ->
                let
                    ndaResult =
                        ndarray Int32 [ 2, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    Expect.equal strnda "The length of the storage data is 6, but the shape says 2×2=4"
            )
        , test "vector Int32 [ 1, 2, 3, 4, 5 ]"
            (\_ ->
                let
                    ndaResult =
                        vector Int32 [ 1, 2, 3, 4, 5 ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    Expect.equal strnda "NdArray[length=5,shape=5×1,dtype=Int32]"
            )
        , test "matrix Int8 [ [1, 2], [3, 4] ]"
            (\_ ->
                let
                    ndaResult =
                        matrix Int8 [ [ 1, 2 ], [ 3, 4 ] ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    Expect.equal strnda "NdArray[length=4,shape=2×2,dtype=Int8]"
            )
        , test "matrix Int8 [ [1, 2], [3, 4, 5] ] --> Error"
            (\_ ->
                let
                    ndaResult =
                        matrix Int8 [ [ 1, 2 ], [ 3, 4, 5 ] ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    Expect.equal strnda "The length of the storage data is 5, but the shape says 2×2=4"
            )
        , test "matrix3d Int8 [ [ [ 1, 2 ], [ 3, 4 ], [ 5, 6 ] ], [ [ 7, 8 ], [ 9, 10 ], [ 11, 12 ] ] ]"
            (\_ ->
                let
                    ndaResult =
                        matrix3d Int8 [ [ [ 1, 2 ], [ 3, 4 ], [ 5, 6 ] ], [ [ 7, 8 ], [ 9, 10 ], [ 11, 12 ] ] ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    Expect.equal strnda "NdArray[length=12,shape=2×3×2,dtype=Int8]"
            )
        , test "matrix3d Int8 [ [ [ 1, 2 ], [ 3, 4 ] ], [ [ 5, 6, 7 ], [ 8, 9 ] ] ] --> Error"
            (\_ ->
                let
                    ndaResult =
                        matrix3d Int8 [ [ [ 1, 2 ], [ 3, 4 ] ], [ [ 5, 6, 7 ], [ 8, 9 ] ] ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    Expect.equal strnda "The length of the storage data is 9, but the shape says 2×2×2=8"
            )
        ]


gettingNdArrayInfo : Test
gettingNdArrayInfo =
    describe "Getting info from a NdArray"
        [ test "toString <| vector Int32 [ 1, 2 ]"
            (\_ ->
                let
                    ndaResult =
                        vector Int32 [ 1, 2 ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    Expect.equal strnda "NdArray[length=2,shape=2×1,dtype=Int32]"
            )
        , test "dataToString <| matrix Float32 [ [1, 2, 3], [4, 5, 6], [7, 8, 9] ]"
            (\_ ->
                let
                    ndaResult =
                        matrix Float32 [ [ 1, 2, 3 ], [ 4, 5, 6 ], [ 7, 8, 9 ] ]

                    dataStr =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString nda

                            Err msg ->
                                msg
                in
                    Expect.equal dataStr "[1,2,3,4,5,6,7,8,9]"
            )
        , test "shape <| matrix3d Int8 [ [ [ 1, 2 ] ], [ [ 7, 8 ] ] ]"
            (\_ ->
                let
                    ndaResult =
                        matrix3d Int8 [ [ [ 1, 2 ] ], [ [ 7, 8 ] ] ]

                    ndashape =
                        case ndaResult of
                            Ok nda ->
                                NumElm.shape nda

                            Err msg ->
                                []
                in
                    Expect.equalLists ndashape [ 2, 1, 2 ]
            )
        , test "shape <| ndarray Int8 [ ] [ 1, 2, 3, 4, 5 ] --> Error"
            (\_ ->
                let
                    ndaResult =
                        ndarray Int8 [] [ 1, 2, 3, 4, 5 ]

                    ndashapeErr =
                        case ndaResult of
                            Ok nda ->
                                "Ok"

                            Err msg ->
                                msg
                in
                    Expect.equal ndashapeErr "NdArray has no shape"
            )
        , test "dtype <| matrix3d Float32 [ [ [ 1, 2 ] ], [ [ 7, 8 ] ] ]"
            (\_ ->
                let
                    ndaResult =
                        matrix3d Float32 [ [ [ 1, 2 ] ], [ [ 7, 8 ] ] ]

                    ndadtype =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dtype nda

                            Err msg ->
                                Array
                in
                    Expect.equal ndadtype Float32
            )
        ]


preFilledMatrixes : Test
preFilledMatrixes =
    describe "Pre-filled matrixes"
        [ test "zeros Int8 [3, 2]"
            (\_ ->
                let
                    ndaResult =
                        zeros Int8 [ 3, 2 ]

                    maybeNdaWithZeros =
                        case ndaResult of
                            Ok nda ->
                                Just nda

                            Err msg ->
                                Nothing
                in
                    case maybeNdaWithZeros of
                        Just ndaWithZeros ->
                            Expect.equal "[0,0,0,0,0,0]" <|
                                NumElm.dataToString ndaWithZeros

                        Nothing ->
                            Expect.fail "WFT??"
            )
        , test "ones Int8 [2, 4]"
            (\_ ->
                let
                    ndaResult =
                        ones Int8 [ 2, 4 ]

                    maybeNdaWithOnes =
                        case ndaResult of
                            Ok nda ->
                                Just nda

                            Err msg ->
                                Nothing
                in
                    case maybeNdaWithOnes of
                        Just ndaWithOnes ->
                            Expect.equal "[1,1,1,1,1,1,1,1]" <|
                                NumElm.dataToString ndaWithOnes

                        Nothing ->
                            Expect.fail "WFT??"
            )
        , test "diag Int16 [2, 4, 3, 1]"
            (\_ ->
                let
                    ndaResult =
                        diag Int16 [ 2, 4, 3, 1 ]

                    maybeNdaWithDiag =
                        case ndaResult of
                            Ok nda ->
                                Just nda

                            Err msg ->
                                Nothing
                in
                    case maybeNdaWithDiag of
                        Just ndaWithDiag ->
                            Expect.equal "[2,0,0,0,0,4,0,0,0,0,3,0,0,0,0,1]" <|
                                NumElm.dataToString ndaWithDiag

                        Nothing ->
                            Expect.fail "WFT??"
            )
        , test "identity Int16 3"
            (\_ ->
                let
                    ndaResult =
                        NumElm.identity Int16 3

                    maybeIdentity =
                        case ndaResult of
                            Ok nda ->
                                Just nda

                            Err msg ->
                                Nothing
                in
                    case maybeIdentity of
                        Just ndaIdentity ->
                            Expect.equal "[1,0,0,0,1,0,0,0,1]" <|
                                NumElm.dataToString ndaIdentity

                        Nothing ->
                            Expect.fail "WFT??"
            )
        ]
