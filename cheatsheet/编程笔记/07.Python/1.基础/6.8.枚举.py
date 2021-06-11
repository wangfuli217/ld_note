
python 前面版本没有原生的 枚举, 需要自己封装一个。(Python 3.4+ 开始有枚举了)


新版本的枚举写法(python 3.4)

    # 写法1
    from enum import Enum
    Animal = Enum('Animal', 'ant bee cat dog')


    # 写法2
    class Animals(Enum):
        ant = 1
        bee = 2
        cat = 3
        dog = 4


旧版Python用户可以充分发挥动态语言的优越性来构造枚举：

# 示例1 (用 type 函数实现， 兼容py2及3写法)
    # 写法1
    # 有字典映射的功能，可以映射出各种类型，不局限于数字。 用 key/value 的参数形式构造
        def enum(**enums):
            return type('Enum', (), enums)

        Numbers = enum(ONE=1, TWO=2, THREE='three')
        print( Numbers.ONE == 1 and Numbers.TWO == 2 and Numbers.THREE == 'three' ) # 打印: True


    # 写法2， (是 写法1 的增强版)
    # 可用 key 参数来构造,下标从0开始。 也可用 key/value 的参数形式构造
        def enum(*args, **kwargs):
            enums = dict(zip(args, range(len(args))), **kwargs)
            return type('Enum', (), enums)

        Numbers = enum('ZERO', 'ONE', 'TWO', THREE='three')
        print( Numbers.ZERO == 0 and Numbers.ONE == 1 and Numbers.TWO == 2 and Numbers.THREE == 'three' ) # 打印: True


    # 写法3， (是 写法2 的增强版)
    # 带值到名称映射的功能
        def enum(*args, **kwargs):
            enums = dict(zip(args, range(len(args))), **kwargs)
            reverse = dict((value, key) for key, value in enums.items())
            enums['reverse_mapping'] = reverse
            return type('Enum', (), enums)

        Numbers = enum('ZERO', 'ONE', 'TWO', THREE='three')
        print( Numbers.ZERO == 0 and Numbers.ONE == 1 and Numbers.TWO == 2 and Numbers.THREE == 'three' ) # 打印: True
        print( Numbers.reverse_mapping[2] == 'TWO' ) # 打印: True
        print( Numbers.reverse_mapping['three'] == 'THREE' ) # 打印: True


# 示例2 (用 list/tuple/set 实现， 兼容py2及3写法)
    # 写法1， 用 set 实现
    # 没有字符数字映射的功能， 仅直接返回名称字符串
        class Enum(set):
            def __getattr__(self, name):
                if name in self:
                    return name
                raise AttributeError

        Animals = Enum(["DOG", "CAT", "HORSE"])
        print( Animals.DOG == 'DOG' and Animals.HORSE == 'HORSE' ) # 打印: True


    # 写法2， 用 tuple/list 实现
    # 具备字符数字映射的功能， 比上面优化一点

        class Enum(tuple): __getattr__ = tuple.index
        #class Enum(list): __getattr__ = list.index # 功能跟上面一样,效率稍差一点

        Animals = Enum(["DOG", "CAT", "HORSE"])
        print( Animals.DOG == 0 and Animals.HORSE == 2 ) # 打印: True


# 示例3 (用 range 实现，写法简便， 兼容py2及3写法)

    # 写法1 (直接定义静态变量)
    dog, cat, rabbit = range(3)


    # 写法2 (枚举类形式)
    class Stationary:
        (Pen, Pencil, Eraser) = range(0, 3)

    print( Stationary.Pen == 0 and Stationary.Eraser == 2 ) # 打印: True


