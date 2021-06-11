#include "widget.h"
#include "ui_widget.h"
#include <QDebug>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
    constexpr int rowCount{3};
    constexpr int columnCount{5};

    //Tree model
    mTreeModel = new QStandardItemModel(this);
    QModelIndex parentIndex = QModelIndex();

    for(int i{0}; i < columnCount; ++i) {
        qDebug() << "Current iteration: " << QString::number(i);
        mTreeModel->insertRow(0, parentIndex);
        mTreeModel->insertColumn(0, parentIndex);

        parentIndex = mTreeModel->index(0, 0, parentIndex);

        QString data = QString("item %0").arg(i);
        mTreeModel->setData(parentIndex, QVariant::fromValue(data));
    }

    ui->treeView->setModel(mTreeModel);

    //Table model
    mTableModel = new QStandardItemModel(this);

    mTableModel->setRowCount(rowCount);
    mTableModel->setColumnCount(columnCount);

    for(int i{0}; i < rowCount; ++i) {
        for(int j{0}; j < columnCount; ++j) {
            QString data = QString("row %0, column %1").arg(i).arg(j);
            QModelIndex index = mTableModel->index(i, j, QModelIndex());
            mTableModel->setData(index, QVariant::fromValue(data));
        }
    }

    ui->tableView->setModel(mTableModel);
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_tableView_clicked(const QModelIndex &index)
{
    QString data = mTableModel->data(index, Qt::DisplayRole).toString();
    qDebug() << data;
}
