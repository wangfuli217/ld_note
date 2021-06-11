1. 任何的序列（或者是可迭代对象）可以通过一个简单的赋值语句解压并赋值给多个变量。
 唯一的前提就是变量的数量必须跟序列元素的数量是一样的。
 >>> p = (4, 5)
>>> x, y = p
>>> x
4
>>> y
5
>>>
>>> data = [ 'ACME', 50, 91.1, (2012, 12, 21) ]
>>> name, shares, price, date = data
>>> name
'ACME'
>>> date
(2012, 12, 21)
>>> name, shares, price, (year, mon, day) = data
>>> name
'ACME'
>>> year
2012
>>> mon
12
>>> day
21
>>>

如果变量个数和序列元素的个数不匹配，会产生一个异常。
>>> s = 'Hello' 
>>> a, b, c, d, e = s
1.1 有时候，你可能只想解压一部分，丢弃其他的值。对于这种情况 Python 并没有提供特殊的语法。 但是你可以使用任意变量名去占位，到时候丢掉这些变量就行了。
>>> data = [ 'ACME', 50, 91.1, (2012, 12, 21) ] 
>>> _, shares, price, _ = data 
>>> shares 50 
>>> price 91.1 
1.2 Python3才支持 * 解析
def drop_first_last(grades): 
    first, *middle, last = grades 
    return avg(middle)