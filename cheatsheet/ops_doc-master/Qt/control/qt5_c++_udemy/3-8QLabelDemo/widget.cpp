#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
    ui->minionTextLabel->move(100, 30);

    QPixmap minionPixmap("://images/minions.jpg");
    ui->imageLabel->move(0, 70);
    ui->imageLabel->setMinimumSize(500,500);
    ui->imageLabel->setPixmap(minionPixmap.scaled(400, 400));
}

Widget::~Widget()
{
    delete ui;
}
