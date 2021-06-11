//Windows7下无这两个函数库
#include <curses.h>
//使用curses函数库和前面定义的kbhit()函数
#include <sys/filio.h>

int kbhit()
{
    int i;
    ioctl(0,FIONREAD,&i);
    return i;   //返回可以读取的字符的计数值
}

main()
{
    int c = ' ', i = 0;

    initscr();  //初始化curses函数
    cbreak();
    noecho();   //按键时不再屏幕上回显字符

    mvprintw(0, 0, "Press 'q' to quit\n");
    refresh();

    while(c != 'q')
        if(kbhit())
        {
            c = getch();    //不会阻塞，因为我们知道有一个字符正在等待
            mvprintw(1, 0, "got char '%c' on iteration %d \n", c, ++i);
            refresh();
        }
    nocbreak();
    echo();
    endwin();
}
