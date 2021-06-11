#include "dialog.h"
#include "ui_dialog.h"

Dialog::Dialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Dialog)
{
    ui->setupUi(this);
}

Dialog::~Dialog()
{
    delete ui;
}

void  Dialog::mousePressEvent
    (QMouseEvent *e){
    switch(e->buttons()){
        case Qt::LeftButton:
        qDebug("left button clicked()%d:%d"
             ,e->x(),e->y());
        break;
        case Qt::MidButton:
        qDebug("mid button clicked()");
        break;
        case Qt::RightButton:
        qDebug("right button clicked()");
        break;
    }
}

void  Dialog::keyPressEvent(QKeyEvent *e){
    switch(e->key()){
        case Qt::Key_Up:
        qDebug("up key ");
        break;
        case Qt::Key_Down:
        qDebug("down key ");
        break;
        case Qt::Key_Left:
        qDebug("left key ");
        break;
        case Qt::Key_Right:
        qDebug("right key ");
        break;
    }
}






