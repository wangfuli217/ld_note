#include "time.h"
TimeDlg::TimeDlg(QWidget* parent):QDialog(parent)
{
	setWindowTitle(tr("时间"));
	m_labTime=new QLabel;
	m_labTime->setFrameStyle(QFrame::Panel|QFrame::Sunken);
	m_labTime->setAlignment(Qt::AlignHCenter|Qt::AlignVCenter);
	timeClicked();
	QPushButton* btnTime=new QPushButton(tr("当前时间"));
	connect(btnTime,SIGNAL(clicked(void)),this,SLOT(timeClicked(void)));
	QVBoxLayout* layVer=new QVBoxLayout;
	layVer->addWidget(m_labTime);
	layVer->addWidget(btnTime);
	setLayout(layVer);
}
//中间槽函数(不带参数)
void TimeDlg::timeClicked(void)
{
	//调用需要参数的目标槽函数
	m_labTime->setText(QTime::currentTime().toString("h:mm:ss"));
}
