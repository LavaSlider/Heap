// Reference: http://www.growingwiththeweb.com/data-structures/fibonacci-heap/overview/
//
// These should probably be in a class cluster...
// See: https://developer.apple.com/library/content/documentation/General/Conceptual/CocoaEncyclopedia/ClassClusters/ClassClusters.html
//
#import "FibonacciHeap.h"

#define NSPrintf(...)	printf( "%s", [[NSString stringWithFormat: __VA_ARGS__] UTF8String] )
//#define NSPrintf(...)	

@interface FibonacciHeapNode : NSObject
@property(nonatomic, strong) id object;
@property(nonatomic, assign) int degree;
@property(nonatomic, strong) FibonacciHeapNode *parent;
@property(nonatomic, strong) FibonacciHeapNode *child;
@property(nonatomic, strong) FibonacciHeapNode *prev;
@property(nonatomic, strong) FibonacciHeapNode *next;
@property(nonatomic, assign) BOOL isMarked;

- (instancetype) init;
- (instancetype) initWithObject: (id) object;
@end

@implementation FibonacciHeapNode

- (instancetype) init {
	return [self initWithObject: nil];
}

- (instancetype) initWithObject: (id) obj {
	if( (self = [super init]) ) {
		self.object = obj;
		self.next = self;
		self.prev = self;
	}
	return self;
}

// Stitch the next/prev pointers to skip this node
// (does nothing about parent/child pointers)
- (void) removeNodeFromList {
	FibonacciHeapNode *prev = self.prev;
	FibonacciHeapNode *next = self.next;
	prev.next = next;
	next.prev = prev;
	self.next = self;
	self.prev = self;
}

- (NSString *) description {
	return [self descriptionWithIndent: @""];
}
- (NSString *) descriptionWithIndent: (NSString *) indent {
	NSMutableString *description = [NSMutableString string];
	FibonacciHeapNode *current = self;
	do {
		[description appendString: indent];
		if( current.child ) {
			NSMutableString *tmpString = [NSMutableString stringWithFormat: @"%@ ", current.object];
			while( tmpString.length < 5 ) [tmpString appendString: @"-"];
			[description appendFormat: @"%@-+\n", tmpString ];
			if( current.next != self )
				[description appendString: [current.child descriptionWithIndent:
					[indent stringByAppendingString: @"|     "]]];
			else	[description appendString: [current.child descriptionWithIndent:
					[indent stringByAppendingString: @"      "]]];
		} else {
			[description appendFormat: @"%@\n", current.object];
		}
		current = current.next;
	} while( current != self );
	return description;
}

- (void) printDescription {
	//NSPrintf( @"%@", self );	// Buffers the whole string...
	[self printDescriptionWithIndent: @"" ];
}
- (void) printDescriptionWithIndent: (NSString *) indent {
	FibonacciHeapNode *current = self;
	do {
		//for( int i = 0; i < level; ++i )
		//	NSPrintf( @"|     " );
		NSPrintf( @"%@", indent );
		if( current.child ) {
			NSMutableString *tmpString = [NSMutableString stringWithFormat: @"%@", current.object];
			//[tmpString appendFormat: @"<%@>", current.parent.object];
			[tmpString appendString: @" "];
			while( tmpString.length < 5 ) [tmpString appendString: @"-"];
			NSPrintf( @"%@-+\n", tmpString );
			if( current.next != self )
				[current.child printDescriptionWithIndent: [indent stringByAppendingString: @"|     "]];
			else	[current.child printDescriptionWithIndent: [indent stringByAppendingString: @"      "]];
		} else {
			NSPrintf( @"%@", current.object );
			//NSPrintf( @"<%@>", current.parent.object );
			NSPrintf( @"\n" );
		}
		current = current.next;
	} while( current != self );
}
@end

@interface FibonacciHeap ()
@property(nonatomic, strong) FibonacciHeapNode	*_rootNode;
@property(nonatomic, assign) NSUInteger	_heapSize;

