
程序停止
=============================
当主程序(main program)收到一个 SIGQUIT 信号时，不能成功做 yield 操作的 Greenlet 可能会令意外地挂起程序的执行。这导致了所谓的僵尸进程， 它需要在 Python 解释器之外被 kill 掉。
对此，一个通用的处理模式就是在主程序中监听 SIGQUIT 信号，在程序退出 调用 gevent.shutdown 。

# 示例
    import gevent
    import signal

    def run_forever():
        gevent.sleep(1000)

    if __name__ == '__main__':
        gevent.signal(signal.SIGQUIT, gevent.shutdown)
        thread = gevent.spawn(run_forever)
        thread.join()

