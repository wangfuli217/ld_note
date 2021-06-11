#include "widget.h"
#include "ui_widget.h"
#include <QFileSystemModel>
#include <QDebug>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
    mModel = new QFileSystemModel(this);
    mParentIndex = mModel->setRootPath("C:/Users/mikolaj/Documents/repos/qt_learn/qt5_c++_udemy/10-1QModelIndexDemo");
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_pushButton_clicked()
{
    int rowCount = mModel->rowCount(mParentIndex);
    qDebug() << QString::number(rowCount);

    for(int i{0}; i < rowCount; ++i) {
        QModelIndex index = mModel->index(i, 0, mParentIndex);
        QString data = mModel->data(index, Qt::DisplayRole).toString();
        qDebug() << QString::number(i) << data;
    }
}
