#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>

namespace Ui {
class Widget;
}

class Widget : public QWidget
{
    Q_OBJECT

public:
    explicit Widget(QWidget *parent = nullptr);
    ~Widget();

private slots:
    void on_textColorButton_clicked();

    void on_backgroundButton_clicked();

    void on_fontButton_clicked();

private:
    Ui::Widget *ui;
};

#endif // WIDGET_H
