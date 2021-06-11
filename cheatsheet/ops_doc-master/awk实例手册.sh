函数名 	            说明
atan2( y, x )       返回 y/x 的反正切。
cos( x )            返回 x 的余弦；x 是弧度。
sin( x )            返回 x 的正弦；x 是弧度。
exp( x )            返回 x 幂函数。
log( x )            返回 x 的自然对数。
sqrt( x )           返回 x 平方根。
int( x )            返回 x 的截断至整数的值。
rand( )             返回任意数字 n，其中 0 <= n < 1。
srand( [Expr] )     将 rand 函数的种子值设置为 Expr 参数的值，或如果省略 Expr 参数则使用某天的时间。返回先前的种子值。

函数                                    说明
gsub( Ere, Repl, [ In ] )               除了正则表达式所有具体值被替代这点，它和 sub 函数完全一样地执行，。
sub( Ere, Repl, [ In ] )                用 Repl 参数指定的字符串替换 In 参数指定的字符串中的由 Ere 参数指定的扩展正则表达式的第一个具体值。sub 函数返回替换的数量。出现在 Repl 参数指定的字符串中的 &（和符号）由 In 参数指定的与 Ere 参数的指定的扩展正则表达式匹配的字符串替换。如果未指定 In 参数，缺省值是整个记录（$0 记录变量）。
index( String1, String2 )               在由 String1 参数指定的字符串（其中有出现 String2 指定的参数）中，返回位置，从 1 开始编号。如果 String2 参数不在 String1 参数中出现，则返回 0（零）。
length [(String)]                       返回 String 参数指定的字符串的长度（字符形式）。如果未给出 String 参数，则返回整个记录的长度（$0 记录变量）。
blength [(String)]                      返回 String 参数指定的字符串的长度（以字节为单位）。如果未给出 String 参数，则返回整个记录的长度（$0 记录变量）。
substr( String, M, [ N ] )              返回具有 N 参数指定的字符数量子串。子串从 String 参数指定的字符串取得，其字符以 M 参数指定的位置开始。M 参数指定为将 String 参数中的第一个字符作为编号 1。如果未指定 N 参数，则子串的长度将是 M 参数指定的位置到 String 参数的末尾 的长度。
match( String, Ere )                    在 String 参数指定的字符串（Ere 参数指定的扩展正则表达式出现在其中）中返回位置（字符形式），从 1 开始编号，或如果 Ere 参数不出现，则返回 0（零）。RSTART 特殊变量设置为返回值。RLENGTH 特殊变量设置为匹配的字符串的长度，或如果未找到任何匹配，则设置为 -1（负一）。
split( String, A, [Ere] )               将 String 参数指定的参数分割为数组元素 A[1], A[2], . . ., A[n]，并返回 n 变量的值。此分隔可以通过 Ere 参数指定的扩展正则表达式进行，或用当前字段分隔符（FS 特殊变量）来进行（如果没有给出 Ere 参数）。除非上下文指明特定的元素还应具有一个数字值，否则 A 数组中的元素用字符串值来创建。
tolower( String )                       返回 String 参数指定的字符串，字符串中每个大写字符将更改为小写。大写和小写的映射由当前语言环境的 LC_CTYPE 范畴定义。
toupper( String )                       返回 String 参数指定的字符串，字符串中每个小写字符将更改为大写。大写和小写的映射由当前语言环境的 LC_CTYPE 范畴定义。
sprintf(Format, Expr, Expr, . . . )     根据 Format 参数指定的 printf 子例程格式字符串来格式化 Expr 参数指定的表达式并返回最后生成的字符串。

