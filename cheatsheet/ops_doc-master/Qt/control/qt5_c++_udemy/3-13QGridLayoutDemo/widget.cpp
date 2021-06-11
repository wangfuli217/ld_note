#include "widget.h"
#include "ui_widget.h"
#include <QGridLayout>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    QGridLayout* layout = new QGridLayout(this); // wihout 'this' you need to setLayout()
    layout->addWidget(ui->pushButton_1, 0, 0);
    layout->addWidget(ui->pushButton_2, 0, 1);
    layout->addWidget(ui->pushButton_3, 0, 2);
    layout->addWidget(ui->pushButton_4, 1, 0);
    layout->addWidget(ui->pushButton_5, 1, 1);
    layout->addWidget(ui->pushButton_6, 1, 2);
    layout->addWidget(ui->pushButton_7, 2, 0);
    layout->addWidget(ui->pushButton_8, 2, 1);
    layout->addWidget(ui->pushButton_9, 2, 2);

//    setLayout(layout);
}

Widget::~Widget()
{
    delete ui;
}
