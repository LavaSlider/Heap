#import "BinaryHeap.h"
/* Reference links:
 *   https://www.linkedin.com/pulse/heap-sort-algorithm-swift-objective-c-implementations-mario
 *   https://en.wikipedia.org/wiki/Binary_heap
 *   https://github.com/mzaks/priority-queue/blob/master/ASPriorityQueue/ASPriorityQueue.m
 *   http://www.geeksforgeeks.org/heap-using-stl-c/
 *   http://www.cplusplus.com/reference/queue/priority_queue/
 *   http://stackoverflow.com/questions/17684170/objective-c-priority-queue
 *   http://www.cplusplus.com/reference/queue/priority_queue/priority_queue/
 */
#define NSPrintf(...)	printf( "%s", [[NSString stringWithFormat: __VA_ARGS__] UTF8String] )

#define	leftChildOf(i)	((i<<1)+1)
#define	rightChildOf(i)	((i<<1)+2)
#define	parentOf(i)	((i-1)>>1)
// These are generalizable for an N-ary Heap (i.e., N children for each node)
//   #define	firstChildOf(i)		((N*i)+1)
//   #define	secondChildOf(i)	((N*i)+2)
//   #define	nthChildOf(n,i)		((N*i)+n)
//   #define	parentOf(i)		((i-1)/N)
// Heapify start point: (size-1)/N
#define	HeapIndexNotFound	NSUIntegerMax

#define DEFAULT_COMPARITOR	^NSComparisonResult( id first, id second ) { \
					return [first compare: second]; }
#define	LOCAL_FIND	1

// "Private" methods
@interface BinaryHeap ()
- (void) bubbleUpFromIndex: (NSUInteger) i;
- (void) heapifyDownFromIndex: (NSInteger) parent;
#if LOCAL_FIND
- (NSUInteger) findIndexOfObject: (ObjectType) object;
- (NSUInteger) findIndexOfObject: (ObjectType) object fromIndex: (NSUInteger) idx;
#endif
- (void) removeObjectAtIndex: (NSUInteger) indexOfObject;
- (void) replaceObjectAtIndex: (NSUInteger) indexOfObject withObject: (id) newObject;
- (NSString *) descriptionFromParent: (NSUInteger) p atLevel: (int) level;
- (void) printDescriptionFromParent: (NSUInteger) p atLevel: (int) level;
@end

@implementation BinaryHeap {
	NSMutableArray		*_objects;
}

- (instancetype) init {
	if( (self = [super init]) ) {
		_objects = [NSMutableArray array];
	}
	return self;
}
- (instancetype) initMax {
	if( (self = [super initMax]) ) {
		_objects = [NSMutableArray array];
	}
	return self;
}
- (instancetype) initMin {
	if( (self = [super initMin]) ) {
		_objects = [NSMutableArray array];
	}
	return self;
}
- (instancetype) initWithComparator: (NSComparator) comparator {
	return [self initWithComparator: comparator andCapacity: 0];
}
- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd {
	return [self initWithSortDescriptor: sd andCapacity: 0];
}

- (instancetype) initWithCapacity: (NSUInteger) numItems {
	if( (self = [super init]) ) {
		if( numItems > 0 )
			_objects = [NSMutableArray arrayWithCapacity: numItems];
		else	_objects = [NSMutableArray array];
	}
	return self;
}
- (instancetype) initMinWithCapacity: (NSUInteger) numItems {
	if( (self = [super initMin]) ) {
		if( numItems > 0 )
			_objects = [NSMutableArray arrayWithCapacity: numItems];
		else	_objects = [NSMutableArray array];
	}
	return self;
}
- (instancetype) initMaxWithCapacity: (NSUInteger) numItems {
	if( (self = [super initMax]) ) {
		if( numItems > 0 )
			_objects = [NSMutableArray arrayWithCapacity: numItems];
		else	_objects = [NSMutableArray array];
	}
	return self;
}
- (instancetype) initWithComparator: (NSComparator) comparator andCapacity: (NSUInteger) numItems {
	if( (self = [super initWithComparator: comparator]) ) {
		if( numItems > 0 )
			_objects = [NSMutableArray arrayWithCapacity: numItems];
		else	_objects = [NSMutableArray array];
	}
	return self;
}
- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andCapacity: (NSUInteger) numItems {
	if( (self = [super initWithSortDescriptor: sd]) ) {
		if( numItems > 0 )
			_objects = [NSMutableArray arrayWithCapacity: numItems];
		else	_objects = [NSMutableArray array];
	}
	return self;
}

