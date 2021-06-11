
风格
    感觉合理的话，就遵循PEP 8。
命名
    变量、函数、方法、包、模块小写，并使用下划线分隔单词（lower_case_with_underscores）
    类、异常首字母大写（CapWords）
    受保护的方法和内部函数单下划线开头（_single_leading_underscore(self, …)）
    私有的方法双下划线开头（__double_leading_underscore(self, …)）
    常量字母全部大写，单词间用下划线分隔（ALL_CAPS_WITH_UNDERSCORES）

一般命名准则
    尽量不要使用只有一个字母的变量名（例如，l，I，O等）。
    例外：在很简短的代码块中，如果变量名的意思可以从上下文明显地看出来。比如下面的例子：
    for e in elements:
        e.mutate()

避免重复变量名，
    正确的做法：
        import audio
        core = audio.Core()
        controller = audio.Controller()

    错误的做法：
        import audio
        core = audio.AudioCore()
        controller = audio.AudioController()

「反向标记」更好，
    正确的做法：
        elements = ...
        elements_active = ...
        elements_defunct = ...
    
    错误的做法：
        elements = ...
        active_elements = ...
        defunct_elements ...

避免使用getter和setter方法，
    正确的做法
        person.age = 42
    
    错误的做法：
        person.set_age(42)

缩进
    用4个空格符——永远别用Tab制表符。
    
模块引用
    引用整个模块，而不是模块中的单个标识符。举个例子，假设一个cantee模块下面，有一个canteen/sessions.py文件，
    正确的做法：
        import canteen
        import canteen.sessions
        from canteen import sessions
    
    错误的做法：
        from canteen import get_user  # Symbol from canteen/__init__.py
        from canteen.sessions import get_session  # Symbol from canteen/sessions.py
    例外：如果第三方代码的文档中明确说明要单个引用。
    理由：避免循环引用。看这里。

把代码引用部分放在文件的顶部，按下面的顺序分成三个部分，每个部分之间空一行。
    系统引用
    第三方引用
    本地引用
    理由：明确显示每个模块的引用来源。
    
文档
    遵循PEP 257提出的文档字符串准则。reStructuredText (reST) 和Sphinx有助于确保文档符合标准。

    对于功能明显的函数，撰写一行文档字符串：
    """Return the pathname of ``foo``."""

    多行文档字符串应包括：
        一行摘要
        *合适的话，请描述使用场景
        参数
        返回数据类型和语义信息，除非返回None
    """Train a model to classify Foos and Bars.
    Usage::
        >>> import klassify
        >>> data = [("green", "foo"), ("orange", "bar")]
        >>> classifier = klassify.train(data)
    :param train_data: A list of tuples of the form ``(color, label)``.
    :rtype: A :class:`Classifier <Classifier>`
    """

注意：
    使用主动词（Return），而不是描述性的单词（Returns）。
    在类的文档字符串中为__init__方法撰写文档。

    class Person(object):
        """A simple representation of a human being.
        :param name: A string, the person's name.
        :param age: An int, the person's age.
        """
        def __init__(self, name, age):
            self.name = name
            self.age = age

关于注释
    尽量少用。与其写很多注释，不如提高代码可读性。通常情况下，短小的方法比注释更有效。
    错误的做法：
        # If the sign is a stop sign
        if sign.color == 'red' and sign.sides == 8:
            stop()
    正确的做法：
        def is_stop_sign(sign):
            return sign.color == 'red' and sign.sides == 8
        if is_stop_sign(sign):
            stop()
    但是的确要写注释时，请牢记：「遵循斯托克与怀特所写的《风格的要素》。」 —— PEP 8
    
每行的长度
    不要过分在意。80到100个字符都是没问题的。

使用括号延续当前行。
    wiki = (
        "The Colt Python is a .357 Magnum caliber revolver formerly manufactured "
        "by Colt's Manufacturing Company of Hartford, Connecticut. It is sometimes "
        'referred to as a "Combat Magnum". It was first introduced in 1955, the '
        "same year as Smith & Wesson's M29 .44 Magnum."
    )

测试
    尽量争取测试全部代码，但也不必执着于覆盖率。
    一般测试准则
    
        使用较长的、描述性的名称。通常情况下，这能避免在测试方法中再写文档。
        测试之间应该是孤立的。不要与真实地数据库或网络进行交互。使用单独的测试数据库，测试完即可销毁，或者是使用模拟对象。
        使用工厂模式，而不是fixture。
        别让不完整的测试通过，否则你就有可能忘记。你应该加上一些占位语句，比如assert False, "TODO: finish me"。
    
    单元测试
        每次聚焦一个很小的功能点。
        运行速度要快，但是速度慢总比不测试好。
        通常，每一个类或模型都应该有一个测试用例类。
        import unittest
        import factories
        class PersonTest(unittest.TestCase):
            def setUp(self):
                self.person = factories.PersonFactory()
            def test_has_age_in_dog_years(self):
                self.assertEqual(self.person.dog_years, self.person.age / 7)

    功能测试
        功能测试是更高层次的测试，更接近最终用户如何与应用交互这一层面。通常用在网络应用与图形应用测试。
        
            按照场景撰写测试。测试用例的测试方法命名应该看上去像场景描述。
            在编写代码之前，通过注释说明具体场景信息。
        import unittest
        class TestAUser(unittest.TestCase):
            def test_can_write_a_blog_post(self):
                # Goes to the her dashboard
                ...
                # Clicks "New Post"
                ...
                # Fills out the post form
                ...
                # Clicks "Submit"
                ...
                # Can see the new post
                ...
        
        请注意，测试用例的类名称和测试方法的名称放在一起，就像是「测试一名用户能否发布博文」。