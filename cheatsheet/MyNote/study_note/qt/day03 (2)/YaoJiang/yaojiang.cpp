#include "yaojiang.h"
#include "ui_yaojiang.h"
#include <QPainter>
#include <QTime>
YaoJiang::YaoJiang(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::YaoJiang)
{   qsrand(QTime::currentTime().msec());
    ui->setupUi(this);
    ind=-1;
    paintFlag=false;
    names[0]="xiaoli";
    names[1]="xiaoqian";
    names[2]="xiaofei";
    names[3]="xiaoxue";
    names[4]="xiaoyu";
    /* 定时器相关的代码 */
    timer=new QTimer(this);
    timer->setInterval(200);
    timer->start();
    // 让当前对象重画的槽函数 repaint()
    connect(timer,SIGNAL(timeout()),
        this,SLOT(repaint()));
    /* 当前对象重画时 应该根据图片
       显示相应的名字 */
    connect(timer,SIGNAL(timeout()),
        this,SLOT(changeName()));
    /* 连接按钮到自定义槽函数 */
    connect(ui->bstart,SIGNAL(clicked()),
        this,SLOT(changePaintFlag()));
    connect(ui->bstop,SIGNAL(clicked()),
        this,SLOT(changePaintFlag()));
}
void  YaoJiang::changeName(){
    if(ind!=-1){
      ui->pname->setText(names[ind-1]);
    }
}
void  YaoJiang::changePaintFlag(){
    if(sender()==ui->bstart){
        paintFlag=true;
    }
    if(sender()==ui->bstop){
        paintFlag=false;
    }
}
void  YaoJiang::paintEvent(QPaintEvent *e){
    QPainter  qp(this);
    // qp.drawLine(0,0,400,600);
    if(paintFlag){
    ind=(qrand()%5)+1;
    /* 随机加载一张图片 */
    QString  imgpath=":/img/";
    imgpath=imgpath+QString::number(ind);
    imgpath+=".jpg";
    img.load(imgpath);
    img=img.scaled(320,480);
    // qp.drawImage(40,40,img);
    }
    /* 内存中有什么样 就绘制这张图片 */
    qp.drawImage(40,40,img,0,0,160,240);
    qp.drawImage(200,280,img,160,240,
        160,240);
}

YaoJiang::~YaoJiang()
{
    delete ui;
}
