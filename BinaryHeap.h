#import "Heap.h"

@interface BinaryHeap : Heap

- (instancetype) initWithCapacity: (NSUInteger) numItems;
- (instancetype) initMinWithCapacity: (NSUInteger) numItems;
- (instancetype) initMaxWithCapacity: (NSUInteger) numItems;
- (instancetype) initWithComparator: (NSComparator) comparator andCapacity: (NSUInteger) numItems;
- (instancetype) initWithSortDescriptor: (NSSortDescriptor *) sd andCapacity: (NSUInteger) numItems;

@end
