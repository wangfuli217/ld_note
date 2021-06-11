https://www.cnblogs.com/wang_yb/p/3999701.html

1. 引用 CPPUTest 中的2个头文件
#include <CppUTest/CommandLineTestRunner.h>
#include <CppUTest/TestHarness.h>


2. 引用 C 头文件时, 需要使用 extern "C" {}
extern "C"
{
#include "sample.h"
}

CPPUTest 的测试用例非常简单, 首先定义一个 TEST_GROUP, 然后定义属于这个 TEST_GROUP 的 TEST.

./test    <-- 默认执行, 没有参数
./test -c   <-- -c 执行结果加上颜色 (成功绿色, 失败红色)
./test -v  <-- -v 显示更为详细的信息
./test -r 2   <-- -r 指定测试执行的次数, 这里把测试重复执行2遍
./test -g sample    <-- -g 指定 TEST_GROUP, 本例其实只有一个 TEST_GROUP sample
./test -n ret_int_success    <-- -s 指定执行其中一个 TEST, 名称为 ret_int_success
./test -v -n ret_int_success  <-- 参数也可以搭配使用


内存泄漏检测插件
内存泄漏一直是C/C++代码中令人头疼的问题, 还好, CPPUTest 中提供了检测内存泄漏的插件, 使用这个插件, 可使我们的代码更加健壮.
使用内存检测插件时, 测试代码 和 待测代码 在编译时都要引用.
-include $(CPPUTEST_HOME)/include/CppUTest/MemoryLeakDetectorMallocMacros.h


测试用例结果判断 ( fail, 各种assert等等)

测试完成后, 可以用 CPPUTest 提供的宏来判断测试结果是否和预期一致.

CPPUTest 提供的用于判断的宏如下: (上面的测试代码就使用了 CHECK_EQUAL)

Assertion 宏                                     含义
CHECK(boolean condition)                         condition==True则成功; 反之失败
CHECK_TEXT(boolean condition, text)              condition==True则成功; 反之失败, 并且失败时输出 text信息
CHECK_EQUAL(expected, actual)                    expected==actual则成功; 反之失败
CHECK_THROWS(expected_exception, expression)     抛出的异常 expected_exception==exception则成功; 反之失败
STRCMP_EQUAL(expected, actual)                   字符串 expected==actual则成功; 反之失败
LONGS_EQUAL(expected, actual)                    数字 expected==actual则成功; 反之失败
BYTES_EQUAL(expected, actual)                    数字 expected==actual则成功; 反之失败 (数字是 8bit 宽)
POINTERS_EQUAL(expected, actual)                 指针 expected==actual则成功; 反之失败
DOUBLES_EQUAL(expected, actual, tolerance)       double型 expected和actual在误差范围内(tolerance)相等则成功; 反之失败
FAIL(text)                                       总是失败, 并输出 text 信息