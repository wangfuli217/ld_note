#include "stdafx.h"
#include "Item31.h"

Item31::Item31() :
  ItemBase("31")
{
}


Item31::~Item31()
{
}


void Item31::ItemEntry()
{
  // Lambda默认捕获模式为引用捕获(by-reference)和值捕获(by-value)

  {
    int i = 123;
    int j = 456;
    int divisor = i / j;

    // 使用默认的引用捕获，捕获局部变量divisor，如果此lambda对象被保存到当前作用域以外
    // 的变量中，再此作用域外调用时，divisor即为dangle的引用
    auto lambdaMayDangle = [&](int value) { return value % divisor == 0; };

    // 稍好一些的写法，显示指定divisor局部变量是引用捕获的，有一定的提醒作用
    // 但在拷贝整个lambda到别处使用时，仍然有dangle的隐患
    auto lambdaStillMayDangle = [&divisor](int value) { return value % divisor == 0; };

    // 值捕获能起到一定作用
    // 但如果值捕获的是指针，指针指向的内容可能在某处被释放，导致lambda里的指针dangle
    auto lambdaAgainDangle = [=](int value) { return value % divisor == 0; };

    // 值捕获成员变量时是捕获的this->成员变量，所以this也被拷贝进了lambda
    // 如果this对应的对象被销毁了，lambda里的this即为dangle
    // 解决方案是显示地创建局部变量，拷贝成员变量，然后再用此局部变量来做值捕获
    // C++14提供了generalized lambda capture，如下，保证把成员变量值捕获进lambda而不带this
    // 详情参考Item32
    auto lambdaCpp14 = [divisor = divisor](int value) { return value % divisor == 0; };

    // 注意如果divisor在作用域里是static的，那么其实并没有值捕获divisor，
    // 而是以引用方式（不是引用捕获！）在使用static的divisor。
    // 这种情况下的lambda并不是self-contained的。
  }
}
