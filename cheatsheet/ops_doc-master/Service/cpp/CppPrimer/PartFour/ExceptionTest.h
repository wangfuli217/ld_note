#pragma once
#include <string>

class ExceptionTest
{
public:
    // 构造函数处理初始值时抛出的异常，因为还没进入构造函数内
    // 必须将构造函数写成函数try语句块
    ExceptionTest(std::string init) try : memStr(init) {/*构造函数体*/}
    catch (...) {/*异常处理*/};

    ~ExceptionTest() = default;

    // C++11：noexcept关键字是noexcept specification，
    // 表示对此函数作出了不抛出说明nonthrowing specification
    // noexcept必须出现在函数所有声明语句和定义语句中
    // 出现在尾置返回类型之前
    // 在成员函数中，要跟在const及引用限定符之后，在final、override、虚函数的=0之前
    // 函数指针和定义中也可以指定noexcept
    // 在typedef或类型别名中不能出现noexcept
    // 编译器不在编译期验证是否真的不抛出异常，运行时如果抛出异常，则调用terminate
    // noexcept说明符接受bool型的参数，true值表示不会抛出异常，false表示会抛出异常
    void noexception(void) noexcept(true) {}
    // 可以用同名的noexcept运算符检查函数声明时是否使用了noexcept说明符。
    // 如下函数定义中，外层noexcept是说明符，内层noexcept是运算符
    void noexceptionAnoth(void) noexcept(noexcept(noexception())) {}
    // noexcept的函数指针只能指向不抛出异常的函数，普通函数指针可以指向任何函数，包括不抛出异常的函数
    // 如果虚函数承诺不抛出异常，其派生出来的虚函数也必须有同样的承诺
    // 未承诺不抛出异常的虚函数，其派生出来的虚函数可以承诺不抛出异常

private:
    std::string memStr;
};

void exceptionTest(void);
