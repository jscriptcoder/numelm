module NumElm
    exposing
        ( -- Types --
          NdArray
        , Shape
        , Location
        , Dtype(..)
          -- Creating NdArray --
        , ndarray
        , vector
        , matrix
        , matrix3d
          -- Getting info from NdArray --
        , toString
        , dataToString
        , shape
        , size
        , ndim
        , length
        , numel
        , dtype
          -- Pre-filled NdArray --
        , zeros
        , ones
        , diagonal
        , diag
        , identity
        , eye
        , rand
        , randn
          -- Getting and Setting --
        , get
        , slice
        , getn
        , set
        , concatenateAxis
        , concatenate
        , concat
          -- Transforming NdArray --
        , map
        , transposeAxes
        , transpose
        , trans
        , inverse
        , inv
        , pinv
        , svd
        , eig
          -- Arithmetic operations --
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
        , mod
        , (.%)
          -- Root and Logarithm --
        , sqrt
        , logBase
        , log
        , log2
        , log10
        , exp
          -- Matrix mutiplication --
        , dot
          -- Round off --
        , around
        , round
        , ceil
        , floor
        , truncate
        , trunc
        , fix
          -- Aggregate functions --
        , max
        , maxAxis
        , min
        , minAxis
        , sum
        , sumAxis
        , prod
        , prodAxis
          -- Relational operators --
        , equal
        , eq
        , (.==)
        , less
        , lt
        , (.<)
        , greater
        , gt
        , (.>)
        , lessEqual
        , lte
        , (.<=)
        , greaterEqual
        , gte
        , (.>=)
        , notEqual
        , neq
        , (./=)
          -- Trigonometry functions --
          {-
             , sin
             , arcsin
             , asin
             , cos
             , arccos
             , acos
             , tan
             , arctan
             , atan
             , arctan2
             , atan2
          -}
          -- Hyperbolic functions --
          {-

             , sinh
             , arcsinh
             , asinh
             , cosh
             , arccosh
             , acosh
             , tanh
             , arctan
             , atanh
          -}
        )

