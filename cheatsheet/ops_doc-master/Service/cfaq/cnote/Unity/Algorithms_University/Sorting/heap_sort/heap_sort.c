#include "heap_sort.h"
#include <stdio.h>

#define PARENT(i) ((i)-1)/2
#define LEFT_CHILD(i) (2*(i))+1

void swap(void** e1, void** e2) {
  void* tmp = *e1;
  *e1 = *e2;
  *e2 = tmp;
}

//move the greater of the children toward the root
void sift_down(void** array, int root, int end, CompFunction compare) {
  int child = LEFT_CHILD(root), 
      swp = root;

  while(child <= end) {    

    if (compare(array[swp], array[child]) < 0)
      swp = child;

    if (child+1 <= end && compare(array[swp], array[child+1]) < 0)
      swp = child + 1;

    if (swp != root) {
      swap(&array[root], &array[swp]);
      root = swp;
    } else 
      break;
    
    child = LEFT_CHILD(root);
  }

}

//heapify the array
void heapify(void** array, int size, CompFunction compare) {
  for (int i = PARENT(size - 1); i >= 0; i--)
    sift_down(array, i, size-1, compare);
}

//heapify, put the max in the last position and move the greater towards the root
void heap_sort(void** array, int size, CompFunction compare) {
  heapify(array, size, compare);

  for(int i=size-1; i>0; ){
    swap(&array[i], &array[0]);
    sift_down(array, 0, --i, compare);
  }
}