module Main exposing (..)

import Html exposing (text)
import NumElm exposing (..)


main =
    text <|
        Basics.toString <|
            NumElm.dtype <|
                matrix3d
                    [ [ [ 1, 2 ]
                      , [ 3, 4 ]
                      ]
                    , [ [ 5, 6 ]
                      , [ 7, 8 ]
                      ]
                    , [ [ 9, 10, 13 ]
                      , [ 11, 12 ]
                      ]
                    ]
                    Float32



-- text <| toString <| ndarray [ 1, 2, 3, 4 ] [ 2, 2 ] Int8
-- text <| toString <| vector [ 1, 2, 3, 4 ] Int8
-- text <| toString <| matrix [ [ 1, 2 ], [ 3, 4 ] ] Int8
