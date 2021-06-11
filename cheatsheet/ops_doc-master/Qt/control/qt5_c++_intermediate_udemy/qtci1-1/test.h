#ifndef TEST_H
#define TEST_H

#include <QObject>

class test : public QObject
{
    Q_OBJECT
public:
    explicit test(QObject *parent = nullptr);
    ~test() noexcept;

    void makeChild(QString name);
signals:

public slots:
};

#endif // TEST_H
