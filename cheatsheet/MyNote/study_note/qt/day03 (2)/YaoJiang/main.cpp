#include <QtGui/QApplication>
#include "yaojiang.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    YaoJiang w;
    w.show();
    
    return a.exec();
}
