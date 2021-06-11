// libev需要的头文件
#include <ev.h>
#include <stdio.h>
 
// 建立我们刚刚说的需要监听的事件，这些事件类型是libev提供的
// with the name ev_TYPE
//ev_io和ev_timer最为常用，ev_io为监听控制台输入，ev_timer为时间事件
ev_io stdin_watcher;
ev_timer timeout_watcher;
 
// 以下为自定义的回调函数，当触发监听事件时，调用执行对应的函数
 
// ev_io事件的回调函数，当有输入流stdin时，调用函数
static void stdin_cb (EV_P_ ev_io *w, int revents){
    puts ("stdin ready");
    //对ev_io事件的监控不会自动停止，需要手动在需要的时候停止
    ev_io_stop (EV_A_ w);
     
    //整体的loop事件在所有监控停止时停止，也可以手动关闭全部的ev_run
    ev_break (EV_A_ EVBREAK_ALL);
}
 
// 时间事件的自定义回调函数，可定时触发
static void timeout_cb (EV_P_ ev_timer *w, intrevents){
    puts ("timeout");
    //关闭最早的一个还在运行的ev_run
    ev_break (EV_A_ EVBREAK_ONE);
}
 
int main (void){
    //定义默认的 event loop，它就像一个大容器，可以装载着很多事件不停运行
    struct ev_loop *loop = EV_DEFAULT;
     
    // 初始化ev_io事件监控，设置它的回调函数，和stdin
    ev_io_init (&stdin_watcher, stdin_cb,/*STDIN_FILENO*/ 0, EV_READ);
    //将ev_io事件放到event loop里面运行
    ev_io_start (loop, &stdin_watcher);
     
    // 初始化ev_timer事件监控，设置它的回调函数，间隔时间，是否重复
    ev_timer_init (&timeout_watcher, timeout_cb, 5.5,0.);
    //将ev_timer事件放到event loop里面运行
    ev_timer_start (loop, &timeout_watcher);
     
    // 将我们的大容器event loop整体运行起来
    ev_run (loop, 0);
     
    // ev_run运行结束之后，才会运行到这里
    return 0;
}