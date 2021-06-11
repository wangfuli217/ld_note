#include "stdafx.h"
#include "Item32.h"
#include <memory>
#include <functional>

using std::make_unique;
using std::bind;

#include "Item01.h"

Item32::Item32() :
  ItemBase("32")
{
}


Item32::~Item32()
{
}


void Item32::ItemEntry()
{
  // C++11不支持把对象move进closure，C++14提供init capture以支持move及其他新功能，
  // 也叫做generalized lambda capture，意为C++11的capture的generalized模式。
  // 使用init capture可以指定：
  // * The name of a data member in the closure class generated from the lambda and
  // * an expression initializing that data member.

  auto pUnqInt = make_unique<int>(123);
  auto lambdaInitCap = [pUnqInt = std::move(pUnqInt)]{ return *pUnqInt; };
  // 等号左边的pUnqInt作用域为closure类内部，等号右边的pUnqInt作用域为定义lambda表达式的语句所在作用域
  // 等号左边的pUnqInt即为closure class的data member

  // 也可以直接用make_unique，即为an expression initializing that data member
  auto lambdaInitCap2 = [pUnqInt = std::make_unique<int>(321)]{ return *pUnqInt; };

  // C++11里可以自己实现和lambda的closure class原理一样的类（代码见书），
  // 或用bind模拟
  vector<int> data{ 1,2,3 };
  // C++14
  auto lambdaInitCapVec = [data = std::move(data)]{};
  // C++11
  auto bindVec = bind(
    [](const std::vector<int>& data){},
    std::move(data)
  );  

  // C++11，模拟make_unique



}
