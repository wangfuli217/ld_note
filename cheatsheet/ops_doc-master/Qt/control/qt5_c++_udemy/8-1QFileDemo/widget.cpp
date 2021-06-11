#include "widget.h"
#include "ui_widget.h"
#include <QFile>
#include <QFileDialog>
#include <QTextStream>
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

void Widget::on_writeButton_clicked()
{
    QString filename = QFileDialog::getSaveFileName(this, "Save as");
    if(filename.isEmpty())
        return;

    QFile file(filename);
    if(!file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Append))
        return;

    QTextStream output(&file);
    output << ui->textEdit->toPlainText() << "\n";

    file.close();
}

void Widget::on_readButton_clicked()
{
    QString filename = QFileDialog::getOpenFileName(this, "Open file");
    if(filename.isEmpty())
        return;

    QFile file(filename);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    QTextStream input(&file);
    QString fileContent{input.readAll()};

    file.close();

    ui->textEdit->clear();
    ui->textEdit->setPlainText(fileContent);
}

void Widget::on_selectFileButton_clicked()
{
    QString filename = QFileDialog::getOpenFileName(this, "Choose the file");
    if(filename.isEmpty()) return;

    ui->sourceLineEdit->setText(filename);
}

void Widget::on_copyButton_clicked()
{
    QString srcFileName = ui->sourceLineEdit->text();
    QString destFileName = ui->destinationLineEdit->text();

    if(srcFileName.isEmpty() || destFileName.isEmpty()) return;

    QFile file(srcFileName);
    if(file.copy(destFileName))
        QMessageBox::information(this, "File copy", "File copied succesfuly!");
    else
        QMessageBox::information(this, "File copy", "File not copied!");
}
