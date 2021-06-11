#include "stdafx.h"
#include "Item02.h"

const int Item02::NumTurns; // 特例：定义不能在头文件中

void Item02::ItemEntry()
{
  // Item 2: Prefer consts, enums, and inlines to #defines
  // 把预处理的工作转换为编译器的工作

  // 用const常量替代宏定义，如
  // #define ASPECT_RATIO 1.653
  // 替换为
  // const double AspectRatio = 1.653;
  cout << "static const int class member: " << Item02::NumTurns << endl;

  // 宏定义的函数用inline的函数模板来替换
  cout << "max value of (1,2) is: " << callWithMax(1, 2) << endl;
}
