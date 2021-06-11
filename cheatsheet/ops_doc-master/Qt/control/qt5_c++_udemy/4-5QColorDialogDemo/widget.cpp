#include "widget.h"
#include "ui_widget.h"
#include <QColorDialog>
#include <QFontDialog>
#include <QDebug>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
    ui->label->setAutoFillBackground(true);
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_textColorButton_clicked()
{
    QPalette palette = ui->label->palette();
    QColor color = palette.color(QPalette::WindowText);

    QColor chosenColor = QColorDialog::getColor(color, this, "Choose text color");

    if(chosenColor.isValid()) {
        palette.setColor(QPalette::WindowText, chosenColor);
        ui->label->setPalette(palette);
        qDebug() << "Valid color";
    }
    else {
        qDebug() << "Not valid color";
    }
}

void Widget::on_backgroundButton_clicked()
{
    QPalette palette = ui->label->palette();
    QColor color = palette.color(QPalette::Window);

    QColor chosenColor = QColorDialog::getColor(color, this, "Choose text color");

    if(chosenColor.isValid()) {
        palette.setColor(QPalette::Window, chosenColor);
        ui->label->setPalette(palette);
        qDebug() << "Valid color";
    }
    else {
        qDebug() << "Not valid color";
    }
}

void Widget::on_fontButton_clicked()
{
    bool success{};
    QFont font = QFontDialog::getFont(&success, QFont("Arial", 10), this);

    if(success) {
        ui->label->setFont(font);
        qDebug() << "Valid font";
    }
    else {
        qDebug() << "Not valid font";
    }
}
