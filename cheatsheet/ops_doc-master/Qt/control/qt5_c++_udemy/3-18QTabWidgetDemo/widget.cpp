#include "widget.h"
#include "ui_widget.h"
#include <QDebug>
#include <QVBoxLayout>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    // Add custom tab in existing QTabWidget
    QWidget* widget = new QWidget(this);
    QVBoxLayout* layout = new QVBoxLayout();
    layout->addWidget(new QPushButton("Button1", this));
    layout->addWidget(new QPushButton("Button2", this));
    layout->addWidget(new QPushButton("Button3", this));
    QPushButton* button4 = new QPushButton("Button4", this);
    connect(button4, &QPushButton::clicked, [](){
        qDebug() << "Button 4 from our custom tab clicked";
    });
    layout->addWidget(button4);
    layout->addSpacerItem(new QSpacerItem(100,200));

    widget->setLayout(layout);

//    ui->tabWidget->addTab(widget, "Custom tab");
    ui->tabWidget->insertTab(1, widget, "Custom tab");
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_tab1_button_clicked()
{
    qDebug() << "Tab 1 button clicked";
}
