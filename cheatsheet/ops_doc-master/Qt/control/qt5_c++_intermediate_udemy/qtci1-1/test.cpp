#include "test.h"
#include <QDebug>

test::test(QObject *parent) : QObject(parent)
{
    qInfo() << this << "Constructed";
}

test::~test() noexcept
{
    qInfo() << this << "Deconstructed";
}

void test::makeChild(QString name)
{
    test* child = new test(this);
    child->setObjectName(name);
}
