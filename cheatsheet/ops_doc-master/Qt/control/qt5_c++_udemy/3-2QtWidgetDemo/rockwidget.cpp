#include "rockwidget.h"
#include <QLabel>
#include <QPushButton>
#include <QMessageBox>

RockWidget::RockWidget(QWidget *parent) : QWidget(parent)
{
    setWindowTitle("Rock widget");

    // Add simple label
    QLabel* label = new QLabel("This is my label", this);

    // Add styled label
    QLabel* styledLabel = new QLabel(this);
    styledLabel->setText("Styled label");
    styledLabel->move(50, 50);

    QFont styledLabelFont("Times", 12, QFont::Bold);
    styledLabel->setFont(styledLabelFont);

    QPalette styledLabelPalette;
    styledLabelPalette.setColor(QPalette::Window, Qt::yellow);
    styledLabelPalette.setColor(QPalette::WindowText, Qt::blue);
    styledLabel->setAutoFillBackground(true);
    styledLabel->setPalette(styledLabelPalette);

    // Add push button and connect to slot
    QFont buttonFont("Arial", 15, QFont::Bold);
    QPushButton* button = new QPushButton(this);
    button->setText("click me");
    button->move(100,100);
    button->setFont(buttonFont);

    connect(button, &QPushButton::clicked, this, &RockWidget::buttonClicked);
//    connect(button, &QPushButton::clicked, [styledLabel](){
//        styledLabel->setText("dupa");
//    });

}

void RockWidget::buttonClicked()
{
    QMessageBox::information(this, "message", "congrats, you clicked");
}

QSize RockWidget::sizeHint() const
{
    return QSize(500, 500);
}
