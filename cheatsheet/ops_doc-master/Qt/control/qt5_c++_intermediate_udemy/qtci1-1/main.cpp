#include <QCoreApplication>
#include "test.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    test* p = new test(&a);

    for(int i{0}; i < 5; ++i)
        p->makeChild(QString::number(i));

    return a.exec();
}
