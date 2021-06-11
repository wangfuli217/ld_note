#include<iostream>
using namespace std;

class Rect
{
	public:
		void draw(void) const
		{
			cout<<"绘制矩形"<<endl;
		}
};
class Circle
{
	public:
		void draw(void) const
		{
			cout<<"绘制圆形"<<endl;
		}
};
//通过同一种类型的同一个方法,表现出不同的外观和行为一一一多态
template<typename Shape>
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
