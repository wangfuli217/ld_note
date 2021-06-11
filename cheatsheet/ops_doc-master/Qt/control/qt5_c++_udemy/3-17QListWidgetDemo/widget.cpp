#include "widget.h"
#include "ui_widget.h"
#include <QDebug>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
    ui->listWidget->setSelectionMode(QAbstractItemView::MultiSelection);
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_addItemButon_clicked()
{
    ui->listWidget->addItem("My item");
}

void Widget::on_deleteItemButton_clicked()
{
    ui->listWidget->takeItem(ui->listWidget->currentRow());
}

void Widget::on_selectedItemsButton_clicked()
{
    auto selectedItems{ui->listWidget->selectedItems()};
    for(auto item : selectedItems)
        qDebug() << "Selected item: " << item->text()
                 << "row: " << ui->listWidget->row(item);
}