close( Expression )                     用同一个带字符串值的 Expression 参数来关闭由 print 或 printf 语句打开的或调用 getline 函数打开的文件或管道。如果文件或管道成功关闭，则返回 0；其它情况下返回非零值。如果打算写一个文件，并稍后在同一个程序中读取文件，则 close 语句是必需的。
system(Command )                        执行 Command 参数指定的命令，并返回退出状态。等同于 system 子例程。
Expression | getline [ Variable ]       从来自 Expression 参数指定的命令的输出中通过管道传送的流中读取一个输入记录，并将该记录的值指定给 Variable 参数指定的变量。如果当前未打开将 Expression 参数的值作为其命令名称的流，则创建流。创建的流等同于调用 popen 子例程，此时 Command 参数取 Expression 参数的值且 Mode 参数设置为一个是 r 的值。只要流保留打开且 Expression 参数求得同一个字符串，则对 getline 函数的每次后续调用读取另一个记录。如果未指定 Variable 参数，则 $0 记录变量和 NF 特殊变量设置为从流读取的记录。
getline [ Variable ] < Expression       从 Expression 参数指定的文件读取输入的下一个记录，并将 Variable 参数指定的变量设置为该记录的值。只要流保留打开且 Expression 参数对同一个字符串求值，则对 getline 函数的每次后续调用读取另一个记录。如果未指定 Variable 参数，则 $0 记录变量和 NF 特殊变量设置为从流读取的记录。
getline [ Variable ]                    将 Variable 参数指定的变量设置为从当前输入文件读取的下一个输入记录。如果未指定 Variable 参数，则 $0 记录变量设置为该记录的值，还将设置 NF、NR 和 FNR 特殊变量。

