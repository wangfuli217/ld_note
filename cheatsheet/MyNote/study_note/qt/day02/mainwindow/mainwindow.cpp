#include<QApplication>
#include<QLabel>
#include<QTextCodec>
#include<QMainWindow>
#include<QPushButton>

int main(int argc,char *argv[])
{
	QTextCodec::setCodecForTr(QTextCodec::codecForName("utf-8"));
	QApplication app(argc,argv);
	QMainWindow wnd;
	wnd.resize(210,110);
	wnd.move(300,200);
	QLabel *lab=new QLabel(QObject::tr("我是标签子窗口!"),&wnd);
	lab->move(30,20);
	lab->resize(150,20);
	QPushButton *btn=new QPushButton(QObject::tr("退出"),&wnd);
	btn->move(30,40);
	btn->resize(70,20);
	QObject::connect(btn,SIGNAL(clicked(void)),&app,SLOT(quit(void)));
	wnd.show();
	return app.exec();
}
