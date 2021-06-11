#include <QCoreApplication>
#include <QDebug>
#include <QList>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QList<QString> stringList;
    stringList << "I am" << "loving" << "qt";
    stringList.append("a");
    stringList.append("lot");

    qDebug() << stringList.count();

    for(auto elem : stringList)
        qDebug() << elem;

    return a.exec();
}
