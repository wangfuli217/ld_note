#include "widget.h"
#include "ui_widget.h"
#include <QButtonGroup>
#include <QDebug>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    QButtonGroup* chooseOsButtonGroup = new QButtonGroup(this);

    chooseOsButtonGroup->addButton(ui->windowsCheckBox);
    chooseOsButtonGroup->addButton(ui->linuxCheckBox);
    chooseOsButtonGroup->addButton(ui->macCheckBox);

    chooseOsButtonGroup->setExclusive(true);
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_windowsCheckBox_toggled(bool checked)
{
    if(checked)
        qDebug() << "windows checked";
    else
        qDebug() << "windows unchecked";
}

void Widget::on_beerCheckBox_toggled(bool checked)
{
    if(checked)
        qDebug() << "beer checked";
    else
        qDebug() << "beer unchecked";
}

void Widget::on_aRadioButton_toggled(bool checked)
{
    if(checked)
        qDebug() << "A checked";
    else
        qDebug() << "A unchecked";
}

void Widget::on_pushButton_clicked()
{
    if(ui->windowsCheckBox->isChecked())
        qDebug() << "windows checked";
    else
        qDebug() << "windows unchecked";
}

void Widget::on_pushButton_2_clicked()
{
    ui->beerCheckBox->setChecked(!ui->beerCheckBox->isChecked());
}
