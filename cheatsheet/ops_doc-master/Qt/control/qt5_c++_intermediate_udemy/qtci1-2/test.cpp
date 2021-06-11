#include "test.h"
#include <QDebug>

test::test(QObject *parent) : QObject(parent)
{

}

void test::useWidget()
{
    if(!widget.data()) {
        qInfo() << "widget is empty";
        return;
    }

    qInfo() << "Widget = " << widget.data();
    widget.data()->setObjectName("used widget");
}
