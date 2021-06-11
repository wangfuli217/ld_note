#include<iostream>
#include "comp.h"
using namespace std;

int main(void)
{
	Comparator comp(123,456);
	cout<<"最小值:"<<comp.min()<<endl;
	cout<<"最大值:"<<comp.max()<<endl;
	return 0;
}
