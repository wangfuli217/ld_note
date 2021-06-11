#include "widget.h"
#include "ui_widget.h"
#include <QColorDialog>
#include <QDebug>
#include <QSettings>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    mButtons.append(ui->pushButton_1);
    mButtons.append(ui->pushButton_2);
    mButtons.append(ui->pushButton_3);
    mButtons.append(ui->pushButton_4);
    mButtons.append(ui->pushButton_5);
    mButtons.append(ui->pushButton_6);
    mButtons.append(ui->pushButton_7);
    mButtons.append(ui->pushButton_8);
    mButtons.append(ui->pushButton_9);

    const int numberOfColors{mButtons.size()};
    for(int i{0}; i < numberOfColors; ++i)
        mColorList.append(Qt::black);
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_pushButton_1_clicked()
{
    changeColor(0);
}

void Widget::on_pushButton_2_clicked()
{
    changeColor(1);
}

void Widget::on_pushButton_3_clicked()
{
    changeColor(2);
}

void Widget::on_pushButton_4_clicked()
{
    changeColor(3);
}

void Widget::on_pushButton_5_clicked()
{
    changeColor(4);
}

void Widget::on_pushButton_6_clicked()
{
    changeColor(5);
}

void Widget::on_pushButton_7_clicked()
{
    changeColor(6);
}

void Widget::on_pushButton_8_clicked()
{
    changeColor(7);
}

void Widget::on_pushButton_9_clicked()
{
    changeColor(8);
}

void Widget::on_saveButton_clicked()
{
    for(int i{0}; i < mButtons.size(); ++i)
        saveColor(mButtons[i]->objectName(), mColorList[i]);
}

void Widget::on_loadButton_clicked()
{
    for(int i{0}; i < mButtons.size(); ++i)
        setLoadedColor(i);
}

void Widget::changeColor(int index)
{
    if(index < 0 || index > 9)
        qDebug() << "Index out of bounds: " << index;
    if(mButtons[index] == nullptr)
        qDebug() << "button == nullptr";

    QColor color = QColorDialog::getColor(mColorList[index], this, "Choose background color");
    if(color.isValid()) {
        mColorList[index] = color;
        QString css = QString("background-color : %1").arg(color.name());
        mButtons[index]->setStyleSheet(css);
    }
}

void Widget::saveColor(const QString &key, const QColor &color)
{
    qDebug() << "save color:" << key << color.name();
    int red{color.red()};
    int green{color.green()};
    int blue{color.blue()};

    QSettings settings("Organization", "SettingsDemo");

    settings.beginGroup("ButtonColor");
    settings.setValue(key + "r", red);
    settings.setValue(key + "g", green);
    settings.setValue(key + "b", blue);
    settings.endGroup();
}

QColor Widget::loadColor(const QString &key)
{
    int red{}, green{}, blue{};
    QSettings settings("Organization", "SettingsDemo");
    settings.beginGroup("ButtonColor");
    red = settings.value(key + "r", QVariant(0)).toInt();
    green = settings.value(key + "g", QVariant(0)).toInt();
    blue = settings.value(key + "b", QVariant(0)).toInt();
    settings.endGroup();

    return QColor(red, green, blue);
}

void Widget::setLoadedColor(int index)
{
    QColor color = loadColor(mButtons[index]->objectName());
    mColorList[index] = color;
    QString css = QString("background-color : %1").arg(color.name());
    mButtons[index]->setStyleSheet(css);
}
