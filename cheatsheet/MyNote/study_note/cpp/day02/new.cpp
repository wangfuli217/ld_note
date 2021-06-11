#include<iostream>
using namespace std;
struct Student
{
	string name;
	int id;
};
int main(void)
{
	int *p1=new int;
	//int *p1=(int *)malloc(sizeof(int));
	*p1=1234;
	++*p1;
	cout<<*p1<<endl;
	delete p1;
	p1=new int();
	cout<<*p1<<endl;
	delete p1;
	p1=new int(1234);
	cout<<*p1<<endl;
	delete p1;
	p1=new int[4]{1,2,3,4};
	for(size_t i=0;i<4;i++)
		cout<<p1[i]<<endl;
	delete[]  p1;
	try
	{
		p1=new int;
	}
	catch(exception&ex)
	{
		cout<<ex.what()<<endl;
	}
	int (*p2)[4]=new int[3][4];
	for(int i=0;i<3;i++)
		for(int j=0;j<4;j++)
			p2[i][j]=(i+1)*10+j+1;
	for(int i=0;i<3;i++)
	{
		for(int j=0;j<4;j++)
			cout<<p2[i][j]<<' ';
		cout<<endl;
	}
	delete[] p2;
	int (*p3)[4][5]=new int[3][4][5];
	for(int i=0;i<3;i++)
		for(int j=0;j<4;j++)
		{
			for(int k=0;k<5;k++)
			{
				p3[i][j][j]=(i+1)*100+(j+1)*10+k+1;
				cout<<p3[i][j][k]<<' ';
			}
			cout<<endl;
		}
	delete[] p3;
	string *p4=new string;
	cout<<'['<<*p4<<']'<<endl;
	delete p4;
	p4=new string("周俊华是SB");
	cout<<*p4<<endl;
	delete p4;
	p4=new string[3]{"北京","天津","上海"};
	for(int i=0;i<3;i++)
		cout<<p4[i]<<endl;
	delete[] p4;
	Student *p5=new Student;
	p5->name="张飞";
	p5->id=25;
	cout<<p5->name<<' '<<p5->id<<endl;
	return 0;
}
