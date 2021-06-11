
附录F：
2.内建过滤器参考

add
    参数与被处理数据相加的结果.
    例如: {{ value|add:"5" }}   # 可返回数值相加的结果；也可返回字符串相加的结果。

addslashes
    给特殊字符添加斜线(转义). 举例,要将一个字符串传递给 JavaScript 时。
    例如:  {{ string|addslashes }}

capfirst
    将字符串的首字母大写
    例如:  {{ string|capfirst }}

center
    在一个给定的长度让字符串居中
    例如:  {{ string|center:"50" }}

cut
    把给定字符串中包含的所有参数值删除掉。
    例如:  {{ string|cut:"spam" }}

date
    把一个date类型按照给定的格式输出（与”now”标签用法一样）。
    例如:  {{ value|date:"F j, Y" }}

default
    如果变量不存在，使用默认值；实际上是变量为任何逻辑非的时候都显示默认值，如'', 0, False 等都显示默认值
    例如:  {{ value|default:"(N/A)" }}

default_if_none
    如果变量值为 None, 使用默认值；比 default 过滤器更严格，仅当变量为 None 时才显示默认值。
    例如:  {{ value|default_if_none:"(N/A)" }}

dictsort
    接受一个字典列表,返回按给定参数的属性排序后的列表.
    例如:  {{ list|dictsort:"foo" }}

dictsortreversed
    接受一个字典列表,返回按给定参数的属性逆序排序后的列表
    例子: {{ list|dictsortreversed:"foo" }}

divisibleby
    如果值能够被给定的参数整除的话，返回“True”。
    例如:
        {% if value|divisibleby:"2" %}  # value 需要是一个可以 int(value) 为数值的变量,否则出错
            Even!
        {% else %}
            Odd!
        {% endif %}

escape
    按照以下的规则，转义一个HTML字符串：
        "&" to "&amp;"
        < to "&lt;"
        > to "&gt;"
        '"' (double quote) to '&quot;'
        "'" (single quote) to '&#39;'
    例如:  {{ string|escape }}


filesizeformat
    将值格式化为 ‘可读性好的’ 文件大小(比如 ‘13 KB’, ‘4.1 MB’, ‘102bytes’ 等等).
    例如: {{ value|filesizeformat }}


first
    返回列表中的第一个元素.
    例如:  {{ list|first }}

fix_ampersands
    将 & 符号替换为 &amp;
    例如:  {{ string|fix_ampersands }}


floatformat
    默认时将一个浮点数四舍五入到小数点后1位 ——如果根本没有小数,小数部分不会显示；即默认参数是“-1”
      36.123 转成 36.1；   36.15 转成 36.2；    36 转成 36

    使用正整数参数时，会使用零来补足小数：
      {{ value|floatformat:"3" }}  输出的结果是: 36.1234 转成 36.123；   36 转成 36.000
    使用负整数做参数时，没有小数则不显示小数：
      {{ value|floatformat:"-3" }}  输出的结果是: 36.1234 转成 36.123；   36 转成 36
      {{ 6.00|floatformat:-3 }}   输出的结果是: 6

    例如:  {{ value|floatformat }}  {{ value|floatformat:"2" }}


get_digit
    提供一个完整的数, 返回该数中被请求的数字,其中 1 是最右边的数, 2 是从右边数第二个数字等等.
    若输入值非法(若输入或参数不是整数, 或者参数小于1)则返回其原始值. 否则输出就总是整数. 必须有参数，否则报错。

    例如:
        {{ 6.01|get_digit:'1' }}   显示: 6
        {{ 601|get_digit:2 }}      显示: 0
        {{ 601.3|get_digit:1 }}    显示: 1
        {{ 601|get_digit:0 }}      显示: 601

join
    用一个字符串将一个列表连接起来,类似 Python 的 str.join(list).
    例子:
        value = [1,2,3] 时,  {{ value|join:", " }}  显示为: 1, 2, 3
        {{ 'abc'|join:", " }}  显示为:  a, b, c

length
    返回对象的长度
    例子:
        value = [1,2,3] 时,  {{ value|length }}  显示为: 3
        {{ 'abcd'|length }}  显示为:  4


length_is
    若值的长度与参数相等,返回 True, 否则返回 False.
    例子:
        {% if list|length_is:"3" %}
            ...
        {% endif %}


