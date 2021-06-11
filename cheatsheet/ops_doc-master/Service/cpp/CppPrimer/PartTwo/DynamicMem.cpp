#include "stdafx.h"
#include "DynamicMem.h"
#include <memory>
#include <string>
#include <iostream>

using std::shared_ptr;
using std::unique_ptr;
using std::weak_ptr;
using std::make_shared;
using std::nothrow;
using std::string;
using std::allocator;
using std::cout;
using std::endl;

DynamicMem::DynamicMem()
{
}


DynamicMem::~DynamicMem()
{
}

void DynamicMem::DynamicMemTest(void)
{
    /*
        - 静态内存用来保存局部static对象、类static数据成员，以及定义在任何函数外的变量。
        - 栈内存用来保存定义在函数内的非static对象。
        静态内存和栈内存由编译器自动创建和销毁。

        - 堆（heap）或称自由空间（free store）用来存储动态分配的对象。
        动态分配的对象由程序在运行时分配，不再使用时由程序显式销毁。

        new运算符在堆中为对象分配空间并返回指向对象的指针
        delete运算符接受动态对象的指针，销毁改对象，释放与之关联的内存
    */
    int *intP1 = new int; // new无法为分配的对象命名，对象默认初始化，值未定义
    int *intP2 = new int(1234); // 直接初始化
    int *intP3 = new int(); // 值初始化为0
    int *intP4(new int(135));
    delete intP1; // 释放一块非new得到的内存，或将相同的内存释放多次，其行为未定义
    delete intP2;
    delete intP3;
    delete intP4;

    string strObj = string("StrObj");
    auto autoP = new auto(strObj); // autoP指向与strObj类型相同的对象，该对象用strObj初始化。只能有一个对象作为初始化器
    // auto illegalP = new auto{1, 2, 3}; // a brace-enclosed initializer list cannot be used in a new-expression whose type contains 'auto'
    delete autoP;

    const int *cIntP = new const int(321); // 动态分配const对象
    delete cIntP;

    int *memOkIntP = new int(0); // 如果分配失败，new会抛出std::bad_alloc
    int *memFailIntP = new (nothrow) int; // 如果分配失败，new返回一个空指针
    delete memOkIntP;
    delete memFailIntP;

    /* 
     * 动态数组
     * 实际上并不是得到数组，而是分配一片连续空间。不能调用数组的begin和end，或调用fangefor
     * delete时按逆序销毁
     */
    int *intAryP = new int[5]; // 数组大小必须是整数，但不必是常量，可以为0返回类似为后指针的非空指针但不能解引用
    delete[] intAryP;
    typedef int intAry[3]; // 用自定义类型别名来分配数组
    int *myIntAryP = new intAry;
    delete[] myIntAryP;

    int *intAryP1 = new int[5]; // 未初始化
    int *intAryP2 = new int[5](); // 值初始化为0
    int *intAryP3 = new int[5]{ 1,2,3,4,5 }; // 列表初始化
    int *intAryP4 = new int[5]{ 1,2,3 }; // 列表中未给定初值的进行值初始化
    delete[] intAryP1;
    delete[] intAryP2;
    delete[] intAryP3;
    delete[] intAryP4;
    
    /*
        C++ 11：智能指针（smart pointer）负责自动释放所指向的对象
        shared_ptr允许多个指针指向同一个对象
        unique_ptr独占指向的对象，同一时刻只能有一个unique_ptr指向给定对象
        weak_ptr是弱引用，指向shared_ptr所管理的对象，但不控制此对象的生存周期，绑定到shared_ptr不会改变shared_ptr的引用计数
        auto_ptr标准库早期智能指针，留作向后兼容用

        注意点：
        - 不要混合使用普通指针和智能指针
        - 不要用get初始化另一个智能指针或为智能指针赋值
        - 不使用相同的内置指针初始化或reset多个智能指针
        - 不delete get()返回的指针
        - 不使用get()初始化或reset另一个智能指针
        - 如果使用get()返回的指针，记住当最后一个对应的智能指针销毁后，指针就变无效了
        - 如果使用智能指针管理的资源不是new分配的内存，记住传递给它一个删除器

        shared_ptr和unique_ptr都支持的操作：
        shared_ptr<T> sp;       空智能指针，指向类型为T的对象
        unique_ptr<T> up;       
        p;                      将p作为条件判断，若p指向一个对象则为true
        *p;                     解引用，获得它指向的对象
        p->mem;                 等价于(*p).mem
        p.get();                返回p中保存的指针，若智能指针释放了其对象，返回的指针指向的对象也消失了
                                用途是需要向不能使用智能指针的代码传递一个内置指针
        swap(p, q);             交互p和q中的指针
        p.swap(q);

        shared_ptr独有的操作：
        make_shared<T>(args);   返回一个shared_ptr，指向一个动态分配的用args初始化的类型为T的对象
        shared_ptr<T>p(q);      如果q也是shared_ptr，则p是q的拷贝，递增q中的计数器，q中的指针必须能转换为T*
                                如果q是new创建的对象，q中的指针必须指向new得到的对象且能转换为T*
        shared_ptr<T>p(u);      p从unique_ptr u接管其对象所有权，将u置为空
        shared_ptr<T>p(q,d);    如果q是内置指针，p接管内置指针q所指向的对象所有权，q必须能转换为T*。p将调用对象d来代替delete
                                如果q是shared_ptr，p是q的拷贝，p可调用d来代替delete
        p.reset();              若p是唯一指向其对象的shared_ptr，释放此对象，将p置空
        p.reset(q);             q是内置指针，p指向q
        p.reset(q,d);           用d而不是delete来释放q
        p=q;                    p和q都是shared_ptr，其指针能相互转换。递减p的引用计数器，递增q的引用计数器，若p的引用计数器为0，则将其管理的原内存释放
        p.unique();             若p.use_count()为1，返回true；否则返回false
        p.use_count();          返回与p共享对象的智能指针数量。执行速度可能会很慢，主要用于调试

        unique_ptr独有的操作：
        unique_ptr<T> p;                    空unique_ptr，指向类型为T的对象，使用delete释放其指针
        unique_ptr<T, D> p;                 使用D释放指针
        unique_ptr<T, D> p(d);              用类型为D的对象d代替delete
        p = nullptr;                        释放u指向的对象，u置空
        u.release()                         u放弃对指针的控制权，返回指针，将u置空
        u.reset()                           释放u指向的对象
        u.reset(q)；                        令u指向内置指针q的对象
        u.reset(nullptr);                   将u置空

        unique_ptr<int> p(new int(42));     定义unique_ptr时绑定new返回的指针
        错误：unique_ptr<int> q(p);          unique_ptr不支持拷贝
        错误：unique_ptr<int> r; r = p;      unique_ptr不支持赋值
        unique_ptr<int> q(p.release());     把p指向的对象所有权转移给q，把p置空

        weak_ptr独有的操作：
        weak_ptr<T> w;          空weak_ptr，指向类型为T的对象
        weak_ptr<T> w(sp);      与shared_ptr sp指向相同对象的weak_ptr。T必须能转换为sp指向的类型。
        w = p;                  p可以为shared_ptr或weak_ptr
        w.reset();              w置为空
        w.use_count();          返回与w共享对象的shared_ptr数量
        w.expired();            若w.use_count()返回为0，返回true，否则返回false
        w.lock();               如果w.expired()返回为true，返回空shared_ptr，否则返回指向w的shared_ptr
    */
    shared_ptr<string> strShPtr = make_shared<string>(string("sharedPtr"));
    shared_ptr<int> intShPtr(new int(1)); // 用new得到的对象直接初始化，因为shared_ptr默认用delete释放其关联的对象，推荐用make_shared代替
    //shared_ptr<int> illIntShPtr = new int(0); // 不能把int*转换为shared_ptr<int>
    
    // 用unique_ptr管理动态数组
    unique_ptr<int[]> uniPtrIntAry(new int[5]);
    // 不能使用.和->操作
    uniPtrIntAry[0] = 123; //用下标运算符访问元素
    uniPtrIntAry.release(); // 自动用delete[]销毁
    
    // 用shared_ptr管理动态数组必须提供自定义删除器
    shared_ptr<int> shdPtrIntAry(new int[5], [](int *p) {delete[] p; }); // lambda释放数组
    shdPtrIntAry.reset();

    /*
       allocator类
       new同时进行对象分配和构造，delete同时进行对象析构和内存释放。allocator只分配内存，不创建对象。
       未construct时不能解引用

       allocator<T> a;      定义allocator对象，可以为类型T的对象分配内存
       a.allocate(n);       分配原始的未构造内存，保持n个类型为T的对象
       a.deallocate(p,n);   释放从p指针开始的，n个类型为T的对象，p必须是allocator返回的指针，n必须是p创建时的大小。
                            调用之前，必须对每个在这块内存中创建的对象调用destory
       a.construct(p, args);    p是类型为T*的指针，指向原始内存，args传递给类型为T的构造函数，用来在p指向的内存中构造一个对象
       a.destory(p);        对p指向的对象执行析构函数

       伴随算法：
       uninitialized_copy(b,e,b2);      从迭代器b和e指定的范围拷贝元素到迭代器b2指定的未构造原始内存中
       uninitialized_copy_n(b,n,b2);    从迭代器b开始，拷贝n个元素到b2开始的内存中
       uninitialized_fill(b,e,t);       在迭代器b和e指定的原始内存范围中创建对象，对象值均为t的拷贝
       uninitialized_fill_n(b,n,t);     在迭代器b指向的内存地址开始创建n个对象，值均为t的拷贝
     */
    allocator<string> allocStr; // allocator是模板，要指明对象类型。可以分配string的allocator对象。
    auto allocP = allocStr.allocate(3); // 分配3个为初始化的string
    auto allocHead = allocP;
    allocStr.construct(allocP++, "hello");
    allocStr.construct(allocP++, 10, 'c');
    cout << "first: " << *allocHead << " second: " << *(allocHead+1) << endl;
    while (allocHead != allocP)
    { allocStr.destroy(--allocP); } // 释放构造的string，只能对构造过的对象destory
    allocStr.deallocate(allocHead, 3);
}
