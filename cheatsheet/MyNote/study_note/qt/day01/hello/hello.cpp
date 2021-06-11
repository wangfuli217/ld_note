#include<QApplication>   //包含QApplication(应用)类的声明头文件
#include<QLabel>   //包含QLabel(标签)组件类的声名头文件
int main(int argc,char *argv[])
{
	//实例化QApplication对象,管理程序的资源,控制事件流程
	QApplication app(argc,argv);
	//实例化QLabel对象,显示静态文本,在内存创建,并不可见
	QLabel lab("<h1><i>Hello,</i><font color=red>Qt</font></h1>"); 
	lab.show();   //显示
	return app.exec();			//事件循环
}
