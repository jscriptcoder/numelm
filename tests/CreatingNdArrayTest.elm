module CreatingNdArrayTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Creating NdArray"
        [ test "Creating Int8"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Int8 [ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    strnda
                        |> Expect.equal "NdArray[length=6,shape=3×2,dtype=Int8]"
            )
        , test "Creating with empty data"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Int8 [ 3, 2 ] []

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    strnda
                        |> Expect.equal "NdArray#constructor - Wrong data length: NdArray cannot be empty"
            )
        , test "Creating Float32"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Float32 [ 2, 2 ] [ 1, 2, 3, 4 ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    strnda
                        |> Expect.equal "NdArray[length=4,shape=2×2,dtype=Float32]"
            )
        , test "Creating with wrong data length"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Int32 [ 2, 2 ] [ 1, 2, 3, 4, 5, 6 ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    strnda
                        |> Expect.equal "NdArray#constructor - Wrong data length: The length of the storage data is 6, but the shape says 2×2=4"
            )
        , test "Creating vector"
            (\_ ->
                let
                    ndaResult =
                        NumElm.vector Int32 [ 1, 2, 3, 4, 5 ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    strnda
                        |> Expect.equal "NdArray[length=5,shape=5×1,dtype=Int32]"
            )
        , test "Creating matrix"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix Int8 [ [ 1, 2 ], [ 3, 4 ] ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    strnda
                        |> Expect.equal "NdArray[length=4,shape=2×2,dtype=Int8]"
            )
        , test "Creating matrix with wrong length"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix Int8 [ [ 1, 2 ], [ 3, 4, 5 ] ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    strnda
                        |> Expect.equal "NdArray#constructor - Wrong data length: The length of the storage data is 5, but the shape says 2×2=4"
            )
        , test "Creating 3D matrix"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix3d Int8 [ [ [ 1, 2 ], [ 3, 4 ], [ 5, 6 ] ], [ [ 7, 8 ], [ 9, 10 ], [ 11, 12 ] ] ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    strnda
                        |> Expect.equal "NdArray[length=12,shape=2×3×2,dtype=Int8]"
            )
        , test "Creating 3D matrix with wrong length"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix3d Int8 [ [ [ 1, 2 ], [ 3, 4 ] ], [ [ 5, 6, 7 ], [ 8, 9 ] ] ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    strnda
                        |> Expect.equal "NdArray#constructor - Wrong data length: The length of the storage data is 9, but the shape says 2×2×2=8"
            )
        , test "Creating with empty shape"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ndarray Int8 [] [ 1, 2, 3, 4, 5 ]

                    ndaShapeErr =
                        case ndaResult of
                            Ok nda ->
                                "Ok"

                            Err msg ->
                                msg
                in
                    ndaShapeErr
                        |> Expect.equal "NdArray#constructor - Wrong shape: NdArray has no shape: []"
            )
        ]
