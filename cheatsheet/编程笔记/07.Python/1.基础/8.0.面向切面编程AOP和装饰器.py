面向切面编程AOP和装饰器
    这个AOP一听起来有点懵,同学面阿里的时候就被问懵了...
    装饰器是一个很著名的设计模式，经常被用于有切面需求的场景，较为经典的有插入日志、性能测试、事务处理等。
    装饰器是解决这类问题的绝佳设计，有了装饰器，我们就可以抽离出大量函数中与函数功能本身无关的雷同代码并继续重用。
    概括的讲，装饰器的作用就是为已经存在的对象添加额外的功能。
    
Python自省
    这个也是python彪悍的特性.
    自省就是面向对象的语言所写的程序在运行时,所能知道对象的类型.简单一句就是运行时能够获得对象的类型.
    比如type(),dir(),getattr(),hasattr(),isinstance().

a = [1,2,3]
b = {'a':1,'b':2,'c':3}
c = True
print type(a),type(b),type(c) # <type 'list'> <type 'dict'> <type 'bool'>
print isinstance(a,list)  # True