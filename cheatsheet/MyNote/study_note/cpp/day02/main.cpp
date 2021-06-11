#include<iostream>
using namespace std;
extern "C"
{
	#include"sub.h"
}
int main(void)
{
	int x=456,y=123;
	cout<<x<<'-'<<y<<'='<<sub(x,y)<<endl;
	return 0;
}
