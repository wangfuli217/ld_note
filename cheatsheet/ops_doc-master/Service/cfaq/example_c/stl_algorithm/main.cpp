#include <iostream>
#include <algorithm>
#include <vector>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

using namespace std;  
  
//初始化vector  
template <typename T>  
void InitContainer( T* vecInt )  
{  
    if (vecInt==NULL)  
    {  
        return;  
    }  
    vecInt->clear();  
  
    vecInt->push_back(12);  
    vecInt->push_back(14);  
    vecInt->push_back(14);  
    vecInt->push_back(13);  
    vecInt->push_back(9);  
    vecInt->push_back(1);  
    vecInt->push_back(5);  
    vecInt->push_back(0);  
}  
//遍历输出容器各值  
template <class T>  
void ShowContainer(T* cont)  
{  
    T::const_iterator cit = cont->begin();  
    while (cit!=cont->end())  
    {  
        cout<<*cit<<"  ";  
        cit++;  
    }  
    cout<<endl;  
}  
template <class IT> inline  
void ShowContainer(IT first,IT last)  
{  
    if (first>last)  
    {  
        return ;  
    }  
    IT cit=first;  
    while (cit!=last)  
    {  
        cout<<*cit<<"  ";  
        cit++;  
    }  
    cout<<endl;  
}  
//计算区间的累加值  
template <class TC> inline  
int _accumulate(TC first,TC last,int val)  
{  
    return accumulate(first,last,val);  
}  
//相邻两个元素之间的差值  
template <typename T>  
void _adjacent_difference(T* t)  
{  
    T dest(t->size());  
    //区间迭代器，第三个参数为结果目标迭代器起点  
    adjacent_difference(t->begin(),t->end(),dest.begin());  
    ShowContainer(&dest);  
}  
//查找迭代器区间相邻的满足条件的元素，返回迭代器，默认条件为相同  
bool findcondition(int a,int b)  
{  
    return a==b;  
}  
void _adjacent_find(vector<int>::iterator first,vector<int>::iterator last)  
{  
    vector<int>::const_iterator it;  
    it=adjacent_find(first,last);  
    //it=adjacent_find(first,last,findcondition);  
    if (it!=last)  
    {  
        cout<<*it<<endl;  
    }  
}  
//查看元素是否存在  
void _binary_search(vector<int>* pVect,int val)  
{  
    bool bResult=binary_search(pVect->begin(),pVect->end(),val);  
    if (bResult)  
    {  
        cout<<"found"<<endl;  
        return;  
    }  
    cout<<"not found!"<<endl;  
}  
//拷贝元素到新的位置  
void _copy(vector<int>* pVect)  
{  
    vector<int> dest;  
    dest.resize(pVect->size());  
    copy(pVect->begin(),pVect->end(),dest.begin());  
  
    ShowContainer(&dest);  
}  
//统计元素个数  
void _count(vector<int>* pVect,int val)  
{  
    char buffer[100];  
    sprintf(buffer,"值为%d的元素个数为:",val);  
    cout<<buffer;  
    cout<<count(pVect->begin(),pVect->end(),val)<<endl;  
}  
  
//统计满足条件的元素个数  
bool countFun(int i)  
{  
    return i<10;  
}  
void _count_if(vector<int>* pVect,bool (*p)(int))  
{  
    cout<<"满足条件的元素个数为:"<<endl;  
    cout<<count_if(pVect->begin(),pVect->end(),p)<<endl;  
}  
  
//判断两个集合中的元素是否完全相同or满足条件  
//i为第一个集合的元素，j为第二个集合的元素,可以为类或者结构  
bool equalFun(int i,int j)  
{  
    return i==j;  
}  
void _equal(vector<int>* pVect1,vector<int>* pVect2,bool (*p)(int,int))  
{  
    if (p==NULL)  
    {  
        bool bResult= equal(pVect1->begin(),pVect1->end(),pVect2->begin());  
        if (bResult)  
        {  
            cout<<"两个集合的值完全相同"<<endl;  
        }  
    }  
    else  
    {  
        bool bResult= equal(pVect1->begin(),pVect1->end(),pVect2->begin(),p);  
        if (bResult)  
        {  
            cout<<"两个集合的值完全满足条件"<<endl;  
        }  
    }  
}  
// 搜索序列中的由相同元素组成的子序列,要排序,不存在返回end迭代器  
void _equal_range(vector<int>* pVect,int val)  
{  
    pair<vector<int>::iterator,vector<int>::iterator> bounds;  
    //排序  
    sort(pVect->begin(),pVect->end());  
    bounds=equal_range(pVect->begin(),pVect->end(),val);  
    cout<<int(bounds.first-pVect->begin())<<endl;  
    cout<<int(bounds.second-pVect->begin())<<endl;  
}  
//在序列中查找一个匹配值的元素,返回第一个迭代器,没有找到为end  
void _find(vector<int>* pVect,int val)  
{  
    vector<int>::iterator it=find(pVect->begin(),pVect->end(),val);  
    if (it!=pVect->end())  
    {  
        cout<<it-pVect->begin()<<endl;  
    }  
}  
  
