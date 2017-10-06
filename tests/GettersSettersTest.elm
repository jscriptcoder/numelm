module GettersSettersTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Getters and Setters"
        [ test "get [2, 2] <| diag Int16 [2, 4, 3, 1]"
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
        , test "get [1, 8] <| diag Int16 [2, 4, 3, 1] --> Nothing"
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
        , test "set 8 [2, 1] <| identity Int16 3"
            (\_ ->
                let
                    ndaResult =
                        NumElm.identity Int16 3

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
        , test "set 8 [9, 1] <| identity Int16 3 --> Error"
            (\_ ->
                let
                    ndaResult =
                        NumElm.identity Int16 3

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
        ]
