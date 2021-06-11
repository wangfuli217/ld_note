#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include <QNetworkAccessManager>

namespace Ui {
class Widget;
}

class Widget : public QWidget
{
    Q_OBJECT

public:
    explicit Widget(QWidget *parent = nullptr);
    ~Widget();

public slots:
    void dataReadyToRead();
    void dataReadFinished();

private:
    Ui::Widget *ui;
    QNetworkAccessManager* mNetManager;
    QNetworkReply* mNetReply;
    QByteArray* mDataBuffer;
};

#endif // WIDGET_H
