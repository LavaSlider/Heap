#import <Foundation/NSThread.h>

#ifndef HEAP_TYPE
# define	HEAP_TYPE	BinaryHeap
#endif

#import <stdio.h>
#import <ctype.h>

#define NSPrintf(...)	printf( "%s", [[NSString stringWithFormat: __VA_ARGS__] UTF8String] )

int get_next_integer_from_stream( FILE *ifp ) {
	int	val = 0;
#if 1
	while( fscanf( ifp, "%d", &val ) == 0 ) {
		if( fscanf( ifp, "%*s" ) == EOF ) {
			fprintf( stderr, "No integer found before EOF\n" );
			return 0;
		}
	}
	return val;
#else
	int	ch;
	while( !feof(ifp) ) {
		while( (ch = fgetc( ifp )) != EOF && isspace(ch) );
		if( isdigit(ch) ) {
			val = ch - '0';
			while( (ch = fgetc(ifp)) != EOF && isdigit(ch) ) {
				val = 10 * val + ch - '0';
			}
			return val;
		}
		while( (ch = fgetc( ifp )) != EOF && !isspace(ch) );
	}
	return val;
#endif
}

double get_next_double_from_stream( FILE *ifp ) {
	double	val = 0;
	while( fscanf( ifp, "%lf", &val ) == 0 ) {
		if( fgetc( ifp ) == '$' && fscanf( ifp, "%lf", &val ) == 1 )
			break;
		else if( fscanf( ifp, "%*s" ) == EOF ) {
			fprintf( stderr, "No float found before EOF\n" );
			return NAN;
		}
	}
	return val;
}

int myMain();
int main() {
	@autoreleasepool {
		myMain();
	}
	return 0;
}

@interface StateInfo : NSObject
@property (nonatomic, assign) NSInteger	votes;
@property (nonatomic, assign) double	cost;
+ (instancetype) withCost: (double) c andVotes: (NSInteger) v;
- (NSComparisonResult) compare: (StateInfo *) object;
@end
@implementation StateInfo
+ (instancetype) withCost: (double) c andVotes: (NSInteger) v {
	StateInfo *si = [[self alloc] init];
	si.cost = c;
	si.votes = v;
	return si;
}
#define	cmpr(a,b) (((a)>(b)) ? NSOrderedDescending : (((a)<(b)) ? NSOrderedAscending : NSOrderedSame))
- (NSComparisonResult) compare: (StateInfo *) object {
	return cmpr( self.votes, object.votes );
}
- (NSComparisonResult) compareCost: (StateInfo *) object {
	return cmpr( self.cost, object.cost );
}
- (NSString *) description {
	return [NSString stringWithFormat: @"%ld votes for $%g", self.votes, self.cost];
}
- (BOOL) isEqual: (id) object {
	if( self == object ) {
		return YES;
	}
	if( ![object isKindOfClass: [self class]] ) {
		return NO;
	}
	return self.votes == ((StateInfo *)object).votes && self.cost == ((StateInfo *)object).cost;
}
@end

typedef struct {
	int	errorCount;
	int	testCount;
}	testRecord;

