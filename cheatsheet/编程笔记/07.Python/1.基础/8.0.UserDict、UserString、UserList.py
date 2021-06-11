http://www.dongwm.com/archives/UserDict%E3%80%81UserString%E3%80%81UserList%E5%AD%98%E5%9C%A8%E7%9A%84%E6%84%8F%E4%B9%89/

最近遇到了一个继承Python内建结构的坑儿和大家分享下。从Python 2.2开始，Python支持继承Python内建结构，如list、dict。最近在实现一个功能，为了简化内容，我直接继承了dict，但是结果和预期不一样。举个例子：

In : class NewDict(dict):
...:     def __getitem__(self, key):
...:         return 42
...:
In : d = NewDict(a=1)
In : d
Out: {'a': 42}
In : d2 = {}
In : d2.update(d)
In : d2
Out: {'a': 1}

也就是说NewDict的__getitem__方法被dict.update给忽略了。这让我很惊讶，我之前用UserDict的时候是正常的（这次为啥直接用dict也不知道抽了什么筋）：

In : from UserDict import UserDict
In : class NewDict(UserDict):
...:     def __getitem__(self, key):
...:         return 42
...:
In : d = NewDict(a=1)
In : d['b'] =2
In : d
Out: {'a': 1, 'b': 2}
In : d['b']
Out: 42
In : d2 = {}
In : d2.update(d)
In : d2
Out: {'a': 42, 'b': 42}

这才是对的呀。所以我开始研究找答案。后来在PyPy的文档中发现了原因，也就是这种C实现的结构的内建方法大部分会忽略重载的那个方法。

之前我以为UserDict这样的类是历史遗留问题，现在才知道是有原因的。原来UserDict、UserString、UserList这样的模块是非常必要的。