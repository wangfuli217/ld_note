#include<QTextCodec>
#include<QApplication>
#include<QLabel>
#include<QPushButton>
int main(int argc,char *argv[])
{
	QTextCodec::setCodecForTr(QTextCodec::codecForName("utf-8"));
	QApplication app(argc,argv);
	QLabel lab(QObject::tr("点击关闭按钮干掉我"));
	QPushButton btn(QObject::tr("关闭"));
	QPushButton btn1(QObject::tr("退出"));
	QObject::connect(&btn,SIGNAL(clicked(void)),&lab,SLOT(close(void)));
	QObject::connect(&btn1,SIGNAL(clicked(void)),&app,SLOT(quit(void)));
	lab.show();
	btn.show();
	btn1.show();
	return app.exec();
}
