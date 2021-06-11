#include "max.h"
#include<iostream>
using namespace std;

int main(void)
{
	cout<<::max(123,456)<<endl;
	cout<<::max(1.23,4.56)<<endl;
	cout<<::max<string>("hello","world")<<endl;
	cout<<"---------------------------"<<endl;
	cout<<Comparator<int>(123,456).max()<<endl;
	cout<<Comparator<double>(1.23,4.56).max()<<endl;
	cout<<Comparator<string>("hello","world").max<<endl;
	return 0;
}
