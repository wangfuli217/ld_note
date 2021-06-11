#ifndef _CALCULATORDLG_H
#define _CALCULATORDLG_H
#include<QDialog>
#include "ui_CalculatorDlg.h"
class CalculatorDlg:public QDialog,public Ui::CalculatorDlg
{
	Q_OBJECT
public:
	CalculatorDlg(QWidget* parent=NULL);
private slots:
	void enableCalcButton(void);
	void calcClicked(void);
};
#endif
