#ifndef _TIME_H
#define _TIME_H
#include<QDialog>
class QLabel;
class TimeDlg:public QDialog
{
	Q_OBJECT
public:
	TimeDlg(QWidget* parent=NULL);
private slots:
	void timeClicked(void);
signals:
	void setText(QString const&);
private:
	QLabel* m_labTime;
};
#endif
