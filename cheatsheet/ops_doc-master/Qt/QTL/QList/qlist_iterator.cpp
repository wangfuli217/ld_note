#include <QCoreApplication>
#include<QDebug>
#include<QList>
#include<QListIterator>
#include<QMutableListIterator>
int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    QList<QString> list;//创建了一个QList容器对象
    list<<"A"<<"B"<<"C"<<"D";
    QListIterator<QString> i(list);//创建了一个指向QList的只读迭代器，用list对象作为参数
    qDebug()<<"the forward is:";
    i.toFront();
    while(i.hasNext())
        qDebug()<<i.next();
    
    qDebug()<<"the backward is:";
    i.toBack();
    while(i.hasPrevious())
        qDebug()<<i.previous();

    QMutableListIterator<QString> j(list);//创建了一个读/写迭代器
    j.toBack();
    while(j.hasPrevious()){
        QString str = j.previous();
        if(str=="B") j.remove();
    }
    /*
    要十分注意上面这个while循环，其实原本是ABCD列表(假如从左到右排列)，然后删除B后，
    因为最后又多执行了一次循环内部代码，所以迭代器就指向A的左侧了。
    */
    j.insert("Q");
    j.toBack();
    if(j.hasPrevious()) j.previous()="N";
    j.previous();
    j.setValue("M");
    j.toFront();
    qDebug()<<"the forward is:";
    while(j.hasNext())
        qDebug()<<j.next();
    return a.exec();
}

