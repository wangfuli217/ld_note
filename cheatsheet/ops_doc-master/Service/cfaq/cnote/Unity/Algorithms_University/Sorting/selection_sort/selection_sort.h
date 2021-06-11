#ifndef __SELECTION_SORT_H_KEIXJ4PDU3__
#define __SELECTION_SORT_H_KEIXJ4PDU3__

typedef int (*CompFunction)(void*, void*);

/*
 * Implementa il selection selection_sort sul posto
 * array: l'array da ordinare
 * compare: funzione per valutare l'ordine di due elementi dell'array
 *
 * Nota: la funzione va usata per confrontare elementi che possono essere
 *   dereferenziati. L'utilizzo di essa per ordinare array di tipi "nativi"
 *   non è supportato e andrebbe evitato.
 */
void selection_sort(void** array, int size, CompFunction compare);


#endif
