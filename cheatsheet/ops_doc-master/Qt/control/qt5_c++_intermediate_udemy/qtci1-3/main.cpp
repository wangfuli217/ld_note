#include <QCoreApplication>
#include <QDebug>
#include <QScopedPointer>
#include "test.h"

void useIt(test* obj);
void create();
void testFunc(QScopedPointer<test>& myPtr);

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    for(int i{0}; i < 20; ++i) {
        qInfo() << "\nNext loop iteration";
        create();
    }
    return a.exec();
}

void useIt(test* obj) {
    if(not obj) return;
    qInfo() << "Using" << obj;
}

void create() {
//    test* t = new test(); // dangling pointer!
    QScopedPointer<test> myPtr(new test());
    useIt(myPtr.data());
//    testFunc(myPtr);
}

void testFunc(QScopedPointer<test>& myPtr) {
    qInfo() << myPtr.data();
}
