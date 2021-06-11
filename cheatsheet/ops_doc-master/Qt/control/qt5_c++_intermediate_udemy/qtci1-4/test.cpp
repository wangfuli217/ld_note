#include "test.h"
#include <QDebug>

test::test(QObject *parent) : QObject(parent)
{
    qInfo() << "ctor" << this;
}

test::~test() noexcept {
    qInfo() << "dtor" << this;
}
