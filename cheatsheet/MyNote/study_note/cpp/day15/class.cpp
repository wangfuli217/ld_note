#include<iostream>
#include<vector>
using namespace std;
class A
{
	public:
		A(void)
		{
			cout<<"缺省构造:"<<this<<endl;
		}
		A(A const& that)
		{
			cout<<"拷贝构造:"<<&that<<"->"<<this<<endl;
		}
		A &operator=(A const& rhs)
		{
			cout<<"拷贝赋值:"<<&rhs<<"->"<<this<<endl;
		}
		~A(void)
		{
			cout<<"析构函数:"<<this<<endl;
		}
};
int main(void)
{
	cout<<"----1----"<<endl;
	vector<A> v1(3);
	cout<<"----2----"<<endl;
//	v1.erase(v1.begin());
	return 0;
}
