#include<iostream>
#include<map>
using namespace std;

int main(void)
{
	multimap<string,int> msi;
	msi.insert(make_pair("赵云",20000));
	msi.insert(make_pair("赵云",40000));
	msi.insert(make_pair("关羽",10000));
	msi.insert(make_pair("关羽",30000));
	msi.insert(make_pair("张飞",10000));
	typedef multimap<string,int>::iterator IT;
	for(IT it=msi.begin();it!=msi.end();++it)
		cout<<it->first<<":"<<it->second<<endl;
	cout<<"----------------------------"<<endl;
	IT lower=msi.lower_bound("张飞");
	IT upper=msi.upper_bound("张飞");
	pair<IT,IT> res=msi.equal_range("关羽");
	cout<<lower->first<<":"<<lower->second<<endl;
	cout<<upper->first<<":"<<lower->second<<endl;
/*	IT lower=res.first;
	IT upper=res.second;
	for(IT it=lower;it!=upper;++it)
		cout<<it->first<<":"<<it->second<<endl;*/
	return 0;
}
