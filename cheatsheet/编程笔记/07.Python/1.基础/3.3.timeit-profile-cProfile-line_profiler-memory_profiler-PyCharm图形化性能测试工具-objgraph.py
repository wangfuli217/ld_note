1.timeit：# timeit只输出被测试代码的总运行时间，单位为秒，没有详细的统计。

>>> import timeit
>>> def fun():
    for i in range(100000):
        a = i * i

>>> timeit.timeit('fun()', 'from __main__ import fun', number=1)
0.02922706632834235

2.profile # 纯Python实现的性能测试模块，接口和cProfile一样。

>>> import profile
>>> def fun():
   for i in range(100000):
      a = i * i

>>> profile.run('fun()')
         5 function calls in 0.031 seconds

   Ordered by: standard name
   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
   
ncall：函数运行次数
tottime： 函数的总的运行时间，减去函数中调用子函数的运行时间
第一个percall：percall = tottime / nclall 
cumtime:函数及其所有子函数调整的运行时间，也就是函数开始调用到结束的时间。
第二个percall：percall = cumtime / nclall

3.cProfile
profile：c语言实现的性能测试模块，接口和profile一样。

4.line_profiler
安装：
pip install line_profiler
安装之后kernprof.py会加到环境变量中。
line_profiler可以统计每行代码的执行次数和执行时间等，时间单位为微妙。
测试代码：

C:\Python34\test.py

import time
@profile
def fun():
    a = 0
    b = 0
    for i in range(100000):
        a = a + i * i

    for i in range(3):
        b += 1
        time.sleep(0.1)

    return a + b
fun()
使用：
1.在需要测试的函数加上@profile装饰，这里我们把测试代码写在C:\Python34\test.py文件上.
2.运行命令行：kernprof -l -v C:\Python34\test.py
Total Time：测试代码的总运行时间 
Hits：表示每行代码运行的次数  
Time：每行代码运行的总时间  
Per Hits：每行代码运行一次的时间  
% Time：每行代码运行时间的百分比


# stack overflow - time explained（堆栈溢出 - 时间解释）
# line_profiler（线性分析器）
# memory_profiler（内存分析器）
# objgraph（对象图）