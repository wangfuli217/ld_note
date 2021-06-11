#include "widget.h"
#include "ui_widget.h"
#include <QDebug>
#include <QMessageBox>
#include <cstdlib>
#include <ctime>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
    ui->restartButton->setDisabled(true);
    ui->messageLabel->setText("Choose your number");
    generateSecretNumber();
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_checkButton_clicked()
{
    ui->restartButton->setDisabled(false);
    guessNumber = ui->spinBox->value();
    qDebug() << "Guss number: " << guessNumber;

    if(guessNumber == secretNumber) {
        ui->messageLabel->setText("Congrats! You won!");
        ui->checkButton->setDisabled(true);
    } else {
        if(guessNumber < secretNumber)
            ui->messageLabel->setText("To small!");
        else
            ui->messageLabel->setText("Too big!");
    }
}

void Widget::on_restartButton_clicked()
{
    ui->checkButton->setDisabled(false);
    ui->spinBox->setValue(1);
    ui->messageLabel->setText("Choose your number");
    generateSecretNumber();
}

void Widget::generateSecretNumber() {
    srand(time(NULL));
    secretNumber = rand() % 100 + 1;
    qDebug() << "Number was generated: " << secretNumber;
}
