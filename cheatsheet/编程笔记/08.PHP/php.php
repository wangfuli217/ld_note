php简介
   PHP是能让你生成动态网页的工具之一。
   PHP代表：超文本预处理器（PHP: Hypertext Preprocessor）。PHP是完全免费的，不用花钱，你可以从PHP官方站点自由下载。PHP遵守GNU公共许可（GPL)，在这一许可下诞生了许多流行的软件诸如Linux和Emacs。你可以不受限制的获得源码，甚至可以从中加进你自己需要的特色。PHP在大多数Unix平台，GUN/Linux和微软Windows平台上均可以运行。怎样在Windows环境的PC机器或Unix机器上安装PHP的资料可以在PHP官方站点上找到，也可以查阅网页陶吧的“PHP安装全攻备”专题文章。安装过程很简单。

PHP资源：
   http://www.php.net    //官方网站
   http://www.zend.com/en/
       http://devzone.zend.com/public/view   有关于php的最初级到最顶级的话题。
   http://www.hotscripts.com    代码下载站点，不止php的
   PHP Editor: http://www.soysal.com/PHPEd

PHP+Apache+MySQL的安装
   1.下载Apache: 官方下载地址:  http://httpd.apache.org/download.cgi
     安装配置Apach: 安装完成后，可以在【开始】->【程序】中找到安装后的APACHE程序，打开一个Edit the Apache httpd.conf Configuration File.TXT 文件。在这文件中查找“Listen 80”，这个80就是端口，可修改它，如改成8080。继续查找“DocumentRoot”，它后面的路径为服务器默认根目录，将后面的路径更改为你自己的网站路径，比如更改为与Eclipse相同的工作区域。同时路径的“\”全部改为“/”。继续查找“Directory”，将它后面的路径设置为以“DocumentRoot”相同。继续查找“DirectoryIndex”，它后面的路径“index.html”为默认工程首页，你也可以设置你自己的默认首页，比如index.php。接下来APACHE服务器的配置就算结束了。如果你没有更改APACHE的默认工程路径，可以进行测试。键入你的本机IP地址，如果有页面显示则证明你的配置已经成功。
     Apache网页服务器软件: http://www.apache.org/dist/httpd/binaries/win32/
   2.下载安装PHP:  下载地址：http://www.php.net/downloads.php
     将下载到的压缩包解压后释放到适宜控制的路径，并打开解压后的文件，找到php.ini-dist，将此文件后缀-dist删除。然后打开此文件编辑，查找“register_globals = Off”，如果设置为ON，页面之间进行数据传输时，可以直接使用【$变量名】获得，如果为Off，页面是GET方式传输数据，则获得数据时要使用【$_GET(“变量名”)】方式获得。当然设为Off比较安全，不会让人轻易将网页间传送的数据截取。继续查找“extension=php_mysql.dll”将前面的“;”去掉，表示PHP要加载mysql模块。其他模块都在ext文件中，同时加载模块越多，耗费资源越大。另外，为了防止其他错误，也请在环境变量中添加PHP的安装路径与PHP文件中EXT的路径。如【;D:\php;D:\php\ext】，当然“D：”是我的安装路径。
     现在开始将php以module方式与apache相结合，使php融入apache，然后打开apache的配置文件，添加“LoadModule php5_module D:php/php5apache2.dll”，表示以module方式加载php。再换行添加“PHPInidir "D:/php";”，表示php的配置文件php.ini的路径。实质是添加可以执行php的文件类型，设置可以添加.txt文件类型。如：“AddType application/x-http-php .php”和“AddType application/x-http-php .html”。接下来，重新启动你的apache，然后就可以运行php的工程了。
   3.MySQL的下载及安装，略。


php基本语法：
   每句都以分号“;”结束。
   变量区分大小写；而函数不区分大小写。

PHP 与 HTML 互嵌：
    动态内容较少时，用php嵌入到html中。
    页面较复杂时，用html嵌入到php中。

不同的 php 开始和结束 风格标签：
    <?php 和 closing ?>                    //php的开始和结束标签；建议使用。但结尾可简写为“?>”
    <?  and  ?>                            //上一种风格的简写，并非所有服务器都支持
    <script language="php"> and </script>  //html风格的写法
    <%  and  %>                            //asp风格，不建议使用，容易出错

