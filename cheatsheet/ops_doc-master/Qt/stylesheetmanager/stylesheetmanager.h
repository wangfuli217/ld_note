#ifndef STYLESHEETMANAGER_H
#define STYLESHEETMANAGER_H
#include <QObject>
class StyleSheetManager : public QObject
{
    Q_OBJECT
public:
    StyleSheetManager(QObject *parent = 0);
    StyleSheetManager(const QString& filePath, QObject *parent = 0);
    //1 加载指定的样式表字符串
    bool load(const QString& styleStr);
    //1.1加载指定qss文件
    bool loadFile(const QString& path);
    //2 重新加载指定的样式表文件
    
    bool StyleSheetManager::loadDir(const QString &path);
    
    bool reload();
    //3 切换指定的样式（换肤）
    bool switchTo(const QString& path);
    //4 qss文件路径存取器
    QString filePath() const;
    void setFilePath(const QString &path);
signals:
    void styleSheetLoaded();
private:
    //1 读取指定文件内容
    QString readFile(const QString& path) const;
    //2 是否为同一文件
    bool isSameFile(const QString &path) const;
private:
    QString m_filePath;//qss文件路径
};
#endif // STYLESHEETMANAGER_H