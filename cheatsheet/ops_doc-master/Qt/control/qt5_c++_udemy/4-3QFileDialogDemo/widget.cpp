#include "widget.h"
#include "ui_widget.h"
#include <QFileDialog>
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

void Widget::on_clickMeButton_clicked()
{
    // Directory
//    QString dir = QFileDialog::getExistingDirectory(this, tr("Open directory"), "/home",
//                                                    QFileDialog::ShowDirsOnly |
//                                                    QFileDialog::DontResolveSymlinks);
//    qDebug() << "Your choosen dir is: " << dir;

    // One file
//    QString fileName = QFileDialog::getOpenFileName(this, tr("Open file"), "/home",
//                                                    tr("Images (*.png *.xpm *.jpg)"));

//    qDebug() << "Your choosen file is: " << fileName;

    // Multiple files
    QStringList files = QFileDialog::getOpenFileNames(this, "Select one or more files to open",
                                                      "/home", "Images (*.png *.jpg);;Text files(*.txt)");

    for(auto file : files)
        qDebug() << file;
}
