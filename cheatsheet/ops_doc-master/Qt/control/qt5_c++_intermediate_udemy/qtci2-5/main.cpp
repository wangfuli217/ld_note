#include <QCoreApplication>
#include <QLinkedList>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QLinkedList<int> list;
    for(int i{0}; i < 10; ++i)
        list.push_back(i);

    list.removeFirst();
    list.removeLast();
    list.removeOne(3);

    for(auto& elem : list)
        qInfo() << elem;

    qInfo() << list.size();
    list.clear();
    qInfo() << list.size();

    return a.exec();
}
