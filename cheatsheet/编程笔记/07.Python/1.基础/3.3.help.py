# dir()、help()、type()
dir和help是Python中两个强大的built-in函数，就像Linux的man一样，绝对是开发的好帮手。

dir()用来查询一个类或者对象所有属性。
>>>print dir(list)

help()用来查询的说明文档。
>>>print help(list)           # 格式化过以后的信息
>>>print(str.split.__doc__)   # 未格式化的信息

type函数：查看变量的类型
>>> type (json.__name__)