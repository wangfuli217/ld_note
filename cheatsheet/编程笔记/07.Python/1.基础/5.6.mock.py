
# 参考:  http://www.oschina.net/translate/unit-testing-with-the-python-mock-class

Mock 是什么
    Mock 这个词在英语中有模拟的这个意思，因此我们可以猜测出这个库的主要功能是模拟一些东西。
    准确的说， Mock 是 Python 中一个用于支持单元测试的库，它的主要功能是使用 mock 对象替代掉指定的 Python 对象，以达到模拟对象的行为。
    简单的说， mock 库用于如下的场景：

        假设你开发的项目叫a，里面包含了一个模块b，模块b中的一个函数c（也就是a.b.c）
        在工作的时候需要调用发送请求给特定的服务器来得到一个JSON返回值，然后根据这个返回值来做处理。
        如果要为a.b.c函数写一个单元测试，该如何做？

    一个简单的办法是搭建一个测试的服务器，在单元测试的时候，让a.b.c函数和这个测试服务器交互。
    但是这种做法有两个问题：
        测试服务器可能很不好搭建，或者搭建效率很低。
        你搭建的测试服务器可能无法返回所有可能的值，或者需要大量的工作才能达到这个目的。

    那么如何在没有测试服务器的情况下进行上面这种情况的单元测试呢？
    Mock模块就是答案。上面已经说过了，mock模块可以替换Python对象。

    我们假设a.b.c的代码如下：

        import requests

        def c(url):
            resp = requests.get(url)
            # further process with resp

    如果利用 mock 模块，那么就可以达到这样的效果：
        使用一个 mock 对象替换掉上面的 requests.get 函数，然后执行函数c时，c调用 requests.get 的返回值就能够由我们的 mock 对象来决定，而不需要服务器的参与。
        简单的说，就是我们用一个 mock 对象替换掉c函数和服务器交互的过程。
        你一定很好奇这个功能是如何实现的，这个是 mock 模块内部的实现机制，不在本文的讨论范围。
        本文主要讨论如何用 mock 模块来解决上面提到的这种单元测试场景。


Mock的安装和导入
    在 Python 3.3 以前的版本中，需要另外安装 mock 模块，可以使用pip命令来安装：

        $ sudo pip install mock

    然后在代码中就可以直接import进来：

        import mock

    从 Python 3.3 开始， mock 模块已经被合并到标准库中，被命名为 unittest.mock ，可以直接import进来使用：

        from unittest import mock


