#include <QCoreApplication>
#include <QDir>
#include <QDebug>
#include <QString>
#include <QFileInfo>

bool createDir(const QString& path) {
    QDir dir(path);

    if(dir.exists()) {
        qInfo() << "Already exists";
        return true;
    }

    if(dir.mkpath(path)) {
        qInfo() << "Dir created";
        return true;
    }

    qInfo() << "Couldn't create a dir";
    return false;
}

bool renameDir(const QString& path, const QString& name) {
    QDir dir(path);

    if(!dir.exists()) {
        qInfo() << "Dir doesn't exist";
        return false;
    }

    int pos = path.lastIndexOf(QDir::separator()); // difference between slash and backslash in the path
    QString parent = path.mid(0, pos);
    QString newpath = parent + QDir::separator() + name;

    qInfo() << "Absolute path: " << dir.absolutePath();
    qInfo() << "Parent: " << parent;
    qInfo() << "New: " << newpath;

    return dir.rename(path, newpath);
}

bool removeDir(const QString& path) {
    qInfo() << "Removing: " << path;
    QDir dir(path);

    if(!dir.exists()) {
        qInfo() << "Dir doesn't exist";
        return false;
    }

    return dir.removeRecursively();
}

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QString path = QDir::currentPath();
    QString test = path + QDir::separator() + "test";
    QString tmp = path + QDir::separator() + "tmp";

    QDir current(QDir::currentPath());
    if(current.exists()) {
        foreach(QFileInfo file, current.entryInfoList()) {
            qInfo() << file.fileName();
        }
    }

    if(createDir(test)) {
        qInfo() << "created test dir";
        if(renameDir(test, "tmp")) {
            qInfo() << "renamed test -> tmp";
            if(removeDir(tmp))
                qInfo() << "removed";
            else
                qInfo() << "didn't remove";
        }
    }
    return a.exec();
}
