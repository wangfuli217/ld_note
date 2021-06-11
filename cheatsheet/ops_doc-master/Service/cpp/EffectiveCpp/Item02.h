#pragma once

#include "ItemBase.h"

class Item02 : public ItemBase
{
public:
  Item02() : ItemBase("02") { }
  ~Item02() = default;

  void ItemEntry() override;

  static const int NumTurns = 5; // 特例：类的成员如果是static的const的整型（integer，char，bool），则此语句为声明
                                 // 定义在实现文件里，不能放在此头文件中，因为初值在声明时已经给出，定义时不可再给初值
  int scores[NumTurns];   // 如果编译器不允许的话，用“enum hack”来实现，如下：

  enum {EnumNumTurns = 5};  // Enum hack
  int scoresEnum[EnumNumTurns];

};

//#define CALL_WITH_MA(a,b) f((a)>(b) ? (a) : (b))
// 替换为
template <typename T>
inline T callWithMax(const T& a, const T& b)
{
  return (a > b) ? a : b;
}

