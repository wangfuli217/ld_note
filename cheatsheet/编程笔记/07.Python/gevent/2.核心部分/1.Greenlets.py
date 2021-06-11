
Greenlets

    在gevent中用到的主要模式是 Greenlet, 它是以C扩展模块形式接入Python的轻量级协程。
    Greenlet全部运行在主程序操作系统进程的内部，但它们被协作式地调度。

    ** 在任何时刻，只有一个协程在运行。

    这与 multiprocessing 或 threading 等提供真正并行构造的库是不同的。
    这些库轮转使用操作系统调度的进程和线程，是真正的并行。

