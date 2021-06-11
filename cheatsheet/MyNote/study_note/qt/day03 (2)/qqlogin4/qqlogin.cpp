#include "qqlogin.h"
#include "ui_qqlogin.h"
#include <QMessageBox>
QqLogin::QqLogin(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::QqLogin)
{
    ui->setupUi(this);
    connect(ui->blogin,SIGNAL(clicked()),
        this,SLOT(loginAndCancel()));
    connect(ui->bcancel,SIGNAL(clicked()),
        this,SLOT(loginAndCancel()));
}
void  QqLogin::loginAndCancel(){
    if(sender()==ui->blogin){
        if(ui->username->text()=="abc"&&
          ui->userpasswd->text()=="123"){
            qDebug("login success!");
        }else{
            qDebug("login failed!");
        }
    }
    if(sender()==ui->bcancel){
        QMessageBox  msg(this);
        msg.setText("are you quit?");
        msg.setStandardButtons(
          QMessageBox::Yes|QMessageBox::No);
        if(msg.exec()==QMessageBox::Yes){
          this->close();
        }
    }
}
QqLogin::~QqLogin()
{
    delete ui;
}



