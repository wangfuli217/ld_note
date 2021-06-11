#pragma once

#include <string>

/*
    五种特殊的成员函数（拷贝控制操作 copy control）：
    - copy constructor拷贝构造函数：当用同类型的另一个对象初始化本对象时的行为
    - move constructor移动构造函数：同上
    - copy assignment operator拷贝赋值运算符：将一个对象赋予给同类型的另一个对象时，拷贝对象的值
    - move assignment operator移动赋值运算符：同上
    - destructor析构函数：对象销毁时的行为

    // Trivial和non-trivial析构：
    // 如果有显式的析构函数，则为non-trivial；如果有非static的成员为non-trivial，则为non-trivial。
    // 即使定义空的析构，也为non-trivial。
    // 在没有non-trivial成员的情况下，编译器自动生成的析构为trivial。

    如果类没有定义拷贝操作成员，编译器自动定义缺省操作。
    可以在拷贝控制成员的参数列表之后之后添加“= default"来要求编译器生成合成的版本。
    可以用参数列表之后的“=delete”定义拷贝构造函数和拷贝赋值运算，表示不能以任何方式使用他们
    = delete必须出现在函数第一次声明处，以便编译器检查是否有试图调用的操作
    = default在编译器生成代码时才生效。

    如果一个类定义了自己的拷贝构造函数/拷贝赋值运算符或者析构函数，编译器就不会为其
    合成移动构造函数和移动赋值运算符，类会使用对应的拷贝操作来替代移动操作。
    只有当一个类没有定义自己的拷贝控制成员，且每个非static数据成员都可以移动，编译器才会为其
    合成移动构造函数或移动赋值运算符。
    移动操作不能定义为= delete，但如果用= default显式要求编译器合成移动操作，但不能移动所有成员
    则编译器会将移动操作定义为= delete。

    C++98/03有rule of three：如果类定义了析构函数/拷贝构造函数/拷贝赋值构造函数之一，则要明确定义全部三个函数
    C++11变为rule of five
*/

class ClassFeatures
{
public:
    // 默认构造函数
    // 构造函数初始化对象的非static数据成员
    ClassFeatures();

    // 拷贝构造函数： 第一个参数是自身类型的引用，且任何额外参数都有默认值
    // 如不自定义，编译器会生成合成拷贝构造函数(synthesized copy constructor)，
    // 一般情况下，合成拷贝构造函数逐个拷贝对象的成员，类类型的成员调用其拷贝构造函数来拷贝，
    // 数组的元素逐个拷贝。
    // 参数是引用。因为非引用的形参在实参传递时需要调用拷贝构造函数，
    // 如果拷贝构造函数的形参为非引用，就会无限循环调用自己
    ClassFeatures(const ClassFeatures& cfIns); // 参数可以非const，但一般都是。通常不是explicit。
    // 合成拷贝构造函数相当于 ClassFeatures(const ClassFeatures &cfIns) : mem1(cfIns.mem1), mem2(cfIns.mem2){}
    // 使能下面代码，阻止拷贝构造函数
    //ClassFeatures(const ClassFeatures &cfIns) = delete;

    // 重载赋值运算符，实现拷贝赋值运算符，定义how an object is passed by value.
    // 如不自定义，编译器会生成合成拷贝赋值运算符(synthesized copy-assignment operator)
    ClassFeatures & operator=(const ClassFeatures& rgtIns); // 赋值运算符通常返回指向左侧运算对象的引用
    // 合成拷贝构造函数相当于 ClassFeatures & operator=(const ClassFeatures &rgtIns) { mem1 = rgtIns.mem1; mem2 = rgtIns.mem2; return *this; }
    // 注意obj1 = obj2;使用了拷贝赋值运算符，而Object obj1 = obj2;使用了拷贝构造函数。
    // 规则为：但有新对象创建时会调用拷贝构造函数，否则只是拷贝赋值

    // 移动构造函数
    ClassFeatures(ClassFeatures&& cfIns) noexcept; // 移动操作不应抛出任何异常

    // 移动赋值运算符
    ClassFeatures& operator=(ClassFeatures&& rgtIns) noexcept;

    // 析构函数
    // 释放对象使用的资源，销毁对象的非static数据成员(此操作在析构函数执行完后，隐含的析构阶段执行）
    // 没有返回值，不接受参数
    // 没有参数所以不能被重载
    // 如不定义，编译器会生成合成析构函数(synthesized destructor)
    // 析构函数可以= delete，但不能再定义该类型的变量或释放指向该类型动态分配对象的指针
    ~ClassFeatures();

    // 普通成员函数也可以同时提供拷贝和移动的版本
    void funcCopyOrMove(const ClassFeatures& cfIns) {} // 拷贝版本
    void funcCopyOrMove(ClassFeatures&& cfIns) {} // 移动版本

    // 使用引用限定符reference qualifier声明 左值引用函数 和 右值引用函数
    // 和const限定符一样，引用限定符只能用于非static成员函数，且必须同时现在声明和定义中
    // 同时使用const和引用限定符时，引用限定符必须出现在const之后
    ClassFeatures lvalueFunc(void) & { return *this; }  // 左值引用函数
    ClassFeatures lvalueFunc(void) && { return *this; } // 右值引用函数
    
    // 辅助函数
    void displayMem(void);
    void setMem(const std::string memStrVal);
    ClassFeatures getSelf(void) { return *this; };

private:
    std::string memStr;
};

void testClassFeatures(void);
