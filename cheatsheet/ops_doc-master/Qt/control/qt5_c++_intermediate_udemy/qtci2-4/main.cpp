#include <QCoreApplication>
#include <QMap>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QMap<QString, int> hobbits;
    hobbits["Frodo"] = 1;
    hobbits["Sam"] = 2;
    hobbits["Merry"] = 3;
    hobbits["Pippin"] = 4;
    hobbits["Bilbo"] = 5;

    qInfo() << hobbits.size();
    qInfo() << hobbits.keys();
    qInfo() << hobbits.values();

    return a.exec();
}
