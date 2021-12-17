// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
esid: sec-date.prototype.getfullyear
info: |
    The Date.prototype.getFullYear property "length" has { ReadOnly, !
    DontDelete, DontEnum } attributes
es5id: 15.9.5.10_A3_T2
description: Checking DontDelete attribute
---*/

if (delete Date.prototype.getFullYear.length !== true) {
  throw new Test262Error('#1: The Date.prototype.getFullYear.length property does not have the attributes DontDelete');
}

if (Date.prototype.getFullYear.hasOwnProperty('length')) {
  throw new Test262Error('#2: The Date.prototype.getFullYear.length property does not have the attributes DontDelete');
}

reportCompare(0, 0);
