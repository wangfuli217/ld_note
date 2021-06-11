pythoner(1.滥用表达式作为函数参数默认值){
Python允许开发者指定一个默认值给函数参数，虽然这是该语言的一个特征，但当参数可变时，很容易导致混乱，例如，
下面这段函数定义：

>>> def foo(bar=[]):        # bar is optional and defaults to [] if not specified
...    bar.append("baz")    # but this line could be problematic, as we'll see...
...    return bar

在上面这段代码里，一旦重复调用foo()函数（没有指定一个bar参数），那么将一直返回'bar'，因为没有指定参数，
那么foo()每次被调用的时候，都会赋予[]。下面来看看，这样做的结果：

>>> foo() 
["baz"] 
>>> foo() 
["baz", "baz"] 
>>> foo() 
["baz", "baz", "baz"]

解决方案：
>>> def foo(bar=None):
...    if bar is None:  # or if not bar:
...        bar = []
...    bar.append("baz")
...    return bar
...
>>> foo()
["baz"]
>>> foo()
["baz"]
>>> foo()
["baz"]
}

pythoner(2.错误地使用类变量){
先看下面这个例子：
>>> class A(object):
...     x = 1
...
>>> class B(A):
...     pass
...
>>> class C(A):
...     pass
...
>>> print A.x, B.x, C.x
1 1 1

这样是有意义的：

>>> B.x = 2
>>> print A.x, B.x, C.x
1 2 2

再来一遍：

>>> A.x = 3
>>> print A.x, B.x, C.x
3 2 2

仅仅是改变了A.x，为什么C.x也跟着改变了。

在Python中，类变量都是作为字典进行内部处理的，并且遵循方法解析顺序（MRO）。在上面这段代码中，
因为属性x没有在类C中发现，它会查找它的基类（在上面例子中只有A，尽管Python支持多继承）。
换句话说，就是C自己没有x属性，独立于A，因此，引用 C.x其实就是引用A.x。
}
pythoner(3.为异常指定不正确的参数){
假设代码中有如下代码：

>>> try:
...     l = ["a", "b"]
...     int(l[2])
... except ValueError, IndexError:  # To catch both exceptions, right?
...     pass
...
Traceback (most recent call last):
  File "<stdin>", line 3, in <module>
IndexError: list index out of range

    问题在这里，except语句并不需要这种方式来指定异常列表。然而，在Python 2.x中，except Exception,e通常
是用来绑定异常里的 第二参数，好让其进行更进一步的检查。因此，在上面这段代码里，IndexError异常并没有被
except语句捕获，异常最后被绑定 到了一个名叫IndexError的参数上。

    在一个异常语句里捕获多个异常的正确方法是指定第一个参数作为一个元组，该元组包含所有被捕获的异常。
与此同时，使用as关键字来保证最大的可移植性，Python 2和Python 3都支持该语法。
>>> try:
...     l = ["a", "b"]
...     int(l[2])
... except (ValueError, IndexError) as e:  
...     pass
...
}
pythoner(4.误解Python规则范围){
Python的作用域解析是基于LEGB规则，分别是Local、Enclosing、Global、Built-in。实际上，这种解析方法也有一些玄机，看下面这个例子：

>>> x = 10
>>> def foo():
...     x += 1
...     print x
...
>>> foo()
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<stdin>", line 2, in foo
UnboundLocalError: local variable 'x' referenced before assignment

许多人会感动惊讶，当他们在工作的函数体里添加一个参数语句，会在先前工作的代码里报UnboundLocalError错误（ 点击这里查看更详细描述）。

在使用列表时，开发者是很容易犯这种错误的，看看下面这个例子：

>>> lst = [1, 2, 3]
>>> def foo1():
...     lst.append(5)   # This works ok...
...
>>> foo1()
>>> lst
[1, 2, 3, 5]

>>> lst = [1, 2, 3]
>>> def foo2():
...     lst += [5]      # ... but this bombs!
...
>>> foo2()
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<stdin>", line 2, in foo
UnboundLocalError: local variable 'lst' referenced before assignment

为什么foo2失败而foo1运行正常？ 

答案与前面那个例子是一样的，但又有一些微妙之处。foo1没有赋值给lst，而foo2赋值了。lst += [5]实际上就是
lst = lst + [5]，试图给lst赋值（因此，假设Python是在局部作用域里）。然而，我们正在寻找指定给lst的值是
基于lst本身，其实尚未确定。
}

