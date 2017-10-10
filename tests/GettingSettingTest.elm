module GettingSettingTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import NumElm exposing (..)


suit : Test
suit =
    describe "Getting and Setting"
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
        , test "getn [1, 1, 0] [3, 2, 2] <| matrix3d Int8 [ [ [ 1, 2 ], [ 3, 4 ] ], [ [ 5, 6 ], [ 7, 8 ] ], [ [ 9, 10 ], [ 11, 12 ] ] ]"
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
                            Expect.equal "[7,8,11,12]" <| NumElm.dataToString slicedNda

                        Nothing ->
                            Expect.fail "This should not happen"
            )
        , test "getn [1, 1, 0] [] <| matrix3d Int8 [ [ [ 1, 2 ], [ 3, 4 ] ], [ [ 5, 6 ], [ 7, 8 ] ], [ [ 9, 10 ], [ 11, 12 ] ] ]"
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
                            Expect.equal [ 2, 2, 1 ] <| NumElm.shape slicedNda

                        Nothing ->
                            Expect.fail "This should not happen"
            )
        , test "getn [ 1, 0, 1 ] [] <| matrix3d Int8 [ [ [ 1, 2 ], [ 3, 4 ] ], [ [ 5, 6 ], [ 7, 8 ] ], [ [ 9, 10 ], [ 11, 12 ] ] ]"
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
                            Expect.equal [ 2, 2, 1 ] <| NumElm.shape slicedNda

                        Nothing ->
                            Expect.fail "This should not happen"
            )
        , test "getn [ -1, -1] [] <| matrix3d Int8 [ [ [ 1, 2 ], [ 3, 4 ] ], [ [ 5, 6 ], [ 7, 8 ] ], [ [ 9, 10 ], [ 11, 12 ] ] ]"
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
                            Expect.equal "[11,12]" <| NumElm.dataToString slicedNda

                        Nothing ->
                            Expect.fail "This should not happen"
            )
        , test "getn [] [-1, -1, -1] <| matrix3d Int8 [ [ [ 1, 2 ], [ 3, 4 ] ], [ [ 5, 6 ], [ 7, 8 ] ], [ [ 9, 10 ], [ 11, 12 ] ] ]"
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
                            Expect.equal "[1,5]" <| NumElm.dataToString slicedNda

                        Nothing ->
                            Expect.fail "This should not happen"
            )
        , test "getn [2, 0] [] <| matrix Int8 [ [ 1, 2 ], [ 3, 4 ] ] --> Nothing"
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
        , test "set 8 [2, 1] <| eye Int16 3"
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
        , test "set 8 [9, 1] <| eye Int16 3 --> Error"
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
        ]
