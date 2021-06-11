#include "subproc.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    SubProC w;
    w.show();

    return a.exec();
}
