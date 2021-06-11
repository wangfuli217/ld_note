#include "stdafx.h"
#include "Item54.h"

void Item54::ItemEntry()
{
  //// Item 54: Familiarize yourself with the standard library, including TR1
  // TR1 (Technical Report 1)出自C++ library working group.
  // C++标准委员会在把TR1的功能纳入标准之前保留对其修改的权利。
  // 第一版标准ISO/IEC 14882:1998，通称C++98
  // 第二版标准ISO/IEC 14882:2003，通称C++03
  // C++11，先前被称作C++0x，即ISO/IEC 14882:2011

  // C++98标准库的组成：
  // 1. STL (Standard Template Library)：包含container（vector，string，map等）；
  //    iterator；algorithm（find，sort，Transform等）；function obejct（less，greater，等）；
  //    container和function object adapter（stack，priority_queue，mem_fun，not1，等）
  // 2. Iostreams：也支持用户自定义的buffering，internationalized IO，预定义的cin，cout，cerr，clog。
  // 3. Internationalization：支持多个active locales，unicode的wchar_t和wstring。
  // 4. Numeric processing：complex number的模板（complex）和pure value的数组（valarray）。
  // 5. 异常继承解构：exception基类，logic_error和runtime_error派生类等。
  // 6. C89的标准库：C++包含C89标准库

  // TR1增加了14项功能库，位于std::tr1的namespace下。
  // 1. Smart pointer
  // 2. function
  // 3. bind
  // 4. Hash table
  // 5. Regular expression
  // 6. Tuple
  // 7. array
  // 8. mem_fn
  // 9. reference_wrapper
  // 10. Random number generation
  // 11. Mathematical special functions
  // 12. C99 compatibility extensions
  // 13. Type trait
  // 14. result_of
}
