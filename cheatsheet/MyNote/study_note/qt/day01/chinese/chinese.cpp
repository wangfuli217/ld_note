#include<QApplication>   //包含QApplication(应用)类的声明头文件
#include<QLabel>   //包含QLabel(标签)组件类的声名头文件
#include<QTextCodec>
#include<QPushButton>
int main(int argc,char *argv[])
{
	//实例化QApplication对象,管理程序的资源,控制事件流程
	QApplication app(argc,argv);
	QTextCodec* codec=QTextCodec::codecForName("utf-8");
	QTextCodec::setCodecForTr(codec);
	//实例化QLabel对象,显示静态文本,在内存创建,并不可见
	QLabel lab(QObject::tr("<h1><i>你好,</i><font color=red>Qt</font></h1>")); 
	QPushButton PushButton(QObject::tr("按我"));
	lab.show();   //显示
	PushButton.show();
	return app.exec();			//事件循环
}