Mock对象-基本用法
    Mock 对象是 mock 模块中最重要的概念。
    Mock 对象就是 mock 模块中的一个类的实例，这个类的实例可以用来替换其他的Python对象，来达到模拟的效果。
    Mock 类的定义如下：

        class Mock(spec=None, side_effect=None, return_value=DEFAULT, wraps=None, name=None, spec_set=None, **kwargs)

    Mock 类的主要参数：
        name: 这个是用来命名一个 mock 对象，只是起到标识作用，当你 print 一个 mock 对象的时候，可以看到它的 name 。
        return_value: 这个字段可以指定一个值（或者对象），当 mock 对象被调用时，如果 side_effect 函数返回的是 DEFAULT ，则对 mock 对象的调用会返回 return_value 指定的值。
        side_effect: 这个参数指向一个可调用对象，一般就是函数。当 mock 对象被调用时，如果该函数返回值不是 DEFAULT 时，那么以该函数的返回值作为 mock 对象调用的返回值。

        注: side_effect 参数和 return_value 是相反的。side_effect 给 mock 分配了可替换的结果，覆盖了 return_value 。
        简单的说，一个模拟工厂调用将返回 side_effect 值(如果有的话)，而不是 return_value 。仅当没有 side_effect 才返回 return_value 。

    这里给出这个定义只是要说明下 Mock 对象其实就是个 Python 类而已，当然，它内部的实现是很巧妙的，有兴趣的可以去看 mock 模块的代码。
    Mock 对象的一般用法是这样的：

        1.找到你要替换的对象，这个对象可以是一个类，或者是一个函数，或者是一个类实例。
        2.然后实例化 Mock 类得到一个 mock 对象，并且设置这个 mock 对象的行为，比如被调用的时候返回什么值，被访问成员的时候返回什么值等。
        3.使用这个 mock 对象替换掉我们想替换的对象，也就是步骤1中确定的对象。
        4.之后就可以开始写测试代码，这个时候我们可以保证我们替换掉的对象在测试用例执行的过程中行为和我们预设的一样。

    ### Mock 对象的 return_value参数 ###

        from mock import Mock

        # create the mock object
        mockFoo = Mock(return_value = 456)

        print mockFoo # 打印: <Mock id='2787568'>

        mockObj = mockFoo()
        print mockObj # 打印: returns: 456


    上面的 return_value 参数用法，也许你看不出有什么用，下面例子会让你明白它的真正用处。
    举个例子来说：我们有一个简单的客户端实现，用来访问一个URL，当访问正常时，需要返回状态码200，不正常时，需要返回状态码404。
    首先，我们的客户端代码实现如下：

        import requests

        class Client():

            def send_request(self, url):
                r = requests.get(url)
                return r.status_code

            def visit_ustack(self):
                return self.send_request('http://www.ustack.com')

    外部模块调用 visit_ustack() 来访问 UnitedStack 的官网。
    下面我们使用 mock 对象在单元测试中分别测试访问正常和访问不正常的情况。

        import unittest
        import mock

        class TestClient(unittest.TestCase):

            def test_success_request(self):
                success_send = mock.Mock(return_value=200)
                clent = Client() # 需导入上面说的 客户端代码 里面的 Client
                clent.send_request = success_send
                self.assertEqual(clent.visit_ustack(), 200)

            def test_fail_request(self):
                fail_send = mock.Mock(return_value=404)
                clent = Client()
                clent.send_request = fail_send
                self.assertEqual(clent.visit_ustack(), 404)

        if __name__ == "__main__":
            unittest.main()

    1.找到要替换的对象：我们需要测试的是 visit_ustack 这个函数，那么我们需要替换掉 send_request 这个函数。
    2.实例化 Mock 类得到一个mock对象，并且设置这个 mock 对象的行为。
      在成功测试中，我们设置 mock 对象的返回值为字符串“200”，在失败测试中，我们设置 mock 对象的返回值为字符串"404"。
    3.使用这个 mock 对象替换掉我们想替换的对象。我们替换掉了 client.send_request。
    4.写测试代码。我们调用 client.visit_ustack() ，并且期望它的返回值和我们预设的一样。

    上面这个就是使用 mock 对象的基本步骤了。
    在上面的例子中我们替换了自己写的模块的对象，其实也可以替换标准库和第三方模块的对象，方法是一样的：先 import 进来，然后替换掉指定的对象就可以了。


mock 对象的自动创建
    当访问一个 mock 对象中不存在的属性时， mock 会自动建立一个子 mock 对象，并且把正在访问的属性指向它，这个功能对于实现多级属性的 mock 很方便。

        client = mock.Mock() # 只有空参的 Mock 对象才行。有参数的则会生成对应的对象，不能随意修改里面属性。
        client.v2_client.get.return_value = '200'

    这个时候，你就得到了一个 mock 过的 client 实例，调用该实例的 v2_client.get() 方法会得到的返回值是"200"。
    从上面的例子中还可以看到，指定 mock 对象的 return_value 还可以使用属性赋值的方法。


Mock 对象的 参数 使用示例
  ### 参数 return_value (指定返回值)用法1 ###

    from mock import Mock

    # create the mock object
    mockFoo = Mock(return_value = 456)

    print mockFoo # 打印: <Mock id='2787568'>

    mockObj = mockFoo()
    print mockObj # 打印: returns: 456


  ### 参数 return_value (指定返回值)用法2 ###
    # return_value 参数，除了可以传入基础类型(string,int,float,time等等)，还可以传入 object 类型(即任意类型都可以)

    from mock import Mock

    # The mock object
    class Foo(object):
        # instance properties
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    # creating the mock object
    fooObj = Foo()
    print fooObj # 打印: <__main__.Foo object at 0x68550>

    mockFoo = Mock(return_value = fooObj)
    print mockFoo # 打印: <Mock id='2788144'>

    # creating an "instance"
    mockObj = mockFoo()
    print mockObj # 打印: <__main__.Foo object at 0x68550>

    # working with the mocked instance
    print mockObj._fooValue # 打印: 123
    mockObj.callFoo() # 打印: Foo:callFoo_
    mockObj.doFoo("narf") # 打印: Foo:doFoo:input =  narf


  ### 参数 side_effect (执行时抛出指定异常类型)用法1 ###
    # side_effect 参数与 return_value 参数是互斥的。有 side_effect 的时候返回 side_effect 值，而不是 return_value 。

    from mock import Mock

    mockFoo = Mock(return_value = 456)
    print mockFoo # 打印: <Mock id='2788144'>

    # creating an "instance"
    mockObj = mockFoo()
    print mockObj # 打印: 456

    # 这上面是直接返回 return_value 的值，下面是 return_value 和 side_effect 两参数一起时发生的效果

    # creating a mock object (with a side effect)
    mockFoo2 = Mock(return_value = 456, side_effect = ['side_effect_value'])
    mockObj2 = mockFoo2()
    print mockObj2 # 这看到 side_effect 生效了，不再返回 return_value ，而是返回 side_effect 的值。打印: side_effect_value

    # 如果想测试抛异常的情况，可以让 side_effect 指定异常
    mockFoo3 = Mock(return_value = 456, side_effect = StandardError)
    mockObj3 = mockFoo3() # raises: StandardError


  ### 参数 side_effect (指定返回值列表)用法2 ###
    # side_effect 参数，是要你可以传入可迭代对象（列表，集合，元组），然后每次调用时按迭代顺序返回。
    # 你不能传入一个简单对象（如int,float,time等），因为这些对象是不能迭代的，为了让简单对象可迭代，需要将他们加入列表中。

    from mock import Mock

    fooList = [665, 666, 667]
    mockFoo = Mock(side_effect = fooList)

    print mockFoo() # 打印: 665

    print mockFoo() # 打印: 666

    print mockFoo() # 打印: 667

    print mockFoo() # raises: StopIteration


