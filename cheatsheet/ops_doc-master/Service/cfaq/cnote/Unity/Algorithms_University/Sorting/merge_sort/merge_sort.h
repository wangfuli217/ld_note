#ifndef __MERGE_SORT_H_KEIXJ4PDU3__
#define __MERGE_SORT_H_KEIXJ4PDU3__

typedef int (*CompFunction)(void*, void*);


void merge_sort(void** array, int size, CompFunction compare);


#endif
