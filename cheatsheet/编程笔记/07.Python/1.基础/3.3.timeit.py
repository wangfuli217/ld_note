Command line usage:
        python timeit.py [-n N] [-r N] [-s S] [-t] [-c] [-h] [--] [statement]
    
    Options:
      -n/--number N: 执行指定语句（段）的次数
      -r/--repeat N: 重复测量的次数（默认 3 次）
      -s/--setup S: 指定初始化代码或构建环境的导入语句（默认是 pass）
      -p            测量进程时间而不是实际执行时间（使用 time.process_time() 代替默认的 time.perf_counter()）
      -t/--time: use time.time() (default on Unix)
      -c/--clock: use time.clock() (default on Windows)
      -v/--verbose: print raw timing results; repeat for more digits precision
      -h/--help: print this usage message and exit
      --: separate options from statement, use when statement starts with -
      statement: statement to be timed (default 'pass')

$ python -m timeit '"-".join(str(n) for n in range(100))' 
10000 loops, best of 3: 40.3 usec per loop 
$ python -m timeit '"-".join([str(n) for n in range(100)])' 
10000 loops, best of 3: 33.4 usec per loop 
$ python -m timeit '"-".join(map(str, range(100)))' 
10000 loops, best of 3: 25.2 usec per loop

      
class Timer # 该模块定义了三个实用函数和一个公共类。
timeit.timeit(stmt='pass', setup='pass', timer=<default timer>, number=1000000)
    创建一个 Timer 实例，参数分别是 
        stmt（需要测量的语句或函数），
        setup（初始化代码或构建环境的导入语句），
        timer（计时函数），
        number（每一次测量中语句被执行的次数）
注：由于 timeit() 正在执行语句，语句中如果存在返回值的话会阻止 timeit() 返回执行时间。timeit() 会取代原语句中的返回值。

timeit.repeat(stmt='pass', setup='pass', timer=<default timer>, repeat=3, number=1000000)
    创建一个 Timer 实例，参数分别是 
        stmt（需要测量的语句或函数），
        setup（初始化代码或构建环境的导入语句），
        timer（计时函数），
        repeat（重复测量的次数），
        number（每一次测量中语句被执行的次数）

timeit.default_timer()
    默认的计时器，一般是 time.perf_counter()，time.perf_counter() 方法能够在任一平台提供最高精度的计时器
    （它也只是记录了自然时间，记录自然时间会被很多其他因素影响，例如计算机的负载）。
    
    
class timeit.Timer(stmt='pass', setup='pass', timer=<timer function>)
    计算小段代码执行速度的类，构造函数需要的参数有 
        stmt（需要测量的语句或函数），
        setup（初始化代码或构建环境的导入语句），
        timer（计时函数）。前两个参数的默认值都是 'pass'，
        timer 参数是平台相关的；
    前两个参数都可以包含多个语句，多个语句间使用分号（;）或新行分隔开。

>>> import timeit 
>>> timeit.timeit('"-".join(str(n) for n in range(100))', number=10000) 
0.8187260627746582 
>>> timeit.timeit('"-".join([str(n) for n in range(100)])', number=10000) 
0.7288308143615723 
>>> timeit.timeit('"-".join(map(str, range(100)))', number=10000) 
0.5858950614929199


def test():
    """Stupid test function"""
    L = []
    for i in range(100):
        L.append(i)

if __name__ == '__main__':
    import timeit
    print(timeit.timeit("test()", setup="from __main__ import test"))

