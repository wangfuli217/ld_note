#include<iostream>
using namespace std;
template<typename iterator>
void print(iterator begin,iterator end)
{
	while(begin!=end)
		cout<<*begin++<<' ';
	cout<<endl;
}
