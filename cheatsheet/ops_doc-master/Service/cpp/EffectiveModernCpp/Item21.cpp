#include "stdafx.h"
#include "Item21.h"
#include <vector>
#include <memory>
#include "ClassHierarchy.h"

using std::cout;
using std::endl;
using std::unique_ptr;
using std::make_unique;
using std::shared_ptr;
using std::make_shared;
using std::vector;

int prepSth(void)
{ return 0; }

void doSth(shared_ptr<ClassBase> pSrd, int prepSthResult)
{ }


Item21::Item21() :
  ItemBase("21")
{
}


Item21::~Item21()
{
}


void Item21::ItemEntry()
{
  //////// 倾向于使用make_xxx的3个原因：

  // 1. 使用make_xxx只写一遍ClassBase类名，建少代码内的重复。
  auto pMakeUnq(make_unique<ClassBase>());
  unique_ptr<ClassBase> pNewUnq(new ClassBase);
  auto pMakeSrd(make_shared<ClassBase>());
  shared_ptr<ClassBase> pNewSrd(new ClassBase);

  // 2. Exception safety
  // 考虑如下两种做法的区别

  // 用new时会有潜在的泄漏风险
  doSth(shared_ptr<ClassBase>(new ClassBase), prepSth());
  // 在进入doSth函数之前需要完成三件事：
  // a. 在堆上创建ClassBase实例
  // b. 调用shared_ptr构造函数，来管理指向堆的原始指针
  // c. 调用prepSth得到第二个参数的实际值
  // 编译器可以自由决定这三个步骤的执行顺序（当然new必须在shared_ptr构造函数之前执行）
  // 如果执行顺序为a->c->b，且在c执行时发生异常，b可能无法被执行到，
  // 导致堆上创建的实例并没有被智能指针管理到，产生泄漏

  // 如果用make_xxx
  doSth(make_shared<ClassBase>(), prepSth());
  // 之前的步骤1和2被合并为一步，就不用担心prepSeh里产生的异常导致泄漏
  // 但如果对象非常大，而且有weak_ptr指向时，如果用make_shared产生shared_ptr，
  // 则即使所有shared_ptr生命周期已经完结，但还有weak_ptr存在时，
  // 对象所占的空间也不会被释放。
  // 这种情况下用new的方式来产生的shared_ptr会先释放对象的空间，只要注意
  // 不要像这个例子一样，把从new对象创建shared_ptr的语句放在有类似副作用的语句里。
  // 比如先用单独的语句创建好shared_ptr，再把创建好的shared_ptr作为参数传递。

  // 3. 效率更优
  // 用make_xxx的情况下，make_xxx内部一次性为对象和control block分配堆上空间
  auto pHighEff = make_shared<ClassBase>();
  // 用new为参数的情况下，new语句在堆上分配对象的空间，
  // 在shared_ptr构造函数内为control block分配空间，
  // 总共两次空间分配。
  // 使用allocate_shared效率和make_shared相同。
  shared_ptr<ClassBase> pLowEff(new ClassBase);

  //////// 不能使用make_xxx的场景
  // unique有2个，shared有4个

  // 1. make_unique和make_shared不支持自定义deleter
  // 2. make_unique和make_shared只支持圆括号构造参数
  auto pConstParam = make_shared<vector<int>>(10, 20);
  // 相当于创建10个元素的vector，元素值都为20
  // 而不是创建两个元素的vector，第一个是10，第二个是20

  // 以下两条只针对shared_ptr
  // 3. 自定义重载new和delete时，可能和std::allocate_share及deleter不适配。
  //    一般自定义new和delete时，管理的内存为对象的大小，而不是对象+control block的总大小
  // 4. 如果创建大尺寸对象，且有长声明周期的weak_ptr时，用make_shared不能及时释放
  //    对象的空间。要改用new来创建对象并注意避免exception unsafe的情况。
}
