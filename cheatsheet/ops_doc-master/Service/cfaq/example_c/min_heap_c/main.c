#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#define CHILD(node) ((node) * 2 + 1)
static void heapify( int a[], int i, int n )
{
  /* Heapify an unknown number of subtrees */
  while ( CHILD( i ) < n ) {
    int child = CHILD( i );
    /* Pick the smaller of the two children */
    if ( child + 1 < n && a[child] > a[child + 1] )
      ++child;
    /* Move the smallest node to the root */
    if ( a[i] > a[child] ) {
      int temp = a[i];
      a[i] = a[child];
      a[child] = temp;
    }
    /* Move to the next node */
    ++i;
  }
}
void make_heap( int a[], int n )
{
  int i = n / 2;
  while ( i-- > 0 )
    heapify( a, i, n );
}

void pop_heap( int heap[], int n )
{
	int temp = heap[0];
	heap[0] = heap[n];
	heap[n] = temp;
	heapify( heap, 0, n );
}

int main( void )
{
  int heap[10];
  
  time_t t;
  
  time(&t);
	
  srand(t);
	
  for (int i = 0; i < 10; i++ )
    heap[i] = rand() % 100;
  /* Build a min heap */
  make_heap( heap, 10 );
  
  /* Prove that it's a min heap */
  for (int n = 10; n >= 0; n-- ) {
	printf("%d ", heap[0]);
    pop_heap( heap, n );
  }
  
  
  putchar( '\n' );
  
  system("pause");
  return 0;
}