var _jscriptcoder$numelm$Native_NumElm = function() {

  // Imports
  var toArray = _elm_lang$core$Native_List.toArray;
  var fromArray = _elm_lang$core$Native_List.fromArray;


  /**
   * Maps Dtype to TypedArray constructor.
   * @const {[key: string]: TypedArray}
   */
  var DTYPE_CONSTRUCTOR = {
    'Int8': Int8Array,
    'In16': Int16Array,
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
    }

    var length = NdArray.lengthFromShape(shape);

    /*
    if (data.length > length) {
      // We need to slice the array since
      // it's longer than what the shape says
      data = data.slice(0, length);
    } else if (data.length < length) {
      // We need to fill the array 
      // with ceros to fullfil the shape
      var lengthToFill = length - data.length;
      data = data.concat(Array(lengthToFill).fill(0));
    }
    */

    if (data.length !== length) {
      throw [
        'The length of the storage data is ',
        data.length,
        ', but the shape says ',
        shape.join('×'), 
        '=',
        length
      ].join();
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
    //    get([2, 0, 3], ndarray) == ndarra[10*2 + 5*0 + 1*3] == ndarra[23]
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
  NdArray.lengthFromShape = function (shape) {
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
    return 'NdArray[length=' + length + ';shape=' + shape + ';dtype=' + dtype + ']'
  };

  /**
   * Gets the value in a specific location.
   * @param {number[]} location
   * @returns {number}
   * @public
   */
  NdArray.prototype.get = function (location) {
    var idx = this.findIndex(location);
    if (idx >= 0 && idx < this.data.length) {
      return this.data[idx];
    }
  };

  /**
   * Sets a value in a specific location.
   * @param {number[]} location
   * @param {number} value
   * @public
   */
  NdArray.prototype.set = function (location, value) {
    var idx = this.findIndex(location);
    if (idx >= 0 && idx < this.data.length) {
      return this.data[idx] = value;
    }
  };

  /**
   * Finds the index within the 1D array
   * @param {number[]} location
   * @return {number}
   * @private
   */
  NdArray.prototype.findIndex = function (location) {
    var idx = -1;
    var length = location.length;
    if (length > 0 && length === this.stride.length) {
      idx = 0;
      for(var i = 0; i < length; i++) {
        idx += this.stride[i] * location[i];
      }
    }
    return idx;
  };

  // =============== Native.NumElm =============== //


  /**
   * Instantiates a NdArray
   * @param {List number | number[]} lData
   * @param {List number} lShape
   * @param {Dtype} tDtype
   * @returns {NdArray}
   * @memberof Native.NumElm
   */
  function ndarray(lData, lShape, tDtype) {
    // Let's do some conversion, Elm to Js types
    var data = toArray(lData);
    var shape = toArray(lShape);
    var dtype = DTYPE_CONSTRUCTOR[tDtype.ctor] ? tDtype.ctor : 'Array';

    return new NdArray(data, shape, dtype);
  }

  /**
   * Returns the string representation of the ndarray
   * @param {NdArray} ndarray
   * @returns {string}
   * @memberof Native.NumElm
   */
  function toString(ndarray) {
    return ndarray + '';
  } 

  /**
   * Gets the shape of the ndarray
   * @param {NdArray} ndarray
   * @returns {List number} shape of the ndarray
   * @memberof Native.NumElm
   */
  function shape(ndarray) {
    return fromArray(ndarray.shape);
  }

  /**
   * Gets the dtype of the ndarray
   * @param {NdArray} ndarray
   * @returns {Dtype}
   * @memberof Native.NumElm
   */
  function dtype(ndarray) {
    return { ctor: ndarray.dtype }
  }

  /**
   * Returns a NdArray pre-filled
   * @param {List number} lShape
   * @param {Dtype} tDtype
   * @returns {NdArray}
   * @private
   */
  function fillNdArray(lShape, tDtype, fillWith) {
    var shape = toArray(lShape);
    var lengthToFill = NdArray.lengthFromShape(shape);
    var data = Array(lengthToFill).fill(fillWith);
    var dtype = DTYPE_CONSTRUCTOR[tDtype.ctor] ? tDtype.ctor : 'Array';

    return new NdArray(data, shape, dtype);
  }

  /**
   * Instantiates a NdArray filled with ceros
   * @param {List number} lShape
   * @param {Dtype} tDtype
   * @returns {NdArray}
   * @memberof Native.NumElm
   */
  function zeros(lShape, tDtype) {
    fillNdArray(lShape, tDtype, 0);
  }

  /**
   * Instantiates a NdArray filled with ones
   * @param {List number} lShape
   * @param {Dtype} tDtype
   * @returns {NdArray}
   * @memberof Native.NumElm
   */
  function ones(lShape, tDtype) {
    fillNdArray(lShape, tDtype, 1);
  }

  /**
   * Creates an identity matrix
   * @param {List number} lShape
   * @param {Dtype} tDtype
   * @returns {NdArray}
   * @memberof Native.NumElm
   */
  function identity(size, tDtype) {
    var length = size * size;
    var lShape = fromArray([size, size]);
    var ndarray = zeros(lShape, tDtype);
    for (var i = 0; i < length; i++) {
      ndarray.set([i, i], 1);
    }
  }

  /**
   * Creates an identity matrix
   * @param {List number} lShape
   * @param {Dtype} tDtype
   * @returns {NdArray}
   * @memberof Native.NumElm
   */
  function identity(size, tDtype) {
    var length = size * size;
    var lShape = fromArray([size, size]);
    var ndarray = zeros(lShape, tDtype);
    for (var i = 0; i < length; i++) {
      ndarray.set([i, i], 1);
    }
  }

  return {
    ndarray:  F3(ndarray),
    vector:   F2(vector),
    matrix:   F2(matrix),
    matrix3d: F2(matrix3d),
    toString: toString,
    shape:    shape,
    dtype:    dtype,
    zeros:    F2(zeros),
    ones:     F2(ones),
    identity: F2(identity)
  };

}();