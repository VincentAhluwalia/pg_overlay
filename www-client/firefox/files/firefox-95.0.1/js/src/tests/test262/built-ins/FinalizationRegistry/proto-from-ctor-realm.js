// |reftest| skip-if(!this.hasOwnProperty('FinalizationRegistry')) -- FinalizationRegistry is not enabled unconditionally
// Copyright (C) 2019 Leo Balter. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
esid: sec-finalization-registry-target
description: Default [[Prototype]] value derived from realm of the newTarget
info: |
  FinalizationRegistry ( cleanupCallback )

  ...
  3. Let finalizationRegistry be ? OrdinaryCreateFromConstructor(NewTarget,  "%FinalizationRegistryPrototype%", « [[Realm]], [[CleanupCallback]], [[Cells]], [[IsFinalizationRegistryCleanupJobActive]] »).
  ...
  9. Return finalizationRegistry.

  OrdinaryCreateFromConstructor ( constructor, intrinsicDefaultProto [ , internalSlotsList ] )

  ...
  2. Let proto be ? GetPrototypeFromConstructor(constructor, intrinsicDefaultProto).
  3. Return ObjectCreate(proto, internalSlotsList).

  GetPrototypeFromConstructor ( constructor, intrinsicDefaultProto )

  3. Let proto be ? Get(constructor, 'prototype').
  4. If Type(proto) is not Object, then
    a. Let realm be ? GetFunctionRealm(constructor).
    b. Set proto to realm's intrinsic object named intrinsicDefaultProto.
  5. Return proto.
features: [FinalizationRegistry, cross-realm, Reflect, Symbol]
---*/

var other = $262.createRealm().global;
var newTarget = new other.Function();
function fn() {}
var finalizationRegistry;

newTarget.prototype = undefined;
finalizationRegistry = Reflect.construct(FinalizationRegistry, [fn], newTarget);
assert.sameValue(Object.getPrototypeOf(finalizationRegistry), other.FinalizationRegistry.prototype, 'newTarget.prototype is undefined');

newTarget.prototype = null;
finalizationRegistry = Reflect.construct(FinalizationRegistry, [fn], newTarget);
assert.sameValue(Object.getPrototypeOf(finalizationRegistry), other.FinalizationRegistry.prototype, 'newTarget.prototype is null');

newTarget.prototype = true;
finalizationRegistry = Reflect.construct(FinalizationRegistry, [fn], newTarget);
assert.sameValue(Object.getPrototypeOf(finalizationRegistry), other.FinalizationRegistry.prototype, 'newTarget.prototype is a Boolean');

newTarget.prototype = '';
finalizationRegistry = Reflect.construct(FinalizationRegistry, [fn], newTarget);
assert.sameValue(Object.getPrototypeOf(finalizationRegistry), other.FinalizationRegistry.prototype, 'newTarget.prototype is a String');

newTarget.prototype = Symbol();
finalizationRegistry = Reflect.construct(FinalizationRegistry, [fn], newTarget);
assert.sameValue(Object.getPrototypeOf(finalizationRegistry), other.FinalizationRegistry.prototype, 'newTarget.prototype is a Symbol');

newTarget.prototype = 1;
finalizationRegistry = Reflect.construct(FinalizationRegistry, [fn], newTarget);
assert.sameValue(Object.getPrototypeOf(finalizationRegistry), other.FinalizationRegistry.prototype, 'newTarget.prototype is a Number');


reportCompare(0, 0);
