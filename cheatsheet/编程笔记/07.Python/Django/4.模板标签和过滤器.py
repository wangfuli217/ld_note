
模板标签和过滤器基础
   模板系统使用内建的标签和过滤器
   Django模板系统并不是一个严格意义上的编程语言，所以它并不允许我们执行Python语句

1)if/else
     if 标签计算一个变量值，如果是“ True ”，即它存在、不为空并且不是 False 的 boolean 值
     系统则会显示{% if %}和{% endif %}间的所有内容,
     必须确认使用{% endif %}来关闭{% if %}标签，否则Django触发TemplateSyntaxError
     如：

        {% if today_is_weekend %}
            <p>Welcome to the weekend!</p>
        {% else %}
            <p>Get back to work.</p>
        {% endif %}

    if 标签接受 and, or 或者 not 来检查多个变量值或者否定一个给定的变量，例如:

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

    注：
    django教程上说 if 标签不允许同一标签里同时出现 and 和 or, 否则逻辑容易产生歧义;但经测试这样做是可以的，只不过还没有办法证明他们一起使用时，是 and 还是 or 的优先级更高。
    再者, 不允许使用括号来改变 and, or, not 的优先顺序, 这是测试出来的结果。
    例如下面的标签是不合法的：
        {% if not (athlete_list or coach_list) %}  {# 这写法会抛出异常 #}
        {% if a1 and a2 or a3 %} {# or 和 and 一起用, 经测试可以这样做 #}

    如果想结合 and 和 or 来做高级逻辑，建议使用嵌套的 if 标签
    没有 elif / else if 标签，需使用嵌套的 if 标签来做：
        {% if athlete %}
            {% if coach or cheerleader %}  {# 这相当于 if athlete and (coach or cheerleader) #}
                We have athletes, and either coaches or cheerleaders!
            {% endif %}
        {% else %}
            {% if coach %}  {# 这相当于 else if #}
                <p>Here are the coaches: {{ coach }}.</p>
            {% endif %}
        {% endif %}

     还可以使用“==”、“>=”、“>”、“<=”、“<”等判断符号，如：
        {% if title|length <= 4 %}title1{% else %}title5{% endif %}


2)for 标签
     for 标签允许按顺序遍历一个序列中的各个元素
     Python的 for 语句语法为 for X in Y，X是用来遍历Y的变量
     每次循环模板系统都会渲染{% for %}和{% endfor %}之间的所有内容；标签可以嵌套
     例如，显示给定athlete_list变量来显示athlete列表：
        <ul>
        {% for athlete in athlete_list %}
            <li>{{ athlete.name }}</li>
        {% endfor %}
        </ul>

     在标签里添加 reversed 来反序循环列表：
        {% for athlete in athlete_list reversed %}
            ...
        {% endfor %}

    系统不支持中断循环(即 break 和 continue)，如果需要中断，可以改变遍历的变量来使得变量只包含你想遍历的值

    forloop 模板变量
    for 标签内置了一个 forloop 模板变量，这个变量含有一些属性可以提供给你一些关于循环的信息
    1，forloop.counter     表示循环的次数，它从1开始计数，第一次循环设为1
    2，forloop.counter0    类似于 forloop.counter, 但它是从0开始计数，第一次循环设为0
    3，forloop.revcounter  表示循环中剩下的 items 数量，第一次循环时设为 items 总数，最后一次设为1
    4，forloop.revcounter0 类似于 forloop.revcounter, 但它是表示的数量少一个，即最后一次循环时设为0
    5，forloop.first       当第一次循环时值为 True, 在特别情况下很有用
    6，forloop.last        当最后一次循环时值为 True
    7，forloop.parentloop  在嵌套循环中表示父循环的 forloop
    例如:

        {% for item in todo_list %}
            {% if forloop.first %}<li class="first">{% else %}<li>{% endif %}
                <p>{{ forloop.counter }}: {{ item }}</p>
            </li>
        {% endfor %}

        {# forloop.parentloop 用法 #}
        {% for country in countries %}
            <table>
            {% for city in country.city_list %}
                <tr>
                    <td>Country[ {{ forloop.parentloop.counter }} ]</td>
                    <td>City[ {{ forloop.counter }} ]</td>
                    <td>{{ city }}</td>
                </tr>
            {% endfor %}
            </table>
        {% endfor %}

    富有魔力的forloop变量只能在循环中得到，当模板解析器到达{% endfor %}时 forloop 就消失了
    如果模板的 context 已经包含一个叫 forloop 的变量，Django会在 for 标签的块中覆盖你定义的 forloop 变量的值,
    在其他非循环的地方，你定义的 forloop 变量仍然可用
    建议模板变量不要使用 forloop, 如果需要这样用，可以在循环中使用 forloop.parentloop

3)ifequal / ifnotequal
     在模板语言里比较两个值并且在他们一致的时候显示一些内容，Django提供了 ifequal 和 ifnotequal 标签。
     ifequal 标签比较两个值，如果相等，则显示{% ifequal %}和{% endifequal %}之间的所有内容
     ifnotequal 标签 与 ifequal 对应，当两个值不相等时显示。
     与 if 标签一样，ifequal 和 ifnotequal标签也支持 else 标签。
     参数可以是硬编码的 string(单引号和双引号均可),也可以是数字,但不能是 True 或者 False 。
     其它的参数类型，如字典、列表或 boolean 不能硬编码在 ifequal 和 ifnotequal标签里面。
     如果你需要测试某个变量是 True 或 False, 用 if 标签即可；用 ifequal标签与 1, 0 比较也可以。
     只能两个参数,不能多也不能少。

        {# 如果 a1 == a2 则显示 #}
        {% ifequal a1 a2 %}
            <h1>equal!</h1>
        {% else %}
            <h1>not equal!</h1>
        {% endifequal %}

        {# 如果 a1 != a2 则显示 #}
        {% ifnotequal a1 a2 %}
            <h1>not equal!</h1>
        {% endifnotequal %}

        {# 如果 a1 == 'sitenews' 则显示 #}
        {% ifequal a1 'sitenews' %}
            <h1>Site News</h1>
        {% endifequal %}

        {# 如果 a2 == 55.23 则显示 #}
        {% ifequal a2 55.23 %}
            <h1>Community</h1>
        {% endifequal %}

     可以使用 if 标签的“==”比较来代替此标签，如： {% if tt == 'template1.html' %}{{ tt }}{% endif %}

4)comment 标签
    注释用，需要多行注释时更好用
    {% comment %}
        {% if client and perms.auth.clients_billing_verify %}
          ....
        {% endif %}
    {% endcomment %}

5)过滤器
     本章前面提到，模板过滤器是变量显示前转换它们的值的方式，看起来像下面这样：
        {{ name|lower }}   # 这将显示通过 lower 过滤器过滤后{{ name }}变量的值，它将文本转换成小写。

     使用(|)管道来申请一个过滤器
     过滤器可以串成链，即一个过滤器的结果可以传向下一个
     下面是escape文本内容然后把换行转换成p标签的习惯用法：
        {{ my_text|escape|linebreaks }}

    有些过滤器需要参数，过滤器参数一直使用双引号, 需要参数的过滤器的样子：
        {{ bio|truncatewords:"30" }} # 这将显示bio变量的前30个字

    下面是一些最重要的过滤器：
    1, addslashed: 在任何后斜线，单引号，双引号前添加一个后斜线
       当你把一些文本输出到一个JavaScript字符串时这会十分有用
    2, date: 根据一个格式化string参数来格式化date或datetime对象，例如:
        {{ pub_date|date:"F j, Y" }}
    3, escape: 避免给定的string里出现“&”符，引号，尖括号
       当你处理用户提交的数据和确认合法的XML和XHTML数据时这将很有用
       escape 将作如下的一些转换：
        Converts & to &amp;
        Converts < to &lt;
        Converts > to &gt;
        Converts "(双引号) to &quot;
        Converts '(单引号) to &#39;
    4, length: 返回值的长度，你可以在一个list或string上做此操作
       或者在任何知道怎样决定自己的长度的Python对象上做此操作(即有一个 __len__()方法的对象)


6)过滤器列表
    {{ 123|add:"5" }} 给value加上一个数值
    {{ 123|add:-10 }} 给value减去一个数值
    {%  widthratio 5 1 100 %} 表示：5/1 *100，返回500，widthratio需要三个参数，它会使用 参数1/参数2*参数3，用来进行乘法、除法运算
    {{ "AB'CD"|addslashes }} 单引号加上转义号，一般用于输出到javascript中
    {{ "abcd"|capfirst }} 第一个字母大写
    {{ "abcd"|center:"50" }} 输出指定长度的字符串，并把值对中
    {{ "123spam456spam789"|cut:"spam" }} 查找删除指定字符串
    {{ value|date:"Y-m-d" }} 格式化日期
    {{ value|default:"(N/A)" }} 值不存在，使用指定值
    {{ value|default_if_none:"(N/A)" }} 值是None，使用指定值
    {{ 列表变量|dictsort:"数字" }} 排序从小到大
    {{ 列表变量|dictsortreversed:"数字" }} 排序从大到小
    {% if 92|pisibleby:"2" %} 判断是否整除指定数字
    {{ string|escape }} 转换为html实体
    {{ 21984124|filesizeformat }} 以1024为基数，计算最大值，保留1位小数，增加可读性(显示 1K, 12M, 2.3G 等文件大小)
    {{ list|first }} 返回列表第一个元素
    {{ "ik23hr&jqwh"|fix_ampersands }} &转为&amp;
    {{ 13.414121241|floatformat }} 保留1位小数，可为负数，几种形式
    {{ 13.414121241|floatformat:"2" }} 保留2位小数
    {{ 23456 |get_digit:"1" }} 从个位数开始截取指定位置的1个数字
    {{ list|join:", " }} 用指定分隔符连接列表
    {{ list|length }} 返回列表个数
    {% if 列表|length_is:"3" %} 列表个数是否指定数值
    {{ "ABCD"|linebreaks }} 用新行用<p> 、 <br /> 标记包裹
    {{ "ABCD"|linebreaksbr }} 用新行用<br /> 标记包裹
    {{ 变量|linenumbers }} 为变量中每一行加上行号
    {{ "abcd"|ljust:"50" }} 把字符串在指定宽度中对左，其它用空格填充
    {{ "ABCD"|lower }} 小写
    {% for i in "1abc1"|make_list %}ABCDE,{% endfor %} 把字符串或数字的字符个数作为一个列表
    {{ "abcdefghijklmnopqrstuvwxyz"|phone2numeric }} 把字符转为可以对应的数字？？
    {{ 列表或数字|pluralize }} 单词的复数形式，如列表字符串个数大于1，返回s，否则返回空串
    {{ 列表或数字|pluralize:"es" }} 指定es
    {{ 列表或数字|pluralize:"y,ies" }} 指定ies替换为y
    {{ object|pprint }} 显示一个对象的值
    {{ 列表|random }} 返回列表的随机一项
    {{ string|removetags:"br p p" }} 删除字符串中指定html标记
    {{ string|rjust:"50" }} 把字符串在指定宽度中对右，其它用空格填充
    {{ 列表|slice:":2" }} 切片
    {{ string|slugify }} 字符串中留下减号和下划线，其它符号删除，空格用减号替换
    {{ 3|stringformat:"02i" }} 字符串格式，使用Python的字符串格式语法
    {{ "E<A>A</A>B<C>C</C>D"|striptags }} 剥去[X]HTML语法标记
    {{ 时间变量|time:"P" }} 日期的时间部分格式
    {{ datetime|timesince }} 给定日期到现在过去了多少时间
    {{ datetime|timesince:"other_datetime" }} 两日期间过去了多少时间
    {{ datetime|timeuntil }} 给定日期到现在过去了多少时间，与上面的区别在于2日期的前后位置。
    {{ datetime|timeuntil:"other_datetime" }} 两日期间过去了多少时间
    {{ "abdsadf"|title }} 首字母大写
    {{ "A B C D E F"|truncatewords:"3" }} 截取指定个数的单词
    {{ "<a>1<a>1<a>1</a></a></a>22<a>1</a>"|truncatewords_html:"2" }} 截取指定个数的html标记，并补完整
    <ul>{{ list|unordered_list }}</ul> 多重嵌套列表展现为html的无序列表
    {{ string|upper }} 全部大写
    <a href="{{ link|urlencode }}">linkage</a> url编码
    {{ string|urlize }} 将URLs由纯文本变为可点击的链接。
    {{ string|urlizetrunc:"30" }} 同上，多个截取字符数。
    {{ "B C D E F"|wordcount }} 单词数
    {{ "a b c d e f g h i j k"|wordwrap:"5" }} 每指定数量的字符就插入回车符
    {{ boolean|yesno:"Yes,No,Perhaps" }} 对三种值的返回字符串，对应是 非空,空,None