Mock 对象的 断言 使用示例
    # Mock 断言将帮助跟踪测试对象对 mock 方法的调用。他们能和 unittest 模块的断言一起工作。能连接到 mock 或者其方法属性之一。
    # 有两个相同的可选参数：一个变量序列，一个键/值序列。

  ### 断言 assert_called_with (检查调用参数)用法1 ###
    # 断言 assert_called_with() ，检查 mock 方法是否获得了正确的参数。当至少一个参数有错误的值或者类型时，当参数的数量错误时，当参数的顺序错误时，或者当 mock 的方法根本不存在任何参数时，这个断言将引发错误。

    from mock import Mock

    # The mock object
    class Foo(object):
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    # create the mock object
    mockFoo = Mock(spec = Foo)
    print mockFoo # 打印: <Mock spec='Foo' id='507120'>

    mockFoo.doFoo("narf")
    mockFoo.doFoo.assert_called_with("narf")
    # assertion passes

    mockFoo.doFoo("zort")
    mockFoo.doFoo.assert_called_with("narf")
    # AssertionError: Expected call: doFoo('narf')
    # Actual call: doFoo('zort')


  ### 断言 assert_called_with (检查调用是否有参数)用法2 ###
    # assert_called_with 还支持没有传入参数的断言

    from mock import Mock

    # The mock object
    class Foo(object):
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    # create the mock object
    mockFoo = Mock(spec = Foo)
    print mockFoo # 打印: <Mock spec='Foo' id='507120'>

    mockFoo.callFoo()
    mockFoo.callFoo.assert_called_with()
    # assertion passes

    mockFoo.callFoo("zort")
    mockFoo.callFoo.assert_called_with()
    # AssertionError: Expected call: callFoo()
    # Actual call: callFoo('zort')


  ### 断言 assert_called_once_with (检查是否首次调用)用法 ###
    # assert_called_once_with() 像 assert_called_with() 一样，这个断言检查测试对象是否正确的调用了 mock 方法。
    # 但是当同样的方法调用超过一次时， assert_called_once_with() 将引发错误，然而 assert_called_with() 会忽略多次调用。
    # 注意： assert_called_once_with 并不关注参数，只要这函数调用第二次，不管参数是否相同都抛 AssertionError

    from mock import Mock

    # The mock object
    class Foo(object):
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    # create the mock object
    mockFoo = Mock(spec = Foo)
    print mockFoo # 打印: <Mock spec='Foo' id='507120'>

    mockFoo.doFoo('a')
    mockFoo.doFoo.assert_called_with('a')
    mockFoo.doFoo.assert_called_once_with('a')
    # assertion passes

    mockFoo.doFoo('b')
    mockFoo.doFoo.assert_called_with('b') # assertion passes， 忽略调用次数
    mockFoo.doFoo.assert_called_once_with('b') # 虽然参数不同，但 assert_called_once_with 关注的是函数调用次数，因为这里是第二次调用。
    # AssertionError: Expected to be called once. Called 2 times.


  ### 断言 assert_any_call (检查是否有调用，忽略先后顺序)用法 ###
    # 断言assert_any_call()，检查测试对象在测试例程中是否调用了测试方法。
    # 它不管 mock 方法和断言之间有多少其他的调用。和前面两个断言相比较，前两个断言仅检查最近一次的调用。

    from mock import Mock

    # The mock object
    class Foo(object):
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    # create the mock object
    mockFoo = Mock(spec = Foo)
    print mockFoo # 打印: <Mock spec='Foo' id='507120'>

    mockFoo.callFoo()
    mockFoo.doFoo("narf")
    mockFoo.doFoo("zort")

    mockFoo.callFoo.assert_any_call() # 虽然空参的调用后面隔了两次其它的调用，但 assert_any_call 不在乎
    # assert passes

    mockFoo.callFoo()
    mockFoo.doFoo("troz")

    mockFoo.doFoo.assert_any_call("zort") # 只要曾经调用过这参数的， assert_any_call 都认
    # assert passes

    mockFoo.doFoo.assert_any_call("egad") # 这参数的确没有调用过
    # raises: AssertionError: doFoo('egad') call not found


  ### 断言 assert_has_calls (检查是否按顺序、参数调用)用法 ###
    # assert_has_calls() 查看方法调用的顺序，检查他们是否按正确的次序调用并带有正确的参数。
    # 它带有两个参数：期望调用方法的列表和一个可选值 any_order 。
    # 当测试对象调用了错误的方法，调用了不在次序中的方法，或者方法获得了一个错误的输入，将产生断言错误。

    from mock import Mock, call

    # The mock object
    class Foo(object):
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    # create the mock object
    mockFoo = Mock(spec = Foo)
    print mockFoo # 打印: <Mock spec='Foo' id='507120'>

    mockFoo.callFoo()
    mockFoo.doFoo("narf")
    mockFoo.doFoo("zort")

    fooCalls = [call.callFoo(), call.doFoo("narf"), call.doFoo("zort")] # 注意导入的 call，这样都能获取到，真是太神奇了
    mockFoo.assert_has_calls(fooCalls)
    # assert passes

    fooCalls = [call.callFoo(), call.doFoo("zort"), call.doFoo("narf")] # 不按顺序也认为是错误的调用
    mockFoo.assert_has_calls(fooCalls)
    # AssertionError: Calls not found.
    # Expected: [call.callFoo(), call.doFoo('zort'), call.doFoo('narf')]
    # Actual: [call.callFoo(), call.doFoo('narf'), call.doFoo('zort')]

    fooCalls = [call.callFoo(), call.doFoo("zort"), call.doFoo("narf")]
    mockFoo.assert_has_calls(fooCalls, any_order = True) # any_order 参数为 True 时不关注调用顺序
    # assert passes

    # 下面添加了不存在的方法 dooFoo()，断言失败，通知我期望调用的顺序和真实发生的顺序不匹配。如果我给 any_order 赋值为 True，断言名称 dooFoo() 作为违规的方法调用。
    fooCalls = [call.callFoo(), call.dooFoo("narf"), call.doFoo("zort")]
    mockFoo.assert_has_calls(fooCalls)
    # AssertionError: Calls not found.
    # Expected: [call.callFoo(), call.dooFoo('narf'), call.doFoo('zort')]
    # Actual: [call.callFoo(), call.doFoo('narf'), call.doFoo('zort')]

    fooCalls = [call.callFoo(), call.dooFoo("narf"), call.doFoo("zort")]
    mockFoo.assert_has_calls(fooCalls, any_order = True)
    # AssertionError: (call.dooFoo('narf'),) not all found in call list