显示：
    echo $variable       显示。显示多个字符串时，可用逗号“,”隔开；但print不可以这样。
    print $variable      显示。两个都可用，但echo更快些，所以更常用。
    printf($variable)    格式化显示。必须带圆括号。可用逗号隔开，显示多个字符串。
    print_r($array)      遍历数组，常用于array。常配合<pre>标签一起用，有自动换行效果。
    var_dump($variable)  显示类型和值
    get_defined_vars()   以array的形式返回定义过的变量，包括php自身的变量

    显示页面信息常用语句：
    echo "<pre>";
    print_r(get_defined_vars());
    echo "</pre>";

注释：comments
    // 单行注释
    #  单行注释(两种写法皆可)；UNIX Shell语法注释
    /* 多行注释  */


变量：variable
    变量可以当作是一种容器，容器里面是值
    值 和 对值的处理方式是，是编程语言的核心
    PHP变量数据类型的定义是通过变量的初始化,系统设定
    数据类型可分为二种：一是标量数据类型 ，二是复合数据类型。
变量命名：
    以“$”开始
    开头可以是字母或下划线，不能用数字开头
    可以包含：字母、数字、下划线、短横线“-”
    中间不能有空格
    区分大小写(case-sensitive)
    注意：短横线一般不用(因为它像减号)；
          首字符一般不会用下划线(因为php自定义的一些变量是这样写的，容易混淆)

常量 Constants:
    设定常量: define("常量名",值);
    常量名一般用大写，不需$开头。值是固定的，不可改。
    defined('常量'); //返回此常量是否已被定义。


标量数据类型：
   (1)布尔型（boolean）
   (2)整形  （integer）
   (3)浮点型（float\double)
   (4)字符串（string）
复合数据类型
   (1)数组  （array）
   (2)对象  （object）
另外，PHP中，还有两种特殊的数据类型：
   (1)资源  （resource）
   (2)空值  （NULL）

浮点数 float：(浮点数，也做”double”)
    整数(int)大小超出其范围后，自动转化为双精度型(double)。
    浮点数的字长和平台相关。
    由于不可能精确的用有限位数表达某些十进制分数，所以不能相信浮点数结果精确到了最后一位，也不能直接比较两个浮点数是否相等。
    如果确实需要更高的精度，应该使用任意精度数学函数库或者 gmp 函数库。
    8进制以“0”开头；16进制以“0x”开头。

    整型与双精度型的范围：
    声明类型    长度(位)    长度(字节)    值的范围
    int         32          4            -2147483647～2147483647
    double      32          4            1.7E-308～1.7E+308 (15位有效数字)

    round($FloatVar,n);  保留n位小数             round(3.14,1)==3.1
    ceil($FloatVar);     变大取整                ceil(3.14)==4;      ceil(-3.14) == -3
    floor($FloatVar);    变小取整                floor(3.14)==3;     floor(-3.14)== -4
    还有很多函数


布尔值 boolean :
    要指定一个布尔值，使用关键字 TRUE 或 FALSE。两个都是大小写不敏感的。如： $foo = True;
    true  返回 1
    false 返回 nothing, 即什么都没返回。
    isset($BooleanVar); 看这变量是否有被设定过，有则返回1，没则没返回

