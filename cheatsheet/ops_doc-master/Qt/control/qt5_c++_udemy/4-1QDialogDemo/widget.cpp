#include "widget.h"
#include "ui_widget.h"
#include "infodialog.h"
#include <QDebug>

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

void Widget::on_provideInfoButton_clicked()
{
    InfoDialog* dialog = new InfoDialog(this);

    // Show the dialog model- blocking the input in parent windget
//    int ret{dialog->exec()};

//    if(ret == QDialog::Accepted) {
//        QString position = dialog->position();
//        QString os = dialog->favouriteOS();
//        qDebug() << "Dialog accepted";
//        qDebug() << "Position: " << position << "OS: " << os;
//        ui->positionLabel->setText(position);
//        ui->favouriteOSLabel->setText(os);

//    }
//    else if(ret == QDialog::Rejected) {
//        qDebug() << "Dialog rejected";
//    }

    // Show the dialog non model- non blocking
    connect(dialog, &InfoDialog::accepted, [this, dialog](){
        QString position = dialog->position();
        QString os = dialog->favouriteOS();
        qDebug() << "Dialog accepted";
        qDebug() << "Position: " << position << "OS: " << os;
        ui->positionLabel->setText(position);
        ui->favouriteOSLabel->setText(os);
    });

    connect(dialog, &InfoDialog::rejected, [](){
        qDebug() << "Dialog rejected";
    });

    dialog->show();
    dialog->raise();
    dialog->activateWindow();


}
