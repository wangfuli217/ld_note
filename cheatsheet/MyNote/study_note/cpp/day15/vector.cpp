#include<iostream>
#include<algorithm>
#include<vector>
using namespace std;

class Comp
{
	public:
		bool operator()(int a,int b)const
		{
			return a>b;
		}
};
bool comp(int a,int b)
{
	return a>b;
}
template<typename T>
void remove(vector<T>& vec,T const& key)
{
	for(typename vector<T>::iterator it=vec.begin();(it=find(it,vec.end(),key))!=vec.end();it=vec.erase(it));
}
void print(vector<int> const& v8)
{
	size_t size=v8.size();
	cout<<"元素:";
	for(size_t i=0;i<size;i++)
		cout<<v8[i]<<' ';
	cout<<endl;
}
void show(vector<int> const& v8)
{
	cout<<"迭代:"<<flush;
	for(vector<int>::const_iterator it=v8.begin();it!=v8.end();it++)
		cout<<*it<<' ';
	cout<<endl;
}
void rshow(vector<int> const& v8)
{
	cout<<"反向:"<<flush;
	for(vector<int>::const_reverse_iterator it=v8.rbegin();it!=v8.rend();it++)
		cout<<*it<<' ';
	cout<<endl;
}
int main(void)
{
	//vector<int> v1;
	//print(v1);
	//vector<int> v2(5);
	//print(v2);
	//v2[0]=10;
	//v2[1]=20;
	//v2[2]=30;
	//v2[3]=40;
	//v2[4]=50;
//	//v2[5]=60;
	//v2.push_back(60);
	//print(v2);
	//vector<int> v3(5,13);
	//print(v3);
	//int a[10]={1,2,3,4,5,6,7,8,9,10};
	//vector<int> v4(a+3,a+7);
	//print(v4);
	//vector<int> v5(a,a+10);
	//print(v5);
	//show(v5);
	//rshow(v5);
	//v5.front()=0;
	//print(v5);
	//v5.back()++;
	//print(v5);
	//v5.erase(v5.begin());
	//print(v5);
	//v5.pop_back();
	//print(v5);
	//v5.insert(v5.begin(),1);
	//print(v5);
	//v5.push_back(10);
	//print(v5);
	//v5.erase(v5.begin()+4);
	//print(v5)
//	vector<int> v6;
//	v6.push_back(13);
//	v6.push_back(27);
//	v6.push_back(13);
//	v6.push_back(39);
//	v6.push_back(13);
//	print(v6);
//	remove(v6,13);
//	print(v6);
//	vector<string> v7;
//	v7.push_back("济南");
//	v7.push_back("北京");
//	v7.push_back("济南");
//	v7.push_back("上海");
//	v7.push_back("浙江");
//	v7.push_back("济南");
//	remove(v7,string("济南"));
//	for(vector<string>::iterator it=v7.begin();it!=v7.end();it++)
//		cout<<*it<<' ';
//	cout<<endl;
//	vector<int> v8;
//	v8.push_back(28);
//	v8.push_back(17);
//	v8.push_back(23);
//	v8.push_back(14);
//	v8.push_back(39);
//	v8.push_back(25);
//	v8.push_back(32);
//	print(v8);
//	sort(v8.begin(),v8.end());
//	print(v8);
//	sort(v8.rbegin(),v8.rend());
	//sort(v8.begin(),v8.end(),comp);
//	sort(v8.begin(),v8.end(),Comp());
//	print(v8);
	vector<int> v9;
	vector<int>::iterator it;
	v9.push_back(100);
	it=v9.begin();
	cout<<*it<<endl;
	v9.push_back(200);
	it=v9.begin();
	cout<<*it<<endl;
	return 0;
}
