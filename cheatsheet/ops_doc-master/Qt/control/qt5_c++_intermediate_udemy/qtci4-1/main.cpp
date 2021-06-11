#include <QCoreApplication>
#include <QIODevice>
#include <QBuffer>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QBuffer buffer;
    if(buffer.open(QIODevice::ReadWrite)) {
        qInfo() << "Buffer opened";
        QByteArray data("Hello World");
        for(uint i{0}; i < 5; ++i) {
            buffer.write(data);
            buffer.write("\r\n");
        }

        buffer.seek(0);

        qInfo() << buffer.readAll();
        buffer.close();
    } else {
        qInfo() << "Buffer not opened";
    }

    return a.exec();
}
