var _jscriptcoder$numelm$Native_NumElm = function() {

  // Imports
  var toArray = _elm_lang$core$Native_List.toArray;
  var fromArray = _elm_lang$core$Native_List.fromArray;
  var resultOk = _elm_lang$core$Result$Ok;
  var resultErr = _elm_lang$core$Result$Err;


  /**
   * Maps dtype to TypedArray constructor.
   * @const {[key: string]: TypedArray}
   */
  var DTYPE_CONSTRUCTOR = {
    'Int8': Int8Array,
    'Int16': Int16Array,
    'Int32': Int32Array,
    'Float32': Float32Array,
    'Float64': Float64Array,
    'Uint8': Uint8Array,
    'Uint16': Uint16Array,
    'Uint32': Uint32Array,
    'Array': Array
  }

  /**
   * @class NdArray
   * @constructor
   * @param {number[]} data
   * @param {number[]} shape
   * @param {string} dtype
   */
  var NdArray = function (data, shape, dtype) {

    data = data || [];
    shape = shape || [1, 1];
    dtype = dtype || 'Array';

    if (shape.length == 1) {
      shape[1] = 1; // Column vector n×1
    } else if (shape.length == 0) {
      throw "NdArray has no shape"
    }

    var length = NdArray.shapeToLength(shape);

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
    var stride = [];
    var acc = 1;
    shape.forEach(function (dim, i) {
      acc *= dim;
      stride[i] = length / acc;
    });

    /**
     * Contains the strides per dimensions
     * @type number[]
     * @private
     */
    this.stride = stride;
  }

  /**
   * Returns the length of a shape
   * @memberOf NdArray
   * @param {number[]} shape
   * @returns {number}
   * @static
   */
  NdArray.shapeToLength = function (shape) {
    return shape.reduce(function (dim1, dim2) {
      return dim1 * dim2;
    }, 1);
  };

  /**
   * String representation.
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
   * String representation of the data storage.
   * @param {number} [from = 0]
   * @param {number} [length = this.data.length]
   * @returns {string}
   * @public
   */
  NdArray.prototype.dataToString = function (from, length) {
    from = from || 0;
    length = length || this.data.length;
    return '[' + this.data.slice(from, length) + ']';
  };

  /**
   * Gets the value from a specific location.
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
   * Sets the value in a specific location.
   * @param {number[]} location
   * @param {number} value
   * @public
   */
  NdArray.prototype.set = function (location, value) {
    var idx = this.toIndex(location);
    if (idx >= 0 && idx < this.data.length) {
      return this.data[idx] = value;
    }
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


  // =============== Native.NumElm =============== //


  /**
   * Instantiates a NdArray
   * @param {Dtype} tDtype
   * @param {List number} lShape   
   * @param {List number} lData
   * @returns {NdArray}
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
   * @returns {NdArray}
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
      for (var i = 0; i < length; i++) {
        nda.set([i, i], diagonal[i]);
      }
      
      return resultOk(nda);
    } catch (e) {
      return resultErr(e + '');
    }
  }

  return {
    ndarray:      F3(ndarray),
    toString:     toString,
    dataToString: dataToString,
    shape:        shape,
    dtype:        dtype,
    diag:         F2(diag)
  };

}();