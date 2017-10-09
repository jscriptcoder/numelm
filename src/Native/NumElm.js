var _jscriptcoder$numelm$Native_NumElm = function() {

  // Imports
  var toArray       = _elm_lang$core$Native_List.toArray;
  var fromArray     = _elm_lang$core$Native_List.fromArray;
  var resultOk      = _elm_lang$core$Result$Ok;
  var resultErr     = _elm_lang$core$Result$Err;
  var maybeJust     = _elm_lang$core$Maybe$Just;
  var maybeNothing  = _elm_lang$core$Maybe$Nothing;


  /**
   * Maps dtype to TypedArray constructor.
   * @const {[key: string]: TypedArray}
   */
  var DTYPE_CONSTRUCTOR = {
    'Int8'    : Int8Array,
    'Int16'   : Int16Array,
    'Int32'   : Int32Array,
    'Float32' : Float32Array,
    'Float64' : Float64Array,
    'Uint8'   : Uint8Array,
    'Uint16'  : Uint16Array,
    'Uint32'  : Uint32Array,
    'Array'   : Array
  }

  /**
   * @class NdArray
   * @constructor
   * @param {number[]} data
   * @param {number[]} shape
   * @param {string} dtype
   * @throws {Error} Wrong shape or length
   */
  var NdArray = function (data, shape, dtype) {

    data = data || [];
    shape = shape || [1, 1];
    dtype = dtype || 'Array';

    if (!data.length) {
      throw 'NdArray#constructor: NdArray cannot be empty';
    }

    if (shape.length == 1 && shape[0] > 0) {
      shape[1] = 1; // Column vector n×1
    } else if (shape.length == 0 || shape[0] === 0) {
      throw 'NdArray#constructor: NdArray has no shape: [' + shape + ']';
    }

    var length = NdArray.toLength(shape);

    if (data.length !== length) {
      throw [
        'NdArray#constructor: The length of the storage data is ',
        data.length,
        ', but the shape says ',
        shape.join('×'), 
        '=',
        length
      ].join('');
    }

    /**
     * Data storage
     * @type TypedArray
     * @public
     */
    this.data = DTYPE_CONSTRUCTOR[dtype].from(data);

    /**
     * Shape of the NdArray
     * @type number[]
     * @public
     */
    this.shape = shape;

    /**
     * Data type
     * @type string
     * @public
     */
    this.dtype = dtype;
    
    // Calculates the stride for each dimension
    // Example: 
    //    shape = [3, 2, 5]
    //    length = 3*2*5 = 30
    //    stride[0] = 30/3        = 10
    //    stride[1] = 30/(3*2)    = 5
    //    stride[2] = 30/(3*2*5)  = 1
    //    get([2, 0, 3], ndarray) == data[10*2 + 5*0 + 1*3] == data[23]
    var res = shape.reduce(function (acc, dim) {
      acc.dims *= dim;
      acc.stride.push(acc.length / acc.dims);
      return acc;
    }, {
      dims: 1,
      stride: [],
      length: length
    });

    /**
     * Contains the strides per dimensions
     * @type number[]
     * @private
     */
    this.stride = res.stride;

    // Memoization to improve calculation of inverse
    this.toIndex.cache = {};
  }

  /**
   * String representation
   * @returns {string}
   * @public
   */
  NdArray.prototype.toString = function () {
    var length = this.data.length;
    var shape = this.shape.join('×');
    var dtype = this.dtype;
    return 'NdArray[length=' + length + ',shape=' + shape + ',dtype=' + dtype + ']'
  };

  /**
   * String representation of the data storage
   * @returns {string}
   * @public
   */
  NdArray.prototype.dataToString = function () {
    var data = [];
    this.forEach(function (value) {
      data.push(value);
    });
    return '[' + data + ']';
  };

  /**
   * String representation of the shape
   * @returns {string}
   * @public
   */
  NdArray.prototype.shapeToString = function () {
    return this.shape + '';
  }

  /**
   * Clones the instance
   * @return {NdArray}
   * @public
   */
  NdArray.prototype.clone = function () {
    var clone = Object.create(NdArray.prototype);
    clone.data = this.data.slice(0);
    clone.shape = this.shape.slice(0);
    clone.dtype = this.dtype;
    clone.stride = this.stride.slice(0);
    return clone;
  };

  /**
   * Gets the value from a specific location
   * @param {number[]} location - list of indexes for each dimension
   * @returns {number}
   * @public
   */
  NdArray.prototype.get = function (location) {
    var idx = this.toIndex(location);
    return this.data[idx];
  };

  /**
   * @public
   */
  NdArray.prototype.slice = function (start, end) {
    start = this._processSliceLocation(start, this._initialLocation());
    end = this._processSliceLocation(end, this.shape);

    var data = [];
    var shape = end.map(function (valEnd, i) { return valEnd - start[i] });
    var dtype = this.dtype;

    this.forEach(function (value) {
      data.push(value);
    }, start, end);

    if (data.length) {
      return new NdArray(data, shape, dtype);
    }
  };

  /**
   * Sets the value in a specific location (does not mutate)
   * @param {number[]} location
   * @param {number} value
   * @returns {NdArray}
   * @public
   */
  NdArray.prototype.set = function (location, value) {
    var clonedNda = this.clone();
    return clonedNda._set(location, value);
  };

  /**
   * Sets the value in a specific location (mutates NdArray)
   * @param {number[]} location
   * @param {number} value
   * @returns {NdArray}
   * @public
   */
  NdArray.prototype._set = function (location, value) {
    var idx = this.toIndex(location);
    if (this.isIndexWithinLimit(idx)) {
      this.data[idx] = value;
    }
    return this;
  };

  /**
   * Swaps values of specific locations (does not mutate)
   * @param {number[]} location1
   * @param {number[]} location2
   * @returns {NdArray}
   * @public
   */
  NdArray.prototype.swap = function (location1, location2) {
    var clonedNda = this.clone();
    return clonedNda._swap(location1, location2);
  };

  /**
   * Swaps values of specific locations (does not mutate)
   * @param {number[]} location1
   * @param {number[]} location2
   * @returns {NdArray}
   * @public
   */
  NdArray.prototype._swap = function (location1, location2) {
    var idx1 = this.toIndex(location1);
    var idx2 = this.toIndex(location2);
    if (idx1 !== idx2 && idx1 >= 0 && idx2 >= 0) {
      var tmp = this.data[idx1];
      this.data[idx1] = this.data[idx2]
      this.data[idx2] = tmp;
    }
    return this;
  };

  /**
   * Implements forEach method
   * @param {(number, number[], number, NdArray) => void} fn
   * @param {number[]} [start = [0, 0, ..., 0]]
   * @param {number[]} [end = this.shape]
   * @returns {NdArray}
   * @public
   */
  NdArray.prototype.forEach = function (fn, start, end) {
    if (!start || !this.isLocationWithinLimit(start)) start = this._initialLocation();
    if (!end || !this.isLocationWithinLimit(end)) end = this.shape;

    for (
      var location = start.slice(0);
      this._isLocationWithinLimit(location, end);
      location = this._nextLocation(location, start, end)
    ) {
      var idx = this.toIndex(location);
      var value = this.data[idx];
      fn(value, location, idx, this);
    }

    return this;
  }

  /**
   * Implements map method
   * @param {(number, number[], number, NdArray) => void} fn
   * @returns {NdArray}
   * @public
   */
  NdArray.prototype.map = function (fn) {
    var clonedNda = this.clone();
    clonedNda.data = clonedNda.data.map(function (value, idx) {
      return fn(value, clonedNda.toLocation(idx), idx, clonedNda);
    });
    return clonedNda;
  };

  /**
   * Permute the dimensions of the NdArray
   * @param {...number[]} dimsIdx
   * @returns {NdArray}
   * @public
   */
  NdArray.prototype.transpose = function () {
    var dimsIdx = NdArray.argsToArray(arguments);
    var shapeLength = this.shape.length;
    var clonedNda = this.clone();

    if (dimsIdx.length && dimsIdx.length <= shapeLength) {
      dimsIdx.forEach(function (oldIdx, newIdx) {
        if (
          typeof oldIdx === 'number' && 
          oldIdx !== newIdx && 
          oldIdx < shapeLength && 
          newIdx < shapeLength
        ) {
          // Permutates dimensions
          var tmp1 = clonedNda.shape[newIdx];
          var tmp2 = clonedNda.stride[newIdx];
          clonedNda.shape[newIdx] = clonedNda.shape[oldIdx];
          clonedNda.stride[newIdx] = clonedNda.stride[oldIdx];
          clonedNda.shape[oldIdx] = tmp1;
          clonedNda.stride[oldIdx] = tmp2;
        }
      });
    }

    return clonedNda;
  };

  /**
   * Compute the (multiplicative) inverse of a matrix
   * @see http://blog.acipo.com/matrix-inversion-in-javascript/
   * @returns {NdArray}
   * @throws {Error} Not inversable for whatever reason
   */
  NdArray.prototype.inverse = function () {

    if(this.shape.length > 2) {
      throw 'NdArray#inverse: Inverse only supported in a 2D NdArray';
    }

    if(this.shape[0] !== this.shape[1]) {
      throw 'NdArray#inverse: NdArray must be square';
    }

    // Guassian Elimination to calculate the inverse:
    // (1) 'augment' the matrix (left) by the identity (on the right)
    // (2) Turn the matrix on the left into the identity by elementary row ops
    // (3) The matrix on the right is the inverse (was the identity matrix)

    // There are 3 elemtary row ops: (b and c are here combined)
    // (a) Swap 2 rows
    // (b) Multiply a row by a scalar
    // (c) Add 2 rows
    
    var size = this.shape[0];

    //create the identity matrix (I), and a copy (C) of the original
    var C = this.clone();
    var I = NdArray.identity(size, this.dtype);

    var i, ii, j, e;

    // Perform elementary row operations
    for (i = 0; i < size; i++) {
      // get the element e on the diagonal
      e = C.get([i, i]);

      // if we have a 0 on the diagonal (we'll need to swap with a lower row)
      if (e === 0) {
          //look through every row below the i'th row
        for (ii= i + 1; ii < size; ii++) {
          //if the ii'th row has a non-0 in the i'th col
          if (C.get([ii, i]) !== 0) {
            //it would make the diagonal have a non-0 so swap it
            for(j = 0; j < size; j++) {
              C._swap([i, j], [ii, j]);
              I._swap([i, j], [ii, j]);
            }

            //don't bother checking other rows since we've swapped
            break;
          }
        }

        //get the new diagonal
        e = C.get([i, i]);

        //if it's still 0, not invertable (error)
        if(e === 0){
          throw 'NdArray#inverse: NdArray not inversable';
        }
      }
      
      // Scale this row down by e (so we have a 1 on the diagonal)
      for (j = 0; j < size; j++) {
        C._set([i, j], C.get([i, j]) / e); //apply to original matrix
        I._set([i, j], I.get([i, j]) / e); //apply to identity
      }
      
      // Subtract this row (scaled appropriately for each row) from ALL of
      // the other rows so that there will be 0's in this column in the
      // rows above and below this one
      for (ii = 0; ii < size; ii++) {
        // Only apply to other rows (we want a 1 on the diagonal)
        if (ii === i) continue;
        
        // We want to change this element to 0
        e = C.get([ii, i]);
        
        // Subtract (the row above(or below) scaled by e) from (the
        // current row) but start at the i'th column and assume all the
        // stuff left of diagonal is 0 (which it should be if we made this
        // algorithm correctly)
        for (j = 0; j < size; j++) {
          C._set([ii, j], C.get([ii, j]) - e * C.get([i, j])); //apply to original matrix
          I._set([ii, j], I.get([ii, j]) - e * I.get([i, j])); //apply to identity
        }
      }
    }
    
    //we've done all operations, C should be the identity
    //matrix I should be the inverse:
    return I;
  };

  /**
   * Performs element wise operations between NdArray with same shape
   * TODO: How about implementing broadcasting?
   * @param {NdArray} nda2
   * @param {(number, number, number[], number, NdArray, NdArray) => void} op
   * @return {number}
   * @throws {Error} Wrong shape
   * @public
   */
  NdArray.prototype.elementWise = function (nda2, op) {
    var shape1 = this.shapeToString();
    var shape2 = nda2.shapeToString();

    // TODO: broadcast the smallest shape??
    if (shape1 === shape2) {
      return this.map(function (value1, location, idx, nda1) {
        var value2 = nda2.data[idx];
        return op(
          value1, value2, 
          location, idx, 
          nda1, nda2
        );
      });
    } else {
        throw [
          'NdArray#elementWise: The shape of nda1 is ',
          this.shape.join('×'),
          ', but nda2 says ',
          nda2.shape.join('×')
        ].join('');
    }
  };

  /**
   * Dot product of NdArray
   * @param {NdArray} nda2
   * @return {NdArray}
   * @throws {Error} Wrong shape
   * @public
   */
  NdArray.prototype.dot = function (nda2) {
    var r1 = this.shape[0];
    var c1 = this.shape[1];
    var r2 = nda2.shape[0];
    var c2 = nda2.shape[1];

    if (c1 === r2) {
      var resData = Array(r1 * c2);
      var resShape = [r1, c2];
      var resDtype = this.dtype;

      var resNda = new NdArray(resData, resShape, resDtype);

      var d1 = this.data;
      var d2 = nda2.data;
      var i, j, k, sum;

      for (i = 0; i < r1; i++) {
        for (j = 0; j < c2; j++) {
          sum = 0;
          for (k = 0; k < c1; k++) {
            sum += d1[i * c1 + k] * d2[j + k * c2];
          }
          resNda.data[i * c2 + j] = sum;
        }
      }

      return resNda;

    } else {
        throw [
          'NdArray#dot: The shape of nda1 is ',
          this.shape.join('×'),
          ', but nda2 says ',
          nda2.shape.join('×')
        ].join('');
    }
  };

  /**
   * Converts a list of indexes (>1D) into a 1D index
   * @param {number[]} location
   * @return {number}
   * @public
   */
  NdArray.prototype.toIndex = function (location) {
    // Memoization
    if (this.toIndex.cache[location]) {
      return this.toIndex.cache[location];
    }

    var idx = -1;
    var length = location ? location.length : 0;
    var stride = this.stride;

    if (
      location.length === stride.length && 
      this.isLocationWithinLimit(location)
    ) {
      idx = location.reduce(function (acc, val, i) {
        return acc + (stride[i] * val);
      }, 0);
    }

    return this.toIndex.cache[location] = idx;
  };

  /**
   * Finds the location (list of coordinates) from a 1D index
   * @param {number} location
   * @return {number[]}
   * @public
   */
  NdArray.prototype.toLocation = function (index) {
    var location = [];
    var stride = this.stride;

    if (this.isIndexWithinLimit(index)) {
      var res = this.stride.reduce(function (acc, stride) {
        acc.location.push(Math.floor(acc.position / stride));
        acc.position = acc.position % stride;
        return acc;
      }, {
        location: [],
        position: index
      });

      location = res.location;
    }

    return location;
  };

  /**
   * Checks whether an index is within the limits
   * @param {number} index
   * @return {boolean}
   * @public
   */
  NdArray.prototype.isIndexWithinLimit = function (index) {
    return index >= 0 && index < this.data.length;
  }

  /**
   * Checks whether a location is within the limits of the shape
   * based on the shape
   * @param {number[]} location
   * @return {boolean}
   * @public
   */
  NdArray.prototype.isLocationWithinLimit = function (location) {
    return this._isLocationWithinLimit(location, this.shape);
  }

  /**
   * Calculates the next location
   * @param {number[]} location
   * @return {boolean}
   * @public
   */
  NdArray.prototype.nextLocation = function (location) {
    var start = this._initialLocation();
    var end = this.shape;

    return this._nextLocation(location, start, end);
  }

  /**
   * Returns an initial location [0, 0, ..., 0]
   * @return {number[]}
   * @private
   */
  NdArray.prototype._initialLocation = function () {
    return Array(this.shape.length).fill(0);
  }

  /**
   * Checks whether a location is within a specific limit
   * @param {number[]} location
   * @param {number[]} limit
   * @return {boolean}
   * @private
   */
  NdArray.prototype._isLocationWithinLimit = function (location, limit) {
    return location.reduce(function (is, dimIdx, idx) {
      return is && dimIdx >= 0 && dimIdx < limit[idx];
    }, true);
  }

  /**
   * Calculates the next location base on a starting and end location
   * @see NdArray.prototype.forEach
   * @param {number[]} location
   * @param {number[]} start
   * @param {number[]} end
   * @param {number} [idx] - current index being looked at
   * @return {boolean}
   * @private
   */
  NdArray.prototype._nextLocation = function (location, start, end, idx) {
    idx = typeof idx === 'undefined' ? location.length -1 : idx;

    if (idx >= 0) {
      location[idx]++;
      if (idx > 0 && location[idx] >= end[idx]) {
        location[idx] = start[idx];
        location = this._nextLocation(location, start, end, --idx);
      }
    }

    return location;
  }

  /**
   * @private
   */
  NdArray.prototype._processSliceLocation = function (location, elseLoc) {
    location = location || [];

    location = this.shape.map(function (shapeVal, i) {
      var locVal = location[i] ;

      if (locVal < 0) { // offset from the end
        locVal = shapeVal - newVal;
      }

      if (typeof locVal === 'number') {
        if (locVal < 0) newVal = 0;
        if (locVal > shapeVal) locVal = shapeVal;
      } else {
        locVal = elseLoc[i];
      }

      return locVal;
    });
  }

  // =============== NdArray static methods =============== //

  /**
   * Returns the length of a shape
   * @memberOf NdArray
   * @param {number[]} shape
   * @returns {number}
   * @static
   */
  NdArray.toLength = function (shape) {
    return shape.reduce(function (dim1, dim2) {
      return dim1 * dim2;
    }, 1);
  };

  /**
   * Converts an array-like into a real array
   * @memberOf NdArray
   * @param {Object} args
   * @returns {any[]}
   * @static
   */
  NdArray.argsToArray = function (args) {
    return [].slice.call(args);
  };

  /**
   * Creates a matrix with a specific diagonal
   * @memberOf NdArray
   * @param {diag} number[]
   * @param {dtype} string
   * @returns {NdArray}
   * @throws {Error} Wrong shape or length
   * @static
   */
  NdArray.diagonal = function (diag, dtype) {
    var size = diag.length;
    var length = size * size;
    var dtype = DTYPE_CONSTRUCTOR[dtype] ? dtype : 'Array';
    var shape = length ? [size, size] : [];
    var data = Array(length).fill(0);
    var nda = new NdArray(data, shape, dtype);

    // Sets the diagonal
    diag.forEach(function (value, i) {
      nda._set([i, i], value);
    });

    return nda;
  };

  /**
   * Creates an identity matrix with a specific size
   * @memberOf NdArray
   * @param {size} number
   * @param {dtype} string
   * @returns {NdArray}
   * @throws {Error} Wrong shape or length
   * @static
   */
  NdArray.identity = function (size, dtype) {
    var diag = Array(size).fill(1);
    return NdArray.diagonal(diag, dtype);
  };

  // =============== Native.NumElm =============== //


  /**
   * Instantiates a NdArray
   * @param {Dtype} tDtype
   * @param {List number} lShape   
   * @param {List number} lData
   * @returns {Result String NdArray}
   * @memberof Native.NumElm
   */
  function ndarray(tDtype, lShape, lData) {
    // Let's do some conversion, Elm to Js types
    var dtype = DTYPE_CONSTRUCTOR[tDtype.ctor] ? tDtype.ctor : 'Array';
    var shape = toArray(lShape);
    var data = toArray(lData);

    try {
      return resultOk(new NdArray(data, shape, dtype));  
    } catch(e) {
      return resultErr(e + '');
    }
    
  }

  /**
   * Returns the string representation of the ndarray
   * @param {NdArray} nda
   * @returns {string}
   * @memberof Native.NumElm
   */
  function toString(nda) {
    return nda + '';
  }

  /**
   * Returns the string representation of the internal array
   * @param {NdArray} nda
   * @returns {string}
   * @memberof Native.NumElm
   */
  function dataToString(nda) {
    return nda.dataToString();
  }

  /**
   * Gets the shape of the ndarray
   * @param {NdArray} nda
   * @returns {List number} shape of the ndarray
   * @memberof Native.NumElm
   */
  function shape(nda) {
    return fromArray(nda.shape);
  }

  /**
   * Gets the dtype of the ndarray
   * @param {NdArray} nda
   * @returns {Dtype}
   * @memberof Native.NumElm
   */
  function dtype(nda) {
    return { ctor: nda.dtype }
  }

  /**
   * Creates a matrix with a specific diagonal
   * @param {Dtype} tDtype
   * @param {List number} lDiag
   * @returns {Result String NdArray}
   * @memberof Native.NumElm
   */
  function diagonal(tDtype, lDiag) {
    var diag = toArray(lDiag);

    try {
      return resultOk(NdArray.diagonal(diag, tDtype.ctor));
    } catch (e) {
      return resultErr(e + '');
    }
  }

  /**
   * Gets the value from a specific location
   * @param {Location} tLocation
   * @param {NdArray} nda
   * @returns {Maybe Number}
   * @memberof Native.NumElm
   */
  function get(tLocation, nda) {
    var location = toArray(tLocation);
    var value;

    try {
      value = nda.get(location);
      if (typeof value === 'number') {
        return maybeJust(value);
      } else {
        throw 'There is no value in location [' + location + ']';
      }
    } catch (e) {
      return maybeNothing;
    }
  }

  function slice(tLocationStart, tLocationEnd, nda) {
    var start = toArray(tLocationStart);
    var end = toArray(tLocationEnd);

    try {
      slicedNda = nda.slice(start, end);
      if (slicedNda) {
        return maybeJust(slicedNda);
      } else {
        throw 'The location [' + start + '] does not exist';
      }
    } catch (e) {
      return maybeNothing;
    }
  }

  /**
   * Sets the value in a specific location
   * @param {number} value
   * @param {Location} tLocation
   * @param {NdArray} nda
   * @returns {Result String NdArray} new NdArray (no mutation)
   * @memberof Native.NumElm
   */
  function set(value, tLocation, nda) {
    var location = toArray(tLocation);

    try {
      if (nda.isLocationWithinLimit(location)) {
        return resultOk(nda.set(location, value));
      } else {
        throw 'The location [' + location + '] does not exist';
      }
    } catch (e) {
      return resultErr(e + '');
    }
    
  }

  function replace(slicedNda, tLocation, nda) {
    var location = toArray(tLocation);

    /*
    try {
      if (nda.isLocationWithinLimit(location)) {
        return resultOk(nda.replace(location, slicedNda));
      } else {
        throw 'The location [' + location + '] does not exist';
      }
    } catch (e) {
      return resultErr(e + '');
    }
    */

  }

  /**
   * Transforms the values of the NdArray with mapping
   * @param {(a -> Location -> NdArray -> b)} fCallback
   * @param {NdArray} nda
   * @returns {NdArray} new NdArray (no mutation)
   * @memberof Native.NumElm
   */
  function map(fCallback, nda) {
    return nda.map(function (value, location, nda) {
      var tLocation = fromArray(location);
      return A3(fCallback, value, tLocation, nda);
    });
  }

  /**
   * Transposes the NdArray (Only two dimensions --> [1, 0])
   * TODO: why not n-d??
   * @param {NdArray} nda
   * @returns {NdArray} transposed NdArray
   * @memberof Native.NumElm
   */
  function transpose(nda) {
    return nda.transpose(1);
  }

  /**
   * Inverses the NdArray (Only two dimensions)
   * @param {NdArray} nda
   * @returns {Result String NdArray} inversed NdArray
   * @memberof Native.NumElm
   */
  function inverse(nda) {
    try {
      return resultOk(nda.inverse());
    } catch (e) {
      return resultErr(e + '');
    }
  }

  /**
   * Performs element wise operations between NdArray
   * @param {(number -> number -> number)} fOperation
   * @param {NdArray} nda1
   * @param {NdArray} nda2
   * @returns {Result String NdArray}
   * @memberof Native.NumElm
   */
  function elementWise (fOperation, nda1, nda2) {
    try {
      return resultOk(nda1.elementWise(nda2, function (value1, value2) {
        return A2(fOperation, value1, value2);
      }));
    } catch (e) {
      return resultErr(e + '');
    }
  }

  /**
   * Matrix multiplication
   * @param {NdArray} nda1
   * @param {NdArray} nda2
   * @returns {Result String NdArray}
   * @memberof Native.NumElm
   */
  function dot (nda1, nda2) {
    try {
      return resultOk(nda1.dot(nda2));
    } catch (e) {
      return resultErr(e + '');
    }
  }

  return {
    ndarray     : F3(ndarray),
    toString    : toString,
    dataToString: dataToString,
    shape       : shape,
    dtype       : dtype,
    diagonal    : F2(diagonal),
    get         : F2(get),
    slice       : F3(slice),
    set         : F3(set),
    replace     : F3(replace),
    map         : F2(map),
    transpose   : transpose,
    inverse     : inverse,
    elementWise : F3(elementWise),
    dot         : F2(dot)
  };

}();