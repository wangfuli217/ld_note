#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>
#include "database.h"
#include <stdio.h>

extern DatabaseConnection* connect_to_product_database(void);

/* Mock connect to database function.  模拟链接数据库函数.
   NOTE: This mock function is very general could be shared between tests
   that use the imaginary database.h module.
   这个模拟函数比较通用，可重复用。
*/

//mock function
DatabaseConnection* connect_to_database(const char * const url,const unsigned int port)
{
    check_expected_ptr(url);
    check_expected(port);
    return (DatabaseConnection*)((size_t)mock());
  
  //return (DatabaseConnection*)((size_t)mock())等价于
  #if 0
   DatabaseConnection *rtv;
   rtv=(DatabaseConnection *)(size_t)mock();  //强制转换类型
   printf("%ld\n",(long int)rtv);             //打印结果是3665476179
   return rtv;
  #endif
}

//测试成功
static void test_connect_to_product_database(void **state)
{
    (void) state;   /* unused */
    expect_string(connect_to_database, url, "products.abcd.org");
    expect_value(connect_to_database, port, 322);
    will_return(connect_to_database, 0xDA7ABA53); //0xDA7ABA53是(DatabaseConnection *)(size_t)mock()的返回值;
	                                              //转换成10进制是3665476179;

    assert_int_equal((size_t)connect_to_product_database(), 0xDA7ABA53);
}


// "products.abcd.org" != "products.abcd.com",测试失败
// 期望的URL和实际通过 connect_to_product_database()传入 connect_to_database()的不同,测试失败。

static void test_connect_to_product_database_bad_url(void **state)
{
    (void) state; /* unused */

    expect_string(connect_to_database, url, "products.abcd.com");  

    expect_value(connect_to_database, port, 322);
    will_return(connect_to_database, 0xDA7ABA53);
    assert_int_equal((size_t)connect_to_product_database(), 0xDA7ABA53);
}

//没有指定端口，测试失败
static void test_connect_to_product_database_missing_parameter(void **state)
{
    (void) state; /* unused */

    expect_string(connect_to_database, url, "products.abcd.org");  //
    will_return(connect_to_database, 0xDA7ABA53);
    assert_int_equal((size_t)connect_to_product_database(), 0xDA7ABA53);
}

int main(void) {
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test_connect_to_product_database),
        cmocka_unit_test(test_connect_to_product_database_bad_url),
        cmocka_unit_test(test_connect_to_product_database_missing_parameter),
    };
    return cmocka_run_group_tests(tests, NULL, NULL);
}
