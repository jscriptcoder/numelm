module NumElm
    exposing
        ( NdArray
        , Shape
        , Location
        , Dtype
        , ndarray
        , vector
        , matrix
        , matrix3d
        , toString
        , shape
        , size
        , dtype
        , zeros
        , ones
        , identity
        , eye
        , diag
        )

{-| The NumPy for Elm

# Types
@docs NdArray, Shape, Location, Dtype


# Creating a NdArray
@docs ndarray, vector, matrix, matrix3d


# Getting info from a NdArray
@docs toString, shape, size, dtype


# Pre-defined matrixes
@docs zeros, ones, identity, eye, diag

# Getters an Setters
@docs get
-}

import Native.NumElm
import List exposing (..)
import Maybe exposing (..)


{-| Represents a multidimensional,
homogeneous array of fixed-size items
-}
type NdArray
    = NdArray


{-| List of dimensions dimensions.

  [3, 4]        == 3x4 matrix
  [2] == [2, 1] == 2x1 column vector
  [1, 4]        == 1x4 row vector
  [3, 2, 5]     == 3x2x5 matrix (3D )

-}
type alias Shape =
    List Int


{-| Location within the matrix.
Used to get or set the matrix
-}
type alias Location =
    List (Maybe Int)


{-| Data type of the ndarray.
-}
type Dtype
    = Int8
    | In16
    | Int32
    | Float32
    | Float64
    | Uint8
    | Uint16
    | Uint32
    | Array


{-| Creates an NdArray from a list of numbers

    ndarray [1, 2, 3, 4, 5, 6] [3, 2] Int8

    Creates a matrix 3x2 of 8-bit signed integers.
    [
      [1, 2],
      [3, 4],
      [5, 6]
    ]

-}
ndarray : List number -> Shape -> Dtype -> NdArray
ndarray data shape dtype =
    Native.NumElm.ndarray data shape dtype


{-| Creates an NdArray from a 1D list

    vector [ 1, 2, 3, 4, 5, 6 ] Int16

    Creates a column vector 6x1 of 16-bit signed integers.
    [ 1
    , 2
    , 3
    , 4
    , 5
    , 6
    ]

-}
vector : List number -> Dtype -> NdArray
vector data dtype =
    let
        d1 =
            length data
    in
        ndarray data [ d1 ] dtype


{-| Creates an NdArray from a 2D list

    matrix [ [1, 2, 3]
           , [4, 5, 6]
           ] Float32

    Creates a matrix 2x3 of of 32-bit floating point numbers.
    [
      [1, 2, 3],
      [4, 5, 6]
    ]

-}
matrix : List (List number) -> Dtype -> NdArray
matrix data dtype =
    let
        maybeYList =
            head data

        d1 =
            length data

        d2 =
            case maybeYList of
                Just firstYList ->
                    length firstYList

                Nothing ->
                    0
    in
        ndarray (List.concatMap (\a -> a) data) [ d1, d2 ] dtype


{-| Creates an NdArray from a 3D list

    matrix3d [ [ [1, 2]
               , [3, 4]
               ]
             , [ [5, 6]
               , [7, 8]
               ]
             , [ [9, 10]
               , [11, 12]
               ]
             ] Float64

    Creates a 3D matrix 3x2x2 of of 64-bit floating point numbers.

-}
matrix3d : List (List (List number)) -> Dtype -> NdArray
matrix3d data dtype =
    let
        maybeYList =
            head data

        firstYList =
            case maybeYList of
                Just yList ->
                    yList

                Nothing ->
                    []

        maybeZList =
            head firstYList

        firstZList =
            case maybeZList of
                Just zList ->
                    zList

                Nothing ->
                    []

        d1 =
            length data

        d2 =
            length firstYList

        d3 =
            length firstZList
    in
        ndarray
            (List.concatMap
                (\sublist ->
                    List.concatMap
                        (\a -> a)
                        sublist
                )
                data
            )
            [ d1, d2, d3 ]
            dtype


{-| Returns the string representation of the ndarray.
This is quite handy for testing.

    let nda = ndarray [1, 2, 3, 4, 5, 6] [3, 2] Int8
    toString nda == NdArray[length=6,shape=3×2,dtype=Int8]

-}
toString : NdArray -> String
toString ndarray =
    Native.NumElm.toString ndarray


{-| Returns the shape of the ndarray.

    shape ndarray1 == [2, 4] -- 2x4 matrix
    shape ndarray2 == [3, 2, 2] -- 3x2x2 3D matrix

-}
shape : NdArray -> Shape
shape ndarray =
    Native.NumElm.shape ndarray


{-| Alias for shape.
-}
size : NdArray -> Shape
size ndarray =
    shape ndarray


{-| Returns the data type of the ndarray.

    dtype ndarray1 == Int32
    dtype ndarray2 == Float64

-}
dtype : NdArray -> Dtype
dtype ndarray =
    Native.NumElm.dtype ndarray


{-| Return a new ndarray of given shape and type, filled with zeros.
-}
zeros : Shape -> Dtype -> NdArray
zeros shape dtype =
    Native.NumElm.zeros shape dtype


{-| Return a new ndarray of given shape and type, filled with ones.
-}
ones : Shape -> Dtype -> NdArray
ones shape dtype =
    Native.NumElm.ones shape dtype


{-| Return an identity matrix of given [size, size] shape and type.
-}
identity : Int -> Dtype -> NdArray
identity size dtype =
    Native.NumElm.identity size dtype


{-| Alias for identity.
-}
eye : Int -> Dtype -> NdArray
eye size dtype =
    identity size dtype


{-| Vector of diagonal elements of list
-}
diag : List number -> Dtype -> NdArray
diag list dtype =
    Native.NumElm.diag list dtype


{-| Getter function.
-}
get : Location -> NdArray
get location =
    NdArray
