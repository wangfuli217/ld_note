operator
1. attrgetter
operator.attrgetter(attr)和operator.attrgetter(*attrs)
    After f = attrgetter(‘name’), the call f(b) returns b.name.
    After f = attrgetter(‘name’, ‘date’), the call f(b) returns (b.name, b.date).
    After f = attrgetter(‘name.first’, ‘name.last’), the call f(b) returns (b.name.first, b.name.last).
    
>>> class Student:
...     def __init__(self, name, grade, age):
...         self.name = name
...         self.grade = grade
...         self.age = age
...     def __repr__(self):
...         return repr((self.name, self.grade, self.age))
>>> student_objects = [
...     Student('john', 'A', 15),
...     Student('jane', 'B', 12),
...     Student('dave', 'B', 10),
... ]
>>> sorted(student_objects, key=lambda student: student.age)   # 传统的lambda做法
[('dave', 'B', 10), ('jane', 'B', 12), ('john', 'A', 15)]
>>> from operator import itemgetter, attrgetter
>>> sorted(student_objects, key=attrgetter('age'))
[('dave', 'B', 10), ('jane', 'B', 12), ('john', 'A', 15)]
# 但是如果像下面这样接受双重比较，Python脆弱的lambda就不适用了
>>> sorted(student_objects, key=attrgetter('grade', 'age'))
[('john', 'A', 15), ('dave', 'B', 10), ('jane', 'B', 12)]

2. itemgetter
operator.itemgetter(item)和operator.itemgetter(*items)
    After f = itemgetter(2), the call f(r) returns r[2].
    After g = itemgetter(2, 5, 3), the call g(r) returns (r[2], r[5], r[3]).
    
>>> student_tuples = [
...     ('john', 'A', 15),
...     ('jane', 'B', 12),
...     ('dave', 'B', 10),
... ]
>>> sorted(student_tuples, key=lambda student: student[2])   # 传统的lambda做法
[('dave', 'B', 10), ('jane', 'B', 12), ('john', 'A', 15)]
>>> from operator import attrgetter
>>> sorted(student_tuples, key=itemgetter(2))
[('dave', 'B', 10), ('jane', 'B', 12), ('john', 'A', 15)]
# 但是如果像下面这样接受双重比较，Python脆弱的lambda就不适用了
>>> sorted(student_tuples, key=itemgetter(1,2))
[('john', 'A', 15), ('dave', 'B', 10), ('jane', 'B', 12)]
    
3. methodcaller
operator.methodcaller(name[, args…])
    After f = methodcaller(‘name’), the call f(b) returns b.name().
    After f = methodcaller(‘name’, ‘foo’, bar=1), the call f(b) returns b.name(‘foo’, bar=1).

from operator import methodcaller 
class Student(object): 
    def __init__(self, name): 
        self.name = name 
    def get_name(self): 
        return self.name 

stu = Student("Jim") 
func = methodcaller('get_name') 
print func(stu) # 输出Jim 还可以给方法传递参数： 
f=methodcaller('name', 'foo', bar=1) 
f(b) # return b.name('foo', bar=1)


4. 逻辑操作
>>> a=2
>>> b=5
>>> from operator import *
>>> not_(a)
False
>>> truth(a)
True
>>> is_(a, b)
False
>>> is_not(a,b)
True

5. 比较操作符
所有富比较操作符都得到支持。
from operator import *
a = 1
b = 5
for func in (lt, le, eq, ne, ge, gt):
    print funct(a,b)
    
6. 序列操作符
处理序列的操作符可以分为四组：建立序列，搜索元素，访问内容和从序列中删除元素。
6.1 建立序列
a = [1,2,3]
b = ['a', 'b', 'c']
print concat(a,b)
print repeat(a,3)
6.2 搜索序列
print contains(a,1)    
print contains(b,"d")   
print countOf(a, 'a')
print countOf(b,"d")
print indexOf(a,1)
6.3 访问序列
>>> from operator import *
>>> a=[1,2,3]
>>> b=['a','b','c']
>>> getitem(b,1)
'b'
>>> getslice(a,1,3)
[2, 3]
>>> setitem(b,1,'d')
>>> b
['a', 'd', 'c']
>>> setslice(a,1,3,[4,5])
>>> a
[1, 4, 5]
6.4 从序列中删除元素
>>> delitem(b,1)
>>> b
['a', 'c']
>>> delslice(a,1,3)
>>> a

注意 setitem和delitem会原地修改序列，而不会返回值。
    原地操作符 除了标准操作符之外，很多对象类型还通过一些特殊操作符支持原地修改。

>>> a=-1
>>> b=5
>>> c=[1,2,3]
>>> d=['a','b','c']
>>> a=iadd(a,b)
>>> a
4
>>> c=iconcat(c,d)
>>> c
[1, 2, 3, 'a', 'b', 'c']

mul乘法
a = [1,2,3]
b = [5,6,7]
c = map(operator.mul, a, b)
c的值就为[5, 12, 21]