// This function checks everything that is checkable about the (abstract) base class
testRecord heapCheck() {
	testRecord	tr;
	tr.errorCount = 0;
	tr.testCount = 0;
	// Make sure we cannot make a Heap object...
	Heap *h0;
	@try {	h0 = [[Heap alloc] init];
		NSPrintf( @"***** error should not be able to allocate and init a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc] initMax];
		NSPrintf( @"***** error should not be able to allocate and initMax a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc] initMin];
		NSPrintf( @"***** error should not be able to allocate and initMin a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc] initWithComparator: ^NSComparisonResult( id a, id b ) { return [a compare: b]; }];
		NSPrintf( @"***** error should not be able to allocate and initWithComparator a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc] initWithSortDescriptor: nil];
		NSPrintf( @"***** error should not be able to allocate and initWithSortDescriptor a Heap object\n" );
	}
	@catch( NSException *exception ) { }

	@try {	h0 = [[Heap alloc]  initWithObject: @5];
		NSPrintf( @"***** error should not be able to allocate and initWithObject a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initMinWithObject: @5];
		NSPrintf( @"***** error should not be able to allocate and initMinWithObject a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initMaxWithObject: @5];
		NSPrintf( @"***** error should not be able to allocate and initMaxWithObject a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initWithComparator: ^NSComparisonResult( id a, id b ) { return [a compare: b]; } andObject: @5];
		NSPrintf( @"***** error should not be able to allocate and initWithComparator:andObject a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initWithSortDescriptor: nil andObject: @5];
		NSPrintf( @"***** error should not be able to allocate and initWithSortDescriptor:andObject a Heap object\n" );
	}
	@catch( NSException *exception ) { }

	@try {	h0 = [[Heap alloc]  initWithObjects: @5, @3, nil];
		NSPrintf( @"***** error should not be able to allocate and initWithObjects: a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initMinWithObjects: @5, @3, nil];
		NSPrintf( @"***** error should not be able to allocate and initMinWithObjects: a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initMaxWithObjects: @5, @2, nil];
		NSPrintf( @"***** error should not be able to allocate and initMaxWithObjects: a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initWithComparator: ^NSComparisonResult( id a, id b ) { return [a compare: b]; } andObjects: @5, @3, nil];
		NSPrintf( @"***** error should not be able to allocate and initWithComparator:andObjects: a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initWithSortDescriptor: nil andObjects: @5, @1, nil];
		NSPrintf( @"***** error should not be able to allocate and initWithSortDescriptor:andObjects: a Heap object\n" );
	}
	@catch( NSException *exception ) { }

	@try {	h0 = [[Heap alloc]  initWithArray: nil];
		NSPrintf( @"***** error should not be able to allocate and initWithArray a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initMinWithArray: nil];
		NSPrintf( @"***** error should not be able to allocate and initMinWithArray a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initMaxWithArray: nil];
		NSPrintf( @"***** error should not be able to allocate and initMaxWithArray a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initWithComparator: ^NSComparisonResult( id a, id b ) { return [a compare: b]; } andArray: nil];
		NSPrintf( @"***** error should not be able to allocate and initWithComparator:andArray a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initWithSortDescriptor: nil andArray: nil];
		NSPrintf( @"***** error should not be able to allocate and initWithSortDescriptor:andArray: a Heap object\n" );
	}
	@catch( NSException *exception ) { }

	id stuff[] = { @5, @3, @1 };
	@try {	h0 = [[Heap alloc]  initWithObjects: stuff count: 3];
		NSPrintf( @"***** error should not be able to allocate and initWithObjects:count: a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initMinWithObjects: stuff count: 3];
		NSPrintf( @"***** error should not be able to allocate and initMinWithObjects:count: a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initMaxWithObjects: stuff count: 3];
		NSPrintf( @"***** error should not be able to allocate and initMaxWithObjects:count: a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initWithComparator: ^NSComparisonResult( id a, id b ) { return [a compare: b]; } andObjects: stuff count: 3];
		NSPrintf( @"***** error should not be able to allocate and initWithComparator:andObjects:count: a Heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [[Heap alloc]  initWithSortDescriptor: nil andObjects: stuff count: 3];
		NSPrintf( @"***** error should not be able to allocate and initWithSortDescriptor:andObjects:count: a Heap object\n" );
	}
	@catch( NSException *exception ) { }

	@try {	h0 = [Heap heap];
		NSPrintf( @"***** error should not be able to create a Heap heap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap maxHeap];
		NSPrintf( @"***** error should not be able to create a Heap maxHeap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap minHeap];
		NSPrintf( @"***** error should not be able to create a Heap minHeap object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap heapWithComparator: ^NSComparisonResult( id a, id b ) { return [a compare: b]; }];
		NSPrintf( @"***** error should not be able to create a Heap heapWithComparator: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap heapWithSortDescriptor: nil];
		NSPrintf( @"***** error should not be able to create a Heap heapWithSortDescriptor: object\n" );
	}
	@catch( NSException *exception ) { }

	@try {	h0 = [Heap  heapWithObject: @5];
		NSPrintf( @"***** error should not be able to create a Heap heapWithObject: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  minHeapWithObject: @5];
		NSPrintf( @"***** error should not be able to create a Heap minHeapWithObject: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  maxHeapWithObject: @5];
		NSPrintf( @"***** error should not be able to create a Heap maxHeapWithObject: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  heapWithComparator: ^NSComparisonResult( id a, id b ) { return [a compare: b]; } andObject: @5];
		NSPrintf( @"***** error should not be able to create a Heap heapWithComparator:andObject: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  heapWithSortDescriptor: nil andObject: @5];
		NSPrintf( @"***** error should not be able to create a Heap heapWithSortDescriptor:andObject: object\n" );
	}
	@catch( NSException *exception ) { }

	@try {	h0 = [Heap  heapWithObjects: @5, @3, nil];
		NSPrintf( @"***** error should not be able to create a Heap heapWithObjects: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  minHeapWithObjects: @5, @3, nil];
		NSPrintf( @"***** error should not be able to create a Heap minHeapWithObjects: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  maxHeapWithObjects: @5, @2, nil];
		NSPrintf( @"***** error should not be able to create a Heap maxHeapWithObjects: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  heapWithComparator: ^NSComparisonResult( id a, id b ) { return [a compare: b]; } andObjects: @5, @3, nil];
		NSPrintf( @"***** error should not be able to create a Heap heapWithComparator:andObjects:: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  heapWithSortDescriptor: nil andObjects: @5, @1, nil];
		NSPrintf( @"***** error should not be able to create a Heap heapWithSortDescriptor:andObjects:: object\n" );
	}
	@catch( NSException *exception ) { }

	@try {	h0 = [Heap  heapWithArray: nil];
		NSPrintf( @"***** error should not be able to create a Heap heapWithArray: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  minHeapWithArray: nil];
		NSPrintf( @"***** error should not be able to create a Heap minHeapWithArray: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  maxHeapWithArray: nil];
		NSPrintf( @"***** error should not be able to create a Heap maxHeapWithArray: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  heapWithComparator: ^NSComparisonResult( id a, id b ) { return [a compare: b]; } andArray: nil];
		NSPrintf( @"***** error should not be able to create a Heap maxHeapWithComparator:andArray: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  heapWithSortDescriptor: nil andArray: nil];
		NSPrintf( @"***** error should not be able to create a Heap maxHeapWithSortDescriptor:andArray: object\n" );
	}
	@catch( NSException *exception ) { }

	//id stuff[] = { @5, @3, @1 }; /* Uses stuff from above... */
	@try {	h0 = [Heap  heapWithObjects: stuff count: 3];
		NSPrintf( @"***** error should not be able to create a Heap heapWithObjects:count:: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  minHeapWithObjects: stuff count: 3];
		NSPrintf( @"***** error should not be able to create a Heap minHeapWithObjects:count:: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  maxHeapWithObjects: stuff count: 3];
		NSPrintf( @"***** error should not be able to create a Heap maxHeapWithObjects:count:: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  heapWithComparator: ^NSComparisonResult( id a, id b ) { return [a compare: b]; } andObjects: stuff count: 3];
		NSPrintf( @"***** error should not be able to create a Heap heapWithComparator:andObjects:count:: object\n" );
	}
	@catch( NSException *exception ) { }
	@try {	h0 = [Heap  heapWithSortDescriptor: nil andObjects: stuff count: 3];
		NSPrintf( @"***** error should not be able to create a Heap heapWithSortDescriptor:andObjects:count:: object\n" );
	}
	@catch( NSException *exception ) { }

	return tr;
}
testRecord beatAnEmptyHeap( Heap *h1, BOOL isMax ) {
	testRecord	tr;
	tr.errorCount = 0;
	tr.testCount = 0;

	// Make some internal test heaps...
	HEAP_TYPE	*ith, *neh;
	if( isMax ) {
		ith = [[HEAP_TYPE alloc] initMax];
		neh = [[HEAP_TYPE alloc] initMax];
		[neh push: @"hello"];
	} else {
		ith = [[HEAP_TYPE alloc] initMin];
		neh = [[HEAP_TYPE alloc] initMin];
		[neh push: @"hello"];
	}

	//NSMutableArray *xxx = [NSMutableArray arrayWithObjects: @1, @2, @3, nil];
	//@try{	[xxx removeObject: nil];
	//	NSPrintf( @"***** NSMutableArray removeObject: nil worked fine, left the array as (%@)\n",
	//		[xxx componentsJoinedByString: @","] );
	//}
	//@catch( NSException *exception ) {
	//	NSPrintf( @"***** NSMutableArray removeObject: nil throws %@\n", exception );
	//}

	// Try everything against the heap while it is empty...
	if( [h1 pop] != nil ) NSPrintf( @"***** error pop of empty heap should return nil\n" );
	if( [h1 top] != nil ) NSPrintf( @"***** error top of empty heap should return nil\n" );
	if( h1.size != 0 ) NSPrintf( @"***** error newly allocated heap should have size 0\n" );
	if( !h1.empty ) NSPrintf( @"***** error newly allocated heap should be empty\n" );
	[h1 removeObject: @99];	// Make sure it doesn't crash removing object from empty heap...
	[h1 removeObject: @"hello"];	// Make sure it doesn't crash removing object from empty heap...
	[h1 removeObject: nil];	// Make sure it doesn't crash removing object from empty heap...
	if( [h1 containsObject: @99] ) NSPrintf( @"***** error: contains returns YES for empty heap\n" );
	if( [h1 containsObject: nil] ) NSPrintf( @"***** error: contains nil returns YES for empty heap\n" );
	if( [h1 isEqual: nil] ) NSPrintf( @"***** error an empty heap should not be equal to nil\n" );
	if( [h1 isEqual: @"hello"] ) NSPrintf( @"***** error an empty heap should not be equal to a string\n" );
	if( [h1 isEqual: neh] ) NSPrintf( @"***** error an empty heap should not be equal to a non-empty heap\n" );
	if( ![h1 isEqual: h1] ) NSPrintf( @"***** error an empty heap should be equal to itself\n" );
	if( ![h1 isEqual: ith] ) NSPrintf( @"***** error two empty heaps should be equal\n" );
	if( ![h1 isEqualToHeap: ith] ) NSPrintf( @"***** error two empty heaps should be equal\n" );
	[h1 removeTopObject]; // Make sure it doesn't crash removing top object from empty heap...
	if( [h1 topObject] != nil ) NSPrintf( @"***** error topObject of empty heap should return nil\n" );
	if( h1.count != 0 ) NSPrintf( @"***** error newly allocated heap should have count 0\n" );
	if( [h1 allObjects] == nil ) NSPrintf( @"***** error allObjects on newly allocated heap should not be nil\n" );
	if( ![[h1 allObjects] isKindOfClass: [NSArray class]] ) NSPrintf( @"***** error allObjects on newly allocated heap should return an array\n" );
	if( ![[h1 allObjects] count] == 0 ) NSPrintf( @"***** error the array from a newly allocated heap should have count 0\n" );
	[h1 removeAllObjects]; // Make sure it doesn't crash removing all objects from empty heap...
	@try {	[h1 push: nil]; // This should do nothing and should not throw an exception
		//NSPrintf( @"***** no-error [heap push: nil] succeeded, this is what it should do\n" );
		if( h1.size != 0 ) NSPrintf( @"***** error pushed nil on heap should do nothing, size should still be 0 not %lu\n", h1.size );
		if( h1.size != 0 ) [h1 removeAllObjects]; // Fix things so later tests don't fail...
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap push: nil] threw exception (%@)\n", exception );
	}

	// Now make it non-empty and try some more...
	[h1 push: @1];
	if( h1.size != 1 ) NSPrintf( @"***** error pushed one item on heap, its size is should be 1 not %lu\n", h1.size );
	if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( [[h1 top] intValue] != 1 ) NSPrintf( @"***** error top of heap should be 1 not %d\n", [h1.top intValue] );
	[h1 removeObject: @99];	// Make sure it doesn't crash non-existent object from empty heap...
	@try { [h1 removeObject: nil];	// This should do nothing and should not throw an exception
		if( h1.size != 1 ) NSPrintf( @"***** error remove nil should do nothing, the size is should still be 1 not %lu\n", h1.size );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap removeObject: nil] should not throw an exeption (%@)\n", exception );
		NSPrintf( @"            By design, remove nil should do nothing\n" );
	}
	@try {	[h1 push: nil]; // This should do nothing and should not throw an exception
		//NSPrintf( @"***** no-error [heap push: nil] succeeded, this is what it should do\n" );
		if( h1.size != 1 ) NSPrintf( @"***** error pushed nil on heap should do nothing, size should still be 1 not %lu\n", h1.size );
		if( h1.size != 1 ) [h1 pop]; // Fix things so later tests don't fail...
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap push: nil] threw exception (%@)\n", exception );
	}
	[h1 push: @2];
	if( h1.size != 2 ) NSPrintf( @"***** error pushed second item on heap, its size is should be 2 not %lu\n", h1.size );
	if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	[h1 removeObject: @99];	// Make sure it doesn't crash removing non-existent object...
	@try { [h1 removeObject: nil];	// This should do nothing and should not throw an exception
		if( h1.size != 2 ) NSPrintf( @"***** error remove nil should do nothing, the size is should still be 2 not %lu\n", h1.size );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap removeObject: nil] should not throw an exeption (%@)\n", exception );
		NSPrintf( @"            By design, remove nil should do nothing\n" );
	}
	if( isMax ) {
		if( [[h1 top] intValue] != 2 ) NSPrintf( @"***** error top of heap should be 2 not %d\n", [h1.top intValue] );
	} else {
		if( [[h1 top] intValue] != 1 ) NSPrintf( @"***** error top of heap should be 1 not %d\n", [h1.top intValue] );
	}
	[h1 addObject: @-2];
	if( h1.size != 3 ) NSPrintf( @"***** error pushed third item on heap, its size is should be 3 not %lu\n", h1.size );
	if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @-2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( isMax ) {
		if( [[h1 top] intValue] != 2 ) NSPrintf( @"***** error top of heap should be 2 not %d\n", [h1.top intValue] );
	} else {
		if( [[h1 top] intValue] != -2 ) NSPrintf( @"***** error top of heap should be -2 not %d\n", [h1.top intValue] );
	}
	[h1 addObjectsFromArray: @[ @4, @-4, @-6, @6 ] ];
	if( h1.size != 7 ) NSPrintf( @"***** error pushed 4 items on heap, its size is should be 7 not %lu\n", h1.size );
	[h1 removeObject: @99];	// Make sure it doesn't crash removing non-existent object...
	@try { [h1 removeObject: nil];	// This should do nothing and should not throw an exception
		if( h1.size != 7 ) NSPrintf( @"***** error remove nil should do nothing, its size is should still be 7 not %lu\n", h1.size );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap removeObject: nil] should not throw an exeption (%@)\n", exception );
		NSPrintf( @"            By design, remove nil should do nothing\n" );
	}
	@try {	[h1 push: nil]; // This should do nothing and should not throw an exception
		//NSPrintf( @"***** no-error [heap push: nil] succeeded, this is what it should do\n" );
		if( h1.size != 7 ) NSPrintf( @"***** error pushed nil on heap should do nothing, size should still be 7 not %lu\n", h1.size );
		if( h1.size != 7 ) [h1 pop]; // Fix things so later tests don't fail...
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap push: nil] threw exception (%@)\n", exception );
	}
	if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @-2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( isMax ) {
		if( [[h1 top] intValue] != 6 ) NSPrintf( @"***** error top of heap should be 6 not %d\n", [h1.top intValue] );
	} else {
		if( [[h1 top] intValue] != -6 ) NSPrintf( @"***** error top of heap should be -6 not %d\n", [h1.top intValue] );
	}
	id temp1 = [h1 pop];
	id temp2 = [h1 pop];
	[h1 push: temp1];
	[h1 addObject: temp2];
	if( h1.size != 7 ) NSPrintf( @"***** error popped and pushed 2 items on heap, its size is should be 7 not %lu\n", h1.size );
	@try {	[h1 addObject: nil]; // This should do nothing and should not throw an exception
		//NSPrintf( @"***** no-error [heap addObject: nil] succeeded, this is what it should do\n" );
		if( h1.size != 7 ) NSPrintf( @"***** error addObject nil should do nothing, size should still be 7 not %lu\n", h1.size );
		if( h1.size != 7 ) [h1 pop]; // Fix things so later tests don't fail...
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap addObject: nil] threw exception (%@)\n", exception );
	}
	if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @-2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( [h1 isEqual: nil] ) NSPrintf( @"***** error a non-empty heap should not be equal to nil\n" );
	if( [h1 isEqual: @"hello"] ) NSPrintf( @"***** error a non-empty heap should not be equal to a string\n" );
	if( [h1 isEqual: neh] ) NSPrintf( @"***** error a non-empty heap should not be equal to another non-empty heap\n" );
	if( ![h1 isEqual: h1] ) NSPrintf( @"***** error an empty heap should be equal to itself\n" );
	if( isMax ) {
		if( ![h1 isEqual: [HEAP_TYPE maxHeapWithObjects: @1, @2, @-2, @-4, @4, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
		if( ![h1 isEqualToHeap: [HEAP_TYPE maxHeapWithObjects: @1, @2, @-2, @-4, @4, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
		if( [[h1 top] intValue] != 6 ) NSPrintf( @"***** error top of heap should be 6 not %d\n", [h1.top intValue] );
	} else {
		if( ![h1 isEqual: [HEAP_TYPE minHeapWithObjects: @1, @2, @-2, @-4, @4, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
		if( ![h1 isEqualToHeap: [HEAP_TYPE minHeapWithObjects: @1, @2, @-2, @-4, @4, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
		if( [[h1 top] intValue] != -6 ) NSPrintf( @"***** error top of heap should be -6 not %d\n", [h1.top intValue] );
	}


	// replaceTopObjectWithObject: (id) anObject testing...
	// Replace top object with nil
	@try {	[h1 replaceTopObjectWithObject: nil];	// This should remove top object
		//NSPrintf( @"***** no-error [heap addObject: nil] succeeded, this is what it should do\n" );
		if( h1.size != 6 ) NSPrintf( @"***** error after replaceTopObject: nil, size should be 6 not %lu\n", h1.size );
		if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
		if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @-2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( [h1 isEqual: nil] ) NSPrintf( @"***** error a non-empty heap should not be equal to nil\n" );
		if( [h1 isEqual: @"hello"] ) NSPrintf( @"***** error a non-empty heap should not be equal to a string\n" );
		if( [h1 isEqual: neh] ) NSPrintf( @"***** error a non-empty heap should not be equal to another non-empty heap\n" );
		if( ![h1 isEqual: h1] ) NSPrintf( @"***** error an empty heap should be equal to itself\n" );
		if( isMax ) {
			if( ![h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns NO for entry -6 in heap\n" );
			if( [h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns YES for entry 6 not in heap\n" );
			if( [[h1 top] intValue] != 4 ) NSPrintf( @"***** error top of heap should now be 4 not %d\n", [[h1 top] intValue] );
		} else {
			if( [h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns YES for entry -6 not in heap\n" );
			if( ![h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns NO for entry 6 in heap\n" );
			if( [[h1 top] intValue] != -4 ) NSPrintf( @"***** error top of heap should now be -4 not %d\n", [[h1 top] intValue] );
		}
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap replaceTopObject: nil] threw exception (%@)\n", exception );
	}
	// Replace top object with new maximum
	@try {	[h1 replaceTopObjectWithObject: @8];
		if( h1.size != 6 ) NSPrintf( @"***** error after replaceTopObject: @8, size should still be 6 not %lu\n", h1.size );
		if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
		if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @-2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @8] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( [h1 isEqual: nil] ) NSPrintf( @"***** error a non-empty heap should not be equal to nil\n" );
		if( [h1 isEqual: @"hello"] ) NSPrintf( @"***** error a non-empty heap should not be equal to a string\n" );
		if( [h1 isEqual: neh] ) NSPrintf( @"***** error a non-empty heap should not be equal to another non-empty heap\n" );
		if( ![h1 isEqual: h1] ) NSPrintf( @"***** error an empty heap should be equal to itself\n" );
		if( isMax ) {
			if( ![h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
			if( ![h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
			if( [h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
			if( [h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
			if( [[h1 top] intValue] != 8 ) NSPrintf( @"***** error top of heap should now be 8 not %d\n", [[h1 top] intValue] );
		} else {
			if( [h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
			if( [h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
			if( ![h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
			if( ![h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
			if( [[h1 top] intValue] != -2 ) NSPrintf( @"***** error top of heap should now be -2 not %d\n", [[h1 top] intValue] );
		}
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap replaceTopObject: nil] threw exception (%@)\n", exception );
	}
	// Replace top object with new minimum
	@try {	[h1 replaceTopObjectWithObject: @-8];
		if( h1.size != 6 ) NSPrintf( @"***** error after replaceTopObject: @-8, size should still be 6 not %lu\n", h1.size );
		if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
		if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @-8] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( [h1 isEqual: nil] ) NSPrintf( @"***** error a non-empty heap should not be equal to nil\n" );
		if( [h1 isEqual: @"hello"] ) NSPrintf( @"***** error a non-empty heap should not be equal to a string\n" );
		if( [h1 isEqual: neh] ) NSPrintf( @"***** error a non-empty heap should not be equal to another non-empty heap\n" );
		if( ![h1 isEqual: h1] ) NSPrintf( @"***** error an empty heap should be equal to itself\n" );
		if( isMax ) {
			if( ![h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
			if( ![h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
			if( [h1 containsObject: @8] ) NSPrintf( @"***** error: contains returns YES for entry 8 not in heap\n" );
			if( [h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns YES for entry 6 not in heap\n" );
			if( [h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns YES for entry 4 not in heap\n" );
			if( [[h1 top] intValue] != 2 ) NSPrintf( @"***** error top of heap should now be 2 not %d\n", [[h1 top] intValue] );
		} else {
			if( [h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns YES for entry -6 not in heap\n" );
			if( [h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns YES for entry -4 not in heap\n" );
			if( [h1 containsObject: @-2] ) NSPrintf( @"***** error: contains returns YES for entry -2 not in heap\n" );
			if( ![h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns NO for entry 6 in heap\n" );
			if( ![h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry 4 in heap\n" );
			if( [[h1 top] intValue] != -8 ) NSPrintf( @"***** error top of heap should now be -8 not %d\n", [[h1 top] intValue] );
		}
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap replaceTopObject: nil] threw exception (%@)\n", exception );
	}
	// Replace top object with something in the middle
	@try {	[h1 replaceTopObjectWithObject: @-5];
		if( h1.size != 6 ) NSPrintf( @"***** error after replaceTopObject: @-5, size should still be 6 not %lu\n", h1.size );
		if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
		if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @-5] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( [h1 isEqual: nil] ) NSPrintf( @"***** error a non-empty heap should not be equal to nil\n" );
		if( [h1 isEqual: @"hello"] ) NSPrintf( @"***** error a non-empty heap should not be equal to a string\n" );
		if( [h1 isEqual: neh] ) NSPrintf( @"***** error a non-empty heap should not be equal to another non-empty heap\n" );
		if( ![h1 isEqual: h1] ) NSPrintf( @"***** error an empty heap should be equal to itself\n" );
		if( isMax ) {
			if( ![h1 containsObject: @-8] ) NSPrintf( @"***** error: contains returns NO for entry -8 in heap\n" );
			if( ![h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns NO for entry -6 in heap\n" );
			if( ![h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns NO for entry -4 in heap\n" );
			if( [h1 containsObject: @8] ) NSPrintf( @"***** error: contains returns YES for entry 8 not in heap\n" );
			if( [h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns YES for entry 6 not in heap\n" );
			if( [h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns YES for entry 4 not in heap\n" );
			if( [h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns YES for entry 2 not in heap\n" );
			if( [[h1 top] intValue] != 1 ) NSPrintf( @"***** error top of heap should now be 2 not %d\n", [[h1 top] intValue] );
		} else {
			if( [h1 containsObject: @-8] ) NSPrintf( @"***** error: contains returns YES for entry -8 not in heap\n" );
			if( [h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns YES for entry -6 not in heap\n" );
			if( [h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns YES for entry -4 not in heap\n" );
			if( [h1 containsObject: @-2] ) NSPrintf( @"***** error: contains returns YES for entry -2 not in heap\n" );
			if( ![h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns NO for entry 6 in heap\n" );
			if( ![h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry 4 in heap\n" );
			if( ![h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns NO for entry 2 in heap\n" );
			if( [[h1 top] intValue] != -5 ) NSPrintf( @"***** error top of heap should now be -5 not %d\n", [[h1 top] intValue] );
		}
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap replaceTopObject: nil] threw exception (%@)\n", exception );
	}
	// Replace top object with something else in the middle
	@try {	[h1 replaceTopObjectWithObject: @5];
		if( h1.size != 6 ) NSPrintf( @"***** error after replaceTopObject: @5, size should still be 6 not %lu\n", h1.size );
		if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
		//if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @5] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		//if( ![h1 containsObject: @-5] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( [h1 isEqual: nil] ) NSPrintf( @"***** error a non-empty heap should not be equal to nil\n" );
		if( [h1 isEqual: @"hello"] ) NSPrintf( @"***** error a non-empty heap should not be equal to a string\n" );
		if( [h1 isEqual: neh] ) NSPrintf( @"***** error a non-empty heap should not be equal to another non-empty heap\n" );
		if( ![h1 isEqual: h1] ) NSPrintf( @"***** error an empty heap should be equal to itself\n" );
		if( isMax ) {
			if( ![h1 containsObject: @-8] ) NSPrintf( @"***** error: contains returns NO for entry -8 in heap\n" );
			if( ![h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns NO for entry -6 in heap\n" );
			if( ![h1 containsObject: @-5] ) NSPrintf( @"***** error: contains returns NO for entry -5 in heap\n" );
			if( ![h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns NO for entry -4 in heap\n" );
			if( [h1 containsObject: @8] ) NSPrintf( @"***** error: contains returns YES for entry 8 not in heap\n" );
			if( [h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns YES for entry 6 not in heap\n" );
			if( [h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns YES for entry 4 not in heap\n" );
			if( [h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns YES for entry 2 not in heap\n" );
			if( [h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns YES for entry 1 not in heap\n" );
			if( [[h1 top] intValue] != 5 ) NSPrintf( @"***** error top of heap should now be 5 not %d\n", [[h1 top] intValue] );
		} else {
			if( [h1 containsObject: @-8] ) NSPrintf( @"***** error: contains returns YES for entry -8 not in heap\n" );
			if( [h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns YES for entry -6 not in heap\n" );
			if( [h1 containsObject: @-5] ) NSPrintf( @"***** error: contains returns YES for entry -5 not in heap\n" );
			if( [h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns YES for entry -4 not in heap\n" );
			if( [h1 containsObject: @-2] ) NSPrintf( @"***** error: contains returns YES for entry -2 not in heap\n" );
			if( ![h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns NO for entry 6 in heap\n" );
			if( ![h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry 4 in heap\n" );
			if( ![h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns NO for entry 2 in heap\n" );
			if( [[h1 top] intValue] != 1 ) NSPrintf( @"***** error top of heap should now be 1 not %d\n", [[h1 top] intValue] );
		}
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap replaceTopObject: nil] threw exception (%@)\n", exception );
	}


	// Test replaceObject: (id) object withObject: (id) newObject;
	// Reset the contents of the heap...
	[h1 setObjectsFromArray: @[ @1, @2, @-2, @-4, @4, @-6, @6]];
	if( h1.size != 7 ) NSPrintf( @"***** error setObjectsFromArray with 7 entries, size should be 7 not %lu\n", h1.size );
	temp1 = [h1 pop];
	temp2 = [h1 pop];
	[h1 push: temp1];
	[h1 addObject: temp2];
	if( h1.size != 7 ) NSPrintf( @"***** error popped and pushed 2 entries, size should still be 7 not %lu\n", h1.size );
	if( isMax ) {
		if( ![h1 isEqual: [HEAP_TYPE maxHeapWithObjects: @1, @2, @4, @-2, @-4, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
		if( ![h1 isEqualToHeap: [HEAP_TYPE maxHeapWithObjects: @1, @2, @-4, @4, @-2, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
	} else {
		if( ![h1 isEqual: [HEAP_TYPE minHeapWithObjects: @1, @-4, @2, @-2, @4, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
		if( ![h1 isEqualToHeap: [HEAP_TYPE minHeapWithObjects: @1, @-2, @-4, @4, @2, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
	}
	[h1 replaceObject: nil withObject: nil];
	if( h1.size != 7 ) NSPrintf( @"***** error replaced nil with nil, its size is should still be 7 not %lu\n", h1.size );
	if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( ![h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @-2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( [h1 isEqual: nil] ) NSPrintf( @"***** error a non-empty heap should not be equal to nil\n" );
	if( [h1 isEqual: @"hello"] ) NSPrintf( @"***** error a non-empty heap should not be equal to a string\n" );
	if( [h1 isEqual: neh] ) NSPrintf( @"***** error a non-empty heap should not be equal to another non-empty heap\n" );
	if( ![h1 isEqual: h1] ) NSPrintf( @"***** error an empty heap should be equal to itself\n" );
	if( isMax ) {
		if( ![h1 isEqual: [HEAP_TYPE maxHeapWithObjects: @1, @2, @-2, @-4, @4, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
		if( ![h1 isEqualToHeap: [HEAP_TYPE maxHeapWithObjects: @1, @2, @-2, @-4, @4, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
		if( [[h1 top] intValue] != 6 ) NSPrintf( @"***** error top of heap should be 6 not %d\n", [h1.top intValue] );
	} else {
		if( ![h1 isEqual: [HEAP_TYPE minHeapWithObjects: @1, @2, @-2, @-4, @4, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
		if( ![h1 isEqualToHeap: [HEAP_TYPE minHeapWithObjects: @1, @2, @-2, @-4, @4, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
		if( [[h1 top] intValue] != -6 ) NSPrintf( @"***** error top of heap should be -6 not %d\n", [h1.top intValue] );
	}
	[h1 replaceObject: @1 withObject: @-1];
	if( h1.size != 7 ) NSPrintf( @"***** error replaced 1 with -1, its size is should still be 7 not %lu\n", h1.size );
	if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( [h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( ![h1 containsObject: @-1] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @-2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( [h1 isEqual: nil] ) NSPrintf( @"***** error a non-empty heap should not be equal to nil\n" );
	if( [h1 isEqual: @"hello"] ) NSPrintf( @"***** error a non-empty heap should not be equal to a string\n" );
	if( [h1 isEqual: neh] ) NSPrintf( @"***** error a non-empty heap should not be equal to another non-empty heap\n" );
	if( ![h1 isEqual: h1] ) NSPrintf( @"***** error an empty heap should be equal to itself\n" );
	if( isMax ) {
		if( ![h1 isEqual: [HEAP_TYPE maxHeapWithObjects: @-1, @2, @-2, @-4, @4, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
		if( ![h1 isEqualToHeap: [HEAP_TYPE maxHeapWithObjects: @-1, @2, @-2, @-4, @4, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
		if( [[h1 top] intValue] != 6 ) NSPrintf( @"***** error top of heap should be 6 not %d\n", [h1.top intValue] );
	} else {
		if( ![h1 isEqual: [HEAP_TYPE minHeapWithObjects: @-1, @2, @-2, @-4, @4, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
		if( ![h1 isEqualToHeap: [HEAP_TYPE minHeapWithObjects: @-1, @2, @-2, @-4, @4, @-6, @6, nil]] )
			NSPrintf( @"***** error heaps with the same content should be equal\n" );
		if( [[h1 top] intValue] != -6 ) NSPrintf( @"***** error top of heap should be -6 not %d\n", [h1.top intValue] );
	}
	@try {	[h1 replaceObject: @-1 withObject: nil];	// This should cause a removeObject:
		if( h1.size != 6 ) NSPrintf( @"***** error replaced -1 with nil, heap size is should be 6 not %lu\n", h1.size );
		if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry 3 not in heap\n" );
		if( [h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns YES for entry 1 not in heap\n" );
		if( [h1 containsObject: @-1] ) NSPrintf( @"***** error: contains returns YES for entry -1 that should not be in heap\n" );
		if( ![h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @-2] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( ![h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
		if( [h1 isEqual: nil] ) NSPrintf( @"***** error a non-empty heap should not be equal to nil\n" );
		if( [h1 isEqual: @"hello"] ) NSPrintf( @"***** error a non-empty heap should not be equal to a string\n" );
		if( [h1 isEqual: neh] ) NSPrintf( @"***** error a non-empty heap should not be equal to another non-empty heap\n" );
		if( ![h1 isEqual: h1] ) NSPrintf( @"***** error an empty heap should be equal to itself\n" );
		if( isMax ) {
			if( ![h1 isEqual: [HEAP_TYPE maxHeapWithObjects: @2, @-2, @-4, @4, @-6, @6, nil]] )
				NSPrintf( @"***** error heaps with the same content should be equal\n" );
			if( ![h1 isEqualToHeap: [HEAP_TYPE maxHeapWithObjects: @2, @-2, @-4, @4, @-6, @6, nil]] )
				NSPrintf( @"***** error heaps with the same content should be equal\n" );
			if( [[h1 top] intValue] != 6 ) NSPrintf( @"***** error top of heap should be 6 not %d\n", [h1.top intValue] );
		} else {
			if( ![h1 isEqual: [HEAP_TYPE minHeapWithObjects: @2, @-2, @-4, @4, @-6, @6, nil]] )
				NSPrintf( @"***** error heaps with the same content should be equal\n" );
			if( ![h1 isEqualToHeap: [HEAP_TYPE minHeapWithObjects: @2, @-2, @-4, @4, @-6, @6, nil]] )
				NSPrintf( @"***** error heaps with the same content should be equal\n" );
			if( [[h1 top] intValue] != -6 ) NSPrintf( @"***** error top of heap should be -6 not %d\n", [h1.top intValue] );
		}
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap replaceTopObject: @1 withObject: nil] threw exception (%@)\n", exception );
	}
	@try {	[h1 replaceObject: nil withObject: @1];	// This should cause a push
		if( h1.size != 7 ) NSPrintf( @"***** error replaced nil with 1, its size is should now be 7 not %lu\n", h1.size );
		if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
		if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for entry 1 in heap\n" );
		if( [h1 containsObject: @-1] ) NSPrintf( @"***** error: contains returns YES for entry -1 not in heap\n" );
		if( ![h1 containsObject: @2] ) NSPrintf( @"***** error: contains returns NO for entry 2 in heap\n" );
		if( ![h1 containsObject: @-2] ) NSPrintf( @"***** error: contains returns NO for entry -2 in heap\n" );
		if( ![h1 containsObject: @-4] ) NSPrintf( @"***** error: contains returns NO for entry -4 in heap\n" );
		if( ![h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry 4 in heap\n" );
		if( ![h1 containsObject: @-6] ) NSPrintf( @"***** error: contains returns NO for entry -6 in heap\n" );
		if( ![h1 containsObject: @6] ) NSPrintf( @"***** error: contains returns NO for entry 6 in heap\n" );
		if( [h1 isEqual: nil] ) NSPrintf( @"***** error a non-empty heap should not be equal to nil\n" );
		if( [h1 isEqual: @"hello"] ) NSPrintf( @"***** error a non-empty heap should not be equal to a string\n" );
		if( [h1 isEqual: neh] ) NSPrintf( @"***** error a non-empty heap should not be equal to another non-empty heap\n" );
		if( ![h1 isEqual: h1] ) NSPrintf( @"***** error an empty heap should be equal to itself\n" );
		if( isMax ) {
			if( ![h1 isEqual: [HEAP_TYPE maxHeapWithObjects: @1, @2, @-2, @-4, @4, @-6, @6, nil]] )
				NSPrintf( @"***** error heaps with the same content should be equal\n" );
			if( ![h1 isEqualToHeap: [HEAP_TYPE maxHeapWithObjects: @2, @-2, @1, @-4, @4, @-6, @6, nil]] )
				NSPrintf( @"***** error heaps with the same content should be equal\n" );
			if( [[h1 top] intValue] != 6 ) NSPrintf( @"***** error top of heap should be 6 not %d\n", [h1.top intValue] );
		} else {
			if( ![h1 isEqual: [HEAP_TYPE minHeapWithObjects: @2, @-2, @-4, @1, @4, @-6, @6, nil]] )
				NSPrintf( @"***** error heaps with the same content should be equal\n" );
			if( ![h1 isEqualToHeap: [HEAP_TYPE minHeapWithObjects: @2, @-2, @-4, @4, @1, @-6, @6, nil]] )
				NSPrintf( @"***** error heaps with the same content should be equal\n" );
			if( [[h1 top] intValue] != -6 ) NSPrintf( @"***** error top of heap should be -6 not %d\n", [h1.top intValue] );
		}
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap replaceTopObject: nil withObject: @1] threw exception (%@)\n", exception );
	}

	// Testing of  setObjectsFromArray: (NSArray *) array;
	// These silently succeed...
	//NSMutableArray *testArray = [NSMutableArray arrayWithArray: nil];
	//[testArray addObject: @1];
	// This, however fails since 'nil' is not fast enumerable...
	//for( id object in nil ) {
	//	NSPrintf( @"Hello world!\n" );
	//}
	// This silently does nothing...
	//NSMutableArray *testArray2 = nil;
	//for( id object in testArray2 ) {
	//	NSPrintf( @"Hello world!\n" );
	//}
	@try {	[h1 setObjectsFromArray: nil];
		if( h1.size != 0 ) NSPrintf( @"***** error setObjectFromArray:nil should end up with a size of 0 not %lu\n", h1.size );
		if( [h1 pop] != nil ) NSPrintf( @"***** error pop after setObjectFromArra:nil should return nil\n" );
		if( [h1 top] != nil ) NSPrintf( @"***** error top of empty heap should return nil\n" );
		if( h1.size != 0 ) NSPrintf( @"***** error newly allocated heap should have size 0\n" );
		if( !h1.empty ) NSPrintf( @"***** error newly allocated heap should be empty\n" );
		[h1 removeObject: @99];	// Make sure it doesn't crash removing object from empty heap...
		[h1 removeObject: @"hello"];	// Make sure it doesn't crash removing object from empty heap...
		[h1 removeObject: nil];	// Make sure it doesn't crash removing object from empty heap...
		if( [h1 containsObject: @99] ) NSPrintf( @"***** error: contains returns YES for empty heap\n" );
		if( [h1 containsObject: nil] ) NSPrintf( @"***** error: contains nil returns YES for empty heap\n" );
		if( [h1 isEqual: nil] ) NSPrintf( @"***** error an empty heap should not be equal to nil\n" );
		if( [h1 isEqual: @"hello"] ) NSPrintf( @"***** error an empty heap should not be equal to a string\n" );
		if( [h1 isEqual: neh] ) NSPrintf( @"***** error an empty heap should not be equal to a non-empty heap\n" );
		if( ![h1 isEqual: h1] ) NSPrintf( @"***** error an empty heap should be equal to itself\n" );
		if( ![h1 isEqual: ith] ) NSPrintf( @"***** error two empty heaps should be equal\n" );
		if( ![h1 isEqualToHeap: ith] ) NSPrintf( @"***** error two empty heaps should be equal\n" );
		[h1 removeTopObject]; // Make sure it doesn't crash removing top object from empty heap...
		if( [h1 topObject] != nil ) NSPrintf( @"***** error topObject of empty heap should return nil\n" );
		if( h1.count != 0 ) NSPrintf( @"***** error newly allocated heap should have count 0\n" );
		if( [h1 allObjects] == nil ) NSPrintf( @"***** error allObjects on newly allocated heap should not be nil\n" );
		if( ![[h1 allObjects] isKindOfClass: [NSArray class]] ) NSPrintf( @"***** error allObjects on newly allocated heap should return an array\n" );
		if( ![[h1 allObjects] count] == 0 ) NSPrintf( @"***** error the array from a newly allocated heap should have count 0\n" );
		[h1 removeAllObjects]; // Make sure it doesn't crash removing all objects from empty heap...
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap setObjectsFromArray: nil] threw exception (%@)\n", exception );
	}
	@try {	[h1 setObjectsFromArray: [NSArray array]];
		if( [h1 pop] != nil ) NSPrintf( @"***** error pop after setObjectFromArra:nil should return nil\n" );
		if( [h1 top] != nil ) NSPrintf( @"***** error top of empty heap should return nil\n" );
		if( h1.size != 0 ) NSPrintf( @"***** error newly allocated heap should have size 0\n" );
		if( !h1.empty ) NSPrintf( @"***** error newly allocated heap should be empty\n" );
		[h1 removeObject: @99];	// Make sure it doesn't crash removing object from empty heap...
		[h1 removeObject: @"hello"];	// Make sure it doesn't crash removing object from empty heap...
		[h1 removeObject: nil];	// Make sure it doesn't crash removing object from empty heap...
		if( [h1 containsObject: @99] ) NSPrintf( @"***** error: contains returns YES for empty heap\n" );
		if( [h1 containsObject: nil] ) NSPrintf( @"***** error: contains nil returns YES for empty heap\n" );
		if( [h1 isEqual: nil] ) NSPrintf( @"***** error an empty heap should not be equal to nil\n" );
		if( [h1 isEqual: @"hello"] ) NSPrintf( @"***** error an empty heap should not be equal to a string\n" );
		if( [h1 isEqual: neh] ) NSPrintf( @"***** error an empty heap should not be equal to a non-empty heap\n" );
		if( ![h1 isEqual: h1] ) NSPrintf( @"***** error an empty heap should be equal to itself\n" );
		if( ![h1 isEqual: ith] ) NSPrintf( @"***** error two empty heaps should be equal\n" );
		if( ![h1 isEqualToHeap: ith] ) NSPrintf( @"***** error two empty heaps should be equal\n" );
		[h1 removeTopObject]; // Make sure it doesn't crash removing top object from empty heap...
		if( [h1 topObject] != nil ) NSPrintf( @"***** error topObject of empty heap should return nil\n" );
		if( h1.count != 0 ) NSPrintf( @"***** error newly allocated heap should have count 0\n" );
		if( [h1 allObjects] == nil ) NSPrintf( @"***** error allObjects on newly allocated heap should not be nil\n" );
		if( ![[h1 allObjects] isKindOfClass: [NSArray class]] ) NSPrintf( @"***** error allObjects on newly allocated heap should return an array\n" );
		if( ![[h1 allObjects] count] == 0 ) NSPrintf( @"***** error the array from a newly allocated heap should have count 0\n" );
		[h1 removeAllObjects]; // Make sure it doesn't crash removing all objects from empty heap...
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap setObjectsFromArray: [NSArray array]] threw exception (%@)\n", exception );
	}
	@try {	[h1 setObjectsFromArray: @[ @1 ]];
		if( h1.size != 1 ) NSPrintf( @"***** error setObjectFromArray: should end up with a size of 1 not %lu\n", h1.size );
		if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for object in heap\n" );
		[h1 pop];
		if( h1.size != 0 ) NSPrintf( @"***** error pop should end up with a size of 0 not %lu\n", h1.size );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap setObjectsFromArray: nil] threw exception (%@)\n", exception );
	}
	@try {	[h1 setObjectsFromArray: @[ @1, @-1 ]];
		if( h1.size != 2 ) NSPrintf( @"***** error setObjectFromArray: should end up with a size of 2 not %lu\n", h1.size );
		if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for object 1 in heap\n" );
		if( ![h1 containsObject: @-1] ) NSPrintf( @"***** error: contains returns NO for object -1 in heap\n" );
		[h1 pop];
		if( h1.size != 1 ) NSPrintf( @"***** error pop should end up with a size of 1 not %lu\n", h1.size );
		[h1 pop];
		if( h1.size != 0 ) NSPrintf( @"***** error pop should end up with a size of 0 not %lu\n", h1.size );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap setObjectsFromArray: nil] threw exception (%@)\n", exception );
	}
	@try {	[h1 setObjectsFromArray: @[ @1, @-1, @4 ]];
		if( h1.size != 3 ) NSPrintf( @"***** error setObjectFromArray: should end up with a size of 2 not %lu\n", h1.size );
		if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for object 1 in heap\n" );
		if( ![h1 containsObject: @-1] ) NSPrintf( @"***** error: contains returns NO for object -1 in heap\n" );
		if( ![h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for object 4 in heap\n" );
		[h1 pop];
		if( h1.size != 2 ) NSPrintf( @"***** error pop should end up with a size of 2 not %lu\n", h1.size );
		[h1 pop];
		if( h1.size != 1 ) NSPrintf( @"***** error pop should end up with a size of 1 not %lu\n", h1.size );
		[h1 pop];
		if( h1.size != 0 ) NSPrintf( @"***** error pop should end up with a size of 0 not %lu\n", h1.size );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error [heap setObjectsFromArray: nil] threw exception (%@)\n", exception );
	}

	return tr;
}

int myMain() {

	NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:
				@"intValue" ascending: YES];
#if 0
	NSSortDescriptor *sdr = sd.reversedSortDescriptor;
	NSSortDescriptor *sdd = [NSSortDescriptor sortDescriptorWithKey:
				@"intValue" ascending: NO];

	// So [@3 compare: @2] gives NSOrderedDescending as expected.
	NSPrintf( @"[@3 compare: @2] is %d\n", (int) [@3 compare: @2] );
	NSPrintf( @"[@3 compare: @3] is %d\n", (int) [@3 compare: @3] );
	NSPrintf( @"[@2 compare: @3] is %d\n", (int) [@2 compare: @3] );
	NSPrintf( @"NSOrderedDescending is %d\n", (int) NSOrderedDescending );
	NSPrintf( @"NSOrderedSame is %d\n", (int) NSOrderedSame );
	NSPrintf( @"NSOrderedAscending is %d\n", (int) NSOrderedAscending );
	NSPrintf( @"Ascending:YES [sortDescriptor compareObject: @3 toObject: @2] is %d\n", (int) [sd compareObject: @3 toObject: @2] );
	NSPrintf( @"Ascending:YES [sortDescriptor compareObject: @2 toObject: @3] is %d\n", (int) [sd compareObject: @2 toObject: @3] );
	NSPrintf( @"Ascending:YES-reversed [sortDescriptor compareObject: @3 toObject: @2] is %d\n", (int) [sdr compareObject: @3 toObject: @2] );
	NSPrintf( @"Ascending:YES-reversed [sortDescriptor compareObject: @2 toObject: @3] is %d\n", (int) [sdr compareObject: @2 toObject: @3] );
	NSPrintf( @"Ascending:NO [sortDescriptor compareObject: @3 toObject: @2] is %d\n", (int) [sdd compareObject: @3 toObject: @2] );
	NSPrintf( @"Ascending:NO [sortDescriptor compareObject: @2 toObject: @3] is %d\n", (int) [sdd compareObject: @2 toObject: @3] );
#endif

	// Run the checks on the base class
	heapCheck();

	// Test all the empty initializers...
	HEAP_TYPE *h1;
	@try {	if( !(h1 = [[HEAP_TYPE alloc] init] ) ) NSPrintf( @"***** error failed alloc/init\n" );
		beatAnEmptyHeap( h1, YES );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error alloc/init throws exception '%@'\n", exception );
		NSPrintf( @"%@\n", [NSThread callStackSymbols] );
	}
	@try {	if( !(h1 = [[HEAP_TYPE alloc] initMax] ) ) NSPrintf( @"***** error failed alloc/initMax\n" );
		beatAnEmptyHeap( h1, YES );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error alloc/initMax throws exception '%@'\n", exception );
		NSPrintf( @"%@\n", [NSThread callStackSymbols] );
	}
	@try {	if( !(h1 = [[HEAP_TYPE alloc] initMin] ) ) NSPrintf( @"***** error failed alloc/initMin\n" );
		beatAnEmptyHeap( h1, NO );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error alloc/initMin throws exception '%@'\n", exception );
		NSPrintf( @"%@\n", [NSThread callStackSymbols] );
	}
#define C1	^NSComparisonResult( id first, id second ) { return cmpr([first intValue],[second intValue]); }
#define C2	^NSComparisonResult( id first, id second ) { return cmpr([second intValue],[first intValue]); }
	@try {	if( !(h1 = [[HEAP_TYPE alloc] initWithComparator: C1] ) ) NSPrintf( @"***** error failed alloc/initWithComparator:\n" );
		beatAnEmptyHeap( h1, YES );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error alloc/initWithComparator: throws exception '%@'\n", exception );
		NSPrintf( @"%@\n", [NSThread callStackSymbols] );
	}
	@try {	if( !(h1 = [[HEAP_TYPE alloc] initWithComparator: C2] ) ) NSPrintf( @"***** error failed alloc/initWithComparator:\n" );
		beatAnEmptyHeap( h1, NO );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error alloc/initWithComparator: throws exception '%@'\n", exception );
		NSPrintf( @"%@\n", [NSThread callStackSymbols] );
	}
	NSSortDescriptor *s1 = [NSSortDescriptor sortDescriptorWithKey: @"intValue" ascending: YES];
	NSSortDescriptor *s2 = [NSSortDescriptor sortDescriptorWithKey: @"intValue" ascending: NO];
	@try {	if( !(h1 = [[HEAP_TYPE alloc] initWithSortDescriptor: s1] ) ) NSPrintf( @"***** error failed alloc/initWithSortDescriptor:\n" );
		beatAnEmptyHeap( h1, NO );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error alloc/initWithSortDescriptor: throws exception '%@'\n", exception );
		NSPrintf( @"%@\n", [NSThread callStackSymbols] );
	}
	@try {	if( !(h1 = [[HEAP_TYPE alloc] initWithSortDescriptor: s2] ) ) NSPrintf( @"***** error failed alloc/initWithSortDescriptor:\n" );
		beatAnEmptyHeap( h1, YES );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error alloc/initWithSortDescriptor: throws exception '%@'\n", exception );
		NSPrintf( @"%@\n", [NSThread callStackSymbols] );
	}

	// Same for factories...
	@try {	if( !(h1 = [HEAP_TYPE heap] ) ) NSPrintf( @"***** error failed [HEAP_TYPE heap]\n" );
		beatAnEmptyHeap( h1, YES );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error +heap throws exception '%@'\n", exception );
		NSPrintf( @"%@\n", [NSThread callStackSymbols] );
	}
	@try {	if( !(h1 = [HEAP_TYPE maxHeap] ) ) NSPrintf( @"***** error failed [HEAP_TYPE maxHeap]\n" );
		beatAnEmptyHeap( h1, YES );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error +maxHeap throws exception '%@'\n", exception );
		NSPrintf( @"%@\n", [NSThread callStackSymbols] );
	}
	@try {	if( !(h1 = [HEAP_TYPE minHeap] ) ) NSPrintf( @"***** error failed [HEAP_TYPE minHeap]\n" );
		beatAnEmptyHeap( h1, NO );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error +minHeap throws exception '%@'\n", exception );
		NSPrintf( @"%@\n", [NSThread callStackSymbols] );
	}
#define C1	^NSComparisonResult( id first, id second ) { return cmpr([first intValue],[second intValue]); }
#define C2	^NSComparisonResult( id first, id second ) { return cmpr([second intValue],[first intValue]); }
	@try {	if( !(h1 = [HEAP_TYPE heapWithComparator: C1] ) ) NSPrintf( @"***** error failed +heapWithComparator:\n" );
		beatAnEmptyHeap( h1, YES );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error +heapWithComparator: throws exception '%@'\n", exception );
		NSPrintf( @"%@\n", [NSThread callStackSymbols] );
	}
	@try {	if( !(h1 = [HEAP_TYPE heapWithComparator: C2] ) ) NSPrintf( @"***** error failed +heapWithComparator:\n" );
		beatAnEmptyHeap( h1, NO );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error +heapWithComparator: throws exception '%@'\n", exception );
		NSPrintf( @"%@\n", [NSThread callStackSymbols] );
	}
	//NSSortDescriptor *s1 = [NSSortDescriptor sortDescriptorWithKey: @"intValue" ascending: YES];
	//NSSortDescriptor *s2 = [NSSortDescriptor sortDescriptorWithKey: @"intValue" ascending: NO];
	@try {	if( !(h1 = [HEAP_TYPE heapWithSortDescriptor: s1] ) ) NSPrintf( @"***** error failed +heapWithSortDescriptor:\n" );
		beatAnEmptyHeap( h1, NO );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error +heapWithSortDescriptor: throws exception '%@'\n", exception );
		NSPrintf( @"%@\n", [NSThread callStackSymbols] );
	}
	@try {	if( !(h1 = [HEAP_TYPE heapWithSortDescriptor: s2] ) ) NSPrintf( @"***** error failed +heapWithSortDescriptor:\n" );
		beatAnEmptyHeap( h1, YES );
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error +heapWithSortDescriptor: throws exception '%@'\n", exception );
		NSPrintf( @"%@\n", [NSThread callStackSymbols] );
	}


	h1 = [HEAP_TYPE heap];
	if( h1.size != 0 ) NSPrintf( @"***** error newly allocated heap should have size 0\n" );
	if( [h1 top] != nil ) NSPrintf( @"***** error top of empty heap should return nil\n" );
	if( [h1 pop] != nil ) NSPrintf( @"***** error pop of empty heap should return nil\n" );
	[h1 removeObject: @99];	// Make sure it doesn't crash removing object from empty heap...
	if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for empty heap\n" );
	[h1 push: @1];
	if( h1.size != 1 ) NSPrintf( @"***** error pushed one item on heap and its size is not 1\n" );
	if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	[h1 push: @2];
	if( h1.size != 2 ) NSPrintf( @"***** error pushed two items on the heap and its size is not 2\n" );
	[h1 push: @9];
	[h1 push: @0];
	[h1 push: @4];
	if( h1.size != 5 ) NSPrintf( @"***** error pushed five items on heap and its size is not 5\n" );
	if( [h1.top intValue] != 9 ) NSPrintf( @"***** error top of heap should be 9\n" );
	if( h1.size != 5 ) NSPrintf( @"***** error did top with five items on heap and its size is not still 5\n" );
	if( [h1 containsObject: @3] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( ![h1 containsObject: @9] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @0] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @1] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );

	if( [[h1 pop] intValue] != 9 ) NSPrintf( @"***** error top of heap should still have been 9\n" );
	if( h1.size != 4 ) NSPrintf( @"***** error size was 5, popped once so should be 4\n" );
	if( [[h1 pop] intValue] != 4 ) NSPrintf( @"***** error top of heap should still have been 9\n" );
	if( h1.size != 3 ) NSPrintf( @"***** error size was 5, popped twice so should be 3\n" );
	if( [[h1 pop] intValue] != 2 ) NSPrintf( @"***** error top of heap should still have been 9\n" );
	if( h1.size != 2 ) NSPrintf( @"***** error size was 5, popped thrice so should be 2\n" );
	if( [[h1 pop] intValue] != 1 ) NSPrintf( @"***** error top of heap should still have been 9\n" );
	if( h1.size != 1 ) NSPrintf( @"***** error size was 5, popped four times so should be 1\n" );
	if( [[h1 pop] intValue] != 0 ) NSPrintf( @"***** error top of heap should still have been 0\n" );
	if( h1.size != 0 ) NSPrintf( @"***** error size was 5, popped five times so should be 0\n" );

	if( !h1.empty ) NSPrintf( @"***** error empty should return true for an stack of size 0\n" );
	[h1 push: @89];
	if( h1.size != 1 ) NSPrintf( @"***** error push entry on empty heap so size should be 1\n" );
	if( h1.empty ) NSPrintf( @"***** error empty should return false for an stack of size 1\n" );
	if( [[h1 top] intValue] != 89 ) NSPrintf( @"***** error top of heap should be 89 since that is what I pushed\n" );
	[h1 push: @99];
	if( h1.size != 2 ) NSPrintf( @"***** error push another entry on heap so size should be 2\n" );
	if( [[h1 top] intValue] != 99 ) NSPrintf( @"***** error top of heap should be 99 since that is the largest number that has been pushed\n" );
	if( [[h1 pop] intValue] != 99 ) NSPrintf( @"***** error pop of heap should be 99 since that was the top\n" );
	if( [[h1 pop] intValue] != 89 ) NSPrintf( @"***** error pop of heap should be 99 since that was the the only other thing on the heap\n" );

	//////////////
	NSArray *zeroArray = [NSArray arrayWithObjects: nil];
	HEAP_TYPE *zeroHeap = [HEAP_TYPE heapWithArray: zeroArray];
	if( zeroHeap.size != 0 ) NSPrintf( @"***** error heap initialized with an empty array should have size 0\n" );
	if( [zeroHeap top] != nil ) NSPrintf( @"***** error top of empty heap should be nil\n" );
	if( [zeroHeap pop] != nil ) NSPrintf( @"***** error pop of empty heap should be nil\n" );
	/////////////

	//////////////
	NSArray *oneArray = [NSArray arrayWithObjects: @99, nil];
	HEAP_TYPE *oneHeap = [HEAP_TYPE heapWithArray: oneArray];
	if( oneHeap.size != 1 ) NSPrintf( @"***** error heap initialized with an array 1 long should have size 1 not %lu\n", oneHeap.size );
	if( oneHeap.count != 1 ) NSPrintf( @"***** error heap initialized with an array 1 long should have count 1 not %lu\n", oneHeap.count );
	if( [[oneHeap top] intValue] != 99 ) NSPrintf( @"***** error top of heap should be 99 since that was the largest number in the array\n" );
	if( [[oneHeap pop] intValue] != 99 ) NSPrintf( @"***** error pop of heap should be 99 since that was the top\n" );
	if( [oneHeap pop] != nil ) NSPrintf( @"***** error pop of empty heap should be nil\n" );
	/////////////
	oneHeap = [HEAP_TYPE heapWithObject: @99];
	if( oneHeap.size != 1 ) NSPrintf( @"***** error heap initialized with an object should have size 1 not %lu\n", oneHeap.size );
	if( oneHeap.count != 1 ) NSPrintf( @"***** error heap initialized with an object should have count 1 not %lu\n", oneHeap.count );
	if( [[oneHeap top] intValue] != 99 ) NSPrintf( @"***** error top of heap should be 99 since that was the largest number in the array\n" );
	if( [[oneHeap pop] intValue] != 99 ) NSPrintf( @"***** error pop of heap should be 99 since that was the top\n" );
	if( [oneHeap pop] != nil ) NSPrintf( @"***** error pop of empty heap should be nil\n" );
	/////////////
	oneHeap = [HEAP_TYPE heapWithObjects: @99, nil];
	if( oneHeap.size != 1 ) NSPrintf( @"***** error heap initialized with an object should have size 1 not %lu\n", oneHeap.size );
	if( oneHeap.count != 1 ) NSPrintf( @"***** error heap initialized with an object should have count 1 not %lu\n", oneHeap.count );
	if( [[oneHeap top] intValue] != 99 ) NSPrintf( @"***** error top of heap should be 99 since that was the largest number in the array\n" );
	if( [[oneHeap pop] intValue] != 99 ) NSPrintf( @"***** error pop of heap should be 99 since that was the top\n" );
	if( [oneHeap pop] != nil ) NSPrintf( @"***** error pop of empty heap should be nil\n" );
	/////////////

	//////////////
	NSArray *twoArray = [NSArray arrayWithObjects: @89, @99, nil];
	HEAP_TYPE *twoHeap = [HEAP_TYPE heapWithArray: twoArray];
	if( twoHeap.size != 2 ) NSPrintf( @"***** error heap initialized with an array 2 long should have size 2 not %lu\n", twoHeap.size );
	if( [[twoHeap top] intValue] != 99 ) NSPrintf( @"***** error top of heap should be 99 since that was the largest number in the array\n" );
	if( [[twoHeap pop] intValue] != 99 ) NSPrintf( @"***** error pop of heap should be 99 since that was the top\n" );
	if( [[twoHeap pop] intValue] != 89 ) NSPrintf( @"***** error pop of heap should be 89 since that was the the only other thing on the heap\n" );
	/////////////

	NSArray *a1 = [NSArray arrayWithObjects: @4, @54, @98, @47, @-5, @98, @100, @80, @200, @150, nil];
	[h1 setObjectsFromArray: a1];
	if( h1.size != 10 ) NSPrintf( @"***** error: expected size of 10 afer calling set array with (%@)\n", [a1 componentsJoinedByString: @","] );
	//[h1 printDescription];
	if( [h1 containsObject: @-100] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( [h1 containsObject: @1000] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( [h1 containsObject: @75] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( ![h1 containsObject: @-5] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @47] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @98] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h1 containsObject: @200] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( [[h1 pop] intValue] != 200 ) NSPrintf( @"***** error: expected 200 on top of heap\n" );
	if( [[h1 pop] intValue] != 150 ) NSPrintf( @"***** error: expected 150 on top of heap\n" );
	if( [[h1 pop] intValue] != 100 ) NSPrintf( @"***** error: expected 100 on top of heap\n" );
	if( [[h1 pop] intValue] != 98 ) NSPrintf( @"***** error: expected 98 on top of heap\n" );
	if( [[h1 pop] intValue] != 98 ) NSPrintf( @"***** error: expected 98 on top of heap\n" );
	if( [[h1 pop] intValue] != 80 ) NSPrintf( @"***** error: expected 80 on top of heap\n" );
	if( [[h1 pop] intValue] != 54 ) NSPrintf( @"***** error: expected 54 on top of heap\n" );
	if( [[h1 pop] intValue] != 47 ) NSPrintf( @"***** error: expected 47 on top of heap\n" );
	if( [[h1 pop] intValue] != 4 ) NSPrintf( @"***** error: expected 4 on top of heap\n" );
	if( [[h1 pop] intValue] != -5 ) NSPrintf( @"***** error: expected -5 on top of heap\n" );
	if( [h1 pop] != nil ) NSPrintf( @"***** error: expected nil since heap should be empty\n" );

	HEAP_TYPE *h2 = [[HEAP_TYPE alloc] initWithComparator:
		^NSComparisonResult( id first, id second ) {
			if( [first intValue] < [second intValue] )
				return NSOrderedDescending;
			if( [first intValue] > [second intValue] )
				return NSOrderedAscending;
			return NSOrderedSame; }];
	[h2 setObjectsFromArray: a1];
	if( h2.count != 10 )
		NSPrintf( @"***** error: expect heap count of 10 after calling h2 with set array using (%@)\n", [a1 componentsJoinedByString: @","] );
	if( [h2 containsObject: @-100] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( [h2 containsObject: @1000] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( [h2 containsObject: @75] ) NSPrintf( @"***** error: contains returns YES for entry not in heap\n" );
	if( ![h2 containsObject: @-5] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h2 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h2 containsObject: @47] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h2 containsObject: @98] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h2 containsObject: @200] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( [[h2 pop] intValue] != -5 )
		NSPrintf( @"***** error: expected stack top of -5 on h2 after set array" );
	if( [[h2 pop] intValue] != 4 )
		NSPrintf( @"***** error: expected stack top of 4 on h2 after set array" );
	if( [[h2 pop] intValue] != 47 )
		NSPrintf( @"***** error: expected stack top of 47 on h2 after set array" );
	if( [[h2 pop] intValue] != 54 )
		NSPrintf( @"***** error: expected stack top of 54 on h2 after set array" );
	if( [[h2 pop] intValue] != 80 )
		NSPrintf( @"***** error: expected stack top of 80 on h2 after set array" );
	if( [[h2 pop] intValue] != 98 )
		NSPrintf( @"***** error: expected stack top of 98 on h2 after set array" );
	if( [[h2 pop] intValue] != 98 )
		NSPrintf( @"***** error: expected stack top of 98 on h2 after set array" );
	if( [[h2 pop] intValue] != 100 )
		NSPrintf( @"***** error: expected stack top of 100 on h2 after set array" );
	if( [[h2 pop] intValue] != 150 )
		NSPrintf( @"***** error: expected stack top of 150 on h2 after set array" );
	if( [[h2 pop] intValue] != 200 )
		NSPrintf( @"***** error: expected stack top of 200 on h2 after set array" );


	// sd is @"intValue" ascending: YES
	HEAP_TYPE *h3 = [[HEAP_TYPE alloc] initWithSortDescriptor: sd];
	[h3 setObjectsFromArray: a1];
	if( [h3 count] != 10 )
		NSPrintf( @"***** error: expected array size of 10 after calling  set array on h3 with (%@)\n", [a1 componentsJoinedByString: @","] );
	if( [[h3 pop] intValue] !=  -5 )
		NSPrintf( @"***** error: expected stack top of  -5 on h3" );
	if( [[h3 pop] intValue] !=  4 )
		NSPrintf( @"***** error: expected stack top of  4 on h3" );
	if( [[h3 pop] intValue] !=  47 )
		NSPrintf( @"***** error: expected stack top of  47 on h3" );
	if( [[h3 pop] intValue] !=  54 )
		NSPrintf( @"***** error: expected stack top of  54 on h3" );
	if( [[h3 pop] intValue] !=  80 )
		NSPrintf( @"***** error: expected stack top of  80 on h3" );
	if( [[h3 pop] intValue] !=  98 )
		NSPrintf( @"***** error: expected stack top of  98 on h3" );
	if( [[h3 pop] intValue] !=  98 )
		NSPrintf( @"***** error: expected stack top of  98 on h3" );
	if( [[h3 pop] intValue] !=  100 )
		NSPrintf( @"***** error: expected stack top of  100 on h3" );
	if( [[h3 pop] intValue] !=  150 )
		NSPrintf( @"***** error: expected stack top of  150 on h3" );
	if( [[h3 pop] intValue] !=  200 )
		NSPrintf( @"***** error: expected stack top of  200 on h3" );


	NSArray *a = [NSArray arrayWithObjects: @100, @80, @200, @150, nil];
	[h1 setObjectsFromArray: a];
	if( h1.size != 4 || [h1.top intValue] != 200 )
		NSPrintf( @"***** error did set array with (%@), size should be 4 not %lu, top should be 200 not %@\n", [a componentsJoinedByString: @","], h1.size, h1.top );
	[h1 push: @10];
	if( h1.size != 5 || [h1.top intValue] != 200 )
		NSPrintf( @"***** error pushed 10, size should be 5 not %lu, top should be 200 not %@\n", h1.size, h1.top );
	[h1 push: @1000];
	if( h1.size != 6 || [h1.top intValue] != 1000 )
		NSPrintf( @"***** error pushed 1000, size should be 6 not %lu, and top should be 1000 not  %@\n", h1.size, h1.top );

	// Testing remove object...
	NSArray *objects5 = [NSArray arrayWithObjects: @34, @56, @12, @78, @90, @101, @4, @82, nil];
	HEAP_TYPE *h5 = [HEAP_TYPE minHeapWithArray: objects5];
	if( h5.size != 8 ) NSPrintf( @"***** error initialized h5 with array with 8 entries, size should be 8 not %lu\n", h5.size );
	//NSPrintf( @"Heap h5 " );
	//[h5 printDescription];
	[h5 removeObject: @99];
	if( h5.size != 8 ) NSPrintf( @"***** error remove of non-existant entry, size should still be 8 not %lu\n", h5.size );
	if( [h5 containsObject: @99] ) NSPrintf( @"***** error: contains returns YES for entry just removed from heap\n" );
	if( ![h5 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @12] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @34] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @56] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @78] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @82] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @90] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @101] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	[h5 removeObject: @78];
	if( h5.size != 7 ) NSPrintf( @"***** error size was 8, removed one so size should be 7 not %lu\n", h5.size );
	if( [h5 containsObject: @78] ) NSPrintf( @"***** error: contains returns YES for entry just removed from heap\n" );
	if( ![h5 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @12] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @34] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @56] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @82] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @90] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @101] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	//NSPrintf( @"Heap h5 after deleting 78 " );
	//[h5 printDescription];
	[h5 removeObject: @99];
	if( h5.size != 7 ) NSPrintf( @"***** error remove of non-existant entry, size should still be 7 not %lu\n", h5.size );
	if( [h5 containsObject: @99] ) NSPrintf( @"***** error: contains returns YES for entry just removed from heap\n" );
	if( ![h5 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @12] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @34] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @56] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @82] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @90] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @101] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	[h5 removeObject: @34];
	if( h5.size != 6 ) NSPrintf( @"***** error size was 7, removed one so size should be 6 not %lu\n", h5.size );
	if( [h5 containsObject: @34] ) NSPrintf( @"***** error: contains returns YES for entry just removed from heap\n" );
	if( ![h5 containsObject: @4] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @12] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @56] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @82] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @90] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @101] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	//NSPrintf( @"Heap h5 after deleting 34 & 99 " );
	//[h5 printDescription];
	[h5 removeObject: @4];
	if( h5.size != 5 ) NSPrintf( @"***** error size was 6, removed one so size should be 5 not %lu\n", h5.size );
	if( [h5 containsObject: @4] ) NSPrintf( @"***** error: contains returns YES for entry just removed from heap\n" );
	if( ![h5 containsObject: @12] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @56] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @82] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @90] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @101] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	//NSPrintf( @"Heap h5 after deleting 4 " );
	//[h5 printDescription];
	[h5 removeObject: @101];
	if( h5.size != 4 ) NSPrintf( @"***** error size was 5, removed one so size should be 4 not %lu\n", h5.size );
	if( [h5 containsObject: @101] ) NSPrintf( @"***** error: contains returns YES for entry just removed from heap\n" );
	if( ![h5 containsObject: @12] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @56] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @82] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	if( ![h5 containsObject: @90] ) NSPrintf( @"***** error: contains returns NO for entry in heap\n" );
	//NSPrintf( @"Heap h5 after deleting 101 " );
	//[h5 printDescription];

	// Let's test replaceObject:withObject: (my replacement for decreaseKey)
	HEAP_TYPE *h6 = [HEAP_TYPE maxHeapWithObjects: @4, @6, @8, @10, @12, @14, @16, @18, @20, @22, @24, @26, @28, @30, nil];
	if( h6.size != 14 ) NSPrintf( @"***** error created heap with 14 obects, size should be 14 not %lu\n", h6.size );
	if( [h6.top intValue] != 30 ) NSPrintf( @"***** error top of heap should be 30 not %@\n", h6.top );
	if( ![h6 containsObject: @4] ) NSPrintf( @"***** error h6 should contain 4\n" );
	if( ![h6 containsObject: @6] ) NSPrintf( @"***** error h6 should contain 6\n" );
	if( ![h6 containsObject: @8] ) NSPrintf( @"***** error h6 should contain 8\n" );
	if( ![h6 containsObject: @10] ) NSPrintf( @"***** error h6 should contain 10\n" );
	if( ![h6 containsObject: @12] ) NSPrintf( @"***** error h6 should contain 12\n" );
	if( ![h6 containsObject: @14] ) NSPrintf( @"***** error h6 should contain 14\n" );
	if( ![h6 containsObject: @16] ) NSPrintf( @"***** error h6 should contain 16\n" );
	if( ![h6 containsObject: @18] ) NSPrintf( @"***** error h6 should contain 18\n" );
	if( ![h6 containsObject: @20] ) NSPrintf( @"***** error h6 should contain 20\n" );
	if( ![h6 containsObject: @22] ) NSPrintf( @"***** error h6 should contain 22\n" );
	if( ![h6 containsObject: @24] ) NSPrintf( @"***** error h6 should contain 24\n" );
	if( ![h6 containsObject: @26] ) NSPrintf( @"***** error h6 should contain 26\n" );
	if( ![h6 containsObject: @28] ) NSPrintf( @"***** error h6 should contain 28\n" );
	if( ![h6 containsObject: @30] ) NSPrintf( @"***** error h6 should contain 30\n" );
	//NSPrintf( @"Heap h6 after creation " );
	//[h6 printDescription];
	[h6 replaceObject: @10 withObject: @29];
	if( [h6.top intValue] != 30 ) NSPrintf( @"***** error top of heap should still be 30 not %@\n", h6.top );
	if( h6.size != 14 ) NSPrintf( @"***** error replace should not change the size so size should be 14 not %lu\n", h6.size );
	if( ![h6 containsObject: @4] ) NSPrintf( @"***** error h6 should contain 4\n" );
	if( ![h6 containsObject: @6] ) NSPrintf( @"***** error h6 should contain 6\n" );
	if( ![h6 containsObject: @8] ) NSPrintf( @"***** error h6 should contain 8\n" );
	if( [h6 containsObject: @10] ) NSPrintf( @"***** error h6 should not contain 10 since it was replaced with 29\n" );
	if( ![h6 containsObject: @12] ) NSPrintf( @"***** error h6 should contain 12\n" );
	if( ![h6 containsObject: @14] ) NSPrintf( @"***** error h6 should contain 14\n" );
	if( ![h6 containsObject: @16] ) NSPrintf( @"***** error h6 should contain 16\n" );
	if( ![h6 containsObject: @18] ) NSPrintf( @"***** error h6 should contain 18\n" );
	if( ![h6 containsObject: @20] ) NSPrintf( @"***** error h6 should contain 20\n" );
	if( ![h6 containsObject: @22] ) NSPrintf( @"***** error h6 should contain 22\n" );
	if( ![h6 containsObject: @24] ) NSPrintf( @"***** error h6 should contain 24\n" );
	if( ![h6 containsObject: @26] ) NSPrintf( @"***** error h6 should contain 26\n" );
	if( ![h6 containsObject: @28] ) NSPrintf( @"***** error h6 should contain 28\n" );
	if( ![h6 containsObject: @29] ) NSPrintf( @"***** error h6 should contain 29 after 10 was replaced with it\n" );
	if( ![h6 containsObject: @30] ) NSPrintf( @"***** error h6 should contain 30\n" );
	//NSPrintf( @"Heap h6 after replacing 10 with 29 " );
	//[h6 printDescription];
	[h6 replaceObject: @6 withObject: @32];
	if( [h6.top intValue] != 32 ) NSPrintf( @"***** error top of heap should now be 32 not %@\n", h6.top );
	if( h6.size != 14 ) NSPrintf( @"***** error replace should not change the size so size should be 14 not %lu\n", h6.size );
	if( ![h6 containsObject: @4] ) NSPrintf( @"***** error h6 should contain 4\n" );
	if( [h6 containsObject: @6] ) NSPrintf( @"***** error h6 should not contain 6 since it was replaced with 32\n" );
	if( ![h6 containsObject: @8] ) NSPrintf( @"***** error h6 should contain 8\n" );
	if( [h6 containsObject: @10] ) NSPrintf( @"***** error h6 should not contain 10 since it was replaced with 29\n" );
	if( ![h6 containsObject: @12] ) NSPrintf( @"***** error h6 should contain 12\n" );
	if( ![h6 containsObject: @14] ) NSPrintf( @"***** error h6 should contain 14\n" );
	if( ![h6 containsObject: @16] ) NSPrintf( @"***** error h6 should contain 16\n" );
	if( ![h6 containsObject: @18] ) NSPrintf( @"***** error h6 should contain 18\n" );
	if( ![h6 containsObject: @20] ) NSPrintf( @"***** error h6 should contain 20\n" );
	if( ![h6 containsObject: @22] ) NSPrintf( @"***** error h6 should contain 22\n" );
	if( ![h6 containsObject: @24] ) NSPrintf( @"***** error h6 should contain 24\n" );
	if( ![h6 containsObject: @26] ) NSPrintf( @"***** error h6 should contain 26\n" );
	if( ![h6 containsObject: @28] ) NSPrintf( @"***** error h6 should contain 28\n" );
	if( ![h6 containsObject: @29] ) NSPrintf( @"***** error h6 should contain 29\n" );
	if( ![h6 containsObject: @30] ) NSPrintf( @"***** error h6 should contain 30\n" );
	if( ![h6 containsObject: @32] ) NSPrintf( @"***** error h6 should contain 32 after 6 was replaced with it\n" );
	//NSPrintf( @"Heap h6 after replacing 6 with 32 " );
	//[h6 printDescription];
	if( [h6.pop intValue] != 32 ) NSPrintf( @"***** error pop of heap should still be 32\n" );
	if( [h6.top intValue] != 30 ) NSPrintf( @"***** error top of heap should now be 30 not %@\n", h6.top );
	if( h6.size != 13 ) NSPrintf( @"***** error popped a value so size should be 13 not %lu\n", h6.size );
	if( ![h6 containsObject: @4] ) NSPrintf( @"***** error h6 should contain 4\n" );
	if( [h6 containsObject: @6] ) NSPrintf( @"***** error h6 should not contain 6 since it was replaced with 32\n" );
	if( ![h6 containsObject: @8] ) NSPrintf( @"***** error h6 should contain 8\n" );
	if( [h6 containsObject: @10] ) NSPrintf( @"***** error h6 should not contain 10 since it was replaced with 29\n" );
	if( ![h6 containsObject: @12] ) NSPrintf( @"***** error h6 should contain 12\n" );
	if( ![h6 containsObject: @14] ) NSPrintf( @"***** error h6 should contain 14\n" );
	if( ![h6 containsObject: @16] ) NSPrintf( @"***** error h6 should contain 16\n" );
	if( ![h6 containsObject: @18] ) NSPrintf( @"***** error h6 should contain 18\n" );
	if( ![h6 containsObject: @20] ) NSPrintf( @"***** error h6 should contain 20\n" );
	if( ![h6 containsObject: @22] ) NSPrintf( @"***** error h6 should contain 22\n" );
	if( ![h6 containsObject: @24] ) NSPrintf( @"***** error h6 should contain 24\n" );
	if( ![h6 containsObject: @26] ) NSPrintf( @"***** error h6 should contain 26\n" );
	if( ![h6 containsObject: @28] ) NSPrintf( @"***** error h6 should contain 28\n" );
	if( ![h6 containsObject: @29] ) NSPrintf( @"***** error h6 should contain 29\n" );
	if( ![h6 containsObject: @30] ) NSPrintf( @"***** error h6 should contain 30\n" );
	if( [h6 containsObject: @32] ) NSPrintf( @"***** error h6 should not contain 32 after it was popped\n" );
	//NSPrintf( @"Heap h6 after popping off the 32 " );
	//[h6 printDescription];
	[h6 replaceObject: @26 withObject: @27];
	if( h6.size != 13 ) NSPrintf( @"***** error only one value has been popped so size should be 13 not %lu\n", h6.size );
	if( [h6.top intValue] != 30 ) NSPrintf( @"***** error top of heap should still be 30 not %@\n", h6.top );
	if( ![h6 containsObject: @4] ) NSPrintf( @"***** error h6 should contain 4\n" );
	if( [h6 containsObject: @6] ) NSPrintf( @"***** error h6 should not contain 6 since it was replaced with 32\n" );
	if( ![h6 containsObject: @8] ) NSPrintf( @"***** error h6 should contain 8\n" );
	if( [h6 containsObject: @10] ) NSPrintf( @"***** error h6 should not contain 10 since it was replaced with 29\n" );
	if( ![h6 containsObject: @12] ) NSPrintf( @"***** error h6 should contain 12\n" );
	if( ![h6 containsObject: @14] ) NSPrintf( @"***** error h6 should contain 14\n" );
	if( ![h6 containsObject: @16] ) NSPrintf( @"***** error h6 should contain 16\n" );
	if( ![h6 containsObject: @18] ) NSPrintf( @"***** error h6 should contain 18\n" );
	if( ![h6 containsObject: @20] ) NSPrintf( @"***** error h6 should contain 20\n" );
	if( ![h6 containsObject: @22] ) NSPrintf( @"***** error h6 should contain 22\n" );
	if( ![h6 containsObject: @24] ) NSPrintf( @"***** error h6 should contain 24\n" );
	if( [h6 containsObject: @26] ) NSPrintf( @"***** error h6 should not contain 26 after it was replaced by 27\n" );
	if( ![h6 containsObject: @27] ) NSPrintf( @"***** error h6 should contain 27 after it replaced 26\n" );
	if( ![h6 containsObject: @28] ) NSPrintf( @"***** error h6 should contain 28\n" );
	if( ![h6 containsObject: @29] ) NSPrintf( @"***** error h6 should contain 29\n" );
	if( ![h6 containsObject: @30] ) NSPrintf( @"***** error h6 should contain 30\n" );
	if( [h6 containsObject: @32] ) NSPrintf( @"***** error h6 should not contain 32\n" );
	//NSPrintf( @"Heap h6 after replacing 26 with 27 " );
	//[h6 printDescription];
	if( ![h6 containsObject: @6] ) {
		@try {
			[h6 replaceObject: @6 withObject: @10];
			if( h6.size != 14 ) NSPrintf( @"***** error only changed 6 to 10 but there was no 6 so size should now be 14 not %lu\n", h6.size );
			if( ![h6 containsObject: @10] ) NSPrintf( @"***** error added 10 via replace so it should exist in the heap\n" );
			[h6 removeObject: @10];
			if( h6.size != 13 ) NSPrintf( @"***** error removed the 10 so size should now be 13 not %lu\n", h6.size );
		}
		@catch( NSException *exception ) {
			NSPrintf( @"***** error replace of non-existent object throws exception '%@'\n", exception );
		}
	}
	[h6 replaceObject: @8 withObject: @10];
	//NSPrintf( @"Heap h6 after replacing 8 with 10 " );
	//[h6 printDescription];
	if( h6.size != 13 ) NSPrintf( @"***** error only one value has been popped so size should be 13 not %lu\n", h6.size );
	if( [h6.top intValue] != 30 ) NSPrintf( @"***** error top of heap should still be 30 not %@\n", h6.top );
	if( ![h6 containsObject: @4] ) NSPrintf( @"***** error h6 should contain 4\n" );
	if( [h6 containsObject: @6] ) NSPrintf( @"***** error h6 should not contain 6 since it was replaced with 32\n" );
	if( [h6 containsObject: @8] ) NSPrintf( @"***** error h6 should not contain 8 after it was replaced with 10\n" );
	if( ![h6 containsObject: @10] ) NSPrintf( @"***** error h6 should contain 10 since it replaced 6\n" );
	if( ![h6 containsObject: @12] ) NSPrintf( @"***** error h6 should contain 12\n" );
	if( ![h6 containsObject: @14] ) NSPrintf( @"***** error h6 should contain 14\n" );
	if( ![h6 containsObject: @16] ) NSPrintf( @"***** error h6 should contain 16\n" );
	if( ![h6 containsObject: @18] ) NSPrintf( @"***** error h6 should contain 18\n" );
	if( ![h6 containsObject: @20] ) NSPrintf( @"***** error h6 should contain 20\n" );
	if( ![h6 containsObject: @22] ) NSPrintf( @"***** error h6 should contain 22\n" );
	if( ![h6 containsObject: @24] ) NSPrintf( @"***** error h6 should contain 24\n" );
	if( [h6 containsObject: @26] ) NSPrintf( @"***** error h6 should not contain 26 after it was replaced by 27\n" );
	if( ![h6 containsObject: @27] ) NSPrintf( @"***** error h6 should contain 27 after it replaced 26\n" );
	if( ![h6 containsObject: @28] ) NSPrintf( @"***** error h6 should contain 28\n" );
	if( ![h6 containsObject: @29] ) NSPrintf( @"***** error h6 should contain 29\n" );
	if( ![h6 containsObject: @30] ) NSPrintf( @"***** error h6 should contain 30\n" );
	if( [h6 containsObject: @32] ) NSPrintf( @"***** error h6 should not contain 32\n" );
	[h6 replaceObject: @4 withObject: @31];
	//NSPrintf( @"Heap h6 after replacing 4 with 31 " );
	//[h6 printDescription];
	if( h6.size != 13 ) NSPrintf( @"***** error only one value has been popped so size should be 13 not %lu\n", h6.size );
	if( [h6.top intValue] != 31 ) NSPrintf( @"***** error top of heap should now be 31 not %@\n", h6.top );
	if( [h6 containsObject: @4] ) NSPrintf( @"***** error h6 should not contain 4 since it was replaced by 31\n" );
	if( [h6 containsObject: @6] ) NSPrintf( @"***** error h6 should not contain 6 since it was replaced with 32\n" );
	if( [h6 containsObject: @8] ) NSPrintf( @"***** error h6 should not contain 8 after it was replaced with 10\n" );
	if( ![h6 containsObject: @10] ) NSPrintf( @"***** error h6 should contain 10 since it replaced 6\n" );
	if( ![h6 containsObject: @12] ) NSPrintf( @"***** error h6 should contain 12\n" );
	if( ![h6 containsObject: @14] ) NSPrintf( @"***** error h6 should contain 14\n" );
	if( ![h6 containsObject: @16] ) NSPrintf( @"***** error h6 should contain 16\n" );
	if( ![h6 containsObject: @18] ) NSPrintf( @"***** error h6 should contain 18\n" );
	if( ![h6 containsObject: @20] ) NSPrintf( @"***** error h6 should contain 20\n" );
	if( ![h6 containsObject: @22] ) NSPrintf( @"***** error h6 should contain 22\n" );
	if( ![h6 containsObject: @24] ) NSPrintf( @"***** error h6 should contain 24\n" );
	if( [h6 containsObject: @26] ) NSPrintf( @"***** error h6 should not contain 26 after it was replaced by 27\n" );
	if( ![h6 containsObject: @27] ) NSPrintf( @"***** error h6 should contain 27 after it replaced 26\n" );
	if( ![h6 containsObject: @28] ) NSPrintf( @"***** error h6 should contain 28\n" );
	if( ![h6 containsObject: @29] ) NSPrintf( @"***** error h6 should contain 29\n" );
	if( ![h6 containsObject: @30] ) NSPrintf( @"***** error h6 should contain 30\n" );
	if( ![h6 containsObject: @31] ) NSPrintf( @"***** error h6 should contain 31 since it replaced 4\n" );
	if( [h6 containsObject: @32] ) NSPrintf( @"***** error h6 should not contain 32\n" );
	[h6 replaceObject: @14 withObject: @17];
	//NSPrintf( @"Heap h6 after replacing 14 with 17 " );
	//[h6 printDescription];
	if( [h6 containsObject: @4] ) NSPrintf( @"***** error h6 should not contain 4 since it was replaced by 31\n" );
	if( [h6 containsObject: @6] ) NSPrintf( @"***** error h6 should not contain 6 since it was replaced with 32\n" );
	if( [h6 containsObject: @8] ) NSPrintf( @"***** error h6 should not contain 8 after it was replaced with 10\n" );
	if( ![h6 containsObject: @10] ) NSPrintf( @"***** error h6 should contain 10 since it replaced 6\n" );
	if( ![h6 containsObject: @12] ) NSPrintf( @"***** error h6 should contain 12\n" );
	if( [h6 containsObject: @14] ) NSPrintf( @"***** error h6 should not contain 14 since it was replaced by 17\n" );
	if( ![h6 containsObject: @17] ) NSPrintf( @"***** error h6 should contain 17 since it replaced 14\n" );
	if( ![h6 containsObject: @16] ) NSPrintf( @"***** error h6 should contain 16\n" );
	if( ![h6 containsObject: @18] ) NSPrintf( @"***** error h6 should contain 18\n" );
	if( ![h6 containsObject: @20] ) NSPrintf( @"***** error h6 should contain 20\n" );
	if( ![h6 containsObject: @22] ) NSPrintf( @"***** error h6 should contain 22\n" );
	if( ![h6 containsObject: @24] ) NSPrintf( @"***** error h6 should contain 24\n" );
	if( [h6 containsObject: @26] ) NSPrintf( @"***** error h6 should not contain 26 after it was replaced by 27\n" );
	if( ![h6 containsObject: @27] ) NSPrintf( @"***** error h6 should contain 27 after it replaced 26\n" );
	if( ![h6 containsObject: @28] ) NSPrintf( @"***** error h6 should contain 28\n" );
	if( ![h6 containsObject: @29] ) NSPrintf( @"***** error h6 should contain 29\n" );
	if( ![h6 containsObject: @30] ) NSPrintf( @"***** error h6 should contain 30\n" );
	if( ![h6 containsObject: @31] ) NSPrintf( @"***** error h6 should contain 31 since it replaced 4\n" );
	if( [h6 containsObject: @32] ) NSPrintf( @"***** error h6 should not contain 32\n" );
	[h6 replaceObject: @17 withObject: @23];
	//NSPrintf( @"Heap h6 after replacing 17 with 23 " );
	//[h6 printDescription];
	if( ![h6 containsObject: @12] ) NSPrintf( @"***** error: contains returns NO for 12 when it is in the heap\n" );
	if( [h6 containsObject: @4] ) NSPrintf( @"***** error h6 should not contain 4 since it was replaced by 31\n" );
	if( [h6 containsObject: @6] ) NSPrintf( @"***** error h6 should not contain 6 since it was replaced with 32\n" );
	if( [h6 containsObject: @8] ) NSPrintf( @"***** error h6 should not contain 8 after it was replaced with 10\n" );
	if( ![h6 containsObject: @10] ) NSPrintf( @"***** error h6 should contain 10 since it replaced 6\n" );
	if( ![h6 containsObject: @12] ) NSPrintf( @"***** error h6 should contain 12\n" );
	if( [h6 containsObject: @14] ) NSPrintf( @"***** error h6 should not contain 14 since it was replaced by 17\n" );
	if( [h6 containsObject: @17] ) NSPrintf( @"***** error h6 should not contain 17 since it was replaced 23\n" );
	if( ![h6 containsObject: @16] ) NSPrintf( @"***** error h6 should contain 16\n" );
	if( ![h6 containsObject: @18] ) NSPrintf( @"***** error h6 should contain 18\n" );
	if( ![h6 containsObject: @20] ) NSPrintf( @"***** error h6 should contain 20\n" );
	if( ![h6 containsObject: @22] ) NSPrintf( @"***** error h6 should contain 22\n" );
	if( ![h6 containsObject: @24] ) NSPrintf( @"***** error h6 should contain 23 because it replaced 17\n" );
	if( ![h6 containsObject: @24] ) NSPrintf( @"***** error h6 should contain 24\n" );
	if( [h6 containsObject: @26] ) NSPrintf( @"***** error h6 should not contain 26 after it was replaced by 27\n" );
	if( ![h6 containsObject: @27] ) NSPrintf( @"***** error h6 should contain 27 after it replaced 26\n" );
	if( ![h6 containsObject: @28] ) NSPrintf( @"***** error h6 should contain 28\n" );
	if( ![h6 containsObject: @29] ) NSPrintf( @"***** error h6 should contain 29\n" );
	if( ![h6 containsObject: @30] ) NSPrintf( @"***** error h6 should contain 30\n" );
	if( ![h6 containsObject: @31] ) NSPrintf( @"***** error h6 should contain 31 since it replaced 4\n" );
	if( [h6 containsObject: @32] ) NSPrintf( @"***** error h6 should not contain 32\n" );

	// Let's test replaceObject:withObject: (my replacement for decreaseKey) with minHeap
	HEAP_TYPE *h7 = [HEAP_TYPE minHeapWithObjects: @5, @10, @15, @20, @25, @30, @35, @40, @45, @50, @55, @60, @65, @70, nil];
	if( h7.size != 14 ) NSPrintf( @"***** error created heap with 14 obects, size should be 14 not %lu\n", h7.size );
	if( [h7.top intValue] != 5 ) NSPrintf( @"***** error top of heap should be 5 not %@\n", h7.top );
	if( ![h7 containsObject: @5] ) NSPrintf( @"***** error h7 should contain 5\n" );
	if( ![h7 containsObject: @10] ) NSPrintf( @"***** error h7 should contain 10\n" );
	if( ![h7 containsObject: @15] ) NSPrintf( @"***** error h7 should contain 15\n" );
	if( ![h7 containsObject: @20] ) NSPrintf( @"***** error h7 should contain 20\n" );
	if( ![h7 containsObject: @25] ) NSPrintf( @"***** error h7 should contain 25\n" );
	if( ![h7 containsObject: @30] ) NSPrintf( @"***** error h7 should contain 30\n" );
	if( ![h7 containsObject: @35] ) NSPrintf( @"***** error h7 should contain 35\n" );
	if( ![h7 containsObject: @40] ) NSPrintf( @"***** error h7 should contain 40\n" );
	if( ![h7 containsObject: @45] ) NSPrintf( @"***** error h7 should contain 45\n" );
	if( ![h7 containsObject: @50] ) NSPrintf( @"***** error h7 should contain 50\n" );
	if( ![h7 containsObject: @55] ) NSPrintf( @"***** error h7 should contain 55\n" );
	if( ![h7 containsObject: @60] ) NSPrintf( @"***** error h7 should contain 60\n" );
	if( ![h7 containsObject: @65] ) NSPrintf( @"***** error h7 should contain 65\n" );
	if( ![h7 containsObject: @70] ) NSPrintf( @"***** error h7 should contain 70\n" );
	//NSPrintf( @"Heap h7 after creation " );
	//[h7 printDescription];
	[h7 replaceObject: @13 withObject: @17];
	if( h7.size != 15 ) NSPrintf( @"***** error created heap with 14 obects, replaced a non-existent so the size should be 15 %lu\n", h7.size );
	if( ![h7 containsObject: @5] ) NSPrintf( @"***** error h7 should contain 5\n" );
	if( ![h7 containsObject: @10] ) NSPrintf( @"***** error h7 should contain 10\n" );
	if( ![h7 containsObject: @15] ) NSPrintf( @"***** error h7 should contain 15\n" );
	if( ![h7 containsObject: @17] ) NSPrintf( @"***** error h7 should contain 17 after replacing 13 with 17\n" );
	if( ![h7 containsObject: @20] ) NSPrintf( @"***** error h7 should contain 20\n" );
	if( ![h7 containsObject: @25] ) NSPrintf( @"***** error h7 should contain 25\n" );
	if( ![h7 containsObject: @30] ) NSPrintf( @"***** error h7 should contain 30\n" );
	if( ![h7 containsObject: @35] ) NSPrintf( @"***** error h7 should contain 35\n" );
	if( ![h7 containsObject: @40] ) NSPrintf( @"***** error h7 should contain 40\n" );
	if( ![h7 containsObject: @45] ) NSPrintf( @"***** error h7 should contain 45\n" );
	if( ![h7 containsObject: @50] ) NSPrintf( @"***** error h7 should contain 50\n" );
	if( ![h7 containsObject: @55] ) NSPrintf( @"***** error h7 should contain 55\n" );
	if( ![h7 containsObject: @60] ) NSPrintf( @"***** error h7 should contain 60\n" );
	if( ![h7 containsObject: @65] ) NSPrintf( @"***** error h7 should contain 65\n" );
	if( ![h7 containsObject: @70] ) NSPrintf( @"***** error h7 should contain 70\n" );
	//NSPrintf( @"Heap h7 after replacement of 13 with 17 " );
	//[h7 printDescription];
	[h7 removeObject: @13];
	if( h7.size != 15 ) NSPrintf( @"***** error removed non-existent object so the size should still be 15 %lu\n", h7.size );
	if( ![h7 containsObject: @5] ) NSPrintf( @"***** error h7 should contain 5\n" );
	if( ![h7 containsObject: @10] ) NSPrintf( @"***** error h7 should contain 10\n" );
	if( ![h7 containsObject: @15] ) NSPrintf( @"***** error h7 should contain 15\n" );
	if( ![h7 containsObject: @17] ) NSPrintf( @"***** error h7 should contain 17 after replacing 13 with 17\n" );
	if( ![h7 containsObject: @20] ) NSPrintf( @"***** error h7 should contain 20\n" );
	if( ![h7 containsObject: @25] ) NSPrintf( @"***** error h7 should contain 25\n" );
	if( ![h7 containsObject: @30] ) NSPrintf( @"***** error h7 should contain 30\n" );
	if( ![h7 containsObject: @35] ) NSPrintf( @"***** error h7 should contain 35\n" );
	if( ![h7 containsObject: @40] ) NSPrintf( @"***** error h7 should contain 40\n" );
	if( ![h7 containsObject: @45] ) NSPrintf( @"***** error h7 should contain 45\n" );
	if( ![h7 containsObject: @50] ) NSPrintf( @"***** error h7 should contain 50\n" );
	if( ![h7 containsObject: @55] ) NSPrintf( @"***** error h7 should contain 55\n" );
	if( ![h7 containsObject: @60] ) NSPrintf( @"***** error h7 should contain 60\n" );
	if( ![h7 containsObject: @65] ) NSPrintf( @"***** error h7 should contain 65\n" );
	if( ![h7 containsObject: @70] ) NSPrintf( @"***** error h7 should contain 70\n" );
	[h7 removeObject: @25];
	if( h7.size != 14 ) NSPrintf( @"***** error removed 25 object so the size should now be 14 not %lu\n", h7.size );
	if( ![h7 containsObject: @5] ) NSPrintf( @"***** error h7 should contain 5\n" );
	if( ![h7 containsObject: @10] ) NSPrintf( @"***** error h7 should contain 10\n" );
	if( ![h7 containsObject: @15] ) NSPrintf( @"***** error h7 should contain 15\n" );
	if( ![h7 containsObject: @17] ) NSPrintf( @"***** error h7 should contain 17 after replacing 13 with 17\n" );
	if( ![h7 containsObject: @20] ) NSPrintf( @"***** error h7 should contain 20\n" );
	if( [h7 containsObject: @25] ) NSPrintf( @"***** error h7 should not contain 25 after removing it\n" );
	if( ![h7 containsObject: @30] ) NSPrintf( @"***** error h7 should contain 30\n" );
	if( ![h7 containsObject: @35] ) NSPrintf( @"***** error h7 should contain 35\n" );
	if( ![h7 containsObject: @40] ) NSPrintf( @"***** error h7 should contain 40\n" );
	if( ![h7 containsObject: @45] ) NSPrintf( @"***** error h7 should contain 45\n" );
	if( ![h7 containsObject: @50] ) NSPrintf( @"***** error h7 should contain 50\n" );
	if( ![h7 containsObject: @55] ) NSPrintf( @"***** error h7 should contain 55\n" );
	if( ![h7 containsObject: @60] ) NSPrintf( @"***** error h7 should contain 60\n" );
	if( ![h7 containsObject: @65] ) NSPrintf( @"***** error h7 should contain 65\n" );
	if( ![h7 containsObject: @70] ) NSPrintf( @"***** error h7 should contain 70\n" );
	if( [h7.top intValue] != 5 ) NSPrintf( @"***** error top of heap should still be 5 not %@\n", h7.top );
	if( [[h7 pop] intValue] != 5 ) NSPrintf( @"***** error pop of heap should also be 5 not %@\n", h7.top );
	if( h7.size != 13 ) NSPrintf( @"***** error popped the 5 so the size should now be 13 not %lu\n", h7.size );
	if( [h7.top intValue] != 10 ) NSPrintf( @"***** error top of heap should now be 10 not %@\n", h7.top );
	if( [h7 containsObject: @5] ) NSPrintf( @"***** error h7 should not contain 5 after popping\n" );
	if( ![h7 containsObject: @10] ) NSPrintf( @"***** error h7 should contain 10\n" );
	if( ![h7 containsObject: @15] ) NSPrintf( @"***** error h7 should contain 15\n" );
	if( ![h7 containsObject: @17] ) NSPrintf( @"***** error h7 should contain 17 after replacing 13 with 17\n" );
	if( ![h7 containsObject: @20] ) NSPrintf( @"***** error h7 should contain 20\n" );
	if( [h7 containsObject: @25] ) NSPrintf( @"***** error h7 still should not contain 25\n" );
	if( ![h7 containsObject: @30] ) NSPrintf( @"***** error h7 should contain 30\n" );
	if( ![h7 containsObject: @35] ) NSPrintf( @"***** error h7 should contain 35\n" );
	if( ![h7 containsObject: @40] ) NSPrintf( @"***** error h7 should contain 40\n" );
	if( ![h7 containsObject: @45] ) NSPrintf( @"***** error h7 should contain 45\n" );
	if( ![h7 containsObject: @50] ) NSPrintf( @"***** error h7 should contain 50\n" );
	if( ![h7 containsObject: @55] ) NSPrintf( @"***** error h7 should contain 55\n" );
	if( ![h7 containsObject: @60] ) NSPrintf( @"***** error h7 should contain 60\n" );
	if( ![h7 containsObject: @65] ) NSPrintf( @"***** error h7 should contain 65\n" );
	if( ![h7 containsObject: @70] ) NSPrintf( @"***** error h7 should contain 70\n" );
	//NSPrintf( @"Heap h7 after popping off the 5 " );
	//[h7 printDescription];
	[h7 removeObject: @40];
	if( [h7.top intValue] != 10 ) NSPrintf( @"***** error top of heap should still be 10 not %@\n", h7.top );
	if( h7.size != 12 ) NSPrintf( @"***** error removed 40 so the size should now be 12 not %lu\n", h7.size );
	//NSPrintf( @"Heap h7 after removing 40 " );
	//[h7 printDescription];
	if( [h7 containsObject: @5] ) NSPrintf( @"***** error h7 should not contain 5 after popping\n" );
	if( ![h7 containsObject: @10] ) NSPrintf( @"***** error h7 should contain 10\n" );
	if( ![h7 containsObject: @15] ) NSPrintf( @"***** error h7 should contain 15\n" );
	if( ![h7 containsObject: @17] ) NSPrintf( @"***** error h7 should still contain 17\n" );
	if( ![h7 containsObject: @20] ) NSPrintf( @"***** error h7 should contain 20\n" );
	if( [h7 containsObject: @25] ) NSPrintf( @"***** error h7 still should not contain 25\n" );
	if( ![h7 containsObject: @30] ) NSPrintf( @"***** error h7 should contain 30\n" );
	if( ![h7 containsObject: @35] ) NSPrintf( @"***** error h7 should contain 35\n" );
	if( [h7 containsObject: @40] ) NSPrintf( @"***** error h7 should not contain 40 because I just removed it\n" );
	if( ![h7 containsObject: @45] ) NSPrintf( @"***** error h7 should contain 45\n" );
	if( ![h7 containsObject: @50] ) NSPrintf( @"***** error h7 should contain 50\n" );
	if( ![h7 containsObject: @55] ) NSPrintf( @"***** error h7 should contain 55\n" );
	if( ![h7 containsObject: @60] ) NSPrintf( @"***** error h7 should contain 60\n" );
	if( ![h7 containsObject: @65] ) NSPrintf( @"***** error h7 should contain 65\n" );
	if( ![h7 containsObject: @70] ) NSPrintf( @"***** error h7 should contain 70\n" );

	// Test replace object with worse object...
	NSNumber *vals[] = { @4, @8, @12, @16, @20, @24, @28, @32 };
	HEAP_TYPE *h8 = [HEAP_TYPE minHeapWithObjects: vals count: 8];
	if( h8.size != 8 ) NSPrintf( @"***** error created heap with 8 obects, size should be 8 not %lu\n", h8.size );
	if( [h8.top intValue] != 4 ) NSPrintf( @"***** error top of heap should be 4 not %@\n", h8.top );
	if( ![h8 containsObject: @4] ) NSPrintf( @"***** error h8 should contain 4\n" );
	if( ![h8 containsObject: @8] ) NSPrintf( @"***** error h8 should contain 8\n" );
	if( ![h8 containsObject: @12] ) NSPrintf( @"***** error h8 should contain 12\n" );
	if( ![h8 containsObject: @16] ) NSPrintf( @"***** error h8 should contain 16\n" );
	if( ![h8 containsObject: @20] ) NSPrintf( @"***** error h8 should contain 20\n" );
	if( ![h8 containsObject: @24] ) NSPrintf( @"***** error h8 should contain 24\n" );
	if( ![h8 containsObject: @28] ) NSPrintf( @"***** error h8 should contain 28\n" );
	if( ![h8 containsObject: @32] ) NSPrintf( @"***** error h8 should contain 32\n" );
	@try {
		//NSPrintf( @"Heap h8 before replacing 12 with 14 " );
		//[h8 printDescription];
		[h8 replaceObject: @12 withObject: @14];
		if( h8.size != 8 ) NSPrintf( @"***** error replaced 12 with 14, size should still be 8 not %lu\n", h8.size );
		if( [h8.top intValue] != 4 ) NSPrintf( @"***** error replaced 12 with 14, top of heap should be 4 not %@\n", h8.top );
		if( ![h8 containsObject: @4] ) NSPrintf( @"***** error h8 should contain 4\n" );
		if( ![h8 containsObject: @8] ) NSPrintf( @"***** error h8 should contain 8\n" );
		if( [h8 containsObject: @12] ) NSPrintf( @"***** error h8 should not contain 12 because it was replaced by 14\n" );
		if( ![h8 containsObject: @14] ) NSPrintf( @"***** error h8 should contain 14\n" );
		if( ![h8 containsObject: @16] ) NSPrintf( @"***** error h8 should contain 16\n" );
		if( ![h8 containsObject: @20] ) NSPrintf( @"***** error h8 should contain 20\n" );
		if( ![h8 containsObject: @24] ) NSPrintf( @"***** error h8 should contain 24\n" );
		if( ![h8 containsObject: @28] ) NSPrintf( @"***** error h8 should contain 28\n" );
		if( ![h8 containsObject: @32] ) NSPrintf( @"***** error h8 should contain 32\n" );
		//NSPrintf( @"Heap h8 after replacing 12 with 14 " );
		//[h8 printDescription];
	}
	@catch( NSException *exception ) {
		NSPrintf( @"***** error replace of object with worse object throws exception '%@'\n", exception );
	}

	// Test cases with StateInfo object...
	HEAP_TYPE *h9 = [HEAP_TYPE minHeap];
	[h9 push: [StateInfo withCost: 803.363 andVotes: 164]];
	[h9 push: [StateInfo withCost: 858.758 andVotes: 37]];
	[h9 push: [StateInfo withCost: 1402.82 andVotes: 50]];
	[h9 push: [StateInfo withCost: 1328.56 andVotes: 61]];
	[h9 push: [StateInfo withCost: 1253.48 andVotes: 61]];
	[h9 push: [StateInfo withCost: 941.308 andVotes: 47]];
	[h9 push: [StateInfo withCost: 1151.04 andVotes: 65]];
	[h9 push: [StateInfo withCost: 1241.98 andVotes: 73]];
	if( h9.size != 8 ) NSPrintf( @"***** error pushed eight objects so size should be 8 not %lu\n", h9.size );
	//NSPrintf( @"The lowest vote state is %@\n", h9.top );
	StateInfo *aState = [StateInfo withCost: 1253.48 andVotes: 61];
	if( ![h9 containsObject: aState] ) NSPrintf( @"***** error h9 should contain '%@'\n", aState );
	//NSPrintf( @"minHeap on votes h9 " );
	//[h9 printDescription];
	[h9 replaceObject: [StateInfo withCost: 1253.48 andVotes: 61] withObject: [StateInfo withCost: 1053.48 andVotes: 61]];
	//NSPrintf( @"minHeap on votes h9 after replace of 1253.48/61 with 1053.48/16 " );
	//[h9 printDescription];

	// Test cases with StateInfo object...
	HEAP_TYPE *h10 = [HEAP_TYPE heapWithComparator: ^NSComparisonResult( StateInfo *first, StateInfo *second ) {
				return cmpr(first.cost/first.votes,second.cost/second.votes); }];
	[h10 push: [StateInfo withCost: 803.363 andVotes: 164]];
	[h10 push: [StateInfo withCost: 858.758 andVotes: 37]];
	[h10 push: [StateInfo withCost: 1402.82 andVotes: 50]];
	[h10 push: [StateInfo withCost: 1328.56 andVotes: 61]];
	[h10 push: [StateInfo withCost: 1253.48 andVotes: 61]];
	[h10 push: [StateInfo withCost: 941.308 andVotes: 47]];
	[h10 push: [StateInfo withCost: 1151.04 andVotes: 65]];
	[h10 push: [StateInfo withCost: 1241.98 andVotes: 73]];
	if( h10.size != 8 ) NSPrintf( @"***** error pushed eight objects so size should be 8 not %lu\n", h10.size );
	//NSPrintf( @"The highest cost/vote state is %@\n", h10.top );
	[h10 pop];
	//NSPrintf( @"The next highest cost/vote state is %@\n", h10.top );
	if( ![h10 containsObject: aState] ) NSPrintf( @"***** error h10 should contain '%@'\n", aState );
	//NSPrintf( @"Heap h10 after popping one state " );
	//[h10 printDescription];

	// Test the allObjects method...
	NSArray *content;
	HEAP_TYPE *h11 = [HEAP_TYPE heap];
	if( h11.size != 0 ) NSPrintf( @"***** error created empty heap, size should be 0 not %lu\n", h11.size );
	content = [h11 allObjects];
	if( content.count != 0 ) NSPrintf( @"***** error array from empty heap should have count of 0 not %lu\n", content.count );
	h11 = [HEAP_TYPE minHeapWithObject: @9];
	if( h11.size != 1 ) NSPrintf( @"***** error created heap with object, size should be 1 not %lu\n", h11.size );
	content = [h11 allObjects];
	if( content.count != 1 ) NSPrintf( @"***** error array from heap with 1 entry should have count of 1 not %lu\n", content.count );
	//NSPrintf( @"Array has (%@)\n", [content componentsJoinedByString: @","] );
	h11 = [HEAP_TYPE maxHeapWithObjects: @9, @13, nil];
	if( h11.size != 2 ) NSPrintf( @"***** error created heap with objects, size should be 2 not %lu\n", h11.size );
	content = [h11 allObjects];
	if( content.count != 2 ) NSPrintf( @"***** error array from heap with 2 entries should have count of 2 not %lu\n", content.count );
	//NSPrintf( @"Array has (%@)\n", [content componentsJoinedByString: @","] );
	[h11 push: @43];
	if( h11.size != 3 ) NSPrintf( @"***** error pushed on a 43, size should be 3 not %lu\n", h11.size );
	content = [h11 allObjects];
	if( content.count != 3 ) NSPrintf( @"***** error array from heap with 3 entries should have count of 3 not %lu\n", content.count );
	//NSPrintf( @"Array has (%@)\n", [content componentsJoinedByString: @","] );
	[h11 push: @73];
	if( h11.size != 4 ) NSPrintf( @"***** error pushed on a 73, size should be 4 not %lu\n", h11.size );
	content = [h11 allObjects];
	if( content.count != 4 ) NSPrintf( @"***** error array from heap with 4 entries should have count of 4 not %lu\n", content.count );
	//NSPrintf( @"Array has (%@)\n", [content componentsJoinedByString: @","] );
	[h11 addObjectsFromArray: @[@15, @67, @-6, @53, @69]];
	if( h11.size != 9 ) NSPrintf( @"***** error added 15, 67, -1, 53 and 69, size should be 9 not %lu\n", h11.size );
	content = [h11 allObjects];
	if( content.count != 9 ) NSPrintf( @"***** error array from heap with 9 entries should have count of 9 not %lu\n", content.count );
	//NSPrintf( @"Array has (%@)\n", [content componentsJoinedByString: @","] );
	[h11 pop];
	if( h11.size != 8 ) NSPrintf( @"***** error popped top so size should be 8 not %lu\n", h11.size );
	content = [h11 allObjects];
	if( content.count != 8 ) NSPrintf( @"***** error array from heap with 8 entries should have count of 8 not %lu\n", content.count );
	//NSPrintf( @"Array has (%@)\n", [content componentsJoinedByString: @","] );
	[h11 pop];
	if( h11.size != 7 ) NSPrintf( @"***** error popped top so size should be 7 not %lu\n", h11.size );
	content = [h11 allObjects];
	if( content.count != 7 ) NSPrintf( @"***** error array from heap with 7 entries should have count of 7 not %lu\n", content.count );
	//NSPrintf( @"Array has (%@)\n", [content componentsJoinedByString: @","] );

	return 0;
}
