#ifndef _CALCULATOR_H
#define _CALCULATOR_H
#include<QDialog>
class QLineEdit;
class QPushButton;
class Calculator:public QDialog
{
	Q_OBJECT
public:
	Calculator(QWidget* parent=NULL);
private slots:
	void enableCalcButton(void);
	void calcClicked(void);
private:
	QLineEdit*		m_editX;
	QLineEdit*		m_editY;
	QPushButton*	m_btnCalc;
	QLineEdit*		m_editZ;
};
#endif
