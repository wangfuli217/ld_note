#ifndef __QUICK_SORT_H_KEIXJ4PDU3__
#define __QUICK_SORT_H_KEIXJ4PDU3__

typedef int (*CompFunction)(void*, void*);

void quick_sort(void** array, int size, CompFunction compare);


#endif
