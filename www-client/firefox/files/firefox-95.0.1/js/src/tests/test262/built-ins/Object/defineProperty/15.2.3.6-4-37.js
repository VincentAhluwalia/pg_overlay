// Copyright (c) 2012 Ecma International.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
es5id: 15.2.3.6-4-37
description: >
    Object.defineProperty - 'O' is a Number object that uses Object's
    [[GetOwnProperty]] method to access the 'name' property (8.12.9
    step 1)
---*/

var obj = new Number(-2);

Object.defineProperty(obj, "foo", {
  value: 12,
  configurable: false
});
assert.throws(TypeError, function() {
  Object.defineProperty(obj, "foo", {
    value: 11,
    configurable: true
  });
});
assert.sameValue(obj.foo, 12, 'obj.foo');

reportCompare(0, 0);
