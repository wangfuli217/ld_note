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
    void on_chooseDirButton_clicked();

    void on_createDirButton_clicked();

    void on_dirExistButton_clicked();

    void on_DirOrFileButton_clicked();

    void on_DirContentsButton_clicked();

private:
    Ui::Widget *ui;
};

#endif // WIDGET_H
