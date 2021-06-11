#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>
#include <QMouseEvent>
#include <QKeyEvent>
namespace Ui {
class Dialog;
}

class Dialog : public QDialog
{
    Q_OBJECT
    
public:
    explicit Dialog(QWidget *parent = 0);
    ~Dialog();
    
private:
    Ui::Dialog *ui;
/* 鼠标事件处理函数 */
public:
    void  mousePressEvent(QMouseEvent *e);
/* 键盘事件处理函数  */
    void  keyPressEvent(QKeyEvent *e);
};

#endif // DIALOG_H



