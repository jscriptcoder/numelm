module GettingNdArrayInfoTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Getting info from NdArray"
        [ test "Converting NdArray to string"
            (\_ ->
                let
                    ndaResult =
                        NumElm.vector Int32 [ 1, 2 ]

                    strnda =
                        case ndaResult of
                            Ok nda ->
                                NumElm.toString nda

                            Err msg ->
                                msg
                in
                    Expect.equal strnda "NdArray[length=2,shape=2×1,dtype=Int32]"
            )
        , test "Converting data to string"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix Float32 [ [ 1, 2, 3 ], [ 4, 5, 6 ], [ 7, 8, 9 ] ]

                    dataStr =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dataToString nda

                            Err msg ->
                                msg
                in
                    Expect.equal dataStr "[1,2,3,4,5,6,7,8,9]"
            )
        , test "Getting the shape"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix3d Int8 [ [ [ 1, 2 ] ], [ [ 7, 8 ] ] ]

                    ndaShape =
                        case ndaResult of
                            Ok nda ->
                                NumElm.shape nda

                            Err msg ->
                                []
                in
                    Expect.equalLists ndaShape [ 2, 1, 2 ]
            )
        , test "Number of dimensions"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ones Float32 [ 3, 2, 1 ]

                    ndaDim =
                        case ndaResult of
                            Ok nda ->
                                NumElm.ndim nda

                            Err _ ->
                                0
                in
                    Expect.equal ndaDim 3
            )
        , test "Number of elements"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ones Float32 [ 3, 2, 2 ]

                    ndaLen =
                        case ndaResult of
                            Ok nda ->
                                NumElm.numel nda

                            Err _ ->
                                0
                in
                    Expect.equal ndaLen 12
            )
        , test "Getting dtype"
            (\_ ->
                let
                    ndaResult =
                        NumElm.matrix3d Float32 [ [ [ 1, 2 ] ], [ [ 7, 8 ] ] ]

                    ndaDtype =
                        case ndaResult of
                            Ok nda ->
                                NumElm.dtype nda

                            Err msg ->
                                Array
                in
                    Expect.equal ndaDtype Float32
            )
        ]
