#include "stdafx.h"
#include "StdLibContainer.h"
#include "Common/CommonUtils.h"
#include <string>
#include <vector>
#include <deque>
#include <list>
#include <forward_list>
#include <array>
#include <iostream>
#include <stack>
#include <queue>
#include <functional>
#include <iterator>
#include <map>
#include <set>
#include <unordered_map>
#include <unordered_set>
#include <utility>

using std::cin;
using std::cout;
using std::endl;
using std::vector;
using std::string;
using std::deque;
using std::list;
using std::forward_list;
using std::array;
using std::to_string;
using std::stoi;
using std::stol;
using std::stoul;
using std::stoll;
using std::stoull;
using std::stof;
using std::stod;
using std::stold;
using std::stack;
using std::queue;
using std::priority_queue;
using std::back_inserter;
using std::front_inserter;
using std::inserter;
using std::istream_iterator;
using std::ostream_iterator;
using namespace std::placeholders;
using std::map;
using std::set;
using std::multimap;
using std::multiset;
using std::pair;
using std::make_pair;

StdLibContainer::StdLibContainer()
{
}

StdLibContainer::StdLibContainer(int initData)
{
    data = initData;
}

StdLibContainer::~StdLibContainer()
{
}

void StdLibContainer::testContainer(void)
{
    // 容器：特定类型对象的集合
    // STL: Standard Template Library.
    // C++标准库中的容器(vector, list, ...)、iterator(vector<int>::iterator, ...)、算法(for_each, find, sort, ...)、相关功能的库
    // 顺序容器：提供控制元素存储和访问顺序的能力顺序与元素加入容器时的位置对应

    //// 各种顺序容器类型
    // vector 可变大小数组，支持快速随机访问，尾部之外插入或删除元素可能很慢
    // string 与vector相似，专门用于保存字符，随机访问快，在尾部插入或删除速度快
    // deque 双端队列，支持快速随机访问，头尾插入或删除很快
    // list 双向链表，只支持双向顺序访问，任何位置插入或删除都很快
    // forward_list 单项链表，只支持单项顺序访问，任何位置插入或删除都很快
    // array 固定大小数组，支持快速随机访问，不能添加或删除元素

    // string和vector的元素保存在连续的内存空间，所以用下标计算地址非常快。
    // 但在中间位置插入或删除时，需要移动后面所有元素来保持连续，
    // 添加元素还可能需要分配额外的存储空间并移动所有元素，所以很耗时。

    // list和forward_list是链表，所以在任意位置添加和删除都很快。
    // 但不支持随机访问，要访问元素必须遍历链表。
    // 和vector、deque、array比，需要额外的内存开销。
    // forward_list没有size操作，为了节省保存或计算大小的额外开销。

    // deque与string和vector类似，支持快速随机访问，但中间位置添加或删除元素代价可能很高。
    // 在两端添加或删除元素速度很快，与list和forward_list速度相当

    // array大小固定，不支持添加或删除，但比内置数组安全、容易使用。

    //// 选择容器的规则
    // - 除非用很好的理由选择其他容器，否则使用vector
    // - 有很多小元素，空间的额外开销很重要，则不要使用list或forward_list
    // - 要求随机访问元素时，使用vector或deque
    // - 要求在中间插入或删除元素，使用list或forward_list
    // - 只在头尾插入或删除元素，使用deque
    // - 如果输入时需要在中间插入元素，随后需要随机访问，可以先用list，再把list的内容拷贝到vector

    vector<char> charVector{ 'a', 'b', 'c' };
    string charString("4 5 6"); 
    deque<char> charDeque = { '7', '8', '9' };
    list<char> charList{ '0', 'a', 'b' };
    forward_list<char> charFarwardList = { 'c', 'd', 'e' };
    array<char, 3> charArray{ 'f', 'g', 'h' }; // array除了指定类型外，还要指定容器大小

    //// 容器操作
    /*
        ****类型别名****
        iterator                某容器类型的迭代器类型
        const_iterator          可以读取元素但不能修改元素的迭代器类型
        size_type               无符号整数，足够保存某容器类型最大的容量大小，是容器的伴随类型，使得容器容量类型与机器无关
        difference_type         有符号整数，足够保存两个迭代器之间的距离
        value_type              元素类型
        reference               元素的左值类型，与value_type&含义相同
        const_reference         元素的const左值类型，即const value_type&
        ****构造函数****
        C c;                    默认构造函数，构造空容器
        C c1(c2);               构造c2的拷贝c1。array可拷贝，但内置数组类型不能拷贝。
        C c1 = c2;              同上，赋值后c1的size变为c2的size
        C c(b, e);              构造c，将迭代器b（第一个拷贝的元素位置）和e（拷贝的最后一个元素之后的位置）指定范围的元素拷贝到c，类型相容即可，不需相同（array不支持）
        C c{a, b, c...};        C++11列表初始化c
        C c = {a, b, c...};     C++11同上，赋值后c1的size变为c2的size
        C c(n);                 顺序容器（array除外）包含n个元素，进行值初始化。此构造函数是explicit的。
        C c(n, t);              同上，但初始化为t
        ****大小****
        c.size();               c中元素数目（不支持forward_list）
        c.max_size();           c可保存的最大元素数目
        c.empty();              若c中存储了元素，返回false；否则返回true
    */
    /*
        ****赋值与swap****
        c1 = c2;                将c1中的元素替换为c2
        c1 = {a, b, c...};      将c1中的元素替换为列表中元素（原书第五版提示array不支持，VS2017支持）
                                *对array进行swap，耗时和array元素数量成正比，因为实际交换元素
                                *对其他容器进行swap，速度很快为线性时间，因为不是拷贝元素而是交换了两个容器的内部数据结构
        a.swap(b);              交换a和b的元素，早期版本之提供此类型
        swap(a, b);             与a.swap(b)等价，在范性编程中很重要，建议使用此种非成员版本的swap
                                *assign用于类型不同但相容的赋值，或用子序列赋值。不适用于关联容器和array
        seq.assign(b, e);       将seq的元素替换为迭代器b和e所表示范围内的元素，迭代器b和e不能指向seq的元素（因为旧元素会被替换）
        seq.assign(il);         将seq的元素替换为初始化列表il中的元素
        seq.assign(n, t);       将seq的元素替换为n个值为t的元素
    */
    // 注意赋值操作会导致容器内部的迭代器、引用、指针失效
    vector<int> vectorInt10 = { 0,1,2,3,4,5,6,7,8,9 };
    vector<int> vectorInt5 = { 4,3,2,1,0 };
    cout << "vectorInt10 size [" << vectorInt10.size() << "] " <<
        "vectorInt5 size [" << vectorInt5.size() << "]" << endl;
    vectorInt10 = vectorInt5; // 不同大小的容器赋值，左边的容器大小变为右边容器大小
    cout << "vectorInt10 size [" << vectorInt10.size() << "] " <<
        "vectorInt5 size [" << vectorInt5.size() << "]" << endl;

    array<int, 10> aryInt10 = { 0,1,2,3,4,5,6,7,8,9 };
    array<int, 10> aryInt10Another = { 9,8,7,6,5,4,3,2,1,0 };
    array<int, 5> aryInt5 = { 4,3,2,1,0 };
    //aryInt10 = aryInt5; // array赋值必须类型相同
    aryInt10 = aryInt10Another; // 类型相同，可以赋值
    cout << "before " << aryInt5[0] << aryInt5[1] << aryInt5[2] << aryInt5[3] << aryInt5[4] << endl;
    aryInt5 = { 1,2 };
    cout << "after " << aryInt5[0] << aryInt5[1] << aryInt5[2] << aryInt5[3] << aryInt5[4] << endl;

    CommonUtils::showSeperator();

    /*
        ****关系运算符****
        *运算符两边的容器必须类型相同，元素类型相同
        ==, !=                  所有容器都支持
        <, <=, >, >=            关系运算符，无序关联容器不支持
                                比较规则：
                                - 两个容器大小相同且所有元素亮亮对应相等，则容器相等；否则不等
                                - 两个容器大小不同，较小容器中每个元素都等于较大容器中对应元素，则较小容器小于较大容器
                                - 两个容器都不是另一个容器的前缀子序列，则比较结果取决于第一个不相等的元素比较结果
    */
    vector<int> vector1 = { 1,3,5,7,9,12 };
    vector<int> vector2 = { 1,3,9 };
    vector<int> vector3 = { 1,3,5,7 };
    vector<int> vector4 = { 1,3,5,7,9,12 };
    cout << "vector1 < vector2: " << ((vector1 < vector2) ? "true" : "false") << endl; // 结果取决于元素[2]
    cout << "vector1 < vector3: " << ((vector1 < vector3) ? "true" : "false") << endl; // 元素都相等，vector3元素数量少
    cout << "vector1 == vector4: " << ((vector1 == vector4) ? "true" : "false") << endl; //大小相同，元素相等
    cout << "vector1 == vector2: " << ((vector1 == vector2) ? "true" : "fasle") << endl; // vector2元素数量少

    CommonUtils::showSeperator();

    /*
    ****获取迭代器****
    c.begin(); c.end();     返回指向c的首元素和尾元素之后位置的迭代器iterator
    c.cbegin(); c.cend();   返回const_iterator
    ****反向容器的额外成员（不支持forward_list）****
    reverse_iterator        按逆序寻址元素的反向迭代器，++得到上一个元素
    const_reverse_iterator  不能修改元素的反向迭代器
    c.rbegin(); c.rend();   返回指向c的尾元素和首元素之前为止的反向迭代器reverse_iterator
    c.crbegin(); c.crend(); 返回const_reverse_iterator
    ****顺序容器特有****
    顺序容器都有front()成员函数，返回首元素的引用
    顺序容器除了forward_list外都有back()成员函数，返回尾元素的引用
    at和下标操作只使用于string、vector、deque和array，返回引用
    编译器不检查下标越界，at()越界会抛出out_of_range异常
    */
    vector<string> strVector = { string("first"),string("second"),string("third") };
    cout << "begin(): " << *strVector.begin() << " end(): " << *(strVector.end()-1) << endl; // end()返回末尾元素后一位置
    cout << "front(): " << strVector.front() << " back(): " << strVector.back() << endl;
    cout << "at(1): " << strVector.at(1) << endl;
    strVector[1] = "2nd";
    cout << "[1]: " << strVector[1] << endl;
    cout << "rangefor: ";
    for (string str : strVector)
    {
        cout << str << " ";
    }
    cout << endl;

    CommonUtils::showSeperator();

    /*
        ****所有容器都支持的添加删除元素（不适用不能改变大小的array）****
        c.insert(args);         将args中元素拷贝进c
        c.emplace(inits);       使用inits构造c中的一个元素
        c.erase(args);          删除args指定的元素
        c.clear();              删除c中所有元素，返回void
        ****顺序容器特有的添加删除操作****
        *插入是拷贝操作，插入的是副本
        *vector和string的元素连续存储
        *在vector或string尾部之外的任何位置，或deque首尾之外的任何位置添加元素，都需要移动元素
        *向vector或string添加元素可能引起整个对象存储空间的重新分配
        *插入操作vector，string之后，如重新分配空间则迭代器、引用、指针全部失效；如未重新分配，则插入位置之后的会失效
        *插入操作deque之后，插入到首尾之外的位置会使所有迭代器、引用和指针失效；插入到首尾位置，迭代器会失效，引用和指针不会失效
        *插入操作list，forward_list之后，迭代器、指针、引用都有效
        *删除操作deque之后，删除首尾元素之外的任何元素都会使所有迭代器、引用和指针失效；删除尾元素则尾后迭代器失效；删除首元素不会失效
        *删除操作vector，string之后，删除点之后位置的迭代器、引用和指针都会失效
        *删除操作list，forward_list之后，迭代器、引用、指针都有效
        *vector和string不支持push_front、emplace_front和pop_front
        c.push_back(t);         在c的尾部创建值t元素，返回void，t为元素类型的对象
        c.emplace_back(args);   C++11，在c的尾部创建由args创建的元素，args为元素构造函数的参数
        c.push_front(t);        在c的头部创建值t元素，返回void
        c.emplace_front(args);  C++11，在c的头部创建值为t或由args创建的元素
        c.insert(p,t);          在c的迭代器p指向的元素之前添加t元素，返回指向新添加元素的迭代器
        c.emplace(p,args);      C++11，在c的迭代器p指向的元素之前添加由args创建的元素
        c.insert(p,n,t);        在c的迭代器p指向的元素之前添加n个值为t的元素，返回指向新添加的第一个元素的迭代器。若n为0，返回p
        c.insert(p,b,e);        将b和e迭代器指定范围内的元素插入到迭代器p指向的元素之前，b和e不能指向c。返回指向新添加的第一个元素的迭代器。若范围为空，返回p
        c.insert(p,il);         il是花括号包围的元素值列表，插入到迭代器p指向的元素之前，返回指向新添加的第一个元素的迭代器。若il为空，返回p
        c.pop_back();           删除c的尾元素，返回void
        c.pop_front();          删除c的首元素，返回void
        c.erase(p);             删除p迭代器指定的元素，返回被删元素之后的元素迭代器
        c.erase(b,e);           删除b和e所指范围内的元素，返回指向最后一个被删元素之后的元素迭代器
        c.clear();              删除c中所有元素，返回void
        *forward_list有自己的insert、emplace和erase
        *forward_list不支持push_back、emplace_back和pop_back
        *forward_list的特殊操作: forward_list是单向链表，其添加删除是在给定迭代器之后操作
        lst.before_begin();     返回指向链表首元素之前不存在的元素的迭代器，此迭代器不能解引用
        lst.cbefore_begin();    返回const_iterator
        lst.insert_after(p,t);  在迭代器p之后插入元素，返回指向插入元素的迭代器
        lst.insert_after(p,n,t);在迭代器p之后插入n个t对象，返回指向最后一个插入元素的迭代器
        lst.insert_after(p,b,e);把b和e指定范围的对象插入到迭代器p之后，b和e不能指向lst，如果范围为空，返回p
        lst.insert_after(p,il); 把花括号列表对象插入到迭代器p之后
        lst.emplace_after(p, args); 使用args在p指定的位置之后创建一个元素，返回指向新元素的迭代器
        lst.erase_after(p);     删除p指向的位置之后的元素，返回被删元素之后元素的迭代器
        lst.erase_after(b,e);   删除b和e指定范围内的元素
    */
    deque<char> cDeque = { '1', '2', '3' };
    cout << "Initial deque: ";
    for (char c : cDeque) { cout << c << " "; } cout << endl;

    cDeque.pop_back();
    cout << "pop_back: ";
    for (char c : cDeque) { cout << c << " "; } cout << endl; 

    cDeque.pop_front();
    cout << "pop_front: ";
    for (char c : cDeque) { cout << c << " "; } cout << endl;

    cDeque.push_back('C');
    cout << "push_back: ";
    for (char c : cDeque) { cout << c << " "; } cout << endl;

    cDeque.emplace_front('A');
    cout << "emplace_front: ";
    for (char c : cDeque) { cout << c << " "; } cout << endl;

    deque<char>::iterator itr = cDeque.end() - 2;
    itr = cDeque.erase(itr);
    cout << "erase: ";
    for (char c : cDeque) { cout << c << " "; } cout << endl;

    cDeque.insert(itr, 'B');
    cout << "insert: ";
    for (char c : cDeque) { cout << c << " "; } cout << endl;

    cDeque.clear();
    cout << "clear: ";
    for (char c : cDeque) { cout << c << " "; } cout << endl;

    CommonUtils::showSeperator();

    /*
        ****改变容器大小（不适用不能改变大小的array）****
        *缩小容器会删除尾部元素，扩大容器在尾部添加元素
        *resize只删除元素改变size()，不改变capacity()对应的内存空间
        c.resize(n);    改变c大小为n
        c.resize(n, t); 改变c大小为n，扩大时添加的元素初始化为t
        *shrink_to_fit只适用于vector、string、deque
        *capacity和reserve只适用于vector和string
        c.shrink_to_fit();  将capacity()减少为与sizeof()同样大小，依赖于具体实现，不保证释放内存
        c.capacity();       不重新分配内存空间的话，c可以保存多少元素
        c.reserve(n);       分配至少能容纳n个元素的内存空间
    */
    vector<char> cVector = { '1','2','3' };
    cout << "Initial: ";
    for (char c : cVector) { cout << c << " "; } cout << endl;
    cout << "Size: " << cVector.size() << " Capacity: " << cVector.capacity() << endl;

    cVector.resize(1);
    cout << "resize small: ";
    for (char c : cVector) { cout << c << " "; } cout << endl;
    cout << "Size: " << cVector.size() << " Capacity: " << cVector.capacity() << endl;

    cVector.resize(3);
    cout << "resize large: ";
    for (char c : cVector) { cout << c << " "; } cout << endl;
    cout << "Size: " << cVector.size() << " Capacity: " << cVector.capacity() << endl;

    cVector.resize(5, 'L');
    cout << "resize large init: ";
    for (char c : cVector) { cout << c << " "; } cout << endl;
    cout << "Size: " << cVector.size() << " Capacity: " << cVector.capacity() << endl;

    cVector.reserve(10);
    cout << "reserve: ";
    for (char c : cVector) { cout << c << " "; } cout << endl;
    cout << "Size: " << cVector.size() << " Capacity: " << cVector.capacity() << endl;

    cVector.shrink_to_fit();
    cout << "shrink: ";
    for (char c : cVector) { cout << c << " "; } cout << endl;
    cout << "Size: " << cVector.size() << " Capacity: " << cVector.capacity() << endl;

    CommonUtils::showSeperator();

    /*
        ****string相关****
    */
    // 构造函数
    string s1; //默认构造函数
    cout << "s1: " << s1 << endl;
    string s2 = s1; //S2是S1的副本
    cout << "s2: " << s2 << endl;
    string s3 = "hello"; //s3是字面值的副本
    cout << "s3: " << s3 << endl;
    string s4(5, 'c'); //s4的内容是ccccc
    cout << "s4: " << s4 << endl;
    char charAry[] = "test";
    string s5(charAry, 2);   //s5是s3前2个字符的拷贝
    cout << "s5: " << s5 << endl;
    string s6(s3, 2); //s6是s3从下标2开始的字符的拷贝
    cout << "s6: " << s6 << endl;
    string s7(s3, 1, 3); //s7是s3从下标1开始的长度位3的字符拷贝
    cout << "s7: " << s7 << endl;

    CommonUtils::showSeperator();

    /*
        substr(pos, n);         返回string，包含从pos开始的n个字符的拷贝
        *string支持容器的assign、insert、erase操作，还提供基于下标的insert和erase
        s.insert(pos, args);    在pos之前插入args指定的字符。pos可以是下标（返回指向s的引用）或迭代器（返回指向第一个插入字符的迭代器）。
        s.erase(pos, len);      删除从位置pos开始的len个字符。如省略len则删到末尾。返回指向s的引用
        s.assign(args);         将s的字符替换为args指定的字符，返回指向s的引用
        s.append(args);         将args追加到s，返回指向s的引用
        s.replace(range, args); 删除range内的字符，替换为args指定的字符。range是一个下标和一个长度，或一对指向s的迭代器。返回指向s的引用。
        *搜索string
        s.find(args);           查找第一次出现的位置
        s.rfind(args);          查找最后一次出现的位置
        s.find_first_of(args);  查找args中任何一个字符第一次出现的位置
        s.find_last_of(args);   查找args中任何一个字符最后一次出现的位置
        s.find_first_not_of(args);  查找第一个不在args中的字符
        s.find_last_not_of(args);   查找最后一个不在args中的字符
        *比较string
        s.compare();            有六个版本
        *数值转换
        to_string(val);         返回任意算数类型val的string表示。
        *sto_(s,p,b);           返回s起始子串的数值；b为转换基数默认10；p是size_t指针保存s第一个非数组字符下标，默认为0表示不保存下标
        stoi(s,p,b);            返回int
        stol(s,p,b);            返回long
        stoul(s,p,b);           返回unsigned long
        stoll(s,p,b);           返回long long
        stoull(s,p,b);          返回unsigned long long
        stof(s,p);              返回float
        stod(s,p);              返回double
        stold(s,p);             返回long double
    */
    cout << "to_string(12345): " << to_string(12345) << endl;
    cout << "stoi(\"12345\"): " << stoi(string("12345")) << endl;
    cout << "stoi(\"010\"): " << stoi(string("010"), 0, 8) << endl;
    cout << "stoi(\"0x10\"): " << stoi(string("0x10"), 0, 16) << endl;
    cout << "stof(\"3.14\"): " << stof(string("3.14")) << endl;

    CommonUtils::showSeperator();

    /* 适配器adapter：一种机制，使某种事物的行为看起来像另一种事。
       顺序容器适配器：接受一种已有的容器类型，使其行为看起来像一种不同的类型，如stack适配器接受一个顺序容器，使其操作起来像stack一样
       标准库定义顺序容器的适配器：stack、queue、priority_queue
       *所有容器适配器都支持的操作和类型：
       size_type        一种类型，足以保存当前类型最大对象的大小
       value_type       元素类型
       container_type   实现适配器的底层容器类型
       A a;             创建空适配器
       A a(c);          用容器c的拷贝创建适配器
       关系运算符        每个适配器都支持关系运算符 == != < <= > >=，返回底层容器的比较结果
       a.empty();       a包含元素则返回false
       a.size();        返回a中元素数目
       swap(a,b);       交互a和b的内容，a和b必须类型相同，底层容器类型相同
       a.swap(b);       同上
       *重载适配器的默认容器类型
       *给定的适配器只能使用特定的类型，规则如下
       - 所有适配器都要求容器具有添加和删除元素的能力，所以适配器不能构造在array之上
       - 所有适配器还要求容器具有访问尾元素的能力，所以不能构造在forward_list之上
       - stack只要求push_back、pop_back和back操作，因此可以使用除array和forward_list之外的任何容器类型
         默认基于deque，可以在list和vector上实现
         s.pop();       删除栈顶元素但不返回该元素值
         s.push(item);  创建一个新元素压入栈顶，通过复制或移动item创建，或由args构造
         s.emplace(args);
         s.top();       返回栈顶元素，但不将元素弹出栈
       - queue要求back、push_back、front、push_front，因此可以构造与list和deque之上，但不能基于vector构造
         默认基于deque实现
         FIFO存储和访问
       - priority_queue除了front、push_back和pop_back之外还要求随机访问能力，因此可以构造与vector和queue之上，但不能基于list构造
         默认基于vector实现，也可用deque实现
         元素优先级高的排列在前面
         q.pop();       删除queue的首元素或priority_queue的最高优先级元素，但不返回此元素
         q.front();     返回首元素，但不删除此元素，只适用于queue
         q.back();      返回尾元素，但不删除此元素，只适用于queue
         q.top();       返回最高优先级元素，但不删除此元素，只适用于priority_queue
         q.push(item);  在queue的末尾或priority_queue中恰当的位置创建一个元素，其值为item或由args构造
         q.emplace(args);
    */
    /* Stack 测试 */
    // 第二个类型参数重载适配器的默认容器类型
    stack<string, vector<string>> strStack;
    strStack.push(string("No.1"));
    strStack.emplace("No.2");
    while (!strStack.empty())
    {
        cout << strStack.top() << " ";
        strStack.pop();
    }
    cout << endl;

    CommonUtils::showSeperator();

    /* Queue 测试 */
    queue<int> intQueue;
    intQueue.push(1);
    intQueue.emplace(2);
    intQueue.push(3);
    cout << "before pop(), front(): " << intQueue.front() << " back(): " << intQueue.back() << endl;
    intQueue.pop();
    cout << "after  pop(), front(): " << intQueue.front() << " back(): " << intQueue.back() << endl;

    CommonUtils::showSeperator();

    /* Priority Queue 测试 TODO:目前使用的是默认的比较优先级函数 */
    priority_queue<int> intPrioQueue;
    intPrioQueue.push(1);
    intPrioQueue.emplace(5);
    intPrioQueue.emplace(3);
    cout << "before pop(), top(): " << intPrioQueue.top() << endl;
    intPrioQueue.pop();
    cout << "after  pop(), top(): " << intPrioQueue.top() << endl;

    CommonUtils::showSeperator();

    /*
        关联容器associative container：元素按关键字来保存和访问。
        map和set是最基本的关联容器，其他关联容器不是基于map就是基于set
        关联容器的迭代器都是双向的

        有序保存元素的关联容器，关键字类型必须提供元素比较的方法以便排序，默认使用<运算符
        map：元素是关键字-值对（key-value），关键字唯一
        set：元素是关键字。支持高效关键字查询（关键字是否在set内），关键字唯一
        multimap：关键字可重复出现的map
        multiset：关键字可重复出现的set

        C++ 11: 无序的关联容器，用哈希函数组织而不是比较运算符
        unordered_map：
        unordered_set：
        unordered_multimap：
        unordered_multiset：
    */

    /* 标准库的pair类型
        pair的数据成员first和second为public

        pair<T1, T2> p;
        pair<T1, T2> p(v1, v2);         first和second分别用v1和v2初始化
        pair<T1, T2> p = {v1, v2};      同上
        make_pair(v1, v2);              返回用v1和v2初始化的pair，pair的类型从v1和v2的类型推断出来
        p.first;
        p.second;
        < <= > >= == !=                 按字典序定义
    */
    pair<string, int> strIntPair{ "hi", 123 };
    cout << "first: " << strIntPair.first << " second: " << strIntPair.second << endl;
    
    // 使用map
    map<string, size_t> wordCounter = { {"init", 123} }; // key-value初始化
    wordCounter["hello"]++; // 如果"hello"还不在map里，则创建一个新元素，关键字为"hello"，值为0。
    wordCounter["world"] += 2;
    for (const auto word : wordCounter)
    { cout << word.first << ":" << word.second << endl; }

    CommonUtils::showSeperator();

    // 使用set
    set<string> vocabulary = { "one", "two", "three" };
    cout << "\"one\" is ";
    (vocabulary.find("one") != vocabulary.end()) ? cout << "in " : cout << "NOT in ";
    cout << "the set" << endl;
    cout << "\"four\" is ";
    (vocabulary.find("four") != vocabulary.end()) ? cout << "in " : cout << "NOT in ";
    cout << "the set" << endl;

    CommonUtils::showSeperator();

    // 用vector来初始化set和multiset
    vector<string> strInitVector = { "hello", "hello", "world" }; // 包含重复的元素
    set<string> strSet(strInitVector.cbegin(), strInitVector.cend());
    multiset<string> strMulSet(strInitVector.cbegin(), strInitVector.cend());
    cout << "vector size: " << strInitVector.size() << endl;
    cout << "set size: " << strSet.size() << endl;
    cout << "multiset size: " << strMulSet.size() << endl;

    CommonUtils::showSeperator();

    /*
        关联容器特有的类型别名
        key_type        关键字类型
        mapped_type     值类型，仅适用于map
        value_type      容器的类型
                        对于set，与key_type相同
                        对于map，为pair<const key_type, mapped_type>。关键字不能改变，所以是const
    */
    set<string>::key_type setKeyType;
    set<string>::value_type setType;
    map<string, int>::key_type mapKeyType;
    map<string, int>::mapped_type mapValType;
    map<string, int>::value_type mapType;

    /*
        关联容器操作
        set的迭代器有iterator和const_iterator两种类型，但都是const的，因为不能改变key
        map的迭代器不能改变key，但可以改变value

        插入操作：
        c.insert(v);        v是value_type类型的对象。当关键字不在c中进行插入
                            返回pair，包含一个迭代器，指向插入关键字的元素，和一个表示插入是否成功的bool
                            对于multimap和multiset，总是插入，返回迭代器
        c.emplace(args);    用args来构造元素
        c.insert(b, e);     b和e是c::valye_type类型的迭代器
                            函数返回void。map和set只插入不在c中的元素，multimap和multiset插入所有的元素
        c.insert(il);       il是花括号的列表
        c.insert(p, v);     类似insert(v)和emplace(args)，但将迭代器p作为新元素存储的位置，返回指向插入元素的迭代器

        删除操作：
        c.erase(k);         从c中删除所有关键字为k的元素，返回size_type，表示删除的元素数量
        c.erase(p);         从c中删除迭代器p指向的元素，返回指向p之后元素的迭代器
        c.erase(b, e);      删除迭代器b和e范围中的元素，返回e
    */

    map<string, int> strIntMapInsert;
    pair<map<string, int>::iterator, bool> rtn;
    cout << "Empty map: ";
    for (const auto word : strIntMapInsert)
    { cout << word.first << ":" << word.second << " "; }
    cout << endl;
    cout << "Insert \"one\":1 ";
    rtn = strIntMapInsert.insert({ "one", 1 }); // 花括号初始化
    for (const auto word : strIntMapInsert)
    { cout << word.first << ":" << word.second << " " << "result " << rtn.second << " "; }
    cout << endl;
    cout << "Insert \"two\":2 ";
    rtn = strIntMapInsert.insert(make_pair("two", 2)); // make_pair构造pair对象
    for (const auto word : strIntMapInsert)
    { cout << word.first << ":" << word.second << " " << "result " << rtn.second << " "; }
    cout << endl;
    cout << "Insert \"two\":12 ";
    rtn = strIntMapInsert.insert(pair<string, int>("two", 12)); // 显式构造pair。相同的关键字插入，只有第一次插入的元素在容器里
    for (const auto word : strIntMapInsert)
    { cout << word.first << ":" << word.second << " " << "result " << rtn.second << " "; }
    cout << endl;
    cout << "Insert \"three\":3 ";
    rtn = strIntMapInsert.insert(map<string, int>::value_type( "three", 3 )); // 用value_type创建pair对象
    for (const auto word : strIntMapInsert)
    { cout << word.first << ":" << word.second << " " << "result " << rtn.second << " "; }
    cout << endl;

    CommonUtils::showSeperator();

    multimap<string, int> strIntMulMapDel = { {"one", 1}, {"one", 123}, {"two", 2} };
    cout << "Delete \"one\": ";
    cout << "deleted: " << strIntMulMapDel.erase("one") << endl;
    cout << "Delete \"one\" again: ";
    cout << "deleted: " << strIntMulMapDel.erase("one") << endl;
    
    CommonUtils::showSeperator();

    /*
    下标运算和at函数：
    map和unordered_map支持下标运算和at函数
    set不支持，因为用下表获得下标无意义
    multimap和unordered_multimap不能进行下标操作，因为可能有相同的下标

    c[k];           返回关键字为k的元素，如果k不在c中，则添加k并进行值初始化
    c.at[k];        返回关键字为k的元素，如果k不在c中，则抛出out_of_range异常
    */
    map<string, int> strIntMapAt = { {"one", 1}, {"two", 2} };
    cout << "Before at: ";
    for (const auto word : strIntMapAt)
    { cout << word.first << ":" << word.second << " "; }
    cout << endl;

    cout << "[\"two\"] " << strIntMapAt["two"] << ": ";
    for (const auto word : strIntMapAt)
    { cout << word.first << ":" << word.second << " "; }
    cout << endl;
    cout << "[\"three\"] " << strIntMapAt["three"] << ": ";
    for (const auto word : strIntMapAt)
    { cout << word.first << ":" << word.second << " "; }
    cout << endl;

    cout << "at(\"two\"): " << strIntMapAt.at("two") << ": ";
    for (const auto word : strIntMapAt)
    { cout << word.first << ":" << word.second << " "; }
    cout << endl;
    cout << "at(\"four\"): ";
    try {
        cout << strIntMapAt.at("four") << ": " << endl;
    }
    catch (std::out_of_range e) {
        cout << "Exception caught: " << e.what() << endl;
    }
    for (const auto word : strIntMapAt)
    { cout << word.first << ":" << word.second << " "; }
    cout << endl;

    CommonUtils::showSeperator();

    /*
        访问元素：
        c.find(k);          返回指向第一个关键字为k的元素的迭代器，若k不在容器中，返回尾后迭代器
        c.count(k);         返回关键字等于k的元素数量
        c.lower_bound(k);   返回指向第一个关键字不小于k的元素的迭代器
        c.upper_bound(k);   返回指向第一个关键字大于k的元素的迭代器
        c.equal_range(k);   返回关键字等于k的元素范围的迭代器pair，若k不存在则pair的两个成员都等于c.end()
    */
    map<string, int> strIntMapFind = { { "one", 123 },{ "two", 321 } };
    cout << "find(\"two\"): " << strIntMapFind.find("two")->second << endl;

    CommonUtils::showSeperator();

    // 严格弱序strict weak ordering：相当于“小于等于”
    // 可用严格弱序的函数作为map和set排序的方法，以替代<运算符
    // 第二个类型为函数指针
    set<StdLibContainer, decltype(compareStdLibContainer)*>
        containerSet(compareStdLibContainer); // 用比较函数来初始化set，表示添加元素时用此函数来排序元素
    containerSet.insert(StdLibContainer(123));
    containerSet.insert(StdLibContainer(789));
    containerSet.insert(StdLibContainer(456));
    cout << "All objects in the set: ";
    for (auto cont : containerSet)
    { cout << cont.data << " "; }
    cout << endl;

    CommonUtils::showSeperator();

    /*
        无序容器在存储组织上为一组桶，每个桶保存0个或多个元素，元素用哈希函数映射到桶。
        桶接口：
        c.bucket_count();       正在使用的桶的数目
        c.max_bucket_count();   容器能容纳的最多桶的数量
        c.bucket_size(n);       第n个桶中有多少个元素
        c.bucket(k);            关键字为k的元素在哪个桶中
        桶迭代：
        local_iterator;         用来访问桶中元素的迭代器类型
        const_local_iterator;   桶迭代器的const版本
        c.begin(n); c.end(n);   桶n的首元素迭代器和尾后迭代器
        c.cbegin(n); c.cend(n); 同上，返回const_local_iterator
        哈希策略：
        c.load_factor();        每个桶的平均元素数量，返回float值
        c.max_load_factor();    c试图维护的平均桶的大小，返回float值。必要时会添加新桶，使得load_factor<=max_load_factor
        c.rehash(n);            重组存储，使得bucket_count >= n，且bucket_count > size/max_load_factor
        c.reserve(n);           重组存储，使得c可以保存n个元素且不必refresh
        默认情况下，无序容器使用关键字类型的==来比较元素，使用hash<key_type>类型的对象来生成元素的哈希值。
        标准库为内置类型提供了hash模板，也为一些标准库类型定义了hash，所以可以直接定义关键字是内置类型、string、只能指针的无序容器。
        但不能直接定义关键字类型为自定义类类型的无序容器，必须提供自定义的hash模板版本。
    */
    
}

