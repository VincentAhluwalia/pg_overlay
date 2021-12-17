// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: The "length" property of the "getTime" is 0
esid: sec-date.prototype.getseconds
description: The "length" property of the "getTime" is 0
---*/

if (Date.prototype.getTime.hasOwnProperty("length") !== true) {
  throw new Test262Error('#1: The getTime has a "length" property');
}

if (Date.prototype.getTime.length !== 0) {
  throw new Test262Error('#2: The "length" property of the getTime is 0');
}

reportCompare(0, 0);
