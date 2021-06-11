#include <QCoreApplication>
#include<QList>
#include<QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    QList<QString> list;//创建了一个QList容器，容器内部存储QString类型的数据，返回一个list对象，该对象有很多操作该容器的方法。
    list<<"aa"<<"bb"<<"cc";//可以采用<<的符号将数据输入到容器内存储。
    if(list[1]=="bb")
    {
        list[1]="ab";
    }
    list.replace(2,"bc");//list对象的replace方法将指定索引位置的元素值替换成指定的类型值，参数1是list索引位置，参数2是指定替换的类型值。
    qDebug()<<"the list is:";
    for(int i=0;i<list.size();++i)//list对象的size方法返回该容器存储的元素个数。
    {
        qDebug()<<list.at(i);//list对象的at方法访问容器内指定索引位置的元素值。
    }
    list.append("dd");//调用list对象的append函数进行尾插入指定类型值。
    list.prepend("mm");//调用list对象的prepend函数进行头插入指定类型值。
    QString str=list.takeAt(2);//调用list对象的takeAt函数删除指定索引值的元素并弹出该删除的类型值。
    qDebug()<<"at(2) item is:"<<str;
    qDebug()<<"the list is:";
    for(int i=0;i<list.size();++i)//list对象的size方法返回该容器存储的元素个数。
    {
        qDebug()<<list.at(i);//list对象的at方法访问容器内指定索引位置的元素值。
    }
    list.insert(2,"mm");//调用list对象的insert方法在指定索引位置插入指定的类型值，参数1是索引值，参数2是要插入的类型值。
    list.swap(1,3);//调用list对象的swap方法交换指定两个索引位置的元素值。
    qDebug()<<"the list is:";
    for(int i=0;i<list.size();++i)//list对象的size方法返回该容器存储的元素个数。
    {
        qDebug()<<list.at(i);//list对象的at方法访问容器内指定索引位置的元素值。
    }
    qDebug()<<"contains'mm'?"<<list.contains("mm");//判断列表中是否包含“mm”
    qDebug()<<"the 'mm' count:"<<list.count("mm");//容器内包含“mm”的个数
    //第一个'mm'的位置，默认从0索引位置开始查找，找到就返回第一个匹配到的元素的索引位置
    qDebug()<<"the first 'mm' index:"<<list.indexOf("mm");
    //第二个'mm'的位置，我们指定从索引位置1开始查找
    qDebug()<<"the second 'mm' index:"<<list.indexOf("mm",1);
    return a.exec();
}
