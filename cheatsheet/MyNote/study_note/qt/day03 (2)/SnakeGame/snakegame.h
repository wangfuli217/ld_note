#ifndef SNAKEGAME_H
#define SNAKEGAME_H
#include <QDialog>
#include <QLabel>
#include <QTimer>
#include <QKeyEvent>
#include <QList>
enum  Direction{D_UP,D_DOWN,D_LEFT,D_RIGHT};
/* 游戏界面类 */
class SnakeGame:public QDialog{
    Q_OBJECT
    /* 蛇 */
    QList<QLabel*>  snake;
    /* 食物 */
    QLabel * food;
    /* 方向 */
    Direction   dire;
    /* 步长 */
    int    footLen;
    /* 控制频率的定时器 */
    QTimer  *timer;
    /* 本关的分数 */
    int    score;
 /* 游戏中涉及到的成员函数 */
public:
    SnakeGame();
    /* 产生新食物的函数 */
    QLabel*  getNewFood();
    /* 蛇移动的函数 根据方向每次移动一个步长 */
public slots:
    void   snakeMove();
    /* 使用键盘事件处理函数 控制方向 */
public:
    void keyPressEvent(QKeyEvent *e);
};
#endif // SNAKEGAME_H