- (FibonacciHeapNode *) mergeList: (FibonacciHeapNode *) node1 withList: (FibonacciHeapNode *) node2;
- (NSArray *) getRootTrees;
- (void) linkHeap: (FibonacciHeapNode *) worst withList: (FibonacciHeapNode *) best;
- (void) consolidate;

- (void) removeNodeWithObject: (FibonacciHeapNode *) nodeWithObject;
- (void) replaceObjectInNode: (FibonacciHeapNode *) nodeWithObject withObject: (id) newObject;
@end


@implementation FibonacciHeap

- (instancetype) init {
	return [super init];
}
- (instancetype) initMax {
	return [super initMax];
}
- (instancetype) initMin {
	return [super initMin];
}
- (instancetype) initWithComparator: (NSComparator) comparator {
	return [super initWithComparator: comparator];
}

- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd {
	return [super initWithSortDescriptor: sd];
}

// Create and return a fibonacci heap from the contents of a file or URL
// (note that the comparator or sort descriptor is not in the file)
//+ (instancetype) heapWithContentsOfFile: (NSString *) path;
//+ (instancetype) heapWithContentsOfURL: (NSURL *) url;

// C++ style interface:
- (void) push: (ObjectType) object {
	if( object != nil ) {
		FibonacciHeapNode *newNode = [[FibonacciHeapNode alloc] initWithObject: object];
		__rootNode = [self mergeList: __rootNode withList: newNode];
		++__heapSize;
		//NSPrintf( @"After insert of %@\n", object );
		//[self printDescription];
	}
}
// This is called extractMin in the example implementations but I think it can
// be either a min or max depending on the comparator used to build the tree.
- (ObjectType) pop {
	//NSPrintf( @"Popping top of fibonacci heap with %lu entries\n", __heapSize );
	FibonacciHeapNode *extractedNode = __rootNode;
	if( __rootNode != nil ) {
		//NSPrintf( @"-- Top node is %@\n", __rootNode.object );
		// Set parent to nil for extracted node's children
		//NSPrintf( @"-- Setting parent to nil for all %@'s children\n", __rootNode.object );
		if( __rootNode.child != nil ) {
			FibonacciHeapNode *child = __rootNode.child;
			do {
				//NSPrintf( @"---- Setting parent of %@ to nil\n", child.object );
				child.parent = nil;
				child = child.next;
			} while( child != __rootNode.child );
		}
		FibonacciHeapNode *nextInRootList = (__rootNode.next == __rootNode) ? nil : __rootNode.next;
		//NSPrintf( @"-- Next in root list set to %@\n", nextInRootList.object );
		[extractedNode removeNodeFromList];
		--__heapSize;
		//NSPrintf( @"-- Removed %@ from the root list\n", extractedNode.object );

		// Merge the children of the minimum node with the root list
		// Does this do the whole chain of children... we looped and removed all their parents, didn't we?
		// Since they are being put into the root list their parents should be nil.
		__rootNode = [self mergeList: nextInRootList withList: extractedNode.child];
		if( nextInRootList != nil ) {
			//NSPrintf( @"-- Next in root list not nil, setting __rootNode to %@ and consolidating\n", nextInRootList.object );
			__rootNode = nextInRootList;
			[self consolidate];
		}
	}
	//NSPrintf( @"-- Returning popped item %@\n", extractedNode.object );
	return extractedNode.object;
}
- (ObjectType) top { return __rootNode.object; }
- (NSUInteger) size { return __heapSize; }
- (BOOL) empty	{ return __rootNode == nil; }

// Apple style interface
//- (void) addObject: (ObjectType) object { [self push: object]; }
//- (void) addObjectsFromArray: (NSArray *) array {
//	for( ObjectType o in array ) {
//		[self push: o ];
//	}
//}
- (void) removeAllObjects {
	__rootNode = nil;
	__heapSize = 0;
}
//- (void) replaceTopObjectWithObject: (id) object;
//- (void) setObjectsFromArray: (NSArray *) array {
//	[self removeAllObjects];
//	for( ObjectType obj in array ) {
//		[self push: obj ];
//	}
//}