{-| Based on NumPy, [Python package](http://www.numpy.org/), NumElm is the fundamental package for
scientific computing with Elm.

**API**
   1. [Types](#types)
    * [NdArray](#NdArray)
    * [Shape](#Shape)
    * [Location](#Location)
    * [Dtype](#Dtype)

   2. [Creating NdArray](#creating-ndarray)
    * [ndarray](#ndarray)
    * [vector](#vector)
    * [matrix](#matrix)
    * [matrix3d](#matrix3d)

   3. [Getting info from NdArray](#getting-info-from-ndarray)
    * [toString](#toString)
    * [dataToString](#dataToString)
    * [shape](#shape), [size](#size)
    * [ndim](#ndim)
    * [length](#length), [numel](#numel)
    * [dtype](#dtype)

   4. [Pre-filled NdArray](#pre-filled-ndarray)
    * [zeros](#zeros)
    * [ones](#ones)
    * [diagonal](#diagonal), [diag](#diag)
    * [identity](#identity), [eye](#eye)
    * [rand](#rand)
    * [randn](#randn)

   5. [Getting and Setting](#getting-and-setting)
    * [get](#get)
    * [slice](#slice), [getn](#getn)
    * [set](#set)
    * [concatenateAxis](#concatenateAxis)
    * [concatenate](#concatenate), [concat](#concat)

   6. [Transforming NdArray](#transforming-ndarray)
    * [map](#map)
    * [transposeAxes](#transposeAxes)
    * [transpose](#transpose), [trans](#trans)
    * [inverse](#inverse), [inv](#inv)
    * [pinv](#pinv) - TODO
    * [svd](#svd) - TODO
    * [eig](#eig) - TODO

   7. [Arithmetic operations](#arithmetic-operations)
    * [add](#add)
    * [(.+)](#.+)
    * [subtract](#subtract), [sub](#sub)
    * [(.-)](#.-)
    * [multiply](#multiply), [mul](#mul)
    * [(.*)](#.*)
    * [divide](#divide), [div](#div)
    * [(./)](#./)
    * [power](#power), [pow](#pow)
    * [(.^)](#.^)
    * [mod](#mod)
    * [(.%)](#.%)

   8. [Root and Logarithm](#root-and-logarithm)
    * [sqrt](#sqrt)
    * [logBase](#logBase)
    * [log](#log)
    * [log2](#log2)
    * [log10](#log10)
    * [exp](#exp)

   9. [Matrix mutiplication](#matrix-mutiplication)
    * [dot](#dot)

   10. [Round off](#round-off)
    * [around](#around)
    * [round](#round)
    * [ceil](#ceil)
    * [floor](#floor)
    * [truncate](#truncate), [trunc](#trunc), [fix](#fix)

   11. [Aggregate functions](#aggregate-functions)
    * [max](#max)
    * [maxAxis](#maxAxis)
    * [min](#min)
    * [minAxis](#minAxis)
    * [sum](#sum)
    * [sumAxis](#sumAxis)
    * [prod](#prod)
    * [prodAxis](#prodAxis)

   12. [Relational operators](#relational-operators)
    * [equal](#equal), [eq](#eq)
    * [(.==)](#.==)
    * [less](#less), [lt](#lt)
    * [(.<)](#.<)
    * [greater](#greater), [gt](#gt)
    * [(.>)](#.>)
    * [lessEqual](#lessEqual), [lte](#lte)
    * [(.<=)](#.<=)
    * [greaterEqual](#greaterEqual), [gte](#gte)
    * [(.>=)](#.>=)
    * [notEqual](#notEqual), [neq](#neq)
    * [(./=)](#./=)

# Types
@docs NdArray, Shape, Location, Dtype

# Creating NdArray
@docs ndarray, vector, matrix, matrix3d

# Getting info from NdArray
@docs toString, dataToString, shape, size, ndim, length, numel, dtype

# Pre-filled NdArray
@docs zeros, ones, diagonal, diag, identity, eye, rand, randn

# Getting and Setting
@docs get, slice, getn, set, concatenateAxis, concatenate, concat

# Transforming NdArray
@docs map, transposeAxes, transpose, trans, inverse, inv, pinv, svd, eig

# Arithmetic operations
@docs add, (.+), subtract, sub, (.-), multiply, mul, (.*)
@docs divide, div, (./), power, pow, (.^), mod, (.%)

# Root and Logarithm
@docs sqrt, logBase, log, log2, log10, exp

# Matrix mutiplication
@docs dot

# Round off
@docs around, round, ceil, floor, truncate, trunc, fix

# Aggregate functions
@docs max, maxAxis, min, minAxis, sum, sumAxis, prod, prodAxis

# Relational operators
@docs equal, eq, (.==), less, lt, (.<), greater, gt, (.>), lessEqual
@docs lte, (.<=), greaterEqual, gte, (.>=), notEqual, neq, (./=)

-}

import Native.NumElm
import List
import Maybe
import Random exposing (Seed, Generator)
import Tuple


-- Types --


{-| Multidimensional container of items of the same type and size.
The number of dimensions and items in an NdArray is defined by its
[Shape](#Shape), which is a list of N positive integers that specify
the sizes of each dimension. The type of items in the array is
specified by a separate data-type object, [Dtype](#Dtype), one of which is
associated with each NdArray.

-}
type NdArray
    = NdArray


{-| List of a [NdArray](#NdArray) dimensions.

    [3, 4]        -- 3×4 matrix
    [2] == [2, 1] -- 2×1 column vector
    [1, 4]        -- 1×4 row vector
    [3, 2, 5]     -- 3×2×5 matrix (3D)

-}
type alias Shape =
    List Int


{-| Location within the [NdArray](#NdArray).

    let
        nda =
            matrix Int8 [ [1, 2], [3, 4], [5, 6] ]

        location =
            [1, 0]

    in
        get location nda == 3

-}
type alias Location =
    List Int


{-| Describes how the bytes in the fixed-size block of memory corresponding
to an array item should be interpreted. It describes the following aspects
of the data:

1. Type of the data (integer, float)
2. Size of the data (how many bytes is in e.g. the integer)

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


{-| Generic way to create an [NdArray](#NdArray) with type [Dtype](#Dtype)
from a `List` of numbers

    -- 3×2 matrix of 8-bit signed integers
    ndarray
      Int8
      [3, 2]
      [1, 2, 3, 4, 5, 6]

-}
ndarray : Dtype -> Shape -> List number -> Result String NdArray
ndarray dtype shape data =
    Native.NumElm.ndarray dtype shape data


{-| Creates an [NdArray](#NdArray) with type [Dtype](#Dtype)
from a 1D `List`.

    -- 6×1 column vector of 16-bit signed integers.
    vector Int16 [ 1, 2, 3, 4, 5, 6 ]

-}
vector : Dtype -> List number -> Result String NdArray
vector dtype data =
    let
        d1 =
            List.length data
    in
        ndarray dtype [ d1 ] data


{-| Creates an [NdArray](#NdArray) with type [Dtype](#Dtype)
from a 2D `List`.

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


{-| Creates an [NdArray](#NdArray) with type [Dtype](#Dtype)
from a 3D `List`.

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


{-| Returns the `String` representation of the ndarray.

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


{-| Returns the `String` representation of the internal array.

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


{-| Returns the [Shape](#Shape) of the [NdArray](#NdArray).

     -- 2×4 matrix
    shape nda1 == [2, 4]

    -- 3×2×2 3D matrix
    shape nda2 == [3, 2, 2]

-}
shape : NdArray -> Shape
shape nda =
    Native.NumElm.shape nda


{-| Alias for [shape](#shape).
-}
size : NdArray -> Shape
size nda =
    shape nda


{-| Returns the number of dimensions of the [NdArray](#NdArray).

    -- 2×4×1 matrix
    ndim nda == 3

-}
ndim : NdArray -> Int
ndim nda =
    List.length <| shape nda


{-| Returns the number of elements in the [NdArray](#NdArray).

    -- 2×4×1 matrix
    length nda == 8

-}
length : NdArray -> Int
length nda =
    toLength <| shape nda


{-| Alias for [length](#length).
-}
numel : NdArray -> Int
numel nda =
    length nda


{-| Returns the [Dtype](#Dtype) of the [NdArray](#NdArray).

    -- Int32 NdArray
    dtype nda1 == Int32

    -- Float64 NdArray
    dtype nda2 == Float64
-}
dtype : NdArray -> Dtype
dtype nda =
    Native.NumElm.dtype nda



-- Pre-filled NgArray --


{-| Returns a new [NdArray](#NdArray) of given [Shape](#Shape) and [Dtype](#Dtype),
filled with zeros.

    let
        dtype =
            Int8

        shape =
            [3, 2]

    in
        zeros dtype shape
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


{-| Returns a new [NdArray](#NdArray) of given [Shape](#Shape) and [Dtype](#Dtype),
filled with ones.

    let
        dtype =
            Int8

        shape =
            [2, 4]

    in
        ones dtype shape
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


{-| Creates a [NdArray](#NdArray) with diagonal elements of a given `List`.

    let
        dtype =
            Int16

        diagList =
            [1, 2, 3]
    in
        diag dtype diagList
        -- [ [1, 0, 0]
        -- , [0, 2, 0]
        -- , [0, 0, 3]
        -- ]
-}
diagonal : Dtype -> List number -> Result String NdArray
diagonal dtype list =
    Native.NumElm.diagonal dtype list


{-| Alias for [diagonal](#diagonal).
-}
diag : Dtype -> List number -> Result String NdArray
diag dtype list =
    diagonal dtype list


{-| Creates an identity square matrix, given a size.

    let
        dtype =
            Int16

        size =
            3

    in
        identity dtype size
        -- [ [1, 0, 0]
        -- , [0, 1, 0]
        -- , [0, 0, 1]
        -- ]

-}
identity : Dtype -> Int -> Result String NdArray
identity dtype size =
    diag dtype <| List.repeat size 1


{-| Alias for [identity](#identity).
-}
eye : Dtype -> Int -> Result String NdArray
eye size dtype =
    identity size dtype


{-| Generates a random [NdArray](#NdArray) from an `uniform` distribution over [0, 1),
given a [Dtype](#Dtype), [Shape](#Shape) and a seed.

    let
        dtype =
            Float32

        shape =
            [3, 3]

        seed =
            123

    in
        rand dtype shape seed
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


{-| Generates a random [NdArray](#NdArray) from a `standard normal` distribution,
given a [Dtype](#Dtype), [Shape](#Shape) and a seed.

    let
        dtype =
            Float32

        shape =
            [3, 3]

        seed =
            123

    in
        randn dtype shape seed
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


{-| Gets the value in a specific [Location](#Location).

    let
        nda =
            ndarray Int8 [3, 2] [1, 2, 3, 4, 5, 6]

        location =
            [1, 0]

    in
        get location nda == 3

-}
get : Location -> NdArray -> Maybe number
get location nda =
    Native.NumElm.get location nda


{-| Slices the [NdArray](#NdArray) starting from a given [Location](#Location) and
ending in a given [Location](#Location) (this last one not included). It pretty much works
like [Array.prototype.slice](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice)

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

        start =
            [ 1, 1, 0 ]

        end =
            [ 3, 2, 2 ]

    in
        slice start end nda
        -- [ [ [  7,  8 ] ]
        -- , [ [ 11, 12 ] ]
        -- ]

-}
slice : Location -> Location -> NdArray -> Maybe NdArray
slice start end nda =
    Native.NumElm.slice start end nda


{-| Alias for [slice](#slice).
-}
getn : Location -> Location -> NdArray -> Maybe NdArray
getn start end nda =
    slice start end nda


{-| Sets the value in a specific [Location](#Location).

    let
        nda =
            ndarray Int8 [3, 2] [1, 2, 3, 4, 5, 6]
            -- [ [1, 2]
            -- , [3, 4]
            -- , [5, 6]
            -- ]

        newValue =
            8

        location =
            [1, 0]
    in
        set newValue location nda
        -- [ [1, 2]
        -- , [8, 4]
        -- , [5, 6]
        -- ]

-}
set : number -> Location -> NdArray -> Result String NdArray
set value location nda =
    Native.NumElm.set value location nda


{-| Joins a sequence of [NdArray](#NdArray) along an existing `axis`.

    let
        nda1 =
            ndarray Int8 [3, 2] [1, 2, 3, 4, 5, 6]
            -- [ [1, 2]
            -- , [3, 4]
            -- , [5, 6]
            -- ]

        nda2 =
            ndarray Int8 [3, 2] [7, 8, 9, 10, 11, 12]
            -- [ [ 7,  8]
            -- , [ 9, 10]
            -- , [11, 12]
            -- ]

        axis =
            1

    in
        concatenateAxis axis nda1 nda2
        -- [ [1, 2,  7,  8]
        -- , [3, 4,  9, 10]
        -- , [5, 6, 11, 12]
        -- ]

-}
concatenateAxis : Int -> NdArray -> NdArray -> Result String NdArray
concatenateAxis axis nda1 nda2 =
    Native.NumElm.concatenate axis nda1 nda2


{-| Alias for [concatenateAxis](#concatenateAxis) with `axis` set to 0.
-}
concatenate : NdArray -> NdArray -> Result String NdArray
concatenate nda1 nda2 =
    concatenateAxis 0 nda1 nda2


{-| Alias for [concatenate](#concatenate).
-}
concat : NdArray -> NdArray -> Result String NdArray
concat nda1 nda2 =
    concatenate nda1 nda2



-- Transforming NdArray --


{-| Transforms the values of the [NdArray](#NdArray) with mapping.

    let
        vec =
            vector Int8 [1, 2, 3]

        toPower2 =
            (\a _ _ -> a^2)

    in
        map toPower2 vec
        --> [1, 4, 9]

-}
map : (number -> Location -> NdArray -> a) -> NdArray -> NdArray
map callback nda =
    Native.NumElm.map callback nda


{-| Returns a new [NdArray](#NdArray) with `axes` transposed.
This function slighly differs from the way NumPy [transposes](https://docs.scipy.org/doc/numpy-1.13.0/reference/generated/numpy.ndarray.transpose.html)

    let
        A =
            matrix Float32
                   [ [1, 2, 3]
                   , [4, 5, 6]
                   ]

        -- 3×2,     [1] swaps 1st and 2nd dimensions            --> 2×3
        -- 3×2×4,   [2] swaps 1st and 3nd dimensions            --> 4×2×3
        -- 3×2×4×5, [2, 3] swaps 1st and 3rd then 2nd and 4th   --> 4×5×3×4
        -- 3×2×4    [1, 2] swaps 1st and 2nd then 2nd and 3rd   --> 2×4×3
        -- 3×2      [1, 0] swaps 1st and 2nd then 2nd and 1st   --> 3×2
        axes =
            [ 1 ]

    in
        transposeAxes axes A
        -- [ [1, 4]
        -- , [2, 5]
        -- , [3, 6]
        -- ]


-}
transposeAxes : List Int -> NdArray -> NdArray
transposeAxes axes nda =
    Native.NumElm.transpose axes nda


{-| Permutes only the first two the dimensions, `transposeAxes [1] nda`.

    let
        A =
            matrix Float32
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
    transposeAxes [ 1 ] nda


{-| Alias for [transpose](#transpose).
-}
trans : NdArray -> NdArray
trans nda =
    transpose nda


{-| Computes the (multiplicative) inverse of a matrix, using
[Guassian Elimination](hhttps://en.wikipedia.org/wiki/Gaussian_elimination).
Only supports square matrixes.

    let
        A =
            matrix Float32
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


{-| Alias for [inverse](#inverse).
-}
inv : NdArray -> Result String NdArray
inv nda =
    inverse nda


{-| Computes the [Moore-Penrose](https://en.wikipedia.org/wiki/Moore–Penrose_inverse) pseudo-inverse of a matrix.

    -- TODO

-}
pinv : NdArray -> NdArray
pinv nda =
    NdArray


{-| Computes [Singular Value Decomposition](https://en.wikipedia.org/wiki/Singular-value_decomposition).

    -- TODO

-}
svd : NdArray -> NdArray
svd nda =
    NdArray


{-| Computes the eigenvalues and right eigenvectors of a square [NdArray](#NdArray).

    -- TODO

-}
eig : NdArray -> NdArray
eig nda =
    NdArray



-- Arithmetic operations --


{-| Adds arguments, element-wise.

    let
        A =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        B =
            matrix Int8
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


{-| Adds scalar, element-wise.

    let
        A =
            matrix Int8
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


{-| Substracts arguments, element-wise.

    let
        A =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        B =
            matrix Int8
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


{-| Alias for [subtract](#subtract).
-}
sub : NdArray -> NdArray -> Result String NdArray
sub nda1 nda2 =
    subtract nda1 nda2


{-| Substracts scalar, element-wise.

    let
        A =
            matrix Int8
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


{-| Multiplies arguments, element-wise.

    let
        A =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        B =
            matrix Int8
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


{-| Alias for [multiply](#multiply).
-}
mul : NdArray -> NdArray -> Result String NdArray
mul nda1 nda2 =
    multiply nda1 nda2


{-| Multiplies scalar, element-wise.

    let
        A =
            matrix Int8
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


{-| Devides arguments, element-wise.

    let
        A =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        B =
            matrix Int8
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


{-| Alias for [divide](#divide).
-}
div : NdArray -> NdArray -> Result String NdArray
div nda1 nda2 =
    divide nda1 nda2


{-| Devides scalar, element-wise.

    let
        A =
            matrix Int8
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


{-| [NdArray](#NdArray) elements raised to power of second [NdArray](#NdArray), element-wise.

    let
        A =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        B =
            matrix Int8
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


{-| Alias for [power](#power).
-}
pow : NdArray -> NdArray -> Result String NdArray
pow nda1 nda2 =
    power nda1 nda2


{-| [NdArray](#NdArray) elements raised to the power of an scalar, element-wise.

    let
        A =
            matrix Int8
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


{-| Returns element-wise remainder of division.

    let
        A =
            matrix Int8
                   [ [1,  2]
                   , [9, 53]
                   ]

        B =
            matrix Int8
                   [ [5, 2]
                   , [3, 3]
                   ]

    in
        mod A B
        -- [ [1, 0]
        -- , [0, 2]
        -- ]

-}
mod : NdArray -> NdArray -> Result String NdArray
mod nda1 nda2 =
    Native.NumElm.elementWise (%) nda1 nda2


{-| Returns element-wise remainder of division by scalar.

    let
        A =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   , [5, 6]
                   ]

    in
        A .% 2
        -- [ [1, 0]
        -- , [1, 0]
        -- , [1, 0]
        -- ]

-}
(.%) : NdArray -> Int -> NdArray
(.%) nda num =
    map (\val _ _ -> val % num) nda



-- Root and Logarithm --


{-| Returns the positive square-root of a [NdArray](#NdArray), element-wise.

    let
        A =
            matrix Float32
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


{-| Logarithm given a `base`, element-wise.

    let
        A =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

        base =
            3

    in
        logBase base A
        -- [ [0, 0.63]
        -- , [1, 1.26]
        -- ]

-}
logBase : Float -> NdArray -> NdArray
logBase base nda =
    map (\val _ _ -> Basics.logBase base val) nda


{-| Natural logarithm, `base e`, element-wise.

    let
        A =
            matrix Float32
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


{-| Logarithm `base 2`, element-wise.

    let
        A =
            matrix Float32
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


{-| Logarithm `base 10`, element-wise.

    let
        A =
            matrix Float32
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


{-| Calculates the exponential of all elements in the [NdArray](#NdArray).

    let
        A =
            matrix Int8
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


{-| Dot product of two [NdArray](#NdArray). Only supports square matrixes

    let
        -- 4×3 matrix
        A =
            matrix Int16
                   [ [1, 2, 3]
                   , [4, 5, 6]
                   , [7, 8, 9]
                   , [3, 1, 1]
                   ]

        -- 3×2 matrix
        B =
            matrix Int16
                   [ [4, 1]
                   , [5, 3]
                   , [2, 6]
                   ]

    in
        -- 4×3 (dot) 3×2 == 4×2
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



-- Round off --


{-| Evenly rounds to the given number of decimals.

    let
        A =
            matrix Float32
                   [ [ 1.4564, -2.1271]
                   , [-3.6544,  4.3221]
                   ]

        decimals =
            2

    in
        around decimals A
        -- [ [ 1.46, -2.13]
        -- , [-3.65,  4.32]
        -- ]

-}
around : Int -> NdArray -> NdArray
around decimals nda =
    map (\val _ _ -> roundTo decimals val) nda


{-| Alias for [around](#around) decimals set to 0.
-}
round : NdArray -> NdArray
round nda =
    around 0 nda


{-| Returns the ceiling of the [NdArray](#NdArray), element-wise.

    let
        A =
            matrix Float32
                   [ [ 1.4564, -2.1271]
                   , [-3.6544,  4.3221]
                   ]

    in
        ceil A
        -- [ [ 2, -2]
        -- , [-4,  5]
        -- ]

-}
ceil : NdArray -> NdArray
ceil nda =
    map (\val _ _ -> Basics.ceiling val) nda


{-| Returns the floor of the [NdArray](#NdArray), element-wise.

    let
        A =
            matrix Float32
                   [ [ 1.4564, -2.1271]
                   , [-3.6544,  4.3221]
                   ]

    in
        floot A
        -- [ [ 2, -2]
        -- , [-3,  5]
        -- ]

-}
floor : NdArray -> NdArray
floor nda =
    map (\val _ _ -> Basics.floor val) nda


{-| Rounds to nearest integer towards zero.

    let
        A =
            matrix Float32
                   [ [ 1.4564, -2.1271]
                   , [-3.6544,  4.3221]
                   ]

    in
        truncate A
        -- [ [ 1, -2]
        -- , [-3,  4]
        -- ]

-}
truncate : NdArray -> NdArray
truncate nda =
    map (\val _ _ -> Basics.truncate val) nda


{-| Alias for [truncate](#truncate).
-}
trunc : NdArray -> NdArray
trunc nda =
    truncate nda


{-| Alias for [truncate](#truncate).
-}
fix : NdArray -> NdArray
fix nda =
    trunc nda



-- Aggregate functions --


{-| Element-wise maximum of a [NdArray](#NdArray).

    let
        A =
            matrix3d Int16
                     [ [ [  1, -2 ]
                       , [ -6,  3 ]
                       , [  3, -7 ]
                       ]
                     , [ [ 10, -6 ]
                       , [ -3, 12 ]
                       , [ -8,  7 ]
                       ]
                     , [ [ 0,  3 ]
                       , [ 1, 15 ]
                       , [ 5,  7 ]
                       ]
                     ]

    in
        max A == 15

-}
max : NdArray -> number
max nda =
    let
        infinity =
            1 / 0
    in
        Native.NumElm.reduce
            (\acc val _ -> Basics.max acc val)
            -infinity
            nda


{-| Returns the maximum along a given `axis`.

    let
        A =
            matrix3d Int16
                     [ [ [  1, -2 ]
                       , [ -6,  3 ]
                       , [  3, -7 ]
                       ]
                     , [ [ 10, -6 ]
                       , [ -3, 12 ]
                       , [ -8,  7 ]
                       ]
                     , [ [ 0,  3 ]
                       , [ 1, 15 ]
                       , [ 5,  7 ]
                       ]
                     ]

        axis =
            1

    in
        maxAxis axis A
        -- [ [ 3, 3 ]
        -- , [ 10, 12 ]
        -- , [ 5,  15 ]
        -- ]

-}
maxAxis : Int -> NdArray -> Result String NdArray
maxAxis axis nda =
    let
        infinity =
            1 / 0
    in
        Native.NumElm.mapAxis
            (\values _ ->
                List.foldr
                    Basics.max
                    -infinity
                    values
            )
            axis
            nda


{-| Element-wise minimum of a [NdArray](#NdArray).

    let
        A =
            matrix3d Int16
                     [ [ [  1, -2 ]
                       , [ -6,  3 ]
                       , [  3, -7 ]
                       ]
                     , [ [ 10, -6 ]
                       , [ -3, 12 ]
                       , [ -8,  7 ]
                       ]
                     , [ [ 0,  3 ]
                       , [ 1, 15 ]
                       , [ 5,  7 ]
                       ]
                     ]

    in
        min A == -8

-}
min : NdArray -> number
min nda =
    let
        infinity =
            1 / 0
    in
        Native.NumElm.reduce
            (\acc val _ -> Basics.min acc val)
            infinity
            nda


{-| Returns the minimum along a given `axis`.

    let
        A =
            matrix3d Int16
                     [ [ [  1, -2 ]
                       , [ -6,  3 ]
                       , [  3, -7 ]
                       ]
                     , [ [ 10, -6 ]
                       , [ -3, 12 ]
                       , [ -8,  7 ]
                       ]
                     , [ [ 0,  3 ]
                       , [ 1, 15 ]
                       , [ 5,  7 ]
                       ]
                     ]

        axis =
            0

    in
        minAxis axis A
        -- [ [  0, -6 ]
        -- , [ -6,  3 ]
        -- , [ -8,  7 ]
        -- ]

-}
minAxis : Int -> NdArray -> Result String NdArray
minAxis axis nda =
    let
        infinity =
            1 / 0
    in
        Native.NumElm.mapAxis
            (\values _ ->
                List.foldr
                    Basics.min
                    infinity
                    values
            )
            axis
            nda


{-| Element-wise total sum of a [NdArray](#NdArray).

    let
        A =
            matrix3d Int16
                     [ [ [  1, -2 ]
                       , [ -6,  3 ]
                       , [  3, -7 ]
                       ]
                     , [ [ 10, -6 ]
                       , [ -3, 12 ]
                       , [ -8,  7 ]
                       ]
                     , [ [ 0,  3 ]
                       , [ 1, 15 ]
                       , [ 5,  7 ]
                       ]
                     ]

    in
        sum A == 35

-}
sum : NdArray -> number
sum nda =
    Native.NumElm.reduce
        (\acc val _ -> acc + val)
        0
        nda


{-| Returns the sum of all the elements along a given `axis`.

    let
        A =
            matrix3d Int16
                     [ [ [  1, -2 ]
                       , [ -6,  3 ]
                       , [  3, -7 ]
                       ]
                     , [ [ 10, -6 ]
                       , [ -3, 12 ]
                       , [ -8,  7 ]
                       ]
                     , [ [ 0,  3 ]
                       , [ 1, 15 ]
                       , [ 5,  7 ]
                       ]
                     ]

        axis =
            2

    in
        sumAxis axis A
        -- [ [ -1, -3, -4 ]
        -- , [  4,  9, -1 ]
        -- , [  3, 16, 12 ]
        -- ]

-}
sumAxis : Int -> NdArray -> Result String NdArray
sumAxis axis nda =
    Native.NumElm.mapAxis
        (\values _ -> List.foldr (+) 0 values)
        axis
        nda


{-| Element-wise total product of a [NdArray](#NdArray).

    let
        A =
            matrix3d Int16
                     [ [ [  1, -2 ]
                       , [ -6,  3 ]
                       , [  3, -7 ]
                       ]
                     , [ [ 10, -6 ]
                       , [ -3, 12 ]
                       , [ -8,  7 ]
                       ]
                     , [ [ 1,  3 ]
                       , [ 1, 15 ]
                       , [ 5,  7 ]
                       ]
                     ]

    in
        prod A == 144027072000

-}
prod : NdArray -> number
prod nda =
    Native.NumElm.reduce
        (\acc val _ -> acc * val)
        1
        nda


{-| Returns the product of all the elements along a given `axis`.

    let
        A =
            matrix3d Int16
                     [ [ [  1, -2 ]
                       , [ -6,  3 ]
                       , [  3, -7 ]
                       ]
                     , [ [ 10, -6 ]
                       , [ -3, 12 ]
                       , [ -8,  7 ]
                       ]
                     , [ [ 1,  3 ]
                       , [ 1, 15 ]
                       , [ 5,  7 ]
                       ]
                     ]

        axis =
            2

    in
        prodAxis axis A
        -- [ [  -2, -18, -21 ]
        -- , [ -60, -36, -56 ]
        -- , [   3,  15,  35 ]
        -- ]

-}
prodAxis : Int -> NdArray -> Result String NdArray
prodAxis axis nda =
    Native.NumElm.mapAxis
        (\values _ -> List.foldr (*) 1 values)
        axis
        nda



-- Relational operators --


{-| Returns `A == B`, element-wise, with 1's (`True`) and 0's (`False`).

    let
        A =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        B =
            matrix Int16
                   [ [2, 2, 2]
                   , [5, 4, 5]
                   ]

    in
        equal A B
        -- [ [0, 1, 0]
        -- , [0, 1, 1]
        -- ]

-}
equal : NdArray -> NdArray -> Result String NdArray
equal nda1 nda2 =
    Native.NumElm.elementWise (==) nda1 nda2


{-| Alias for [equal](#equal).
-}
eq : NdArray -> NdArray -> Result String NdArray
eq nda1 nda2 =
    equal nda1 nda2


{-| Compares each element with an scalar, `nda(i) == value`.

    let
        nda =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        value =
            3

    in
        nda .== value
        -- [ [0, 0, 1]
        -- , [1, 0, 0]
        -- ]

-}
(.==) : NdArray -> number -> NdArray
(.==) nda num =
    map (\val _ _ -> val == num) nda


{-| Returns `A < B`, element-wise, with 1's (`True`) and 0's (`False`).

    let
        A =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        B =
            matrix Int16
                   [ [2, 2, 2]
                   , [5, 4, 5]
                   ]

    in
        less A B
        -- [ [1, 0, 0]
        -- , [1, 0, 0]
        -- ]

-}
less : NdArray -> NdArray -> Result String NdArray
less nda1 nda2 =
    Native.NumElm.elementWise (<) nda1 nda2


{-| Alias for [less](#less).
-}
lt : NdArray -> NdArray -> Result String NdArray
lt nda1 nda2 =
    less nda1 nda2


{-| Compares each element with an scalar, `nda(i) < value`.

    let
        nda =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        value =
            3

    in
        nda .< value
        -- [ [1, 1, 0]
        -- , [0, 0, 0]
        -- ]

-}
(.<) : NdArray -> comparable -> NdArray
(.<) nda num =
    map (\val _ _ -> val < num) nda


{-| Returns `A > B`, element-wise, with 1's (`True`) and 0's (`False`).

    let
        A =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        B =
            matrix Int16
                   [ [2, 2, 2]
                   , [5, 4, 5]
                   ]

    in
        greater A B
        -- [ [0, 0, 1]
        -- , [0, 0, 0]
        -- ]

-}
greater : NdArray -> NdArray -> Result String NdArray
greater nda1 nda2 =
    Native.NumElm.elementWise (>) nda1 nda2


{-| Alias for [greater](#greater).
-}
gt : NdArray -> NdArray -> Result String NdArray
gt nda1 nda2 =
    greater nda1 nda2


{-| Compares each element with an scalar, `nda(i) > value`.

    let
        nda =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        value =
            3

    in
        nda .> value
        -- [ [0, 0, 0]
        -- , [0, 1, 1]
        -- ]

-}
(.>) : NdArray -> comparable -> NdArray
(.>) nda num =
    map (\val _ _ -> val > num) nda


{-| Returns `A <= B`, element-wise, with 1's (`True`) and 0's (`False`).

    let
        A =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        B =
            matrix Int16
                   [ [2, 2, 2]
                   , [5, 4, 5]
                   ]

    in
        lessEqual A B
        -- [ [1, 1, 0]
        -- , [1, 1, 0]
        -- ]

-}
lessEqual : NdArray -> NdArray -> Result String NdArray
lessEqual nda1 nda2 =
    Native.NumElm.elementWise (<=) nda1 nda2


{-| Alias for [lessEqual](#lessEqual).
-}
lte : NdArray -> NdArray -> Result String NdArray
lte nda1 nda2 =
    lessEqual nda1 nda2


{-| Compares each element with an scalar, `nda(i) <= value`.

    let
        nda =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        value =
            3

    in
        nda .<= value
        -- [ [1, 1, 1]
        -- , [1, 0, 0]
        -- ]

-}
(.<=) : NdArray -> comparable -> NdArray
(.<=) nda num =
    map (\val _ _ -> val <= num) nda


{-| Returns `A >= B`, element-wise, with 1's (`True`) and 0's (`False`).

    let
        A =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        B =
            matrix Int16
                   [ [2, 2, 2]
                   , [5, 4, 5]
                   ]

    in
        greaterEqual A B
        -- [ [0, 1, 1]
        -- , [0, 1, 1]
        -- ]

-}
greaterEqual : NdArray -> NdArray -> Result String NdArray
greaterEqual nda1 nda2 =
    Native.NumElm.elementWise (>=) nda1 nda2


{-| Alias for [greaterEqual](#greaterEqual).
-}
gte : NdArray -> NdArray -> Result String NdArray
gte nda1 nda2 =
    greaterEqual nda1 nda2


{-| Compares each element with an scalar, `nda(i) >= value`.

    let
        nda =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        value =
            3

    in
        nda .>= value
        -- [ [0, 0, 1]
        -- , [1, 1, 1]
        -- ]

-}
(.>=) : NdArray -> comparable -> NdArray
(.>=) nda num =
    map (\val _ _ -> val >= num) nda


{-| Returns `A /= B`, element-wise, with 1's (`True`) and 0's (`False`).

    let
        A =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        B =
            matrix Int16
                   [ [2, 2, 2]
                   , [5, 4, 5]
                   ]

    in
        notEqual A B
        -- [ [1, 0, 1]
        -- , [1, 0, 0]
        -- ]

-}
notEqual : NdArray -> NdArray -> Result String NdArray
notEqual nda1 nda2 =
    Native.NumElm.elementWise (/=) nda1 nda2


{-| Alias for [notEqual](#notEqual).
-}
neq : NdArray -> NdArray -> Result String NdArray
neq nda1 nda2 =
    notEqual nda1 nda2


{-| Compares each element with an scalar, `nda(i) /= value`.

    let
        nda =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        value =
            3

    in
        nda .>= value
        -- [ [1, 1, 0]
        -- , [0, 1, 1]
        -- ]

-}
(./=) : NdArray -> comparable -> NdArray
(./=) nda num =
    map (\val _ _ -> val /= num) nda



-- Trigonometry functions --
{-
   sin: NdArray -> NdArray
   arcsin: NdArray -> NdArray
   asin: NdArray -> NdArray
   cos: NdArray -> NdArray
   arccos: NdArray -> NdArray
   acos: NdArray -> NdArray
   tan: NdArray -> NdArray
   arctan: NdArray -> NdArray
   atan: NdArray -> NdArray
   arctan2
   atan2
-}
-- Hyperbolic functions --
{-
   sinh
   arcsinh
   asinh
   cosh
   arccosh
   acosh
   tanh
   arctan
   atanh
-}
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


roundTo : Int -> Float -> Float
roundTo places value =
    let
        factor =
            (10 ^ places)
                |> Basics.toFloat
    in
        ((value * factor)
            |> Basics.round
            |> Basics.toFloat
        )
            / factor
