
垃圾回收
    import gc
    gc.collect() # 显示调用垃圾回收

    gc.disable() # 关闭垃圾回收,当程序需要大量内存时可调用这语句,避免频繁的垃圾回收而影响效率
    gc.enable()  # 开启垃圾回收
