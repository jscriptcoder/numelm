# NumElm
Inspired by Python package [NumPy](http://www.numpy.org/), NumElm is the fundamental package for scientific computing with Elm. The core data structure is the **NdArray**, a multidimensional container of items of the same type and size. The number of dimensions and items in an ```NdArray``` is defined by its ```Shape```, which is a list of N positive integers that specify the sizes of each dimension. The type of items in the array is specified by a separate data-type object, ```Dtype```, one of which is associated with each NdArray.

## Motivation
As a huge fan of Functional Programming, I'm extremely interested in Elm language. I'm also passionate about Machine Learning and Deep Learning. Ever since I started studying these subjects I've been trying to figure out how to mix these worlds, Frontend/Functional Programming/Elm and Machine/Deep Learning, together. **NumElm** is the first step in these quest of mine. My goal is to build a fast (as fast as the browser allows me) Machine Learning package for the Elm community.

## Something to keep in mind
I wouldn't say this package is fully ready to be use in production (not yet). Even though there are some performance optimizations, I didn't put too much effort on it this initial version. The ```NdArray``` implementation is my [own one](src/Native/NumElm.js). I'm aware of the project [scijs/ndarray](https://github.com/scijs/ndarray), which is better optmized, but it lacks of certain funcionality I needed in order to cover most of the _NumPy API_.

## How to install
Unfortunately, and because I'm [using](https://github.com/eeue56/take-home/wiki/Writing-Native) [Native](https://github.com/gabrielperales/elm-native-module) [modules](https://newfivefour.com/elm-lang-basic-native-module.html), this package couldn't make to the official Elm [repository](http://package.elm-lang.org/). Even though I totally agree with the [policy](https://www.reddit.com/r/elm/comments/73ubxo/an_explanation_of_elms_policy_on_native_code/) about Native code, I believe such package in Elm, at least at its current version 0.18, could not achieve top performance, as good as the browser would allow. Only low level code, in this case JavaScript, can do so.

First of all, you need to install [elm-install](https://github.com/gdotdesign/elm-github-install) in order to be able to install elm packages from git repos:
```bash
npm install elm-github-install -g
```
Once installed ```elm-install``` can be used instead of ```elm-package``` as a replacement. The process is well explained [here](https://github.com/gdotdesign/elm-github-install#basic-usage).

## TO-DO
1. Break NumElm API down into modules. Too many functions in just one module.

2. I'm still deciding whether to use [scijs/ndarray](https://github.com/scijs/ndarray) and extend it, or use [deeplearn.js](https://github.com/PAIR-code/deeplearnjs) which is a highly optimized hardware-accelerated JavaScript library, in order to speed up performance.

3. Write performance tests.

4. Implement:
```elm
{-| Computes the Moore-Penrose pseudo-inverse of a matrix.
-}
pinv : NdArray -> NdArray

{-| Computes Singular Value Decomposition.
-}
svd : NdArray -> NdArray

{-| Computes the eigenvalues and right eigenvectors of a square NdArray.
-}
eig : NdArray -> NdArray
```
5. Write a few examples!!

6. Consider using [ports](https://guide.elm-lang.org/interop/javascript.html) instead of Native modules.

7. Don't know yet. Any suggestion is always welcomed :wink:

## Notes
1. There are around 122 tests that covers the whole API. You can have a look in [tests](tests) folder.

2. I use [debug](debug) folder to debug functionality in the browser with breakpoints. You need to run ```elm-reactor``` in this folder, open the browser in http://localhost:8000, and then click on _Main.elm_. Open devtool, sources, and in _Main.elm_ you have your compiled Javascript.

# API
```elm
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

{-| Creates an [NdArray](#NdArray) with type [Dtype](#Dtype)
from a 1D `List`.

    -- 6×1 column vector of 16-bit signed integers.
    vector Int16 [ 1, 2, 3, 4, 5, 6 ]

-}
vector : Dtype -> List number -> Result String NdArray

{-| Creates an [NdArray](#NdArray) with type [Dtype](#Dtype)
from a 2D `List`.

    -- 2×3 matrix of 32-bit floating point numbers.
    matrix Float32
           [ [1, 2, 3]
           , [4, 5, 6]
           ]

-}
matrix : Dtype -> List (List number) -> Result String NdArray

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

{-| Returns the [Shape](#Shape) of the [NdArray](#NdArray).

     -- 2×4 matrix
    shape nda1 == [2, 4]

    -- 3×2×2 3D matrix
    shape nda2 == [3, 2, 2]

-}
shape : NdArray -> Shape

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

{-| Returns the number of elements in the [NdArray](#NdArray).

    -- 2×4×1 matrix
    length nda == 8

-}
length : NdArray -> Int

{-| Alias for [length](#length).
-}
numel : NdArray -> Int

{-| Returns the [Dtype](#Dtype) of the [NdArray](#NdArray).

    -- Int32 NdArray
    dtype nda1 == Int32

    -- Float64 NdArray
    dtype nda2 == Float64
-}
dtype : NdArray -> Dtype


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

{-| Alias for [diagonal](#diagonal).
-}
diag : Dtype -> List number -> Result String NdArray

{-| Return evenly spaced (`steps`) values within a given interval `[start, stop)`.

    let
        dtype =
            Float64

        start =
            1

        stop =
            10.5

        step =
            2.2

    in
        arangeStep dtype start stop step
        -- [ 1, 3.2, 5.4, 7.6, 9.8 ]

-}
arangeStep : Dtype -> comparable -> comparable -> comparable -> Result String NdArray

{-| Alias for [arangeStep](#arangeStep) with `step = 1`.
-}
arange : Dtype -> comparable -> comparable -> Result String NdArray

{-| Alias for [arange](#arange).
-}
range : Dtype -> comparable -> comparable -> Result String NdArray

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

{-| Alias for [identity](#identity).
-}
eye : Dtype -> Int -> Result String NdArray

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

{-| Alias for [slice](#slice).
-}
getn : Location -> Location -> NdArray -> Maybe NdArray

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

{-| Alias for [concatenateAxis](#concatenateAxis).
-}
concatAxis : Int -> NdArray -> NdArray -> Result String NdArray

{-| Alias for [concatenateAxis](#concatenateAxis) with `axis = 0`.
-}
concatenate : NdArray -> NdArray -> Result String NdArray

{-| Alias for [concatenate](#concatenate).
-}
concat : NdArray -> NdArray -> Result String NdArray


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

{-| Returns a new [NdArray](#NdArray) with `axes` transposed.
This function slighly differs from the way NumPy [transposes](https://docs.scipy.org/doc/numpy-1.13.0/reference/generated/numpy.ndarray.transpose.html)

    let
        nda =
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
        transposeAxes axes nda
        -- [ [1, 4]
        -- , [2, 5]
        -- , [3, 6]
        -- ]


-}
transposeAxes : List Int -> NdArray -> NdArray

{-| Permutes only the first two the dimensions, `transposeAxes [1] nda`.

    let
        nda =
            matrix Float32
                   [ [1, 2, 3]
                   , [4, 5, 6]
                   ]

    in
        transpose nda
        -- [ [1, 4]
        -- , [2, 5]
        -- , [3, 6]
        -- ]

-}
transpose : NdArray -> NdArray

{-| Alias for [transpose](#transpose).
-}
trans : NdArray -> NdArray

{-| Gives a new shape to a NdArray without changing its data.

    let
        -- 3×2×2
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

        -- 2×6
        nda2x6 =
            reshape nda [2, 6]

        -- 3×4
        nda3x4 =
            reshape nda [3, 4]

        -- 2×2×3
        nda3x4 =
            reshape nda [2, 2, 3]

        nda6x2 =
            reshape nda [6, 2]

    in
        -- 2×2
        dot nda2x6 nda6x2

-}
reshape : Shape -> NdArray -> Result String NdArray

{-| Calculate the absolute value, element-wise.

    let
        nda =
            matrix Float32
                   [ [-1.4,  2]
                   , [   3, -4]
                   , [ 5.1, -6]
                   ]

    in
        absolute nda
        -- [ [1.4, 2]
        -- , [  3, 4]
        -- , [5.1, 6]
        -- ]

-}
absolute : NdArray -> NdArray

{-| Alias for [absolute](#absolute).
-}
abs : NdArray -> NdArray

{-| Computes the (multiplicative) inverse of a matrix, using
[Guassian Elimination](http://mathworld.wolfram.com/GaussianElimination.html).
Only supports square matrixes.

    let
        nda =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        inverse nda
        -- [ [-2.0,  1.0]
        -- , [ 1.5, -0.5]
        -- ]

-}
inverse : NdArray -> Result String NdArray

{-| Alias for [inverse](#inverse).
-}
inv : NdArray -> Result String NdArray

{-| Computes the [Moore-Penrose](http://mathworld.wolfram.com/Moore-PenroseMatrixInverse.html) pseudo-inverse of a matrix.

    -- TODO

-}
pinv : NdArray -> NdArray

{-| Computes [Singular Value Decomposition](http://mathworld.wolfram.com/SingularValueDecomposition.html).

    -- TODO

-}
svd : NdArray -> NdArray

{-| Computes the eigenvalues and right eigenvectors of a square [NdArray](#NdArray).

    -- TODO

-}
eig : NdArray -> NdArray


-- Arithmetic operations --


{-| Adds arguments, element-wise.

    let
        nda1 =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        nda2 =
            matrix Int8
                   [ [4, 1]
                   , [5, 3]
                   ]

    in
        add nda1 nda2
        -- [ [5, 3]
        -- , [8, 7]
        -- ]

-}
add : NdArray -> NdArray -> Result String NdArray

{-| Adds scalar, element-wise.

    let
        nda =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        nda .+ 5
        -- [ [6, 7]
        -- , [8, 9]
        -- ]

-}
(.+) : NdArray -> number -> NdArray

{-| Substracts arguments, element-wise.

    let
        nda1 =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        nda2 =
            matrix Int8
                   [ [4, 1]
                   , [5, 3]
                   ]

    in
        subtract nda1 nda2
        -- [ [-3, 1]
        -- , [-2, 1]
        -- ]

-}
subtract : NdArray -> NdArray -> Result String NdArray

{-| Alias for [subtract](#subtract).
-}
sub : NdArray -> NdArray -> Result String NdArray

{-| Substracts scalar, element-wise.

    let
        nda =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        nda .- 5
        -- [ [-4, -3]
        -- , [-2, -1]
        -- ]

-}
(.-) : NdArray -> number -> NdArray

{-| Multiplies arguments, element-wise.

    let
        nda1 =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        nda2 =
            matrix Int8
                   [ [4, 1]
                   , [5, 3]
                   ]

    in
        multiply nda1 nda2
        -- [ [ 4,  2]
        -- , [15, 12]
        -- ]

-}
multiply : NdArray -> NdArray -> Result String NdArray

{-| Alias for [multiply](#multiply).
-}
mul : NdArray -> NdArray -> Result String NdArray

{-| Multiplies scalar, element-wise.

    let
        nda =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        nda .* 5
        -- [ [ 5, 10]
        -- , [15, 20]
        -- ]

-}
(.*) : NdArray -> number -> NdArray

{-| Devides arguments, element-wise.

    let
        nda1 =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        nda2 =
            matrix Int8
                   [ [4, 1]
                   , [5, 3]
                   ]

    in
        divide nda1 nda2
        -- [ [1/4,   2]
        -- , [3/5, 4/3]
        -- ]

-}
divide : NdArray -> NdArray -> Result String NdArray

{-| Alias for [divide](#divide).
-}
div : NdArray -> NdArray -> Result String NdArray

{-| Devides scalar, element-wise.

    let
        nda =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        nda ./ 5
        -- [ [1/5, 2/5]
        -- , [3/5, 4/5]
        -- ]

-}
(./) : NdArray -> Float -> NdArray

{-| [NdArray](#NdArray) elements raised to power of second [NdArray](#NdArray), element-wise.

    let
        nda1 =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

        nda2 =
            matrix Int8
                   [ [2, 2]
                   , [3, 4]
                   ]

    in
        divide nda1 nda2
        -- [ [ 1,   4]
        -- , [27, 256]
        -- ]

-}
power : NdArray -> NdArray -> Result String NdArray

{-| Alias for [power](#power).
-}
pow : NdArray -> NdArray -> Result String NdArray

{-| [NdArray](#NdArray) elements raised to the power of an scalar, element-wise.

    let
        nda =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        nda .^ 2
        -- [ [1,  4]
        -- , [9, 16]
        -- ]

-}
(.^) : NdArray -> number -> NdArray

{-| Returns element-wise remainder of division.

    let
        nda1 =
            matrix Int8
                   [ [1,  2]
                   , [9, 53]
                   ]

        nda2 =
            matrix Int8
                   [ [5, 2]
                   , [3, 3]
                   ]

    in
        mod nda1 nda2
        -- [ [1, 0]
        -- , [0, 2]
        -- ]

-}
mod : NdArray -> NdArray -> Result String NdArray

{-| Returns element-wise remainder of division by scalar.

    let
        nda =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   , [5, 6]
                   ]

    in
        nda .% 2
        -- [ [1, 0]
        -- , [1, 0]
        -- , [1, 0]
        -- ]

-}
(.%) : NdArray -> Int -> NdArray


-- Root and Logarithm --


{-| Returns the positive square-root of a [NdArray](#NdArray), element-wise.

    let
        nda =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        sqrt nda
        -- [ [   1, 1.41]
        -- , [1.73,    2]
        -- ]

-}
sqrt : NdArray -> NdArray

{-| Logarithm given a `base`, element-wise.

    let
        nda =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

        base =
            3

    in
        logBase base nda
        -- [ [0, 0.63]
        -- , [1, 1.26]
        -- ]

-}
logBase : Float -> NdArray -> NdArray

{-| Natural logarithm, `base e`, element-wise.

    let
        nda =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        log nda
        -- [ [   0, 0.69]
        -- , [1.09, 1.38]
        -- ]

-}
log : NdArray -> NdArray

{-| Logarithm `base 2`, element-wise.

    let
        nda =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        log2 nda
        -- [ [   0, 1]
        -- , [1.58, 2]
        -- ]

-}
log2 : NdArray -> NdArray

{-| Logarithm `base 10`, element-wise.

    let
        nda =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        log10 nda
        -- [ [   0, 0.3]
        -- , [0.47, 0.6]
        -- ]

-}
log10 : NdArray -> NdArray

{-| Calculates the exponential of all elements in the [NdArray](#NdArray).

    let
        nda =
            matrix Int8
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        exp nda
        -- [ [ 2.71,  7.38]
        -- , [20.08, 54.59]
        -- ]

-}
exp : NdArray -> NdArray


-- Matrix mutiplication --


{-| Dot product of two [NdArray](#NdArray). Only supports square matrixes

    let
        -- 4×3 matrix
        nda1 =
            matrix Int16
                   [ [1, 2, 3]
                   , [4, 5, 6]
                   , [7, 8, 9]
                   , [3, 1, 1]
                   ]

        -- 3×2 matrix
        nda2 =
            matrix Int16
                   [ [4, 1]
                   , [5, 3]
                   , [2, 6]
                   ]

    in
        -- 4×3 (dot) 3×2 == 4×2
        dot nda nda2
        -- [ [1×4 + 2×5 + 3×2, 1×1 + 2×3 + 3×6]
        -- , [4×4 + 5×5 + 6×2, 4×1 + 5×3 + 6×6]
        -- , [7×4 + 8×5 + 9×2, 7×1 + 8×3 + 9×6]
        -- , [3×4 + 1×5 + 1×2, 3×1 + 1×3 + 1×6]
        -- ]

-}
dot : NdArray -> NdArray -> Result String NdArray


-- Round off --


{-| Evenly rounds to the given number of decimals.

    let
        nda =
            matrix Float32
                   [ [ 1.4564, -2.1271]
                   , [-3.6544,  4.3221]
                   ]

        decimals =
            2

    in
        around decimals nda
        -- [ [ 1.46, -2.13]
        -- , [-3.65,  4.32]
        -- ]

-}
around : Int -> NdArray -> NdArray

{-| Alias for [around](#around) `decimals = 0`.
-}
round : NdArray -> NdArray

{-| Returns the ceiling of the [NdArray](#NdArray), element-wise.

    let
        nda =
            matrix Float32
                   [ [ 1.4564, -2.1271]
                   , [-3.6544,  4.3221]
                   ]

    in
        ceil nda
        -- [ [ 2, -2]
        -- , [-4,  5]
        -- ]

-}
ceil : NdArray -> NdArray

{-| Returns the floor of the [NdArray](#NdArray), element-wise.

    let
        nda =
            matrix Float32
                   [ [ 1.4564, -2.1271]
                   , [-3.6544,  4.3221]
                   ]

    in
        floot nda
        -- [ [ 2, -2]
        -- , [-3,  5]
        -- ]

-}
floor : NdArray -> NdArray

{-| Rounds to nearest integer towards zero.

    let
        nda =
            matrix Float32
                   [ [ 1.4564, -2.1271]
                   , [-3.6544,  4.3221]
                   ]

    in
        truncate nda
        -- [ [ 1, -2]
        -- , [-3,  4]
        -- ]

-}
truncate : NdArray -> NdArray

{-| Alias for [truncate](#truncate).
-}
trunc : NdArray -> NdArray

{-| Alias for [truncate](#truncate).
-}
fix : NdArray -> NdArray


-- Aggregate functions --


{-| Element-wise maximum of a [NdArray](#NdArray).

    let
        nda =
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
        max nda == 15

-}
max : NdArray -> number

{-| Returns the maximum along a given `axis`.

    let
        nda =
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
        maxAxis axis nda
        -- [ [ 3, 3 ]
        -- , [ 10, 12 ]
        -- , [ 5,  15 ]
        -- ]

-}
maxAxis : Int -> NdArray -> Result String NdArray

{-| Element-wise minimum of a [NdArray](#NdArray).

    let
        nda =
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
        min nda == -8

-}
min : NdArray -> number

{-| Returns the minimum along a given `axis`.

    let
        nda =
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
        minAxis axis nda
        -- [ [  0, -6 ]
        -- , [ -6,  3 ]
        -- , [ -8,  7 ]
        -- ]

-}
minAxis : Int -> NdArray -> Result String NdArray

{-| Element-wise total sum of a [NdArray](#NdArray).

    let
        nda =
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
        sum nda == 35

-}
sum : NdArray -> number

{-| Returns the sum of all the elements along a given `axis`.

    let
        nda =
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
        sumAxis axis nda
        -- [ [ -1, -3, -4 ]
        -- , [  4,  9, -1 ]
        -- , [  3, 16, 12 ]
        -- ]

-}
sumAxis : Int -> NdArray -> Result String NdArray

{-| Element-wise total product of a [NdArray](#NdArray).

    let
        nda =
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
        prod nda == 144027072000

-}
prod : NdArray -> number

{-| Returns the product of all the elements along a given `axis`.

    let
        nda =
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
        prodAxis axis nda
        -- [ [  -2, -18, -21 ]
        -- , [ -60, -36, -56 ]
        -- , [   3,  15,  35 ]
        -- ]

-}
prodAxis : Int -> NdArray -> Result String NdArray

{-| Matrix ([Frobenius Norm](http://mathworld.wolfram.com/FrobeniusNorm.html)) or vector ([L2-Norm](http://mathworld.wolfram.com/L2-Norm.html)) norm
(also called Euclidean norm).

    let
        nda =
            matrix Float32
                   [ [ 10, -6 ]
                   , [ -3, 12 ]
                   , [ -8,  7 ]
                   ]

    in
        norm nda == 20.049937656

-}
norm : NdArray -> Float

{-| Returns the norm along a given `axis`
-}
normAxis : Int -> NdArray -> Result String NdArray


-- Relational operators --


{-| Returns `nda1 == nda2`, element-wise, with 1's (`True`) and 0's (`False`).

    let
        nda1 =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        nda2 =
            matrix Int16
                   [ [2, 2, 2]
                   , [5, 4, 5]
                   ]

    in
        equal nda1 nda2
        -- [ [0, 1, 0]
        -- , [0, 1, 1]
        -- ]

-}
equal : NdArray -> NdArray -> Result String NdArray

{-| Alias for [equal](#equal).
-}
eq : NdArray -> NdArray -> Result String NdArray

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

{-| Returns `nda1 < nda2`, element-wise, with 1's (`True`) and 0's (`False`).

    let
        nda1 =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        nda2 =
            matrix Int16
                   [ [2, 2, 2]
                   , [5, 4, 5]
                   ]

    in
        less nda1 nda2
        -- [ [1, 0, 0]
        -- , [1, 0, 0]
        -- ]

-}
less : NdArray -> NdArray -> Result String NdArray

{-| Alias for [less](#less).
-}
lt : NdArray -> NdArray -> Result String NdArray

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

{-| Returns `nda1 > nda2`, element-wise, with 1's (`True`) and 0's (`False`).

    let
        nda1 =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        nda2 =
            matrix Int16
                   [ [2, 2, 2]
                   , [5, 4, 5]
                   ]

    in
        greater nda1 nda2
        -- [ [0, 0, 1]
        -- , [0, 0, 0]
        -- ]

-}
greater : NdArray -> NdArray -> Result String NdArray

{-| Alias for [greater](#greater).
-}
gt : NdArray -> NdArray -> Result String NdArray

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

{-| Returns `nda1 <= nda2`, element-wise, with 1's (`True`) and 0's (`False`).

    let
        nda1 =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        nda2 =
            matrix Int16
                   [ [2, 2, 2]
                   , [5, 4, 5]
                   ]

    in
        lessEqual nda1 nda2
        -- [ [1, 1, 0]
        -- , [1, 1, 0]
        -- ]

-}
lessEqual : NdArray -> NdArray -> Result String NdArray

{-| Alias for [lessEqual](#lessEqual).
-}
lte : NdArray -> NdArray -> Result String NdArray

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

{-| Returns `nda1 >= nda2`, element-wise, with 1's (`True`) and 0's (`False`).

    let
        nda1 =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        nda2 =
            matrix Int16
                   [ [2, 2, 2]
                   , [5, 4, 5]
                   ]

    in
        greaterEqual nda1 nda2
        -- [ [0, 1, 1]
        -- , [0, 1, 1]
        -- ]

-}
greaterEqual : NdArray -> NdArray -> Result String NdArray

{-| Alias for [greaterEqual](#greaterEqual).
-}
gte : NdArray -> NdArray -> Result String NdArray

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

{-| Returns `nda1 /= nda2`, element-wise, with 1's (`True`) and 0's (`False`).

    let
        nda1 =
            matrix Int16
                   [ [1, 2, 3]
                   , [3, 4, 5]
                   ]

        nda2 =
            matrix Int16
                   [ [2, 2, 2]
                   , [5, 4, 5]
                   ]

    in
        notEqual nda1 nda2
        -- [ [1, 0, 1]
        -- , [1, 0, 0]
        -- ]

-}
notEqual : NdArray -> NdArray -> Result String NdArray

{-| Alias for [notEqual](#notEqual).
-}
neq : NdArray -> NdArray -> Result String NdArray

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

{-| Alias for [(./=)](#./=).
-}
(.!=) : NdArray -> comparable -> NdArray

{-| Alias for [(./=)](#./=).
-}
(.~=) : NdArray -> comparable -> NdArray


-- Logical operators --

{-| Compute the truth value of nda1 `AND` nda2, element-wise.

    let
        nda1 =
            matrix Int16
                   [ [ 1, 2, 3 ]
                   , [ 3, 0, 5 ]
                   ]

        nda2 =
            matrix Int16
                   [ [ 0, 2, 2 ]
                   , [ 5, 4, 0 ]
                   ]

    in
        and nda1 nda2
        -- [ [0, 1, 1]
        -- , [1, 0, 0]
        -- ]

-}
and : NdArray -> NdArray -> Result String NdArray

{-| Compute the truth value of nda1 `OR` nda2, element-wise.

    let
        nda1 =
            matrix Int16
                   [ [ 1, 2, 3 ]
                   , [ 3, 0, 5 ]
                   ]

        nda2 =
            matrix Int16
                   [ [ 0, 2, 2 ]
                   , [ 5, 0, 0 ]
                   ]

    in
        or nda1 nda2
        -- [ [1, 1, 1]
        -- , [1, 0, 1]
        -- ]

-}
or : NdArray -> NdArray -> Result String NdArray

{-| Compute the truth value of `NOT` nda, element-wise.

    let
        nda =
            matrix Int16
                   [ [ 1, 2, 0 ]
                   , [ 3, 0, 5 ]
                   ]

    in
        not nda
        -- [ [0, 0, 1]
        -- , [0, 1, 0]
        -- ]

-}
not : NdArray -> NdArray

{-| Compute the truth value of nda1 `XOR` nda2, element-wise.

    let
        nda1 =
            matrix Int16
                   [ [ 1, 2, 3 ]
                   , [ 3, 0, 5 ]
                   ]

        nda2 =
            matrix Int16
                   [ [ 0, 2, 2 ]
                   , [ 5, 0, 0 ]
                   ]

    in
        xor nda1 nda2
        -- [ [1, 0, 0]
        -- , [0, 0, 1]
        -- ]

-}
xor : NdArray -> NdArray -> Result String NdArray

{-| Test whether any NdArray element evaluates to `True`.

    let
        nda =
            matrix Int16
                   [ [ 1, 2, 0 ]
                   , [ 3, 0, 5 ]
                   ]

    in
        any nda == True

-}
any : NdArray -> Bool

{-| Test whether all NdArray elements evaluate to `True`.

    let
        nda =
            matrix Int16
                   [ [ 1, 2, 0 ]
                   , [ 3, 0, 5 ]
                   ]

    in
        all nda == False

-}
all : NdArray -> Bool


-- Trigonometry functions --

{-| Trigonometric sine, element-wise.

    let
        nda =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        sin nda
        -- [ [0.84,  0.91]
        -- , [0.14, -0.75]
        -- ]

-}
sin : NdArray -> NdArray

{-| Inverse sine, element-wise.

    let
        nda =
            matrix Float32
                   [ [0.1, 0.5]
                   , [0.8,   1]
                   ]

    in
        arcsin nda
        -- [ [ 0.1, 0.52]
        -- , [0.92, 1.57]
        -- ]

-}
arcsin : NdArray -> NdArray

{-| Alias for [arcsin](#arcsin).
-}
asin : NdArray -> NdArray

{-| Cosine element-wise.

    let
        nda =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        cos nda
        -- [ [ 0.54,   0.41]
        -- , [-0.98, -0.65]
        -- ]

-}
cos : NdArray -> NdArray

{-| Inverse Cosine, element-wise.

    let
        nda =
            matrix Float32
                   [ [0.1, 0.5]
                   , [0.8,   1]
                   ]

    in
        arccos nda
        -- [ [1.47, 1.04]
        -- , [0.64,    0]
        -- ]

-}
arccos : NdArray -> NdArray

{-| Alias for [arccos](#arccos).
-}
acos : NdArray -> NdArray

{-| Compute tangent element-wise.

    let
        nda =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        tan nda
        -- [ [ 1.55, -2.18]
        -- , [-0.14,  1.15]
        -- ]

-}
tan : NdArray -> NdArray

{-| Trigonometric inverse tangent, element-wise.

    let
        nda =
            matrix Float32
                   [ [0.1, 0.5]
                   , [0.8,   1]
                   ]

    in
        arccos nda
        -- [ [ 0.1, 0.46]
        -- , [0.67, 0.78]
        -- ]

-}
arctan : NdArray -> NdArray

{-| Alias for [arctan](#arctan).
-}
atan : NdArray -> NdArray

{-| Element-wise arc tangent of nda1/nda2 choosing the quadrant correctly.

    let
        nda1 =
            matrix Float32
                   [ [ 9, 2 ]
                   , [ 7, 4 ]
                   ]

        nda2 =
            matrix Float32
                   [ [ 3, 8 ]
                   , [ 4, 6 ]
                   ]

    in
        arctan2 nda1 nda2
        -- [ [ 1.25, 0.24]
        -- , [1.05, 0.58]
        -- ]

-}
arctan2 : NdArray -> NdArray -> Result String NdArray

{-| Alias for [arctan2](#arctan2).
-}
atan2 : NdArray -> NdArray -> Result String NdArray


-- Hyperbolic functions --

{-| Hyperbolic sine, element-wise.

    let
        nda =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        sinh nda
        -- [ [ 1.17,  3.62]
        -- , [10.01, 27.28]
        -- ]

-}
sinh : NdArray -> NdArray

{-| Inverse hyperbolic sine element-wise.

    let
        nda =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        arcsinh nda
        -- [ [0.88, 1.44]
        -- , [1.81, 2.09]
        -- ]

-}
arcsinh : NdArray -> NdArray

{-| Alias for [arcsinh](#arcsinh).
-}
asinh : NdArray -> NdArray

{-| Hyperbolic cosine, element-wise.

    let
        nda =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        cosh nda
        -- [ [1.54, 10.06]
        -- , [3.76,  27.3]
        -- ]

-}
cosh : NdArray -> NdArray

{-| Inverse hyperbolic cosine, element-wise.

    let
        nda =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        arccosh nda
        -- [ [   0, 1.31]
        -- , [1.76, 2.06]
        -- ]

-}
arccosh : NdArray -> NdArray

{-| Alias for [arccosh](#arccosh).
-}
acosh : NdArray -> NdArray

{-| Compute hyperbolic tangent element-wise.

    let
        nda =
            matrix Float32
                   [ [1, 2]
                   , [3, 4]
                   ]

    in
        tanh nda
        -- [ [0.76,  0.96]
        -- , [   1,     1]
        -- ]

-}
tanh : NdArray -> NdArray

{-| Inverse hyperbolic tangent element-wise.

    let
        nda =
            matrix Float32
                   [ [0.1, 0.2]
                   , [0.3, 0.4]
                   ]

    in
        arctanh nda
        -- [ [ 0.1,  0.2]
        -- , [0.31, 0.42]
        -- ]

-}
arctanh : NdArray -> NdArray

{-| Alias for [arctanh](#arctanh).
-}
atanh : NdArray -> NdArray
```
