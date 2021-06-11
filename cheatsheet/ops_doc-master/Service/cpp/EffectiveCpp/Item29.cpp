#include "stdafx.h"
#include "Item29.h"

void Item29::ItemEntry()
{
  //// Item 29: Strive for exception-safe code.
  // 异常抛出的时候，exception-safe的函数应该：
  // 1. Leak no resources. 不能由于异常抛出而无法执行delete等清理资源的语句。
  // 2. Don't allow data structures to become corrupted. 不能由于抛出异常而是成员变量的值处于非法状态。
  // Exception-safe函数提供三个级别的保障，如果三个级别都不符合，就不是exception-safe：
  // 1. The basic guarantee：程序内部数据依然正确且一致，但用户无法估计异常发生后程序为了保证数据一致性所采取的行为。如程序可能用默认值，或上一次可用的值。
  // 2. The strong guarantee：异常发生是程序内部状态不变。如原子操作，由于异常而不成功时不改变任何状态。
  // 3. The nothrow guarantee：保证正确执行操作，不抛出异常。
  // 实现strong guarantee的解决方案通常为copy and swap，即先拷贝一份需要改变的对象，改变拷贝得到的对象，如果成功，则swap改变后的拷贝对象和原对象。
  // 实现上往往用pimpl idiom，把实际数据单独放在一个类里，要被修改的类用指针成员变量指向实际数据类。修改对象的时候先拷贝一个数据对象，得到其指针，修改完值后和原指针交换指针值。
  // 如果copy的开销很大时，要用copy-and-swap做到strong guarantee可能不切实际。
}
