#include "widget.h"
#include <QPushButton>
#include <QTextEdit>
#include <QLabel>
#include <QDebug>

Widget::Widget(QWidget *parent)
    : QWidget(parent)
{
    QFont font("Arial", 12, QFont::Bold);
    QLabel* label = new QLabel("Dupa", this);
    label->setFont(font);
    label->move(100,25);

    QTextEdit* textEdit = new QTextEdit(this);
    textEdit->move(20,50);

    connect(textEdit, &QTextEdit::textChanged, [](){
        qDebug() << "Text changed";
    });

    // Copy, cut and paste
    QPushButton* copyButton = new QPushButton("Copy", this);
    copyButton->setMinimumSize(50,25);
    copyButton->move(10,250);

    connect(copyButton, &QPushButton::clicked, [textEdit](){
        textEdit->copy();
    });

    QPushButton* cutButton = new QPushButton("Cut", this);
    cutButton->setMinimumSize(50,25);
    cutButton->move(110,250);

    connect(cutButton, &QPushButton::clicked, [textEdit](){
        textEdit->cut();
    });

    QPushButton* pasteButton = new QPushButton("Paste", this);
    pasteButton->setMinimumSize(50,25);
    pasteButton->move(210,250);

    connect(pasteButton, &QPushButton::clicked, [textEdit](){
        textEdit->paste();
    });

    // Undo, redo
    QPushButton* undoButton = new QPushButton("Undo", this);
    undoButton->setMinimumSize(50,25);
    undoButton->move(10,300);

    connect(undoButton, &QPushButton::clicked, [textEdit](){
        textEdit->undo();
    });

    QPushButton* redoButton = new QPushButton("Redo", this);
    redoButton->setMinimumSize(50,25);
    redoButton->move(110,300);

    connect(redoButton, &QPushButton::clicked, [textEdit](){
        textEdit->redo();
    });

    // Set plain text and html to the text edit
    QPushButton* plainTextButton = new QPushButton("Plain text", this);
    plainTextButton->setMinimumSize(50,25);
    plainTextButton->move(10,350);

    connect(plainTextButton, &QPushButton::clicked, [textEdit](){
        textEdit->setPlainText("text text text");
    });

    QPushButton* htmlButton = new QPushButton("HTML", this);
    htmlButton->setMinimumSize(50,25);
    htmlButton->move(110,350);

    connect(htmlButton, &QPushButton::clicked, [textEdit](){
        textEdit->setHtml("<h1>text</h1>");
    });

    // grab plain text and html to the text edit
    QPushButton* grabPlainTextButton = new QPushButton("Grab plain text", this);
    grabPlainTextButton->setMinimumSize(50,25);
    grabPlainTextButton->move(10,400);

    connect(grabPlainTextButton, &QPushButton::clicked, [textEdit](){
        qDebug() << textEdit->toPlainText();
    });

    QPushButton* grabHtmlButton = new QPushButton("Grab HTML", this);
    grabHtmlButton->setMinimumSize(50,25);
    grabHtmlButton->move(110,400);

    connect(grabHtmlButton, &QPushButton::clicked, [textEdit](){
        qDebug() << textEdit->toHtml();
    });

    setFixedSize(300, 450);
}

Widget::~Widget()
{
}
