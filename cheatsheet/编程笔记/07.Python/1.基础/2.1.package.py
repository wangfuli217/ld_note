1.import时，也可以指定目录。目录称为包，这类的导入称为包导入。
    包导入是将计算机上的目录变成另一个Python命名空间，它的属性对应于目录中包含的子目录和模块文件
    包导入的语法：
      import dir1.dir2.modname
      from dir1.dir2.modname import x
      
    包导入语句的路径中，每个目录内部必须要有__init__.py这个文件。否则包导入会失败
        __init__.py就像普通模块文件，它可以为空的
        Python首次导入某个目录时，会自动执行该目录下__init__.py文件的所有程序代码
        import dir1.dir2.modname包导入后，每个目录名都成为模块对象 （模块对象的命名空间由该目录下的__init__.py中所有的全局变量定义 （包含显式定义和隐式定义）决定）
        __init__.py中的全局变量称为对应目录包的属性
    
2.任何已导入的目录包也可以用reload重新加载，来强制该目录包重新加载
    reload一个目录包的用法与细节与reload一个模块相同
      
3.包与import使用时输入字数较长，每次使用时需要输入完整包路径。可以用from语句来避免
    import dir2.inner.test2
    dir2.inner.test2.a           # 没有都要完整包路径
    from dir2.inner import test2
    test2.a                      # 用from简化输入

4.包相对导入：from语句可以用.与..：
  from . import modname1     #modname1与本模块在同一包中（即与本文件在同一目录下）
  from .modname1 import name #modname1与本模块在同一包中（即与本文件在同一目录下）
  from .. import modname2    #modname2在本模块的父目录中（即在本文件上层）
  
  Python2中，import modname会优先在本模块所在目录下加载modname以执行相对导入。 因此局部的模块可能会因此屏蔽sys.path上的另一个模块
要想启用相对导入功能，使用from __future__ import absolute_import

Python3中，没有点号的导入均为绝对导入。import总是优先在包外查找模块

5. 对package中对象的引入有两种方式:
    通过 import <parckageName>.<subpackName>...<moduleName> 这种方式, 这样在具体使用模块对象时前面还需带入前缀
     import chapter18.mathproj.comp.numeric.n2
     chapter18.mathproj.comp.numeric.n2.h()

    通过 from <parckageName>.<subpackName>...<moduleName> import <对象名> 这种方式, 这样在具体使用模块对象时前面不需要带入前缀
     from chapter18.mathproj.comp.numeric.n2 import h
     h()
当需要引入父目录或同级模块对象时, 还可以使用点号(.)来实现, 比如:

6. __all__: 这个专门用于 from <packageName>... import * 语句中, 会将__all__中定义的包或模块加载进来. 如果不定义,则什么也不做

