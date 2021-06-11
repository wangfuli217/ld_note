//file RBTree.cpp   
//written by saturnman，20101008。   
//updated by July，20110329。   
  
//所有的头文件都已补齐，现在您可以直接复制此份源码上机验证了（版权所有，侵权必究）。   
//July、updated，2011.05.06。   
#include <iostream>   
#include <algorithm>   
#include <iterator>   
#include <vector>   
#include <sstream>   
#include "RBTree.h"   //如果.h文件，和cpp文件放在一个文件里，此句去掉   

using namespace std;  

#if !defined(PAUSE)
#include <stdlib.h>
#define	PAUSE system("pause") 
#endif
  
int main()  
{  
    RB_Tree<int,int> tree;  
    vector<int> v;  
      
    for(int i=0;i<20;++i)  
    {  
        v.push_back(i);  
    }  
    random_shuffle(v.begin(),v.end());  
    copy(v.begin(),v.end(),ostream_iterator<int>(cout," "));  
    cout<<endl;  
    stringstream sstr;  
    for(unsigned int i=0;i<v.size();++i)  
    {  
        tree.Insert(v[i],i);  
        cout<<"insert:"<<v[i]<<endl;   //添加结点   
    }  
    for(unsigned int i=0;i<v.size();++i)  
    {  
        cout<<"Delete:"<<v[i]<<endl;  
        tree.Delete(v[i]);             //删除结点   
        tree.InOrderTraverse();  
    }  
    cout<<endl;  
    tree.InOrderTraverse();

	PAUSE;
	
    return 0;  
}  