- (BOOL) isEqualToHeap: (Heap *) heap {
	// Call the super's isEqualToHeap...
	if( ![super isEqualToHeap: heap] )
		return NO;
	// If any of the objects in self are not in heap then they are not equal
	if( __rootNode ) {
		FibonacciHeapNode *current = __rootNode;
		do {
			//NSPrintf( @"Checking if %@ is in the other heap\n", current.object );
			if( ![heap containsObject: current.object] )
				return NO;
			if( current.child ) {
				//NSPrintf( @"-- %@ has a child... going to %@\n", current.object, current.child.object );
				current = current.child;
			} else {
				//NSPrintf( @"-- %@ has no child... going to next %@\n", current.object, current.next.object );
				current = current.next;
				//NSPrintf( @"   %@ has parent %@... whose child is %@\n", current.object, current.parent.object, current.parent.child.object );
				// Changed from if to while to fix infinite looping thing...
				//if( current.parent && current.parent.child == current )
				while( current.parent && current.parent.child == current ) {
					current = current.parent.next;
					//NSPrintf( @"-- Resetting next to %@\n", current.object );
				}
			}
		} while( current != __rootNode );
	}
	return YES;
}
//- (void) filterUsingPredicate: (NSPredicate *) predicate;
- (BOOL) containsObject: (ObjectType) object {
	if( __rootNode == nil )	return NO;
	return [self findNodeWithObject: object] != nil;
}
- (FibonacciHeapNode *) findNodeWithObject: (id) obj {
	//NSPrintf( @"Looking for node with %@ in:\n", obj );
	//[__rootNode printDescription];
	FibonacciHeapNode *found = nil;
	if( obj && __rootNode ) {
		if( [self heapCompareNode: __rootNode.object toNode: obj] != NSOrderedAscending ) {
			found = [self findNodeWithObject: obj belowNode: __rootNode];
		//} else {
		//	NSPrintf( @"-- Rootnode %@ compare: %@ is NSOrderAscending, not in the heap\n", __rootNode.object, obj );
		}
		//if( found )
		//	NSPrintf( @"** Found it!\n" );
		//else	NSPrintf( @"** Not found!\n" );
	}
	return found;
}
// This always gets called with the rootNode or the node pointed to by the child pointer
// This will always be the largest/smallest of the root nodes or children.
// ((The above statement does not seem to be true after replaceObject:withObject:
//   [my replacement for decreaseKey] has been called. It seems as though the first
//   child may not be the max/min of the children anymore))
- (FibonacciHeapNode *) findNodeWithObject: (id) obj belowNode: (FibonacciHeapNode *) start {
	FibonacciHeapNode *current = start;
	FibonacciHeapNode *found = nil;
	do {
		//NSPrintf( @"-- Checking %@\n", current.object );
		if( [self heapCompareNode: current.object toNode: obj] != NSOrderedAscending ) {
			if( [current.object isEqual: obj] ) {
	//			NSPrintf( @"   ** Found! **\n" );
				found = current;
			} else if( current.child && [self heapCompareNode: current.child.object toNode: obj] != NSOrderedAscending ) {
	//			NSPrintf( @"   No match, Going to recurse and check %@'s children\n", current.object );
				found = [self findNodeWithObject: obj belowNode: current.child];
	//		} else {
	//			if( current.child && [self heapCompareNode: current.child.object toNode: obj] == NSOrderedAscending ) {
	//				NSPrintf( @"   No match but child %@ compare: %@ is NSOrderAscending, so no further checking needed\n", current.child.object, obj );
	//			} else {
	//				NSPrintf( @"   No match, No children, can't recurse\n" );
	//			}
			}
	//	} else {
	//		NSPrintf( @"-- Since %@ compare: %@ is NSOrderAscending, no checking of children needed\n", current.object, obj );
		}
		current = current.next;
	} while( !found && current != start );
	return found;
}
- (NSUInteger) count { return __heapSize; }
- (ObjectType) topObject { return __rootNode.object; }
#if 1
- (NSArray *) allObjects {
	if( !__rootNode )
		return [NSArray array];
	NSMutableArray	*all = [NSMutableArray arrayWithCapacity: __heapSize];
	FibonacciHeapNode *current = __rootNode;
	do {
		[all addObject: current.object];
		if( current.child ) {
			current = current.child;
		} else {
			current = current.next;
			if( current.parent && current.parent.child == current ) {
				current = current.parent.next;
			}
		}
	} while( current != __rootNode );
	return all;
}
#else
- (NSArray *) allObjects {
	if( !__rootNode )
		return [NSArray array];
	NSMutableArray	*all = [NSMutableArray arrayWithCapacity: __heapSize];
	[self appendObjectsToArray: all fromNode: __rootNode];
	return all;
}
- (void) appendObjectsToArray: (NSMutableArray *) all fromNode: (FibonacciHeapNode *) start {
	FibonacciHeapNode *current = start;
	do {
		[all addObject: current.object];
		if( current.child )
			[self appendObjectsToArray: all fromNode: current.child];
		current = current.next;
	} while( current != start );
}
#endif

