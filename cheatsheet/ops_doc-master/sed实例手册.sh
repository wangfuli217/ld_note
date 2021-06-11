---------------------------------------------------------------------------------
#vi test.txt  文件内容如下：
My name is Liu YiLing.
I am a boy.
I am 23 now(2016-04-23).
I like cooking delicious something.
---------------------------------------------------------------------------------

0.打印行号&打印该行&执行脚本

    e:后跟执行命令    =:打印行号    p:打印该行    -'s/I/Liu YiLing/g':替换

    #sed -e '=' -e 'p' -e 's/I/Liu YiLing/g' test.txt

-------------------------------------------------------------------------
注意，为了使代码清晰，接下来的代码中省略e：后跟执行命令
-------------------------------------------------------------------------

1.匹配&替换--仅仅输出到控制台
    把"I am"替换成"Liu YiLing is" 并输出到控制台  
    #sed 's/I am/Liu YiLing is/g' test.txt
    My name is Liu YiLing.
    Liu YiLing is a boy.
    Liu YiLing is 23 now(2016-04-23).
    I like cooking delicious something.


2.匹配&替换--输出到新文件
    把把"I am"替换成"Liu YiLing is" 并通过重定向输出到newfile.txt中
    #sed 's/I am/Liu YiLing is/g' test.txt>newfile.txt


3.匹配&替换--直接修改文本内容
    -i：指定备份文件的名称

    //替换test.txt的内容，并把替换后的内容，直接写入test.txt中，同时把修改前的test.txt备份到test.txt.bak中
    Linux:
       #sed -i.bak 's/I am/Liu YiLing is/g' test.txt

    MacOs:
       #sed -i '.bak' 's/I am/Liu YiLing is/g' test.txt

       #cat test.txt   //
       My name is Liu YiLing.
       Liu YiLing is a boy.
       Liu YiLing is 23 now(2016-04-23).
       I like cooking delicious something.

       #cat test.txt.bak
       My name is Liu YiLing.
       I am a boy.
       I am 23 now(2016-04-23).
       I like cooking delicious something.
 
 
4.在行头添加内容
    //在每一行的前面添加"%",  ^表示行首
    #sed 's/^/%/g' test.txt
    %My name is Liu YiLing.
    %I am a boy.
    %I am 23 now(2016-04-23).
    %I like cooking delicious something.


5.在行尾添加内容
    //在每一行的行尾添加"---",  $表示行尾
    #sed 's/$/---/g' test.txt
    My name is Liu YiLing.---
    I am a boy.---
    I am 23 now(2016-04-23).---
    I like cooking delicious something.---


6.指定行数
    //把第2，3行的"I"被替换成"Liu YiLing"
    #sed '2,3s/I/Liu YiLing is/g' test.txt
    My name is Liu YiLing.
    Liu YiLing is am a boy.                //第2行的"I"被替换成"Liu YiLing"
    Liu YiLing is am 23 now(2016-04-23).   //第3行的"I"被替换成"Liu YiLing"
    I like cooking delicious something.


7.指定匹配替换的索引

   #cat test2.txt
   a a a a
   a a a a
   a a a a
    
    //只替换每一行的第1个a    
    #sed 's/a/A/1' test2.txt
    A a a a
    A a a a
    A a a a

    
    //只替换每一行的第2个a
    #sed 's/a/A/2' test2.txt   
    a A a a
    a A a a
    a A a a


    //只替换每一行的第三个以后的a替换成A
    #sed 's/a/A/3g' test2.txt   (linux)
    a a A A
    a a A A
    a a A A

    执行奇数行
    #sed '1~2s/a/A/g' test2.txt    执行1，3，5，7行：其中波浪线代表跳跃区间
    A A A A
    a a a a
    A A A A


8.多行匹配
    //1-2行中的第三个及其以后的a替换为A，3-最后一行的每个a都替换为AA
    #sed '1,2s/a/A/3g; 3,$s/a/AA/g' test2.txt
    a a A A
    a a A A
    AA AA AA AA
    AA AA AA AA
    AA AA AA AA


9.使用匹配字符--&代表匹配的字符串

    //对1-2行的所有a替换成["a"]这样的形式
    #sed '1,2s/a/["&"]/g' test2.txt
    ["a"] ["a"] ["a"] ["a"]
    ["a"] ["a"] ["a"] ["a"]
    a a a a
    a a a a
    a a a a


10.使用圆括号做索引匹配
    //1-2行中匹配到This is my ([^,]*\),.*is (.*)替换为--->圆括号1内容:圆括号2内容
    #sed '1,2s/This is my \([^,]*\),.*is \(.*\)/\1:\2/g' test2.txt
    a a a a
    a a a a
    a a a a
    a a a a
    a a a a


#cat test3.txt
the first line
the second line
the third line
the forth line


11.在某一行之前添加行
    //在第一行之前追加一行"the new added line",  i---insert
    #sed "1 i the new added line" test3.txt
    the new added line
    the first line
    the second line
    the third line
    the forth line


12.在某一行之后追加行
    //在第一行之后追加一行，   a---append
    #sed "1 a the new added line" test3.txt
    the first line
    the new added line
    the second line
    the third line
    the forth line

    //在最后一行之后追加一行追加行:$表示最后一行， a---append
    #sed "$ a the new added line" test3.txt
    the first line
    the second line
    the third line
    the forth line
    the new added line

    //找到所有含有"line"的行，并在其后追加行"the new added line"
    #sed "/line/a the new added line" test3.txt
    the first line
    the new added line
    the second line
    the new added line
    the third line
    the new added line
    the forth line
    the new added line


13.删除行
    //删除第2行
    #sed '2d' test3.txt
    the first line
    the third line
    the forth line
    
    //从第二行开始全部删除，2,$表示从2开始到最后一行
    #sed '2,$d' test3.txt
    the first line
    
    //匹配日&&删除行--删除匹配fish的那一行
    #sed '/second/d' test3.txt
    the first line
    the third line
    the forth line
   

14.匹配替换行

    //把含有third的行，全部替换成"replaced line" ,   c:替换
    #sed "/third/c replaced line" test3.txt
    the first line
    the second line
    replaced line
    the forth line

OK,到此刻你是否已经发现，sed其实和正则表达式有很大的关联？

没错，前面所用到的^,$都是正则表达式的一部分


---------------------------------------------------------------------------------
正则表达式：
    ^:开头--如：/^#/ 以#开头的匹配
    $:结尾--如：/}$/ 以}结尾的匹配
    .:任意字符
    [1-5],[a-b]:从1-5或者a-b中的字符
    ?：0或1--如：a? 表示0或1个a    
    +：1或多--如：a+ 表示1或多个a
    *：0或多--如：a* 表示0或多个a
    ^：去除--如：[^a] 表示非a的字符
    {n,m}:n到m--如：a{2,5} 表示2到5个a
    \n：前面n个组合    123\n 表示n个连续的123
    \|：或    123\|234 表示123或者234
例子：    
    [[:digit:]]{4}    匹配任意4位数
    ^[0-9\.]$    匹配任意数字
转义：
    \.,\-,\\,

---------------------------------------------------------------------------------
一个例子：
    #cat test4.txt
    This is what I meant. Understand?

    我们打算把tag外的内容提取出来
    //本质就是把<>里面的内容替换成空
    #sed "s/<[^>]*>//g" test4.txt
    This is what I meant. Understand?