awk(getline close system)
{
打开外部文件（close用法）
$ awk 'BEGIN{while("cat /etc/passwd"|getline){print $0;};close("/etc/passwd");}'
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin

逐行读取外部文件(getline使用方法）
$ awk 'BEGIN{while(getline < "/etc/passwd"){print $0;};close("/etc/passwd");}'
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin

$ awk 'BEGIN{print "Enter your name:";getline name;print name;}'
Enter your name:
chengmo
chengmo

调用外部应用程序(system使用方法）
$ awk 'BEGIN{b=system("ls -al");print b;}'
total 42092
drwxr-xr-x 14 chengmo chengmo     4096 09-30 17:47 .
drwxr-xr-x 95 root   root       4096 10-08 14:01 ..

b返回值，是执行结果。
}



awk(常用运维awk命令)
{
统计tomcat每秒的带宽(字节)，最大的排在最后面
cat localhost_access_log.txt | awk '{ bytes[$5] += $NF; }; END{for(time in bytes) print   bytes[time] " " time}'  | sort -n

统计某一秒的带宽
grep "18:07:34" localhost_access_log.txt |awk '{ bytes += $NF; } END{ print  bytes }'


统计指定ip.txt中ip在local_access.txt中出现的次数
cat ip.txt //内容如下 
12.3.4.5
12.3.4.6
12.3.4.7
12.3.4.8

cat local_access.txt
19:23:35  /a.html   12.3.4.5
19:23:35  /b.html   12.3.4.5
19:23:35  /c.html   12.3.4.6
19:23:35  /d.html   12.3.4.7
19:23:35  /a.html   12.3.4.9
19:23:35  /b.html   12.3.4.9
19:23:35  /c.html   12.3.4.9

awk -F " " '{if (NR==FNR) {arr1[$1]=1} else{arr2[$3]++;}} END{for(ip in arr1){print ip,arr2[ip]}}' ip.txt local_access.txt
12.3.4.5 2
12.3.4.6 1
12.3.4.7 1
12.3.4.8

}


awk($0,$1,$2,$NF,$(NF-1)的使用)
{
$0整个当前行， $1当前行的第一个域   $NF为最后一个域   $(NF-1)为倒数第二个
echo "a b c d e" |awk '{print $1; print $2; print $(NF-1);print $NF;print $0}'
a                 //对应第1个域
b                 //对应第2个域
d                 //对应$(NF-1),对应倒数第二个域
e                 //对应$NF,最后一个域
a b c d e         //对应$0
}

awk(print, printf用法)
{
awk 'BEGIN{a=1;b="213";print "output "a","b;}' 
output 1,213 

awk 'BEGIN{a=1;b="213";print "output",a,","b;}' 
output 1 ,213 

printf的使用 
awk 'BEGIN{a=1;b="213";printf("output %d,%s\n",a,b)}' output 1,213
}

awk(选择分隔符)
{
awk默认是按照空格来分割, NF表示域的个数
echo "a:b c,d" |awk '{print $1; print $2; print NF}'
a:b
c,d
2

根据":",空格，","来进行分割
echo "a:b c,d" |awk -F " |,|:" '{print $1; print $2; print NF}'
a
b
4
}

awk(BEGIN,END用法)
{
abc.txt内容如下：
first lady
second boy
third child


cat abc.txt |awk 'BEGIN {print "begin process"} {print "process 1 "$1} {print "process 2 "$2} END { print " the end"}'
换行后如下:

cat abc.txt |awk -F " " '
         'BEGIN {print "begin process"}     //在开头的时候执行一次
               {print "process 1 "$1}       //每一行执行一次
               {print "process 2 "$2}       //每一行执行一次
          END  { print " the end"}'         //最后的时候执行一次'
输出如下
begin process      
process 1 first         // {print "process 1 "$1}  执行了一次
process 2 lady          // {print "process 2 "$2}  执行了一次
process 1 second
process 2 boy
process 1 third
process 2 child
 the end
 
 
 没有BEGIN，只有END的情况
cat abc.txt |awk '{print "begin process"} {print "process 1 "$1} {print "process 2 "$2} END { print " the end"}'
  格式化语句如下
cat abc.txt |awk -F ":"
  '{print "begin process"}          #因为没有BEGIN  所以这个每一行都会执行
   {print "process 1 "$1}           #每一行都会执行
   {print "process 2 "$2}           #每一行都会执行
    END { print " the end"}'        #最后执行一次
    
输出如下:    
begin process
process 1 first
process 2 lady
begin process
process 1 second
process 2 boy
begin process
process 1 third
process 2 child
the end
}

awk(数组使用)
{
awk中数据结构使用, 数组也可以理解为map

awk 'BEGIN{array1["a"]=1;array1[2]="213";print array1["a"],array1[2]}'
1 213

year.txt中内容如下  

2016:09 1    //表示2016年9月，有一个访问
2016:06 1
2016:06 1
2016:01 1
2015:01 1
2014:01 1
2015:01 1
2016:02 1


下面语句是把每个月的访问量相加,排序后输出
awk  '{bytes[$1]+=$2}  END { for(time in bytes) print bytes[time],time}' year.txt |sort -n

展开如下
awk
    '{bytes[$1]+=$2}             //bytes为数组，下标是时间，value是访问量
      END {
          for(time in bytes) print bytes[time], time
      }'
      year.txt |sort -n


输出的内容如下；   bytes是一个数组，下标是字符串""上面用数组，下标可以是数字，也可以是字符串
1 2014:01
1 2016:01
1 2016:02
1 2016:09
2 2015:01
2 2016:06

awk 'BEGIN{tB["a"]="a1";tB["b"]="b1";if(tB["c"]!="1"){print "no found";};for(k in tB){print k,tB[k];}}' 

展开是如下
awk 'BEGIN{
          tB["a"]="a1";
          tB["b"]="b1";
          if(tB["c"]!="1"){           //这个地方会判断在里面，但是会往tB占用一个值
              print "no found";
          };
          for(k in tB){
              print k,tB[k];
          }
       }' 

输出如下：
no found
a a1
b b1
c                   很奇怪，  “c”没有赋值，循环的时候，就发现在里面了，这个里面有副作用

要修改这个点，需要使用如下
awk 'BEGIN {
         tB["a"]="a1";
         tB["b"]="b1";
         if ("c" in tB) {                      //用这个来进行判断，就没有负作用
             print "c is in tB";
         } 
         for(k in tB){
             print k,tB[k];
         }
      }'
      
awk的多维数组

awk 'BEGIN{ for(i=1;i<=3;i++) {for(j=1;j<=3;j++) {tarr[i,j]=i*j;print i,"*",j,"=",tarr[i,j]}}}'

展开后如下:
awk 'BEGIN{
          for(i=1;i<=3;i++) {
              for(j=1;j<=3;j++) {
                  tarr[i,j]=i*j;
                  print i,"*",j,"=",tarr[i,j]
              }
          }
      }'

输出如下：
1 * 1 = 1
1 * 2 = 2
1 * 3 = 3
2 * 1 = 2
2 * 2 = 4
2 * 3 = 6
3 * 1 = 3
3 * 2 = 6
3 * 3 = 9

awk多维数组的in判断

