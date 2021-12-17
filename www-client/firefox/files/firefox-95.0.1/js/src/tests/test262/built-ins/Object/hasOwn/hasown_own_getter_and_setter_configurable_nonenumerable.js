// Copyright (c) 2021 Jamie Kyle.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
esid: sec-object.hasown
description: >
    Properties - [[HasOwnProperty]] (configurable, non-enumerable own
    getter/setter property)
author: Jamie Kyle
features: [Object.hasOwn]
---*/

var o = {};
Object.defineProperty(o, "foo", {
  get: function() {
    return 42;
  },
  set: function() {;
  },
  configurable: true
});

assert.sameValue(Object.hasOwn(o, "foo"), true, 'Object.hasOwn(o, "foo") !== true');

reportCompare(0, 0);
