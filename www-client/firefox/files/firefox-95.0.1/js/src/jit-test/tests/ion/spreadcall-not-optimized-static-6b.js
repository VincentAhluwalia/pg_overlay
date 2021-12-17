// Tests when JSOP_OPTIMIZE_SPREADCALL can't be applied during the initial
// Ion compilation.

// JSOP_OPTIMIZE_SPREADCALL can be optimised when the following conditions
// are fulfilled:
//   (1) the argument is an array
//   (2) the array has no hole
//   (3) array[@@iterator] is not modified
//   (4) the array's prototype is Array.prototype
//   (5) Array.prototype[@@iterator] is not modified
//   (6) %ArrayIteratorPrototype%.next is not modified

function add(a, b) {
    return a + b;
}

// %ArrayIteratorPrototype%.next was modified.
function test() {
    var ArrayIteratorPrototype = Object.getPrototypeOf(Array.prototype[Symbol.iterator]());
    var ArrayIteratorPrototypeNext = ArrayIteratorPrototype.next;
    ArrayIteratorPrototype.next = function() {
        var res = ArrayIteratorPrototypeNext.call(this);
        if (!res.done) {
            res.value += 2;
        }
        return res;
    };
    function fn(...rest) {
        return add(...rest);
    }
    for (var i = 0; i < 2000; ++i) {
        assertEq(fn(1, 2), 7);
    }
}
test();
