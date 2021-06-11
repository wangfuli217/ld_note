#include "Calculator.h"
#include<QApplication>
#include<QTextCodec>

int main(int argc,char *argv[])
{
	QTextCodec::setCodecForTr(QTextCodec::codecForName("utf-8"));
	QApplication app(argc,argv);
	Calculator dlg;
	dlg.show();
	return app.exec();
}
