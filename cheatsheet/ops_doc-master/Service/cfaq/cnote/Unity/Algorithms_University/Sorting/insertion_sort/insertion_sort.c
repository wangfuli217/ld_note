#include "insertion_sort.h"

//move an element toward the start of the array, until the previous element is minor or we have reached the start
void insertion_sort(void** array, int size, CompFunction compare) {
  void* insert_elem;
  int y;

  for(int i=1; i<size; i++) {
    
    insert_elem = array[i];
    y = i;
    
    while(y>0 && compare(array[y-1],insert_elem) > 0) {
      array[y] = array[y-1];
      y--;
    }

    array[y] = insert_elem;
  }
}

