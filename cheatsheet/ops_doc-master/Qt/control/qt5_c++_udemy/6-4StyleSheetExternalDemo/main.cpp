#include "widget.h"
#include <QApplication>
#include <QFile>
#include <QTextStream>
#include <QDebug>

QString readTextFile(const QString& path) {
    QFile file{path};

    if(file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        return in.readAll();
    }

    return "";
}

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    QString css = readTextFile(":/style.css");
    if(css.length() > 0) {
        qDebug() << "Valid style sheet";
        a.setStyleSheet(css);
    } else {
        qDebug() << "Invalid style sheet";
    }

    Widget w;
    w.show();

    return a.exec();
}
