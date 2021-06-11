#include "widget.h"
#include "ui_widget.h"
#include <QDebug>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    QString path = "C:/";

    mDirModel = new QFileSystemModel(this);
    mDirModel->setFilter(QDir::NoDotAndDotDot | QDir::Dirs);
    mDirModel->setRootPath(path);
    ui->treeView->setModel(mDirModel);

    mFilesModel = new QFileSystemModel(this);
    mFilesModel->setFilter(QDir::NoDotAndDotDot | QDir::Files);
    mFilesModel->setRootPath(path);
    ui->listView->setModel(mFilesModel);
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_treeView_clicked(const QModelIndex &index)
{
    QString path = mDirModel->fileInfo(index).absoluteFilePath();
    qDebug() << path;
    ui->listView->setRootIndex(mFilesModel->setRootPath(path));
}