字符串 string:
    字符串可以用三种字面上的方法定义：单引号、双引号、定界符。
    注: 和其他语法不同，单引号字符串中出现的变量和转义序列不会被变量的值替代。
    双引号字符串最重要的一点是其中的变量名会被变量值替代。

    strlen($str1);       返回字符串长度。每个汉字长度为2
    合并 Concatenate:    使用点号“.”，而不是加号“+”
    substr($str2,n);     截取字符串；从第n个开始，到末尾。起始位置为0。也可用于数字等。
    substr($str3,n,m);   截取字符串；从第n个开始，到第m个。起始位置为0。也可用于数字等。
    $str4{n};            返回字符串的第n个字符。只能用于字符串，且也不能用于汉字。

    Case function:
    strtoupper($str);    全部变成大写。语句中可以有中文，但中文不受影响。
    strtolower($str);    全部变成小写。
    ucfirst($str);       只有首字母大写。
    ucwords($str);       每个单词首字母大写。以空格作为不同单词的划分依据。

    字符串的查找、替换：
    str_replace($nums, $n, $str);    $nums是写查找什么；$n是查找到之后替换成什么；$str是被查找的源字符串。
    例如：$str = "There are approcimately 3 other subjects to release.";
          $nums = array("1", "2", "3", "4", "5", "6", "7", "8", "9", "0");
          $newstr = str_replace($nums,"X", $str);
          echo $newstr, "<br><br><br><br>";
          //显示结果： There are approcimately X other subjects to release.

    Clearing Up 修剪、清理字符串：
    trim($str1);         修剪字符串。把字符串左右两边的空格都去掉。
    ltrim($str);         修剪字符串的左边。只把字符串左边的空格去掉。
    rtrim($str);         修剪字符串的右边。只把字符串右边的空格去掉。
    chop($str);          效果等同于 rtrim() 。

    PHP支持以“＼”后面的有特殊意义的字符，如“＼n”代表回车。更多参考正则表达式。


数组 array:
    数组就像是值的列表，其中每个值可以是字符串或数字，甚至是另一个数组。
    数组结构:
    1.基本结构：  $My_Array[0] :       这个0是下标、index、key。从0开始。
    2.名称索引：  $Some_Guy["name"]:   用名称作索引；也称联合数组、哈希表数组。类似枚举。
                  $a["apple"][4]["color"][0]="bad"; //四维数组，普通数组和联合数组连用

    创建 array:   $Some_Guy = array();
    带起始值的    $Some_Guy = array("John","30","5'12");
                  $user1 = Array("name"=>"Mike","city"=>"Oakville","age"=>"30");
    遍历数组，用 print_r() 函数 ；或者 foreach()循环。

    多维数组 Multidimensional array:
    可理解为数组里嵌套的数组，数组里的数组。各维长短不要求相等。
    实际上数组的维数最好不要超过三维，否则会给服务器带来极大的负担，就有些得不偿失了。
    如：$users=Array(
          Array("name"=>"Mike","city"=>"Oakville","age"=>"30"),
          Array("0",1,"bb",3,4),
          Array("kk","jj",array(99,88,"jiji"))
        );

    array functions：
    count($array1)           查出array里有多少个元素。
    max($array1)             找出array里的最大值。
    min($array1)             找出array里的最小值。
    sort($array1)            把array排序。
    rsort($array1)           反过来把array排序。
    implode($array1 ," * ")  把数组转化成字符串阵列。这里用“ * ”作为数组各元素间的分隔符。
                             写成 implode(" * " , $array1) 也可以。
    explode(" * ", $str1)    是implode()的反过程。
    in_array(15, $array1)    查找数组里是否有这个元素(这里用15)；有则返回1，没有则没返回。

    还可以用 array_walk 函数来实现数组的显示。这个函数对数组的每个内容执行同一个函数操作。例如：
    function printelement ($element){print ("$element< p>");}
    array_walk($myarray, "printelement");

<?php   //数组的定义举例：
        $monthName = array(
        /*定义$monthName[1]到$monthName[12]*/
                1=>"January", "February", "March","April", "May", "June",
                "July", "August", "September", "October", "November", "December",
        /*定义$monthName["Jan"]到$monthName["Dec"]*/
                "Jan"=>"January", "Feb"=>"February","Mar"=>"March", "Apr"=>"April",
                "May"=>"May", "Jun"=>"June", "Jul"=>"July", "Aug"=>"August",
                "Sep"=>"September", "Oct"=>"October", "Nov"=>"November", "Dec"=>"December",
        /*定义$monthName["Jan"]到$monthName["Dec"]*/
                "January"=>"January", "February"=>"February","March"=>"March", "April"=>"April",
                "May"=>"May", "June"=>"June", "July"=>"July", "August"=>"August",
                "September"=>"September", "October"=>"October", "November"=>"November", "December"=>"December"
                );
        /*打印相关的元素*/
        echo "Month <B>5</B> is <B>" , $monthName[5] , "</B><BR>\n";
        echo "Month <B>Aug</B> is <B>" , $monthName["Aug"] , "</B><BR>\n";
        echo "Month <B>June</B> is <B>" , $monthName["June"] , "</B><BR>\n";
