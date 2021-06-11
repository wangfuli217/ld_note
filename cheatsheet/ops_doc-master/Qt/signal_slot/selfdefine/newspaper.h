#include <QObject>
 ////////// newspaper.h //////////
class Newspaper : public QObject
{
    Q_OBJECT
public:
    Newspaper(const QString & name) :
        m_name(name)
    {
    }
 
    void send()	//发送信号的函数
    {
        emit newPaper(m_name);
    }
 
signals:
    void newPaper(const QString &name);	//信号函数
 
private:
    QString m_name;
};