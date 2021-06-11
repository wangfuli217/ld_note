#include <algorithm>
#include <cstdlib>
#include <iostream>

int main()
{
  using namespace std;
  int heap[10];
  for ( int i = 0; i < 10; i++ )
    heap[i] = rand() % 100;
  
  // Build a max heap
  
  make_heap( heap, heap + 10 );
  
  // Prove that it's a max heap
  for ( int n = 10; n > 0; n-- ) {
    for ( int i = 0; i < n; i++ )
      cout << heap[i] << ' ';
    
	pop_heap( heap, heap + n );
    
	cout << '\n';
  }
  
  system("pause");
  
  return 0;
}