// mergeList:withList: splices the two lists together using their prev/next pointers
// and returns the higher priority of the two
// (this seems to assume that the nodes passed are the highet priority nodes in their respective prev/next lists)
- (FibonacciHeapNode *) mergeList: (FibonacciHeapNode *) a withList: (FibonacciHeapNode *) b {
	// Take care of the simple stuff...
	if( a == nil && b == nil ) return nil;
	if( a == nil ) return b;
	if( b == nil ) return a;

	FibonacciHeapNode *temp = a;
	//NSPrintf( @"Merging (" );
	//do {
	//	NSPrintf( @"%@", temp.object );
	//	temp = temp.next;
	//	if( temp != a ) NSPrintf( @" <-> " );
	//} while( temp != a );
	//temp = b;
	//NSPrintf( @") with (" );
	//do {
	//	NSPrintf( @"%@", temp.object );
	//	temp = temp.next;
	//	if( temp != b ) NSPrintf( @" <-> " );
	//} while( temp != b );
	//NSPrintf( @")" );
	temp = a.next;
	a.next = b.next;
	a.next.prev = a;
	b.next = temp;
	b.next.prev = b;

	//FibonacciHeapNode *result = ([self heapCompareNode: a.object toNode: b.object] == NSOrderedDescending) ? a : b;
	//temp = result;
	//NSPrintf( @" to get (" );
	//do {
	//	NSPrintf( @"%@", temp.object );
	//	temp = temp.next;
	//	if( temp != result ) NSPrintf( @" <-> " );
	//} while( temp != result );
	//NSPrintf( @")\n" );
	return ([self heapCompareNode: a.object toNode: b.object] == NSOrderedDescending) ? a : b;
}

- (NSArray *) getRootTrees {
	NSMutableArray	*items = [NSMutableArray array];
	FibonacciHeapNode *current = __rootNode;
	do {
		[items addObject: current];
		current = current.next;
	} while( current != __rootNode );
	return items;
}

- (void) linkHeap: (FibonacciHeapNode *) worse withList: (FibonacciHeapNode *) better {
	//NSPrintf( @"Entering linkHeap with worse of %@ and better of %@\n", worse.object, better.object );
	[worse removeNodeFromList];
	better.child = [self mergeList: worse withList: better.child];
	worse.parent = better;
	worse.isMarked = NO;
}

