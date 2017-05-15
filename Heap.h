#import <Foundation/Foundation.h>
// Implementation of Heaps as a Class Cluster
// The heap class is an abstract super class with no storage.
// Be default, size, pop, and top return nil or zero,
//	empty returns YES, containsObject: returns NO,
//	removeObject: does nothing, and push throws an exception.
//
// Methods that must be overridden in all subclasses:
//	- (void) push: (ObjectType) object;
//	- (ObjectType) pop;
//	- (ObjectType) top;
//	- (NSUInteger) size;
//	- (void) removeObject: (id) object;
//	- (BOOL) containsObject: (ObjectType) anObject;
//
// Subclasses should use - (NSComparisonResult) heapCompareNode:
// (const id) lhs toNode: (const id) rhs; for all object comparisons
//
// Methods commonly overridden for enhanced efficiency include
//	- (void) setObjectsFromArray: (NSArray *) array;
//	- (void) setObjectsFromObject: (id) obj andArgs: (va_list) args;
//	- (void) replaceTopObjectWithObject: (id) anObject;
//	- (void) replaceObject: (id) object withObject: (id) newObject;
//
// Required of stored objects:
//	- (NSComparisonResult) compare: (MyClass *) otherObject;
// 		If no comparator or sort descriptor is supplied.
//	- (BOOL) isEqual: (id) otherObject;
//		For containsObject: and removeObject:
//

#define HEAP_VERSION	10000

#define	ObjectType	id

@interface Heap : NSObject

// Classic heap style interface methods:
- (void) push: (ObjectType) object;	// Should this return the size???
- (ObjectType) pop; // This is not really C++ like since it should return void
- (ObjectType) top; // Could also add peek?
- (NSUInteger) size;
- (BOOL) empty; // Could also have isEmpty?

- (void) removeObject: (id) object;		// Does nothing for nil object
- (BOOL) containsObject: (ObjectType) anObject;
- (BOOL) isEqualToHeap: (Heap *) heap;
@end

@interface Heap (AppleStyleInterface)
- (void) addObject: (ObjectType) object;	// push
- (void) removeTopObject;			// pop
- (ObjectType) topObject;			// top
- (NSUInteger) count;				// size

- (NSArray *) allObjects;

- (void) setObjectsFromArray: (NSArray *) array;
- (void) addObjectsFromArray: (NSArray *) array;
- (void) removeAllObjects;
- (void) replaceTopObjectWithObject: (id) anObject;
- (void) replaceObject: (id) object withObject: (id) newObject;

//- (void) filterUsingPredicate: (NSPredicate *) predicate;

@end

@interface Heap (HeapCreation)

- (instancetype) init;
- (instancetype) initMax;
- (instancetype) initMin;
- (instancetype) initWithComparator: (NSComparator) comparator;
- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd;

- (instancetype) initWithObject: (ObjectType) object;
- (instancetype) initMinWithObject: (ObjectType) object;
- (instancetype) initMaxWithObject: (ObjectType) object;
- (instancetype) initWithComparator: (NSComparator) comparator andObject: (ObjectType) object;
- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andObject: (ObjectType) object;

- (instancetype) initWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype) initMinWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype) initMaxWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype) initWithComparator: (NSComparator) comparator andObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype) initWithArray: (NSArray *) array;
- (instancetype) initMinWithArray: (NSArray *) array;
- (instancetype) initMaxWithArray: (NSArray *) array;
- (instancetype) initWithComparator: (NSComparator) comparator andArray: (NSArray *) array;
- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andArray: (NSArray *) array;

- (instancetype) initWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt;
- (instancetype) initMinWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt;
- (instancetype) initMaxWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt;
- (instancetype) initWithComparator: (NSComparator) comparator andObjects: (const ObjectType *) objects count: (NSUInteger) cnt;
- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andObjects: (const ObjectType *) objects count: (NSUInteger) cnt;

+ (instancetype) heap;
+ (instancetype) minHeap;
+ (instancetype) maxHeap;
+ (instancetype) heapWithComparator: (NSComparator) comparator;
+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd;

+ (instancetype) heapWithObject: (ObjectType) object;
+ (instancetype) minHeapWithObject: (ObjectType) object;
+ (instancetype) maxHeapWithObject: (ObjectType) object;
+ (instancetype) heapWithComparator: (NSComparator) comparator andObject: (ObjectType) object;
+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd andObject: (ObjectType) object;

+ (instancetype) heapWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;
+ (instancetype) minHeapWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;
+ (instancetype) maxHeapWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;
+ (instancetype) heapWithComparator: (NSComparator) comparator andObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;
+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd andObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype) heapWithArray: (NSArray *) array;
+ (instancetype) minHeapWithArray: (NSArray *) array;
+ (instancetype) maxHeapWithArray: (NSArray *) array;
+ (instancetype) heapWithComparator: (NSComparator) comparator andArray: (NSArray *) array;
+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd andArray: (NSArray *) array;

+ (instancetype) heapWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt;
+ (instancetype) minHeapWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt;
+ (instancetype) maxHeapWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt;
+ (instancetype) heapWithComparator: (NSComparator) comparator andObjects: (const ObjectType *) objects count: (NSUInteger) cnt;
+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd andObjects: (const ObjectType *) objects count: (NSUInteger) cnt;

@end

// Comparing?
// - isEqualToBinaryHeap: (BinaryHeap *) otherHeap;	// Quite difficult?
// Deriving New Binary Heaps
//- heapByAddingObject: (id) object;
//- filteredBinaryHeapUsingPredicate:
// Creating a Description
//- description;	// Formatted as a property list...
// Key-Value Observing
// Key-Value Coding

@interface Heap (InternalSubclassSupport)

- (NSComparisonResult) heapCompareNode: (const id) lhs toNode: (const id) rhs;
- (void) setObjectsFromObject: (id) obj andArgs: (va_list) args;

- (void) printDescription;

@end
