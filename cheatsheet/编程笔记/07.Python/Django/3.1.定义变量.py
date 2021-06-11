
在django模板中定义变量(set variable in django template)

    总有一些情况，你会想在django template中设置临时变量,但是django 对在模板中对临时变量的赋值没有很好的开箱即用的 tag 或者 filter 。
    但是还是能通过一些其他方法实现的：
        1. 利用 django 自带的 with 标签实现
        2. 利用自定义 tag  实现，应该灵活很多.


1.利用 django 自带的 with 标签实现对变量赋值
    好像在django 1.3 之后才支持这种做法

    从context中得到值进行赋值

        {% with total=business.employees.count %}
            {{ total }} employee{{ total|pluralize }}
        {% endwith %}

    当然也可以直接给一个常量

        {% with age=100 %}
            {{ age|add:"2" }}
            ....
        {% endwith %}


2 自定义标签方式现实在django template 中给变量赋值

    # 代码中先定义函数
    from django import template
    register = template.Library()

    class SetVarNode(template.Node):

        def __init__(self, var_name, var_value):
            self.var_name = var_name
            self.var_value = var_value

        def render(self, context):
            try:
                value = template.Variable(self.var_value).resolve(context)
            except template.VariableDoesNotExist:
                value = ""
            context[self.var_name] = value
            return u""

    def set_var(parser, token):
        """
            {% set <var_name>  = <var_value> %}
        """
        parts = token.split_contents()
        if len(parts) < 4:
            raise template.TemplateSyntaxError("'set' tag must be of the form:  {% set <var_name>  = <var_value> %}")
        return SetVarNode(parts[1], parts[3])

    register.tag('set', set_var)


    # 页面调用
    在 template 中应用时,现在模板中load这个标签所在文件。然后用类似如下方式处理
    {% load set_var %}

    {% set a = 3 %}
    {% set b = some_context_variable %}
    {% set c = "some string" %}

    这样就实现了在django 模板中 对变量进行赋值和处理.