//在序列中查找最后出现的序列  
void _find_end(vector<int>* pVect,vector<int>* pMatch)  
{  
    vector<int>::iterator it;  
    it=find_end(pVect->begin(),pVect->end(),pMatch->begin(),pMatch->end());  
    if (it!=pVect->end())  
    {  
        cout<<"位置:"<<it-pVect->begin()<<endl;  
        cout<<"值"<<*it<<endl;  
        return;  
    }  
    cout<<"没有找到"<<endl;  
  
}  
  
//在序列中查找给定集合的任一元素  
//(符合条件)  
bool FindFun(int a,int b)  
{  
    return a==b;  
}  
void _find_first_of(vector<int>* pVect,vector<int>* pMatch)  
{  
    vector<int>::iterator it;  
    it=find_first_of(pVect->begin(),pVect->end(),pMatch->begin(),pMatch->end());  
    //it=find_first_of(pVect->begin(),pVect->end(),pMatch->begin(),pMatch->end(),FindFun);  
    if (it!=pVect->end())  
    {  
        cout<<"位置:"<<it-pVect->begin()<<endl;  
        cout<<"值"<<*it<<endl;  
        return;  
    }  
    cout<<"没有找到"<<endl;  
}  
  
// 在序列中查找第一个符合条件的元素  
//类似于count_if  
bool FindIfFun(int i)  
{  
    return i<10;  
}  
void _find_if(vector<int>* pVect)  
{  
    vector<int>::iterator it;  
    it=find_if(pVect->begin(),pVect->end(),FindIfFun);  
    if (it!=pVect->end())  
    {  
        cout<<"位置:"<<it-pVect->begin()<<endl;  
        cout<<"值"<<*it<<endl;  
        return;  
    }  
    cout<<"没有找到"<<endl;  
}  
  
//为序列中的每个元素应用指定的函数  
//要对每个元素进行处理的函数  
void ForEachFun(int i)  
{  
    cout<<i<<endl;  
}  
void _for_each(vector<int>* pVect)  
{  
    for_each(pVect->begin(),pVect->end(),ForEachFun);  
}  
  
//将函数的运行结果储存在一个序列中  
int RandomNumber()  
{  
    return (rand()%100);  
}  
void _generate(vector<int>* pVect)  
{  
    srand(unsigned(time(NULL)));  
    generate(pVect->begin(),pVect->end(),RandomNumber);  
    ShowContainer(pVect);  
}  
//将N次驱动函数的结果储存在一个序列中  
void _generate_n(vector<int>* pVect)  
{  
    srand(unsigned(time(NULL)));  
    generate_n(pVect->begin(),pVect->size(),RandomNumber);  
    ShowContainer(pVect);  
}  
//检查一个集合是否是另外一个集合的子集  
void _includes(vector<int>* pVect,vector<int>* pSubVect)  
{  
    bool bResult=includes(pVect->begin(),pVect->end(),pSubVect->begin(),pSubVect->end());  
    if (bResult)  
    {  
        cout<<"参数2为参数1的子集"<<endl;  
    }  
      
}  
//计算两容器之间规定操作的结果 默认为  
//_Val + ( a1 * b1 ) + ( a2 * b2 )...  
//定义操作_Val _Binary_op1 ( a1 _Binary_op2 b1 ) _Binary_op1 ( a2 _Binary_op2 b2 ) _Binary_op1  
void _inner_product(vector<int>* pVect)  
{  
    //int result=inner_product(pVect->begin(),pVect->end(),pVect->begin(),0);  
  
    //val*(a1+b1)*(a2+b2)  
    int result=inner_product(pVect->begin(),pVect->end(),pVect->begin(),1,multiplies<int>(),plus<int>());  
      
    cout<<result<<endl;  
}  
//内置式归并  
void _inplace_merge()  
{  
    vector<int> v1,v2;  
    InitContainer(&v1);  
    InitContainer(&v2);  
    //排序  
    sort(v1.begin(),v1.end());  
    sort(v2.begin(),v2.end());  
    //将两个容器合并为一个  
    vector<int> dest(v1.size()+v2.size());  
    //装入待归并数据  
    copy(v1.begin(),v1.end(),dest.begin());  
    copy(v2.begin(),v2.end(),dest.begin()+v1.size());  
  
    //内部归并  
    inplace_merge(dest.begin(),dest.begin()+v1.size(),dest.end());  
    ShowContainer(&dest);  
}  
//检查给定的序列是否是堆  
void _is_heap(vector<int>* pVect)  
{  
    if (is_heap(pVect->begin(),pVect->end()))  
    {  
        cout<<"该序列是堆"<<endl;  
    }  
}  
//交换两个迭代器指向的元素  
void _iter_swap()  
{  
    vector<int> v1;  
    InitContainer(&v1);  
    //交换首尾元素  
    iter_swap(v1.begin(),v1.end()-1);  
    ShowContainer(&v1);  
}  
//按字典顺序检查一个序列是否小于另外一个序列  
void _lexicographical_compare(vector<int>* pVect,vector<int>* pVect2)  
{  
    bool bResult=lexicographical_compare(pVect->begin(),pVect->end(),pVect2->begin(),pVect2->end());  
  
}  
//lower_bound 查找有序序列第一个元素的位置 uper_bound。。。最后一个元素的位置  
  
