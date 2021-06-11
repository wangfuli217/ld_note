#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QApplication>
#include <QDebug>
#include <QMessageBox>
#include <QTimer>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_actionQuit_triggered()
{
    statusBar()->showMessage("App will be shut down in 3 seconds...");
    QTimer::singleShot(3000, this, SLOT(quitApp()));
}

void MainWindow::on_actionCopy_triggered()
{
    qDebug() << "Copy option triggered";
    ui->textEdit->copy();
}

void MainWindow::on_actionCut_triggered()
{
    qDebug() << "Cut option triggered";
    ui->textEdit->cut();
}

void MainWindow::on_actionPaste_triggered()
{
    qDebug() << "Paste option triggered";
    ui->textEdit->paste();
}

void MainWindow::on_actionUndo_triggered()
{
    qDebug() << "Undo option triggered";
    ui->textEdit->undo();
}

void MainWindow::on_actionRedo_triggered()
{
    qDebug() << "Redo option triggered";
    ui->textEdit->redo();
}

void MainWindow::on_actionAbout_triggered()
{
    QMessageBox::about(this, "About", "This is demo application.");
}

void MainWindow::on_actionAbout_Qt_triggered()
{
    QApplication::aboutQt();
}

void MainWindow::quitApp()
{
    qDebug() << "Quit option triggered";
    QApplication::quit();
}