linebreaks
    把换行符转换成<p>和<br />标签。
    例子:
        {{ 'abc'|linebreaks }}  显示为: <p>abc</p>
        若 value = 'fg\nfsd'  则 {{ value|linebreaks }}  显示为:  <p>fg<br />fsd</p>


linebreaksbr
    把每个换行转换为<br />标签
    例子: 若 value = 'fg\nfsd'  则 {{ value|linebreaks }}  显示为:  fg<br />fsd


linenumbers
    带行号显示文本
        例子:  value = 'fg\nfsd'  则 {{ value|linenumbers }}  显示为:  1. fg 2. fsd


ljust
    在给定宽度的域内将文本左对齐.
    例子: {{ string|ljust:"50" }}


lower
    把一个给定的字符串转换成小写。
    例子: {{ string|lower }}


make_list
    将值转化为一个列表.对一个整数,它是一个数字的列表.对一个字符串,这是一个字符的列表(实际上，数字也会被当成字符串处理)
    例子:
        {% for i in 56789.21|make_list %}
            {{ i }}<br/>
        {% endfor %}
        显示出: 5<br/>6<br/>7<br/>8<br/>9<br/>.<br/>2<br/>1<br/>


phone2numeric
    将一个电话号码(可能包含字母)转化等价的数字值.比如: ‘800-COLLECT’ 将被转化为 ‘800-2655328’.
    输入不一定非是一个合法号码. 它可以转化任意字符串.(字母的转换没什么规律)
    例子:
        {{ string|phone2numeric }}


pluralize
    如果值不是 1 的话返回 's' 用于 '1 vote' vs. '2 votes' 这种场合

    例子:
        The list has {{ list|length }} item{{ list|pluralize }}.
        如果 list 的 length 是0或者1，则 {{ list|pluralize }} 返回空， length 是2或以上，则返回's'

        The list has item{{ 1|pluralize }}.  可以直接用于数字，当数字比2小,则不返回任何内容
        The list has item{{ '2'|pluralize }}.  当数字大于等于2时,则返回's'
        The list has item{{ '2'|pluralize:"es" }}.  当数字大于等于2时,则返回指定的内容，如'es'
        The list has item{{ '1'|pluralize:"y,ies" }}.  当数字比2小时,则返回指定的内容的第一个，如'y'
        The list has item{{ '2'|pluralize:"y,ies" }}.  当数字大于等于2时,则返回指定的内容的第二个，如'ies'


pprint
    pprint.pprint 和一个封装器 ——仅用于调试.
    例子:
        {{ object|pprint }}
        now = datetime.datetime.now()  {{ now|pprint }} 显示: datetime.datetime(2011, 5, 5, 17, 6, 25, 838000)


random
    返回随机的从列表中返回一个元素
    例子:
        {{ list|random }}


removetags
    从输出中删除单空格分隔的 [X]HTML标签 列表
    例子:
        {{ string|removetags:"br p div" }}


rjust
    在给定宽度的域内将文本右对齐.
    例子:
        {{ string|rjust:"50" }}


safe
    不转码输出，页面会自动进行html转码来输出，如果需要输出html内容则需要用
        {{ page.html|safe }} # 让内容原样输出到页面上，比如有“<div>”这样的内容，直接输出会是“&lt;div&gt;”


slice
    返回一个列表的片段
    例子:
        {{ some_list|slice:":2" }}


slugify
    转化为小写, 移去非单词字符(字母数字和下划线),将空白转化为连字符,去除前后空白.
    例子:
        {{ string|slugify }}


stringformat
    根据给定参数(一个格式字符串)格式化一个变量, 这个格式字符串使用 Python 字符串格式化语法, 例外之处是 “%” 运算符被省略.
    例子:
        {{ number|stringformat:"02i" }}


striptags
    过滤掉[X]HTML标签.
    例子: {{ string|striptags }}


time
    按指定的样式（样式定义同now标签）来格式化一个时间对象。日期格式参考内建标签的 now
    例子: {{ value|time:"P" }}


timesince
    格式化一个日期,这个日期是从给定日期到现在的天数和小时数(比如: “4 days, 6 hours”).

    接受一个可选的参数，该参数是一个包含比较日期的变量（该参数默认值是 now).
    举例来说， 如果 blog_date 是一个日期实例表示 2006-06-01 午夜， 而 comment_date 是一个日期实例表示 2006-06-01 早上8点，那么 {{ comment_date|timesince:blog_date }} 将返回 “8 hours”.

    例子:
        now1 = datetime.datetime(2005, 3, 11)
        now2 = datetime.datetime(2005, 2, 16)
        {{ now2|timesince }}         显示如: 6 years, 2 months
        {{ now2|timesince:now1 }}    显示: 3 weeks, 2 days
        {{ now1|timesince:now2 }}    显示: 0 minutes


