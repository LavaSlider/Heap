all:	BinaryHeap FibonacciHeap campaign

BinaryHeap:	testBin.m testHeap.m ../Heap.m ../Heap.h ../BinaryHeap.m ../BinaryHeap.h
	clang -Wall -pedantic -framework Foundation testBin.m ../Heap.m ../BinaryHeap.m -o $@

FibonacciHeap:	testFib.m testHeap.m ../Heap.m ../Heap.h ../FibonacciHeap.m ../FibonacciHeap.h
	clang -Wall -framework Foundation testFib.m ../Heap.m ../FibonacciHeap.m -o $@

clean:
	rm -f BinaryHeap FibonacciHeap campaign x y

campaign:	campaign.m ../Heap.m ../Heap.h \
		../BinaryHeap.m ../BinaryHeap.h \
		../FibonacciHeap.m ../FibonacciHeap.h \
		knapsack.h knapsack1.m knapsack2.m
	clang -Wall -framework Foundation campaign.m knapsack1.m knapsack2.m ../Heap.m ../BinaryHeap.m ../FibonacciHeap.m -o $@
