#include "stdafx.h"
#include "Item25.h"

Item25::Item25() :
  ItemBase("25")
{
}


Item25::~Item25()
{
}


void Item25::ItemEntry()
{
  // 在转给其他函数使用之前，
  // 如果要传右值引用，用move来无条件转为右值以实现移动
  // 如果要传universial reference，因为不一定为左值引用还是右值引用，用forward来根据初始化的情况来转右值或左值再使用

  // 由于RVO（Return Value Optimization）的存在，不要move或forward会用作RVO的局部变量
  // RVO是在要返回局部变量的情况下，为避免拷贝，编译器把要返回的变量直接生成到用于返回的内存位置
  // NRVO (Named Return Value Optimization) 返回未命名的局部变量

}
