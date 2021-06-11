/********************************************************************************
** Form generated from reading UI file 'CalculatorDlg.ui'
**
** Created: Mon Aug 3 14:30:10 2015
**      by: Qt User Interface Compiler version 4.8.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_CALCULATORDLG_H
#define UI_CALCULATORDLG_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QDialog>
#include <QtGui/QHBoxLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QLineEdit>
#include <QtGui/QPushButton>

QT_BEGIN_NAMESPACE

class Ui_CalculatorDlg
{
public:
    QHBoxLayout *horizontalLayout;
    QLineEdit *m_editX;
    QLabel *label;
    QLineEdit *m_editY;
    QPushButton *m_btnCalc;
    QLineEdit *m_editZ;

    void setupUi(QDialog *CalculatorDlg)
    {
        if (CalculatorDlg->objectName().isEmpty())
            CalculatorDlg->setObjectName(QString::fromUtf8("CalculatorDlg"));
        CalculatorDlg->resize(428, 45);
        horizontalLayout = new QHBoxLayout(CalculatorDlg);
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        m_editX = new QLineEdit(CalculatorDlg);
        m_editX->setObjectName(QString::fromUtf8("m_editX"));
        m_editX->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        horizontalLayout->addWidget(m_editX);

        label = new QLabel(CalculatorDlg);
        label->setObjectName(QString::fromUtf8("label"));
        label->setAlignment(Qt::AlignCenter);

        horizontalLayout->addWidget(label);

        m_editY = new QLineEdit(CalculatorDlg);
        m_editY->setObjectName(QString::fromUtf8("m_editY"));
        m_editY->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        horizontalLayout->addWidget(m_editY);

        m_btnCalc = new QPushButton(CalculatorDlg);
        m_btnCalc->setObjectName(QString::fromUtf8("m_btnCalc"));
        m_btnCalc->setEnabled(false);

        horizontalLayout->addWidget(m_btnCalc);

        m_editZ = new QLineEdit(CalculatorDlg);
        m_editZ->setObjectName(QString::fromUtf8("m_editZ"));
        m_editZ->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        m_editZ->setReadOnly(true);

        horizontalLayout->addWidget(m_editZ);

        QWidget::setTabOrder(m_editX, m_editY);
        QWidget::setTabOrder(m_editY, m_btnCalc);
        QWidget::setTabOrder(m_btnCalc, m_editZ);

        retranslateUi(CalculatorDlg);

        QMetaObject::connectSlotsByName(CalculatorDlg);
    } // setupUi

    void retranslateUi(QDialog *CalculatorDlg)
    {
        CalculatorDlg->setWindowTitle(QApplication::translate("CalculatorDlg", "\350\256\241\347\256\227\345\231\250", 0, QApplication::UnicodeUTF8));
        label->setText(QApplication::translate("CalculatorDlg", "+", 0, QApplication::UnicodeUTF8));
        m_btnCalc->setText(QApplication::translate("CalculatorDlg", "=", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class CalculatorDlg: public Ui_CalculatorDlg {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_CALCULATORDLG_H
