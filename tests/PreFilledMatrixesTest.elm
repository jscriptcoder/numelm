module PreFilledMatrixesTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Pre-filled NgArray"
        [ test "zeros Int8 [3, 2]"
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
        , test "ones Int8 [2, 4]"
            (\_ ->
                let
                    ndaResult =
                        NumElm.ones Int8 [ 2, 4 ]
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
                        NumElm.diag Int16 [ 2, 4, 3, 1 ]
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
                        Ok ndaRand ->
                            Expect.equal
                                "[0.24073243141174316,0.04531741142272949,0.9876625537872314,0.35852646827697754,0.07100510597229004,0.12969064712524414,0.36553406715393066,0.9482383728027344,0.7428145408630371]"
                            <|
                                NumElm.dataToString ndaRand

                        Err msg ->
                            Expect.fail msg
            )
        , test "randn Float32 [3, 3] 123"
            (\_ ->
                let
                    ndaResult =
                        NumElm.randn Float32 [ 3, 3 ] 123
                in
                    case ndaResult of
                        Ok ndaRand ->
                            Expect.equal
                                "[0.7122775912284851,-1.8686243295669556,0.2632739543914795,0.903903603553772,0.8288260698318481,-0.10995164513587952,1.022497534751892,-0.4667685925960541,0.2659539580345154]"
                            <|
                                NumElm.dataToString ndaRand

                        Err msg ->
                            Expect.fail msg
            )
        ]
