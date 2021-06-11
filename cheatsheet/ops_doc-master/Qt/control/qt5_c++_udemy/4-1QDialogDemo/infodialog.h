#ifndef INFODIALOG_H
#define INFODIALOG_H

#include <QDialog>

namespace Ui {
class InfoDialog;
}

class InfoDialog : public QDialog
{
    Q_OBJECT

public:
    explicit InfoDialog(QWidget *parent = nullptr);
    ~InfoDialog();

    QString position() const;

    QString favouriteOS() const;

    void setPosition(const QString &position);

    void setFavouriteOS(const QString &favouriteOS);

private slots:
    void on_cancelButton_clicked();

    void on_okButton_clicked();

private:
    Ui::InfoDialog *ui;
    QString mPosition{};
    QString mFavouriteOS{};
};

#endif // INFODIALOG_H
