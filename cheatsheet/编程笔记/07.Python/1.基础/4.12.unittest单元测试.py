
unittest 模块(单元测试)
    单元测试的好处：
      在编写代码之前，通过编写单元测试来强迫你使用有用的方式细化你的需求。
      在编写代码时，单元测试可以使你避免过度编码。当所有测试用例通过时，实现的方法就完成了。
      重构代码时，单元测试用例有助于证明新版本的代码跟老版本功能是一致的。
      在维护代码期间，可验证代码是否破坏原有代码的状态。
      在团队编码中，缜密的测试套件可以降低你的代码影响别人代码的机率，提前发现代码与其他人的不可以良好工作。
    单元测试的原则：
      完全自动运行，而不需要人工干预。单元测试几乎是全自动的。
      自主判断被测试的方法是通过还是失败，而不需要人工解释结果。
      独立运行，而不依赖其它测试用例(即使测试的是同样的方法)。即，每一个测试用例都是一个孤岛。


断点调试
    测试离不开断点调试
    import pdb; pdb.set_trace() # 运行到这语句，会出现断点

    输入命令：
    命令的详细帮助: h
    查看代码上下文, l(小写L)
    监视变量: p 变量名
    单步执行: n
    加入断点: b 行号
    跳出断点: c
    执行到函数返回前: r

    命令行上，进入调试模式：
    python -mpdb script.py


######################### 示例 #################################

#### roman1.py 文件的内容 start ####

    # 定义异常类型(这里仅做范例，不执行什么)
    class OutOfRangeError(ValueError): pass
    class NotIntegerError(ValueError): pass

    roman_numeral_map = (('M',  1000),
         ('CM', 900), ('D',  500), ('CD', 400), ('C',  100),
         ('XC', 90),  ('L',  50),  ('XL', 40),  ('X',  10),
         ('IX', 9),   ('V',  5),   ('IV', 4),   ('I',  1))

    # 被测试函数
    def to_roman(n):
        '''convert integer to Roman numeral'''
        # 数值范围判断
        if not ( 0 < n < 4000 ):
            raise OutOfRangeError('number out of range (must be less than 4000)')
        # 类型判断, 内建的 isinstance() 方法可以检查变量的类型
        # isinstance(n, int) 与 type(n) is int 等效
        if not isinstance(n, int):
            raise NotIntegerError('non-integers can not be converted')
        result = ''
        for numeral, integer in roman_numeral_map:
            while n >= integer:
                result += numeral
                n -= integer
        return result

#### roman1.py 文件的内容 end  ####



#### 测试文件的内容 start ####

    import roman1 # 导入被测试的类
    import unittest

    # 需继承 unittest 模块的TestCase 类。TestCase 提供了很多可以用于测试特定条件的有用的方法。
    class KnownValues(unittest.TestCase):
        def setUp(self):
            """初始化"""
            #执行数据库连接，数据初始化等,此函数可不写
            pass

        # setUp 和 tearDown 在执行每个测试函数的前后都会执行
        def tearDown(self):
            """销毁"""
            pass

        # 每一个独立的测试都有它自己的不含参数及没有返回值的方法。如果方法不抛出异常而正常退出则认为测试通过;否则，测试失败。
        # 测试本身是类一个方法，并且该方法以 test 开头命名。如果不是 test 开头，则不会执行。
        def test_to_roman_known_values(self):
            # 对于每一个测试用例， unittest 模块会打印出测试方法的 docstring ，并且说明该测试失败还是成功。
            # 失败时必然打印docstring, 成功时需使用“-v”命令行参数来查看。
            '''to_roman 方法传回的值与用例的数据不相等时,则测试不通过'''
            # 测试的用例，一般是所有明显的边界用例。
            known_values = ( (1, 'I'), (2, 'II'), (3, 'III'), (4, 'IV'),
                (5, 'V'), (6, 'VI'), (7, 'VII'), (8, 'VIII'),
                (9, 'IX'), (10, 'X'), (50, 'L'), (100, 'C'),
                (500, 'D'), (1000, 'M'), (31, 'XXXI'), (148, 'CXLVIII'),
                (3888, 'MMMDCCCLXXXVIII'), (3940, 'MMMCMXL'), (3999, 'MMMCMXCIX') )
            for integer, numeral in known_values:
                result = roman1.to_roman(integer) # 这里调用真实的方法。如果该方法抛出了异常，则测试被视为失败。
                self.assertEqual(numeral, result) # 检查两个值是否相等。如果两个值不一致，则抛出异常，并且测试失败。
                self.assertNotEqual(0, result, '这两个值不应该相等') # 检查两个值是否不相等。
                self.assertTrue(5 > 0, '5 > 0 都出错，不是吧')
                self.assertFalse(5 < 0)
            # 对于每一个失败的测试用例， unittest 模块会打印出详细的跟踪信息。
            # 如果所有返回值均与已知的期望值一致，则 self.assertEqual 不会抛出任何异常，于是此次测试最终会正常退出，这就意味着 to_roman() 通过此次测试。
            assert 5 > 0 # 为了更灵活的判断，可使用 assert

        # 测试异常,让被测试的方法抛出异常，这里来验证异常类型。如果预期的异常没有抛出，则测试失败。
        def test_over_value(self):
            '''参数过大或者过小时, to_roman 方法应该抛出异常信息'''
            # assertRaises 方法需要以下参数：你期望的异常、你要测试的方法及传入给方法的参数。
            #(如果被测试的方法需要多个参数的话，则把所有参数依次传入 assertRaises， 它会正确地把参数传递给被测方法的。)
            self.assertRaises(roman1.OutOfRangeError, roman1.to_roman, 4000)
            # 注意是把 to_roman() 方法作为参数传递;没有调用被测方法，也不是把被测方法作为一个字符串名字传递进去
            self.assertRaises(roman1.OutOfRangeError, roman1.to_roman, 0)
            self.assertRaises(roman1.OutOfRangeError, roman1.to_roman, -1)

        # 验证参数类型
        def test_non_integer(self):
            '''如果参数不是 int 类型时， to_roman 方法应该抛出异常'''
            self.assertRaises(roman1.NotIntegerError, roman1.to_roman, 0.5)
            self.assertRaises(roman1.NotIntegerError, roman1.to_roman, 6.0)

    # 在说明每个用例的详细执行结果之后， unittest 打印出一个简述来说明“多少用例被执行了”和“测试执行了多长时间”。
    if __name__ == '__main__':
        # main 方法会执行每个测试用例
        unittest.main()


#### 测试文件的内容 end ####
