#include "stdafx.h"
#include "Item20.h"
#include <memory>

using std::cout;
using std::endl;
using std::shared_ptr;
using std::weak_ptr;
using std::make_shared;


Item20::Item20() :
  ItemBase("20")
{
}


Item20::~Item20()
{
}


void Item20::ItemEntry()
{
  cout << ">> Test weak_ptr expire" << endl;

  shared_ptr<int> sptr = make_shared<int>(123); // Reference count为1
  cout << "*sptr: " << *sptr << endl;
  weak_ptr<int> wptr(sptr); // wptr指向sptr所指向的对象
  cout << "When reference count is 1: " << wptr.expired() << endl; // 是否悬挂dangle

  // weak_ptr不能解引用，所以无法得到其指向的值
  // 即使能解引用，先用expire检查再解引用，这两个分离的步骤会导致race condition
  // 要借助shared_ptr来解引用
  {
    shared_ptr<int> sptrFromWptr = wptr.lock(); // 如果wptr已经expire了，sptrFromWptr为null
    cout << "sptrFromWptr: " << *sptrFromWptr << endl;
    auto autoFromWptr = wptr.lock(); // auto同shared_ptr
    cout << "autoFromWptr: " << *autoFromWptr << endl;
    shared_ptr<int> aptrByWptr(wptr); //如果wptr已经expire，抛出异常
    cout << "aptrByWptr: " << *aptrByWptr << endl;
  }


  sptr = nullptr; // Reference count为0
  cout << "When reference count is 0: " << wptr.expired() << endl; // 是否悬挂dangle

  {
    shared_ptr<int> sptrFromWptr = wptr.lock();
    // sptrFromWptr应该为null
    if (sptrFromWptr == nullptr)
    {
      cout << "sptrFromWptr is null." << endl;
    }
    else
    {
      cout << "!!!!!sptrFromWptr should be null!!!!!" << endl;
    }

    auto autoFromWptr = wptr.lock();
    // sptrFromWptr应该为null
    if (autoFromWptr == nullptr)
    {
      cout << "autoFromWptr is null." << endl;
    }
    else
    {
      cout << "!!!!!autoFromWptr should be null!!!!!" << endl;
    }

    // 应该抛出异常
    try
    {
      shared_ptr<int> aptrByWptr(wptr);
      cout << "!!!!!Should throw exception!!!!!" << endl;
    }
    catch (const std::bad_weak_ptr&)
    {
      cout << "autoFromWptr generates exception." << endl;
    }

    // weak_ptr在control block里也有weak count
    // （但由于优化的原因，并不总是等于weak_ptr的个数）
    // 还有weak_ptr存在的话，即使没有shared_ptr指向了，
    // 被指向的对象和control block的空间也不会被释放。
    
  }
}
