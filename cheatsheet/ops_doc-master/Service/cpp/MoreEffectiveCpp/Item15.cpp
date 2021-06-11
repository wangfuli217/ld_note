#include "stdafx.h"
#include "Item15.h"

void Item15::ItemEntry()
{
  // Item15: Understand the costs of exceptioni handling.
  // 使用异常机制的代价：
  // 1. 即使不使用异常处理功能，也会需要消耗空间存储用来跟踪已经完全构造好的对象的数据结构,
  //    以及用于更新这些数据结构的时间。（有些编译器可以关闭异常处理机制以产生更快更小的代码，但
  //    随着越来越多库使用异常，这类开关意义不大。）
  // 2. try语句块不同编译器有不同实现，仅仅是try语句块就会导致5~10%的代码增量和运行时间增量。
  //    尽量避免不需要的try。
  // 3. Excpetion specification语法也会导致类似try语句块的代价。
  // 4. Exception语句块的代价虽然在80-20原理下应该对程序的整体性能影响不大，
  //    但其绝对运行速度与同等的函数相比大约慢三个数量级。
}
