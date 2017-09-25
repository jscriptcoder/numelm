module NumElm
    exposing
        ( NdArray
        , Shape
        , Location
        , Dtype(..)
        , ndarray
        , vector
        , matrix
        , matrix3d
        , toString
        , dataToString
        , shape
        , size
        , dtype
        , zeros
        , ones
        , diag
        , identity
        , eye
        , rand
        , get
        , set
        )

{-| The NumPy for Elm

# Types
@docs NdArray, Shape, size, Location, Dtype


# Creating a NdArray
@docs ndarray, vector, matrix, matrix3d


# Getting info from a NdArray
@docs toString, toDataString, shape, size, dtype


# Pre-filled matrixes
@docs zeros, ones, diag, identity, eye, rand


# Getters and Setters
@doc get, set
-}

import Native.NumElm
import List
import Random exposing (Seed)
import Tuple


-- Types --


{-| Represents a multidimensional, homogeneous array of fixed-size items
-}
type NdArray
    = NdArray


{-| List of dimensions.

    [3, 4]        -- 3x4 matrix
    [2] == [2, 1] -- 2x1 column vector
    [1, 4]        -- 1x4 row vector
    [3, 2, 5]     -- 3x2x5 matrix (3D )

-}
type alias Shape =
    List Int


{-| Location within the matrix.

    get [2, 1] [[1, 2], [3, 4], [5, 6]] --> 6

-}
type alias Location =
    List Int


{-| Data type of the ndarray.
-}
type Dtype
    = Int8
    | Int16
    | Int32
    | Float32
    | Float64
    | Uint8
    | Uint16
    | Uint32
    | Array



-- Creating a NdArray --


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
            List.length data
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
            List.head data

        d1 =
            List.length data

        d2 =
            case maybeYList of
                Just firstYList ->
                    List.length firstYList

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
            List.head data

        firstYList =
            case maybeYList of
                Just yList ->
                    yList

                Nothing ->
                    []

        maybeZList =
            List.head firstYList

        firstZList =
            case maybeZList of
                Just zList ->
                    zList

                Nothing ->
                    []

        d1 =
            List.length data

        d2 =
            List.length firstYList

        d3 =
            List.length firstZList
    in
        ndarray dtype [ d1, d2, d3 ] <|
            List.concatMap
                (\sublist ->
                    List.concatMap
                        (\a -> a)
                        sublist
                )
                data



-- Getting info from a NdArray --


{-| Returns the string representation of the ndarray.

    let
        nda = ndarray Int8 [3, 2] [1, 2, 3, 4, 5, 6]
    in
        toString nda --> NdArray[length=6,shape=3×2,dtype=Int8]
-}
toString : NdArray -> String
toString nda =
    Native.NumElm.toString nda


{-| Returns the string representation of the internal array.

    let
        nda = ndarray Int8 [3, 2] [1, 2, 3, 4, 5, 6]
    in
        dataToString nda --> "[1,2,3,4,5,6]"
-}
dataToString : NdArray -> String
dataToString nda =
    Native.NumElm.dataToString nda


{-| Gets the shape of the ndarray.

     -- 2×4 matrix
    shape ndarray1 --> [2, 4]

    -- 3×2×2 3D matrix
    shape ndarray2 --> [3, 2, 2]

-}
shape : NdArray -> Shape
shape nda =
    Native.NumElm.shape nda


{-| Alias for shape.
-}
size : NdArray -> Shape
size nda =
    shape nda


{-| Gets the dtype of the ndarray.

    dtype ndarray1 --> Int32
    dtype ndarray2 --> Float64
-}
dtype : NdArray -> Dtype
dtype nda =
    Native.NumElm.dtype nda



-- Pre-filled matrixes --


{-| Returns a new ndarray of given shape and type, filled with zeros.

    zeros Int8 [3, 2] --> [ [0, 0]
                          , [0, 0]
                          , [0, 0]
                          ]
-}
zeros : Dtype -> Shape -> Result String NdArray
zeros dtype shape =
    let
        length =
            toLength shape
    in
        Native.NumElm.ndarray dtype shape <| List.repeat length 0


{-| Return a new ndarray of given shape and type, filled with ones.

    ones Int8 [2, 4] --> [ [1, 1, 1, 1]
                         , [1, 1, 1, 1]
                         ]
-}
ones : Dtype -> Shape -> Result String NdArray
ones dtype shape =
    let
        length =
            toLength shape
    in
        Native.NumElm.ndarray dtype shape <| List.repeat length 1


{-| Vector of diagonal elements of list.

    diag Int16 [1, 2, 3] --> [ [1, 0, 0]
                             , [0, 2, 0]
                             , [0, 0, 3]
                             ]
-}
diag : Dtype -> List number -> Result String NdArray
diag dtype list =
    Native.NumElm.diag dtype list


{-| Return an identity matrix given [size, size].

    identity Int16 3 --> [ [1, 0, 0]
                         , [0, 1, 0]
                         , [0, 0, 1]
                         ]
-}
identity : Dtype -> Int -> Result String NdArray
identity dtype size =
    diag dtype <| List.repeat size 1


{-| Alias for identity.
-}
eye : Dtype -> Int -> Result String NdArray
eye size dtype =
    identity size dtype


{-| Generates a random ndarray from an uniform distribution over [0, 1).

    rand Float32 [3, 3] 123 --> [ [1, 0, 0]
                                , [0, 1, 0]
                                , [0, 0, 1]
                                ]

-}
rand : Dtype -> Shape -> Int -> Result String NdArray
rand dtype shape intSeed =
    let
        size =
            toLength shape
    in
        Native.NumElm.ndarray dtype shape <|
            randomUniformList size intSeed



-- Getters and Setters --


{-| Gets the value from a specific location.

    let
        nda = ndarray Int8 [3, 2] [1, 2, 3, 4, 5, 6]
    in
        get [1, 0] nda --> 3

-}
get : Location -> NdArray -> Maybe number
get location nda =
    Native.NumElm.get location nda


{-| Sets the value in a specific location

    let
        nda = ndarray Int8 [3, 2] [1, 2, 3, 4, 5, 6]
    in
        set 8 [1, 0] nda --> [ [1, 2]
                             , [8, 4]
                             , [5, 6]
                             ]

-}
set : number -> Location -> NdArray -> Result String NdArray
set value location nda =
    Native.NumElm.set value location nda



-- Helper functions --


toLength : Shape -> Int
toLength shape =
    List.foldr (*) 1 shape


randomUniformList : Int -> Int -> List Float
randomUniformList size intSeed =
    Tuple.first <|
        Random.step (Random.list size <| Random.float 0 1) <|
            Random.initialSeed intSeed
