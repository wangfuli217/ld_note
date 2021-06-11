#pragma once

#include <iostream>

class ClassBase
{
public:
  /*
  ���������������ڶ�̬��ʱ�������ָ�뱻����ʱ�ܵ������������
  ���Դ������£����virtual����ֻ�ܵ��õ����������
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
