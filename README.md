# Heap Abstract Class (BinaryHeap and FibonacciHeap)

This defines and declares a Heap abstract base class
and two concrete subclasses, BinaryHeap and FibonacciHeap.
Subclassing of the Heap class is possible for other structures.

The base class defines the user interface and the implementations
add the storage and manipulation backend.
The user interface includes the traditional heap interface with
push, pop, top, size, and empty,
as well as a more Apple-like interface including synonyms
addObject, removeTopObject, topObject, and count.

Heaps can be declared as minimum heaps (top object is always the minimum)
or maximum heaps (top object is always the maximum).
A heap without explicit minimum or maximum will be the default for the
heap subclass type; in general these will be maximum heaps.

Heaps can also be declared providing an [NSComparator] that defines relationships
between stored objects or with an [NSSortDescriptor] to define order.

The objects stored in the heap must implement
`- (NSComparisonResult) compare: (MyClass *) otherObject;` if
if no comparator or sort descriptor is supplied.
They must also implement `- (BOOL) isEqual: (id) otherObject;`
although this is only really needed if methods that need
to identify objects are used such as `containsObject:`, `removeObject:`,
and `replaceObject:withObject:`.

All heaps are mutable and therefore not thread safe.
This seemed appropriate since there is no random access to a heap,
if it was not mutable only its top element would every be accessible.

### Version 1.00.00

# Installation and Usage
Copy both [Heap.h][] and [Heap.m][] files to your project as well as the
interface and implementation files for the specific type or types of heap
you intend to use ([BinaryHeap.h][] and [BinaryHeap.m][],
and/or [FibonacciHeap.h][] and [FibonacciHeap.m][]).
Usage is simple, delare your heap and use it.

```objective-c
BinaryHeap *heap1 = [BinaryHeap maxHeap];
[heap1 push: @1];
[heap1 push: @5];
[heap1 push: @2];
NSLog( @"The top of the heap is %@\n", heap1.top );
// Will output:
//   The top of the heap is 5
```

Should be compatible with iOS or Mac OS X.

# Heap Methods

## Traditional heap interface methods:
<dl>
<dt>- (void) push: (ObjectType) object;</dt>
   <dd>Adds the <em>object</em> to the heap.
   Pushing a <strong>nil</strong> does nothing.</dd>
<dt>- (ObjectType) pop;</dt>
   <dd>Removes and returns the top object from the heap.
   If the heap is empty returns <strong>nil</strong>.</dd>
<dt>- (ObjectType) top;</dt>
   <dd>Returns the top object from the heap.
   If the heap is empty returns <strong>nil</strong>.</dd>
<dt>- (NSUInteger) size;</dt>
   <dd>Returns the number of objects in the heap.</dd>
<dt>- (BOOL) empty;</dt>
   <dd>Returns <strong>YES</strong> if the heap's size is zero.</dd>
</dl>

## More Apple-like interface methods:
<dl>
<dt>- (void) addObject: (ObjectType) object;</dt>
   <dd>Pushes the <em>object</em> to the heap.
   Adding a <strong>nil</strong> does nothing.</dd>
<dt>- (void) removeTopObject;</dt>
   <dd>Removes the top object from the heap.
   If the heap is empty returns <strong>nil</strong>.</dd>
<dt>- (ObjectType) topObject;</dt>
   <dd>Returns the top object from the heap.
   If the heap is empty returns <strong>nil</strong>.</dd>
<dt>- (NSUInteger) count;</dt>
   <dd>Returns the number of objects in the heap.</dd>
</dl>

## Additional / expanded interface methods:
<dl>
<dt>- (void) addObjectsFromArray: (NSArray *) array;</dt>
   <dd>Pushes each object from the <em>array</em> to the heap.</dd>
<dt>- (void) setObjectsFromArray: (NSArray *) array;</dt>
   <dd>Replaces the content of the heap with the objects
   from the <em>array</em>.
   This is functionally equivalent to:
   <div><code>
      [heap removeAllObjects];<br>
      [heap addObjectsFromArray: array];
   </code></div>
   however subclasses may override this if there is a more
   efficient way to do it.</dd>
