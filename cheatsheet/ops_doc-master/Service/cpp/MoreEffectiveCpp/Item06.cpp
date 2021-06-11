#include "stdafx.h"
#include "Item06.h"

namespace ITEM06
{
  class MyIncDecOpers
  {
  public:
    MyIncDecOpers(int init) : m_value(init) {};

    MyIncDecOpers& operator++()           // Prefix: ++i
    {
      *this += 1;
      return *this;
    }
    // 为了能重载prefix和postfix，postfix接收int参数，编译器永远传0作为参数
    // 不写行参变量命，以免编译器告警
    // const为了不让连续调用： i++++；
    const MyIncDecOpers operator++(int)   // Postfix: i++
    {
      // 因为产生临时变量，所以效率比prefix低
      const MyIncDecOpers oldValue = *this;
      // 直接调用是为了让prefix和postfix语义一致，只要改prefix就可以
      ++(*this);
      return oldValue;
    }
    MyIncDecOpers& operator--()           // Prefix: --i
    {
      *this -= 1;
      return *this;
    }
    const MyIncDecOpers operator--(int)   // Postfix: i--
    {
      const MyIncDecOpers oldValue = *this;
      --(*this);
      return oldValue;
    }

    // 要实现和int的自增和自减操作
    MyIncDecOpers& operator+=(int inc)
    {
      m_value += inc;
      return *this;
    }
    MyIncDecOpers& operator-=(int inc)
    {
      m_value -= inc;
      return *this;
    }

    int m_value{ 0 };
  };
}

using namespace ITEM06;

void Item06::ItemEntry()
{
  // Item06: Distinguish between prefix and postfix forms of increment and decrement operators.
  MyIncDecOpers i{ 7 };
  cout << "Init value: " << i.m_value << endl;
  cout << "i++ value: " << (i++).m_value << endl;
  cout << "After i++:" << i.m_value << endl;
  cout << "++i value: " << (++i).m_value << endl;
  cout << "After ++i:" << i.m_value << endl;
  cout << "i-- value: " << (i--).m_value << endl;
  cout << "After i--:" << i.m_value << endl;
  cout << "--i value: " << (--i).m_value << endl;
  cout << "After --i:" << i.m_value << endl;
}
