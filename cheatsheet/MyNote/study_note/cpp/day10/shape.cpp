#include<iostream>
using namespace std;
class A
{
	public:
		void foo(void)
		{
			cout<<"A::foo"<<endl;
		}
		int m_data;
};
class Shape
{
	public:
		Shape(int x=0,int y=0):m_x(x),m_y(y){}
		virtual void draw(void) const
		{
			cout<<"形状("<<m_x<<','<<m_y<<')'<<endl;
		}
	protected:
		int m_x;
		int m_y;
};
class Circle:public Shape
{
	public:
		Circle(int x,int y,int r):Shape(x,y),m_r(r){}
		void draw(void) const
		{
			cout<<"圆形("<<m_x<<','<<m_y<<"),"<<m_r<<endl;
		}
	private:
		int m_r;
};
class Rect:public Shape
{
	public:
		Rect(int x,int y,int w,int h):Shape(x,y),m_w(w),m_h(h){}
		void draw(void) const
		{
			cout<<"矩形("<<m_x<<','<<m_y<<"),"<<m_w<<','<<m_h<<endl;
		}
	private:
		int m_w;
		int m_h;
};
void render(Shape *shapes[])
{
	for(int i=0;shapes[i];i++)
		shapes[i]->draw();
}
int main(void)
{
	Rect r(1,2,3,4);
	Circle c(5,6,7);
	r.draw();
	c.draw();
	Shape* shapes[1024]={NULL};
	shapes[0]=new Rect(1,2,3,4);
	shapes[1]=new Circle(5,6,7);
	shapes[2]=new Circle(8,9,10);
	A* p=NULL;
	render(shapes);
	p->foo();
	return 0;
}
