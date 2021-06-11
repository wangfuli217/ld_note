#include <QDebug>
#include <QDir>
#include <QFile>
#include <QApplication>
#include "stylesheetmanager.h"
StyleSheetManager::StyleSheetManager(QObject *parent) :
    QObject(parent)
{
}
StyleSheetManager::StyleSheetManager(
    const QString &filePath, QObject *parent
) : QObject(parent)
{
    setFilePath(filePath);
}

bool StyleSheetManager::load(const QString &styleStr)
{
    if (!styleStr.isEmpty() && qApp)
    {
        qApp->setStyleSheet(styleStr);
        setFilePath(styleStr);
        return true;
    }
    return false;
}

bool StyleSheetManager::loadFile(const QString &path)
{
    QString styleStr = readFile(path);
    return load(styleStr);
}

//1.2加载指定文件夹下的所有qss文件
bool StyleSheetManager::loadDir(const QString &path)
{
    QString styleStr;
    QDir dir(path);
    QFileInfoList fileList = dir.entryInfoList(QDir::Files);
    foreach (const QFileInfo& file, fileList)
    {
        styleStr += readFile(file.absoluteFilePath());
    }
    return load(styleStr);
}

bool StyleSheetManager::reload()
{
    return loadFile(filePath());
}

bool StyleSheetManager::switchTo(const QString &path)
{
    if (isSameFile(path))
    {
        return false;
    }
    return loadFile(path);
}

QString StyleSheetManager::readFile(const QString &path) const
{
    QString ret;
    QFile file(path);
    if (file.open(QIODevice::ReadOnly))
    {
        ret = file.readAll();
        file.close();
    }
    return ret;
}

bool StyleSheetManager::isSameFile(const QString &path) const
{
    return filePath() == path;
}

QString StyleSheetManager::filePath() const
{
    return m_filePath;
}

void StyleSheetManager::setFilePath(const QString &path)
{
    m_filePath = path;
}