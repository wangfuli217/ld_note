#include <iostream>  
#include <string.h>
#include <stddef.h>

#include "mem_pool.h"

using namespace std;  
  
int 
main()  
{  
    mem_pool *pool = mem_create_pool(1024);//创建一个1024字节大小的内存池（不用担心不够用，nginx遇到内存不足时会自己申请足够的内存）  
  
    char *mychar = (char *)mem_palloc(pool,100);//请求1:100字节的内存  
    strcpy(mychar,"use mem_pool to manage your memory 100");  
    cout << mychar << endl;  
  
    mychar = (char *)mem_palloc(pool,300);//请求2:300字节的内存  
    strcpy(mychar,"use mem_pool to manage your memory 300");  
    cout << mychar << endl;  
  
    mychar = (char *)mem_palloc(pool,1000);//请求3:1000字节的内存  
    strcpy(mychar,"use mem_pool to manage your memory 1000");  
    cout << mychar << endl;  
  
    int *arr = (int *)mem_palloc(pool,sizeof(int)*4);//请求4：一个整型数组，数组大小自定义为4  
    arr[0]=3;  
    arr[1]=4;  
    arr[2]=5;  
    arr[3]=6;  
  
    printf("%d %d %d %d\n",arr[0],arr[1],arr[2],arr[3]);  
    mem_destroy_pool(pool);//统一销毁内存池，不会有内存泄露  
	
	system("pause");
  
    return 0;  
}  