awk 'BEGIN{ tarr[1,3]=5;if ((1,3) in tarr) print "1,3 in"; if ((4,4) in tarr) print "4,4 in"}'

#awk 'BEGIN{ 
          tarr[1,3]=5;
          if ((1,3) in tarr)          //直接使用(1,3)来判断in语句
              print "1,3 in"; 
          if ((4,4) in tarr) 
              print "4,4 in"}'
}'

awk(for)
{
＃awk 'BEGIN{array1["a"]=1;array1["c"]=3;array1["b"]=2;for(index1 in array1) print index1,array1[index1]}'

展开如下:
awk 'BEGIN{
          array1["a"]=1;
          array1["c"]=3;
          array1["b"]=2;
          for(index1 in array1)
              print index1,array1[index1]
      }'


输出如下：
a 1
b 2
c 3

or也可以使用k=1;k<=3;k++的形式

awk 'BEGIN{array1[1]="a";array1[3]="c";array1[2]="b";len=length(array1);for(k=1;k<=len;k++) print k,array1[k]}'

展开如下:
awk 'BEGIN{
          array1[1]="a";
          array1[3]="c";
          array1[2]="b";
          len=length(array1);        //得到数组的长度
          for(k=1;k<=len;k++) 
              print k,array1[k]
      }'

输出如下
1 a
2 b
c 3
}

awk(内置函数使用)
{
int函数，把字符串转为整数 
awk 'BEGIN {print int("12.9")}' 返回一个整数 12

index函数  
awk 'BEGIN {print index("12.9343",".")}'     #index方法返回"."在"12.9343的位置，没有找到则返回0
3

length函数 得到数组的长度,字符串长度 
awk 'BEGIN{array1["a"]=1;array1["b"]=2;print length(array1)}' #输出如下: 2

awk 'BEGIN{a="123";print length(a)}' #得到字符串长度 3


match函数，   检测info中是否含有"te" 如果有，则返回"te"第一次出现的位置，如果没有则返回0
awk 'BEGIN {info="is is test"; print match(info,"te");}'


rand函数 生成随机数 但是事实上是不随机的 
awk 'BEGIN {print rand " " rand}' # 
rand会生成一个0-1的数字 0.840188 0.394383 //每次运行第一个，第二个都是这个数字


split函数  按照某个分隔符，对字符串进行分割
split按照" "对"it is a test"进行切割，切割后的内容放在thearray中 返回的是split后，thearray的元素个数，
awk 'BEGIN {print split("it is a test",thearray," "); print thearray[1]}'
4                    //split后返回数组的长度
it                   //打印第一个元素

sub函数   替换
awk 'BEGIN {info="this a test"; sub("a","b",info); print info }'   把info中"a"用"b"替代
this b test


substr函数   得到子字符串
substr(s, m, n)     s是要截取的字符串,m是开始点，从1开始，   n是要截取的长度
awk 'BEGIN {print substr("12.9343",2,4)}'      //substr
2.93

toupper函数   字符串转为大写
awk 'BEGIN {info="this a test"; print toupper(info);}'
THIS A TEST


tolower函数   字符串转为消协
awk 'BEGIN {info="thIS A TEST"; print tolower(info);}'
this a test

}

awk(命令选项)
{
-F fs or --field-separator fs
    指定输入文件折分隔符，fs是一个字符串或者是一个正则表达式，如-F:。
-v var=value or --asign var=value
    赋值一个用户定义变量。
-f scripfile or --file scriptfile
    从脚本文件中读取awk命令。
-mf nnn and -mr nnn
    对nnn值设置内在限制，-mf选项限制分配给nnn的最大块数目；-mr选项限制记录的最大数目。这两个功能是Bell实验室版awk的扩展功能，在标准awk中不适用。
-W compact or --compat, -W traditional or --traditional
    在兼容模式下运行awk。所以gawk的行为和标准的awk完全一样，所有的awk扩展都被忽略。
-W copyleft or --copyleft, -W copyright or --copyright
    打印简短的版权信息。
-W help or --help, -W usage or --usage
    打印全部awk选项和每个选项的简短说明。
-W lint or --lint
    打印不能向传统unix平台移植的结构的警告。
-W lint-old or --lint-old
    打印关于不能向传统unix平台移植的结构的警告。
-W posix
    打开兼容模式。但有以下限制，不识别：\x、函数关键字、func、换码序列以及当fs是一个空格时，将新行作为一个域分隔符；操作符**和**=不能代替^和^=；fflush无效。
-W re-interval or --re-inerval
    允许间隔正则表达式的使用，参考(grep中的Posix字符类)，如括号表达式[[:alpha:]]。
-W source program-text or --source program-text
    使用program-text作为源代码，可与-f命令混用。
-W version or --version
    打印bug报告信息的版本。
}

