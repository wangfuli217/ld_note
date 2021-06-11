#include<iostream>
#include<typeinfo>
using namespace std;

template<typename A=int,typename B=double,typename C=string>
class X
{
	public:
		static void print(void)
		{
			cout<<typeid(A).name()<<' '<<typeid(B).name()<<' '<<typeid(C).name()<<endl;
		}
};
int main(void)
{
	X<short,float,char>::print();
	return 0;
}
