#include <QCoreApplication>
#include <QSet>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QSet<QString> hobbits;
    hobbits << "Frodo" << "Bilbo" << "Sam";
    hobbits.insert("Pippin");
    hobbits.insert("Merry");
    hobbits.insert("Merry");

    foreach(QString hobbit, hobbits) {
        qInfo() << hobbit;
    }

    qInfo() << hobbits.size();
    qInfo() << hobbits.contains("Frodo"); // true
    qInfo() << hobbits.contains("Gandalf"); // false

    return a.exec();
}