pythoner(5.修改遍历列表){
下面这段代码很明显是错误的：

>>> odd = lambda x : bool(x % 2)
>>> numbers = [n for n in range(10)]
>>> for i in range(len(numbers)):
...     if odd(numbers[i]):
...         del numbers[i]  # BAD: Deleting item from a list while iterating over it
...
Traceback (most recent call last):
  	  File "<stdin>", line 2, in <module>
IndexError: list index out of range

在遍历的时候，对列表进行删除操作，这是很低级的错误。稍微有点经验的人都不会犯。

对上面的代码进行修改，正确地执行：

>>> odd = lambda x : bool(x % 2)
>>> numbers = [n for n in range(10)]
>>> numbers[:] = [n for n in numbers if not odd(n)]  # ahh, the beauty of it all
>>> numbers
[0, 2, 4, 6, 8]
}

pythoner(6.如何在闭包中绑定变量){
看下面这个例子：

>>> def create_multipliers():
...     return [lambda x : i * x for i in range(5)]
>>> for multiplier in create_multipliers():
...     print multiplier(2)
...

你期望的结果是：
0
2
4
6
8
实际上：
8
8
8
8
8
是不是非常吃惊！出现这种情况主要是因为Python的后期绑定行为，该变量在闭包中使用的同时，内部函数又在调用它。

解决方案：

>>> def create_multipliers():
...     return [lambda x, i=i : i * x for i in range(5)]
...
>>> for multiplier in create_multipliers():
...     print multiplier(2)
...
0
2
4
6
8
}
pythoner(7.创建循环模块依赖关系){
假设有两个文件，a.py和b.py，然后各自导入，如下：

在a.py中：

import b
def f():
    return b.x
print f()

在b.py中：

import a
x = 1
def g():
    print a.f()

首先，让我们试着导入a.py：

>>> import a
1

可以很好地工作，也许你会感到惊讶。毕竟，我们确实在这里做了一个循环导入，难道不应该有点问题吗？

仅仅存在一个循环导入并不是Python本身问题，如果一个模块被导入，Python就不会试图重新导入。根据这一点，每个模块在试图访问函数或变量时，可能会在运行时遇到些问题。

当我们试图导入b.py会发生什么（先前没有导入a.py）：

>>> import b
Traceback (most recent call last):
  	  File "<stdin>", line 1, in <module>
  	  File "b.py", line 1, in <module>
    import a
  	  File "a.py", line 6, in <module>
	print f()
  	  File "a.py", line 4, in f
	return b.x
AttributeError: 'module' object has no attribute 'x'

出错了，这里的问题是，在导入b.py的过程中还要试图导入a.py，这样就要调用f()，并且试图访问b.x。但是b.x并未被定义。

可以这样解决，仅仅修改b.py导入到a.py中的g()函数：

x = 1
def g():
    import a	# This will be evaluated only when g() is called
    print a.f()

无论何时导入，一切都可以正常运行：

>>> import b
>>> b.g()
1	# Printed a first time since module 'a' calls 'print f()' at the end
1	# Printed a second time, this one is our call to 'g'
}

pythoner(8.与Python标准库模块名称冲突){
    Python拥有非常丰富的模块库，并且支持“开箱即用”。因此，如果不刻意避免，很容易发生命名冲突事件。
例如，在你的代码中可能有一个email.py的模块，由于名称一致，它很有可能与Python自带的标准库模块发生冲突。
}
pythoner(9.未按规定处理Python2.x和Python3.x之间的区别){}
