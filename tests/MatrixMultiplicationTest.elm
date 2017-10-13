module MatrixMultiplicationTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Matrix multiplication"
        [ test "Dot multiplication"
            (\_ ->
                let
                    nda1Result =
                        NumElm.matrix Int16
                            [ [ 1, 2, 3 ]
                            , [ 4, 5, 6 ]
                            , [ 7, 8, 9 ]
                            , [ 3, 1, 1 ]
                            ]

                    nda2Result =
                        NumElm.matrix Int16
                            [ [ 4, 1 ]
                            , [ 5, 3 ]
                            , [ 2, 6 ]
                            ]

                    ndaDotResult =
                        Result.map2
                            (\nda1 nda2 -> NumElm.dot nda1 nda2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opDotResult -> Result.map Basics.identity opDotResult)
                in
                    case ndaDotResult of
                        Ok ndaDot ->
                            NumElm.toString ndaDot
                                |> Expect.equal
                                    "NdArray[length=8,shape=4×2,dtype=Int16]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Another dot multiplication"
            (\_ ->
                let
                    nda1Result =
                        NumElm.matrix Int16
                            [ [ 1, 2, 3 ]
                            , [ 4, 5, 6 ]
                            , [ 7, 8, 9 ]
                            ]

                    nda2Result =
                        NumElm.matrix Int16
                            [ [ 1, 2 ]
                            , [ 3, 4 ]
                            , [ 5, 6 ]
                            ]

                    ndaDotResult =
                        Result.map2
                            (\nda1 nda2 -> NumElm.dot nda1 nda2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opDotResult -> Result.map Basics.identity opDotResult)
                in
                    case ndaDotResult of
                        Ok ndaDot ->
                            {-
                               [ [22,  28]
                               , [49,  64]
                               , [76, 100]
                               ]
                            -}
                            NumElm.dataToString ndaDot
                                |> Expect.equal "[22,28,49,64,76,100]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Dot multiplication with incompatible shapes"
            (\_ ->
                let
                    nda1Result =
                        NumElm.matrix Int16
                            [ [ 1, 2 ]
                            , [ 3, 4 ]
                            , [ 5, 6 ]
                            ]

                    nda2Result =
                        NumElm.matrix Int16
                            [ [ 1, 2, 3 ]
                            , [ 4, 5, 6 ]
                            , [ 7, 8, 9 ]
                            ]

                    ndaDotResult =
                        Result.map2
                            (\nda1 nda2 -> NumElm.dot nda1 nda2)
                            nda1Result
                            nda2Result
                            |> Result.andThen
                                (\opDotResult -> Result.map Basics.identity opDotResult)
                in
                    case ndaDotResult of
                        Ok ndaDot ->
                            Expect.fail "This should not happen"

                        Err msg ->
                            msg
                                |> Expect.equal "NdArray#dot - Incompatible shapes: The shape of nda1 is 3×2, but nda2 says 3×3"
            )
        ]