?>


内置数组   Built-in php Arrays:
    $_SERVER     服务器的细节信息。
    $_ENV        环境信息。如操作系统、处理器。
    $GLOBALS     全局。
    $_POST       处理表单、提交的时候用。
    $_GET        类似上一个。
    $_COOKIE     跟踪客户信息的时候用。用于互动。
    $_SESSION    类似上一个。
    $_REQUEST    是 $_POST 加上 $_GET

    如：显示本页的相对地址 <?php  echo $_SERVER['SCRIPT_NAME']."<BR>"; ?>


类型转换 typecasting：
    php具有自动类型转换功能。但不能依赖它，因为那未必是你想要的。
    gettype($var);                  返回变量的类型。
    settype($var,"string");         设置变量的类型。
    (int) $var;                     指定变量的类型。
    String + integer = integer      这跟Java很不同。加号没有被重载，都按数字算。
    字符串的拼接用"." 点号。        注意：点号不能紧跟着数字，否则会被认为小数点。


运算符：
    算术运算符:   +   -   *   /   %             (加减乘除,求余)
    赋值运算符:   +=  -=  *=  /=  %=  <<=  >>=
    字符串合并:   .   .=                        (点是合并，点等于是赋值合并)
    自增、自减:   ++  --
    比较运算符:   >   >=  <   <=  ==  !=        (true则返回1；false则不返回)
    逻辑运算:     !(反相)                       (true则返回1；false则不返回)
      短路运算    &&  ||                        (true则返回1；false则不返回)
      非短路运算  &   |                         (true则返回1；false则返回0)
    移位运算:     >>  <<
    位运算:       &(AND)  |(OR)   ^(XOR异或)    ~(补码)按位取反 ＝ 加1再取反   (还不知这组怎么用)


条件语句
    if(expression){statement;}      //当statement是单行语句时，可不写大括号。
    if(){} elseif(){} else{}        //这里的elseif可以连在一起写；分开成 else if 也可以。

swith(值){
        case condition1: statement1; break;
        case condition2: statement2; break;
        case condition3: statement3; break;
        default:  statement4; break;
        }

循环 loop：
    while(expression){statement;}
    for(initial;expression;each){statement;}

    foreach() 循环： //用于遍历数组
    形式: foreach($数组 as $临时变量){echo $临时变量;}
          foreach($数组 as $key => $value){echo $key . ": " . $value;}


break 和 continue
    break 退出当前的循环体，在嵌套循环中，只退出当前的一层循环。
    continue 跳过本次循环，继续进行下一轮的循环。可以说，只是本次忽略循环内后面的语句。


函数 function:
    function name($arguments,$arg2,$arg3="test") {
        statement1;
        return statement2;  //返回。可不写
    }
    name($a1, &$a2); //$arg3有默认值，可不写。变量前加“&”，在函数里改变参数的值时，就直接改变了这个变量的值。
    注：PHP不允许重载(overload)。函数可以在定义之前调用。
        允许嵌套定义函数，但不建议这样做；易错。
        函数不调用，则不加载。
        函数名的大小写不敏感，但不能重名。

    global: PHP如果直接在函数中引用与页面变量同名的变量，它会认为函数的变量是一个新的局部变量；
    给变量加上 global ，则成为全局变量，就可以得到页面的同名变量的值。
    如：$bar = "inside";
        function foo() {
                global $bar;    //不写 global 则这函数没显示。
                echo $bar;
        }
        foo();  //显示为 inside

    函数的默认值 Defaultvalue:
    在定义函数时，可以赋予默认值。不一定要这样做，但这是个好习惯。
    由于PHP不允许函数重载(overload),所以有默认值的函数，可以以空参函数来调用。
    function paint($color="red") { statement; } //定义默认值，即是在函数的参数里赋值。
    paint();      //这是使用默认值。
    paint(blue);  //另外赋值。


动态调用函数
<?php   function write($text) {echo $text;}                //定义 write()函数
        function writeBold($text) {echo "<B>$text</B>";}   //定义 writeBold()函数

        $myFunction = "write";         //定义变量
        $myFunction("你好!<BR>\n");    //由于变量后面有括号，所以找名字相同的函数: write($text)

        $myFunction = "writeBold";     //定义变量
        $myFunction("再见!<BR>\n");    //由于变量后面有括号，所以找名字相同的函数: writeBold($text)
