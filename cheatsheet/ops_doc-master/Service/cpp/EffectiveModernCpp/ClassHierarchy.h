#pragma once

#include <iostream>

class ClassBase
{
public:
  /*
  虚析构函数：用于动态绑定时，基类的指针被析构时能调用子类的析构
  测试代码如下，如非virtual，则只能调用到基类的析构
  ClassBase *pClassBase = new ClassDerived1();
  delete pClassBase;
  */
  virtual ~ClassBase()
  {
    std::cout << "~ClassBase()" << std::endl;
  }
};

class ClassDerived1 : public ClassBase
{
public:
  virtual ~ClassDerived1()override
  {
    std::cout << "~ClassDerived1()" << std::endl;
  }
};

class ClassDerived2 : public ClassBase
{
public:
  virtual ~ClassDerived2() override
  {
    std::cout << "~ClassDerived2()" << std::endl;
  }
};
