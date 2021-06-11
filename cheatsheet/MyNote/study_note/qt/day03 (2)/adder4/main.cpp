#include <QtGui/QApplication>
#include "adder.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    Adder w;
    w.show();
    
    return a.exec();
}
