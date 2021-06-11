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
    void on_checkButton_clicked();

    void on_restartButton_clicked();

private:
    void generateSecretNumber();

private:
    Ui::Widget *ui;
    int secretNumber{};
    int guessNumber{};
};

#endif // WIDGET_H
