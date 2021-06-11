#include "stdafx.h"
#include "ClassFeatures.h"
#include <iostream>

using std::cout;
using std::endl;
using std::string;

ClassFeatures::ClassFeatures()
{
    cout << "/!\\ default constructor" << endl;
    this->memStr = string("Default");
}


ClassFeatures::ClassFeatures(const ClassFeatures & cfIns)
{
    cout << "/!\\ copy constructor" << endl;
    this->memStr = cfIns.memStr;
}

ClassFeatures::~ClassFeatures()
{
    cout << "/!\\ destructor" << endl;
}

ClassFeatures & ClassFeatures::operator=(const ClassFeatures & rgtIns)
{
    cout << "/!\\ copy-assignment operator" << endl;
    this->memStr = rgtIns.memStr;
    return *this; // 返回此对象的引用
}

ClassFeatures::ClassFeatures(ClassFeatures && cfIns) noexcept
{
    cout << "/!\\ move constructor" << endl;
    this->memStr = cfIns.memStr;
}

ClassFeatures & ClassFeatures::operator=(ClassFeatures && rgtIns) noexcept
{
    cout << "/!\\ move-assignment operator" << endl;
    // 要处理自己给自己赋值
    if (this != &rgtIns) // 检查this和rgtIns的地址是否相同
    {
        this->memStr = rgtIns.memStr;
    }
    return *this; // 返回此对象的引用
}

void ClassFeatures::displayMem(void)
{
    cout << "Instance members: "
        << "memStr[" << this->memStr << "] "
        << endl;
}

void ClassFeatures::setMem(const string memStrVal)
{
    this->memStr = memStrVal;
}

void testClassFeatures(void)
{
    // 直接初始化
    ClassFeatures cfInsDefault = ClassFeatures();
    cout << "1. ";
    cfInsDefault.displayMem();
    cfInsDefault.setMem("setMem");
    cout << "2. ";
    cfInsDefault.displayMem();

    // 虽然调用了拷贝构造函数，但是使用普通的函数匹配，是直接初始化
    ClassFeatures cfInsCallCopyConst = ClassFeatures(cfInsDefault);
    cout << "3. ";
    cfInsCallCopyConst.displayMem();
    cfInsCallCopyConst.setMem("Changed");
    /*
        拷贝初始化发生在如下情况：
        - 用=直接赋值
        - 将对象作为实参传给非引用类型的形参
        - 返回非引用类型的函数返回对象
        - 用花括号列表初始化数组的元素或聚合类的成员
    */

    // 拷贝初始化
    ClassFeatures cfInsCopyConstruct = cfInsCallCopyConst;
    cout << "4. ";
    cfInsCopyConstruct.displayMem();

    // 拷贝赋值运算符
    cfInsCopyConstruct = cfInsDefault;
    cout << "5. ";
    cfInsCopyConstruct.displayMem();

    /*
        调用析构函数的情况：
        - 变量离开作用域时被销毁
        - 当一个对象被销毁时，其成员被销毁
        - 容器被销毁时，其元素被销毁
        - 动态分配的对象，当指向其的指针应用delete运算符时被销毁
        - 创建临时对象的完整表达式结束时，临时对象被销毁
    */

    /*
        C++ 98/03规范定义：every expression is either an lvalue or an rvalue.
        所以左值和右值是表达式的属性而非对象的属性，不在乎表达式做了什么，而是命名了什么（参考++x和x++的区别）

        左值：lvalues name object that persist beyond a single expression.
              表达式命名生命周期超过单条表达式的对象，如obj, *ptr, ptr[index], ++x
        右值：rvalues are temporaries that evaporate at the end of the full-expression in which they live.
              表达式执行完后结束生命周期的临时变量。如1729, x+y, std::string("neow"), x++
        x++表达式先拷贝x，自增x，然后返回拷贝的临时变量，所以是右值。
        ++x则是自增之后返回x，所以是左值

        分辨的方法：能否获取表达式得到的对象的地址，如可以则为左值。
        因为规范定义取地址操作符"operand shall be an lvalue"。

        对于函数，规范定义"A function call is an lvalue if and only if the result is a reference.
        例：vector<int> v(10,1729);
            v[0]是左值，因为操作符[]()返回int&
        例：string s("foo");
            string t("bar");
            s+t是右值，因为操作符+()返回string

        左值引用 &：不能绑定到要求转换的表达式/字面常量/返回右值的表达式
        右值引用 &&：与左值引用完全相反，只能绑定到右值
        例外：const 左值引用可以用右值初始化
        右值引用的用途为自定义类型实现move语义，
        或实现完美转发perfect forwarding（模板函数向其他函数传递参数时如何保留参数的左右值属性）

        得到右值引用的两种方法：
        - 强制类型转换为右值引用：static_cast<T&&>(t);
        - 从函数返回值得到：T&& func() { return t; }
        注意函数返回值和下面两种写法的区别：
        T& func() { return t; } // 返回左值引用
        T func() { return t; } // 返回右值（临时变量）

        例：
        T& t1 = v;  // t1是类型为引用的变量，指向左值，称为左值引用，t1自身为左值
        T&& t2 = func(); // t2是右值引用，t2自身为左值，因为引用是一个名字，即使绑定到右值，其自身已然是左值
        注意如果t2定义语句里的T为模板参数、auto、decltype等需要推导的类型，
        则t2是universal reference，或forwarding reference，根据reference collapsing
        及右值引用推导原则，t2被左值初始化时为左值引用，被右值初始化时为右值引用。

        std::move()：返回参数对象的右值引用
        std::forward()：返回参数本来对应的类型的引用，配合forwarding reference实现完美转发

    */
    int intVal = 123;
    int &lvalRef1 = intVal;             // 正确，左值引用
    //int &&rvalRef1 = intVal;          // 错误，右值引用不能绑定到左值
    //int &lvalRef2 = intVal * 5;       // 错误，intVal*5是右值，不能绑定到左值引用
    const int &lvalRef3 = intVal * 5;   // 正确，可以将const的左值引用绑定到右值上
    int &&rvalRef2 = intVal * 5;        // 正确，右值引用
    // 左值有持久的状态，右值是字面量或者表达式求值过程中创建的临时对象
    // 右值引用只能绑定到临时对象（该对象将要被销毁，没有其他用户）
    //int &&rvalRef3 = rvalRef2;          // 错误，变量是左值，不能绑定到右值引用s
    int &&rvalRef4 = std::move(rvalRef2); // 正确，move接受一个参数，返回该参数对应的右值引用。用std::move而不是using避免潜在的名字冲突
    //调用move之后，可以对此对象赋值或销毁，但不能再使用其值
    
    // 移动赋值操作
    ClassFeatures cfInsCopy = ClassFeatures();
    cout << "6. " << endl;
    ClassFeatures cfInsMoveOper;
    cfInsMoveOper = cfInsCopy.getSelf();
    // 移动构造函数
    cout << "7. " << endl;
    ClassFeatures cfInsMove2 = ClassFeatures(cfInsCopy.getSelf());
}
