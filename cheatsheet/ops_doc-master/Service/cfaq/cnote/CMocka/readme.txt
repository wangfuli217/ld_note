https://www.colabug.com/712600.html

Running Tests               是整个测试的运行函数
Standard Assertions         对标准assert的一种替换方案，防止测试被assert打断
Checking Parameters         用于对函数参数的检测
Mock Objects                用于mock对象，常用作mock函数的返回，实现方式与Checking Parameter类似
Dynamic Memory Allocation   用于对内存的检测
Assert Macros               包含了常用的断言


cmocka_unit_test是一个宏，如果不深究的话，完全可以把它当做函数。除此之外，还有另外3个宏：
cmocka_unit_test_startup(case, startup)
cmocka_unit_test_teardown(case, teardown)
cmocka_unit_test_startup_teardown(case, startup, teardown)


void fail(void) 立即结束当前test case，报错
void fail(const char* msg) 立即结束当前test case，报错并打印错误信息
void skip(void) 跳过当前test case

1. 表达式
    assert_true(expr)
    assert_false(expr)
其中expr表示C语言的表达式，相对简单，assert_true()和assert()的用法差不多,而assert_false()则是正好相反。

2. 整型
    assert_int_equal(int a, int b)
    assert_int_not_equal(int a, int b)

断言int型变量a与b是否相等。
    assert_in_range(LargestIntegralType v, LargestIntegralType min, LargestIntegralType max)
    assert_not_in_range(LargestIntegralType v, LargestIntegralType min, LargestIntegralType max)

断言v是否在[min, max]的范围之内。
    assert_in_set(LargestIntegralType v, LargestIntegralType vals[], size_t count)
    assert_not_in_set(LargestIntegralType v, LargestIntegralType vals[], size_t count)
断言v是否属于vals集合。

3. 指针
    assert_ptr_equal(void* a, void* b)
    assert_ptr_not_equal(void* a, void* b)
    assert_null(void* p)
    assert_not_null(void* p)
判断两个指针变量a与b是否相等，或者p指针是否为NULL。
4. 内存块
    assert_memory_equal(const void* a, const void* b, size_t size)
    assert_memory_not_equal(const void* a, const void* b, size_t size)
断言长度为size的a与b指向的内存内容是否相等。

5. string类型
C语言并没有字符串，只有char*，虽然我们也能使用内存块断言，但cmocka还是提供了字符串的断言。
    assert_string_equal(const char* a, const char* b)
    assert_string_not_equal(const char* a, const char* b)
断言a与b指向的字符串是否相等，而此处的size相当于strlen(a)或strlen(b)。
6. 函数返回值
    assert_return_code(int rc, int error)
断言函数的返回值rc是否小于0，并将errno传入，如果出错则将错误信息加入到输出中。



1. 参数断言
    check_expected(#para)
    check_expected_ptr(#para)
检查函数，但并不指出应该检查什么，这些都已经在函数调用之前通过如下的expect_*函数指定了。其中后者用于对指针类型的检查事件。
    expect_any(#func, #para)
    expect_any_count(#func, #para, size_t count)

指定func的para将会被传递的事件，如果有count，就说该事件会被重复count次。
    expect_check(#func, #para, #check_func, const void* check_data)

指定某个para将会触发调用check_func函数的事件，该函数的两个参数分别为para和check_data，若检查通过，则返回0。这个在文档中写的不是很明确，我通过测试得出的上述结论。
    expect_in_range(#func, #para, LargestIntegralType min, LargestIntegralType max)
    expect_not_in_range(#func, #para, LargestIntegralType min, LargestIntegralType max)
    expect_in_range_count(#func, #para, LargestIntegralType min, LargestIntegralType max, size_t count)
    expect_not_in_range_count(#func, #para, LargestIntegralType min, LargestIntegralType max, size_t count)
    expect_in_set(#func, #para, LargestIntegralType vals[])
    expect_not_in_set(#func, #para, LargestIntegralType vals[])
    expect_in_set_count(#func, #para, LargestIntegralType vals[], size_t count)
    expect_not_in_set_count(#func, #para, LargestIntegralType vals[], size_t count)
    expect_memory(#func, #para, void* mem, size_t size)
    expect_not_memory(#func, #para, void* mem, size_t size)
    expect_memory_count(#func, #para, void* mem, size_t size, size_t count)
    expect_not_memory_count(#func, #para, void* mem, size_t size, size_t count)
    expect_string(#func, #para, const char* str)
    expect_not_string(#func, #para, const char* str)
    expect_string_count(#func, #para, const char* str, size_t count)
    expect_not_string_count(#func, #para, const char* str, size_t count)
    expect_value(#func, #para, LargestIntegralType val)
    expect_not_value(#func, #para, LargestIntegralType val)
    expect_value_count(#func, #para, LargestIntegralType val, size_t count)
    expect_not_value_count(#func, #para, LargestIntegralType val, size_t count)
上述的这些expect函数基本和assert中的一致，其中expect_value和assert_int_equal类似，这里不再赘述。
2. 返回值断言
    mock()
    mock_ptr_type()
出发返回值事件，其中后者返回指针。
    will_return(#func, LargestIntegralType val)
    will_return_always(#func, LargestIntegralType val)
    will_return_count(#func, LargestIntegralType val, int count)

指定函数的返回事件，可以选择重复count次或者一直返回。


