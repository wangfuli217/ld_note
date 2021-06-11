#include <QCoreApplication>
#include <QStorageInfo>
#include <QFileInfo>
#include <QDir>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    foreach(QStorageInfo storage, QStorageInfo::mountedVolumes()) {
        qInfo() << "Name: " << storage.displayName();
        qInfo() << "Type: " << storage.fileSystemType();
        qInfo() << "Total: " << storage.bytesTotal()/1024/1024 << "MB";
        qInfo() << "Available: " << storage.bytesAvailable()/1024/1024 << "MB";
        qInfo() << "#############################################################";
    }

    return a.exec();
}