- (void) printDescription {
	if( self.empty ) {
		NSPrintf( @"Empty Binary Heap\n" );
	} else {
		NSPrintf( @"Dump of Binary Heap with %lu Nodes\n", self.size );
		NSPrintf( @"%@", self );
	}
}

//- description;	// Formatted as a property list...?
- (NSString *) description {
	return [self descriptionFromParent: 0 atLevel: 0];
}

- (NSString *) descriptionFromParent: (NSUInteger) p atLevel: (int) level {
	NSMutableString *description = [NSMutableString string];
	NSUInteger child = leftChildOf( p );
	if( child < self.size )
		[description appendString: [self descriptionFromParent: child atLevel: level + 1]];
	for( int i = 0; i < level; ++i )
		[description appendString: @"        " ];
	[description appendFormat: @"%-6@\n", _objects[p]];
	child = rightChildOf( p );
	if( child < self.size )
		[description appendString: [self descriptionFromParent: child atLevel: level + 1]];
	return description;
}
- (void) printDescriptionFromParent: (NSUInteger) p atLevel: (int) level {
	NSUInteger child = leftChildOf( p );
	if( child < self.size )
		[self printDescriptionFromParent: child atLevel: level + 1];
	for( int i = 0; i < level; ++i )
		NSPrintf( @"        " );
	NSPrintf( @"%-6@\n", _objects[p] );
	child = rightChildOf( p );
	if( child < self.size )
		[self printDescriptionFromParent: child atLevel: level + 1];
}

- (NSUInteger) size { return [_objects count]; }
- (NSUInteger) count { return [_objects count]; }
- (BOOL) empty	{ return [_objects count] == 0; }
- (ObjectType) top { return _objects.firstObject; }
- (void) push: (ObjectType) object {
	if( object != nil ) {
		NSUInteger i = _objects.count;
		// Make sure there is room? If not throw NSRangeException?
		_objects[i] = object;
		[self bubbleUpFromIndex: i];
	}
}
- (void) bubbleUpFromIndex: (NSUInteger) i {
	NSUInteger p = parentOf(i);
	// Bubble-up
	while( i > 0 && [self heapCompareNode: _objects[i] toNode: _objects[p]] == NSOrderedDescending) {
		ObjectType t = _objects[p];
		_objects[p] = _objects[i];
		_objects[i] = t;
		i = p;
		p = parentOf(i);
	}
}

- (ObjectType) pop {
	ObjectType top = _objects.firstObject;
	if( _objects.count > 0 ) {
		_objects[0] = _objects.lastObject;
		[_objects removeLastObject];
		[self heapifyDownFromIndex: 0];
	}
	return top;
}
- (ObjectType) topObject { return self.top; }
- (NSArray *) allObjects { return [NSArray arrayWithArray: _objects]; }

- (void) addObject: (ObjectType) object { [self push: object]; }
- (void) addObjectsFromArray: (NSArray *) array {
	// This might be faster with Floyd's algorithm, or might not
	// it may depend on how big the array is to start with???
	for( ObjectType o in array ) {
		[self push: o ];
	}
}
- (void) removeAllObjects { [_objects removeAllObjects]; }
- (void) removeTopObject { [self pop]; }
- (void) replaceTopObjectWithObject: (id) object {
	if( object != nil ) {
		_objects[0] = object;
		[self heapifyDownFromIndex: 0];
	} else	[self pop];
}
- (BOOL) containsObject: (ObjectType) object {
#if LOCAL_FIND
	return( [self findIndexOfObject: object] != HeapIndexNotFound );
#else
	return [_objects containsObject: object];
#endif
}
#if LOCAL_FIND
- (NSUInteger) findIndexOfObject: (ObjectType) object {
	return [self findIndexOfObject: object fromIndex: 0];
}
- (NSUInteger) findIndexOfObject: (ObjectType) object fromIndex: (NSUInteger) idx {
	NSUInteger indexOfObject;
	if( !object || idx >= _objects.count ||
	    [self heapCompareNode: _objects[idx] toNode: object] == NSOrderedAscending ) {
		indexOfObject = HeapIndexNotFound;
	} else if( [object isEqual: _objects[idx]] ) {
		indexOfObject = idx;
	} else if( (indexOfObject = [self findIndexOfObject: object fromIndex: leftChildOf(idx)]) == HeapIndexNotFound ) {
		indexOfObject = [self findIndexOfObject: object fromIndex: rightChildOf(idx)];
	}
	return indexOfObject;
}
#endif

