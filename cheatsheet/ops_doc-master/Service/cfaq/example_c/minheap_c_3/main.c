#include <stdio.h>
#include <stdlib.h>
#include "heap.h"

int main(int argc, char **argv)
{
	int heap[100];
	int end = 100; /* 堆的长度 */
	int pop;
	
	
	for (int i = 100; i > 0; i--) heap[100 - i] = i;
	
	MakeMinHeap(heap, 100);

	for (int i = 0; i < 100; i++) printf("heap[%d]: %d\n", i, heap[i]);	
	
	for (int i = 0; i < 100; i++) {
		pop = heap[0];
		MinHeapDeleteNumber(heap, end--);
		printf("pop: %d\n", pop);
	}
	
	system("pause");
	
	return 0;
}
