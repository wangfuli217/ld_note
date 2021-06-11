#include "stdafx.h"
#include "Item25.h"

///////////////////////////////////////

namespace TestDefaultSwap
{
  class SwapTester
  {
  public:
    SwapTester(int& val) : m_ptr(&val) {};
    // 支持拷贝构造和拷贝赋值的类，std::swap就可以对其进行操作

    SwapTester& operator=(const SwapTester& rhs)
    {
      cout << "CopyOper" << endl;
      *(this->m_ptr) = *(rhs.m_ptr);
      return *this;
    }

  private:
    int* m_ptr{ nullptr }; // 可能为指向大型数据结构的指针
  };
}

///////////////////////////////////////

namespace TestExtendSwap
{
  class SwapTester
  {
  public:
    SwapTester(int& val) : m_ptr(&val) {};

    SwapTester& operator=(const SwapTester& rhs)
    {
      cout << "CopyOper" << endl;
      *(this->m_ptr) = *(rhs.m_ptr);
      return *this;
    }

    void swap(SwapTester& another) // 定义swap函数实现只交换指针值的pimpl
    {
      using std::swap;
      swap(this->m_ptr, another.m_ptr);
    }

  private:
    int* m_ptr{ nullptr };
  };
}

// 不能改变std的swap模板函数，但可以指定自定义的模板函数实例
namespace std
{
  template<> // 不指定T表示这是模板函数的实例
  void swap<TestExtendSwap::SwapTester>(TestExtendSwap::SwapTester& lhs, TestExtendSwap::SwapTester& rhs)
  {
    cout << "std::swap<TestExtendSwap::SwapTester>" << endl;
    lhs.swap(rhs); // 不能直接访问私有成员，使用类提供swap函数
  }
}

///////////////////////////////////////

namespace TestExtendTemplateSwap
{
  template <typename T> // 改为模板类
  class SwapTester
  {
  public:
    SwapTester(int& val) : m_ptr(&val) {};

    SwapTester& operator=(const SwapTester& rhs)
    {
      cout << "CopyOper" << endl;
      *(this->m_ptr) = *(rhs.m_ptr);
      return *this;
    }

    void swap(SwapTester& another)
    {
      using std::swap;
      swap(this->m_ptr, another.m_ptr);
    }

  private:
    int* m_ptr{ nullptr };
  };

  // 在命名空间内定义非成员函数来swap
  template<typename T>
  void swap(TestExtendTemplateSwap::SwapTester<T>& lhs, TestExtendTemplateSwap::SwapTester<T>& rhs)
  {
    cout << "TestExtendTemplateSwap::swap" << endl;
    lhs.swap(rhs);
  }
}

namespace std
{

#if ILLEGAL
  // 部分实例化模板函数非法
  template<typename T>
  void swap<TestExtendTemplateSwap::SwapTester<T>>(TestExtendTemplateSwap::SwapTester<T>& lhs, TestExtendTemplateSwap::SwapTester<T>& rhs)
  {
    cout << "std::swap<TestExtendSwap::SwapTester>" << endl;
    lhs.swap(rhs);
  }
#endif

#if NOTSUGGESTED
  // 重载swap函数而非实例化可行，但不建议向std命名空间添加新成员
  template<typename T>
  void swap(TestExtendTemplateSwap::SwapTester<T>& lhs, TestExtendTemplateSwap::SwapTester<T>& rhs)
  {
    cout << "std::swap<TestExtendSwap::SwapTester>" << endl;
    lhs.swap(rhs);
  }
#endif
}


void Item25::ItemEntry()
{
  //// Item 25: Consider support for a non-throwing swap
  // 最直观的交换两个值的方法是使用中间变量进行三次赋值。

  // 如果是指针，可以只交换指针值，而不是拷贝指针指向的对象。
  // pimpl idiom (Pointer to implementation)
  // 此时可以创建swap模板的实例,如本文件中的代码

  int value1 = 1;
  int value2 = 2;

  // 使用std的默认swap，调用拷贝构造函数或拷贝赋值操作符
  cout << endl << "==========Test Default Swap" << endl;
  TestDefaultSwap::SwapTester defaultTester1{value1};
  TestDefaultSwap::SwapTester defaultTester2{value2};
  cout << "----Gonna Swap" << endl;
  std::swap(defaultTester1, defaultTester2);

  // 自定义std的swap的模板函数实例来交换
  cout << endl << "==========Test Extend Swap" << endl;
  TestExtendSwap::SwapTester extendTester1{ value1 };
  TestExtendSwap::SwapTester extendTester2{ value2 };
  cout << "----Gonna Swap" << endl;
  std::swap(extendTester1, extendTester2);
  

}