// Find the node with the object and delete it...
- (void) removeObject: (id) object {
	NSUInteger indexOfObject = [self findIndexOfObject: object];
	[self removeObjectAtIndex: indexOfObject];
}
- (void) removeObjectAtIndex: (NSUInteger) indexOfObject {
	if( indexOfObject != HeapIndexNotFound && _objects.count > 0 ) {
		_objects[indexOfObject] = _objects.lastObject;
		[_objects removeLastObject];
		[self heapifyDownFromIndex: indexOfObject];
	}
}
- (void) replaceObject: (id) object withObject: (id) newObject {
	NSUInteger indexOfObject = [self findIndexOfObject: object];
	[self replaceObjectAtIndex: indexOfObject withObject: newObject];
}
- (void) replaceObjectAtIndex: (NSUInteger) indexOfObject withObject: (id) newObject {
	if( indexOfObject == HeapIndexNotFound || _objects.count <= 0 ) {
		// If the object does not exist, then just add it to the heap
		// This is most consistent with the default implementation remove;push;
		[self push: newObject];
		// This was the older, unfriendly way...
		//[NSException raise: NSInvalidArgumentException
		//	format: @"Object is not in the heap."];
	} else if( !newObject ) {
		[self removeObjectAtIndex: indexOfObject];
	} else if( [self heapCompareNode: newObject toNode: _objects[indexOfObject]] == NSOrderedAscending ) {
		_objects[indexOfObject] = newObject;
		[self heapifyDownFromIndex: indexOfObject];
		//[NSException raise: NSInvalidArgumentException
		//	format: @"New object is not 'better' than old object."];
	} else {
		_objects[indexOfObject] = newObject;
		[self bubbleUpFromIndex: indexOfObject];
	}
}

- (void) setObjectsFromArray: (NSArray *) array {
	_objects = [NSMutableArray arrayWithArray: array];
	// I should verify that _objects.count is <= NSMAXINTEGER since
	// I cast it to a NSInteger on this call...
	if( _objects.count > 1 ) {
		for( NSInteger i = parentOf((NSInteger)_objects.count - 1); i >= 0; --i ) {
			[self heapifyDownFromIndex: i];
		}
	}
}

- (BOOL) isEqualToHeap: (Heap *) heap {
	// Call the super's isEqualToHeap...
	if( ![super isEqualToHeap: heap] )
		return NO;
	// If any of the objects in self are not in heap then they are not equal
	for( NSUInteger i = 0; i < _objects.count; ++i ) {
		if( ![heap containsObject: _objects[i]] )
			return NO;
	}
	return YES;
}

- (void) filterUsingPredicate: (NSPredicate *) predicate {
	[_objects filterUsingPredicate: predicate];
	for( NSInteger i = parentOf(_objects.count - 1); i >= 0; --i ) {
		[self heapifyDownFromIndex: i];
	}
}

// ------- //// Internal / Private Methods //// ------  //
- (void) setObjectsFromObject: (id) firstObj andArgs: (va_list) args {
	id arg = nil;
	// Should I count the args first?
	_objects = [NSMutableArray arrayWithObject: firstObj];
	while( (arg = va_arg( args, id )) ) {
		[_objects addObject: arg];
	}
	for( NSInteger i = parentOf((NSInteger)_objects.count - 1); i >= 0; --i ) {
		[self heapifyDownFromIndex: i];
	}
}
- (void) heapifyDownFromIndex: (NSInteger) p {
	NSInteger l, r;
	NSInteger largest;
	NSUInteger size = _objects.count;
	//NSLog( @"Entering heapifyDown for parent %ld for _objects of size %lu\n", p, size );
	if( size > 0 && p < size && p >= 0 ) {
		// Bubble down
		for( ; ; ) {
			// Compare root with children...
			largest = p;
			// This would work for N-ary tree with k looped to N
			//for( int k = 1; k <= 2; ++k ) {
			//	l = ((p)<< 1) + k;
			//	if( l < size &&
			//		[self heapCompareNode: _objects[l] toNode: _objects[largest]] == NSOrderedDescending ) {
			//		largest = l;
			//	}
			//}
			l = leftChildOf(p);
			r = rightChildOf(p);
			if( l < size && l >= 0 &&
			    [self heapCompareNode: _objects[l] toNode: _objects[largest]] == NSOrderedDescending )
				largest = l;
			if( r < size && r >= 0 &&
			    [self heapCompareNode: _objects[r] toNode: _objects[largest]] == NSOrderedDescending )
				largest = r;
	
			// If in correct order, we are done
			if( largest == p ) {
				break;
			} else { /* largest != p */
				// If not swap and move down
				ObjectType t = _objects[p];
				_objects[p] = _objects[largest];
				_objects[largest] = t;
				p = largest;
			}
		}
	}
}

@end
