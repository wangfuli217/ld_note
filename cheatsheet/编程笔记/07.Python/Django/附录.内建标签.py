
附录F：
1.内建标签参考

block
    定义一个能被子模板覆盖的区块。如：
        <title>{% block title %}{% endblock %}</title>
        <body>
            <h1>My helpful timestamp site</h1>
            {% block content %}{% endblock %}
            {% block footer %} {# 如果有输入这个模板，则使用输入的，没有则使用这里定义的内容 #}
              <hr><p>Thanks for visiting my site.</p>
            {% endblock %}
        </body>


comment 注释
    模板引擎会忽略掉 {% comment %} 和 {% endcomment %} 之间的所有内容。如：
        {# dsfsfsdfsdfsdfsd #}  # 单行注释
        {% comment %}  dsfsfsdfsdfsdfsd {% endcomment %}  # 多行注释


cycle 轮流使用标签给出的字符串列表中的值。
    在一个循环内，轮流使用给定的字符串列表元素：
        {% for o in some_list %}
            <tr class="{% cycle row1,row2 %}">
                ...
            </tr>
        {% endfor %}

    在循环外，在你第一次调用时，给这些字符串值定义一个不重复的名字，以后每次只需使用这个名字就行了：
        <tr class="{% cycle row1,row2,row3 as rowcolors %}">...</tr>
        <tr class="{% cycle rowcolors %}">...</tr>
        <tr class="{% cycle rowcolors %}">...</tr>

    你可以使用任意数量的用逗号分隔的值。注意不要在值与值之间有空格，只是一个逗号。


debug
    输出完整的调试信息，包括当前的上下文及导入的模块信息。如：
    {% debug %}  用查看源码来看，可以看到得更好点


extends 扩展
    标记当前模板扩展一个父模板。
    这个标签有两种用法：
    {% extends "base.html" %}  (带引号) 直接使用要扩展的父模板的名字 "base.html"
    {% extends variable %} 用变量 variable 的值来指定父模板。如果变量是一个字符串，Django会把字符串的值当作父模板的文件名。如果变量是一个 Template 对象，Django会把这个对象当作父模板。


filter
    通过可变过滤器过滤变量的内容。
    过滤器也可以相互传输，它们也可以有参数，就像变量的语法一样。如：
        {% filter escape|lower %}
            This text will be HTML-escaped, and will appear in all lowercase.
        {% endfilter %}


firstof
    输出传入的第一个不是 False 的变量，如果被传递变量都为 False ，则什么也不输出。如：
        {% firstof var1 var2 var3 %}
    这等同于如下内容：
        {% if var1 %}
            {{ var1 }}
        {% else %}{% if var2 %}
            {{ var2 }}
        {% else %}{% if var3 %}
            {{ var3 }}
        {% endif %}{% endif %}{% endif %}


for
    遍历列表中的每一元素。例如显示一个指定的运动员的序列 athlete_list ：
        <ul>
        {% for athlete in athlete_list %}
            <li>{{ athlete.name }}</li>
        {% endfor %}
        </ul>

    逆向遍历一个列表 {% for obj in list reversed %}

    {% for %}循环中的可用变量
    forloop.counter         当前循环次数（索引最小为1）。
    forloop.counter0        当前循环次数 (索引最小为0)。
    forloop.revcounter      剩余循环次数 (索引最小为1)。
    forloop.revcounter0     剩余循环次数 (索引最小为0)。
    forloop.first           第一次循环时为 True 。
    forloop.last            最后一次循环时为 True 。
    forloop.parentloop      用于嵌套循环，表示当前循环外层的循环。

    系统不支持中断循环(即 break 和 continue)，如果需要中断，可以改变遍历的变量来使得变量只包含你想遍历的值


if
    测试一个变量，若变量为真(即其存在、非空，且不是一个为假的布尔值)，区块中的内容就会被输出：
        {% if athlete_list %}
            Number of athletes: {{ athlete_list|length }}
        {% else %}
            No athletes.
        {% endif %}

    if 标签有可选的 {% else %} 从句，若条件不成立则显示该从句。
    if 语句可使用 and 、 or 和 not 来测试变量或者对给定的变量取反：

        {% if athlete_list and coach_list %}      {# and 用法 #}
            <p>Both athletes and coaches are available.</p>
        {% endif %}
        {% if not athlete_list %}                 {# not 用法 #}
            <p>There are no athletes.</p>
        {% endif %}
        {% if athlete_list or coach_list %}       {# or 用法 #}
            <p>There are some athletes or some coaches.</p>
        {% endif %}
        {% if not athlete_list or coach_list %}   {# not 和 or 一起用, not 的优先级更高 #}
            <p>There are no athletes or there are some coaches.</p>
        {% endif %}
        {% if athlete_list and not coach_list %}  {# not 和 and 一起用, not 的优先级更高 #}
            <p>There are some athletes and absolutely no coaches.</p>
        {% endif %}
        {% if a1 or a2 or a3 or a4 %}             {# 允许多次使用同一个逻辑符号 #}
            <p>There are some a.</p>
        {% endif %}


    不允许 and 和 or 同时出现在一个 if 语句中，因为这样会有逻辑上的问题。例如这样是有语病的：
        {% if athlete_list and coach_list or cheerleader_list %}...{% endif %}
        {# 经测试，这样写是可以的，只不过建议不要这样写，因为逻辑上会混乱 #}

    还可以使用“==”、“>=”、“>”、“<=”、“<”等判断符号，如：
        {% if title|length <= 4 %}title1{% else %}title5{% endif %}


  ifchanged
    检查循环中一个值从最近一次重复其是否改变。
    ifchanged 语句块用于循环中，其作用有两个：

    它会把要渲染的内容与前一次作比较，发生变化时才显示它。例如，下面要显示一个日期列表，只有月份改变时才会显示它：
        <h1>Archive for {{ year }}</h1>
        {% for date in days %}
            {% ifchanged %}<h3>{{ date|date:"F" }}</h3>{% endifchanged %}
            <a href="{{ date|date:"M/d"|lower }}/">{{ date|date:"j" }}</a>
        {% endfor %}

    如果给的是一个变量，就会检查它是否发生改变。
        {% for date in days %}
            {% ifchanged date.date %} {{ date.date }} {% endifchanged %}
            {% ifchanged date.hour date.date %}
                {{ date.hour }}
            {% endifchanged %}
        {% endfor %}

    前面那个例子中日期每次发生变化时就会显示出来，但只有小时和日期都发生变化时才会显示小时。


ifequal
    如果两个参数相等，就输出该区块的内容。如：
        {% ifequal user.id comment.user_id %}
            ...
        {% endifequal %}

    {% else %} 语句是可选的。
    参数也可以是硬编码的字符串(单引号和双引号均可)，所以下面这种写法是正确的：
        {% ifequal user.username "adrian" %}
            ...
        {% endifequal %}

    可以用来比较的参数只限于模板变量或者字符串、数值，但不能检查诸如 True or False 等Python对象是否相等。如果你需要测试某值的真假，可以用 if 标签。
    可以使用 if 标签的“==”比较来代替此标签，如： {% if tt == 'template' %}{{ tt }}{% endif %}

ifnotequal
    和 ifequal 类似，不过它是用来测试两个参数是 不 相等的。


include
    加载一个模板，并用当前上下文对它进行渲染，这是在一个模板中包含其他模板的一种方法。
    模板名可以是一个变量或者是一个硬编码（引号引起来的）的字符串，引号可以是单引号或者双引号。

    如包含 "foo/bar.html" 模板的内容：
        {% include "foo/bar.html" %}

    如包含名字为变量 template_name 指定的模板的内容：
        {% include template_name %}


load
    读入一个自定义的模板库。


now
    根据给定的格式字符串显示当前日期。
    这个标签来源于PHP中的 date() 函数( http://php.net/date )，并使用与其相同的格式语法，但是Django对其做了扩展。

    可用的日期格式字符串
       格式     描述
        a     'a.m.' 或者 'p.m.'(这与PHP中的输出略有不同，因为为了匹配美联社风格，它包含了句点。)。输出如: 'a.m.'
        A     'AM' 或者 'PM' 。输出如:  'AM'
        b     月份，文字式的，三个字母，小写。输出如: 'jan'
        d     一月的第几天，两位数字，带前导零。输出如: '01' 到 '31'
        D     一周的第几天，文字式的，三个字母。输出如: 'Fri'
        f     时间，12小时制的小时和分钟数，如果分钟数为零则不显示。输出如: '1' , '1:30'
        F     月份，文字式的，全名。输出如: 'January'
        g     小时，12小时制，没有前导零。 '1' 到 '12'
        G     小时，24小时制，没有前导零,'0' 到 '23'。输出如: '0', '1', '23'
        h     小时，12小时制。 '01' 到 '12'
        H     小时，24小时制。 '00' 到 '23'
        i     分钟。'00' 到 '59'
        j     一月的第几天，不带前导零。'1' 到 '31'
        l     一周的第几天，文字式的，全名。输出如: 'Friday'
        L     是否为闰年的布尔值。输出如: True 到 False
        m     月份，两位数字，带前导零。'01' 到 '12'
        M     月份，文字式的，三个字母。输出如: 'Jan'
        n     月份，没有前导零。'1' 到 '12'
        N     美联社风格的月份缩写。输出如: 'Jan.' , 'Feb.' , 'March' , 'May'
        O     与格林威治标准时间的时间差(以小时计)。输出如: '+0200'
        P     时间，12小时制的小时分钟数以及a.m./p.m.，分钟数如果为零则不显示，用字符串表示特殊时间点，如 'midnight' 和 'noon' 。
                输出如: '1 a.m.' , '1:30 p.m.' , 'midnight' , 'noon' , '12:30 p.m.'
        r     RFC 822 格式的日期。输出如: 'Thu, 21 Dec 2000 16:01:07 +0200'
        s     秒数，两位数字，带前导零。'00' 到 '59'
        S     英语序数后缀，用于表示一个月的第几天，两个字母。输出如: 'st' , 'nd' , 'rd' 到 'th'
        t     指定月份的天数。28 到 31
        T     本机的时区。输出如: 'EST' , 'MDT'
        w     一周的第几天，数字，带前导零。'0' (Sunday) 到 '6' (Saturday)
        W     ISO-8601 一年中的第几周，一周从星期一开始。输出如: 1 , 23
        y     年份，两位数字。输出如: '99'
        Y     年份，四位数字。输出如: '1999'
        z     一年的第几天。0 到 365
        Z     以秒计的时区偏移量，这个偏移量对于UTC西部时区总是负数，对于UTC东部时区总是正数。 -43200 到 43200

    例：
        It is {% now "jS F Y H:i" %}

    记住，如果你想用一个字符串的原始值的话，你可以用反斜线进行转义。
    下面这个例子中，f被用反斜线转义了，如果不转义的话f就是显示时间的格式字符串。o不用转义，因为它本来就不是一个格式字母。
        It is the {% now "jS o\f F" %}   显示成: “It is the 4th of September”。


regroup
    把一列相似的对象根据某一个共有的属性重新分组。
    要解释清这个复杂的标签，最好来举个例子。比如， people 是包含 Person 对象的一个列表， 这个对象拥有 first_name 、 last_name 和 gender 属性，你想这样显示这个列表：
        * Male:
            * George Bush
            * Bill Clinton
        * Female:
            * Margaret Thatcher
            * Condoleezza Rice
        * Unknown:
            * Pat Smith

    下面这段模板代码就可以完成这个看起来很复杂的任务：
        {% regroup people by gender as grouped %}
        <ul>
        {% for group in grouped %}
            <li>{{ group.grouper }}
            <ul>
                {% for item in group.list %}
                <li>{{ item }}</li>
                {% endfor %}
            </ul>
            </li>
        {% endfor %}
        </ul>

    如你所见， {% regroup %} 构造了一个列表变量，列表中的每个对象都有 grouper 和 list 属性。 grouper 包含分组所依据的属性， list 包含一系列拥有共同的 grouper 属性的对象。这样 grouper 就会是 Male 、 Female 和 Unknown ， list 就是属于这几种性别的人们。

    记住，如果被分组的列表不是按照某一列排好序的话，你就不能用 {% regroup %} 在这一列上进行重新分组！就是说如果人的列表不是按照性别排好序的话，在用它之前就要先对它排序，即：
        {% regroup people|dictsort:"gender" by gender as grouped %}


spaceless
    去除HTML标签之间的空白符号，包括制表符和换行符。例如:
        {% spaceless %}
            <p>
                <a href="foo/">Foo</a>
            </p>
        {% endspaceless %}
    返回结果如下：
        <p><a href="foo/">Foo</a></p>

    仅仅 标签 之间的空白符被删掉，标签和文本之间的空白符是不会被处理的。在下面这个例子中， Hello 两边的空白符是不会被截掉的：
        {% spaceless %}
            <strong>
                Hello
            </strong>
        {% endspaceless %}


ssi
    把一个指定的文件的内容输出到页面上。
    像include标签一样， {% ssi %} 会包含另外一个文件的内容，这个文件必须以绝对路径指明：
        {% ssi /home/html/ljworld.com/includes/right_generic.html %}

    如果指定了可选的parsed参数的话，包含进来的文件的内容会被当作模板代码，并用当前的上下文来渲染：
        {% ssi /home/html/ljworld.com/includes/right_generic.html parsed %}

    注意，如果你要使用 {% ssi %} 的话，为了安全起见，你必须在Django配置文件中定义ALLOWED_INCLUDE_ROOTS。
    大多数情况下 {% include %} 比 {% ssi %} 更好用， {% ssi %} 的存在通常是为了向后兼容。


  templatetag
    输出组成模板标签的语法字符。
    模板系统没有转义的概念，所以要显示一个组成模板标签的字符的话，你必须使用 {% templatetag %} 标签。如：
        {% templatetag openblock %} 输出“{%”

    参数用来标明要显示的字符
        参数              输出
        openblock        {%
        closeblock       %}
        openvariable     {{
        closevariable    }}
        openbrace        {
        closebrace       }
        opencomment      {#
        closecomment     #}


url
    根据所给视图函数和可选参数，返回一个绝对的URL（就是不带域名的URL）。由于没有在模板中对URL进行硬编码，所以这种输出链接的方法没有违反DRY原则。
        {% url path.to.some_view arg1,arg2,name1=value1 %}

    第一个变量是按 package.package.module.function 形式给出的指向一个view函数的路径。那些可选的、用逗号分隔的附加参数被用做URL中的位置和关键词变量。所有URLconf需要的参数都应该是存在的。

    例如，假设你有一个view，app_name.client，它的URLconf包含一个client ID参数。URLconf对应行可能看起来像这样：
        ('^client/(\d+)/$', 'app_name.client')
    如果这个应用的URLconf像下面一样被包含在项目的URLconf里：
        ('^clients/', include('project_name.app_name.urls'))
    那么，在模板中，你可以像这样创建一个指向那个view的link连接：
        {% url app_name.client client.id %}
    模板标签将输出字符串/clients/client/123/


widthratio 宽度的比率
    为了画出长条图，这个标签计算一个给定值相对于最大值的比率，然后将这个比率给定一个常数。如：
        <img src="bar.gif" height="10" width="{% widthratio this_value max_value 100 %}" />
        如果 this_value 是 175，而 max_value 是 200, 这图片的宽度会是 88 pixels (因为 175/200 = 0.875; 0.875 * 100 = 87.5,四舍五入到 88).
