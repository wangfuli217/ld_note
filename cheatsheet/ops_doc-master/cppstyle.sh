第一章 头文件
style(头文件){
  通常每一个 .cc 文件都有一个对应的 .h 文件. 也有一些常见例外, 如单元测试代码和只包含 main() 
函数的 .cc 文件.
  正确使用头文件可令代码在可读性、文件大小和性能上大为改观.
}

style(Self-contained 头文件){
  a. 头文件应该能够自给自足（self-contained,也就是可以作为第一个头文件被引入），以 .h 结尾。
  b. 至于用来插入文本的文件，说到底它们并不是头文件，所以应以 .inc 结尾。
     不允许分离出 -inl.h 头文件的做法.

  不过有一个例外，即一个文件并不是 self-contained 的，而是作为文本插入到代码某处。或者，
文件内容实际上是其它头文件的特定平台（platform-specific）扩展部分。这些文件就要用 .inc 文件扩展名。
   redis的ae_evport.c、ae_epoll.c、ae_kqueue.c、ae_select.c最好为.inc文件扩展名。
   
   如果 .h 文件声明了一个模板或内联函数，同时也在该文件加以定义。凡是有用到这些的 .cc 文件，
就得统统包含该头文件，否则程序可能会在构建中链接失败。不要把这些定义放到分离的 -inl.h 文件里。
}
style(define 保护){
  所有头文件都应该使用 #define 来防止头文件被多重包含, 命名格式当是: 
<PROJECT>_<PATH>_<FILE>_H_ .

  为保证唯一性, 头文件的命名应该基于所在项目源代码树的全路径. 例如, 项目 foo 中的头文件 
foo/src/bar/baz.h 可按如下方式保护:
#ifndef FOO_BAR_BAZ_H_
#define FOO_BAR_BAZ_H_
...
#endif // FOO_BAR_BAZ_H_
}
style(前置声明){
  尽可能地避免使用前置声明。使用 #include 包含需要的头文件即可。
定义：
  所谓「前置声明」（forward declaration）是类、函数和模板的纯粹声明，没伴随着其定义.
    // b.h:
    struct B {};
    struct D : B {}
    
    // good_user.cc:
    #include "b.h"
    void f(B*);
    void f(void*);
    void test(D* x) { f(x); }  // calls f(B*)
  如果 #include 被 B 和 D 的前置声明替代， test() 就会调用 f(void*) .
  前置声明了不少来自头文件的 symbol 时，就会比单单一行的 include 冗长。
  仅仅为了能前置声明而重构代码（比如用指针成员代替对象成员）会使代码变得更慢更复杂.
  
结论：
  尽量避免前置声明那些定义在其他项目中的实体.
  函数：总是使用 #include.
  类模板：优先使用 #include.
}
style(内联函数){
只有当函数只有 10 行甚至更少时才将其定义为内联函数.
定义:
  当函数被声明为内联函数之后, 编译器会将其内联展开, 而不是按通常的函数调用机制进行调用.
结论:
  a. 一个较为合理的经验准则是, 不要内联超过 10 行的函数. 谨慎对待析构函数, 析构函数往往比其表面
     看起来要更长, 因为有隐含的成员和基类析构函数被调用!
  b. 另一个实用的经验准则: 内联那些包含循环或 switch 语句的函数常常是得不偿失 (除非在大多数情况下, 
     这些循环或 switch 语句从不被执行).
  c. 有些函数即使声明为内联的也不一定会被编译器内联, 这点很重要。
}
style(include 的路径及顺序){
  使用标准的头文件包含顺序可增强可读性, 避免隐藏依赖: 
1.相关头文件, 2.C 库, 3.C++ 库, 4.其他库的 .h, 5.本项目内的 .h.

  项目内头文件应按照项目源代码目录树结构排列, 避免使用 UNIX 特殊的快捷目录 . (当前目录) 或 .. (上级目录). 
  例如, google-awesome-project/src/base/logging.h 应该按如下方式包含:
  #include "base/logging.h"
  又如, dir/foo.cc 或 dir/foo_test.cc 的主要作用是实现或测试 dir2/foo2.h 的功能, foo.cc 
中包含头文件的次序如下:
  1. dir2/foo2.h (优先位置, 详情如下)
  2. C 系统文件
  3. C++ 系统文件
  4. 其他库的 .h 文件
  5. 本项目内 .h 文件
  这种优先的顺序排序保证当 dir2/foo2.h 遗漏某些必要的库时， dir/foo.cc 或 dir/foo_test.cc 
的构建会立刻中止。因此这一条规则保证维护这些文件的人们首先看到构建中止的消息而不是维护其他包的人们。
  dir/foo.cc 和 dir2/foo2.h 通常位于同一目录下 (如 base/basictypes_unittest.cc 和 base/basictypes.h)
但也可以放在不同目录下.
  按字母顺序分别对每种类型的头文件进行二次排序是不错的主意。注意较老的代码可不符合这条规则，
要在方便的时候改正它们。

举例来说, google-awesome-project/src/foo/internal/fooserver.cc 的包含次序如下:
  #include "foo/public/fooserver.h"     // 优先位置
  
  #include <sys/types.h>                //  C 系统文件
  #include <unistd.h>                   //  C 系统文件
  
  #include <hash_map>                   // C++ 系统文件
  #include <vector>                     // C++ 系统文件
  
  #include "base/basictypes.h"          // 其他库的 .h 文件
  #include "base/commandlineflags.h"    // 其他库的 .h 文件
  #include "foo/public/bar.h"           //本项目内 .h 文件
    
例外：
  有时，平台特定（system-specific）代码需要条件编译（conditional includes），
这些代码可以放到其它 includes 之后。当然，您的平台特定代码也要够简练且独立，比如：
  #include "foo/public/fooserver.h"
  
  #include "base/port.h"  // For LANG_CXX11.
  
  #ifdef LANG_CXX11
  #include <initializer_list>
  #endif  // LANG_CXX11
}
style(YuleFox){
  a. 原来还真有项目用 #includes 来插入文本，且其文件扩展名 .inc 看上去也很科学。
  b. Google 已经不再提倡 -inl.h 用法。
  c. 注意，前置声明的类是不完全类型（incomplete type），我们只能定义指向该类型的指针或引用，或者声明（但不能定义）以不完全类型作为参数或者返回类型的函数。毕竟编译器不知道不完全类型的定义，我们不能创建其类的任何对象，也不能声明成类内部的数据成员。
  d. 类内部的函数一般会自动内联。所以某函数一旦不需要内联，其定义就不要再放在头文件里，而是放到对应的 .cc 文件里。这样可以保持头文件的类相当精炼，也很好地贯彻了声明与定义分离的原则。
  e. 在 #include 中插入空行以分割相关头文件, C 库, C++ 库, 其他库的 .h 和本项目内的 .h 是个好习惯。
}
第二章 作用域
style(命名空间){
  鼓励在 .cc 文件内使用匿名命名空间或 static 声明. 使用具名的命名空间时, 其名称可基于项目名或相对路径.
1. 禁止使用 using 指示（using-directive）。
2. 禁止使用内联命名空间（inline namespace）。
定义:
  命名空间将全局作用域细分为独立的, 具名的作用域, 可有效防止全局作用域的命名冲突.
  内联命名空间会自动把内部的标识符放到外层作用域，比如：
1. 禁止使用内联命名空间
namespace X {
inline namespace Y {
void foo();
}  // namespace Y
}  // namespace X
X::Y::foo() 与 X::foo() 彼此可代替。内联命名空间主要用来保持跨版本的 ABI 兼容性。

结论:
  根据下文将要提到的策略合理使用命名空间.
    遵守 命名空间命名 中的规则。
    像之前的几个例子中一样，在命名空间的最后注释出命名空间的名字。
  用命名空间把文件包含, gflags 的声明/定义, 以及类的前置声明以外的整个源文件封装起来, 
以区别于其它命名空间:
  // .h 文件 -- 头文件
  namespace mynamespace {
  // 所有声明都置于命名空间中
  // 注意不要使用缩进
  class MyClass {
      public:
      ...
      void Foo();
  };
  } // namespace mynamespace
  
  // .cc 文件 -- 实现文件
  namespace mynamespace {
  // 函数定义都置于命名空间中
  void MyClass::Foo() {
      ...
  }
  } // namespace mynamespace
  
  更复杂的 .cc 文件包含更多, 更复杂的细节, 比如 gflags 或 using 声明。
  include "a.h"
  DEFINE_FLAG(bool, someflag, false, "dummy flag");
  namespace a {
  
  ...code for a...                // 左对齐
  
  } // namespace a

  不要在命名空间 std 内声明任何东西, 包括标准库的类前置声明. 
在 std 命名空间声明实体是未定义的行为, 会导致如不可移植. 声明标准库下的实体, 需要包含对应的头文件.
  1. 不应该使用 using 指示 引入整个命名空间的标识符号。
    // 禁止 —— 污染命名空间
    using namespace foo;
    
  2. 不要在头文件中使用 命名空间别名 除非显式标记内部命名空间使用。
因为任何在头文件中引入的命名空间都会成为公开API的一部分。
  // 在 .cc 中使用别名缩短常用的命名空间
  namespace baz = ::foo::bar::baz;
  
  // 在 .h 中使用别名缩短常用的命名空间
  namespace librarian {
  namespace impl {  // 仅限内部使用
  namespace sidetable = ::pipeline_diagnostics::sidetable;
  }  // namespace impl
  
  inline void my_inline_function() {
    // 限制在一个函数中的命名空间别名
    namespace baz = ::foo::bar::baz;
    ...
  }
  }  // namespace librarian
  
3. 禁止用内联命名空间
}

