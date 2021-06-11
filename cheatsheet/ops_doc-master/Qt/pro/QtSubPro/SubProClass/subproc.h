#ifndef SUBPROC_H
#define SUBPROC_H

#include <QWidget>

namespace Ui {
class SubProC;
}

#if defined(LIBWIDGET_BUILD)
#  define WIDGET_API Q_DECL_EXPORT
#else
#  define WIDGET_API Q_DECL_IMPORT
#endif

class SubProC : public QWidget
{
    Q_OBJECT

public:
    explicit SubProC(QWidget *parent = 0);
    ~SubProC();

private:
    Ui::SubProC *ui;
};

#endif // SUBPROC_H
