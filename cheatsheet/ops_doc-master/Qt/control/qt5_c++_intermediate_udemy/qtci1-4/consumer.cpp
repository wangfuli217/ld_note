#include "consumer.h"
#include <QDebug>

consumer::consumer(QObject *parent) : QObject(parent)
{
    qInfo() << "ctor" << this;
}

consumer::~consumer() noexcept
{
    qInfo() << "dtor" << this;

}
