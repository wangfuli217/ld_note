#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
    //1. String notation
    //connect(ui->horizontalSlider, SIGNAL(valueChanged(int)), ui->progressBar, SLOT(setValue(int)));

    //2. Functor notation: regular slots
    //connect(ui->horizontalSlider, &QSlider::valueChanged, ui->progressBar, &QProgressBar::setValue);

    //3. Funcotr notation: lambdas
    connect(ui->horizontalSlider, &QSlider::valueChanged, [&](int value){
       ui->progressBar->setValue(value);
    });
}

Widget::~Widget()
{
    delete ui;
}