Mock 对象的 管理 使用示例
    # Mock 类的第三套方法允许你控制和管理 mock 对象。
    # 你可以更改 mock 的行为，改变它的属性或者将 mock 恢复到测试前的状态。你甚至可以更改每个 mock 方法或者 mock 本身的响应值。

  ### 方法 attach_mock (添加另一个 mock 对象)用法 ###
    # attach_mock()方法让你在 mock 中添加第二个 mock 对象。这个方法带有两个参数：第二个 mock 对象(aMock)和一个属性名称(aName)。

    from mock import Mock

    # The mock object
    class Foo(object):
        # instance properties
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    class Bar(object):
        # instance properties
        _barValue = 456

        def callBar(self):
            pass

        def doBar(self, argValue):
            pass

    # create the first mock object
    mockFoo = Mock(spec = Foo)
    print mockFoo # 打印: <Mock spec='Foo' id='507120'>

    # create the second mock object
    mockBar = Mock(spec = Bar)
    print mockBar # 打印: <Mock spec='Bar' id='2784400'>

    # attach the second mock to the first
    # 用 attach_mock() 方法将 mockBar 添加到 mockFoo 中，命名为 fooBar 。
    # 一旦添加成功，我就能通过属性 fooBar 访问第二 mock 对象和它的属性。并且我仍然可以访问第一个 mock 对象 mockFoo 的属性。
    mockFoo.attach_mock(mockBar, 'fooBar')

    # access the first mock's attributes
    print mockFoo # mockFoo 的id没变，打印: <Mock spec='Foo' id='507120'>
    print mockFoo._fooValue # 打印: <Mock name='mock._fooValue' id='428976'>
    print mockFoo.callFoo() # 打印: <Mock name='mock.callFoo()' id='448144'>

    # access the second mock and its attributes
    print mockFoo.fooBar # mockFoo.fooBar 的 id 跟 mockBar 的 id 一致，打印: <Mock name='mock.fooBar' spec='Bar' id='2784400'>
    print mockBar._barValue # 打印: <Mock name='mock.fooBar._barValue' id='2788016'>
    print mockFoo.fooBar._barValue # 跟上面直接调用 mockBar 的id一致，打印: <Mock name='mock.fooBar._barValue' id='2788016'>
    print mockFoo.fooBar.callBar() # 打印: <Mock name='mock.fooBar.callBar()' id='2819344'>
    print mockFoo.fooBar.doBar("narf") # 打印: <Mock name='mock.fooBar.doBar()' id='4544528'>


  ### 方法 configure_mock (修改属性)用法 ###
    # 使用 configure_mock() 方法可以更改 return_value 及 side_effect 参数

    from mock import Mock

    class Foo(object):
        # instance properties
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    mockFoo = Mock(spec = Foo, return_value = 555) # spec 参数指定 模仿 的对象
    print mockFoo() # 打印: 555

    mockFoo.configure_mock(return_value = 999)
    print mockFoo() # 打印: 999

    print mockFoo.callFoo() # 没有返回值，打印: <Mock name='mock.callFoo()' id='41671032'>
    print mockFoo.doFoo("narf") # 没有返回值，打印: <Mock name='mock.doFoo()' id='50350624'>

    fooSpec = {'callFoo.return_value':"narf", 'doFoo.return_value':"zort", 'doFoo.side_effect':None}
    mockFoo.configure_mock(**fooSpec)

    print mockFoo.callFoo() # 打印: narf
    print mockFoo.doFoo("narf") # 打印: zort

    fooSpec = {'doFoo.side_effect':StandardError}
    mockFoo.configure_mock(**fooSpec)
    print mockFoo.doFoo("narf") # raises: StandardError


  ### 给每个方法属性分配 return_value 或者 side_effect 属性(效果同 configure_mock 方法) ###

    from mock import Mock

    class Foo(object):
        # instance properties
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    mockFoo = Mock(spec = Foo, return_value = 555) # spec 参数指定 模仿 的对象
    print mockFoo() # 打印: 555

    mockFoo.return_value = 999 # 效果相当于 mockFoo.configure_mock(return_value = 999)
    print mockFoo() # 打印: 999

    print mockFoo.callFoo() # 没有返回值，打印: <Mock name='mock.callFoo()' id='41671032'>
    print mockFoo.doFoo("narf") # 没有返回值，打印: <Mock name='mock.doFoo()' id='50350624'>

    mockFoo.callFoo.return_value = "narf"
    mockFoo.doFoo.return_value = "zort"
    # 上面两行的效果相当于 mockFoo.configure_mock(**{'callFoo.return_value':"narf", 'doFoo.return_value':"zort"})
    print mockFoo.callFoo() # 按指定的 return_value ，打印: narf
    print mockFoo.doFoo("narf") # 按指定的 return_value ，打印: zort

    mockFoo.callFoo.side_effect = TypeError # 效果相当于 mockFoo.configure_mock(**{'callFoo.side_effect': TypeError})
    print mockFoo.callFoo() # raises: TypeError

    mockFoo.callFoo.side_effect = None # 效果相当于 mockFoo.configure_mock(**{'callFoo.side_effect': None})
    print mockFoo.callFoo() # 去掉抛异常，正常打印


  ### 方法 mock_add_spec (修改 模仿 的对象)用法 ###
    # 方法 mock_add_spec() 让你向 mock 对象添加新的属性。除了 mock_add_spec() 工作在一个已存在的对象上之外，它的功能类似于构造器的 spec 参数。
    # 它擦除了一些构造器设置的属性。这个方法带有两个参数：spec属性（aSpec）和spc_set标志（aFlag）。spce可以是字符串、列表或者是类。
    # 已添加的属性缺省状态是只读的，但是通过设置 spec_set 标志为 True ，可以让属性可写。

    from mock import Mock

    # The class interfaces
    class Foo(object):
        # instance properties
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    class Bar(object):
        # instance properties
        _barValue = 456

        def callBar(self):
            pass

        def doBar(self, argValue):
            pass

    # create the mock object
    mockFoo = Mock(spec = Foo)
    print mockFoo # 打印: <Mock spec='Foo' id='507120'>
    print mockFoo._fooValue # 打印: <Mock name='mock._fooValue' id='2788112'>
    print mockFoo.callFoo() # 打印: <Mock name='mock.callFoo()' id='2815376'>

    # add a new spec attributes
    mockFoo.mock_add_spec(Bar) # mock 对象的 spec 属性已经被替换了
    print mockFoo # 打印: <Mock spec='Bar' id='507120'>
    print mockFoo._barValue # 打印: <Mock name='mock._barValue' id='2815120'>
    print mockFoo.callBar() # 打印: <Mock name='mock.callBar()' id='4544368'>

    # 由于替换 spec 后的 Bar 对象没有下面属性，所以报错(即使替换前是有)
    print mockFoo._fooValue # raises: AttributeError: Mock object has no attribute '_fooValue'
    print mockFoo.callFoo() # raises: AttributeError: Mock object has no attribute 'callFoo'


  ### 方法 reset_mock (重置统计及断言信息)用法 ###
    # 方法 reset_mock()，恢复 mock 对象到测试前的状态。它清除了 mock 对象的调用统计和断言。
    # 它不会清除 mock 对象的 return_value 和 side_effect 属性和它的方法属性。这样做是为了重新使用 mock 对象避免重新创建 mock 的开销。

    from mock import Mock

    # The mock object
    class Foo(object):
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    # create the mock object
    mockFoo = Mock(spec = Foo)
    print mockFoo # 打印: <Mock spec='Foo' id='507120'>

    mockFoo.callFoo()
    mockFoo.callFoo.assert_called_once_with()
    # assertion passes

    mockFoo.reset_mock() # 没有这行 reset_mock 的话，下面的断言则会报错，因为调用第二次了
    mockFoo.callFoo()
    mockFoo.callFoo.assert_called_once_with()
    # assertion passes


