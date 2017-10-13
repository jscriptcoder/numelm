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
        , ndim
        , length
        , numel
        , dtype
        , zeros
        , ones
        , diagonal
        , diag
        , identity
        , eye
        , rand
        , randn
        , get
        , slice
        , getn
        , set
        , concatenateAxis
        , concatenate
        , concat
        , map
        , transposeAxes
        , transpose
        , trans
        , inverse
        , inv
        , pinv
        , svd
        , eig
        , add
        , (.+)
        , subtract
        , sub
        , (.-)
        , multiply
        , mul
        , (.*)
        , divide
        , div
        , (./)
        , power
        , pow
        , (.^)
        , sqrt
        , logBase
        , log
        , log2
        , log10
        , exp
        , dot
        )

{-| The NumPy for Elm.

# Types
@docs NdArray, Shape, Location, Dtype

# Creating NdArray
@docs ndarray, vector, matrix, matrix3d

# Getting info from NdArray
@docs toString, dataToString, shape, size, ndim, length, numel, dtype

# Pre-filled NdArray
@docs zeros, ones, diagonal, diag, identity, eye, rand

# Getting and Setting
@docs get, slice, getn, set

# Transforming NdArray
@docs map, transposeAxes, transpose, trans, inverse, inv, pinv, svd, eig

# Arithmetic operations
@docs add, (.+), subtract, sub, (.-), multiply, mul, (.*), divide, div, (./), power, pow, (.^)

# Root and Logarithm
@docs sqrt, logBase, log, log2, log10, exp

# Matrix mutiplication
@docs dot

# Round off
@docs around, round, ceil, floor, fix

-}

import Native.NumElm
import List
import Random exposing (Seed, Generator)
import Tuple


-- Types --


{-| Represents a multidimensional, homogeneous array of fixed-size items
-}
type NdArray
    = NdArray


{-| List of dimensions.

    [3, 4]        -- 3×4 matrix
    [2] == [2, 1] -- 2×1 column vector
    [1, 4]        -- 1×4 row vector
    [3, 2, 5]     -- 3×2×5 matrix (3D)

-}
type alias Shape =
    List Int


