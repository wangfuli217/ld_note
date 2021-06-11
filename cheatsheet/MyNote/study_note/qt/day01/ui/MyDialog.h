/********************************************************************************
** Form generated from reading UI file 'MyDialog.ui'
**
** Created: Fri Jul 31 13:00:54 2015
**      by: Qt User Interface Compiler version 4.8.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef MYDIALOG_H
#define MYDIALOG_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QDialog>
#include <QtGui/QHeaderView>
#include <QtGui/QPushButton>

QT_BEGIN_NAMESPACE

class Ui_Mywnd
{
public:
    QPushButton *pushButton;

    void setupUi(QDialog *Mywnd)
    {
        if (Mywnd->objectName().isEmpty())
            Mywnd->setObjectName(QString::fromUtf8("Mywnd"));
        Mywnd->resize(350, 245);
        pushButton = new QPushButton(Mywnd);
        pushButton->setObjectName(QString::fromUtf8("pushButton"));
        pushButton->setGeometry(QRect(190, 170, 98, 27));

        retranslateUi(Mywnd);

        QMetaObject::connectSlotsByName(Mywnd);
    } // setupUi

    void retranslateUi(QDialog *Mywnd)
    {
        Mywnd->setWindowTitle(QApplication::translate("Mywnd", "Mydialog", 0, QApplication::UnicodeUTF8));
        pushButton->setText(QApplication::translate("Mywnd", "OK", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class Mywnd: public Ui_Mywnd {};
} // namespace Ui

QT_END_NAMESPACE

#endif // MYDIALOG_H
