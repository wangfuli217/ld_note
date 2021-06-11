#include "widget.h"
#include <QPushButton>
#include <QDebug>

Widget::Widget(QWidget *parent)
    : QWidget(parent)
{
    QPushButton* button = new QPushButton("click", this);
    QFont buttonFont("Arial", 20, QFont::Bold);
    button->setMinimumSize(200,200);
    button->setFont(buttonFont);
    connect(button, &QPushButton::clicked, [](){
        qDebug() << "Button clicked";
    });
    connect(button, &QPushButton::pressed, [](){
        qDebug() << "Button pressed";
    });
    connect(button, &QPushButton::released, [](){
        qDebug() << "Button released";
    });
}

Widget::~Widget()
{

}