// Merge all trees of the same order together until
// there are no two trees of the same order.
- (void) consolidate {
	if( __rootNode == nil )	return;

	//NSPrintf( @"Entering consolidate with %lu nodes and root of %@\n", __heapSize, __rootNode.object );
	NSMutableArray *aux = [NSMutableArray array];
	NSArray *items = [self getRootTrees];
	//NSPrintf( @"-- There are %lu root trees\n", items.count );
	FibonacciHeapNode *top;
	for( int i = 0; i < items.count; ++i ) {
		top = items[i];
		//NSPrintf( @"-- Processing item %d (%@) of degree %d\n", i, top.object, top.degree );
		while( aux.count <= top.degree + 1 ) {
			[aux addObject: [NSNull null]];
		}
		// If there exists another node with the same degree, merge them
		while( aux[top.degree] != [NSNull null] ) {
			//NSPrintf( @"---- More than one tree with degree %d\n", top.degree );
			FibonacciHeapNode *other = aux[top.degree];
			// Check the order and swap so they are proper for linkHeap:withList:
			if( [self heapCompareNode: top.object toNode: other.object] == NSOrderedAscending ) {
				FibonacciHeapNode *temp = top;
				top = aux[top.degree];
				aux[top.degree] = temp;
			}
			[self linkHeap: aux[top.degree] withList: top];
			aux[top.degree] = [NSNull null];
			++top.degree;
		}
		while( aux.count <= top.degree + 1 ) {
			[aux addObject: [NSNull null]];
		}
		aux[top.degree] = top;
	}
	// Rebuild the tree
	//NSPrintf( @"-- Rebuilding the tree\n" );
	__rootNode = nil;
	for( int i = 0; i < aux.count; ++i ) {
		if( aux[i] != [NSNull null] ) {
			// Remove siblings before merging
			top = aux[i];
			top.next = aux[i];
			top.prev = aux[i];
			__rootNode = [self mergeList: __rootNode withList: aux[i]];
		}
	}
	//NSPrintf( @"-- At the end of consolidate the root node is %@ and the heap is:\n", __rootNode.object );
	//[self printDescription];
}

// Find the node with the object and delete it...
- (void) removeObject: (id) object {
	FibonacciHeapNode *nodeWithObject = [self findNodeWithObject: object];
	[self removeNodeWithObject: nodeWithObject];
}
- (void) removeNodeWithObject: (FibonacciHeapNode *) nodeWithObject {
	if( nodeWithObject != nil ) {
		FibonacciHeapNode *parent = nodeWithObject.parent;
		if( parent != nil ) {
			[self cutNode: nodeWithObject fromParent: parent];
			[self cascadingCutFromNode: parent];
		}
		__rootNode = nodeWithObject;
		[self pop];
	}
}

// DecreaseKey changes a key to a lower value and fixes the tree....
// To use this the user must get access to a FibonacciHeapNode but
// these are private and I don't think should be released to the
// outside world... an alternative would be to have a find function
// so it could be a description of the node to change.
//
// I need to change the name to be maxHeap and minHeap compatible.
// I need to try and generalize it for increase or decrease value
// operations... I can always delete and then push!
- (void) replaceObject: (id) object withObject: (id) newObject {
	[self replaceObjectInNode: [self findNodeWithObject: object] withObject: newObject];
}
- (void) replaceObjectInNode: (FibonacciHeapNode *) nodeWithObject withObject: (id) newObject {
	if( !nodeWithObject ) {
		// If no node exists with the object, then make a new node for it
		[self push: newObject];
		//[NSException raise: NSInvalidArgumentException
		//	format: @"Object is not in the heap."];
	} else if( newObject == nil ) {
		[self removeNodeWithObject: nodeWithObject];
	} else if( [self heapCompareNode: newObject toNode: nodeWithObject.object] == NSOrderedAscending ) {
		// There might be a more efficient way to do this...
		[self removeNodeWithObject: nodeWithObject];
		[self push: newObject];
		//[NSException raise: NSInvalidArgumentException
		//	format: @"New object is not 'better' than old object."];
	} else {
		nodeWithObject.object = newObject;
		FibonacciHeapNode *parent = nodeWithObject.parent;
		BOOL parentNotNil = NO;
		if( parent != nil ) {
			parentNotNil = YES;
			if( [self heapCompareNode: nodeWithObject.object toNode: parent.object] == NSOrderedDescending ) {
				[self cutNode: nodeWithObject fromParent: parent];
				[self cascadingCutFromNode: parent];
#if 1
			} else if( [self heapCompareNode: nodeWithObject.object toNode: parent.child.object] == NSOrderedDescending ) {
				//NSPrintf( @"Parent is set, new-node (%@) belongs below it (%@) but is not set as best of sibship (%@), resetting\n", nodeWithObject.object, parent.object, parent.child.object );
				parent.child = nodeWithObject;
			//} else {
			//	NSPrintf( @"Parent is set but new-node (%@) belongs below it (%@)\n", nodeWithObject.object, parent.object );
#endif
			}
		}
		// This compare right here probably should not be with __rootNode but with
		// the 'relative root' for the sibship which would be node.parent.child...
		if( [self heapCompareNode: nodeWithObject.object toNode: __rootNode.object] == NSOrderedDescending ) {
			if( parentNotNil ) NSPrintf( @"++++++ Ok, needed to reset __rootNode for non-nil parent case!!\n" );
			__rootNode = nodeWithObject;
		}
	}
}

