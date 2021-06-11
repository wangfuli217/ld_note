#include<QDialog>
#include<QApplication>
#include<QSlider>
#include<QSpinBox>

int main(int argc,char *argv[])
{
	QApplication app(argc,argv);
	QDialog dlg;
	QSlider* slider=new QSlider(Qt::Horizontal,&dlg);
	slider->move(20,20);
	slider->resize(100,20);
	slider->setRange(0,100);
	slider->setPageStep(10);
	slider->setValue(20);
	QSpinBox* spin=new QSpinBox(&dlg);
	spin->move(slider->x()+slider->width()+10,slider->y());
	spin->resize(60,slider->height());
	spin->setRange(slider->minimum(),slider->maximum());
	spin->setValue(slider->value());
	QObject::connect(slider,SIGNAL(valueChanged(int)),spin,SLOT(setValue(int)));
	QObject::connect(spin,SIGNAL(valueChanged(int)),slider,SLOT(setValue(int)));
	dlg.show();
	return app.exec();
}

