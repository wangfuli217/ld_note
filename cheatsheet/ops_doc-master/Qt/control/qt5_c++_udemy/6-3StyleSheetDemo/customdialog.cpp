#include "customdialog.h"
#include "ui_customdialog.h"

CustomDialog::CustomDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::CustomDialog)
{
    ui->setupUi(this);

    // Set style sheet on a specific widget
    ui->OkButton->setStyleSheet("QPushButton{color : green}");
}

CustomDialog::~CustomDialog()
{
    delete ui;
}
