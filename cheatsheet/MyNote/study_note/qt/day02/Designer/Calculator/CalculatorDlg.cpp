#include<QtGui>
#include"CalculatorDlg.h"

CalculatorDlg::CalculatorDlg(QWidget* parent):QDialog(parent)
{
	setupUi(this);

	m_editX->setValidator(new QDoubleValidator(this));
	
	m_editY->setValidator(new QDoubleValidator(this));

	connect(m_editX,SIGNAL(textChanged(QString const&)),this,SLOT(enableCalcButton(void)));
	connect(m_editY,SIGNAL(textChanged(QString const&)),this,SLOT(enableCalcButton(void)));

	connect(m_btnCalc,SIGNAL(clicked(void)),this,SLOT(calcClicked(void)));
}
void CalculatorDlg::enableCalcButton(void)
{
	bool bXOk;
	m_editX->text().toDouble(&bXOk);
	bool bYOk;
	m_editY->text().toDouble(&bYOk);
	m_btnCalc->setEnabled(bXOk&&bYOk);
	if(!m_btnCalc->isEnabled())
		m_editZ->setText("");
}
void CalculatorDlg::calcClicked(void)
{
	m_editZ->setText(QString::number(m_editX->text().toDouble()+m_editY->text().toDouble(),'g',15));
}
