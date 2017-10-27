# NumElm
Inspired by [NumPy](http://www.numpy.org/), NumElm is the fundamental package for scientific computing with Elm. The core data structure is the **NdArray**, a multidimensional container of items of the same type and size. The number of dimensions and items in an _NdArray_ is defined by its _Shape_, which is a list of N positive integers that specify the sizes of each dimension. The type of items in the array is specified by a separate data-type object, _Dtype_, one of which is associated with each NdArray.

## Motivation
As a huge fan of Functional Programming, I'm extremely interested in Elm language. I'm also passionate about Machine Learning and Deep Learning. Ever since I started studying these subjects I've been trying to figure out how to mix these worlds, Frontend/Functional Programming/Elm and Machine/Deep Learning, together. **NumElm** is the first step in these _quest_ of mine. My goal is to build a fast (as fast as the browser allows me) Machine Learning package for the Elm community.

## Something to keep in mind
I wouldn't say this package is fully ready to be use in _production_ (not yet). Even though there are some performance optimizations, I didn't put too much effort on it. The _NdArray_ implementation is my own one. I'm aware of the project [scijs/ndarray](https://github.com/scijs/ndarray), which is better optmized, but it lacks of certain funcionality I needed in order to cover most of the _NumPy API_.

## TO-DO
1. I'm still deciding whether to use [scijs/ndarray](https://github.com/scijs/ndarray) and extend it, or use [deeplearn.js](https://github.com/PAIR-code/deeplearnjs) which is a highly optimized hardware-accelerated JavaScript library, in order to speed up performance.

2. Implement:
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
