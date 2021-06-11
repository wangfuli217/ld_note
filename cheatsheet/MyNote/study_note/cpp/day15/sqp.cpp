#include<iostream>
#include<stack>
#include<queue>
#include<vector>
#include<deque>
#include<list>
#include<string>
using namespace std;

class CmpInt
{
	public:
		bool operator()(int a,int b) const
		{
			return a>b;
		}
};
int main(void)
{
	//stack<string> ss;
	stack<string,vector<string> > ss;
	ss.push("C++");
	ss.push("喜欢");
	ss.push("我们");
	while(!ss.empty())
	{
		cout<<ss.top();
		ss.pop();
	}
	cout<<endl;
	queue<string,list<string> > qs;
	qs.push("我们");
	qs.push("喜欢");
	qs.push("STL!");
	while(!qs.empty())
	{
		cout<<qs.front();
		qs.pop();
	}
	cout<<endl;
	//priority_queue<int,vector<int> > p1;
	priority_queue<int,vector<int>,CmpInt> p1;
	p1.push(66);
	p1.push(77);
	p1.push(88);
	p1.push(55);
	p1.push(33);
	while(!p1.empty())
	{
		cout<<p1.top()<<' ';
		p1.pop();
	}
	cout<<endl;
	return 0;
}
