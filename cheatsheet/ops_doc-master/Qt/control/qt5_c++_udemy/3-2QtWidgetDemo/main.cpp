#include <QApplication>
#include "rockwidget.h"
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    RockWidget w;
    w.show();
    return a.exec();
}