Mock 对象的 统计 使用示例
    # Mock 对象的 统计 包含跟踪 mock 对象所做的任意调用的访问器。

  ### called 属性(是否被访问过)用法 ###
    # 当 mock 对象获得工厂调用时，访问器 called 返回 True ，否则返回 False 。

    from mock import Mock

    # The mock object
    class Foo(object):
        # instance properties
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    # create the first mock object
    mockFoo = Mock(spec = Foo)
    print mockFoo # 打印: <Mock spec='Foo' id='507120'>
    print mockFoo.called # 打印: False

    mockFoo()
    print mockFoo.called # 打印: True

    mockFoo2 = Mock(spec = Foo)
    print mockFoo2.called # 打印: False

    mockFoo2.callFoo()
    print mockFoo2.called # 打印: False
    print mockFoo2.callFoo.called # 打印: True


  ### call_count 属性(被访问次数)用法 ###
    # 访问器 call_count 给出了 mock 对象被工厂调用的次数。

    from mock import Mock

    # The mock object
    class Foo(object):
        # instance properties
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    # create the first mock object
    mockFoo = Mock(spec = Foo)
    print mockFoo # 打印: <Mock spec='Foo' id='507120'>

    print mockFoo.call_count # 打印: 0

    mockFoo()
    print mockFoo.call_count # 打印: 1
    print mockFoo.callFoo.call_count # 打印: 0

    mockFoo.callFoo()
    print mockFoo.call_count # 打印: 1
    print mockFoo.callFoo.call_count # 打印: 1

    mockFoo.callFoo()
    print mockFoo.call_count # 打印: 1
    print mockFoo.callFoo.call_count # 打印: 2


  ### call_args 属性(被调用的参数)用法 ###
    # 访问器 call_args 返回工厂调用时的参数。

    from mock import Mock

    # The mock object
    class Foo(object):
        # instance properties
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    # create the first mock object
    mockFoo = Mock(spec = Foo, return_value = "narf")
    print mockFoo # 打印: <Mock spec='Foo' id='507120'>
    print mockFoo.call_args # 打印: None

    mockFoo("zort")
    print mockFoo.call_args # 打印: call('zort')

    mockFoo()
    print mockFoo.call_args # 打印: call()

    mockFoo("troz")
    print mockFoo.call_args # 打印: call('troz')

    mockFoo.callFoo("zort", "troz")
    print mockFoo.call_args # 打印: call('troz')
    print mockFoo.callFoo.call_args # 打印: call('zort', 'troz')


  ### call_args_list 属性(被调用的历史参数列表)用法 ###
    # 访问器 call_args_list 也报告了工厂调用中已使用的参数。但是 call_args 返回最近使用的参数，而 call_args_list 返回一个历史参数列表。

    from mock import Mock

    # The mock object
    class Foo(object):
        # instance properties
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    # create the first mock object
    mockFoo = Mock(spec = Foo, return_value = "narf")
    print mockFoo # 打印: <Mock spec='Foo' id='507120'>

    mockFoo("zort")
    print mockFoo.call_args_list # 打印: [call('zort')]

    mockFoo()
    print mockFoo.call_args_list # 打印: [call('zort'), call()]

    mockFoo("troz")
    print mockFoo.call_args_list # 打印: [call('zort'), call(), call('troz')]

    mockFoo.callFoo("zort", "troz")
    print mockFoo.call_args_list # 打印: [call('zort'), call(), call('troz')]
    print mockFoo.callFoo.call_args_list # 打印: [call('zort', 'troz')]


  ### mothod_calls 属性(被调用的函数列表)用法 ###
    # 访问器 mothod_calls 报告了测试对象所做的 mock 方法的调用。它的结果是一个列表对象，每一项显示了方法的名称和它的参数。

    from mock import Mock

    # The mock object
    class Foo(object):
        # instance properties
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    # create the first mock object
    mockFoo = Mock(spec = Foo, return_value = "poink")
    print mockFoo # 打印: <Mock spec='Foo' id='507120'>
    print mockFoo.method_calls # 打印: []

    mockFoo()
    print mockFoo.method_calls # 打印: []

    mockFoo.callFoo()
    print mockFoo.method_calls # 打印: [call.callFoo()]

    mockFoo.doFoo("narf")
    print mockFoo.method_calls # 打印: [call.callFoo(), call.doFoo('narf')]

    mockFoo()
    print mockFoo.method_calls # 打印: [call.callFoo(), call.doFoo('narf')]


  ### mock_calls 属性(被调用的工厂及函数列表)用法 ###
    # 访问器 mock_calls 报告了测试对象对 mock 对象所有的调用。结果是一个列表，但是工厂调用和方法调用都显示了。

    from mock import Mock

    # The mock object
    class Foo(object):
        # instance properties
        _fooValue = 123

        def callFoo(self):
            print "Foo:callFoo_"

        def doFoo(self, argValue):
            print "Foo:doFoo:input = ", argValue

    # create the first mock object
    mockFoo = Mock(spec = Foo, return_value = "poink")
    print mockFoo # 打印: <Mock spec='Foo' id='507120'>

    print mockFoo.mock_calls # 打印: []

    mockFoo()
    print mockFoo.mock_calls # 打印: [call()]

    mockFoo.callFoo()
    print mockFoo.mock_calls # 打印: [call(), call.callFoo()]

    mockFoo.doFoo("narf")
    print mockFoo.mock_calls # 打印: [call(), call.callFoo(), call.doFoo('narf')]

    mockFoo()
    print mockFoo.mock_calls # 打印: [call(), call.callFoo(), call.doFoo('narf'), call()]


