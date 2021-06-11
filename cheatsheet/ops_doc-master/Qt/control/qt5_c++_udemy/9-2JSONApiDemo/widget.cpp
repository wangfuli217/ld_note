#include "widget.h"
#include "ui_widget.h"
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QVariantMap>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget),
    mNetManager(new QNetworkAccessManager(this)),
    mNetReply(nullptr),
    mDataBuffer(new QByteArray)
{
    ui->setupUi(this);
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_fetchButton_clicked()
{
    const QUrl API_ENDPOINT("https://jsonplaceholder.typicode.com/posts");
    QNetworkRequest request;
    request.setUrl(API_ENDPOINT);

    mNetReply = mNetManager->get(request);
    connect(mNetReply, &QIODevice::readyRead, this, &Widget::dataReadReady);
    connect(mNetReply, &QNetworkReply::finished, this, &Widget::dataReadFinished);
}

void Widget::dataReadReady()
{
    mDataBuffer->append(mNetReply->readAll());
}

void Widget::dataReadFinished()
{
    if(!mNetReply->errorString().isEmpty()) {
        qDebug() << "error: " << mNetReply->errorString();
    } else {
        qDebug() << "data fetch finished: " << QString(*mDataBuffer);

        QJsonDocument doc = QJsonDocument::fromJson(*mDataBuffer);
        QJsonArray array = doc.array();

        for(int i{0}; i < array.size(); ++i) {
            QJsonObject object = array.at(i).toObject();
            QVariantMap map = object.toVariantMap();

            QString title = map["title"].toString();
            ui->listWidget->addItem("[" + QString::number(i+1) + "] " + title);
        }
    }
}