// Cut the link between a node and its parent, moving the node to the root list.
// Simplify this to: cutNodeFromParent: (FibonacciHeapNode *) node and have it
// return the parent?
- (void) cutNode: (FibonacciHeapNode *) node fromParent: (FibonacciHeapNode *) parent {
	node.parent = nil;	// ADDED 5/9/17....
	--parent.degree;
	// Will this leave 'parent.child' as having just the next in line, but they are not organized...
	// Seems like it needs to be:
	//	parent.child = ((node.next == node) ? nil : bestOf(node.next...);
#if 1
	// This fixes the problem...
	FibonacciHeapNode *firstChild = nil;
	FibonacciHeapNode *currentNode = node.next;
	while( currentNode != node ) {
		if( !firstChild ||
		    [self heapCompareNode: firstChild.object toNode: currentNode.object] == NSOrderedAscending ) {
			firstChild = currentNode;
		}
		currentNode = currentNode.next;
	}
	parent.child = firstChild;
#elif 1
	// This was my first fix but I think is a little more kludgy looking...
	if( node.next == node ) {
		parent.child = nil;
	} else if( parent.child == node ) {
		parent.child = node.next;
		FibonacciHeapNode *currentNode = node.next;
		do {
			if( [self heapCompareNode: parent.child.object toNode: currentNode.object] == NSOrderedAscending ) {
				parent.child = currentNode;
			}
			currentNode = currentNode.next;
		} while( currentNode != node );
	}
#else
	// This is the broken code that demonstrates removeBugExample.txt
	parent.child = ((node.next == node) ? nil : node.next);
#endif
	[node removeNodeFromList];
	[self mergeList: __rootNode withList: node];
	node.isMarked = NO;
}
// Perform a cascading cut on a node; mark the node if it is not marked,
// otherwise cut the node and perform a cascading cut on its parent.
- (void) cascadingCutFromNode: (FibonacciHeapNode *) node {
	if( node.parent != nil ) {
		if( node.isMarked ) {
			FibonacciHeapNode *parent = node.parent;
			[self cutNode: node fromParent: parent];
			[self cascadingCutFromNode: parent];
		} else {
			node.isMarked = YES;
		}
	}
}

//- description;	// Formatted as a property list...?
- (NSString *) description {
	if( __rootNode )
		return [__rootNode description];
	return @"";
}
- (void) printDescription {
	if( __rootNode == nil ) {
		NSPrintf( @"Empty Fibonacci Heap\n" );
	} else {
		NSPrintf( @"Dump of Fibonacci Heap with %lu Nodes\n", __heapSize );
		//NSPrintf( @"%@", self );	// Buffers output...
		[__rootNode printDescription];
	}
}

@end
