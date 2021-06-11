#include <QCoreApplication>
#include <QHash>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QHash<QString, int> ages;
    ages.insert("Frodo", 4);
    ages.insert("Sam", 8);
    ages.insert("Merry", 15);
    ages.insert("Pippin", 16);
    ages.insert("Bilbo", 23);
    ages.insert("Gandalf", 42);

    qInfo() << ages["Frodo"];
    qInfo() << ages.keys();
    qInfo() << ages.values();
    qInfo() << ages.size();

    foreach(QString key, ages.keys()){
        qInfo() << key << " = " << ages[key];
    }

    return a.exec();
}
