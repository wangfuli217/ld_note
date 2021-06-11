#include "widget.h"
#include "ui_widget.h"
#include <QDebug>
#include <cstdlib>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
    //1. String notation
    //connect(ui->pushButton, SIGNAL(clicked()), this, SLOT(changeText()));

    //2. Functor notation: regular slots
    //connect(ui->pushButton, &QPushButton::clicked, this, &Widget::changeText);

    //3. Functor notation: lambdas
    connect(ui->pushButton, &QPushButton::clicked, [&](){
        qDebug() << "clicked";
        this->changeText();
    });
}

Widget::~Widget()
{
    delete ui;
}

void Widget::changeText()
{
    srand(time(NULL));
    int random = rand() % 100;
    ui->label->setText(QString::number(random));
}
