#include "infodialog.h"
#include "ui_infodialog.h"

InfoDialog::InfoDialog(QWidget *parent) :
    QDialog(parent, Qt::WindowSystemMenuHint | Qt::WindowTitleHint),
    ui(new Ui::InfoDialog)
{
    ui->setupUi(this);
}

InfoDialog::~InfoDialog()
{
    delete ui;
}

void InfoDialog::on_cancelButton_clicked()
{
    reject();
}

void InfoDialog::on_okButton_clicked()
{
    QString userPos = ui->positionLineEdit->text();
    if(!userPos.isEmpty())
        mPosition = userPos;

    if(ui->windowsRadioButton->isChecked())
        mFavouriteOS = "Windows";
    if(ui->linuxRadioButton->isChecked())
        mFavouriteOS = "Linux";
    if(ui->macRadioButton->isChecked())
        mFavouriteOS = "Mac";

    accept();
}

void InfoDialog::setFavouriteOS(const QString &favouriteOS)
{
    mFavouriteOS = favouriteOS;
}

void InfoDialog::setPosition(const QString &position)
{
    mPosition = position;
}

QString InfoDialog::favouriteOS() const
{
    return mFavouriteOS;
}

QString InfoDialog::position() const
{
    return mPosition;
}
