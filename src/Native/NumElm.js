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
      throw 'NdArray cannot be empty';
    }

    if (shape.length == 1 && shape[0] > 0) {
      shape[1] = 1; // Column vector n×1
    } else if (shape.length == 0 || shape[0] === 0) {
      throw 'NdArray has no shape: [' + shape + ']';
    }

    var length = NdArray.toLength(shape);

    if (data.length !== length) {
      throw [
        'The length of the storage data is ',
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
  }

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
    if (idx >= 0 && idx < this.data.length) {
      return this.data[idx];
    }
  };

  /**
   * Sets the value in a specific location (mutates NdArray)
   * @param {number[]} location
   * @param {number} value
   * @returns {NdArray}
   * @public
   */
  NdArray.prototype.set = function (location, value) {
    var idx = this.toIndex(location);
    if (idx >= 0 && idx < this.data.length) {
      this.data[idx] = value;
    }
    return this;
  };

  /**
   * Implements forEach method
   * @param {(any, number[], number, NdArray) => void} fn
   * @returns {NdArray}
   * @public
   */
  NdArray.prototype.forEach = function (fn) {
    for (
      var location = this.initialLocation();
      this.isLocationBelowLimit(location);
      location = this.nextLocation(location)
    ) {
      var idx = this.toIndex(location);
      var value = this.data[idx];
      fn(value, location, idx, this);
    }

    return this;
  }

  /**
   * Implements map method
   * @param {(any, number[], number, NdArray) => void} fn
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
   * Permute the dimensions of an array
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
   * Converts a list of indexes (>1D) into a 1D index
   * @param {number[]} location
   * @return {number}
   * @private
   */
  NdArray.prototype.toIndex = function (location) {
    var idx = -1;
    var length = location ? location.length : 0;
    var stride = this.stride;

    if (location.length === stride.length) {
      idx = location.reduce(function (acc, val, i) {
        return acc + (stride[i] * val);
      }, 0);
    }
    return idx;
  };

  /**
   * Finds the location (list of coordinates) from a 1D index
   * @param {number} location
   * @return {number[]}
   * @private
   */
  NdArray.prototype.toLocation = function (index) {
    var location = [];
    var stride = this.stride;

    if (index >= 0 && index < this.data.length) {
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
   * Returns an initial location [0, 0, ..., 0]
   * @return {number[]}
   * @private
   */
  NdArray.prototype.initialLocation = function () {
    return Array(this.shape.length).fill(0);
  }

  /**
   * Checks whether a location is below the limits
   * based on the shape
   * @param {number[]} location
   * @return {boolean}
   * @private
   */
  NdArray.prototype.isLocationBelowLimit = function (location) {
    var self = this;
    return location.reduce(function (is, dimIdx, idx) {
      return is && dimIdx < self.shape[idx];
    }, true);
  }

  /**
   * Calculates the next location
   * @param {number[]} location
   * @param {number} idx - current index in being looked at
   * @return {boolean}
   * @private
   */
  NdArray.prototype.nextLocation = function (location, idx) {
    location = typeof location === 'undefined' ? this.initialLocation() : location;
    idx = typeof idx === 'undefined' ? location.length -1 : idx;

    if (idx >= 0) {
      location[idx]++;
      if (idx > 0 && location[idx] >= this.shape[idx]) {
        location[idx] = 0;
        location = this.nextLocation(location, --idx);
      }
    }

    return location;
  }

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
  function diag(tDtype, lDiag) {
    var diagonal = toArray(lDiag);
    var size = diagonal.length;
    var length = size * size;
    var dtype = DTYPE_CONSTRUCTOR[tDtype.ctor] ? tDtype.ctor : 'Array';
    var shape = length ? [size, size] : [];
    var data = Array(length).fill(0);
    var nda;

    try {
      nda = new NdArray(data, shape, dtype);

      // Sets the diagonal
      diagonal.forEach(function (value, i) {
        nda.set([i, i], value);
      });
      
      return resultOk(nda);
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
        throw "Something went really wrong";
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

    // We need to clone since NdArray#set mutates the data
    var clonedNda = nda.clone();

    try {
      return resultOk(clonedNda.set(location, value));
    } catch (e) {
      return resultErr(e + '');
    }
    
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

  return {
    ndarray     : F3(ndarray),
    toString    : toString,
    dataToString: dataToString,
    shape       : shape,
    dtype       : dtype,
    diag        : F2(diag),
    get         : F2(get),
    set         : F3(set),
    map         : F2(map),
    transpose   : transpose
  };

}();