var _jscriptcoder$numelm$Native_NumElm = function() {

  // Imports
  var toArray = _elm_lang$core$Native_List.toArray

  // Maps Dtype to TypedArray constructor
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

  var NdArray = function (data, shape, dtype) {

    data = data || [];
    shape = shape || [1, 1];
    dtype = dtype || 'Array';

    if (shape.length == 1) {
      shape[1] = 1; // Column vector Nx1
    }

    var length = shape.reduce(function (dim1, dim2) {
      return dim1 * dim2;
    }, 1);

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

    this.data = DTYPE_CONSTRUCTOR[dtype].from(data);
    this.shape = shape;
    
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

    this.stride = stride;
  }

  function ndarray(lData, lShape, tDtype) {
    // Let's do some conversion. Elm to Js types
    var data = toArray(lData);
    var shape = toArray(lShape);
    var dtype = DTYPE_CONSTRUCTOR[tDtype.ctor] ? tDtype.ctor : 'Array';
    return new NdArray(data, shape, dtype);
  }

  return {
    ndarray: F3(ndarray)
  };

}();