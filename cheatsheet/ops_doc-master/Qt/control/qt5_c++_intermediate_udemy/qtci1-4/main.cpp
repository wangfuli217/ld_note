#include <QCoreApplication>
#include <QDebug>
#include "consumer.h"

using testPtr = QSharedPointer<test>;
using consumerPtr = QSharedPointer<consumer>;

void doDeleteLater(test* obj) {
    qInfo() << "Deleting: " << obj;
    obj->deleteLater();
}

testPtr createPtr() {
    test* t = new test();
    t->setObjectName("Test ptr");
    testPtr p(t, doDeleteLater);
    return p;
}

void doStuff(consumerPtr ptr) {
    qInfo() << "doStuff: " << ptr.data()->tester;
    ptr.clear(); // not deleting, just removing the reference
}

consumerPtr makeConsumer() {
    consumerPtr c(new consumer, &QObject::deleteLater);
    testPtr ptr = createPtr();
    c.data()->tester.swap(ptr);
    doStuff(c);

    return c;
}

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    consumerPtr c = makeConsumer();
    qInfo() << "main :" << c.data()->tester;
    c.clear();
    return a.exec();
}
