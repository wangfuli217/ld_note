
#include <iostream>
#include <stdarg.h>
#include "VariadicFunction.h"

using std::cout;
using std::endl;
using std::string;
using std::initializer_list;

// C++中有三种方式实现变参函数

// 方法1: C语言形式实现
// 省略号必须出现在参数列表的末尾，即省略号右边不能再出现确定参数
// 可变参数的个数和类型在运行时确定
// 可变参数宏的实现可能使用动态内存分配，要使用va_end()做清理工作，以免内存泄漏
// 可变参数宏只能顺序访问可变参数，需要往前访问参数时要end后重新start再遍历
void VariFuncCImp(int mandatoryArg, ...)
{
  cout << "----- Variadic Function: C Style Implementation -----" << endl;
  va_list ap;                 //声明一个va_list变量
  va_start(ap, mandatoryArg); //初始化，第二个参数为最后一个确定的形参

  // 期望参数类型为int， string， float
  int intArg = va_arg(ap, int);       //读取可变参数，第二个参数为可变参数的类型
  string strArg = va_arg(ap, string); //读取可变参数，第二个参数为可变参数的类型

  cout << "- intArg: " << intArg << endl;
  cout << "- strArg: " << strArg << endl;

  va_end(ap);           //清理工作 
}

// 方法2: C++11 的initializer list
// 同一个initializer list的类型相同
// initializer list可以在参数的任意位置
void VariFuncInitList(initializer_list<string> strArgs, int extVal)
{
  cout << "----- Variadic Function: C++11 Initializer List -----" << endl;

  for (string cur : strArgs)
  {
    cout << "- strArg: " << cur << " " << endl;
  }
}

// 方法3: 可变参数模板，见头文件
