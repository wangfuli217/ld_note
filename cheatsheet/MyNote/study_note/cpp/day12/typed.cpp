#include<iostream>
using  namespace std;;

//函数模板
template<typename T>
T max(T x,T y)
{
	return x>y?x:y;
}
/*int max_int(int x,int y)
{
	return x>y?x:y;
}
double max_double(double x,double y)
{
	return x>y?x:y;
}
string max_string(string x,string y)
{
	return x>y?x:y;
}*/
int main(void)
{
	int nx=123,ny=456;
	cout<<::max(nx,ny)<<endl;
	double dx=1.23,dy=4.56;
	cout<<::max(dx,dy)<<endl;
	string sx="world",sy="hello";
	cout<<::max(sx,sy)<<endl;
	return 0;
}