<dt>- (void) replaceTopObjectWithObject: (id) anObject;</dt>
   <dd>Replaces the top object on the heap with the object.
   This is functionally equivalent to:
   <div><code>
      [heap pop];<br>
      [heap push: anObject];
   </code></div>
   however subclasses may override this if there is a more
   efficient way to do it.
   If <em>anObject</em> is <strong>nil</strong> then the
   top object is removed.</dd>
<dt>- (void) replaceObject: (id) object withObject: (id) newObject;</dt>
   <dd>Replaces the <em>object</em> in the heap with the <em>newObject</em>.
   This is functionally equivalent to:
   <div><code>
      [heap removeObject: object];<br>
      [heap push: newObject];
   </code></div>
   however subclasses may override this if there is a more
   efficient way to do it.
   If <em>object</em> is <strong>nil</strong> then nothing is
   removed.
   If <em>newObject</em> is <strong>nil</strong> then nothing
   is added.</dd>
<dt>- (BOOL) containsObject: (ObjectType) anObject;</dt>
   <dd>Returns <strong>YES</strong> if any object in the
   heap returns <strong>YES</strong> to
   <code>isEqual: anObject</code>.
   If <em>anObject</em> is <strong>nil</strong> the
   return value will always be <strong>NO</strong></dd>
<dt>- (void) removeObject: (id) object;</dt>
   <dd>Removes the <em>object</em> from the heap.
   If <em>object</em> is <strong>nil</strong> nothing
   is changed.</dd>
<dt>- (void) removeAllObjects;</dt>
   <dd>Removes all objects from the heap. This is functionally
   equivalent to:
   <div><code>
      while( [heap pop] );<br>
   </code></div>
   however subclasses may override this if there is a more
   efficient way to do it.</dd>
<dt>- (NSArray *) allObjects;</dt>
   <dd>Returns an array containing all the objects in the heap.
   It the heap is empty then an empty array is returned.
   No specific order is guaranteed.</dd>
<dt>- (BOOL) isEqualToHeap: (Heap *) heap;</dt>
   <dd>Two heaps are considered equal if
   they contain the same number of objects,
   their top objects are equal
   and every object is contained in the other heap.
   Therefore a BinaryHeap can be equal to a FibonacciHeap.
   Also an empty <em>minimum</em> heap will be equal to an
   empty <em>maximum</em> heap.</dd>
</dl>

## Heap Creation
<dl>
<dt>- (instancetype) init;</dt>
<dt>- (instancetype) initMax;</dt>
<dt>- (instancetype) initMin;</dt>
<dt>- (instancetype) initWithComparator: (NSComparator) comparator;</dt>
<dt>- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd;</dt>

<dt>- (instancetype) initWithObject: (ObjectType) object;</dt>
<dt>- (instancetype) initMinWithObject: (ObjectType) object;</dt>
<dt>- (instancetype) initMaxWithObject: (ObjectType) object;</dt>
<dt>- (instancetype) initWithComparator: (NSComparator) comparator andObject: (ObjectType) object;</dt>
<dt>- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andObject: (ObjectType) object;</dt>

<dt>- (instancetype) initWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;</dt>
<dt>- (instancetype) initMinWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;</dt>
<dt>- (instancetype) initMaxWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;</dt>
<dt>- (instancetype) initWithComparator: (NSComparator) comparator andObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;</dt>
<dt>- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;</dt>

<dt>- (instancetype) initWithArray: (NSArray *) array;</dt>
<dt>- (instancetype) initMinWithArray: (NSArray *) array;</dt>
<dt>- (instancetype) initMaxWithArray: (NSArray *) array;</dt>
<dt>- (instancetype) initWithComparator: (NSComparator) comparator andArray: (NSArray *) array;</dt>
<dt>- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andArray: (NSArray *) array;</dt>

<dt>- (instancetype) initWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt;</dt>
<dt>- (instancetype) initMinWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt;</dt>
<dt>- (instancetype) initMaxWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt;</dt>
<dt>- (instancetype) initWithComparator: (NSComparator) comparator andObjects: (const ObjectType *) objects count: (NSUInteger) cnt;</dt>
<dt>- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andObjects: (const ObjectType *) objects count: (NSUInteger) cnt;</dt>