Mock 对象的 patch 和 patch.object
    # 在了解了 mock 对象之后，我们来看两个方便测试的函数： patch 和 patch.object 。
    # 这两个函数都会返回一个 mock 内部的类实例，这个类是 class_patch 。返回的这个类实例既可以作为函数的装饰器，也可以作为类的装饰器，也可以作为上下文管理器。
    # 使用 patch 或者 patch.object 的目的是为了控制 mock 的范围，意思就是在一个函数范围内，或者一个类的范围内，或者 with 语句的范围内 mock 掉一个对象。

  ### patch 函数 用法 ###
    # client.py 代码 #
    import requests

    def send_request(url):
        r = requests.get(url)
        return r.status_code

    def visit_ustack():
        return send_request('http://www.ustack.com')


    # 单元测试 代码 #
    import unittest
    import mock

    class TestClient(unittest.TestCase):

        def test_success_request(self):
            status_code = 200
            success_send = mock.Mock(return_value=status_code)
            with mock.patch('client.send_request', success_send): # 这里解设导入的 client 模块，里面有一个 send_request 函数
                from client import visit_ustack # 这里解设导入的 client 模块，里面有一个 visit_ustack 函数
                self.assertEqual(visit_ustack(), status_code)

        def test_fail_request(self):
            status_code = '404'
            fail_send = mock.Mock(return_value=status_code)
            with mock.patch('client.send_request', fail_send):
                from client import visit_ustack
                self.assertEqual(visit_ustack(), status_code)

    # 这个测试类和我们刚才写的第一个测试类一样，包含两个测试，只不过这次不是显示创建一个 mock 对象并且进行替换，而是使用了 patch 函数（作为上下文管理器使用）。


  ### patch.object 函数 用法 ###
    # patch.object 和 patch 的效果是一样的，只不过用法有点不同。
    # 同样是上面这个例子，换成patch.object的话是这样的：

    def test_fail_request(self):
        status_code = 404
        fail_send = mock.Mock(return_value=status_code)
        with mock.patch.object(client, 'send_request', fail_send):
            from client import visit_ustack
            self.assertEqual(visit_ustack(), status_code)

    # 就是替换掉一个对象的指定名称的属性，用法和 setattr 类似。


  ### patch.object 函数 用法2 ###
    # 使用到类上面
    import requests
    import unittest
    import mock

    class Client():

        def send_request(self, url):
            r = requests.get(url)
            return r.status_code

        def visit_ustack(self):
            return self.send_request('http://www.ustack.com')

    class TestClient(unittest.TestCase):

        def test_success_request(self):
            status_code = 200
            success_send = mock.Mock(return_value=status_code)
            with mock.patch.object(Client, 'send_request', success_send):
                client = Client()
                self.assertEqual(client.visit_ustack(), status_code)

        def test_fail_request(self):
            status_code = 404
            fail_send = mock.Mock(return_value=status_code)
            client = Client()
            with mock.patch.object(Client, 'send_request', fail_send):
                self.assertEqual(client.visit_ustack(), status_code)



