nonlocal是新近出现的保留关键字，
    它的作用是把变量标记为自由变量，即使在函数中为变量赋予新值了，也会变成自由变量。如果为nonlocal声明的变量赋予新值，闭包中保存的绑定会更新。
    def make_averager(): 
    count = 0 
    total = 0 
 
    def averager(new_value): 
        count += 1           # 在averager的定义体中为count 赋值了，这会把count 变成局部变量。
        total += new_value   # total 变量也受这个问题影响。
        return total / count 
 
    return averager
-----------------------------------------------
    def make_averager(): 
    count = 0 
    total = 0 
 
    def averager(new_value): 
        nonlocal count, total 
        count += 1 
        total += new_value 
        return total / count 
 
    return averager
    Python 2 没有 nonlocal，因此需要变通方法，基本上，这种处理方式是把内部函数需要修改的变量（如 count 和total）存储为可变对象（如字典或
简单的实例）的元素或属性，并且把那个对象绑定给一个自由变量。
    
    装饰器是可调用的对象，其参数是另一个函数（被装饰的函数）。装饰器可能会处理被装饰的函数，然后把它返回，
或者将其替换成另一个函数或可调用对象。
    装饰器的第一大特性是，能把被装饰的函数替换成其他函数。
    装饰器的第二个特性是，装饰器在加载模块时立即执行。  registration.py
    
考虑到装饰器在真实代码中的常用方式，
•  装饰器函数与被装饰的函数在同一个模块中定义。实际情况是，装饰器通常在一个模块中定义，然后应用到其他模块中的函数上。
•  register装饰器返回的函数与通过参数传入的相同。实际上，大多数装饰器会在内部定义一个函数，然后将其返回。

闭包
    闭包指延伸了作用域的函数，其中包含函数定义体中引用、但是不在定义体中定义的非全局变量。关键是它能访问定义体之外定义的非全局变量。
    闭包是一种函数，它会保留定义函数时存在的自由变量的绑定，这样调用函数时，虽然定义作用域不可用了，但是仍能使用那些绑定。
    注意，只有嵌套在其他函数中的函数才可能需要处理不在全局作用域中的外部变量。
    
    
一个简单的装饰器，输出函数的运行时间
    import time 
    
    def clock(func): 
        def clocked(*args):  # 定义内部函数clocked，它接受任意个定位参数。 
            t0 = time.perf_counter() 
            result = func(*args)  # 这行代码可用，是因为clocked 的闭包中包含自由变量func 
            elapsed = time.perf_counter() - t0 
            name = func.__name__ 
            arg_str = ', '.join(repr(arg) for arg in args) 
            print('[%0.8fs] %s(%s) -> %r' % (elapsed, name, arg_str, result)) 
            return result 
        return clocked  # 返回内部函数，取代被装饰的函数。
    
functools.wraps 装饰器把相关的属性从func复制到clocked 中
import time 
import functools 
 
def clock(func): 
    @functools.wraps(func) 
    def clocked(*args, **kwargs): 
        t0 = time.time() 
        result = func(*args, **kwargs) 
        elapsed = time.time() - t0 
        name = func.__name__ 
        arg_lst = [] 
        if args: 
            arg_lst.append(', '.join(repr(arg) for arg in args)) 
        if kwargs: 
            pairs = ['%s=%r' % (k, w) for k, w in sorted(kwargs.items())] 
            arg_lst.append(', '.join(pairs)) 
        arg_str = ', '.join(arg_lst) 
        print('[%0.8fs] %s(%s) -> %r ' % (elapsed, name, arg_str, result)) 
        return result 
    return clocked
    
functools.wraps 只是标准库中拿来即用的装饰器之一。

使用functools.lru_cache做备忘

生成第n 个斐波纳契数，递归方式非常耗时
from clockdeco import clock 
 
@clock 
def fibonacci(n): 
    if n < 2: 
        return n 
    return fibonacci(n-2) + fibonacci(n-1) 
 
if __name__=='__main__': 
    print(fibonacci(6))
    
    
使用缓存实现，速度更快
import functools 
 
from clockdeco import clock 
 
@functools.lru_cache() # 必须像常规函数那样调用 lru_cache。这一行中有一对括号：@functools.lru_cache()。这么做的原因是，lru_cache 可以接受配置参数，
@clock  # 这里叠放了装饰器：@lru_cache()应用到@clock返回的函数上。 
def fibonacci(n): 
    if n < 2: 
        return n 
    return fibonacci(n-2) + fibonacci(n-1) 
 
if __name__=='__main__': 
    print(fibonacci(6))
