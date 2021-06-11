#include "mainwindow.h"
#include <QPushButton>
#include <QDebug>
#include <QMenuBar>
#include <QStatusBar>
#include <QAction>
#include <QApplication>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    // Add central widget
    QPushButton* button1 = new QPushButton("Click1", this);
    button1->move(50,50);
    QPushButton* button2 = new QPushButton("Click2", this);
    button2->move(150,50);
    //setCentralWidget(button);

    // Declare quit action
    QAction* quitAction = new QAction("Quit");
    connect(quitAction, &QAction::triggered, [=](){
        QApplication::quit();
    });

    // Add menus
    menuBar()->addMenu("File")->addAction(quitAction);
    menuBar()->addMenu("Edit");
    menuBar()->addMenu("Help");
    menuBar()->addMenu("About");

    // Add status bar mesage
    statusBar()->showMessage("Uploading file...");
    connect(button1, &QPushButton::clicked, [this](){
        statusBar()->showMessage("Clicking button1", 100);
    });
    connect(button2, &QPushButton::clicked, [this](){
        statusBar()->showMessage("Clicking button2", 100);
    });
}

MainWindow::~MainWindow()
{

}

QSize MainWindow::sizeHint() const
{
    return QSize(300, 300);
}
