#include "CalculatorDlg.h"
#include<QApplication>

int main(int argc,char *argv[])
{
	QApplication app(argc,argv);
	CalculatorDlg dlg;
	dlg.show();
	return app.exec();
}
