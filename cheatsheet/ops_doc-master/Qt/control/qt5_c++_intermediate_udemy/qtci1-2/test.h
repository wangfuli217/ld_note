#ifndef TEST_H
#define TEST_H

#include <QObject>
#include <QPointer>

class test : public QObject
{
    Q_OBJECT
public:
    explicit test(QObject *parent = nullptr);

    void useWidget();
signals:

public slots:

public:
    QPointer<QObject> widget;
};

#endif // TEST_H