awk(模式)
{
模式可以是以下任意一个：
    /正则表达式/：使用通配符的扩展集。
    关系表达式：可以用下面运算符表中的关系运算符进行操作，可以是字符串或数字的比较，如$2>%1选择第二个字段比第一个字段长的行。
    模式匹配表达式：用运算符~(匹配)和~!(不匹配)。
    模式，模式：指定一个行的范围。该语法不能包括BEGIN和END模式。
    BEGIN：让用户指定在第一条输入记录被处理之前所发生的动作，通常可在这里设置全局变量。
    END：让用户在最后一条输入记录被读取之后发生的动作。
    
    
}

awk(操作)
{
操作由一人或多个命令、函数、表达式组成，之间由换行符或分号隔开，并位于大括号内。主要有四部份：
    变量或数组赋值
    输出命令
    内置函数
    控制流命令
}

awk(awk的环境变量)
{
变量          描述
$n          当前记录的第n个字段，字段间由FS分隔。
$0          完整的输入记录。
ARGC        命令行参数的数目。
ARGIND      命令行中当前文件的位置(从0开始算)。
ARGV        包含命令行参数的数组。
CONVFMT     数字转换格式(默认值为%.6g)
ENVIRON     环境变量关联数组。
ERRNO       最后一个系统错误的描述。
FIELDWIDTHS 字段宽度列表(用空格键分隔)。
FILENAME    当前文件名。
FNR         同NR，但相对于当前文件。
FS          字段分隔符(默认是任何空格)。
IGNORECASE  如果为真，则进行忽略大小写的匹配。
NF          当前记录中的字段数。
NR          当前记录数。
OFMT        数字的输出格式(默认值是%.6g)。
OFS         输出字段分隔符(默认值是一个空格)。
ORS         输出记录分隔符(默认值是一个换行符)。
RLENGTH     由match函数所匹配的字符串的长度。
RS          记录分隔符(默认是一个换行符)。
RSTART      由match函数所匹配的字符串的第一个位置。
SUBSEP      数组下标分隔符(默认值是\034)。
}

awk(awk运算符)
{
运算符                      描述
= += -= *= /= %= ^= **=     赋值
?:                          C条件表达式
||                          逻辑或
&&                          逻辑与
~ ~!                        匹配正则表达式和不匹配正则表达式
< <= > >= != ==             关系运算符
空格                        连接
+ -                         加，减
* / &                       乘，除与求余
+ - !                       一元加，减和逻辑非
^ ***                       求幂
++ --                       增加或减少，作为前缀或后缀
$                           字段引用
in                          数组成员
}