?>


变量的变量
    在php中变量与许多常用语言最大的区别就是增加了一个‘$’前缀，有了这一个前缀，又增加了PHP的独特的一种处理方式。
    一个前缀代表普通的变量，但是两个前缀呢？这就是变量的变量，例：
        <?php
         $name = "hello";
         ${$name}="world";              //等同于$hello=″world″;
         echo "$name $hello","<br>";    //输出：hello world
         echo "$name ${$name}","<br>";  //同样输出：hello world  //测试时是：hello $hello
         for($i=1;$i<=5;$i++)
         { ${"var"."$i"}=$i;}           //定义 $var1 ~ $var5
         echo $var3;                    //输出：3 。证明 $var3 刚才被生成了。  //测试不成功，可能版本问题。
        ?>
    上面的例子基本上可以理解$$name了，PHP的标准定义则是${$name}。
    我们有了变量的变量就可以实现动态增加变量了，这简直就是神奇。


MySQL crud:   Create Read Update Delete
    Create:   INSERT INTO table (column1,column2,column3) VALUES (val1,val2,val3);
    Read:     SELECT * FROM table WHERE column1 = 'some_text' ORDER BY column1,column2 ASC;
    Update:   UPDATE table SET column1 = 'some_text' WHERE id = 1;
    DELETE:   DELETE FROM table WHERE id = 1;

MySQL数据库连接步骤：
    //步骤一：初始化
    $dbHostname = "localhost";
    $dbUsername = "root";
    $dbPassword = "root";
    $dbName     = "samples";

    //步骤二：连接数据库
    $dblink = MYSQL_CONNECT($dbHostname, $dbUsername, $dbPassword) OR DIE("连接数据库失败");
    //进入MySQL的某个 database
    mysql_select_db($dbName) or die( "Unable to select database ".$dbName);

    //步骤三：crud
    mysql_query("set names GBK");  //设置字体编码

        //Create:  (以下的 $Customer_id 等变量须先赋值)
        $Customer_id = addslashes($_REQUEST['Customer_id_name']); //取得传过来的参数...多个...
        $sqlQuery = "INSERT INTO table (id , name , company)
        VALUES ('$Customer_id' , '$thisFname' , '$thisCompany')";
        mysql_query($sqlQuery) or die('Query failed: ' . mysql_error());

        //Read:
        $query = 'SELECT * FROM table' . 'ORDER BY customer_id ASC LIMIT 0,10'; //LIMIT 是数据库分页
        $result = mysql_query($query) or die('Query failed: ' . mysql_error());
        echo "<table border='1'>\n";
        while ($line = mysql_fetch_array($result, MYSQL_ASSOC)) {
           echo "\t<tr>\n";
           foreach ($line as $col_value) {
                   echo "\t\t<td>$col_value</td>\n";
           }
           echo "\t</tr>\n";
        }echo "</table>\n";

        //Update:  (以下的 $Customer_id 等变量须先赋值)
        $sql = "UPDATE table SET id = '$Customer_id' , name = '$Fname' , company = '$thisCompany'
        WHERE id = '$Customer_id'";
        MYSQL_QUERY($sql);

        //Delete:
        $Customer_id = addslashes($_POST['Customer_idField']); //接受提交过来的数据
        $sql = "DELETE FROM table WHERE id = '$Customer_id'";
        MYSQL_QUERY($sql);

        //search: 搜索
        $thisKeyword = $_REQUEST['keyword'];   //接收要求搜索的关键字
        $sqlQuery = "SELECT * FROM table WHERE id like '%$thisKeyword%' OR name like '%$thisKeyword%'
          OR company like '%$thisKeyword%'";   //各个列都比较一下
        $result = MYSQL_QUERY($sqlQuery);
        $numberOfRows = MYSQL_NUM_ROWS($result); //取得返回列的数目
        if ($numberOfRows==0) { echo "Sorry. No records found !!"; }
        else if ($numberOfRows>0) {
           $i=0;
           echo "<table border='1'>";
           while ($i < $numberOfRows){
                 $Customer_id = MYSQL_RESULT($result,$i,"id");
                 $Fname = MYSQL_RESULT($result,$i,"name");
                 $Company = MYSQL_RESULT($result,$i,"company");
                <TR>
                <TD nowrap><?php echo $Customer_id; ?></TD>
                <TD nowrap><?php echo $Fname; ?></TD>
                <TD nowrap><?php echo $Company; ?></TD>
                </TR> $i++;
           } </TABLE>
        }

    //步骤四：关闭连接。这步可不写，数据库引擎会自动做；写出来更有条理
    /*显示大量数据库的内容时，网速慢的用户可能会拖累整个数据库。
      因此，尽快的连上数据库，取得需要的资料后，马上关闭数据库，再慢慢送给用户，应是最好的对策。*/
    mysql_close($dblink);


