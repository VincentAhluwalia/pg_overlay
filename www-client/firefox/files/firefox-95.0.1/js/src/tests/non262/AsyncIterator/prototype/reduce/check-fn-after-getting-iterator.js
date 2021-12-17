// |reftest| skip-if(!this.hasOwnProperty('AsyncIterator')) 
const log = [];
const handlerProxy = new Proxy({}, {
  get: (target, key, receiver) => (...args) => {
    log.push(`${key}: ${args[1]?.toString()}`);
    return Reflect[key](...args);
  },
});

class TestIterator extends AsyncIterator {
  next() {
    return Promise.resolve({ done: this.closed });
  }
}

const iter = new Proxy(new TestIterator(), handlerProxy);
iter.reduce(1).then(() => assertEq(true, false, 'expected error'), err => {
  assertEq(err instanceof TypeError, true);
  assertEq(
    log.join('\n'),
    `get: reduce
get: next`
  );
});

if (typeof reportCompare === 'function')
  reportCompare(0, 0);
