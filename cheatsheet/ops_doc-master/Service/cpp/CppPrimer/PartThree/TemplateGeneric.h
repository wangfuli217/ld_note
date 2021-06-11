#pragma once
#include <iostream>
#include <memory>
#include <vector>
#include <initializer_list>
#include <string>

/*
    类模板class template
    编译器不能为类模板推断参数类型，使用类模板时必须在模板名后用<>提供额外信息。
    早期没有typename关键字时，用template <class T>
*/
template <typename T>
class ClassTemplate
{
public:
    typedef T value_type;
    // 编译器默认类模板情况下，作用域运算符访问的是名字而不是类型
    // 用typename显式告诉编译器，std::vector<T>::size_type是类型，不是叫size_type的成员
    typedef typename std::vector<T>::size_type size_type;

    // 构造函数
    ClassTemplate();
    ClassTemplate(std::initializer_list<T> initList);
    ~ClassTemplate();
    // 元素数目
    size_type size() const { return data->size(); }
    bool empty() const { return data->empty(); }
    // 添加元素
    void push_back(const T &t) { data->push_back(t); }
    // 移动版本
    void push_back(T &&t) { data->push_back(std::move(t)); }
    // 删除版本
    void pop_back();
    // 元素访问
    T& back();
    T& operator[](size_type i);
    // 在类内部使用模板类时，可以直接使用类名而不提供实参
    // 在类外部使用模板类时，必须提供实参，但在出现带实参类名之后的作用域里，可以不提供实参
    ClassTemplate& operator++() { std::cout << "++ called." << std::endl; return (*this); }
    ClassTemplate<T>& operator--() { std::cout << "-- called." << std::endl; return (*this); }
    // 静态成员针存在于每种<T>的实参对应的类实例中
    static std::string staticStr;

private:
    std::shared_ptr<std::vector<T>> data;
    // 检查data[i]是否有效，无效时抛出msg
    void check(size_type i, const std::string &msg) const;
};

// C++11: 为类模板定义别名
template<typename T> using templateClassAlias = ClassTemplate<T>;

// 静态类成员初始化
template<typename T>
std::string ClassTemplate<T>::staticStr = std::string("DEFAULT");

// 类模板的成员函数是函数模板
template<typename T>
inline ClassTemplate<T>::ClassTemplate()
{
    data = std::make_shared<std::vector<T>>();
}

template<typename T>
inline ClassTemplate<T>::ClassTemplate(std::initializer_list<T> initList)
{
    data = std::make_shared<std::vector<T>>(initList);
}

template<typename T>
inline ClassTemplate<T>::~ClassTemplate()
{
}

template<typename T>
inline void ClassTemplate<T>::pop_back()
{
    check(0, "pop_back on empty ClassTemplate");
    data->pop_back();
}

template<typename T>
inline T & ClassTemplate<T>::back()
{
    check(0, "back on empty ClassTemplate")；
    return data->back();
}

template<typename T>
inline T & ClassTemplate<T>::operator[](size_type i)
{
    check(i, "Out of range!");
    return (*data)[i];
}

template<typename T>
void ClassTemplate<T>::check(size_type i, const std::string & msg) const
{
    if (i >= data->size())
    { throw std::out_of_range(msg); }
}


// 函数模板和类模板成员函数的定义一般放在头文件中
// 因为编译器要知道函数模板定义，才能在实例化的代码处生成实例化版本

// 函数模板function template
// 相当于一个公式，可用来生成针对特定类型的版本
// 模板定义以关键字template起始，后跟逗号分隔的模板参数列表template parameter list
// 模板参数列表不能为空。
// 类型参数type parameter前必须有typename或class（没有区别）。
// 非类型参数nontype parameter表示值，用特定的类型名来指定。
// 在使用模板时，显式或隐式地指定模板实参template argument，绑定到模板参数上。

// 函数模板可以被另一个模板或非模板函数重载
// 如果多个模板函数都能精确匹配，则选择最特例化（最不通用）的版本
// 如果模板函数和非模板函数都能精确匹配，则选择非模板函数（比模板函数特例化）

// 类型参数
template <typename T>
T ftCompare(const T &val1, const T &val2)
{
    // T可以作为参数类型、变量类型、返回值类型
    T const * pVal = &val1;
    if (val1 < val2)
    {
        return T(-1);
    }
    else if (val1 > val2)
    {
        return T(1);
    }
    else
    {
        return T(0);
    }
}

// 非类型参数
// 可以是整型，指向对象或函数类型的指针，或左值引用
// 绑定到非类型整型参数的实参由用户提供或编译器推断，必须是常量表达式
// 绑定到指针或引用的非类型参数的实参必须具有静态生存期
// 绑定到指针的非类型参数实参可以用nullptr或值为0的常量表达式来实例化
template <unsigned N, unsigned M>
int ftCompare(const char(&pCharAry1)[N], const char(&pCharAry2)[M])
{
    return strcmp(pCharAry1, pCharAry2);
}

// 函数模板可以声明为inline或constexpr
// inline和constexpr关键字放在模板参数列表之后
template <typename T>
inline constexpr T ftInlineConstexprDouble(const T &val)
{
    return val * 2;
}

