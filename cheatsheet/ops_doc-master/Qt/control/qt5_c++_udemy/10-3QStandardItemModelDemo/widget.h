#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include <QStandardItemModel>

namespace Ui {
class Widget;
}

class Widget : public QWidget
{
    Q_OBJECT

public:
    explicit Widget(QWidget *parent = nullptr);
    ~Widget();

private slots:
    void on_tableView_clicked(const QModelIndex &index);

private:
    Ui::Widget *ui;
    QStandardItemModel* mTreeModel;
    QStandardItemModel* mTableModel;
};

#endif // WIDGET_H
