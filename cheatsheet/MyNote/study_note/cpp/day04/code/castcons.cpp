#include<iostream>
using namespace std;
class Integer{
	public:
		//类型转换构造函数
		Integer(int i)
		{
			m_i=i;
		}
		int m_i;
};
class Point2D{
	public:
		Point2D(int x,int y)
		{
			m_x=x;
			m_y=y;
		}
		void draw(void)
		{
			cout<<"点("<<m_x<<','<<m_y<<')'<<endl;
		}
		int m_x,m_y;
};
class Point3D{
	public:
		Point3D(int x,int y,int z)
		{
			m_x=x;
			m_y=y;
			m_z=z;
		}
		explicit Point3D(Point2D const &p)
		{
			m_x=p.m_x;
			m_y=p.m_y;
			m_z=0;
		}
		void draw(void)
		{
			cout<<"点("<<m_x<<','<<m_y<<','<<m_z<<')'<<endl;
		}
		int m_x,m_y,m_z;
};
void foo(Point3D p3)
{
	p3.draw();
}
Point3D bar(void)
{
	return static_cast<Point3D>(Point2D(123,456));
}
int main(void)
{
	Integer i(1234);
	cout<<i.m_i<<endl;
	i=5678;
	//i=Integer(5678);
	cout<<i.m_i<<endl;
	Point2D p2(123,456);
	Point3D p3=static_cast<Point3D>(p2);
	p2.draw();
	p3.draw();
	foo(static_cast<Point3D>(p2));
	bar().draw();
	return 0;
}
