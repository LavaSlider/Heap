all:	BinaryHeap campaign FibonacciHeap

BinaryHeap:	testBin.m testHeap.m ../Heap.m ../Heap.h ../BinaryHeap.m ../BinaryHeap.h
	clang -Wall -pedantic -framework Foundation testBin.m ../Heap.m ../BinaryHeap.m -o $@

# testBin.o:	testBin.m testHeap.m ../Heap.m ../Heap.h
#	clang -c -o $@ testBin.m

FibonacciHeap:	testFib.m testHeap.m ../Heap.m ../Heap.h ../FibonacciHeap.m ../FibonacciHeap.h
	clang -Wall -framework Foundation testFib.m ../Heap.m ../FibonacciHeap.m -o $@

#testFib.o:	testFib.m testHeap.m ../Heap.m ../Heap.h ../FibonacciHeap.m ../FibonacciHeap.h
#	clang -c -o $@ testFib.m

campaign:	campaign.m ../Heap.m ../Heap.h \
		../BinaryHeap.m ../BinaryHeap.h \
		../FibonacciHeap.m ../FibonacciHeap.h \
		knapsack.h knapsack1.m knapsack2.m
	clang -Wall -framework Foundation campaign.m knapsack1.m knapsack2.m ../Heap.m ../BinaryHeap.m ../FibonacciHeap.m -o $@
