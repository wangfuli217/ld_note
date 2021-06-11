#include<iostream>
#include<set>
using namespace std;
int main(void)
{
	multiset<int> si;
	si.insert(13);
	si.insert(26);
	si.insert(39);
	si.insert(13);
	si.insert(13);
	si.insert(77);
	si.insert(26);
	for(multiset<int>::iterator it=si.begin();it!=si.end();it++)
		cout<<*it<<' ';
	cout<<endl;
	typedef multiset<int>::iterator  IT;
	pair<IT,IT> its=si.equal_range(13);
	for(IT it=its.first;it!=its.second;it++)
		cout<<*it<<' ';
	cout<<endl;
	return 0;
}
