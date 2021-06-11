//
// Created by chenchukun on 18/1/25.
//
#include <uv.h>
#include <iostream>
#include "sock.h"
#include <assert.h>
#include <cstring>
using namespace std;

int cnt = 0;

void accept_cb(uv_poll_t *handle, int status, int events)
{
    if (status < 0) {
        cerr << "accept_cb: " << uv_strerror(status) << endl;
        return;
    }
    ++cnt;
    int connfd = accept(*(int*)handle->data, NULL, NULL);
    if (connfd < 0) {
        cerr << "accept: " << strerror(errno) << endl;
    }
    static const char *buff = "hello uv_poll_t\n";
    write(connfd, buff, strlen(buff));
    close(connfd);
    if (cnt >= 3) {
        // 停止监控该文件描述符
        uv_poll_stop(handle);
        // 调用uv_poll_stop()后才可关闭文件描述符,否则可能出错
        close(*(int*)handle->data);
        free(handle);
    }
}

int main(int argc, char **argv)
{
    uv_loop_t *loop = uv_default_loop();

    signal_action(SIGPIPE, SIG_IGN);

    int listenfd = socket(AF_INET, SOCK_STREAM, 0);
    assert(listenfd >= 0);
    set_reuseaddr(listenfd, true);
    listenfd = sock_listen(listenfd, AF_INET, 1024, 6180);
    if (listenfd < 0) {
        cerr << "sock_listen: " << strerror(errno) << endl;
        exit(-1);
    }
    set_nonblock(listenfd, true);
    set_nodelay(listenfd, true);

    // uv_poll_t可以用于将文件描述符集成到事件循环中
    uv_poll_t *poll_handle = (uv_poll_t*)malloc(sizeof(uv_poll_t));
    uv_poll_init(loop, poll_handle, listenfd);
    poll_handle->data = &listenfd;
    uv_poll_start(poll_handle, UV_READABLE, accept_cb);

    uv_run(loop, UV_RUN_DEFAULT);
    uv_stop(loop);
    return 0;
}