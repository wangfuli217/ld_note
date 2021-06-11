#include"Calculator.h"
#include<QtGui>

Calculator::Calculator(QWidget* parent):QDialog(parent)
{
	setWindowTitle(tr("计算器"));
	m_editX=new QLineEdit;
	m_editX->setAlignment(Qt::AlignRight);
	m_editX->setValidator(new QDoubleValidator(this));
	
	m_editY=new QLineEdit;
	m_editY->setAlignment(Qt::AlignRight);
	m_editY->setValidator(new QDoubleValidator(this));

	m_btnCalc=new QPushButton("=");
	m_btnCalc->setEnabled(false);

	m_editZ=new QLineEdit;
	m_editZ->setAlignment(Qt::AlignRight);
	m_editZ->setReadOnly(true);

	QHBoxLayout* layHor=new QHBoxLayout;
	layHor->addWidget(m_editX);
	layHor->addWidget(new QLabel("+"));
	layHor->addWidget(m_editY);
	layHor->addWidget(m_btnCalc);
	layHor->addWidget(m_editZ);
	setLayout(layHor);

	connect(m_editX,SIGNAL(textChanged(QString const&)),this,SLOT(enableCalcButton(void)));
	connect(m_editY,SIGNAL(textChanged(QString const&)),this,SLOT(enableCalcButton(void)));

	connect(m_btnCalc,SIGNAL(clicked(void)),this,SLOT(calcClicked(void)));
}
void Calculator::enableCalcButton(void)
{
	bool bXOk;
	m_editX->text().toDouble(&bXOk);
	bool bYOk;
	m_editY->text().toDouble(&bYOk);
	m_btnCalc->setEnabled(bXOk&&bYOk);
	if(!m_btnCalc->isEnabled())
		m_editZ->setText("");
}
void Calculator::calcClicked(void)
{
	m_editZ->setText(QString::number(m_editX->text().toDouble()+m_editY->text().toDouble(),'g',15));
}
