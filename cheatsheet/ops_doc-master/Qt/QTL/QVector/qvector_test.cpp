#include <QCoreApplication>
#include<QVector>
#include<QDebug>
int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    //创建QVector对象
    QVector<QString> *vec=new QVector<QString>(0);
    //追加元素
    vec->append("a");
    vec->append("b");
    vec->append("c");
    //查找元素
    qDebug()<<"索引为1的元素是:"<<vec->at(1);
    qDebug()<<"索引为2的元素是:"<<(*vec)[2];
    //删除元素
    vec->removeAt(1);
    qDebug()<<"索引为1的元素是:"<<vec->at(1);
    //插入元素
    vec->insert(1,"d");
    qDebug()<<"索引为1的元素是:"<<vec->at(1);
    //更改元素
    vec->replace(1,"e");
    qDebug()<<"索引为1的元素是:"<<vec->at(1);
    //查看向量是否为空
    qDebug()<<"向量为空:"<<vec->isEmpty();
    //查看向量中元素的个数
    qDebug()<<"向量中元素的个数为:"<<vec->count();
    //返回向量中第一个元素和最后一个元素
    qDebug()<<"第一个元素:"<<vec->first();
    qDebug()<<"最后一个元素:"<<vec->last();
    //重新设置向量的大小
    vec->resize(100);
    qDebug()<<"向量的元素个数:"<<vec->count();
    qDebug()<<"索引为99的元素是:"<<vec->at(99);

    return a.exec();
}