综合示例
  ### 修改 http 请求 ###

    # 被测试的代码
    import json
    import time
    import urllib2
    import logging

    logger = logging.getLogger()
    ERROR_REPEAT_TIMES = 3 # 请求出错时的重试次数
    HOST_WARN_TIME = 3 # 请求超时警告时间，单位：秒

    def http_send(url, data=None, headers=None):
        """发送 http 请求，并获取返回值(请求出错时会自动重试，请求超过警告时间则记录警告日志)
        :return: 请求返回的结果
        """
        req = urllib2.Request(url, headers=headers or {})
        if data is not None:
            req.add_header("Content-Type", "application/json")
            data = data if isinstance(data, basestring) else json.dumps(data)
            req.add_data(data)
        e = None
        repeat_time = ERROR_REPEAT_TIMES
        while repeat_time >= 0:
            try:
                start_time = time.time()
                resp = urllib2.urlopen(req)
                content = resp.read()
                use_time = time.time() - start_time
                # 输出日志
                if HOST_WARN_TIME and use_time >= HOST_WARN_TIME:
                    logger.warn(u'请求adminweb服务超时，耗时:%.4f秒，url-->%s， 参数-->%s 返回-->%s', use_time, url, data, content)
                else:
                    logger.debug(u"请求adminweb服务耗时:%.4f秒, url-->%s， 参数-->%s 返回-->%s", use_time, url, data, content)
                return content
            except Exception,e:
                repeat_time -= 1
                logger.error(u'请求adminweb服务失败：%s', e, exc_info=True)
        else:
            raise e or RuntimeError(u'请求adminweb服务失败，url：%s，参数：%s' % (url, data))


    # 单元测试
    from mock import Mock
    import urllib2
    import logging
    import unittest

    class TestClient(unittest.TestCase):

        def test_http_send(self):
            global urllib2
            _orig_url2 = urllib2
            mockClass = Mock(spec = urllib2)
            urllib2 = mockClass
            mockClass.urlopen.side_effect = StandardError

            has_error = False
            try:
                # 随意写一个不存在的地址，测试出错重试
                http_send('http://127.0.1.2:51234/none')
            except Exception,e:
                has_error = True # 上面程序要求必须报错
            assert has_error
            assert mockClass.Request.call_count == 1
            assert mockClass.urlopen.call_count == 4
            logging.info(u'上面的出错日志，是正常打印，说明测试通过。。。')
            # 还原
            urllib2 = _orig_url2

    if __name__ == "__main__":
        unittest.main()


