#ifndef __INSERTION_SORT_H_KEIXJ4PDU3__
#define __INSERTION_SORT_H_KEIXJ4PDU3__

typedef int (*CompFunction)(void*, void*);

void insertion_sort(void** array, int size, CompFunction compare);


#endif
