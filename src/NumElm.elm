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
-}

import Native.NumElm
import List exposing (..)
import Maybe exposing (..)


{-| Represents a multidimensional,
homogeneous array of fixed-size items
-}
type NdArray
    = NdArray


{-| List of dimensions.

    [3, 4]        == 3x4 matrix
    [2] == [2, 1] == 2x1 column vector
    [1, 4]        == 1x4 row vector
    [3, 2, 5]     == 3x2x5 matrix (3D )

-}
type alias Shape =
    List Int


{-| Location within the matrix.

    get [2, 1] [[1, 2], [3, 4], [5, 6]] == 6

-}
type alias Location =
    List Int


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


{-| Creates an NdArray from a list of numbers.

    -- 3x2 matrix of 8-bit signed integers
    ndarray Int8 [3, 2] [1, 2, 3, 4, 5, 6]

-}
ndarray : Dtype -> Shape -> List number -> Result String NdArray
ndarray dtype shape data =
    Native.NumElm.ndarray dtype shape data


{-| Creates an NdArray from a 1D list.

    -- 6x1 column vector of 16-bit signed integers.
    vector Int16 [ 1, 2, 3, 4, 5, 6 ]

-}
vector : Dtype -> List number -> Result String NdArray
vector dtype data =
    let
        d1 =
            length data
    in
        ndarray dtype [ d1 ] data


{-| Creates an NdArray from a 2D list.

    -- 2x3 matrix of 32-bit floating point numbers.
    matrix Float32
           [ [1, 2, 3]
           , [4, 5, 6]
           ]

-}
matrix : Dtype -> List (List number) -> Result String NdArray
matrix dtype data =
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
        ndarray dtype [ d1, d2 ] <| List.concatMap Basics.identity data


{-| Creates an NdArray from a 3D list.

    -- 3x2x2 3D matrix of 64-bit floating point numbers.
    matrix3d Float64
             [ [ [1, 2]
               , [3, 4]
               ]
             , [ [5, 6]
               , [7, 8]
               ]
             , [ [9, 10]
               , [11, 12]
               ]
             ]

-}
matrix3d : Dtype -> List (List (List number)) -> Result String NdArray
matrix3d dtype data =
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
        ndarray dtype [ d1, d2, d3 ] <|
            List.concatMap
                (\sublist ->
                    List.concatMap
                        (\a -> a)
                        sublist
                )
                data


{-| Returns the string representation of the ndarray.
This is quite handy for testing.

    let nda = ndarray Int8 [3, 2] [1, 2, 3, 4, 5, 6]
    toString nda == NdArray[length=6,shape=3×2,dtype=Int8]
-}
toString : NdArray -> String
toString ndarray =
    Native.NumElm.toString ndarray


{-| Returns the string representation of the internal array.
This is quite handy for testing.

    let nda = ndarray Int8 [3, 2] [1, 2, 3, 4, 5, 6]
    toDataString nda == "[1,2,3,4,5,6]"
-}
toDataString : NdArray -> String
toDataString ndarray =
    Native.NumElm.toString ndarray


{-| Gets the shape of the ndarray.

    shape ndarray1 == [2, 4] -- 2×4 matrix
    shape ndarray2 == [3, 2, 2] -- 3×2×2 3D matrix

-}
shape : NdArray -> Shape
shape ndarray =
    Native.NumElm.shape ndarray


{-| Alias for shape.
-}
size : NdArray -> Shape
size ndarray =
    shape ndarray


{-| Gets the dtype of the ndarray.

    dtype ndarray1 == Int32
    dtype ndarray2 == Float64
-}
dtype : NdArray -> Dtype
dtype ndarray =
    Native.NumElm.dtype ndarray


{-| Returns a new ndarray of given shape and type, filled with zeros.

    zeros Int8 [3, 2] == [[0, 0], [0, 0], [0, 0]]
-}
zeros : Dtype -> Shape -> Result String NdArray
zeros dtype shape =
    let
        length =
            shapeToLength shape
    in
        Native.NumElm.ndarray dtype shape <| List.repeat length 0


{-| Return a new ndarray of given shape and type, filled with ones.

    ones Int8 [2, 4] == [[1, 1, 1, 1], [1, 1, 1, 1]]
-}
ones : Dtype -> Shape -> Result String NdArray
ones shape dtype =
    let
        length =
            shapeToLength shape
    in
        Native.NumElm.ndarray dtype shape <| List.repeat length 1


{-| Vector of diagonal elements of list.

    diag Int16 [1, 2, 3] == [
                              [1, 0, 0],
                              [0, 2, 0],
                              [0, 0, 3]
                            ]
-}
diag : Dtype -> List number -> Result String NdArray
diag dtype list =
    Native.NumElm.diag dtype list


{-| Return an identity matrix given [size, size].

    identity Int16 3 == [
                          [1, 0, 0],
                          [0, 1, 0],
                          [0, 0, 1]
                        ]
-}
identity : Dtype -> Int -> Result String NdArray
identity dtype size =
    Native.NumElm.diag dtype <| List.repeat size 1


{-| Alias for identity.
-}
eye : Dtype -> Int -> Result String NdArray
eye size dtype =
    identity size dtype


shapeToLength : Shape -> Int
shapeToLength shape =
    List.foldl (*) 1 shape
