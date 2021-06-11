#include "widget.h"
#include "ui_widget.h"
#include <QFileDialog>
#include <QMessageBox>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_chooseDirButton_clicked()
{
    QString dirName = QFileDialog::getExistingDirectory(this, "Choose folder");
    if(dirName.isEmpty())
        return;

    ui->lineEdit->setText(dirName);
}

void Widget::on_createDirButton_clicked()
{
    QString dirName = ui->lineEdit->text();
    if(dirName.isEmpty())
        return;

    QDir dir(dirName);
    if(!dir.exists() && dir.mkpath(dirName))
        QMessageBox::information(this, "Message", "Directory created!");
    else
        QMessageBox::information(this, "Message", "Directory already exists!");
}

void Widget::on_dirExistButton_clicked()
{
    QString dirName = ui->lineEdit->text();

    if(dirName.isEmpty())
        return;

    QDir dir(dirName);
    if(dir.exists())
        QMessageBox::information(this, "Message", "Directory exists!");
    else
        QMessageBox::information(this, "Message", "Directory doesn't exist!");
}

void Widget::on_DirOrFileButton_clicked()
{
    QFileInfo fileInfo(ui->listWidget->currentItem()->text());
    if(fileInfo.isDir())
        QMessageBox::information(this, "Message", "Directory");
    else if(fileInfo.isFile())
        QMessageBox::information(this, "Message", "File");
    else
        QMessageBox::information(this, "Message", "Something else");
}

void Widget::on_DirContentsButton_clicked()
{
    QString dirName = ui->lineEdit->text();

    if(dirName.isEmpty())
        return;

    QDir dir(dirName);
    auto fileInfo = dir.entryInfoList();

    ui->listWidget->clear();
    for(auto info : fileInfo)
        ui->listWidget->addItem(info.absoluteFilePath());
}