bool toBeBind(int intArg, char charArg, string strArg)
{
    cout << "toBeBind: intArg: " << intArg << " charArg: " << charArg << " strArg: " << strArg << endl;
    return true;
}

void StdLibContainer::testGeneric(void)
{
    /*
        泛型编程是编写与类型无关的代码，是代码复用的一种手段。模板则是泛型编程的基础。
        标准库提供独立于特定容器的泛型算法（generic algorithm），提供一些经典算法的公共接口，如排序和搜索。
        泛型算法用于不同类型容器和不同类型元素。
        算法只操作迭代器，不会执行容器操作改变容器大小
        指针对于内置数组来说就像迭代器

        只读算法：count/find/accumulate/equal。对于只读算法，建议使用cbegin和cend。
        写容器元素的算法：fill/fill_n/copy/replace
        重排容器元素的算法：sort/unique/stable_sort

        谓词predicate：可调用的表达式，返回结果是能用作条件的值。
        一元谓词unary predicate：值接受单一参数
        二元谓词binary predicate：两个参数
        接受谓词的算法对序列中的元素调用谓词，元素类型必须能转换为谓词的参数类型。
        比如sort默认依靠<比较元素大小，可以自定义比较大小的函数，作为谓词在第三个参数传给sort，此时sort使用该函数比较大小
        突破谓词参数个数限制：
        - 用lambda表达式作为谓词，用其capture list
        - C++11的标准库bind函数

    */
    /*
        C++11:
        lambda expression：表示可调用的代码单元，相当于未命名的内联函数
        具有一个返回类型，一个参数列表，一个函数体
        lambda可定义在函数内部
        形式：[capture list](parameter list) mutable -> return type {function body}
        capture list：lambda所在函数中定义的局部变量列表，通常为空
        mutable表示lambda可改变捕获的变量值，也可以靠捕获引用来改变值
        如果lambda体包含return之外的任何语句，则编译器假定lambda返回void，不能返回值。此时必须使用尾置返回类型
        不能有默认参数
        可以忽略parameter list和return type（根据body代码推断返回类型），但capture list和function body必须存在，如
        auto f = [] { return 123; }; // 定义对象f，不接受参数，返回123
        f(); // 调用f
        定义lambda时，编译器生成对应的未命名类类型。
        lambda的capture list支持值捕获和引用捕获，捕获发生在lambda创建时而不是调用时。可混合使用显式捕获和隐式捕获。
        []              空捕获列表
        [name,name]     name为lambda所在函数的局部变量，默认值拷贝，如果&name则引用捕获
        [&]             隐式捕获列表，lambda中用到的函数局部变量都为引用捕获
        [=]             隐式捕获列表，lambda中用到的函数局部变量都为拷贝捕获
        [&, identifier_list]    identifier_list里为显式拷贝捕获，不能用&
        [=, identifier_list]    identifier_list里为显式引用捕获，不能包括this，必须使用&

    */

    int intForLambda = 123;
    auto testLambdaExp = [intForLambda](float fltForLambda) -> string { return to_string(intForLambda * fltForLambda); };
    cout << "lambda expression: " << testLambdaExp(2.5) << endl;

    /*
        C++11:
        bind函数相当于一个通用对象适配器，接受可调用对象，生成新的可调用对象来适应原对象的参数列表
        一般形式：
        auto newCallable = bind(callable, arg_list);
        newCallable是可调用对象
        arg_list是逗号分隔的参数列表，对应callable的参数。arg_list可能包含_n这样的名字，如_1, _2，作为占位符
        调用newCallable时，newCallable会调用callable，把arg_list中的参数传递给callable
        希望传递给bind对象而不拷贝时，用标准库的ref或cref函数，如：bind(print, ref(os), _1, ' ');
    */

    //bool toBeBind(int intArg, char charArg, string strArg)
    auto bindObj = bind(toBeBind, _2, 'c', _1);
    bindObj("test", 123); // 相当于bind(123, 'c', "test")
    bindObj("again", 890);

    /*
        lambda和泛型算法的配合使用，lambda作为谓词：
        auto wc = find_if(words.begin(), words.end(),
                        [sz] (const string &a) { return a.size() >= sz; });
        bind和泛型算法的配合使用，find_if调用bind的时候，check_size被调用，string作为第一个参数，sz作为第二个参数：
        auto wc = find_if(words.begin(), words.end(),
                        bind(check_size, _1, sz));
    */
}

