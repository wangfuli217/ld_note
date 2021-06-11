#include "widget.h"
#include "ui_widget.h"
#include <QDebug>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);


    ui->comboBox->addItem("Mercury");
    ui->comboBox->addItem("Venus");
    ui->comboBox->addItem("Earth");
    ui->comboBox->addItem("Mars");
    ui->comboBox->addItem("Jupiter");
    ui->comboBox->addItem("Saturn");
    ui->comboBox->addItem("Uranus");

    // Make combobox editable
    ui->comboBox->setEditable(true);
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_captureValueButton_clicked()
{
    qDebug() << "The currently selected value is: " << ui->comboBox->currentText()
             << "and the index is: " << QString::number(ui->comboBox->currentIndex());
}

void Widget::on_setValueButton_clicked()
{
    ui->comboBox->setCurrentText("Venus");
}

void Widget::on_getValuesButton_clicked()
{
    qDebug() << "The combo box currently has " << ui->comboBox->count();
}
