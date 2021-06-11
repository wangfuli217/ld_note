#include<iostream>
using namespace std;

class Shape
{
	public:
		virtual void draw(void) const
		{
			cout<<"绘制图形"<<endl;
		}
};
class Rect:public Shape
{
	public:
		void draw(void) const
		{
			cout<<"绘制矩形"<<endl;
		}
};
class Circle:public Shape
{
	public:
		void draw(void) const
		{
			cout<<"绘制圆形"<<endl;
		}
};
//通过同一种类型的同一个方法,表现出不同的外观和行为一一一多态
void drawAny(Shape const& shape)
{
	shape.draw();
}
int main(void)
{
	drawAny(Rect());
	drawAny(Circle());
	return 0;
}
