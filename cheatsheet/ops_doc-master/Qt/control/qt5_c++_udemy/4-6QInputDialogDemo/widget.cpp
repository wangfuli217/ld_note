#include "widget.h"
#include "ui_widget.h"
#include <QDebug>
#include <QInputDialog>

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

void Widget::on_chooseButton_clicked()
{
    // Get double
//    bool success{};
//    double input = QInputDialog::getDouble(this, "QInputDialog::getDouble()",
//                                           "Amount", 0, -1000, 1000, 4, &success);

//    if(success){
//        qDebug() << QString::number(input);
//    }

    // Get item
    QStringList items{};
    items << "Mercury" << "Venus" << "Earth" << "Mars" << "Jupiter" << "Staturn" << "Uranus" << "Neptune";

    bool success{};
    QString item = QInputDialog::getItem(this, "QInputDialog::getItem()",
                                         "Planet", items, 0, false, &success);

    if(success && !item.isEmpty()) {
        qDebug() << "Choosen item: " << item;
    }
}
