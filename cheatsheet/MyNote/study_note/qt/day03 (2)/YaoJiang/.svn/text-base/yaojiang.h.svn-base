#ifndef YAOJIANG_H
#define YAOJIANG_H

#include <QDialog>
#include <QImage>
#include <QTimer>
namespace Ui {
class YaoJiang;
}

class YaoJiang : public QDialog
{
    Q_OBJECT
    
public:
    explicit YaoJiang(QWidget *parent = 0);
    ~YaoJiang();
    
private:
    Ui::YaoJiang *ui;
    /* 要绘制的图片 */
    QImage   img;
    /* 随机的图片下标 */
    int      ind;
    /* 控制重画的定时器 */
    QTimer   *timer;
    /* 控制是否绘制的标志 */
    bool     paintFlag;
    /* 参与摇奖的人名 */
    QString  names[5];
/* 绘制事件处理函数 */
public:
    void  paintEvent(QPaintEvent *e);
/* 控制绘制标志的槽函数 */
public slots:
    void  changePaintFlag();
/* 改变名字的槽函数 */
public slots:
    void  changeName();
};

#endif // YAOJIANG_H


