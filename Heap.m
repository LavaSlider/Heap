#import "Heap.h"

#define	cmpr(a,b) (((a)>(b)) ? NSOrderedDescending : (((a)<(b)) ? NSOrderedAscending : NSOrderedSame))

#define DEFAULT_COMPARITOR	^NSComparisonResult( id first, id second ) { \
					return [first compare: second]; }
#define REVERSE_COMPARITOR	^NSComparisonResult( id first, id second ) { \
					return [second compare: first]; }

@implementation Heap {
	NSComparator		_comparator;
	NSSortDescriptor	*_sortDescriptor;
}

- (NSUInteger) size { return 0; }
- (NSUInteger) count { return self.size; }
- (ObjectType) top { return nil; }
- (ObjectType) pop { return nil; }
- (BOOL) empty	{ return self.size == 0; }

// Push is required... (actually so are the above, should they crash?)
- (void) push: (ObjectType) object {
	[NSException raise: NSInternalInconsistencyException
		format: @"Required method %@ has not been implemented in %@",
		NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

- (NSComparisonResult) heapCompareNode: (const id) lhs toNode: (const id) rhs {
	if( _comparator )
		return _comparator( lhs, rhs );
	return [_sortDescriptor compareObject: lhs toObject: rhs];
}

- (ObjectType) topObject { return [self top]; }
- (NSArray *) allObjects { return [NSArray array]; }
- (void) addObject: (ObjectType) object { [self push: object]; }
- (void) addObjectsFromArray: (NSArray *) array {
	for( ObjectType obj in array ) {
		[self push: obj ];
	}
}
- (void) removeTopObject { [self pop]; }
- (void) removeObject: (id) object {
	[NSException raise: NSInternalInconsistencyException
		format: @"Required method %@ has not been implemented in %@",
		NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}
- (void) removeAllObjects {
	while( [self pop] != nil );
}
- (void) replaceTopObjectWithObject: (id) object {
	[self pop];
	[self push: object];
}
- (void) replaceObject: (id) object withObject: (id) newObject {
	[self removeObject: object];
	[self push: newObject];
}

- (void) setObjectsFromArray: (NSArray *) array {
	[self removeAllObjects];
	for( ObjectType obj in array ) {
		[self push: obj ];
	}
}

- (BOOL) containsObject: (ObjectType) object {
	return NO;
}

- (BOOL) isEqualToHeap: (Heap *) heap {
	[NSException raise: NSInternalInconsistencyException
		format: @"Required method %@ has not been implemented in %@",
		NSStringFromSelector(_cmd), NSStringFromClass([self class])];
	return NO;
}

- (instancetype) init {
	return [self initMax];
}
- (instancetype) initMax {
	return [self initWithComparator: DEFAULT_COMPARITOR];
}
- (instancetype) initMin {
	return [self initWithComparator: REVERSE_COMPARITOR];
}
- (instancetype) initWithComparator: (NSComparator) comparator {
	if( [self isMemberOfClass: [Heap class]] ) {
		[NSException raise: NSInternalInconsistencyException
			format: @"Cannot instantiate Heap class, must be subclassed"];
	}
	if( (self = [super init]) ) {
		_comparator = comparator;
	}
	return self;
}
- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd {
	if( [self isMemberOfClass: [Heap class]] ) {
		[NSException raise: NSInternalInconsistencyException
			format: @"Cannot instantiate Heap class, must be subclassed"];
	}
	if( (self = [super init]) ) {
		// The reverse below is done so
		//   [[NSSortDescriptor alloc] initWithKey: key ascending: YES]
		// will create a Heap where the top is the smallest
		// (it did not seem right to have ascending YES and the
		//  priority queue have the largest entry on top even though
		//  that would be correct. The other option would be to have
		//  the default heap be a MIN heap with smallest on top if
		//  no comparator is provided)
		_sortDescriptor = [sd reversedSortDescriptor];
	}
	return self;
}

- (instancetype) initWithObject: (ObjectType) object {
	if( (self = [self init]) ) {
		[self push: object];
	}
	return self;
}
- (instancetype) initMinWithObject: (ObjectType) object {
	if( (self = [self initMin]) ) {
		[self push: object];
	}
	return self;
}
- (instancetype) initMaxWithObject: (ObjectType) object {
	if( (self = [self initMax]) ) {
		[self push: object];
	}
	return self;
}
- (instancetype) initWithComparator: (NSComparator) comparator andObject: (ObjectType) object {
	if( (self = [self initWithComparator: comparator]) ) {
		[self push: object];
	}
	return self;
}
- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andObject: (ObjectType) object {
	if( (self = [self initWithSortDescriptor: sd]) ) {
		[self push: object];
	}
	return self;
}

- (instancetype) initWithArray: (NSArray *) array {
	return [self initMaxWithArray: array];
}
- (instancetype) initMinWithArray: (NSArray *) array {
	self = [self initMin];
	[self setObjectsFromArray: array];
	return self;
}
- (instancetype) initMaxWithArray: (NSArray *) array {
	self = [self initMax];
	[self setObjectsFromArray: array];
	return self;
}
- (instancetype) initWithComparator: (NSComparator) comparator andArray: (NSArray *) array {
	self = [self initWithComparator: comparator];
	[self setObjectsFromArray: array];
	return self;
}
- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andArray: (NSArray *) array {
	self = [self initWithSortDescriptor: sd];
	[self setObjectsFromArray: array];
	return self;
}

- (instancetype) initWithObjects: (ObjectType) firstObj, ... {
	if( (self = [self init]) ) {
		va_list args;
		va_start( args, firstObj );
		[self setObjectsFromObject: firstObj andArgs: args];
		va_end( args );
	}
	return self;
}
- (instancetype) initMinWithObjects: (ObjectType) firstObj, ... {
	if( (self = [self initMin]) ) {
		va_list args;
		va_start( args, firstObj );
		[self setObjectsFromObject: firstObj andArgs: args];
		va_end( args );
	}
	return self;
}
- (instancetype) initMaxWithObjects: (ObjectType) firstObj, ... {
	if( (self = [self initMax]) ) {
		va_list args;
		va_start( args, firstObj );
		[self setObjectsFromObject: firstObj andArgs: args];
		va_end( args );
	}
	return self;
}
- (instancetype) initWithComparator: (NSComparator) comparator andObjects: (ObjectType) firstObj, ... {
	if( (self = [self initWithComparator: comparator]) ) {
		va_list args;
		va_start( args, firstObj );
		[self setObjectsFromObject: firstObj andArgs: args];
		va_end( args );
	}
	return self;
}
- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andObjects: (ObjectType) firstObj, ... {
	if( (self = [self initWithSortDescriptor: sd]) ) {
		va_list args;
		va_start( args, firstObj );
		[self setObjectsFromObject: firstObj andArgs: args];
		va_end( args );
	}
	return self;
}

- (instancetype) initWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt {
	// This might be a little wasteful to make an array like this
	// Instead I could add - (void) setObjectsFromObjects: (const id) objects count: cnt;
	// that is just like setObjectsFromArray:
	NSArray *a = [NSArray arrayWithObjects: objects count: cnt];
	return [self initWithArray: a];
}
- (instancetype) initMinWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt {
	NSArray *a = [NSArray arrayWithObjects: objects count: cnt];
	return [self initMinWithArray: a];
}
- (instancetype) initMaxWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt {
	NSArray *a = [NSArray arrayWithObjects: objects count: cnt];
	return [self initMaxWithArray: a];
}
- (instancetype) initWithComparator: (NSComparator) comparator andObjects: (const ObjectType *) objects count: (NSUInteger) cnt {
	NSArray *a = [NSArray arrayWithObjects: objects count: cnt];
	return [self initWithComparator: comparator andArray: a];
}
- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andObjects: (const ObjectType *) objects count: (NSUInteger) cnt {
	NSArray *a = [NSArray arrayWithObjects: objects count: cnt];
	return [self initWithSortDescriptor: sd andArray: a];
}

// Convenience constructors / factory methods
+ (instancetype) heap {
	return [[self alloc] init];
}
+ (instancetype) minHeap {
	return [[self alloc] initMin];
}
+ (instancetype) maxHeap {
	return [[self alloc] initMax];
}
+ (instancetype) heapWithComparator: (NSComparator) comparator {
	return [[self alloc] initWithComparator: comparator];
}
+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd {
	return [[self alloc] initWithSortDescriptor: sd];
}

+ (instancetype) heapWithObject: (ObjectType) object {
	return [[self alloc] initWithObject: object];
}
+ (instancetype) minHeapWithObject: (ObjectType) object {
	return [[self alloc] initMinWithObject: object];
}
+ (instancetype) maxHeapWithObject: (ObjectType) object {
	return [[self alloc] initMaxWithObject: object];
}
+ (instancetype) heapWithComparator: (NSComparator) comparator andObject: (ObjectType) object {
	return [[self alloc] initWithComparator: comparator andObject: object];
}
+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd andObject: (ObjectType) object {
	return [[self alloc] initWithSortDescriptor: sd andObject: object];
}

+ (instancetype) heapWithArray: (NSArray *) array {
	return [[self alloc] initWithArray: array];
}
+ (instancetype) minHeapWithArray: (NSArray *) array {
	return [[self alloc] initMinWithArray: array];
}
+ (instancetype) maxHeapWithArray: (NSArray *) array {
	return [[self alloc] initMaxWithArray: array];
}
+ (instancetype) heapWithComparator: (NSComparator) comparator andArray: (NSArray *) array {
	return [[self alloc] initWithComparator: comparator andArray: array];
}
+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd andArray: (NSArray *) array {
	return [[self alloc] initWithSortDescriptor: sd andArray: array];
}

+ (instancetype) heapWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION {
	id heap = [[self alloc] init];
	va_list args;
	va_start( args, firstObj );
	[heap setObjectsFromObject: firstObj andArgs: args];
	va_end( args );
	return heap;
}
+ (instancetype) minHeapWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION {
	id heap = [[self alloc] initMin];
	va_list args;
	va_start( args, firstObj );
	[heap setObjectsFromObject: firstObj andArgs: args];
	va_end( args );
	return heap;
}
+ (instancetype) maxHeapWithObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION {
	id heap = [[self alloc] initMax];
	va_list args;
	va_start( args, firstObj );
	[heap setObjectsFromObject: firstObj andArgs: args];
	va_end( args );
	return heap;
}
+ (instancetype) heapWithComparator: (NSComparator) comparator andObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION {
	id heap = [[self alloc] initWithComparator: comparator];
	va_list args;
	va_start( args, firstObj );
	[heap setObjectsFromObject: firstObj andArgs: args];
	va_end( args );
	return heap;
}
+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd andObjects: (ObjectType) firstObj, ... NS_REQUIRES_NIL_TERMINATION {
	id heap = [[self alloc] initWithSortDescriptor: sd];
	va_list args;
	va_start( args, firstObj );
	[heap setObjectsFromObject: firstObj andArgs: args];
	va_end( args );
	return heap;
}

+ (instancetype) heapWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt {
	return [[self alloc] initWithObjects: objects count: cnt];
}
+ (instancetype) minHeapWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt {
	return [[self alloc] initMinWithObjects: objects count: cnt];
}
+ (instancetype) maxHeapWithObjects: (const ObjectType *) objects count: (NSUInteger) cnt {
	return [[self alloc] initMaxWithObjects: objects count: cnt];
}
+ (instancetype) heapWithComparator: (NSComparator) comparator andObjects: (const ObjectType *) objects count: (NSUInteger) cnt {
	return [[self alloc] initWithComparator: comparator andObjects: objects count: cnt];
}
+ (instancetype) heapWithSortDescriptor: (NSSortDescriptor *) sd andObjects: (const ObjectType *) objects count: (NSUInteger) cnt {
	return [[self alloc] initWithSortDescriptor: sd andObjects: objects count: cnt];
}

- (void) setObjectsFromObject: (id) firstObj andArgs: (va_list) args {
	id arg = nil;
	[self removeAllObjects];
	[self push: firstObj];
	while( (arg = va_arg( args, id )) ) {
		[self push: arg];
	}
}

@end
