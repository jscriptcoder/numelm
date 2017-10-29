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

## API
[Here](API.md)
