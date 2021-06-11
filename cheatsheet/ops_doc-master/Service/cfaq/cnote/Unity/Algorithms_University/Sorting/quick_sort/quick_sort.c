#include "quick_sort.h"
#include <stdio.h>

void swap(void** e1, void** e2) {
  void* tmp = *e1;
  *e1 = *e2;
  *e2 = tmp;
}

void partition(void** array, int size, CompFunction compare, int* posizione_pivot, int* size_pivot) {
  
  void** array_pivot = &array[0];
  int size_eq = 1, i, res;

  //swap the middle element with the first
  swap(&array[0], &array[size/2]);

  for(i = 1; i < size; i++) {

    res = compare(array[i], array_pivot[0]);

    if (res < 0) {                                  //if the element is less than pivot we move it in the partition of the minors
      swap(&array[i], &array_pivot[size_eq]);
      swap(&array_pivot[size_eq], &array_pivot[0]);
      array_pivot = &array_pivot[1];
    } else if (res == 0) {                          //if is equal we move the element in the partition of the equals. Otherwise the element is greater than pivot, so we can check the next element
      swap(&array[i], &array_pivot[size_eq]);
      size_eq++;
    }

  }

  *posizione_pivot = array_pivot - array;
  *size_pivot = size_eq;
}

//partition the array in three parts one less than pivot, one equal to pivot and one greter than pivot
void quick_sort(void** array, int size, CompFunction compare) {
  if (size > 1) {
    int posizione_pivot, size_pivot;
    partition(array, size, compare, &posizione_pivot, &size_pivot);
    quick_sort(array, posizione_pivot, compare);
    quick_sort(&array[posizione_pivot+size_pivot], size-posizione_pivot-size_pivot, compare);
  }
}
