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