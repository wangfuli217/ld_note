#ifndef CONSUMER_H
#define CONSUMER_H

#include <QObject>
#include <QSharedPointer>
#include "test.h"
class consumer : public QObject
{
    Q_OBJECT
public:
    explicit consumer(QObject *parent = nullptr);
    ~consumer() noexcept;

signals:

public slots:

public:
    QSharedPointer<test> tester;
};

#endif // CONSUMER_H