引用文件：
    引用文件的方法有：include、include-once 和 require、require-once
    include:PHP 的网页在遇到include 所指定的文件时，才将它读进来。这种方式，更符合人们的习惯。
            这个函数一般是放在流程控制的处理部分中；可以把程序执行时的流程简单化。
            如: include("./intro/hello.php"); 。  //注，路径的斜杠方向，正反都行。
    require:在 PHP 程序执行前，先读入 require 所指定引入的文件，使它变成 PHP 程序网页的一部份。
            如: require("intro\hello.php"); 。
            这个函数通常放在 PHP 程序的最前面。常用的函数，可以用这个方法将它引入网页中。
    once:   编程时，在我们极力保证函数和类的独立性和公用性的同时，而如果在程序里面我们调用了一个非公用文件里的类，但我们的另一个处理文件也调用了这个文件里的这个类，那么程序将会出错，说是重定义了这个类，因此，我们将不得不去重写文件或者丢弃它的独立性，但在PHP4以后不存在这个问题，因为PHP4可以使用require_once和include_once方法，顾名思义也就是他们只调用一次我们所需要的文件，如果有两次调用文件的话，第二次调用的文件不起作用。


文件操作：
1. 打开文件、读取内容
   <?php  echo "<H3>通过http协议打开文件</H3>\n";
        //打开同文件夹下的某文件
        if (!($myFile = fopen($_REQUEST['DOCUMENT_ROOT'] . "data.txt", "r")))
        {  print("文件不能打开");  exit;  }
        while(!feof($myFile))     // 按行读取文件中的内容
        {  $myLine = fgets($myFile, 255);  //fgets还可用fgetss、fgetc；效果有所不同
           echo "$myLine <BR>\n";
        }

        // 打开文件同时，打印每一行
        $myFile = file("data.txt");
        for ($index = 0; $index < count($myFile); $index++)
        {   echo $myFile[$index] , "<BR>";    }

        fclose($myFile);    //关闭文件的句柄
   ?>

   <?php //读取某文件夹(默认当前文件夹)下的所有文件夹及文件
         function aa($dirName="."){
            $d = dir($dirName);
            echo "Handle: " , $d->handle , "<br>\n";      //打印例子：Resource id #3
            //echo "Path: " , $d->path , "<br>\n";        //打印正在读取的文件夹路径
            while ($entry=$d->read()) {
                if ($entry == "." || $entry == "..") continue;
                echo $dirName , "/",$entry , "<br>\n";
                if (@filetype($dirName . "/".$entry)=="dir") aa($d->path . "/" . $entry);
           }
           $d->close();
        }
   ?>

2. 创建文件
   <?php
        if(!file_exists(myDir1)){mkdir("myDir1", 0777);} //创建文件夹
        $configfile="要写入的内容";               //内容按String里的写法，有特殊字符
        $filenum = fopen ("myDir1\DATA.TXT","w"); //如果没有这文件，会自动创建
        fwrite($filenum, $configfile);            //把内容写进文件里
        fclose($filenum);
   ?>



常用语句：
   让浏览器重定向到某页面：   Header("Location: ./name.php"); //“name.php”是页面名称

   $msg=base64_encode($msg);  //把页面接收的 $msg 用 BASE64 编码。解决中文冲突问题。
   //显示时：
   $msg=base64_decode($get_msg);  //$get_msg 即刚才用了 BASE64 编码的 $msg；现在翻译回来
   $msg=nl2br($msg); //将换行字符转成 <br>。不写这行则没有显示出换行






