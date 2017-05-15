# Heap Abstract Class (BinaryHeap and FibonacciHeap)

This defines and declares a Heap abstract base class
and two concrete subclasses, BinaryHeap and FibonacciHeap.
Subclassing of the Heap class is possible for other structures.

The base class defines the user interface and the implementations add the storage and manipulation backend.
The user interface includes the traditional heap interface that includes push, pop, top, size, and empty,
as well as a more Apple-like interface including synonyms addObject, removeTopObject, topObject, and count.

Heaps can be declared as minimum heaps (top object is always the minimum)
or maximum heaps (top object is always the maximum).
A heap without explicit minimum or maximum will be the default for the
heap subclass type. In general these will be maximum heaps.

Heaps can also be declared providing a comparator that defines relationships
between stored objects or with an NSSortDescriptor to define order.

All heaps are mutable and therefore not thread safe.
This seemed appropriate since there is no random access to a heap if it was not
mutable only its top element would every be accessible.

### Version 1.00.00

# Methods

## Traditional heap interface methods:
<dl>
<dt>- (void) push: (ObjectType) object;</dt>
<dt>- (ObjectType) pop;</dt>
<dt>- (ObjectType) top;</dt>
<dt>- (NSUInteger) size;</dt>
<dt>- (BOOL) empty;</dt>
</dl>

## More Apple-like interface methods:
<dl>
<dt>- (void) addObject: (ObjectType) object;</dt>
<dt>- (void) removeTopObject;</dt>
<dt>- (ObjectType) topObject;</dt>
<dt>- (NSUInteger) count;</dt>
</dl>

## Additional / expanded interface methods:
<dl>
<dt>- (void) removeObject: (id) object;</dt>
<dt>- (BOOL) containsObject: (ObjectType) anObject;</dt>
<dt>- (BOOL) isEqualToHeap: (Heap *) heap;</dt>

<dt>- (NSArray *) allObjects;</dt>

<dt>- (void) setObjectsFromArray: (NSArray *) array;</dt>
<dt>- (void) addObjectsFromArray: (NSArray *) array;</dt>
<dt>- (void) removeAllObjects;</dt>
<dt>- (void) replaceTopObjectWithObject: (id) anObject;</dt>
<dt>- (void) replaceObject: (id) object withObject: (id) newObject;</dt>
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

# Subclasses

## BinaryHeap
The binary heap subclass uses an NSMutableArray as its storage mechanism.
It takes no additional space for pointers or other elements for the objects being stored.
The binary heap is described in detail on it [Wikipedia page](https://en.wikipedia.org/wiki/Binary_heap).
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

# Subclassing

Subclasses of Heap are required to declare and manage the storage of the heap objects and implement the minimum subset of methods described below. They can also define additional methods as appropriate.
The 

# Installation and Usage
Copy both [Heap.h][] and [Heap.m][] files to your project as well as the interface and implementation files for the specific type or types of heap you intend to use ([BinaryHeap.h][], [BinaryHeap.m][], [FibonacciHeap.h][] and/or [FibonacciHeap.m][]). Usage is simple, delare your heap and use it.

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

