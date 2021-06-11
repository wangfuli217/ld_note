#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#include <stdio.h>
#include <stdlib.h>

#if 0
#define assert(expression) \
   mock_assert(((expression) ? 1 : 0), #expression, __FILE__, __LINE__);
#endif
 
#if 1 
#define assert(expression) \
    mock_assert((int)(expression), #expression, __FILE__, __LINE__)
#endif  

 int divide(int a, int b) 
 {  
    assert(b);         
 	
	return a / b;
	
 }
  

 