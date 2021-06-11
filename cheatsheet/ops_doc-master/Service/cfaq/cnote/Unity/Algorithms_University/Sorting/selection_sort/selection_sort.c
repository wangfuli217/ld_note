#include "selection_sort.h"


/*
 * Restituisce l'indice del minimo elemento in array[pos..(size-1)].
 * array: l'array in cui cercare
 * size: dimensione dell'array
 * pos: posizione da cui far iniziare la ricerca
 * compare: funzione di confronto tra due elementi dell'array
 */
int select(void** array, int size, int pos, CompFunction compare) {
  int min_index = pos;

  for(int i=pos+1; i<size; ++i) {
    if(compare(array[i], array[min_index])<0) {
      min_index = i;
    }
  }

  return min_index;
}

/*
 * Dati due puntatori, ne inverte il contenuto
 * e1: puntatore al primo valore
 * e2: puntatore al secondo valore
 */
void swap(void** e1, void** e2) {
  void* tmp = *e1;
  *e1 = *e2;
  *e2 = tmp;
}

void selection_sort(void** array, int size, CompFunction compare) {
  for(int i=0; i<size-1; ++i) {
    int min_index = select(array, size, i, compare);
    swap(&array[i], &array[min_index]);
  }
}
