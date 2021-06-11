/*
  单独使用mock_assert()的时候，它的用法和assert()差不多。
  
  如果expression值为假（即为0），那么它先向stderr打印一条出错信息,然后通过调用 abort 来终止程序运行。

*/
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#if 1
#define assert(expression) \
   mock_assert(((expression) ? 1 : 0), #expression, __FILE__, __LINE__);
#endif

#if 0 
#define assert(expression) \
    mock_assert((int)(expression), #expression, __FILE__, __LINE__)
#endif 

void test() 
 {  
	//assert(0);        //error: Failure! 	
	assert(10);         //PASSED  
 }

 int main()
{
	const struct CMUnitTest tests[] = {
        cmocka_unit_test(test),
    };
	
	return cmocka_run_group_tests(tests, NULL, NULL);
	
}