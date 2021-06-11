#include "widget.h"
#include "ui_widget.h"
#include <QDebug>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
    mModel = new QStandardItemModel(this);

    // Capture the root item
    QStandardItem* rootItem = mModel->invisibleRootItem();

    // Define a couple of items
    QStandardItem* europeItem = new QStandardItem("Europe");
    QStandardItem* polandItem = new QStandardItem("Poland");
    QStandardItem* wroclawItem = new QStandardItem("Wroclaw");
    QStandardItem* asiaItem = new QStandardItem("Asia");
    QStandardItem* chinaItem = new QStandardItem("China");
    QStandardItem* shanghaiItem = new QStandardItem("Shanghai");

    // Define the tree structure
    rootItem->appendRow(europeItem);
    europeItem->appendRow(polandItem);
    polandItem->appendRow(wroclawItem);
    rootItem->appendRow(asiaItem);
    asiaItem->appendRow(chinaItem);
    chinaItem->appendRow(shanghaiItem);

    ui->treeView->setModel(mModel);
    ui->treeView->expandAll();

    QItemSelectionModel* selectionModel = ui->treeView->selectionModel();
    connect(selectionModel, SIGNAL(selectionChanged(QItemSelection,QItemSelection)), this,
                            SLOT(selectionChangedSlot(QItemSelection,QItemSelection)));
}

Widget::~Widget()
{
    delete ui;
}

void Widget::selectionChangedSlot(const QItemSelection &oldSelection, const QItemSelection &newSelection)
{
    qDebug() << "clicked on something in the tree";
    QModelIndex currentIndex = ui->treeView->selectionModel()->currentIndex();
    QString data = mModel->data(currentIndex, Qt::DisplayRole).toString();

    int hierarchy{0};
    QModelIndex seekRoot = currentIndex;

    while(seekRoot != QModelIndex()) {
        seekRoot = seekRoot.parent();
        ++hierarchy;
    }
    qDebug() << data << hierarchy;
}
