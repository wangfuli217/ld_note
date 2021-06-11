#include "widget.h"
#include <QPushButton>
#include <QMessageBox>
#include <QDebug>

Widget::Widget(QWidget *parent) :
    QWidget(parent)
{
    QPushButton* button = new QPushButton(this);
    button->setText("click");
    button->move(200, 200);
    connect(button, &QPushButton::clicked, [this](){
        // The hard way- critical/information/question/warning
//        QMessageBox message;
//        message.setMinimumSize(600, 600);
//        message.setWindowTitle("Message");
//        message.setText("Something happened");
//        message.setInformativeText("Do you want to do something about it?");
//        message.setIcon(QMessageBox::Warning);
//        message.setStandardButtons(QMessageBox::Cancel | QMessageBox::Ok);
//        message.setDefaultButton(QMessageBox::Ok);
//        int ret = message.exec();

        // The easy way- critical/information/question/warning
        int ret = QMessageBox::critical(this, "Message", "Something happened", QMessageBox::Ok | QMessageBox::Cancel, QMessageBox::Ok);

        if(ret == QMessageBox::Ok)
            qDebug() << "Ok";
        else if(ret == QMessageBox::Cancel)
            qDebug() << "Cancel";
    });
}

Widget::~Widget()
{

}
