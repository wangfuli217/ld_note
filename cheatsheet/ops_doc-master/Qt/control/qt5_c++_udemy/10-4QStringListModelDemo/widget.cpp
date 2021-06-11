#include "widget.h"
#include "ui_widget.h"
#include <QDebug>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    mModel = new QStringListModel(this);
    QStringList list;
    list << "Cow" << "Rooster" << "Lion" << "Dog" << "Cat";
    mModel->setStringList(list);
    ui->listView->setModel(mModel);
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_pushButton_clicked()
{
    QStringList list = mModel->stringList();
    qDebug() << list;
}