<dt>+ (instancetype) heap;</dt>
<dt>+ (instancetype) minHeap;</dt>
<dt>+ (instancetype) maxHeap;</dt>
<dt>+ (instancetype) heapWithComparator: (NSComparator) comparator;</dt>
<dt>+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd;</dt>

<dt>+ (instancetype) heapWithObject: (ObjectType) object;</dt>
<dt>+ (instancetype) minHeapWithObject: (ObjectType) object;</dt>
<dt>+ (instancetype) maxHeapWithObject: (ObjectType) object;</dt>
<dt>+ (instancetype) heapWithComparator: (NSComparator) comparator andObject: (ObjectType) object;</dt>
<dt>+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd andObject: (ObjectType) object;</dt>

<dt>+ (instancetype) heapWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;</dt>
<dt>+ (instancetype) minHeapWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;</dt>
<dt>+ (instancetype) maxHeapWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;</dt>
<dt>+ (instancetype) heapWithComparator: (NSComparator) comparator andObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;</dt>
<dt>+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd andObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;</dt>

<dt>+ (instancetype) heapWithArray: (NSArray *) array;</dt>
<dt>+ (instancetype) minHeapWithArray: (NSArray *) array;</dt>
<dt>+ (instancetype) maxHeapWithArray: (NSArray *) array;</dt>
<dt>+ (instancetype) heapWithComparator: (NSComparator) comparator andArray: (NSArray *) array;</dt>
<dt>+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd andArray: (NSArray *) array;</dt>

<dt>+ (instancetype) heapWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt;</dt>
<dt>+ (instancetype) minHeapWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt;</dt>
<dt>+ (instancetype) maxHeapWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt;</dt>
<dt>+ (instancetype) heapWithComparator: (NSComparator) comparator andObjects: (const ObjectType *) objects count: (NSUInteger) cnt;</dt>
<dt>+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd andObjects: (const ObjectType *) objects count: (NSUInteger) cnt;</dt>
</dl>

# Existing Subclasses

