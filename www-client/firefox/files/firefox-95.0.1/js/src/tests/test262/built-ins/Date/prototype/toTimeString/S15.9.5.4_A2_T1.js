// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: The "length" property of the "toTimeString" is 0
esid: sec-date.prototype.totimestring
description: The "length" property of the "toTimeString" is 0
---*/

if (Date.prototype.toTimeString.hasOwnProperty("length") !== true) {
  throw new Test262Error('#1: The toTimeString has a "length" property');
}

if (Date.prototype.toTimeString.length !== 0) {
  throw new Test262Error('#2: The "length" property of the toTimeString is 0');
}

reportCompare(0, 0);
