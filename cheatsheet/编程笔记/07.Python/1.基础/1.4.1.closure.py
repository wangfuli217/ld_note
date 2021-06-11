闭包
要设计一个求平均值的函数, 采用类设计方式, 为:
>>> avg = Averager() 
>>> avg(10) 10.0 
>>> avg(11) 10.5 
>>> avg(12) 11.0

class Averager():
    def __init__(self):
        self.series = []
    def __call__(self, new_value):
        self.series.append(new_value)
        total = sum(self.series)
        return total/len(self.series)
        
>>> avg = make_averager()
>>> avg(10)
10.0
>>> avg(11)
10.5
>>> avg(12)
11.0
>>> avg.__code__.co_varnames
('new_value', 'total')
>>> avg.__code__.co_freevars
('series',)
>>> avg.__closure__  # doctest: +ELLIPSIS
(<cell at 0x...: list object at 0x...>,)
>>> avg.__closure__[0].cell_contents
[10, 11, 12]

def make_averager():
    series = []             #说明此local变量的作用域并不限制在make_averager函数内

    def averager(new_value):
        series.append(new_value)
        total = sum(series)
        return total/len(series)
    return averager
    
    
nonlocal关键词
    def make_averager():
        count = 0
        total = 0
        def averager(new_value):
            nonlocal count
            nonlocal total
            count += 1
            total += new_value
            return total / count
        return averager
        
    # 运行
    avg = make_averager()
    avg(10)	
    

    ### 给装饰器添加其他参数
    使用一个装饰器工厂返回一个装饰器, 并在此装饰器中装饰被装饰对象
    registry = set()  # <1>
    
    def register(active=True):  # <2>
        def decorate(func):  # <3>
            print('running register(active=%s)->decorate(%s)'
                % (active, func))
            if active:   # <4>
                registry.add(func)
            else:
                registry.discard(func)  # <5>
    
            return func  # <6>
        return decorate  # <7>
    
    @register(active=False)  # <8>		等价于 register(active=False)(f1)
    def f1():
        print('running f1()')
    
    @register()  # <9>
    def f2():
        print('running f2()')
    
    def f3():
        print('running f3()')