#include <QCoreApplication>
#include <QApplication>
#include "subproc.h"

int main(int argc, char *argv[])
{
    //QCoreApplication a(argc, argv); //QWidget: Cannot create a QWidget without QApplication!
    QApplication a(argc, argv);

    SubProC subclass;

    subclass.show();

    return a.exec();
}

