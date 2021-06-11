#include<iostream>
#include "list.h"
using namespace std;

int main(void)
{
	/*	List<int>  l1;
	l1.push_front(5);
	l1.push_front(4);
	l1.push_front(3);
	l1.push_front(2);
	l1.push_front(1);
	l1.push_back(1);
	l1.push_back(2);
	l1.push_back(3);
	l1.push_back(4);
	l1.push_back(5);
	cout<<l1.front()<<endl;
	cout<<l1.back()<<endl;
	cout<<l1.empty()<<endl;
	cout<<l1.pop_front()<<endl;
	cout<<l1.pop_front()<<endl;
	cout<<l1.pop_front()<<endl;
	cout<<l1.pop_front()<<endl;
	cout<<l1.pop_front()<<endl;
	cout<<l1.pop_back()<<endl;
	cout<<l1.pop_back()<<endl;
	cout<<l1.pop_back()<<endl;
	cout<<l1.pop_back()<<endl;
	cout<<l1.pop_back()<<endl;
	cout<<l1.empty()<<endl;*/
	List<string> l1;
	l1.push_front("123");
	l1.push_front("234");
	l1.push_front("345");
	cout<<l1.size()<<endl;
	cout<<l1.pop_back()<<endl;
	cout<<l1.pop_back()<<endl;
	cout<<l1.pop_back()<<endl;
	cout<<l1.size()<<endl;
	return 0;
}
