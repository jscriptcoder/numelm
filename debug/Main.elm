module Main exposing (..)

import Html exposing (text)
import NumElm exposing (..)


main =
    let
        ndaResult =
            NumElm.arangeStep Float64 1 10.5 2.2

        strdata =
            case ndaResult of
                Ok nda ->
                    NumElm.abs nda
                        |> NumElm.dataToString

                Err msg ->
                    msg
    in
        text strdata
