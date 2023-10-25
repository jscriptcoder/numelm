# NumElm
Inspired by Python package [NumPy](http://www.numpy.org/), NumElm is the fundamental package for scientific computing with Elm. The core data structure is the **NdArray**, a multidimensional container of items of the same type and size. The number of dimensions and items in an ```NdArray``` is defined by its ```Shape```, which is a list of N positive integers that specify the sizes of each dimension. The type of items in the array is specified by a separate data-type object, ```Dtype```, one of which is associated with each NdArray.

## Motivation
As a huge fan of Functional Programming, I'm extremely interested in Elm language. I'm also passionate about Machine Learning and Deep Learning. Ever since I started studying these subjects I've been trying to figure out how to mix these worlds, Frontend/Functional Programming/Elm and Machine/Deep Learning, together. **NumElm** is the first step in these quest of mine. My goal is to build a fast (as fast as the browser allows me) Machine Learning package for the Elm community.

## Something to keep in mind
I wouldn't say this package is fully ready to be use in production (not yet). Even though there are some performance optimizations, I didn't put too much effort on this initial version. The ```NdArray``` implementation is my [own one](src/Native/NumElm.js). I'm aware of the project [scijs/ndarray](https://github.com/scijs/ndarray), which is better optmized, but it lacks of certain funcionality I needed in order to cover most of the _NumPy API_.

## How to install
Unfortunately, and because I'm using Native modules, this package couldn't make it to the official Elm [repository](http://package.elm-lang.org/). Even though I totally agree with the [policy](https://www.reddit.com/r/elm/comments/73ubxo/an_explanation_of_elms_policy_on_native_code/) about Native code, I believe such package in Elm, at least at its current version 0.18, could not achieve top performance, as good as the browser would allow. Only low level code, in this case JavaScript, can do so.

First of all, you need to install [elm-install](https://github.com/gdotdesign/elm-github-install) in order to be able to install elm packages from git repos:
```bash
$ npm install elm-github-install -g
```
Once installed, ```elm-install``` can be used instead of ```elm-package``` as a replacement. The process is well explained [here](https://github.com/gdotdesign/elm-github-install#basic-usage).

Creates `elm-package.json` with basic modules and add `jscriptcoder/numelm` as follow:
```
{
  ...
  "dependencies": {
    "elm-lang/core": "5.0.0 <= v < 6.0.0",
    "elm-lang/svg": "2.0.0 <= v < 3.0.0",
    "elm-lang/dom": "1.1.1 <= v < 2.0.0"
    "jscriptcoder/numelm": "1.0.0 <= v < 2.0.0"
  }
  "dependency-sources": {
      "jscriptcoder/numelm": {
          "url": "https://github.com/jscriptcoder/numelm",
          "ref": "master"
      }
  },
  ...
}
```
Then run
```bash
$ elm-install

Resolving packages...
  ▶ Getting updates for: elm-lang/core
  ▶ Getting updates for: elm-lang/html
  ▶ Getting updates for: elm-lang/virtual-dom
  ▶ Getting updates for: jscriptcoder/numelm
Solving dependencies...
  ● elm-lang/core - https://github.com/elm-lang/core (5.1.1)
  ● elm-lang/html - https://github.com/elm-lang/html (2.0.0)
  ● jscriptcoder/numelm - https://github.com/jscriptcoder/numelm at master (1.0.0)
  ● elm-lang/virtual-dom - https://github.com/elm-lang/virtual-dom (2.0.4)
```
## Run tests
You need to first install ```elm-test``` and then run it. It'll automatically pick up all the tests in [tests](tests) folder 
```bash
$ npm install elm-test -g
```
```bash
$ elm-test

elm-test 0.18.9
---------------

Running 122 tests. To reproduce these results, run: elm-test --fuzz 100 --seed 2042360958

TEST RUN PASSED

Duration: 498 ms
Passed:   122
Failed:   0
```

## How to use
Easy, just import ```NumElm``` and use it :smirk:
```elm
module Main exposing (..)

import Html exposing (text)
import NumElm exposing (..)


main =
    let
        matrixResult =
            NumElm.ndarray
                Float64
                [ 2, 2 ]
                [ 1, 2, 3, 4, 5, 6 ]
    in
        case matrixResult of
            Ok matrix ->
                matrix
                    |> NumElm.toString
                    |> text

            Err msg ->
                text msg
```

## TO-DO
1. Break _NumElm API_ down into modules. Too many functions in just one module.

2. I'm still deciding whether to use [scijs/ndarray](https://github.com/scijs/ndarray) and extend it, or use [deeplearn.js](https://github.com/PAIR-code/deeplearnjs) which is a highly optimized hardware-accelerated JavaScript library, in order to speed up performance.

3. Write performance tests.

4. Show better API docs. Investigate how to generate the markdown like [docs-preview](http://package.elm-lang.org/help/docs-preview) does.

5. Implement:
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
6. Write a few examples!!

7. Consider using [ports](https://guide.elm-lang.org/interop/javascript.html) instead of Native modules.

8. Don't know yet. Any suggestion is always welcomed :wink:

## Notes
1. There are around 122 tests that covers the whole API. You can have a look in [tests](tests) folder to see how to use the API. Each test could be considered as an example.

2. I use [debug](debug) folder to debug functionality in the browser with breakpoints. You need to run ```elm-reactor``` in this folder, open the browser in http://localhost:8000, and then click on _Main.elm_. Open devtool, sources, and in _Main.elm_ you have your compiled Javascript.

### See NumElm API [here](http://elm-directory.herokuapp.com/package/jscriptcoder/numelm/1.0.0/NumElm)

<!-- sort 1 -->
