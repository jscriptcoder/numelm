module PreFilledMatrixesTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Pre-filled NgArray"
        [ test "Zeros"
            (\_ ->
                let
                    ndaResult =
                        NumElm.zeros Int8 [ 3, 2 ]
                in
                    case ndaResult of
                        Ok ndaWithZeros ->
                            Expect.equal "[0,0,0,0,0,0]" <|
                                NumElm.dataToString ndaWithZeros

                        Err msg ->
                            Expect.fail msg
            )
        , test "Ones"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ones Int8 [ 2, 4 ]
                in
                    case ndaResult of
                        Ok ndaWithOnes ->
                            NumElm.dataToString ndaWithOnes
                                |> Expect.equal "[1,1,1,1,1,1,1,1]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Diagonal"
            (\_ ->
                let
                    ndaResult =
                        NumElm.diag Int16 [ 2, 4, 3, 1 ]
                in
                    case ndaResult of
                        Ok ndaWithDiag ->
                            NumElm.dataToString ndaWithDiag
                                |> Expect.equal "[2,0,0,0,0,4,0,0,0,0,3,0,0,0,0,1]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Identity"
            (\_ ->
                let
                    ndaResult =
                        NumElm.identity Int16 3
                in
                    case ndaResult of
                        Ok ndaIdentity ->
                            NumElm.dataToString ndaIdentity
                                |> Expect.equal "[1,0,0,0,1,0,0,0,1]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Uniform distribution random"
            (\_ ->
                let
                    ndaResult =
                        NumElm.rand Float32 [ 3, 3 ] 123
                in
                    case ndaResult of
                        Ok ndaRand ->
                            NumElm.dataToString ndaRand
                                |> Expect.equal
                                    "[0.24073243141174316,0.04531741142272949,0.9876625537872314,0.35852646827697754,0.07100510597229004,0.12969064712524414,0.36553406715393066,0.9482383728027344,0.7428145408630371]"

                        Err msg ->
                            Expect.fail msg
            )
        , test "Standar normal distribution random"
            (\_ ->
                let
                    ndaResult =
                        NumElm.randn Float32 [ 3, 3 ] 123
                in
                    case ndaResult of
                        Ok ndaRand ->
                            NumElm.dataToString ndaRand
                                |> Expect.equal
                                    "[0.7122775912284851,-1.8686243295669556,0.2632739543914795,0.903903603553772,0.8288260698318481,-0.10995164513587952,1.022497534751892,-0.4667685925960541,0.2659539580345154]"

                        Err msg ->
                            Expect.fail msg
            )
        ]
