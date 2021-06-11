#ifndef ADDER_H
#define ADDER_H

#include <QDialog>

namespace Ui {
class Adder;
}

class Adder : public QDialog
{
    Q_OBJECT
    
public:
    explicit Adder(QWidget *parent = 0);
    ~Adder();
    
private:
    Ui::Adder *ui;
/* 实现计算的槽函数 */
public slots:
    void  getRes();
};

#endif // ADDER_H





