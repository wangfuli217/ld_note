#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QFileInfoList>
#include <QDateTime>
#include <QDebug>

void list(const QString& path) {
    qInfo() << "Listing: " << path;

    QDir dir(path);
    qInfo() << dir.absolutePath();

    QFileInfoList dirs = dir.entryInfoList(QDir::Dirs | QDir::NoDotAndDotDot);
    QFileInfoList files = dir.entryInfoList(QDir::Files);

    foreach(QFileInfo dir, dirs) {
        qInfo() << dir.fileName();
    }

    foreach(QFileInfo file, files) {
        qInfo() << "Name: " << file.fileName();
        qInfo() << "Size: " << file.size();
        qInfo() << "Created: " << file.birthTime();
        qInfo() << "Modified: " << file.lastModified();
    }

    foreach(QFileInfo dir, dirs) {
        list(dir.absolutePath());
    }
}

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    list(QDir::tempPath());
    return a.exec();
}
