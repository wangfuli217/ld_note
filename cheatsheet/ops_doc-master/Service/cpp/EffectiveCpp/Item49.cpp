#include "stdafx.h"
#include "Item49.h"

namespace ITEM49
{
  void OutOfMen()
  {
    cout << "new failed." << endl;
  }
}

void Item49::ItemEntry()
{
  //// Item 49: Understand the behavior of the new-handler
  // new由于内存申请失败时，抛出异常，可以自定义new-handler来处理
  // new会反复调用new-handler以尝试获取内存。所以new-handler必须选择以下方式的一种：
  // 1. 找到可用的内存
  // 2. 如果当前handler无法找到可用的内存，可以尝试set_new_handler让别的handler来尝试。
  // 3. 如果设置null为handler，在new会抛出异常
  // 4. 由handler抛出异常，如bad_alloc或其派生异常类，new不会catch，继续向上抛出
  // 5. 不返回，直接调用abort或exit
  // 用CRTP（curiously recurring template pattern)来为类实现自定义的new和new-handler基类功能。

  // 用如下的new来使用不抛出异常而是返回null的new：
  // Widget *pw2 =new (std::nothrow) Widget;
  // 但注意只保证new操作不抛出异常，Widget的构造函数可能调用普通的new，失败而抛出异常

  std::set_new_handler(ITEM49::OutOfMen);
  int* pBigData = new int[0x7fffffff];
  int* pBigData1 = new int[0x7fffffff];
  int* pBigData2 = new int[0x7fffffff];
  int* pBigData3 = new int[0x7fffffff];
  int* pBigData4 = new int[0x7fffffff];
  int* pBigData5 = new int[0x7fffffff];
  delete pBigData;
  delete pBigData1;
  delete pBigData2;
  delete pBigData3;
  delete pBigData4;
  delete pBigData5;
}