# 示例4 (用 namedtuple 实现， 兼容py2及3写法)

    # 写法1， 没有字符数字映射的功能， 仅直接返回名称字符串
        from collections import namedtuple
        def enum(*keys):
            return namedtuple('Enum', keys)(*keys)

        Animals = enum("DOG", "CAT", "HORSE")
        print( Animals.DOG == 'DOG' and Animals.HORSE == 'HORSE' ) # 打印: True


    # 写法2， 带字符数字映射的功能 (是 写法1 的增强版)
        from collections import namedtuple
        def enum(*keys):
            return namedtuple('Enum', keys)(*range(len(keys)))

        Animals = enum("DOG", "CAT", "HORSE")
        print( Animals.DOG == 0 and Animals.HORSE == 2 ) # 打印: True


    # 写法3， (跟 写法2 的参数类型不同)
    # 带有字典映射的功能，可以映射出各种类型，不局限于数字。 用 key/value 的参数形式构造
        from collections import namedtuple
        def enum(**kwargs):
            return namedtuple('Enum', kwargs.keys())(*kwargs.values())

        Numbers = enum(ONE=1, TWO=2, THREE='three')
        print( Numbers.ONE == 1 and Numbers.TWO == 2 and Numbers.THREE == 'three' ) # 打印: True


    # 写法4， (是 写法2 + 写法3 的综合版)
    # 有字符数字映射的功能， 也带有字典映射的功能，可以映射出各种类型，不局限于数字。
        from collections import namedtuple
        def enum(*args, **kwargs):
            enums = dict(zip(args, range(len(args))), **kwargs)
            return namedtuple('Enum', enums.keys())(*enums.values())

        Numbers = enum('ZERO', 'ONE', 'TWO', THREE='three')
        print( Numbers.ZERO == 0 and Numbers.ONE == 1 and Numbers.TWO == 2 and Numbers.THREE == 'three' ) # 打印: True


    # 写法5， (是 写法4 的增强版)
    # 带值到名称映射的功能
        from collections import namedtuple
        def enum(*args, **kwargs):
            enums = dict(zip(args, range(len(args))), **kwargs)
            reverse = dict((value, key) for key, value in enums.items())
            enums['reverse_mapping'] = reverse
            return namedtuple('Enum', enums.keys())(*enums.values())

        Numbers = enum('ZERO', 'ONE', 'TWO', THREE='three')
        print( Numbers.ZERO == 0 and Numbers.ONE == 1 and Numbers.TWO == 2 and Numbers.THREE == 'three' ) # 打印: True
        print( Numbers.reverse_mapping[2] == 'TWO' ) # 打印: True
        print( Numbers.reverse_mapping['three'] == 'THREE' ) # 打印: True


# 示例5 (用 内部类 实现， 兼容py2及3写法)

    # 写法1， 带字符数字映射的功能
        def enum(*args):
            class Enum(object):
                def __init__(self):
                    for i, key in enumerate(args, 0):
                        setattr(self, key, i)

            return Enum()

        Animals = enum("DOG", "CAT", "HORSE")
        print( Animals.DOG == 0 and Animals.HORSE == 2 ) # 打印: True


    # 写法2， (是 写法1 的增强版)
    # 有字符数字映射的功能， 也带有字典映射的功能，可以映射出各种类型，不局限于数字。
        def enum(*args, **kwargs):
            class Enum(object):
                def __init__(self):
                    for i, key in enumerate(args, 0):
                        setattr(self, key, i)

                    for key, value in kwargs.items():
                        setattr(self, key, value)

            return Enum()

        Numbers = enum('ZERO', 'ONE', 'TWO', THREE='three')
        print( Numbers.ZERO == 0 and Numbers.ONE == 1 and Numbers.TWO == 2 and Numbers.THREE == 'three' ) # 打印: True


    # 写法3， (是 写法2 的增强版)
    # 带值到名称映射的功能
        def enum(*args, **kwargs):
            enums = {}
            class Enum(object):
                def __init__(self):
                    for i, key in enumerate(args, 0):
                        setattr(self, key, i)
                        enums[key] = i

                    enums.update(kwargs)
                    for key, value in kwargs.items():
                        setattr(self, key, value)

                    self.reverse_mapping = dict((value, key) for key, value in enums.items())

            return Enum()

        Numbers = enum('ZERO', 'ONE', 'TWO', THREE='three')
        print( Numbers.ZERO == 0 and Numbers.ONE == 1 and Numbers.TWO == 2 and Numbers.THREE == 'three' ) # 打印: True
        print( Numbers.reverse_mapping[2] == 'TWO' ) # 打印: True
        print( Numbers.reverse_mapping['three'] == 'THREE' ) # 打印: True

