#include "stdafx.h"
#include "Item48.h"

void Item48::ItemEntry()
{
  //// Item 48: Be aware of template metaprogramming
  // Template MetaProgramming (TMP): 编写基于模板的C++程序，执行于编译期。
  // 相当于template metaprogram是用c++编写但由编译器执行的程序，执行的输出为模板的实例，进行常规编译。
  // 比如用typeid判断类型是在运行期执行的编程方式，用Item47的trait则在编译器完成判断。

  // TMP被证明是图灵完备的（Turing-complete），即任何可计算的问题都可被解决。
  // 如循环可用递归模板实例化来实现。

  // 比较好的TMP实践：
  // 1. Ensuring dimensional unit correctness. 保证各种计算的组合是正确有意义的。
  // 2. Optimizing matrix operations. 使用expression template加速运算，但保持表达式的形式不变。
  // 3. Generating custom design pattern implementations. 使用policy-based design实现，称为generative programming。
}
