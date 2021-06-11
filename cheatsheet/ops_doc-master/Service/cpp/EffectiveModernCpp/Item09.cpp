#include "stdafx.h"
#include "Item09.h"
#include <memory>
#include <vector>
#include <list>
#include <functional>


Item09::Item09() :
  ItemBase("09")
{
}


Item09::~Item09()
{
}


// C++98风格typedef
typedef std::unique_ptr<std::vector<std::string, std::string>> UPtrVecSS;
typedef void(*FuncPtr)(int, const std::string&);

// C++11风格alias declaration
using UPtrVecSS = std::unique_ptr<std::vector<std::string, std::string>>;
using FuncPtr = void(*)(int, const std::string&);

// Alias的优点为支持模板：alias template
template<typename T>
using MyAllocList = std::list<T>;


void Item09::ItemEntry()
{
  // Type trait: 在头文件<type_traits>里定义的一组模板
  // std::remove_const<T>::type           // 从const T产生T
  // std::remove_reference<T>::type       // 从T&和T&&产生T
  // std::add_lvalue_reference<T>::type   // 从T产生T&
  // 这些是C++11用嵌套的typedef定义的
  // C++14用alias template重新实现为：
  // std::remove_const_t<T>
  // std::remove_reference_t<T>
  // std::add_lvalue_reference_t<T>


}
