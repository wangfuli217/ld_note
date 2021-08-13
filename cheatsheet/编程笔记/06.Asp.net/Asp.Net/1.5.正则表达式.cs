
1. 正则表达式替换
    using System.Text.RegularExpressions;
    string str = "abc123asd+55<div class='vvv'>haha</div>";
    // 替换“>”为“&gt;”(下面的 $1 是保存正则里面括号的内容，作为替位符)
    str = Regex.Replace(str, @"\s*(>?[^<]*?)>", "$1&gt;");

