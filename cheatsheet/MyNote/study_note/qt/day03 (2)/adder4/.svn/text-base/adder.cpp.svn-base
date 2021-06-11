#include "adder.h"
#include "ui_adder.h"

Adder::Adder(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Adder)
{
    ui->setupUi(this);
    connect(ui->equ,SIGNAL(clicked())
           ,this,SLOT(getRes()));
}
void  Adder::getRes(){
    ui->res->setText(QString::number(
        ui->add->text().toDouble()+
        ui->added->text().toDouble()));
    qDebug("call getRes()");
}

Adder::~Adder()
{
    delete ui;
}
