#include<iostream>
using namespace std;
enum Color{RED,GREEN,BLUE,WHITE,BLACK};
void foo(Color color)
{
	cout<<color<<endl;
}
Color bar(void)
{
//	return 2; 不允许的操作
	return BLUE;
}
int main(void)
{
    Color color=RED;
	cout<<color<<endl; //0
//	color=0; 不允许的操作
	foo(GREEN);
//	foo(1);  不允许的操作
	cout<<bar()<<endl;
	int i=WHITE;
	cout<<i<<endl;
	cout<<WHITE+BLACK<<endl;
	return 0;
}