timeuntil
    类似 timesince, 只是它比较当前时间直到给定日期时间。举例来说，如果今天是 2006-06-01 而 conference_date 是 2006-06-29, 那么 {{ conference_date|timeuntil }} 将返回 “28 days”.
    接受一个可选的参数，该参数是一个包含比较日期的变量（该参数默认值是 now). 举例来说， 如果 from_date 是一个日期实例表示 2006-06-22， 那么 {{ conference_date|timeuntil:from_date }} 会返回 “7 days”.

    例子:
        now1 = datetime.datetime(2005, 3, 11)
        now2 = datetime.datetime(2005, 2, 16)
        {{ now1|timeuntil:now2 }}  显示: 3 weeks, 2 days
        {{ now2|timeuntil:now1 }}  显示: 0 minutes


title
    按标题格式转化一个字符串
    例子:    {{ string|titlecase }}


truncatewords
    将一个字符串截短为指定数目的单词.(是按单词数量来截取，不是字母数量；中文不算)
    例子:    {{ string|truncatewords:"15" }}


truncatewords_html
    例子:    {{ string|truncatewords_html:"15" }}
    类似 truncatewords, 只是忽略 html 标签
    Similar to truncatewords , except that it is aware of HTML tags. Any tags that are opened in the string and not closed before the truncation point are closed immediately after the truncation.
    This is less efficient than truncatewords , so it should be used only when it is being passed HTML text.


unordered_list
    递归的接受一个自嵌套的列表并返回一个HTML无序列表(此列表可不是pythob语义中的列表) — 只是没有开始和结束的<ul>标签

    例子:
        如果 list = ['States', [['Kansas', [['Lawrence', []], ['Topeka', []]]], ['Illinois', []]]]
        那么
        <ul>
            {{ list|unordered_list }}
        </ul>
        就会返回:
        <ul>
            <li>States
            <ul>
                    <li>Kansas
                    <ul>
                            <li>Lawrence</li>
                            <li>Topeka</li>
                    </ul>
                    </li>
                    <li>Illinois</li>
            </ul>
            </li>
        </ul>


upper
    将一个字符串全部字母改为大写。
    例子：    {{ string|upper }}


urlencode
    转义该值以用于 URL.(会把中文、冒号、问号等转成 URL 编码)
    例子：  <a href="{{ link|urlencode }}">linkage</a>


urlize
    将URLs由纯文本变为可点击的链接。
    例子：  {{ string|urlize }}
        {{ "hahah http://localhost/ ddddddddddddddddd"|urlize }}
        显示成: hahah <a href="http://localhost/" rel="nofollow">http://localhost/</a> ddddddddddddddddd


urlizetrunc
    将URLs变为可点击的链接，按给定字母限截短URLs。
    例子：  {{ string|urlizetrunc:"30" }}
        {{ "hahah http://localhost/ ddddddddddddddddd"|urlizetrunc:"15" }}
        显示成: hahah <a href="http://localhost/" rel="nofollow">http://local...</a> ddddddddddddddddd


wordcount
    返回单词数。(是单词的数量，不是字母数量)
    例如：  {{ string|wordcount }}
        {{ "hahah http://localhost/ ddddddddddddddddd"|wordcount }}  显示: 3


wordwrap
    在指定长度将文字换行。
    例如：  {{ string|wordwrap:"75" }}
        {{ "hahah http://localhost/ ddddddddddddddddd"|wordwrap:3 }}
        显示:
    hahah
    http://localhost/
    ddddddddddddddddd


yesno
    提供一个字符串参数对应着 true, false 和 (可选的) None, 根据被处理的值返回相应的字符串:
    例如：    {{ boolean|yesno:"Yes,No,Perhaps" }}

    yesno过滤器示例
    值       参数            输出
    True   "yeah,no,maybe"   yeah
    False  "yeah,no,maybe"   no
    None   "yeah,no,maybe"   maybe
    None   "yeah,no" "no"    (如果不存在 None 的映射，将 None 变为 False)
