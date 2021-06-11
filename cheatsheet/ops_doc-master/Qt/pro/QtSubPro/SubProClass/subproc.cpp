#include "subproc.h"
#include "ui_subproc.h"

SubProC::SubProC(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::SubProC)
{
    ui->setupUi(this);
}

SubProC::~SubProC()
{
    delete ui;
}