style(匿名命名空间和静态变量){
  在 .cc 文件中定义一个不需要被外部引用的变量时，可以将它们放在匿名命名空间或声明为 static 。
但是不要在 .h 文件中这么做。
定义:
  所有置于匿名命名空间的声明都具有内部链接性，函数和变量可以经由声明为 static 拥有内部链接性，
这意味着你在这个文件中声明的这些标识符都不能在另一个文件中被访问。即使两个文件声明了完全一样
名字的标识符，它们所指向的实体实际上是完全不同的。

结论:
    推荐、鼓励在 .cc 中对于不需要在其他地方引用的标识符使用内部链接性声明，但是不要在 .h 中使用。
    匿名命名空间的声明和具名的格式相同，在最后注释上 namespace :
    namespace {
    ...
    }  // namespace
}
style(非成员函数、静态成员函数和全局函数){
  使用静态成员函数或命名空间内的非成员函数, 尽量不要用裸的全局函数. 将一系列函数直接置于命名空间中，
不要用类的静态方法模拟出命名空间的效果，类的静态方法应当和类的实例或静态数据紧密相关。

结论:
  有时, 把函数的定义同类的实例脱钩是有益的, 甚至是必要的. 这样的函数可以被定义成静态成员, 
  或是非成员函数. 非成员函数不应依赖于外部变量, 应尽量置于某个命名空间内. 相比单纯为了封装
  若干不共享任何静态数据的静态成员函数而创建类, 不如使用 2.1. 命名空间 。举例而言，
  对于头文件 myproject/foo_bar.h , 应当使用
  namespace myproject {
  namespace foo_bar {
  void Function1();
  void Function2();
  }  // namespace foo_bar
  }  // namespace myproject
  -- 而非 --
  namespace myproject {
  class FooBar {
   public:
    static void Function1();
    static void Function2();
  };
  }  // namespace myproject
  
  定义在同一编译单元的函数, 被其他编译单元直接调用可能会引入不必要的耦合和链接时依赖; 
静态成员函数对此尤其敏感. 可以考虑提取到新类中, 或者将函数置于独立库的命名空间内.
  如果你必须定义非成员函数, 又只是在 .cc 文件中使用它, 可使用匿名 2.1. 命名空间 或 
static 链接关键字 (如 static int Foo() {...}) 限定其作用域.
}
style(局部变量){
  将函数变量尽可能置于最小作用域内, 并在变量声明时进行初始化.
  a. 应使用初始化的方式替代声明再赋值, 比如:
    int i;
    i = f(); // 坏——初始化和声明分离

    int j = g(); // 好——初始化时声明

    vector<int> v;
    v.push_back(1); // 用花括号初始化更好
    v.push_back(2);

    vector<int> v = {1, 2}; // 好——v 一开始就初始化
  属于 if, while 和 for 语句的变量应当在这些语句中正常地声明，这样子这些变量的作用域就被限制
在这些语句中了，举例而言:
  while (const char* p = strchr(str, '/')) str = p + 1;
  
  b. 有一个例外, 如果变量是一个对象, 每次进入作用域都要调用其构造函数, 每次退出作用域都要调用其析构函数. 
这会导致效率降低.
  // 低效的实现
  for (int i = 0; i < 1000000; ++i) {
      Foo f;                  // 构造函数和析构函数分别调用 1000000 次!
      f.DoSomething(i);
  }
  在循环作用域外面声明这类变量要高效的多:
  Foo f;                      // 构造函数和析构函数只调用 1 次
  for (int i = 0; i < 1000000; ++i) {
      f.DoSomething(i);
  }
}
style(静态和全局变量){
  a. 禁止定义静态储存周期非POD变量， # 原生数据类型 (POD : Plain Old Data)
  b. 禁止使用含有副作用的函数初始化POD全局变量，
  c. 因为多编译单元中的静态变量执行时的构造和析构顺序是未明确的，这将导致代码的不可移植。
  禁止使用类的 静态储存周期 变量：由于构造和析构函数调用顺序的不确定性，它们会导致难以发现的 bug 。
不过 constexpr 变量除外，毕竟它们又不涉及动态初始化或析构。
  静态生存周期的对象，即包括了全局变量，静态变量，静态类成员变量和函数静态变量，都必须是原生数据类型
(POD : Plain Old Data): 即 int, char 和 float, 以及 POD 类型的指针、数组和结构体。
  也不允许用函数返回值来初始化 POD 变量，除非该函数（比如 getenv() 或 getpid() ）不涉及任何全局变量。
函数作用域里的静态变量除外，毕竟它的初始化顺序是有明确定义的，而且只会在指令执行到它的声明那里才会发生。

  综上所述，我们只允许 POD 类型的静态变量，即完全禁用 vector (使用 C 数组替代) 和 string
(使用 const char [])。

  如果您确实需要一个 class 类型的静态或全局变量，可以考虑在 main() 函数或 pthread_once() 内初始化一个
指针且永不回收。注意只能用 raw 指针，别用智能指针，毕竟后者的析构函数涉及到上文指出的不定顺序问题。
}
第三章 类
style(构造函数的职责){
总述
  不要在构造函数中调用虚函数, 也不要在无法报出错误时进行可能失败的初始化.
定义
  在构造函数中可以进行各种初始化操作.
结论
  a. 构造函数不允许调用虚函数. 如果代码允许, 直接终止程序是一个合适的处理错误的方式. 否则, 
     考虑用 Init() 方法或工厂函数.
}
style(隐式类型转换){
总述
  不要定义隐式类型转换. 对于转换运算符和单参数构造函数, 请使用 explicit 关键字.
定义
  隐式类型转换允许一个某种类型 (称作 源类型) 的对象被用于需要另一种类型 (称作 目的类型) 的位置, 
  例如, 将一个 int 类型的参数传递给需要 double 类型的函数.
  
    explicit 关键字可以用于构造函数或 (在 C++11 引入) 类型转换运算符, 以保证只有当目的类型在
  调用点被显式写明时才能进行类型转换, 例如使用 cast. 这不仅作用于隐式类型转换, 还能作用于 
  C++11 的列表初始化语法:
    class Foo {
      explicit Foo(int x, double y);
      ...
    };
    void Func(Foo f);
    此时下面的代码是不允许的:
    Func({42, 3.14});  // Error
  这一代码从技术上说并非隐式类型转换, 但是语言标准认为这是 explicit 应当限制的行为.
  
结论
    在类型定义中, 类型转换运算符和单参数构造函数都应当用 explicit 进行标记. 一个例外是, 
  拷贝和赋值构造函数不应当被标记为 explicit, 因为它们并不执行类型转换. 对于设计目的就是
  用于对其他类型进行透明包装的类来说, 隐式类型转换有时是必要且合适的. 这时应当联系项目
  组长并说明特殊情况.
    不能以一个参数进行调用的构造函数不应当加上 explicit. 接受一个 std::initializer_list 
  作为参数的构造函数也应当省略 explicit, 以便支持拷贝初始化 (例如 MyType m = {1, 2};) .
}
style(可拷贝类型和可移动类型){
总述
  如果你的类型需要, 就让它们支持拷贝 / 移动. 否则, 就把隐式产生的拷贝和移动函数禁用.
结论
  如果需要就让你的类型可拷贝 / 可移动. 作为一个经验法则, 
  如果对于你的用户来说这个拷贝操作不是一眼就能看出来的, 那就不要把类型设置为可拷贝. 
  如果让类型可拷贝, 一定要同时给出拷贝构造函数和赋值操作的定义, 反之亦然. 
  如果让类型可拷贝, 同时移动操作的效率高于拷贝操作, 那么就把移动的两个操作 (移动构造函数和赋值操作) 也给出定义. 
  如果类型不可拷贝, 但是移动操作的正确性对用户显然可见, 那么把这个类型设置为只可移动并定义移动的两个操作.

  如果定义了拷贝/移动操作, 则要保证这些操作的默认实现是正确的. 记得时刻检查默认操作的正确性, 
并且在文档中说明类是可拷贝的且/或可移动的.
class Foo {
 public:
  Foo(Foo&& other) : field_(other.field) {}
  // 差, 只定义了移动构造函数, 而没有定义对应的赋值运算符.

 private:
  Field field_;
};

  由于存在对象切割的风险, 不要为任何有可能有派生类的对象提供赋值操作或者拷贝 / 移动构造函数 (当然也不要继承有这样的成员函数的类). 如果你的基类需要可复制属性, 
请提供一个 public virtual Clone() 和一个 protected 的拷贝构造函数以供派生类实现.
  如果你的类不需要拷贝 / 移动操作, 请显式地通过在 public 域中使用 = delete 或其他手段禁用之.
// MyClass is neither copyable nor movable.
MyClass(const MyClass&) = delete;
MyClass& operator=(const MyClass&) = delete;
}
style(结构体 VS. 类){
总述
  仅当只有数据成员时使用 struct, 其它一概使用 class.
说明
  在 C++ 中 struct 和 class 关键字几乎含义一样. 我们为这两个关键字添加我们自己的语义理解, 
以便为定义的数据类型选择合适的关键字.
  struct 用来定义包含数据的被动式对象, 也可以包含相关的常量, 但除了存取数据成员之外, 没有别
的函数功能. 并且存取功能是通过直接访问位域, 而非函数调用. 除了构造函数, 析构函数, Initialize(), 
Reset(), Validate() 等类似的用于设定数据成员的函数外, 不能提供其它功能的函数.
  如果需要更多的函数功能, class 更适合. 如果拿不准, 就用 class.
  为了和 STL 保持一致, 对于仿函数等特性可以不用 class 而是使用 struct.
}
style(继承){
总述
  使用组合常常比使用继承更合理. 如果使用继承的话, 定义为 public 继承.
  必要的话, 析构函数声明为 virtual. 如果你的类有虚函数, 则析构函数也应该为虚函数.
  对于可能被子类访问的成员函数, 不要过度使用 protected 关键字. 注意, 数据成员都必须是 私有的.
定义
  当子类继承基类时, 子类包含了父基类所有数据及操作的定义. C++ 实践中, 继承主要用于两种场合: 
  实现继承, 子类继承父类的实现代码; 
  接口继承, 子类仅继承父类的方法名称.
缺点
  对于实现继承, 由于子类的实现代码散布在父类和子类间之间, 要理解其实现变得更加困难. 子类不能
重写父类的非虚函数, 当然也就不能修改其实现. 基类也可能定义了一些数据成员, 因此还必须区分基类
的实际布局.
  不要过度使用实现继承. 组合常常更合适一些. 尽量做到只在"是一个"的情况下使用继承: 如果 Bar 的确
"是一种"Foo, Bar 才能继承 Foo。

  对于重载的虚函数或虚析构函数, 使用 override, 或 (较不常用的) final 关键字显式地进行标记. 
较早 (早于 C++11) 的代码可能会使用 virtual 关键字作为不得已的选项. 因此, 在声明重载时, 
请使用 override, final 或 virtual 的其中之一进行标记.
}
style(多重继承){
总述
  真正需要用到多重实现继承的情况少之又少. 只在以下情况我们才允许多重继承: 最多只有
一个基类是非抽象类; 其它基类都是以 Interface 为后缀的 纯接口类.
定义
  多重继承允许子类拥有多个基类. 要将作为 纯接口 的基类和具有 实现 的基类区别开来.
结论
  只有当所有父类除第一个外都是 纯接口类 时, 才允许使用多重继承. 为确保它们是纯接口, 
这些类必须以 Interface 为后缀.
}
style(接口){
总述
  接口是指满足特定条件的类, 这些类以 Interface 为后缀 (不强制).
定义
  当一个类满足以下要求时, 称之为纯接口:
    只有纯虚函数 ("=0") 和静态函数 (除了下文提到的析构函数).
    没有非静态数据成员.
    没有定义任何构造函数. 如果有, 也不能带有参数, 并且必须为 protected.
    如果它是一个子类, 也只能从满足上述条件并以 Interface 为后缀的类继承.
  接口类不能被直接实例化, 因为它声明了纯虚函数. 为确保接口类的所有实现可被正确销毁, 
必须为之声明虚析构函数
结论
  只有在满足上述条件时, 类才以 Interface 结尾, 但反过来, 满足上述需要的类未必一定以 Interface 结尾.
}
style(运算符重载){
总述
  除少数特定环境外, 不要重载运算符. 也不要创建用户定义字面量.
定义
  C++ 允许用户通过使用 operator 关键字 对内建运算符进行重载定义 , 只要其中一个参数是用户定义的类型. 
operator 关键字还允许用户使用 operator"" 定义新的字面运算符, 并且定义类型转换函数, 例如 
operator bool().
  
缺点
  a. 要提供正确, 一致, 不出现异常行为的操作符运算需要花费不少精力, 而且如果达不到这些要求的话, 会导致令人迷惑的 Bug.
  b. 过度使用运算符会带来难以理解的代码, 尤其是在重载的操作符的语义与通常的约定不符合时.
  c. 函数重载有多少弊端, 运算符重载就至少有多少.
  d. 运算符重载会混淆视听, 让你误以为一些耗时的操作和操作内建类型一样轻巧.
  e. 对重载运算符的调用点的查找需要的可就不仅仅是像 grep 那样的程序了, 这时需要能够理解 C++ 语法的搜索工具.
  f. 如果重载运算符的参数写错, 此时得到的可能是一个完全不同的重载而非编译错误. 例如: foo < bar 执行的是一个行为, 而 &foo < &bar 执行的就是完全不同的另一个行为了.
  g. 重载某些运算符本身就是有害的. 例如, 重载一元运算符 & 会导致同样的代码有完全不同的含义, 这取决于重载的声明对某段代码而言是否是可见的. 重载诸如 &&, || 和 , 会导致运算顺序和内建运算的顺序不一致.
  h. 运算符从通常定义在类的外部, 所以对于同一运算, 可能出现不同的文件引入了不同的定义的风险. 如果两种定义都链接到同一二进制文件, 就会导致未定义的行为, 有可能表现为难以发现的运行时错误.
  k. 用户定义字面量所创建的语义形式对于某些有经验的 C++ 程序员来说都是很陌生的.
    不要为了避免重载操作符而走极端. 比如说, 应当定义 ==, =, 和 << 而不是 Equals(), CopyFrom() 
 和 PrintTo(). 反过来说, 不要只是为了满足函数库需要而去定义运算符重载. 比如说, 如果你的类型
 没有自然顺序, 而你要将它们存入 std::set 中, 最好还是定义一个自定义的比较运算符而不是重载 <.
    不要重载 &&, ||, , 或一元运算符 &. 不要重载 operator"", 也就是说, 不要引入用户定义字面量.
}
style(存取控制){
总述
  将 所有 数据成员声明为 private, 除非是 static const 类型成员 (遵循 常量命名规则). 
处于技术上的原因, 在使用 Google Test 时我们允许测试固件类中的数据成员为 protected
}
style(声明顺序){
总述
  将相似的声明放在一起, 将 public 部分放在最前.
说明
1. 类定义一般应以 public: 开始, 后跟 protected:, 最后是 private:. 省略空部分.
2. 在各个部分中, 建议将类似的声明放在一起, 并且建议以如下的顺序: 类型 (包括 typedef, using 和
   嵌套的结构体与类), 常量, 工厂函数, 构造函数, 赋值运算符, 析构函数, 其它函数, 数据成员.
3. 不要将大段的函数定义内联在类定义中. 只有那些普通的, 或非性能关键且短小的函数可以内联在函数定义中.
}
第四章 函数
style(参数顺序){
总述
    函数的参数顺序为: 输入参数在先, 后跟输出参数.
说明
  a. C/C++ 中的函数参数或者是函数的输入, 或者是函数的输出, 或兼而有之. 
  b. 输入参数通常是值参或 const 引用, 
  c. 输出参数或输入/输出参数则一般为非 const 指针. 
  d. 在排列参数顺序时, 将所有的输入参数置于输出参数之前. 
  e. 特别要注意, 在加入新参数时不要因为它们是新参数就置于参数列表最后, 而是仍然要按照前述的规则, 
     即将新的输入参数也置于输出参数之前.
}
style(编写简短函数){
总述
  我们倾向于编写简短, 凝练的函数.
说明
a. 我们承认长函数有时是合理的, 因此并不硬性限制函数的长度. 如果函数超过 40 行, 可以思索一下
   能不能在不影响程序结构的前提下对其进行分割.
b. 即使一个长函数现在工作的非常好, 一旦有人对其修改, 有可能出现新的问题, 甚至导致难以发现的 bug. 
   使函数尽量简短, 以便于他人阅读和修改代码.
c. 在处理代码时, 你可能会发现复杂的长函数. 不要害怕修改现有代码: 如果证实这些代码使用 / 调试起来
   很困难, 或者你只需要使用其中的一小段代码, 考虑将其分割为更加简短并易于管理的若干函数.
}
style(引用参数){
总述
  所有按引用传递的参数必须加上 const
定义
  在 C 语言中, 如果函数需要修改变量的值, 参数必须为指针, 如 int foo(int *pval). 
  在 C++ 中, 函数还可以声明为引用参数: int foo(int &val).
  
结论
  函数参数列表中, 所有引用参数都必须是 const:
  void Foo(const string &in, string *out);
  事实上这在 Google Code 是一个硬性约定: 输入参数是值参或 const 引用, 输出参数为指针. 
输入参数可以是 const 指针, 但决不能是非 const 的引用参数, 除非特殊要求, 比如 swap().
有时候, 在输入形参中用 const T* 指针比 const T& 更明智. 比如:
    a. 可能会传递空指针.
    b. 函数要把指针或对地址的引用赋值给输入形参.
  总而言之, 大多时候输入形参往往是 const T&. 若用 const T* 则说明输入另有处理. 所以若要使用
const T*, 则应给出相应的理由, 否则会使得读者感到迷惑.
}
style(函数重载){
总述
  若要使用函数重载, 则必须能让读者一看调用点就胸有成竹, 而不用花心思猜测调用的重载函数到底是哪一种. 
这一规则也适用于构造函数.

定义
   你可以编写一个参数类型为 const string& 的函数, 然后用另一个参数类型为 const char* 的函数
对其进行重载:
class MyClass {
    public:
    void Analyze(const string &text);
    void Analyze(const char *text, size_t textlen);
};

结论
  如果打算重载一个函数, 可以试试改在函数名里加上参数信息. 例如, 用 AppendString() 和 AppendInt() 等,
而不是一口气重载多个 Append(). 如果重载函数的目的是为了支持不同数量的同一类型参数, 则优先考虑使用 
std::vector 以便使用者可以用 列表初始化 指定参数.
}
style(缺省参数){
总述
  只允许在非虚函数中使用缺省参数, 且必须保证缺省参数的值始终一致. 缺省参数与 函数重载 遵循同样的规则. 
一般情况下建议使用函数重载, 尤其是在缺省函数带来的可读性提升不能弥补下文中所提到的缺点的情况下.

缺点
a. 缺省参数实际上是函数重载语义的另一种实现方式, 因此所有 不应当使用函数重载的理由 也都适用于缺省参数.
b. 虚函数调用的缺省参数取决于目标对象的静态类型, 此时无法保证给定函数的所有重载声明的都是同样的缺省参数.
c. 缺省参数是在每个调用点都要进行重新求值的, 这会造成生成的代码迅速膨胀. 作为读者, 一般来说也更希望缺省的参数在声明时就已经被固定了, 而不是在每次调用时都可能会有不同的取值.
e. 缺省参数会干扰函数指针, 导致函数签名与调用点的签名不一致. 而函数重载不会导致这样的问题.
结论
  对于虚函数, 不允许使用缺省参数, 因为在虚函数中缺省参数不一定能正常工作. 如果在每个调用点
缺省参数的值都有可能不同, 在这种情况下缺省函数也不允许使用.
}
style(函数返回类型后置语法){
总述
  只有在常规写法 (返回类型前置) 不便于书写或不便于阅读时使用返回类型后置语法.

定义
  C++ 现在允许两种不同的函数声明方式. 以往的写法是将返回类型置于函数名之前. 例如:
  int foo(int x);
  C++11 引入了这一新的形式. 现在可以在函数名前使用 auto 关键字, 在参数列表之后后置返回类型. 例如:
  auto foo(int x) -> int;
  后置返回类型为函数作用域. 对于像 int 这样简单的类型, 两种写法没有区别. 但对于复杂的情况, 
例如类域中的类型声明或者以函数参数的形式书写的类型, 写法的不同会造成区别.
}
第五章 来自 Google 的奇技
style(所有权与智能指针){
> 总述
  动态分配出的对象最好有单一且固定的所有主, 并通过智能指针传递所有权.
  
定义
  所有权是一种登记／管理动态内存和其它资源的技术. 动态分配对象的所有主是一个对象或函数, 
后者负责确保当前者无用时就自动销毁前者. 所有权有时可以共享, 此时就由最后一个所有主来负责销毁它. 
甚至也可以不用共享, 在代码中直接把所有权传递给其它对象.

  智能指针是一个通过重载 * 和 -> 运算符以表现得如指针一样的类. 智能指针类型被用来自动化所有权
的登记工作, 来确保执行销毁义务到位. std::unique_ptr 是 C++11 新推出的一种智能指针类型, 
用来表示动态分配出的对象的独一无二的所有权; 当 std::unique_ptr 离开作用域时, 对象就会被销毁. 
std::unique_ptr 不能被复制, 但可以把它移动（move）给新所有主. std::shared_ptr 同样表示动态分配对象
的所有权, 但可以被共享, 也可以被复制; 对象的所有权由所有复制者共同拥有, 最后一个复制者被销毁时, 
对象也会随着被销毁.

缺点
a. 不得不用指针（不管是智能的还是原生的）来表示和传递所有权. 指针语义可要比值语义复杂得许多了, 特别是在 API 里：这时不光要操心所有权, 还要顾及别名, 生命周期, 可变性以及其它大大小小的问题.
b. 其实值语义的开销经常被高估, 所以所有权传递带来的性能提升不一定能弥补可读性和复杂度的损失.
c. 如果 API 依赖所有权的传递, 就会害得客户端不得不用单一的内存管理模型.
d. 如果使用智能指针, 那么资源释放发生的位置就会变得不那么明显.
e. std::unique_ptr 的所有权传递原理是 C++11 的 move 语法, 后者毕竟是刚刚推出的, 容易迷惑程序员.
f. 如果原本的所有权设计已经够完善了, 那么若要引入所有权共享机制, 可能不得不重构整个系统.
h. 所有权共享机制的登记工作在运行时进行, 开销可能相当大.
i. 某些极端情况下 (例如循环引用), 所有权被共享的对象永远不会被销毁.
j. 智能指针并不能够完全代替原生指针.

结论
  如果必须使用动态分配, 那么更倾向于将所有权保持在分配者手中. 如果其他地方要使用这个对象, 
最好传递它的拷贝, 或者传递一个不用改变所有权的指针或引用. 倾向于使用 std::unique_ptr 
来明确所有权传递, 例如：
    std::unique_ptr<Foo> FooFactory();
    void FooConsumer(std::unique_ptr<Foo> ptr);
  如果没有很好的理由, 则不要使用共享所有权. 这里的理由可以是为了避免开销昂贵的拷贝操作, 
但是只有当性能提升非常明显, 并且操作的对象是不可变的（比如说 std::shared_ptr<const Foo> ）时候, 
才能这么做. 如果确实要使用共享所有权, 建议于使用 std::shared_ptr .

不要使用 std::auto_ptr, 使用 std::unique_ptr 代替它.
}
style(shared_ptr){

}
style(auto_ptr){

}
style(unique_ptr){

}
style(scoped_ptr){

}
style(Cpplint){
总述
  使用 cpplint.py 检查风格错误.
  
说明
  cpplint.py 是一个用来分析源文件, 能检查出多种风格错误的工具. 它不并完美, 甚至还会漏报和误报,
但它仍然是一个非常有用的工具. 在行尾加 // NOLINT, 或在上一行加 // NOLINTNEXTLINE, 可以忽略报错.
  某些项目会指导你如何使用他们的项目工具运行 cpplint.py. 如果你参与的项目没有提供, 你可以单独下载 
cpplint.py. http://github.com/google/styleguide/blob/gh-pages/cpplint/cpplint.py
}
第六章 其他 C++ 特性
style(引用参数){
所有按引用传递的参数必须加上 const.
定义:
  在 C 语言中, 如果函数需要修改变量的值, 参数必须为指针, 如 int foo(int *pval). 
  在 C++ 中, 函数还可以声明引用参数: int foo(int &val).
}
style(右值引用){
只在定义移动构造函数与移动赋值操作时使用右值引用. 不要使用 std::forward.
定义:
  右值引用是一种只能绑定到临时对象的引用的一种, 其语法与传统的引用语法相似. 
例如, void f(string&& s); 声明了一个其参数是一个字符串的右值引用的函数.
缺点:
  右值引用是一个相对比较新的特性 (由 C++11 引入), 它尚未被广泛理解. 类似引用崩溃, 
移动构造函数的自动推导这样的规则都是很复杂的.

结论:
    只在定义移动构造函数与移动赋值操作时使用右值引用, 不要使用 std::forward 功能函数. 
你可能会使用 std::move 来表示将值从一个对象移动而不是复制到另一个对象.
}
style(变长数组和 alloca){
我们不允许使用变长数组和 alloca().
优点:
    变长数组具有浑然天成的语法. 变长数组和 alloca() 也都很高效.
缺点:
    变长数组和 alloca() 不是标准 C++ 的组成部分. 更重要的是, 它们根据数据大小动态分配堆栈内存, 
会引起难以发现的内存越界 bugs:"在我的机器上运行的好好的, 发布后却莫名其妙的挂掉了".
结论:
    改用更安全的分配器（allocator），就像 std::vector 或 std::unique_ptr<T[]>.
}
style(友元){
我们允许合理的使用友元类及友元函数.

a. 通常友元应该定义在同一文件内, 避免代码读者跑到其它文件查找使用该私有成员的类.
经常用到友元的一个地方是将 FooBuilder 声明为 Foo 的友元, 以便 FooBuilder 正确构造 
Foo 的内部状态, 而无需将该状态暴露出来. 某些情况下, 将一个单元测试类声明成待测类的友元会很方便.

b. 友元扩大了 (但没有打破) 类的封装边界. 某些情况下, 相对于将类成员声明为 public, 
使用友元是更好的选择, 尤其是如果你只允许另一个类访问该类的私有成员时. 当然, 大多数类
都只应该通过其提供的公有成员进行互操作.
}
style(异常){
我们不使用 C++ 异常.
}
style(运行时类型识别){
我们禁止使用 RTTI.
定义:
  RTTI 允许程序员在运行时识别 C++ 类对象的类型. 它通过使用 typeid 或者 dynamic_cast 完成.
}
style(类型转换){
使用 C++ 的类型转换, 如 static_cast<>(). 不要使用 int y = (int)x 或 int y = int(x) 等转换方式;
定义:
    C++ 采用了有别于 C 的类型转换机制, 对转换操作进行归类.
    
结论:
  不要使用 C 风格类型转换. 而应该使用 C++ 风格.
    用 static_cast 替代 C 风格的值转换, 或某个类指针需要明确的向上转换为父类指针时.
    用 const_cast 去掉 const 限定符.
    用 reinterpret_cast 指针类型和整型或其它指针之间进行不安全的相互转换. 仅在你对所做一切了然于心时使用.
}
style(流){
只在记录日志时使用流.
定义:
    流用来替代 printf() 和 scanf().
    
流的支持者们主张流是不二之选, 但观点并不是那么清晰有力. 他们指出的流的每个优势也都是其劣势. 
流最大的优势是在输出时不需要关心打印对象的类型. 这是一个亮点. 同时, 也是一个不足: 
你很容易用错类型, 而编译器不会报警. 使用流时容易造成的这类错误:
#      cout << this;   // 输出地址
#      cout << *this;  // 输出值
# 由于 << 被重载, 编译器不会报错. 就因为这一点我们反对使用操作符重载.

    每一种方式都是各有利弊, "没有最好, 只有更适合". 简单性原则告诫我们必须从中选择其一, 
最后大多数决定采用 printf + read/write.
}
style(前置自增和自减){
对于迭代器和其他模板对象使用前缀形式 (++i) 的自增, 自减运算符.
}
style(const 用法){
我们强烈建议你在任何可能的情况下都要使用 const. 此外有时改用 C++11 推出的 constexpr 更好。
定义:
    在声明的变量或参数前加上关键字 const 用于指明变量值不可被篡改 (如 const int foo ). 
为类中的函数加上 const 限定符表明该函数不会修改类成员变量的状态 
(如 class Foo { int Bar(char c) const; };).

结论:
  const 变量, 数据成员, 函数和参数为编译时类型检测增加了一层保障; 便于尽早发现错误. 因此, 
我们强烈建议在任何可能的情况下使用 const:
    如果函数不会修改传你入的引用或指针类型参数, 该参数应声明为 const.
    尽可能将函数声明为 const. 访问函数应该总是 const. 其他不会修改任何数据成员, 未调用非 const 函数, 不会返回数据成员非 const 指针或引用的函数也应该声明成 const.
    如果数据成员在对象构造之后不再发生变化, 可将其定义为 const.
    
  然而, 也不要发了疯似的使用 const. 像 const int * const * const x; 就有些过了, 
虽然它非常精确的描述了常量 x. 关注真正有帮助意义的信息: 前面的例子写成 const int** x 就够了.
    关键字 mutable 可以使用, 但是在多线程中是不安全的, 使用时首先要考虑线程安全.
}
style(整型){
定义:
    C++ 没有指定整型的大小. 通常人们假定 short 是 16 位, int 是 32 位, long 是 32 位, 
long long 是 64 位.
结论:
   <stdint.h> 定义了 int16_t, uint32_t, int64_t 等整型, 在需要确保整型大小时可以使用它们代替 
short, unsigned long long 等. 在 C 整型中, 只使用 int. 在合适的情况下, 推荐使用标准类型如 
size_t 和 ptrdiff_t.
  如果已知整数不会太大, 我们常常会使用 int, 如循环计数. 在类似的情况下使用原生类型 int. 
你可以认为 int 至少为 32 位, 但不要认为它会多于 32 位. 如果需要 64 位整型, 用 int64_t 或 uint64_t.
  对于大整数, 使用 int64_t.
  不要使用 uint32_t 等无符号整型, 除非你是在表示一个位组而不是一个数值, 或是你需要定义二进制补码溢出. 
尤其是不要为了指出数值永不会为负, 而使用无符号类型. 相反, 你应该使用断言来保护数据.
  如果您的代码涉及容器返回的大小（size），确保其类型足以应付容器各种可能的用法。拿不准时，
类型越大越好。
  小心整型类型转换和整型提升（acgtyrant 注：integer promotions, 比如 int 与 unsigned int 运算时，
前者被提升为 unsigned int 而有可能溢出），总有意想不到的后果。

关于无符号整数:
  有些人, 包括一些教科书作者, 推荐使用无符号类型表示非负数. 这种做法试图达到自我文档化. 
但是, 在 C 语言中, 这一优点被由其导致的 bug 所淹没. 看看下面的例子:
    for (unsigned int i = foo.Length()-1; i >= 0; --i) ...
上述循环永远不会退出! 有时 gcc 会发现该 bug 并报警, 但大部分情况下都不会.
}
style(64 位下的可移植性){
代码应该对 64 位和 32 位系统友好. 处理打印, 比较, 结构体对齐时应切记:
inttypes.h
  // printf macros for size_t, in the style of inttypes.h
  #ifdef _LP64
  #define __PRIS_PREFIX "z"
  #else
  #define __PRIS_PREFIX
  #endif
  
  // Use these macros after a % in a printf format string
  // to get correct 32/64 bit behavior, like this:
  // size_t size = records.size();
  // printf("%"PRIuS"\n", size);
  #define PRIdS __PRIS_PREFIX "d"
  #define PRIxS __PRIS_PREFIX "x"
  #define PRIuS __PRIS_PREFIX "u"
  #define PRIXS __PRIS_PREFIX "X"
  #define PRIoS __PRIS_PREFIX "o"
类型 	                    不要使用 	        使用
void * (或其他指针类型) 	%lx 	            %p 	 
int64_t 	                %qd, %lld 	        %"PRId64" 	 
uint64_t 	                %qu, %llu, %llx 	%"PRIu64", %"PRIx64" 	 
size_t 	                    %u 	                %"PRIuS", %"PRIxS" 	
ptrdiff_t 	                %d 	                %"PRIdS" 	

创建 64 位常量时使用 LL 或 ULL 作为后缀, 如:
    int64_t my_value = 0x123456789LL;
    uint64_t my_mask = 3ULL << 48;
}
style(预处理宏){
使用宏时要非常谨慎, 尽量以内联函数, 枚举和常量代替之

下面给出的用法模式可以避免使用宏带来的问题; 如果你要宏, 尽可能遵守:
  不要在 .h 文件中定义宏.
  在马上要使用时才进行 #define, 使用后要立即 #undef.
  不要只是对已经存在的宏使用#undef，选择一个不会冲突的名称；
  不要试图使用展开后会导致 C++ 构造不稳定的宏, 不然也至少要附上文档说明其行为.
  不要用 ## 处理函数，类和变量的名字。
}
style(sizeof){
  尽可能用 sizeof(varname) 代替 sizeof(type).
  使用 sizeof(varname) 是因为当代码中变量类型改变时会自动更新. 您或许会用 sizeof(type) 
处理不涉及任何变量的代码，比如处理来自外部或内部的数据格式，这时用变量就不合适了。
Struct data;
Struct data; memset(&data, 0, sizeof(data));
}
style(Boost 库){
只使用 Boost 中被认可的库.
定义:
  Boost 库集 是一个广受欢迎, 经过同行鉴定, 免费开源的 C++ 库集.
}
style(C++11){
适当用 C++11（前身是 C++0x）的库和语言扩展，在贵项目用 C++11 特性前三思可移植性。
}
第八章 命名约定
style(通用命名规则){
总述
  函数命名, 变量命名, 文件命名要有描述性; 少用缩写.
  
int price_count_reader;    // 无缩写
int num_errors;            // "num" 是一个常见的写法
int num_dns_connections;   // 人人都知道 "DNS" 是什么

int n;                     // 毫无意义.
int nerr;                  // 含糊不清的缩写.
int n_comp_conns;          // 含糊不清的缩写.
int wgc_connections;       // 只有贵团队知道是什么意思.
int pc_reader;             // "pc" 有太多可能的解释了.
int cstmr_id;              // 删减了若干字母.
注意, 一些特定的广为人知的缩写是允许的, 例如用 i 表示迭代变量和用 T 表示模板参数.
}
style(文件命名){
总述
  文件名要全部小写, 可以包含下划线 (_) 或连字符 (-), 依照项目的约定. 如果没有约定, 那么 "_" 更好.

  可接受的文件命名示例:
    my_useful_class.cc
    my-useful-class.cc
    myusefulclass.cc
    myusefulclass_test.cc // _unittest 和 _regtest 已弃用.
C++ 文件要以 .cc 结尾, 头文件以 .h 结尾.
  不要使用已经存在于 /usr/include 下的文件名 如 db.h.
  
  通常应尽量让文件名更加明确. http_server_logs.h 就比 logs.h 要好. 定义类时文件名一般成对出现, 
如 foo_bar.h 和 foo_bar.cc, 对应于类 FooBar.
  内联函数必须放在 .h 文件中. 如果内联函数比较短, 就直接放在 .h 中.
}
style(类型命名){
总述
  类型名称的每个单词首字母均大写, 不包含下划线: MyExcitingClass, MyExcitingEnum.
说明
  所有类型命名 —— 类, 结构体, 类型定义 (typedef), 枚举, 类型模板参数 —— 均使用相同约定, 
即以大写字母开始, 每个单词首字母均大写, 不包含下划线. 例如:
    // 类和结构体
    class UrlTable { ...
    class UrlTableTester { ...
    struct UrlTableProperties { ...
    
    // 类型定义
    typedef hash_map<UrlTableProperties *, string> PropertiesMap;
    
    // using 别名
    using PropertiesMap = hash_map<UrlTableProperties *, string>;
    
    // 枚举
    enum UrlTableErrors { ...
}

style(变量命名){
总述
  变量 (包括函数参数) 和数据成员名一律小写, 单词之间用下划线连接. 类的成员变量以下划线结尾, 
但结构体的就不用, 如: a_local_variable, a_struct_data_member, a_class_data_member_.
1. 普通变量命名
  举例:
    string table_name;  // 好 - 用下划线.
    string tablename;   // 好 - 全小写.
    string tableName;  // 差 - 混合大小写
    
2. 类数据成员
不管是静态的还是非静态的, 类数据成员都可以和普通变量一样, 但要接下划线.
class TableInfo {
  ...
 private:
  string table_name_;  // 好 - 后加下划线.
  string tablename_;   // 好.
  static Pool<TableInfo>* pool_;  // 好.
};
3. 结构体变量
不管是静态的还是非静态的, 结构体数据成员都可以和普通变量一样, 不用像类那样接下划线:
struct UrlTableProperties {
  string name;
  int num_entries;
  static Pool<UrlTableProperties>* pool;
};
}
style(常量命名){
总述
  声明为 constexpr 或 const 的变量, 或在程序运行期间其值始终保持不变的, 命名时以"k"开头, 大小写混合. 
例如:
const int kDaysInAWeek = 7;
}
style(函数命名){
总述
  常规函数使用大小写混合, 取值和设值函数则要求与变量名匹配: MyExcitingFunction(), 
MyExcitingMethod(), my_exciting_member_variable(), set_my_exciting_member_variable().
说明
  一般来说, 函数名的每个单词首字母大写 (即 “驼峰变量名” 或 “帕斯卡变量名”), 没有下划线. 
对于首字母缩写的单词, 更倾向于将它们视作一个单词进行首字母大写 (例如, 写作 StartRpc() 
而非 StartRPC()).
  AddTableEntry()
  DeleteUrl()
  OpenFileOrDie()
}
style(枚举命名){
总述
  枚举的命名应当和 常量 或 宏 一致: kEnumName 或是 ENUM_NAME.
说明
  单独的枚举值应该优先采用 常量 的命名方式. 但 宏 方式的命名也可以接受. 
枚举名 UrlTableErrors (以及 AlternateUrlTableErrors) 是类型, 所以要用大小写混合的方式.
    enum UrlTableErrors {
        kOK = 0,
        kErrorOutOfMemory,
        kErrorMalformedInput,
    };
    enum AlternateUrlTableErrors {
        OK = 0,
        OUT_OF_MEMORY = 1,
        MALFORMED_INPUT = 2,
    }
}
style(宏命名){
总述
  你并不打算 使用宏, 对吧? 如果你一定要用, 像这样命名: MY_MACRO_THAT_SCARES_SMALL_CHILDREN.
说明
  参考 预处理宏; 通常 不应该 使用宏. 如果不得不用, 其命名像枚举命名一样全部大写, 使用下划线:
#define ROUND(x) ...
#define PI_ROUNDED 3.0
}
第九章 注释
style(注释风格){
总述
    使用 // 或 /* */, 统一就好.
说明
    // 或 /* */ 都可以; 但 // 更 常用. 要在如何注释及注释风格上确保统一.
}
style(文件注释){
总述
  在每一个文件开头加入版权公告.
  文件注释描述了该文件的内容. 如果一个文件只声明, 或实现, 或测试了一个对象, 并且这个对象
已经在它的声明处进行了详细的注释, 那么就没必要再加上文件注释. 除此之外的其他文件都需要文件注释.
说明
    法律公告和作者信息
    每个文件都应该包含许可证引用. 为项目选择合适的许可证版本.(比如, Apache 2.0, BSD, LGPL, GPL)
如果你对原始作者的文件做了重大修改, 请考虑删除原作者信息.
    文件内容
  如果一个 .h 文件声明了多个概念, 则文件注释应当对文件的内容做一个大致的说明, 
同时说明各概念之间的联系. 一个一到两行的文件注释就足够了, 对于每个概念的详细文档
应当放在各个概念中, 而不是文件注释中.
  不要在 .h 和 .cc 之间复制注释, 这样的注释偏离了注释的实际意义.
}
style(类注释){
每个类的定义都要附带一份注释, 描述类的功能和用法, 除非它的功能相当明显.

// Iterates over the contents of a GargantuanTable.
// Example:
//    GargantuanTableIterator* iter = table->NewIterator();
//    for (iter->Seek("foo"); !iter->done(); iter->Next()) {
//      process(iter->key(), iter->value());
//    }
//    delete iter;
class GargantuanTableIterator {
  ...
};
  类注释应当为读者理解如何使用与何时使用类提供足够的信息, 同时应当提醒读者在正确
使用此类时应当考虑的因素. 
如果类有任何同步前提, 请用文档说明. 
如果该类的实例可被多线程访问, 要特别注意文档说明多线程环境下相关的规则和常量使用.
}
style(函数注释){
总述
  函数声明处的注释描述函数功能; 定义处的注释描述函数实现.
  
函数声明
  基本上每个函数声明处前都应当加上注释, 描述函数的功能和用途.
  
  函数声明处注释的内容:
    a. 函数的输入输出.
    b. 对类成员函数而言: 函数调用期间对象是否需要保持引用参数, 是否会释放这些参数.
    c. 函数是否分配了必须由调用者释放的空间.
    d. 参数是否可以为空指针.
    e. 是否存在函数使用上的性能隐患.
    f. 如果函数是可重入的, 其同步前提是什么?
  举例如下:
    // Returns an iterator for this table.  It is the clients
    // responsibility to delete the iterator when it is done with it,
    // and it must not use the iterator once the GargantuanTable object
    // on which the iterator was created has been deleted.
    //
    // The iterator is initially positioned at the beginning of the table.
    //
    // This method is equivalent to:
    //    Iterator* iter = table->NewIterator();
    //    iter->Seek("");
    //    return iter;
    // If you are going to immediately seek to another place in the
    // returned iterator, it will be faster to use NewIterator()
    // and avoid the extra seek.
    Iterator* GetIterator() const;
    
函数定义
  如果函数的实现过程中用到了很巧妙的方式, 那么在函数定义处应当加上解释性的注释.
}
style(变量注释){
总述
  通常变量名本身足以很好说明变量用途. 某些情况下, 也需要额外的注释说明.
类数据成员
  每个类数据成员 (也叫实例变量或成员变量) 都应该用注释说明用途.
全局变量
  和数据成员一样, 所有全局变量也要注释说明含义及用途, 以及作为全局变量的原因.
}
style(实现注释){
总述
  对于代码中巧妙的, 晦涩的, 有趣的, 重要的地方加以注释.

说明
  1. 代码前注释
    巧妙或复杂的代码段前要加注释. 比如:
    // Divide result by two, taking into account that x
    // contains the carry from the add.
    for (int i = 0; i < result->size(); i++) {
      x = (x << 8) + (*result)[i];
      (*result)[i] = x >> 1;
      x &= 1;
    }
  
  2. 行注释
    比较隐晦的地方要在行尾加入注释. 在行尾空两格进行注释. 比如:
    // If we have enough memory, mmap the data portion too.
    mmap_budget = max<int64>(0, mmap_budget - index_->length());
    if (mmap_budget >= data_size_ && !MmapData(mmap_chunk_bytes, mlock))
      return;  // Error already logged.
    注意, 这里用了两段注释分别描述这段代码的作用, 和提示函数返回时错误已经被记入日志.
  
  3. 如果你需要连续进行多行注释, 可以使之对齐获得更好的可读性:
    DoSomething();                  // Comment here so the comments line up.
    DoSomethingElseThatIsLonger();  // Two spaces between the code and the comment.
    { // One space before comment when opening a new scope is allowed,
      // thus the comment lines up with the following comments and code.
      DoSomethingElse();  // Two spaces before line comments normally.
    }
    std::vector<string> list{
                        // Comments in braced lists describe the next element...
                        "First item",
                        // .. and should be aligned appropriately.
    "Second item"};
    DoSomething(); /* For trailing block comments, one space is fine. */
}
style(函数参数注释){
函数参数注释
如果函数参数的意义不明显, 考虑用下面的方式进行弥补:
    如果参数是一个字面常量, 并且这一常量在多处函数调用中被使用, 用以推断它们一致, 你应当用一个常量名让这一约定变得更明显, 并且保证这一约定不会被打破.
    考虑更改函数的签名, 让某个 bool 类型的参数变为 enum 类型, 这样可以让这个参数的值表达其意义.
    如果某个函数有多个配置选项, 你可以考虑定义一个类或结构体以保存所有的选项, 并传入类或结构体的实例. 这样的方法有许多优点, 例如这样的选项可以在调用处用变量名引用, 这样就能清晰地表明其意义. 同时也减少了函数参数的数量, 使得函数调用更易读也易写. 除此之外, 以这样的方式, 如果你使用其他的选项, 就无需对调用点进行更改.
    用具名变量代替大段而复杂的嵌套表达式.
    万不得已时, 才考虑在调用点用注释阐明参数的意义.
    
    // Find the element in the vector.  <-- 差: 这太明显了!
    auto iter = std::find(v.begin(), v.end(), element);
    if (iter != v.end()) {
    Process(element);
    }
    
    和这样的注释:
    
    // Process "element" unless it was already processed.
    auto iter = std::find(v.begin(), v.end(), element);
    if (iter != v.end()) {
    Process(element);
    }
}
style(TODO 注释){
  对那些临时的, 短期的解决方案, 或已经够好但仍不完美的代码使用 TODO 注释.
  TODO 注释要使用全大写的字符串 TODO, 在随后的圆括号里写上你的名字, 邮件地址, bug ID, 
或其它身份标识和与这一 TODO 相关的 issue. 主要目的是让添加注释的人 (也是可以请求提供更多细节的人) 
可根据规范的 TODO 格式进行查找. 添加 TODO 注释并不意味着你要自己来修正, 因此当你加上带有姓名的 
TODO 时, 一般都是写上自己的名字.
    // TODO(kl@gmail.com): Use a "*" here for concatenation operator.
    // TODO(Zeke) change this to use relations.
    // TODO(bug 12345): remove the "Last visitors" feature
  如果加 TODO 是为了在 “将来某一天做某事”, 可以附上一个非常明确的时间 “Fix by November 2005”), 
或者一个明确的事项 (“Remove this code when all clients can handle XML responses.”).
}
style(弃用注释){
总述
  通过弃用注释（DEPRECATED comments）以标记某接口点已弃用.
  您可以写上包含全大写的 DEPRECATED 的注释, 以标记某接口为弃用状态. 注释可以放在接口声明前, 或者同一行.
  在 DEPRECATED 一词后, 在括号中留下您的名字, 邮箱地址以及其他身份标识.
}
第十章 格式
style(行长度){
每一行代码字符数不超过 80.
包含长路径的 #include 语句可以超出80列.
}
style(非 ASCII 字符){
尽量不使用非 ASCII 字符, 使用时必须使用 UTF-8 编码.
}
style(空格还是制表位){
只使用空格, 每次缩进 2 个空格.
}
style(函数声明与定义){
返回类型和函数名在同一行, 参数也尽量放在同一行, 如果放不下就对形参分行, 分行方式与 函数调用 一致.

1. 函数看上去像这样:
ReturnType ClassName::FunctionName(Type par_name1, Type par_name2) {
  DoSomething();
  ...
}
2. 如果同一行文本太多, 放不下所有参数:
ReturnType ClassName::ReallyLongFunctionName(Type par_name1, Type par_name2,
                                             Type par_name3) {
  DoSomething();
  ...
}
3. 甚至连第一个参数都放不下:
ReturnType LongClassName::ReallyReallyReallyLongFunctionName(
    Type par_name1,  // 4 space indent
    Type par_name2,
    Type par_name3) {
  DoSomething();  // 2 space indent
  ...
}

注意以下几点:
    使用好的参数名.
    只有在参数未被使用或者其用途非常明显时, 才能省略参数名.
    如果返回类型和函数名在一行放不下, 分行.
    如果返回类型与函数声明或定义分行了, 不要缩进.
    左圆括号总是和函数名在同一行.
    函数名和左圆括号间永远没有空格.
    圆括号与参数间没有空格.
    左大括号总在最后一个参数同一行的末尾处, 不另起新行.
    右大括号总是单独位于函数最后一行, 或者与左大括号同一行.
    右圆括号和左大括号间总是有一个空格.
    所有形参应尽可能对齐.
    缺省缩进为 2 个空格.
    换行后的参数保持 4 个空格的缩进.
    
4. 未被使用的参数, 或者根据上下文很容易看出其用途的参数, 可以省略参数名:
    class Foo {
     public:
      Foo(Foo&&);
      Foo(const Foo&);
      Foo& operator=(Foo&&);
      Foo& operator=(const Foo&);
    };

5. 未被使用的参数如果其用途不明显的话, 在函数定义处将参数名注释起来:
    class Shape {
     public:
      virtual void Rotate(double radians) = 0;
    };
    
    class Circle : public Shape {
     public:
      void Rotate(double radians) override;
    };
    
    void Circle::Rotate(double /*radians*/) {}

6. // 差 - 如果将来有人要实现, 很难猜出变量的作用.
    void Circle::Rotate(double) {}

7. 属性, 和展开为属性的宏, 写在函数声明或定义的最前面, 即返回类型之前:
    MUST_USE_RESULT bool IsOK();
}
style(函数调用){
  要么一行写完函数调用, 要么在圆括号里对参数分行, 要么参数另起一行且缩进四格. 
如果没有其它顾虑的话, 尽可能精简行数, 比如把多个参数适当地放在同一行里.

1. 函数调用遵循如下形式：
bool retval = DoSomething(argument1, argument2, argument3);
2. 如果同一行放不下, 可断为多行, 后面每一行都和第一个实参对齐, 左圆括号后和右圆括号前不要留空格：
bool retval = DoSomething(averyveryveryverylongargument1,
                          argument2, argument3);
3. 参数也可以放在次行, 缩进四格：
if (...) {
  ...
  ...
  if (...) {
    DoSomething(
        argument1, argument2,  // 4 空格缩进
        argument3, argument4);
  }
把多个参数放在同一行以减少函数调用所需的行数, 除非影响到可读性.
  
}
style(列表初始化格式){
您平时怎么格式化函数调用, 就怎么格式化 列表初始化.
}
style(条件语句){
  倾向于不在圆括号内使用空格. 关键字 if 和 else 另起一行.
  
  1. 注意所有情况下 if 和左圆括号间都有个空格. 右圆括号和左大括号之间也要有个空格:
    if(condition)     // 差 - IF 后面没空格.
    if (condition){   // 差 - { 前面没空格.
    if(condition){    // 变本加厉地差.
    
    if (condition) {  // 好 - IF 和 { 都与空格紧邻.

  2. 如果能增强可读性, 简短的条件语句允许写在同一行. 只有当语句简单并且没有使用 else 子句时使用:
    if (x == kFoo) return new Foo();
    if (x == kBar) return new Bar();
    
    如果语句有 else 分支则不允许:
    
    // 不允许 - 当有 ELSE 分支时 IF 块却写在同一行
    if (x) DoThis();
    else DoThat();
    
  3. 通常, 单行语句不需要使用大括号, 如果你喜欢用也没问题; 
复杂的条件或循环语句用大括号可读性会更好. 也有一些项目要求 if 必须总是使用大括号:
    if (condition)
    DoSomething();  // 2 空格缩进.
    
    if (condition) {
    DoSomething();  // 2 空格缩进.
    }

  4. 但如果语句中某个 if-else 分支使用了大括号的话, 其它分支也必须使用:
    // 不可以这样子 - IF 有大括号 ELSE 却没有.
    if (condition) {
    foo;
    } else
    bar;
    
    // 不可以这样子 - ELSE 有大括号 IF 却没有.
    if (condition)
    foo;
    else {
    bar;
    }

    // 只要其中一个分支用了大括号, 两个分支都要用上大括号.
    if (condition) {
      foo;
    } else {
      bar;
    }
}
style(循环和开关选择语句){
总述
  switch 语句可以使用大括号分段, 以表明 cases 之间不是连在一起的. 在单语句循环里, 括号可用可不用. 
空循环体应使用 {} 或 continue.

1. 如果有不满足 case 条件的枚举值, switch 应该总是包含一个 default 匹配 (如果有输入值没有 
case 去处理, 编译器将给出 warning). 如果 default 应该永远执行不到, 简单的加条 assert:
    switch (var) {
    case 0: {  // 2 空格缩进
        ...      // 4 空格缩进
        break;
    }
    case 1: {
        ...
        break;
    }
    default: {
        assert(false);
    }
    }

2. 在单语句循环里, 括号可用可不用：
    for (int i = 0; i < kSomeNumber; ++i)
    printf("I love you\n");
    
    for (int i = 0; i < kSomeNumber; ++i) {
    printf("I take it back\n");
    }

3. 空循环体应使用 {} 或 continue, 而不是一个简单的分号.
    while (condition) {
    // 反复循环直到条件失效.
    }
    for (int i = 0; i < kSomeNumber; ++i) {}  // 可 - 空循环体.
    while (condition) continue;  // 可 - contunue 表明没有逻辑.
    
    while (condition);  // 差 - 看起来仅仅只是 while/loop 的部分之一.
}
style(布尔表达式){
总述
  如果一个布尔表达式超过 标准行宽, 断行方式要统一一下.
说明
  下例中, 逻辑与 (&&) 操作符总位于行尾:
    if (this_one_thing > this_other_thing &&
        a_third_thing == a_fourth_thing &&
        yet_another && last_one) {
    ...
    }
注意, 上例的逻辑与 (&&) 操作符均位于行尾. 这个格式在 Google 里很常见, 虽然把所有操作符放在开头也可以.
}
style(函数返回值){
总述
  不要在 return 表达式里加上非必须的圆括号.

说明
  只有在写 x = expr 要加上括号的时候才在 return expr; 里使用括号.
    return result;                  // 返回值很简单, 没有圆括号.
    // 可以用圆括号把复杂表达式圈起来, 改善可读性.
    return (some_long_condition &&
            another_condition);
    
    return (value);                // 毕竟您从来不会写 var = (value);
    return(result);                // return 可不是函数！
}
style(变量及数组初始化){
您可以用 =, () 和 {}, 以下的例子都是正确的：
    int x = 3;
    int x(3);
    int x{3};
    string name("Some Name");
    string name = "Some Name";
    string name{"Some Name"};
  请务必小心列表初始化 {...} 用 std::initializer_list 构造函数初始化出的类型. 
非空列表初始化就会优先调用 std::initializer_list, 不过空列表初始化除外, 
后者原则上会调用默认构造函数. 为了强制禁用 std::initializer_list 构造函数, 请改用括号.
}
style(预处理指令){
预处理指令不要缩进, 从行首开始.
即使预处理指令位于缩进代码块中, 指令也应从行首开始.

// 好 - 指令从行首开始
    if (lopsided_score) {
    #if DISASTER_PENDING      // 正确 - 从行首开始
        DropEverything();
    # if NOTIFY               // 非必要 - # 后跟空格
        NotifyClient();
    # endif
    #endif
        BackToNormal();
    }

// 差 - 指令缩进
    if (lopsided_score) {
        #if DISASTER_PENDING  // 差 - "#if" 应该放在行开头
        DropEverything();
        #endif                // 差 - "#endif" 不要缩进
        BackToNormal();
    }
}
style(水平留白){
水平留白的使用根据在代码中的位置决定. 永远不要在行尾添加没意义的留白.
}
style(垂直留白){
垂直留白越少越好.

1. 这不仅仅是规则而是原则问题了: 不在万不得已, 不要使用空行. 尤其是: 两个函数定义之间的空行
   不要超过 2 行, 函数体首尾不要留空行, 函数体中也不要随意添加空行.
2. 基本原则是: 同一屏可以显示的代码越多, 越容易理解程序的控制流. 当然, 过于密集的代码块和过于
   疏松的代码块同样难看, 这取决于你的判断. 但通常是垂直留白越少越好.
下面的规则可以让加入的空行更有效:
    函数体内开头或结尾的空行可读性微乎其微.
    在多重 if-else 块里加空行或许有点可读性.
}
