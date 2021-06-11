#include <stdio.h>
#include <vector>
#include <algorithm>
#include <iostream>
#include <stdlib.h>

using namespace std;

//STL中关于二分查找的函数有三个lower_bound 、upper_bound 、binary_search 。这三个函数都运用于有序区间（当然这也是运用二分查找的前提），下面记录一下这两个函数。
//ForwardIter lower_bound(ForwardIter first, ForwardIter last,const _Tp& val)算法返回一个非递减序列[first, last)中的第一个大于等于值val的位置。
//
//ForwardIter upper_bound(ForwardIter first, ForwardIter last, const _Tp& val)算法返回一个非递减序列[first, last)中的第一个大于值val的位置。

void bound_2()
{
    int myints[] = {10,20,30,30,20,10,10,20};
    std::vector<int> v(myints,myints+8);           // 10 20 30 30 20 10 10 20

    std::sort (v.begin(), v.end());                // 10 10 10 20 20 20 30 30

    std::vector<int>::iterator low,up;
    low=std::lower_bound (v.begin(), v.end(), 20); //          ^
    up= std::upper_bound (v.begin(), v.end(), 20); //                   ^

    std::cout << "low: " << *low << " lower_bound at position " << (low- v.begin()) << '\n';
    std::cout << "up: " << *up << " upper_bound at position " << (up - v.begin()) << '\n';
}

int main(int argc, char **argv)
{
	vector<int> vec;
    vector<int>::iterator low;
    vector<int>::iterator up;
    
    for (int i = 0; i <= 9; i++) {
        vec.push_back(i);
    }
    
    low = std::lower_bound(vec.begin(), vec.end(), 5);
    up = std::upper_bound(vec.begin(), vec.end(), 5);
    
    cout << "low: " << *low << " pos: " << low - vec.begin() << endl;
    cout << "up: " << *up << " pos: " << up - vec.begin() << endl;
    
    
    cout << endl;
    
    bound_2();
    
    system("pause");
	return 0;
}
