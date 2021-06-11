#include<QTextCodec>
#include<QApplication>
#include "time.h"

int main(int argc,char *argv[])
{
	QTextCodec::setCodecForTr(QTextCodec::codecForName("utf-8"));
	QApplication app(argc,argv);
	TimeDlg dlg;
	dlg.show();
	return app.exec();
}
