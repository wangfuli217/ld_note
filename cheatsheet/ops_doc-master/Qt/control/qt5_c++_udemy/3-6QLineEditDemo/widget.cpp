#include "widget.h"
#include <QPushButton>
#include <QLabel>
#include <QLineEdit>
#include <QDebug>

Widget::Widget(QWidget *parent)
    : QWidget(parent)
{
    // First name
    QLabel* firstNameLabel = new QLabel("First name", this);
    firstNameLabel->setMinimumSize(70,30);
    firstNameLabel->move(10,10);

    QLineEdit* firstNameLineEdit = new QLineEdit(this);
    firstNameLineEdit->setMinimumSize(200,30);
    firstNameLineEdit->move(100, 10);
    firstNameLineEdit->setPlaceholderText("Put here your first name");

    // Last name
    QLabel* lastNameLabel = new QLabel("Last name", this);
    lastNameLabel->setMinimumSize(70,30);
    lastNameLabel->move(10,50);

    QLineEdit* lastNameLineEdit = new QLineEdit(this);
    lastNameLineEdit->setMinimumSize(200,30);
    lastNameLineEdit->move(100, 50);
    lastNameLineEdit->setPlaceholderText("Put here your last name");

    // City
    QLabel* cityLabel = new QLabel("City", this);
    cityLabel->setMinimumSize(70,30);
    cityLabel->move(10,90);

    QLineEdit* cityLineEdit = new QLineEdit(this);
    cityLineEdit->setMinimumSize(200,30);
    cityLineEdit->move(100, 90);
    cityLineEdit->setPlaceholderText("Put you city here");

    // Submit button
    QFont buttonFont("Arial", 20);
    QPushButton* button = new QPushButton("Submit", this);
    button->setFont(buttonFont);
    button->move(100, 130);

    connect(button, &QPushButton::clicked, [=](){
        QString firstName = firstNameLineEdit->text();
        QString lastName = lastNameLineEdit->text();
        QString city = cityLineEdit->text();

        if(!firstName.isEmpty() && !lastName.isEmpty() && !city.isEmpty())
            qDebug() << firstName << " " << lastName << " " << city;
        else
            qDebug() << "Some of the fields are empty. Please fill them.";
    });

    // Respond to signals from QLineEdit
    connect(firstNameLineEdit, &QLineEdit::cursorPositionChanged, [](int pos){
        qDebug() << "The current cursor' position is: " << pos;
    });

    connect(firstNameLineEdit, &QLineEdit::editingFinished, [](){
        qDebug() << "Editing finished";
    });

    connect(firstNameLineEdit, &QLineEdit::returnPressed, [](){
        qDebug() << "Return pressed";
    });

    connect(firstNameLineEdit, &QLineEdit::selectionChanged, [](){
        qDebug() << "Selection changed";
    });

    connect(firstNameLineEdit, &QLineEdit::textChanged, [](const QString& text){
        qDebug() << "Text changed: " << text;
    });

    connect(firstNameLineEdit, &QLineEdit::textEdited, [](const QString& text){
        qDebug() << "Text edited: " << text;
    });
}

Widget::~Widget()
{

}
