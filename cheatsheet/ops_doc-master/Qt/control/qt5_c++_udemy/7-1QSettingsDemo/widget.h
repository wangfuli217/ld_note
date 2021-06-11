#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include <QList>
#include <QColor>
#include <QPushButton>

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
    void on_pushButton_1_clicked();

    void on_pushButton_2_clicked();

    void on_pushButton_3_clicked();

    void on_pushButton_4_clicked();

    void on_pushButton_5_clicked();

    void on_pushButton_6_clicked();

    void on_pushButton_7_clicked();

    void on_pushButton_8_clicked();

    void on_pushButton_9_clicked();

    void on_saveButton_clicked();

    void on_loadButton_clicked();

private:
    void changeColor(int index);
    void saveColor(const QString& key, const QColor& color);
    QColor loadColor(const QString& key);
    void setLoadedColor(int index);


private:
    Ui::Widget *ui;
    QList<QColor> mColorList;
    QList<QPushButton*> mButtons;
};
#endif // WIDGET_H
