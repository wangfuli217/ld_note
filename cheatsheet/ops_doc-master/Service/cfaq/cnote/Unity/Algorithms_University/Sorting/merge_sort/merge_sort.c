#include "merge_sort.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//merge the parts in order
void merge(void** array1, int size1, void** array2, int size2, CompFunction compare) {
  if(size1 > 0 && size2 > 0){

    int sizetot = size1 + size2;
    void** arrayt = (void**) malloc(sizeof(void*) * sizetot);
    int iat = 0, ia1 = 0, ia2 = 0;
    
    //insert in the helper array the element of the others array in order until one of them is empty
    while (ia1 < size1 && ia2 < size2) {
      if (compare(array1[ia1], array2[ia2]) < 0)
        arrayt[iat++] = array1[ia1++];
      else
        arrayt[iat++] = array2[ia2++];
    }

    //copy in the helper array the remanent elements of the array that still contains something
    if (ia1 < size1)
      memcpy(&arrayt[iat], &array1[ia1], sizeof(void*) * (size1-ia1));
    else
      memcpy(&arrayt[iat], &array2[ia2], sizeof(void*) * (size2-ia2));

    //replace the content of the original array with the content of the helper array
    memcpy(array1, arrayt, sizeof(void*) * sizetot);
    free(arrayt);
  }
}

//divide the array in half until the parts are of size 1
void merge_sort(void** array, int size, CompFunction compare) {
  if (size > 1){
    int k = size/2;
    merge_sort(array, k, compare);
    merge_sort(&array[k], size-k, compare);
    merge(array, k, &array[k], size-k, compare);
  }
}
