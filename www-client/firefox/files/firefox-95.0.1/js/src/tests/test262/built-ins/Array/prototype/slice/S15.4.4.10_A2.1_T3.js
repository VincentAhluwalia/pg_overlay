// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: Operator use ToInteger from start
esid: sec-array.prototype.slice
description: start = Infinity
---*/

var x = [0, 1, 2, 3, 4];
var arr = x.slice(Number.POSITIVE_INFINITY, 3);

//CHECK#1
arr.getClass = Object.prototype.toString;
if (arr.getClass() !== "[object " + "Array" + "]") {
  throw new Test262Error('#1: var x = [0,1,2,3,4]; var arr = x.slice(Number.POSITIVE_INFINITY,3); arr is Array object. Actual: ' + (arr.getClass()));
}

//CHECK#2
if (arr.length !== 0) {
  throw new Test262Error('#2: var x = [0,1,2,3,4]; var arr = x.slice(Number.POSITIVE_INFINITY,3); arr.length === 0. Actual: ' + (arr.length));
}

//CHECK#3
if (arr[0] !== undefined) {
  throw new Test262Error('#3: var x = [0,1,2,3,4]; var arr = x.slice(Number.POSITIVE_INFINITY,3); arr[0] === undefined. Actual: ' + (arr[0]));
}

reportCompare(0, 0);
