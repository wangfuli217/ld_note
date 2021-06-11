#pragma once
class StdLibContainer
{
public:
    StdLibContainer();
    StdLibContainer(int initData);
    ~StdLibContainer();

    // 用于比较大小的数据
    int data;

    // 容器
    void testContainer(void);
    // 泛型
    void testGeneric(void);
    // 迭代器
    void testIterator(void);

};


//// 非成员接口函数
// 用于比较大小的严格弱序函数
bool compareStdLibContainer(StdLibContainer insA, StdLibContainer insB);