// |reftest| skip-if(!this.hasOwnProperty('AsyncIterator'))

//
//
/*---
esid: pending
description: Calling `.return()` on a lazy %AsyncIterator.prototype% method multiple times closes the source iterator once.
info: >
  Iterator Helpers proposal 2.1.6
features: [iterator-helpers]
---*/

class TestIterator extends AsyncIterator {
  async next() { 
    return {done: false, value: 1};
  }

  closeCount = 0;
  async return(value) {
    this.closeCount++;
    return {done: true, value};
  }
}

async function* gen(x) { yield x; }

const methods = [
  iter => iter.map(x => x),
  iter => iter.filter(x => x),
  iter => iter.take(1),
  iter => iter.drop(0),
  iter => iter.asIndexedPairs(),
  iter => iter.flatMap(gen),
];

(async () => {
  // Call `return` after stepping the iterator once:
  for (const method of methods) {
    const iter = new TestIterator();
    const iterHelper = method(iter);
    
    await iterHelper.next();
    assertEq(iter.closeCount, 0);
    await iterHelper.return();
    assertEq(iter.closeCount, 1);
    await iterHelper.return();
    assertEq(iter.closeCount, 1);
  }

  // Call `return` before stepping the iterator:
  for (const method of methods) {
    const iter = new TestIterator();
    const iterHelper = method(iter);

    assertEq(iter.closeCount, 0);
    await iterHelper.return();
    assertEq(iter.closeCount, 1);
    await iterHelper.return();
    assertEq(iter.closeCount, 1);
  }
})();

if (typeof reportCompare == 'function')
  reportCompare(0, 0);
