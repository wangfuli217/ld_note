#include "snakegame.h"
#include <QTime>
SnakeGame::SnakeGame(){
    qsrand(QTime::currentTime().msec());
    this->resize(800,600);
    footLen=40;
    snake.push_back(getNewFood());
    food=getNewFood();
    dire=D_RIGHT;
    timer=new QTimer(this);
    timer->setInterval(200);
    timer->start();
    score=3;
}
/* 产生新食物的函数 */
QLabel*  SnakeGame::getNewFood(){
    food=new QLabel(this);
    food->resize(footLen,footLen);
    food->setAutoFillBackground(true);
    food->setPalette(QPalette(
        QColor(qrand()%256,qrand()%256
            ,qrand()%256)));
    /* 食物的位置随机
       食物的位置在界面范围内
       食物的位置是 footLen的整数倍 */
    int w=this->width();
    int h=this->height();
    food->move(400,300);
    food->show();
    return  food;
}
/* 蛇移动的函数 根据方向每次移动一个步长 */
void   SnakeGame::snakeMove(){

}
/* 使用键盘事件处理函数 控制方向 */
void SnakeGame::keyPressEvent(QKeyEvent *e){

}

