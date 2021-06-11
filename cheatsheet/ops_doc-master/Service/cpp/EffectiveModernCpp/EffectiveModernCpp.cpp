#include "stdafx.h"
#include "Chapter01.h"
#include "Chapter03.h"
#include "Chapter04.h"
#include "Chapter05.h"
#include "Chapter06.h"


int main()
{
////////// Chapter One: Deducing types //////////
  /*
    C++98的type deduction规则：
      - for function templates
    C++11的type deduction规则：
      - for auto
      - for decltype
    C++14对C++11的规则进行扩展
  */
  //Item01().ItemEntry();
  //Item02().ItemEntry();
  //Item03().ItemEntry();
  //TODO Item04().ItemEntry();
  
////////// Chapter Two: auto //////////
  //TODO Item05().ItemEntry();
  //TODO Item06().ItemEntry();

////////// Chapter Three: Moving to Modern C++ //////////
  //TODO Item07().ItemEntry();
  //TODO Item08().ItemEntry();
  //Item09().ItemEntry();
  //TODO Item10().ItemEntry();
  //TODO Item11().ItemEntry();
  //TODO Item12().ItemEntry();
  //TODO Item13().ItemEntry();
  //TODO Item14().ItemEntry();
  //TODO Item15().ItemEntry();
  //TODO Item16().ItemEntry();
  //TODO Item17().ItemEntry();

////////// Chapter Four: Smart pointers //////////

  /*
    C++11的四种智能指针： 
    - auto_ptr
      * Deprecated leftover from C++98. unique_ptr的前身。
    - unique_ptr
      * 默认情况下可以认为和原始指针大小相同，可用在对内存使用有限制的场景。
        默认用delete；如果自定义了deleter，内存消耗会增加。
        增加的大小视deleter函数的内部状态多少而定。
        没有capture的lambda函数会比没有内部状态的函数要节省空间。
      * 非空的unique_ptr“拥有”其指向的对象。
      * move的时候把“拥有权”转让给另一个指针，把自己置为null。
      * copy不允许，否则可能会出现两个unique_ptr同时拥有对象，按各自的情况清理其指向的堆上对象
      * 不能把原始指针直接赋值给unique_ptr，因为无法类型转换。要用reset(new ...)来绑定拥有关系
    - shared_ptr
      * 是原始指针的两倍大小：除了原始指针之外，还有内部的原始指针指向control block
      （control block结构里有reference count）
      * reference count是动态分配的
      * Reference count的增加和减少操作都是原子操作，相对耗时
    - weak_ptr
      * 类似shared_ptr，但是没有“拥有”的概念，可以检查自己是否变成悬空指针
      * weak_ptr和shared_ptr尺寸相同

    有三个make函数：make_unique/make_shared/allocate_shared
    allocate_shared除了make_shared的功能以外，其第一个参数为用于动态内存分配的allocator对象
    make_unique从C++14开始引入，make_shared从C++11开始引入
  */
  //Item18().ItemEntry();
  //Item19().ItemEntry();
  //Item20().ItemEntry();
  //Item21().ItemEntry();
  //Item22().ItemEntry();

////////// Chapter Five: Rvalue References, Move Semantics, and Perfect Forwarding //////////

  /* Move semantics: makes it possible for compilers to replace expensive copying operations
        with less expensive moves.
        拷贝构造函数和拷贝赋值操作用于控制copy
        移动构造函数和移动赋值操作用于控制move
        依赖移动语义实现的move-only type，如unique_ptr，future，thread
     Perfect forwarding: make it possible to write function templates that take arbitrary
          arguments and forward them to other functions such that the target functions
          receive exactly the same arguments as were passed to the forwarding functions.
     rvalue右值是实现这两个功能的基础。
   */
  //Item23().ItemEntry();
  //Item24().ItemEntry();
  //Item25().ItemEntry();
  //TODO Item26().ItemEntry();
  //TODO Item27().ItemEntry();
  //TODO Item28().ItemEntry();
  //TODO Item29().ItemEntry();
  //TODO Item30().ItemEntry();


////////// Chapter Six: Lambda Expressions //////////

  /* Lambda Expression:
     [capture list](parameter list) mutable -> return type {function body}

     适合用lambda的场景：
     * STL的_if算法，如find_if/remove_if/count_if
     * STL的比较函数的算法，如sort/nth_element/lower_bound
     * STL之外，使用lambda快速实现unique_ptr和shared_ptr的deleter

     Closure是lambda创建的运行时对象。closure里有capture数据的拷贝
     Closure class是closure实例对应的类。编译器为每个lambda创建closure class，
        lambda里面的语句是这个类的成员函数。
     可以把lambda语句赋值给auto变量，这个auto变量即为此lambda对应的closure
     同时可以赋值给其他的auto变量，获得多个拷贝。
   */

  //Item31().ItemEntry();
  //Item32().ItemEntry();
  //TODO Item33().ItemEntry();
  //TODO Item34().ItemEntry();
  
////////// Chapter Seven: The Concurrency API //////////

  //TODO Item35().ItemEntry();
  //TODO Item36().ItemEntry();
  //TODO Item37().ItemEntry();
  //TODO Item38().ItemEntry();
  //TODO Item39().ItemEntry();
  //TODO Item40().ItemEntry();
  
////////// Chapter Eight: Tweaks //////////

  //TODO Item41().ItemEntry();
  //TODO Item42().ItemEntry();

  return 0;
}