//创建一个堆并以序列的形式输出  
bool HeapFun(int i,int j)  
{  
    return i<j;  
}  
void _make_heap(vector<int>* pVect)  
{  
    //创建一个大顶堆  
    make_heap(pVect->begin(),pVect->end());  
    ShowContainer(pVect);  
    //将最大元素从堆中移除  
    pop_heap(pVect->begin(),pVect->end());  
    //从容器中移除  
    pVect->pop_back();  
    ShowContainer(pVect);  
    //添加一个元素到堆  
    pVect->push_back(99);  
    push_heap(pVect->begin(),pVect->end());  
    ShowContainer(pVect);  
    //堆排序  
    sort_heap(pVect->begin(),pVect->end());  
    ShowContainer(pVect);  
}  
//返回序列中的最大/小者  
void _max_element(vector<int>* pVect)  
{  
    vector<int>::iterator it= max_element(pVect->begin(),pVect->end());  
    cout<<*it<<endl;  
    cout<<it-pVect->begin()<<endl;  
    it=min_element(pVect->begin(),pVect->end());  
}  
  
//对两个有序序列进行归并处理  
void _merge()  
{  
    vector<int> v1,v2;  
    InitContainer(&v1);  
    InitContainer(&v2);  
  
    vector<int> dest(v1.size()+v2.size());  
  
    merge(v1.begin(),v1.end(),v2.begin(),v2.end(),dest.begin());  
    ShowContainer(&dest);  
      
}  
//生成下一个稍大的序列  
void _next_permutation()  
{  
    vector<int> vect;  
    vect.push_back(2);  
    vect.push_back(1);  
    vect.push_back(4);  
    //排序  
    sort(vect.begin(),vect.end());  
    do   
    {  
        ShowContainer(&vect);  
    } while (next_permutation(vect.begin(),vect.end()));  
    do   
    {  
        ShowContainer(&vect);  
    } while (prev_permutation(vect.begin(),vect.end()));  
}  
//将元素分成两组  
bool PartitionFun(int i)  
{  
    return i%2==1;  
}  
void _partition(vector<int>* pVect)  
{  
    vector<int>::iterator it=partition(pVect->begin(),pVect->end(),PartitionFun);  
    ShowContainer(pVect->begin(),it);  
    ShowContainer(it,pVect->end());  
}  
//随机生成元素的一个排列  
void _random_shuffle(vector<int>* pVect)  
{  
    srand (unsigned(time(NULL)));  
    random_shuffle(pVect->begin(),pVect->end());  
    ShowContainer(pVect);  
}  
//移除给定值的所有元素  
//  
bool RemoveFun(int i)  
{  
    return i%2==1;  
}  
void _remove(vector<int>* pVect,int val)  
{  
    //删除指定的值  
    remove(pVect->begin(),pVect->end(),val);  
  
    remove_if(pVect->begin(),pVect->end(),RemoveFun);  
  
}  
// replace replace_if 替换满足条件的值  
//reverse 反转  
  
//search 查找   
  
//set_difference 计算两个集合的差集  
  
//set_intersection      计算两个集合的并集  
//  
//  set_symmetric_difference      计算两个集合的对称差  
//  
//  set_union 计算两个集合的交集  
//  
  
  
int 
main(int argc, char* argv[])  
{  
    vector<int> vecInt;  
    InitContainer(&vecInt);  
    vector<int>::iterator itb=vecInt.begin(),ite=vecInt.end();  
  
    vector<int> match;  
    match.push_back(5);  
    match.push_back(1);  
  
    _random_shuffle(&vecInt);  
      
    return 0;  
}  