// 函数和类模板的默认模板实参default template argument
template <typename T>
class CTPrint
{
public:
    CTPrint() = default;
    void operator()(T t) { std::cout << "CTPrint(" << t << ")" << std::endl; }
};

template <typename T = int> // 类模板默认模板实参
class CTPrintAnother
{
public:
    CTPrintAnother() = default;
    void operator()(T t) { std::cout << "CTPrintAnother(" << t << ")" << std::endl; }
};

template <typename T, typename F = CTPrint<T>> // 函数模板默认模板实参
void ftDefaultArg(const T &t, F f = F())
{
    std::cout << "ftDefaultArg(" << t << ")" << std::endl;
    f(t);
}

// 包含函数模板的普通类
class ClassNormalWithFuncTemplate
{
public:
    ClassNormalWithFuncTemplate() = default;
    // 函数模板
    template <typename T>
    void funcTemplate(const T &t) const;
};

// 函数模板在外部定义
template<typename T>
void ClassNormalWithFuncTemplate::funcTemplate(const T & t) const
{
    std::cout << "ClassNormalWithFuncTemplate(" << t << ")" << std::endl;
}

// 包含函数模板的类模板
template <typename T>
class ClassTemplateWithFuncTemplate
{
public:
    ClassTemplateWithFuncTemplate() = default;
    // 函数模板
    template <typename FT>
    void funcTemplate(const FT &ft, const T &t);
};

// 函数模板在外部定义
template<typename T> // 类模板的类型参数
template<typename FT> // 函数模板的类型参数
inline void ClassTemplateWithFuncTemplate<T>::funcTemplate(const FT & ft, const T & t)
{
    std::cout << "ClassTemplateWithFuncTemplate(" << ft << ", " << t << ")" << std::endl;
}

// 显式模板实参explicit template argument
// 编译器无法推断出模板实参的类型时，显式指定
// 如函数模板的T1
// 显式模板实参按照对应的模板参数从左往右匹配，尽量把不能推断的放模板参数列表的坐标
template <typename T1, typename T2, typename T3>
T1 ftExplicitTempArg(const T2 &val1, const T3 &val2)
{
    std::cout << "ftExplicitTempArg(" << val1 << ", " << val2 << ")" << std::endl;
    return val1 * val2;
}

// 尾置返回类型
// 此函数接受一对迭代器作为参数，返回迭代器指向的元素
// 在编译器遇到参数列表之前，beg和end都是不存在的，所以不能用decltype(*beg)来获得返回类型
// 尾置返回类型在参数列表之后，可以使用beg
template<typename Iterator>
auto ftRtnElement(Iterator beg, Iterator end) -> decltype(*beg)
// 或使用标准库的类型转换type transformation模板（头文件type_traits），如下
// auto ftRtnElement(Iterator beg, Iterator end) -> typename remove_reference<decltype(*beg)>::type
{ return *beg; }

// 定义函数模板特例化template specialization
// 通用函数模板
template <typename T>
void ftGeneral(const T &val1, const T &val2)
{
    std::cout << "General function template. val1: " << val1 << " val2: " << val2 << std::endl;
}

// 特例化函数模板，本质上是实例化模板而非重载模板
// 注意：特例化的模板相当于一个函数，如果在头文件里实现，多个源文件包含头文件时就会重复定义
// 解决方案为：
// - 在头文件里定义并inline（看编译器是否真正inline）
// - 在头文件里定义并static，限制文件作用域
// - 在使用的源文件里实现
template <> // 空尖括号表示为原模板提供所有模板实参
inline void ftGeneral(const double &val1, const double &val2)
{
    std::cout << "Specialization function template. val1: " << val1 << " val2: " << val2 << std::endl;
}

// 通用类模板
template <typename T>
class ctGeneral
{
public:
    ctGeneral() { std::cout << "General class." << std::endl; }
    ~ctGeneral() = default;
    void disp(void) { std::cout << "General disp." << std::endl; }
};

// 完全特例化类模板
template <> // 尖括号表示特例化
class ctGeneral<double> // 指定特例化的模板参数
{
public:
    ctGeneral() { std::cout << "Full special class." << std::endl; }
    ~ctGeneral() = default;
    void disp(void) { std::cout << "Full special disp." << std::endl; }
};

// 部分特例化类模板。只有类模板可以部分特例化。
template <typename T>
class ctGeneral<T&>
{
public:
    ctGeneral() { std::cout << "Partial special class: lvalue." << std::endl; }
    ~ctGeneral() = default;
    void disp(void) { std::cout << "Partial special lvalue disp." << std::endl; }
};
template <typename T> 
class ctGeneral<T&&>
{
public:
    ctGeneral() { std::cout << "Partial special class: rvalue." << std::endl; }
    ~ctGeneral() = default;
    void disp(void) { std::cout << "Partial special rvalue disp." << std::endl; }
};

// 特例化模板类成员
template <>
void ctGeneral<std::string>::disp(void) { std::cout << "Special disp." << std::endl; }



void testTemplateGeneric(void);

