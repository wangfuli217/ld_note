#include "widget.h"
#include "ui_widget.h"
#include <QNetworkReply>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
    mNetManager = new QNetworkAccessManager(this);
    mNetReply = nullptr;
    mDataBuffer = new QByteArray();

    // Define network request
    QNetworkRequest request{};
    request.setUrl(QUrl("https://www.qt.io"));
    mNetReply = mNetManager->get(request);
    connect(mNetReply, &QIODevice::readyRead, this, &Widget::dataReadyToRead);
    connect(mNetReply, &QNetworkReply::finished, this, &Widget::dataReadFinished);
}

Widget::~Widget()
{
    delete ui;
}

void Widget::dataReadyToRead()
{
    qDebug() << "Data available";
    mDataBuffer->append(mNetReply->readAll());
}

void Widget::dataReadFinished()
{
    if(!mNetReply->errorString().isEmpty()) {
        qDebug() << "error: " << mNetReply->errorString();
    }
    else {
        ui->textEdit->setPlainText(QString(*mDataBuffer));
    }
}
