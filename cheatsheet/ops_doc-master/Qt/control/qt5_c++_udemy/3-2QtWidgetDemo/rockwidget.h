#ifndef ROCKWIDGET_H
#define ROCKWIDGET_H

#include <QObject>
#include <QWidget>

class RockWidget : public QWidget
{
    Q_OBJECT
public:
    explicit RockWidget(QWidget *parent = nullptr);
signals:

private slots:
    void buttonClicked();

private:
    // This method is automatically called on startup of the application
    QSize sizeHint() const;
};

#endif // ROCKWIDGET_H
