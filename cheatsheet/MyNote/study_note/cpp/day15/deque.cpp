#include "print.h"
#include<deque>
int main(void)
{
	deque<int> di;
	di.push_front(30);
	di.push_front(20);
	di.push_front(10);
	di.push_back(40);
	di.push_back(50);
	di.push_back(60);
	print(di.begin(),di.end());
	size_t size=di.size();
	for(size_t i=0;i<size;i++)
		cout<<&di[i]<<' ';
	cout<<endl;
	deque<int>::iterator i1=di.begin(),i2=di.end();
	i1+=2;
	i2-=3;
	swap(*i1,*i2);
	print(di.begin(),di.end());
	return 0;
}
