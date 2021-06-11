#include <QCoreApplication>
#include<QDebug>
#include<QList>
#include<QListIterator>
#include<QMutableListIterator>
#include<QMap>
#include<QMapIterator>
#include<QMutableMapIterator>
int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    QMap<QString,QString> map;
    map.insert("Paris","France");
    map.insert("Guatemala City","Guatemala");
    map.insert("Mexico City","Mexio");
    map.insert("Moscow","Russia");
    QMapIterator<QString,QString> i(map);//创建了一个只读迭代器指向QMap对象
    while(i.hasNext()){
        i.next();
        /*
        注意，调用next函数后返回的是一个项目对象，可以使用这个项目对象的key()和value()方法获取，
        例如：i.next().key()。但是对于这里的需求是我们需要获取键和值，如果连续两次执行i.next().key()
        和i.next().value()那么迭代器就移动两次了，很明显不符合我们的需求。其实当单独执行了这个函数，迭代器也向后移
        动了一次，并且内部已经保存了跳过的
        项目的键和值，它告诉我们可以通过i对象的key()和
        value()函数获取。就好像下面那条语句一样。
        */
        qDebug()<<i.key()<<":"<<i.value();
    }
    qDebug()<<"--------------------";
    if(i.findPrevious("Mexico")) qDebug()<<"find 'Mexico'";
    QMutableMapIterator<QString,QString> j(map);
    while(j.hasNext()){
        //下面的j.next.key()语句可以看出，就是我们上面介绍的那样，不过这里的应用场景是为了只单独获取键，
        //然后匹配以City的项目后再删除。
        if(j.next().key().endsWith("City"))
            j.remove();
    }
    while(j.hasPrevious()){
        j.previous();
        qDebug()<<j.key()<<":"<<j.value();
    }
    return a.exec();
}