{-| Location within the matrix.

    -- nda == [ [1, 2], [3, 4], [5, 6] ]
    get [1, 0] nda == 3

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



-- Creating NdArray --


{-| Creates an NdArray from a list of numbers.

    -- 3×2 matrix of 8-bit signed integers
    ndarray
      Int8
      [3, 2]
      [1, 2, 3, 4, 5, 6]

-}
ndarray : Dtype -> Shape -> List number -> Result String NdArray
ndarray dtype shape data =
    Native.NumElm.ndarray dtype shape data


{-| Creates an NdArray from a 1D list.

    -- 6×1 column vector of 16-bit signed integers.
    vector
      Int16
      [ 1, 2, 3, 4, 5, 6 ]

-}
vector : Dtype -> List number -> Result String NdArray
vector dtype data =
    let
        d1 =
            List.length data
    in
        ndarray dtype [ d1 ] data


{-| Creates an NdArray from a 2D list.

    -- 2×3 matrix of 32-bit floating point numbers.
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

    -- 3×2×2 3D matrix of 64-bit floating point numbers.
    matrix3d Float64
             [ [ [1, 2]
               , [3, 4]
               ]
             , [ [5, 6]
               , [7, 8]
               ]
             , [ [ 9, 10]
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



-- Getting info from NdArray --


{-| Returns the string representation of the ndarray.

    let
        nda = ndarray
                Int8
                [3, 2]
                [1, 2, 3, 4, 5, 6]
    in
        toString nda
        --> NdArray[length=6,shape=3×2,dtype=Int8]
-}
toString : NdArray -> String
toString nda =
    Native.NumElm.toString nda


{-| Returns the string representation of the internal array.

    let
        nda = ndarray
                Int8
                [3, 2]
                [1, 2, 3, 4, 5, 6]
    in
        dataToString nda
        --> "[1,2,3,4,5,6]"
-}
dataToString : NdArray -> String
dataToString nda =
    Native.NumElm.dataToString nda


{-| Gets the shape of the ndarray.

     -- 2×4 matrix
    shape ndarray1 == [2, 4]

    -- 3×2×2 3D matrix
    shape ndarray2 == [3, 2, 2]

-}
shape : NdArray -> Shape
shape nda =
    Native.NumElm.shape nda


{-| Alias for shape.
-}
size : NdArray -> Shape
size nda =
    shape nda


{-| Gets the number of dimensions of the ndarray

     -- 2×4×1 matrix
    ndim ndarray == 3

-}
ndim : NdArray -> Int
ndim nda =
    List.length <| shape nda


{-| Gets the number of elements in the ndarray

     -- 2×4×1 matrix
    numel ndarray == 3

-}
length : NdArray -> Int
length nda =
    toLength <| shape nda


{-| Alias for length.
-}
numel : NdArray -> Int
numel nda =
    length nda


{-| Gets the dtype of the ndarray.

    dtype ndarray1 == Int32
    dtype ndarray2 == Float64
-}
dtype : NdArray -> Dtype
dtype nda =
    Native.NumElm.dtype nda



-- Pre-filled NgArray --


{-| Returns a new ndarray of given shape and type, filled with zeros.

    zeros Int8 [3, 2]
    -- [ [0, 0]
    -- , [0, 0]
    -- , [0, 0]
    -- ]

-}
zeros : Dtype -> Shape -> Result String NdArray
zeros dtype shape =
    let
        length =
            toLength shape
    in
        Native.NumElm.ndarray dtype shape <| List.repeat length 0


{-| Return a new ndarray of given shape and type, filled with ones.

    ones Int8 [2, 4]
    -- [ [1, 1, 1, 1]
    -- , [1, 1, 1, 1]
    -- ]
-}
ones : Dtype -> Shape -> Result String NdArray
ones dtype shape =
    let
        length =
            toLength shape
    in
        Native.NumElm.ndarray dtype shape <| List.repeat length 1


{-| Vector of diagonal elements of list.

    diag Int16 [1, 2, 3]
    -- [ [1, 0, 0]
    -- , [0, 2, 0]
    -- , [0, 0, 3]
    -- ]
-}
diagonal : Dtype -> List number -> Result String NdArray
diagonal dtype list =
    Native.NumElm.diagonal dtype list


{-| Alias for diagonal.
-}
diag : Dtype -> List number -> Result String NdArray
diag dtype list =
    diagonal dtype list


{-| Return an identity matrix given [size, size].

    identity Int16 3
    -- [ [1, 0, 0]
    -- , [0, 1, 0]
    -- , [0, 0, 1]
    -- ]

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

    rand Float32 [3, 3] 123
    -- [ [0.24, 0.04, 0.98]
    -- , [0.35, 0.07, 0.12]
    -- , [0.36, 0.94, 0.74]
    -- ]

-}
rand : Dtype -> Shape -> Int -> Result String NdArray
rand dtype shape intSeed =
    let
        size =
            toLength shape
    in
        Native.NumElm.ndarray dtype shape <|
            randomUniformList size intSeed


{-| Generates a random ndarray from a "standard normal" distribution.

    randn Float32 [3, 3] 123
    -- [ [0.71, -1.86, 0.26]
    -- , [ 0.9,  0.82, -0.1]
    -- , [1.02, -0.46, 0.26]
    -- ]

-}
randn : Dtype -> Shape -> Int -> Result String NdArray
randn dtype shape intSeed =
    let
        size =
            toLength shape
    in
        Native.NumElm.ndarray dtype shape <|
            randomStandardNormalList size intSeed



-- Getting and Setting --


{-| Gets the value from a specific location.

    let
        nda = ndarray Int8 [3, 2] [1, 2, 3, 4, 5, 6]
    in
        get [1, 0] nda == 3

-}
get : Location -> NdArray -> Maybe number
get location nda =
    Native.NumElm.get location nda


{-| Slices the NdArray selected from start to end (end not included).

    let
        nda = matrix3d
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
    in
        slice [ 1, 1, 0 ] [ 3, 2, 2 ] nda
        -- [ [ [  7,  8 ] ]
        -- , [ [ 11, 12 ] ]
        -- ]

-}
slice : Location -> Location -> NdArray -> Maybe NdArray
slice start end nda =
    Native.NumElm.slice start end nda


{-| Alias for slice.
-}
getn : Location -> Location -> NdArray -> Maybe NdArray
getn start end nda =
    slice start end nda


{-| Sets the value in a specific location

    let
        nda = ndarray Int8 [3, 2] [1, 2, 3, 4, 5, 6]
        -- [ [1, 2]
        -- , [3, 4]
        -- , [5, 6]
        -- ]
    in
        set 8 [1, 0] nda
        -- [ [1, 2]
        -- , [8, 4]
        -- , [5, 6]
        -- ]

-}
set : number -> Location -> NdArray -> Result String NdArray
set value location nda =
    Native.NumElm.set value location nda


{-| Join a sequence of NdArray along an existing axis.

    let
        nda1 = ndarray Int8 [3, 2] [1, 2, 3, 4, 5, 6]
        -- [ [1, 2]
        -- , [3, 4]
        -- , [5, 6]
        -- ]

        nda2 = ndarray Int8 [3, 2] [7, 8, 9, 10, 11, 12]
        -- [ [ 7,  8]
        -- , [ 9, 10]
        -- , [11, 12]
        -- ]
    in
        concatenateAxis 1 nda1 nda2
        -- [ [1, 2,  7,  8]
        -- , [3, 4,  9, 10]
        -- , [5, 6, 11, 12]
        -- ]

-}
concatenateAxis : Int -> NdArray -> NdArray -> Result String NdArray
concatenateAxis axis nda1 nda2 =
    Native.NumElm.concatenate axis nda1 nda2


{-| Alias for concatenateAxis with axis 0.
-}
concatenate : NdArray -> NdArray -> Result String NdArray
concatenate nda1 nda2 =
    concatenateAxis 0 nda1 nda2


{-| Alias for concatenate.
-}
concat : NdArray -> NdArray -> Result String NdArray
concat nda1 nda2 =
    concatenate nda1 nda2



-- Transforming NdArray --


{-| Transforms the values of the NdArray with mapping.

    let
        vec = vector Int8 [1, 2, 3]
    in
        map (\a loc -> a^2) vec
        --> [1, 4, 9]

-}
map : (number1 -> Location -> NdArray -> number2) -> NdArray -> NdArray
map callback nda =
    Native.NumElm.map callback nda


{-| Permute the axes according to the values given
-}
transposeAxes : List Int -> NdArray -> NdArray
transposeAxes axes nda =
    Native.NumElm.transpose axes nda


{-| Transposes the NdArray. Permute the dimensions, and only the first two.

    let
        A = matrix Float32
                   [ [1, 2, 3]
                   , [4, 5, 6]
                   ]
    in
        transpose A
        -- [ [1, 4]
        -- , [2, 5]
        -- , [3, 6]
        -- ]

-}
transpose : NdArray -> NdArray
transpose nda =
    -- 3×2,     [1] swaps 1st and 2nd dimensions            --> 2×3
    -- 3×2×4,   [2] swaps 1st and 3nd dimensions            --> 4×2×3
    -- 3×2×4×5, [2, 3] swaps 1st and 3rd then 2nd and 4th   --> 4×5×3×4
    -- 3×2×4    [1, 2] swaps 1st and 2nd then 2nd and 3rd   --> 2×4×3
    -- 3×2      [1, 0] swaps 1st and 2nd then 2nd and 1st   --> 3×2
    transposeAxes [ 1 ] nda


{-| Alias for transpose.
-}
trans : NdArray -> NdArray
trans nda =
    transpose nda


{-| Compute the (multiplicative) inverse of a matrix.

    let
        A = matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]
    in
        inverse A
        -- [ [-2.0,  1.0]
        -- , [ 1.5, -0.5]
        -- ]

-}
inverse : NdArray -> Result String NdArray
inverse nda =
    Native.NumElm.inverse nda


{-| Alias for inverse.
-}
inv : NdArray -> Result String NdArray
inv nda =
    inverse nda


{-| Compute the (Moore-Penrose) pseudo-inverse of a matrix.

    -- TODO

-}
pinv : NdArray -> NdArray
pinv nda =
    NdArray


{-| Singular Value Decomposition.

    -- TODO

-}
svd : NdArray -> NdArray
svd nda =
    NdArray


{-| Compute the eigenvalues and right eigenvectors of a square NdArray.

    -- TODO

-}
eig : NdArray -> NdArray
eig nda =
    NdArray



-- Arithmetic operations --


{-| Add arguments, element-wise.

    let
        A = matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        B = matrix Int8
                   [ [4, 1]
                   , [5, 3]
                   ]
    in
        add A B
        -- [ [5, 3]
        -- , [8, 7]
        -- ]

-}
add : NdArray -> NdArray -> Result String NdArray
add nda1 nda2 =
    Native.NumElm.elementWise (+) nda1 nda2


{-| Add escalar, element-wise.

    let
        A = matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        A .+ 5
        -- [ [6, 7]
        -- , [8, 9]
        -- ]

-}
(.+) : NdArray -> number -> NdArray
(.+) nda num =
    map (\val _ _ -> val + num) nda


{-| Substract arguments, element-wise.

    let
        A = matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        B = matrix Int8
                   [ [4, 1]
                   , [5, 3]
                   ]
    in
        subtract A B
        -- [ [-3, 1]
        -- , [-2, 1]
        -- ]

-}
subtract : NdArray -> NdArray -> Result String NdArray
subtract nda1 nda2 =
    Native.NumElm.elementWise (-) nda1 nda2


{-| Alias for subtract.
-}
sub : NdArray -> NdArray -> Result String NdArray
sub nda1 nda2 =
    subtract nda1 nda2


{-| Substract escalar, element-wise.

    let
        A = matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        A .- 5
        -- [ [-4, -3]
        -- , [-2, -1]
        -- ]

-}
(.-) : NdArray -> number -> NdArray
(.-) nda num =
    map (\val _ _ -> val - num) nda


{-| Multiply arguments, element-wise.

    let
        A = matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        B = matrix Int8
                   [ [4, 1]
                   , [5, 3]
                   ]
    in
        multiply A B
        -- [ [ 4,  2]
        -- , [15, 12]
        -- ]

-}
multiply : NdArray -> NdArray -> Result String NdArray
multiply nda1 nda2 =
    Native.NumElm.elementWise (*) nda1 nda2


{-| Alias for multiply.
-}
mul : NdArray -> NdArray -> Result String NdArray
mul nda1 nda2 =
    multiply nda1 nda2


{-| Multiply escalar, element-wise.

    let
        A = matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        A .* 5
        -- [ [ 5, 10]
        -- , [15, 20]
        -- ]

-}
(.*) : NdArray -> number -> NdArray
(.*) nda num =
    map (\val _ _ -> val * num) nda


{-| Devide arguments, element-wise.

    let
        A = matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        B = matrix Int8
                   [ [4, 1]
                   , [5, 3]
                   ]
    in
        divide A B
        -- [ [1/4,   2]
        -- , [3/5, 4/3]
        -- ]

-}
divide : NdArray -> NdArray -> Result String NdArray
divide nda1 nda2 =
    Native.NumElm.elementWise (/) nda1 nda2


{-| Alias for divide.
-}
div : NdArray -> NdArray -> Result String NdArray
div nda1 nda2 =
    divide nda1 nda2


{-| Devide escalar, element-wise.

    let
        A = matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        A ./ 5
        -- [ [1/5, 2/5]
        -- , [3/5, 4/5]
        -- ]

-}
(./) : NdArray -> Float -> NdArray
(./) nda num =
    map (\val _ _ -> val / num) nda


{-| NdArray elements raised to powers from second NdArray, element-wise.

    let
        A = matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        B = matrix Int8
                   [ [2, 2]
                   , [3, 4]
                   ]
    in
        divide A B
        -- [ [ 1,   4]
        -- , [27, 256]
        -- ]

-}
power : NdArray -> NdArray -> Result String NdArray
power nda1 nda2 =
    Native.NumElm.elementWise (^) nda1 nda2


{-| Alias for power.
-}
pow : NdArray -> NdArray -> Result String NdArray
pow nda1 nda2 =
    power nda1 nda2


{-| NdArray elements raised to power of an escalar, element-wise.

    let
        A = matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        A .^ 2
        -- [ [1,  4]
        -- , [9, 16]
        -- ]

-}
(.^) : NdArray -> number -> NdArray
(.^) nda num =
    map (\val _ _ -> val ^ num) nda



-- Root and Logarithm --


{-| Return the positive square-root of an array, element-wise.

    let
        A = matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        sqrt A
        -- [ [   1, 1.41]
        -- , [1.73,    2]
        -- ]

-}
sqrt : NdArray -> NdArray
sqrt nda =
    map (\val _ _ -> Basics.sqrt val) nda


{-| Base "base" logarithm, element-wise.

    let
        A = matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        logBase 3 A
        -- [ [0, 0.63]
        -- , [1, 1.26]
        -- ]

-}
logBase : Float -> NdArray -> NdArray
logBase base nda =
    map (\val _ _ -> Basics.logBase base val) nda


{-| Natural logarithm (in base e), element-wise.

    let
        A = matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        log A
        -- [ [   0, 0.69]
        -- , [1.09, 1.38]
        -- ]

-}
log : NdArray -> NdArray
log nda =
    logBase Basics.e nda


{-| Base 2 logarithm, element-wise.

    let
        A = matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        log2 A
        -- [ [   0, 1]
        -- , [1.58, 2]
        -- ]

-}
log2 : NdArray -> NdArray
log2 nda =
    logBase 2 nda


{-| Base 10 logarithm, element-wise.

    let
        A = matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        log10 A
        -- [ [   0, 0.3]
        -- , [0.47, 0.6]
        -- ]

-}
log10 : NdArray -> NdArray
log10 nda =
    logBase 10 nda


{-| Calculate the exponential of all elements in the NdArray.

    let
        A = matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        exp A
        -- [ [ 2.71,  7.38]
        -- , [20.08, 54.59]
        -- ]

-}
exp : NdArray -> NdArray
exp nda =
    map (\val _ _ -> Basics.e ^ val) nda



-- Matrix mutiplication --


{-| Dot product of two arrays.

    let
        -- 4×3 matrix
        A = matrix Int16
                   [ [1, 2, 3]
                   , [4, 5, 6]
                   , [7, 8, 9]
                   , [3, 1, 1]
                   ]

        -- 3×2 matrix
        B = matrix Int16
                   [ [4, 1]
                   , [5, 3]
                   , [2, 6]
                   ]

    in
        -- 4×3 3×2 == 4×2
        dot A B
        -- [ [1×4 + 2×5 + 3×2, 1×1 + 2×3 + 3×6]
        -- , [4×4 + 5×5 + 6×2, 4×1 + 5×3 + 6×6]
        -- , [7×4 + 8×5 + 9×2, 7×1 + 8×3 + 9×6]
        -- , [3×4 + 1×5 + 1×2, 3×1 + 1×3 + 1×6]
        -- ]

-}
dot : NdArray -> NdArray -> Result String NdArray
dot nda1 nda2 =
    Native.NumElm.dot nda1 nda2



-- Helper functions --


toLength : Shape -> Int
toLength shape =
    List.foldr (*) 1 shape


randomUniformList : Int -> Int -> List Float
randomUniformList size intSeed =
    let
        generator =
            Random.float 0 1
    in
        randomList size intSeed generator


randomStandardNormalList : Int -> Int -> List Float
randomStandardNormalList size intSeed =
    let
        -- Standard Normal variate using Box-Muller transform
        generator =
            Random.map2
                (\u v ->
                    Basics.sqrt
                        (-2 * Basics.logBase Basics.e (1 - Basics.max 0 u))
                        * Basics.cos v
                )
                (Random.float 0 1)
                (Random.float 0 (2 * Basics.pi))
    in
        randomList size intSeed generator


randomList : Int -> Int -> Generator Float -> List Float
randomList size intSeed generator =
    let
        rndList =
            Random.list size generator
    in
        Tuple.first <|
            Random.step rndList <|
                Random.initialSeed intSeed
