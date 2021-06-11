#include "test.h"
#include <QDebug>
#include <QtGlobal>

test::test(QObject *parent) : QObject(parent)
{
    qInfo() << "ctor";
}

test::~test() noexcept {
    qInfo() << "dtor";
}
