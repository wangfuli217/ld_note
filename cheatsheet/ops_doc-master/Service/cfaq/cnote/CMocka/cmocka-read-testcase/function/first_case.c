#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

/*Test cases */
static void null_test_success(void **state)  /*null_test_success只是一个测试函数的名称，可以改成其他字符串*/
{
	(void) state ;
		
}


/*Test applications */
int main()
{
   const struct CMUnitTest tests[]={cmocka_unit_test(null_test_success),};	 //cmock_unit_test宏用test case初始化一个table,然后table被传递给run_tests()宏来执行测试.
                                                                             //run_tests()在运行每个测试函数之前设置适当的异常/信号处理程序和其他数据结构。
																			 //当一个完整的单元测试完成以后，run_tests()执行各种检查以确定测试是否成功

    
    return cmocka_run_group_tests(tests, NULL, NULL);
	
	//return cmocka_run_group_tests_name("test_success",tests,NULL,NULL);    //加上名字，这个名字是自己任意起的

}