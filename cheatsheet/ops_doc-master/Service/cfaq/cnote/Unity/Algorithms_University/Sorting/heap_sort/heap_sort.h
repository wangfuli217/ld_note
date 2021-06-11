#ifndef __HEAP_SORT_H_KEIXJ4PDU3__
#define __HEAP_SORT_H_KEIXJ4PDU3__

typedef int (*CompFunction)(void*, void*);


void heap_sort(void** array, int size, CompFunction compare);


#endif