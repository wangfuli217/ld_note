iterator协议
    检测是否实现了__iter__()方法
    如果没有实现的话, 再看是否实现了__getitem()__方法
    如果都没有实现, 抛出TypeError异常

Iterable和Iterator
    iterable指的是对象可迭代,一般实现__iter__()方法
    iterator指的是被隐藏起来的iterator对象,实现了__next__()和__iter__()方法,并且__iter__()返回self, 
    __next()__返回下一个元素或当没有更多元素时抛出StopIteration
    
1. 容器(container)
容器是一种把多个元素组织在一起的数据结构，容器中的元素可以逐个地迭代获取，可以用in, not in关键字判断元素是否包含在容器中。

list, deque, ….
set, frozensets, ….
dict, defaultdict, OrderedDict, Counter, ….
tuple, namedtuple, …
str
    尽管绝大多数容器都提供了某种方式来获取其中的每一个元素，但这并不是容器本身提供的能力，而是可迭代对象赋予了容器这种能力，
当然并不是所有的容器都是可迭代的，

2. 可迭代对象(iterable)
很多容器都是可迭代对象，此外还有更多的对象同样也是可迭代对象，比如处于打开状态的files，sockets等等。但凡是可以返回一个
迭代器的对象都可称之为可迭代对象，
>>> x = [1, 2, 3]
>>> y = iter(x)
>>> z = iter(x)
>>> next(y)
1
>>> next(y)
2
>>> next(z)
1
>>> type(x)
<class 'list'>
>>> type(y)
<class 'list_iterator'>
list是可迭代对象，dict是可迭代对象，set也是可迭代对象。
y和z是两个独立的迭代器，迭代器内部持有一个状态，该状态用于记录当前迭代所在的位置，以方便下次迭代的时候获取正确的元素。
迭代器有一种具体的迭代器类型，比如list_iterator，set_iterator。可迭代对象实现了__iter__方法，该方法返回一个迭代器对象。

3. 迭代器(iterator)
是一个带状态的对象，他能在你调用next()方法的时候返回容器中的下一个值，任何实现了__iter__和__next__()
（python2中实现next()）方法的对象都是迭代器，__iter__返回迭代器自身，__next__返回容器中的下一个值，
如果容器中没有更多元素了，则抛出StopIteration异常，至于它们到底是如何实现的这并不重要。
>>> from itertools import count
>>> counter = count(start=13)
>>> next(counter)
13
>>> next(counter)
14

>>> from itertools import cycle
>>> colors = cycle(['red', 'white', 'blue'])
>>> next(colors)
'red'
>>> next(colors)
'white'
>>> next(colors)
'blue'
>>> next(colors)
'red'

4. 生成器(generator)
生成器算得上是Python语言中最吸引人的特性之一，生成器其实是一种特殊的迭代器，不过这种迭代器更加优雅。它不需要再像上面
的类一样写__iter__()和__next__()方法了，只需要一个yiled关键字。 生成器一定是迭代器（反之不成立），因此任何生成器也是
以一种懒加载的模式生成值。
def fib():
    prev, curr = 0, 1
    while True:
        yield curr
        prev, curr = curr, curr + prev
>>> f = fib()
>>> list(islice(f, 0, 10))
[1, 1, 2, 3, 5, 8, 13, 21, 34, 55]

5. 生成器表达式(generator expression)
生成器表达式是列表推倒式的生成器版本，看起来像列表推导式，但是它返回的是一个生成器对象而不是列表对象。
>>> a = (x*x for x in range(10))
>>> a
<generator object <genexpr> at 0x401f08>
>>> sum(a)
285

总结
1. 容器是一系列元素的集合，str、list、set、dict、file、sockets对象都可以看作是容器，容器都可以被迭代（用在for，while等语句中），因此他们被称为可迭代对象。
2. 可迭代对象实现了__iter__方法，该方法返回一个迭代器对象。
3. 迭代器持有一个内部状态的字段，用于记录下次迭代返回值，它实现了__next__和__iter__方法，迭代器不会一次性把所有元素加载到内存，而是需要的时候才生成返回结果。
4. 生成器是一种特殊的迭代器，它的返回值不是通过return而是用yield。