void StdLibContainer::testIterator(void)
{
    /*
        插入迭代器insert iterator：绑定到容器上，向容器插入元素
        - back_inserter，使用push_back()的迭代器
        - front_inserter，使用push_front()的迭代器
        - inserter，使用insert()的迭代器，第二个参数为指定insert位置的迭代器，插入到此迭代器之前
    */
    deque<int> intDeque;

    cout << "Original vector: ";
    for (int i : intDeque) { cout << i << " "; } cout << endl;

    // 总是在末尾插入
    auto backItr = back_inserter(intDeque);
    *backItr = 1;
    cout << "After back_inserter: ";
    for (int i : intDeque) { cout << i << " "; } cout << endl;

    // 总是在开头插入
    auto frontItr = front_inserter(intDeque);
    *frontItr = 0;
    cout << "After front_inserter: ";
    for (int i : intDeque) { cout << i << " "; } cout << endl;

    // 总是插入到固定迭代器之前
    auto midItr = intDeque.begin() + 1;
    auto insertItr = inserter(intDeque, midItr);
    *insertItr = 2;
    cout << "After inserter: ";
    for (int i : intDeque) { cout << i << " "; } cout << endl;
    *insertItr = 3;
    cout << "After inserter: ";
    for (int i : intDeque) { cout << i << " "; } cout << endl;

    CommonUtils::showSeperator();

    /*
        流迭代器stream iterator：绑定到输入或输出流上，遍历关联的IO流
        虽然iostream不是容器，但标准库为IO类型对象定义了迭代器，将流当作一个特定类型的元素序列来处理
        istream_iterator读取输入流
        ostream_iterator向输出流写数据
    */
    cout << "Please enter numbers end with CTRL+Z." << endl;
    istream_iterator<int> intIstreamItr(cin); // 初始化时绑定流
    istream_iterator<int> intIstreamItrEof; // 默认初始化，当作尾后值使用
    //ostream_iterator<int> intOstreamItr(cout); // 把int类型的值写到输出流中
    ostream_iterator<int> intOstreamItr(cout, "_"); // 每个输出之后输出一个_
    while (intIstreamItr != intIstreamItrEof)
    {
        *intOstreamItr++ = *intIstreamItr++;
    }
    cout << endl;

    CommonUtils::showSeperator();

    /*
        反向迭代器reverse iterator：在容器中从尾元素向首元素移动的迭代器
        除了forward_list之外的容器都有
        不能从流迭代器创建反向迭代器
        递增移动到前一个元素，递减移动到后一个元素
    */
    vector<string> strVector = { string("one"), string("two"), string("three") };

    cout << "Use standard iterator: ";
    for (auto sIter = strVector.cbegin();
        sIter != strVector.cend();
        sIter++)
    { cout << *sIter << " "; }
    cout << endl;

    cout << "Use reverse iterator: ";
    for (auto rIter = strVector.crbegin();
        rIter != strVector.crend();
        rIter++)
    { cout << *rIter << " "; }
    cout << endl;

    auto rTobIterator = strVector.crbegin();
    cout << "rTobIterator = crbegin(): " << *rTobIterator << endl;
    rTobIterator++;
    cout << "rTobIterator++: " << *rTobIterator << endl;
    rTobIterator++;
    auto bIterator = rTobIterator.base(); // base成员函数返回正向迭代器，但指向反向迭代器后一个元素
    cout << "bIterator: " << *bIterator << endl;
    bIterator++;
    cout << "bIterator++: " << *bIterator << endl;

    CommonUtils::showSeperator();

    /*
        移动迭代器move iterator：只移动元素，不拷贝 TODO Page 480
    */


    /*
        五类迭代器，不同泛型算法要求不同的迭代器类型：
        - 输入迭代器：只读不写，单遍扫描，只能递增
        - 输出迭代器：只写不读，单遍扫描，只能递减
        - 前向迭代器：可读写，多遍扫描，只能递增
        - 双向迭代器：可读写，多遍扫描，可递增递减
        - 随机访问迭代器：可读写，多遍扫描，支持全部迭代器运算
    */

    /*
        链表list和forward_list的特有算法：
        lst.merge(lst2);            将lst2的元素合并入lst，lst和lst2必须都是排过序的。
                                    合并后lst2的元素全部被删除，lst2为空。
                                    此算法使用<运算符比较大小
        lst.merge(lst2, comp);      此算法使用comp比较大小
        lst.remove(val);            调用erase删除与val相等（用==判断）的元素
        lst.remove_if(pred);        删除令pred谓词为真的元素
        lst.reverse();              反转lst中元素的顺序
        lst.sort();                 用<排序
        lst.sort(comp);             用comp排序
        lst.unique();               调用erase删除同一个值（用==判断）的连续拷贝
        lst.unique(pred);           删除同一个值（令pred谓词为真）的连续拷贝
        lst.splice(p, lst2);        p是指向lst中元素的迭代器，把lst2的所有元素移动到p之前的位置。lst2必须和lst类型相同，不能是同一个链表。
        lst.splice_after(p, lst2);  p是指向lst首前位置的迭代器，把lst2的所有元素移动到p之后的位置
        lst.splice(p, lst2, p2);    p2指向lst2中的位置，将p2指向的元素移动到lst中，lst2可以和lst为相同链表
        lst.splice_after(p, lst2, p2); 将p2之后的元素移动到lst中
        lst.splice(p, lst2, b, e);  b和e表示lst2中的合法范围，将范围内的元素从lst2移动到lst。lst2和lst可以是相同的链表，但p不能指向b和e的范围内
        lst.splice_after(p, lst2, b, e);
        *链表算法会改变底层的容器
    */
}

bool compareStdLibContainer(StdLibContainer insA, StdLibContainer insB)
{
    return (insA.data < insB.data);
}
