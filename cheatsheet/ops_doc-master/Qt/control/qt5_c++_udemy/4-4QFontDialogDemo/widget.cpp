#include "widget.h"
#include "ui_widget.h"
#include <QFontDialog>
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

void Widget::on_chooseFontButton_clicked()
{
    bool success{};
    QFont font = QFontDialog::getFont(&success, QFont("Arial", 10), this);

    if(success) {
        ui->label->setFont(font);
    } else {
        QMessageBox::information(this, "Message box", "User didn't choose a font");
    }
}