## BinaryHeap
The binary heap subclass uses an NSMutableArray as its storage mechanism.
It takes no additional space for pointers or other elements for the objects being stored.
The binary heap is described in detail on its [Wikipedia page](https://en.wikipedia.org/wiki/Binary_heap).
Because its backing storage is a mutable array it adds some addtional 
initializes including:

<dl>
<dt>- (instancetype) initWithCapacity: (NSUInteger) numItems;</dt>
<dt>- (instancetype) initMinWithCapacity: (NSUInteger) numItems;</dt>
<dt>- (instancetype) initMaxWithCapacity: (NSUInteger) numItems;</dt>
<dt>- (instancetype) initWithComparator: (NSComparator) comparator andCapacity: (NSUInteger) numItems;</dt>
<dt>- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andCapacity: (NSUInteger) numItems;</dt>
</dl>

## Fibonacci Heap
A Fibonacci heap is a heap data structure similar to the binomial heap.
It defers ‘clean up’ jobs until later to improved to O(1) several operations.
Internally it stores its data in nodes organized as doubly linked lists
conecting siblings and parent/child pointers for heap relationships so there is
greater memory usage than with the Binary Heap implementation.
Much of the code was derived from examples on the Growing with the Web
[Fibonacci heap](http://www.growingwiththeweb.com/data-structures/fibonacci-heap/overview/) page.

# Subclassing Instructions

Heaps is implemented as a Class Cluster.
The Heap class itself is an abstract super class with no storage.
By default, `size`, `pop`, and `top` return **nil** or **zero**,
`empty` returns **YES**, `containsObject:` returns **NO**,
`removeObject:` does nothing, and `push:` throws an exception.

Subclasses of Heap are required to declare and manage the storage
of the heap objects and implement the minimum subset of methods
described below. They can also define additional methods as appropriate.

Methods that must be overridden in all subclasses include:
<dl>
<dt>- (void) push: (ObjectType) object;</dt>
   <dd>This should add the <em>object</em> to the heap
   or do nothing if the <em>object</em> is <strong>nil</strong>.
   It should not call <code>[super push: object]</code>.</dd>
<dt>- (ObjectType) pop;</dt>
   <dd>This should remove and return the top object in the heap
   or return <strong>nil</strong> if the heap is empty.
   It should not call <code>[super pop]</code>.</dd>
<dt>- (ObjectType) top;</dt>
   <dd>This should return the top object in the heap or
   <strong>nil</strong> if the heap is empty.
   It should not call <code>[super top]</code>.</dd>
<dt>- (NSUInteger) size;</dt>
   <dd>This should return the number of objects in
   the heap.
   It should not call <code>[super size]</code>.</dd>
<dt>- (void) removeObject: (id) object;</dt>
   <dd>This should efficiently search through the heap
   and delete the first object that
   returns <strong>YES</strong> when passed <em>object</em>
   to <code>isEqual:</code>. It should gracefully do nothing
   if <em>object</em> is <strong>nil</strong>.
   It should not call <code>[super removeObject: object]</code></dd>
<dt>- (BOOL) containsObject: (ObjectType) anObject;</dt>
   <dd>This should efficiently search through the heap
   and return <strong>YES</strong> if any object in the heap
   returns <strong>YES</strong> when passed <em>anObject</em>
   to <code>isEqual:</code>. It should gracefully return
   <strong>nil</strong> if <em>anObject</em> is <strong>nil</strong>.
   It should not call <code>[super containsObject: object]</code></dd>
<dt>- (BOOL) isEqualToHeap: (Heap *) otherHeap;</dt>
   <dd>This should call <code>[super isEqualToHeap: otherHeap]</code>
   then, if this returns <strong>YES</strong> go through
   each object in the heap and call
   <code>[otherHeap contains: object]</code>, returning <strong>NO</strong>
   if the other heap returns <strong>NO</strong>.</dd>
</dl>

The subclass must also implement 
<dl>
<dt>- (instancetype) init;</dt>
<dt>- (instancetype) initMax;</dt>
<dt>- (instancetype) initMin;</dt>
<dt>- (instancetype) initWithComparator: (NSComparator) comparator;</dt>
<dt>- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd;</dt>
</dl>

These should each call their **[super]** then initialize the storage
as needed.

Within your subclass you should use `- (NSComparisonResult) heapCompareNode:
(const id) lhs toNode: (const id) rhs` for all object comparisons.
For example, here is the internal bubble up code from the BinaryHeap
implementation.

```objective-c
- (void) bubbleUpFromIndex: (NSUInteger) i {
	NSUInteger p = parentOf(i);
	while( i > 0 && [self heapCompareNode: _objects[i] toNode: _objects[p]] == NSOrderedDescending) {
		ObjectType t = _objects[p];
		_objects[p] = _objects[i];
		_objects[i] = t;
		i = p;
		p = parentOf(i);
	}
}
```

This will make your implementation work with the built in comparators,
user specified comparators or sort descriptors.

Testing is also implemented. If you create a new heap type subclass, make a
copy of [test/testFib.m][] or [test/testBin.m][], modify it to import your
header file, and define your class name as **HEAP_TYPE**.
Compile and run. No output means no errors identified.
(Sorry about the inelegant testing, it was just what I had on the fly)

# License
The MIT License (MIT)

Copyright (c) 2017 Syntonicity, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


[Heap.h]: Heap.h
[Heap.m]: Heap.m
[BinaryHeap.h]: BinaryHeap.h
[BinaryHeap.m]: BinaryHeap.m
[FibonacciHeap.h]: FibonacciHeap.h
[FibonacciHeap.m]: FibonacciHeap.m

[NSSortDescriptor]: https://developer.apple.com/reference/foundation/nssortdescriptor?language=objc
[NSComparator]: https://developer.apple.com/reference/foundation/nscomparator
[NSComparisonResult]: https://developer.apple.com/reference/foundation/nscomparisonresult?language=objc
