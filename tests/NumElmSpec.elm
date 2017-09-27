module NumElmSpec exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import NumElm exposing (..)


creatingNdArray : Test
creatingNdArray =
    describe "Creating NdArray"
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
        , test "ndarray Int8 [ 3, 2 ] [ ] --> Error" <|
            (\_ ->
                let
                    ndaResult =
                        ndarray Int8 [ 3, 2 ] []

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    Expect.equal strnda "NdArray cannot be empty"
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
    describe "Getting info from NdArray"
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
                    Expect.equal ndashapeErr "NdArray has no shape: []"
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
    describe "Pre-filled NgArray"
        [ test "zeros Int8 [3, 2]"
            (\_ ->
                let
                    ndaResult =
                        zeros Int8 [ 3, 2 ]
                in
                    case ndaResult of
                        Ok ndaWithZeros ->
                            Expect.equal "[0,0,0,0,0,0]" <|
                                NumElm.dataToString ndaWithZeros

                        Err msg ->
                            Expect.fail msg
            )
        , test "ones Int8 [2, 4]"
            (\_ ->
                let
                    ndaResult =
                        ones Int8 [ 2, 4 ]
                in
                    case ndaResult of
                        Ok ndaWithOnes ->
                            Expect.equal "[1,1,1,1,1,1,1,1]" <|
                                NumElm.dataToString ndaWithOnes

                        Err msg ->
                            Expect.fail msg
            )
        , test "diag Int16 [2, 4, 3, 1]"
            (\_ ->
                let
                    ndaResult =
                        diag Int16 [ 2, 4, 3, 1 ]
                in
                    case ndaResult of
                        Ok ndaWithDiag ->
                            Expect.equal "[2,0,0,0,0,4,0,0,0,0,3,0,0,0,0,1]" <|
                                NumElm.dataToString ndaWithDiag

                        Err msg ->
                            Expect.fail msg
            )
        , test "identity Int16 3"
            (\_ ->
                let
                    ndaResult =
                        NumElm.identity Int16 3
                in
                    case ndaResult of
                        Ok ndaIdentity ->
                            Expect.equal "[1,0,0,0,1,0,0,0,1]" <|
                                NumElm.dataToString ndaIdentity

                        Err msg ->
                            Expect.fail msg
            )
        , test "rand Float32 [3, 3] 123"
            (\_ ->
                let
                    ndaResult =
                        NumElm.rand Float32 [ 3, 3 ] 123
                in
                    case ndaResult of
                        Ok ndaIdentity ->
                            Expect.equal "[0.24073243141174316,0.04531741142272949,0.9876625537872314,0.35852646827697754,0.07100510597229004,0.12969064712524414,0.36553406715393066,0.9482383728027344,0.7428145408630371]" <|
                                NumElm.dataToString ndaIdentity

                        Err msg ->
                            Expect.fail msg
            )
        ]


gettersSetters : Test
gettersSetters =
    describe "Getters and Setters"
        [ test "get [1, 0] <| diag Int16 [2, 4, 3, 1]"
            (\_ ->
                let
                    ndaResult =
                        diag Int16 [ 2, 4, 3, 1 ]
                in
                    case ndaResult of
                        Ok nda ->
                            let
                                maybeValue =
                                    get [ 2, 2 ] nda
                            in
                                case maybeValue of
                                    Just value ->
                                        Expect.equal value 3

                                    Nothing ->
                                        Expect.fail "Wrong location"

                        Err msg ->
                            Expect.fail msg
            )
        , test "set 8 [2, 1] <| identity Int16 3"
            (\_ ->
                let
                    ndaResult =
                        NumElm.identity Int16 3
                in
                    case ndaResult of
                        Ok nda ->
                            let
                                newNdaResult =
                                    set 8 [ 2, 1 ] nda
                            in
                                case newNdaResult of
                                    Ok newNda ->
                                        Expect.equal "[1,0,0,0,1,0,0,8,1]" <|
                                            NumElm.dataToString newNda

                                    Err msg ->
                                        Expect.fail msg

                        Err msg ->
                            Expect.fail msg
            )
        ]


transformingNdArray : Test
transformingNdArray =
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
                                    NumElm.map (\a loc nda -> a ^ 2) vec
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
                            in
                                Expect.equalLists (NumElm.shape matrixT) [ 3, 2 ]

                        Err msg ->
                            Expect.fail msg
            )
        , test "transpose <| matrix3d Int8 [ [ [ 1 ], [ 2 ], [ 3 ] ], [ [ 4 ], [ 5 ], [ 6 ] ] ]"
            (\_ ->
                let
                    matrixResult =
                        NumElm.matrix3d Int8 [ [ [ 1 ], [ 2 ], [ 3 ] ], [ [ 4 ], [ 5 ], [ 6 ] ] ]
                in
                    case matrixResult of
                        Ok matrix ->
                            let
                                matrixT =
                                    NumElm.transpose matrix
                            in
                                {-
                                   shape matrix
                                       --> [2, 3, 1]

                                   shape <| transpose matrix
                                       --> [3, 2, 1]
                                -}
                                Expect.equalLists (NumElm.shape matrixT) [ 3, 2, 1 ]

                        Err msg ->
                            Expect.fail msg
            )
        , test "matrix Int8 [ [ 1, 2, 3 ], [ 4, 5, 6 ] ]"
            (\_ ->
                let
                    matrixResult =
                        matrix Int8 [ [ 1, 2, 3 ], [ 4, 5, 6 ] ]
                in
                    case matrixResult of
                        Ok matrix ->
                            let
                                matrixT =
                                    NumElm.transpose matrix

                                strmatrix =
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
                                Expect.equal strmatrix "[1,4,2,5,3,6]"

                        Err msg ->
                            Expect.fail msg
            )
        ]