awk(重定向和管道)
{
    awk可使用shell的重定向符进行重定向输出，如：awk '$1 = 100 {print $1 > "output_file" }'test
上式表示如果第一个域的值等于100，则把它输出到output_file中。也可以用>>来重定向输出，但不清空文件，只做追加操作。

    输出重定向需用到getline函数。getline从标准输入、管道或者当前正在处理的文件之外的其他输入文件获得输入。
它负责从输入获得下一行的内容，并给NF,NR和FNR等内建变量赋值。如果得到一条记录，getline函数返回1，如果到达
文件的末尾就返回0，如果出现错误，例如打开文件失败，就返回-1。如：

    awk 'BEGIN{ "date" | getline d; print d}' test。执行linux的date命令，并通过管道输出给getline，然后再把
输出赋值给自定义变量d，并打印它。

    awk 'BEGIN{"date" | getline d; split(d,mon); print mon[2]}' 执行shell的date命令，并通过管道输出给getline，
然后getline从管道中读取并将输入赋值给d，split函数把变量d转化成数组mon，然后打印数组mon的第二个元素。

    awk 'BEGIN{while( "ls" | getline) print}'，命令ls的输出传递给geline作为输入，循环使getline从ls的输出中读取一行，
并把它打印到屏幕。这里没有输入文件，因为BEGIN块在打开输入文件前执行，所以可以忽略输入文件。

    awk 'BEGIN{printf "What is your name?"; getline name < "/dev/tty" } 
         $1 ~name {print "Found" name on line ", NR "."} 
         END{print "See you," name "."} ' test。
     在屏幕上打印 "What is your name?" ,并等待用户应答。
     当一行输入完毕后，getline函数从终端接收该行输入，并把它储存在自定义变量name中。
     如果第一个域匹配变量name的值，print函数就被执行，END块打印See you和name的值。

    awk 'BEGIN{while (getline < "/etc/passwd" > 0) lc++; print lc}'。
    awk将逐行读取文件/etc/passwd的内容，在到达文件末尾前，计数器lc一直增加，当到末尾时，打印lc的值。
    注意，如果文件不存在，getline返回-1，如果到达文件的末尾就返回0，如果读到一行，就返回1，
    所以命令 while (getline < "/etc/passwd")在文件不存在的情况下将陷入无限循环，因为返回-1表示逻辑真。

    可以在awk中打开一个管道，且同一时刻只能有一个管道存在。通过close()可关闭管道。
如：$ awk '{print $1, $2 | "sort" }' test END {close("sort")}。
awk把print语句的输出通过管道作为linux命令sort的输入,END块执行关闭管道操作。

    system函数可以在awk中执行linux的命令。如：$ awk 'BEGIN{system("clear")'。

    fflush函数用以刷新输出缓冲区，如果没有参数，就刷新标准输出的缓冲区，如果以空字符串为参数，
如fflush(""),则刷新所有文件和管道的输出缓冲区。
}

awk(日期和时间格式说明符)
{
格式      描述
%a      星期几的缩写(Sun)
%A      星期几的完整写法(Sunday)
%b      月名的缩写(Oct)
%B      月名的完整写法(October)
%c      本地日期和时间
%d      十进制日期
%D      日期 08/20/99
%e      日期，如果只有一位会补上一个空格
%H      用十进制表示24小时格式的小时
%I      用十进制表示12小时格式的小时
%j      从1月1日起一年中的第几天
%m      十进制表示的月份
%M      十进制表示的分钟
%p      12小时表示法(AM/PM)
%S      十进制表示的秒
%U      十进制表示的一年中的第几个星期(星期天作为一个星期的开始)
%w      十进制表示的星期几(星期天是0)
%W      十进制表示的一年中的第几个星期(星期一作为一个星期的开始)
%x      重新设置本地日期(08/20/99)
%X      重新设置本地时间(12：00：00)
%y      两位数字表示的年(99)
%Y      当前月份
%Z      时区(PDT)
%%      百分号(%)

awk '{ now=strftime( "%D", systime() ); print now }' 
awk '{ now=strftime("%m/%d/%y"); print now }'
}
awk '/^(no|so)/' test-----打印所有以模式no或so开头的行。
awk '/^[ns]/{print $1}' test-----如果记录以n或s开头，就打印这个记录。
awk '$1 ~/[0-9][0-9]$/(print $1}' test-----如果第一个域以两个数字结束就打印这个记录。
awk '$1 == 100 || $2 < 50' test-----如果第一个或等于100或者第二个域小于50，则打印该行。
awk '$1 != 10' test-----如果第一个域不等于10就打印该行。
awk '/test/{print $1 + 10}' test-----如果记录包含正则表达式test，则第一个域加10并打印出来。
awk '{print ($1 > 5 ? "ok "$1: "error"$1)}' test-----如果第一个域大于5则打印问号后面的表达式值，否则打印冒号后面的表达式值。
awk '/^root/,/^mysql/' test----打印以正则表达式root开头的记录到以正则表达式mysql开头的记录范围内的所有记录。如果找到一个新的正则表达式root开头的记录，则继续打印直到下一个以正则表达式mysql开头的记录为止，或到文件末尾。