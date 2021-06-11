#include<cstdlib>
#include <iostream>  
#include <cmath>  
#include <ctime>  
using namespace std;
  
const int MAX = 10000;  
int a[MAX];  
int main()  
{  
    int i, j, n = MAX;  
    int rep = 100; //ÖØ¸´´ÎÊı  
    clock_t beg, end;  
    for(i = 0; i < n; i++)  
        a[i] = rand() % 20000 - 10000; //-10000 <= a[i]< 10000  
  
    cout<<"test a[i]*a[i]"<<endl;  
    beg = clock();
	int val = a[i];  
    for(j = 0; j < rep; j++)  
        for(i = 0; i < n; i++)  
        	 a[i]*a[i]*a[i]*a[i]*a[i]*a[i]*a[i]*a[i]*a[i]*a[i];  
    end = clock();  
    cout<<"time: "<<end - beg<<"ms"<<endl;  
      
    cout<<"test pow(a[i], "<< 10 << " )"<<endl;  
    beg = clock();  
    for(j = 0; j < rep; j++)  
        for(i = 0; i < n; i++)  
            pow(a[i],10 );  
    end = clock();  
    cout<<"time: "<<end - beg<<"ms"<<endl;  
  
    return 0;  
}  
