#include "customtablemodel.h"
#include <QFont>
#include <QBrush>
#include <QTime>

CustomTableModel::CustomTableModel(QObject* parent) : QAbstractTableModel(parent)
{
    mTimer = new QTimer(this);
    mTimer->setInterval(1000);
    connect(mTimer, &QTimer::timeout, [this](){
        QModelIndex bottomLeft = index(1, 0);
        //Notify the view of the change of the time in the model
        emit dataChanged(bottomLeft, bottomLeft);
    });
    mTimer->start();
}

int CustomTableModel::rowCount(const QModelIndex &parent) const
{
    return kRowCount;
}

int CustomTableModel::columnCount(const QModelIndex &parent) const
{
    return kColumnCount;
}

QVariant CustomTableModel::data(const QModelIndex &index, int role) const
{
    int row{index.row()};
    int col{index.column()};

    switch(role){
    case Qt::DisplayRole:
        if(row == 0 && col == 0) return QString("<--left");
        if(row == 0 && col == 1) return QString("right->");
        if(row == 1 && col == 0) return QTime::currentTime().toString();
        return QString("Row %0, Col %1")
                .arg(index.row() + 1)
                .arg(index.column() + 1);
    case Qt::FontRole:
        if(row == 0 && col == 0) {
            QFont font;
            font.setBold(true);
            return font;
        }
        break;
    case Qt::BackgroundRole:
        if(row == 1 && col == 2)
            return QBrush(Qt::green);
        break;
    case Qt::TextAlignmentRole:
        if(row == 1 && col == 1)
            return Qt::AlignRight;
        break;
    }
    return QVariant();
}

QVariant CustomTableModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if(role == Qt::DisplayRole) {
        if(orientation == Qt::Horizontal) {
            switch(section){
            case 0:
                return QString("First");
            case 1:
                return QString("Second");
            case 2:
                return QString("Third");
            default:
                return QString("Default");
            }
        }
    }
    return QVariant();
}
