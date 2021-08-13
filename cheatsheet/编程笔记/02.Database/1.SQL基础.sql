本笔记以orcal数据库为例,其它数据库略有不同.

一、写子句顺序
    Select [ALL | DISTINCT]  column_name [, column_name]...
    From  {table_name | view_name}
              [, {table_name | view_name}]...
    [Where  search_conditions]
    [Group By  column_name [, column_name]
      [Having  search_condition]]
    [Order By  {column_name | select_list_number} [ASC | DESC]
        [,  {column_name | select_list_number} [ASC | DESC]]... ];    -- 最后

二、常用SQL:
  1.建表前检查语句:
    MySQL的: drop table if exists 表名 DEFAULT CHARACTER SET utf8;
    SQL Server的: IF EXISTS (SELECT 1 FROM sysobjects  WHERE name = '表名' AND type = 'U') DROP TABLE 表名;
                  CREATE TABLE 表名(ID INT PRIMARY KEY, UserID CHAR(15),  ContactPersonID INT);
    Oracle的: create or replace table 表名 ...; -- 直接写建表语句

  2.建表语句: create table 表名(memid int , points numeric(10,1) default 0,
        primary key (`memid`, `courseid`),
        FOREIGN KEY (`memid`) REFERENCES 表名2 (`memid`) on delete cascade on update cascade ,
        CHECK ( points>=0 and points<=100 ) );
  3.复制表: CREATE TABLE 新表名 AS SELECT *  FROM 旧表名; -- 仅复制数据,没复制表结构(自增主键等不会复制)
            CREATE TABLE 新表名 like 旧表名; -- 使用旧表创建新表,复制表结构(数据不会复制)
  4.插入语句: INSERT INTO 表名(id,name,price,vend_name) VALUES(11,'TV',222,'US'),(22,'ss',12.22,'kk');
              INSERT INTO 表名(id,name,price,vend_name) SELECT id,name,price,vend FROM 表名2;
  5.更新语句: UPDATE 表名 SET column_name = expression, prod_name = 'NEWCOMPUTER' [WHERE];
              UPDATE 表1, 表2 SET 表2.column_name = expression, 表1.prod_name = 'NEWCOMPUTER' [WHERE];
  6.删除语句: DELETE FROM 表名 WHERE search_conditions;

  7.清空表格: TRUNCATE TABLE 表名;
  8.修改表结构
    修改字段: ALTER TABLE 表名 Modify col_name varchar(100);
    添加字段: ALTER TABLE 表名 Add col_name varchar(100) default NULL COMMENT '匯款帳號或者匯款人' after col_name0;
    减少字段: Alter Table 表名 Drop (column [, column]…);
    添加约束: Alter TABLE 表名 Add FOREIGN KEY(column1) REFERENCES 表名2(column2); -- 添加非空约束时,要用Modify语句
    删除约束: ALTER TABLE 表名 Drop FOREIGN KEY 表名_ibfk_1;
              Alter Table 表名 Drop CONSTRAINT column;
    添加主键: Alter table 表名 Add primary key(col);
    删除主键: Alter table 表名 DROP primary key(col);
    唯一约束: ALTER [IGNORE] TABLE 表名 ADD UNIQUE INDEX (column [, column]…); -- IGNORE:删除重复; 没这个则重复时报错
  9.创建索引: CREATE [UNIQUE] INDEX 索引名 ON 表名(column [, column]…);
    添加索引: ALTER TABLE 表名 ADD INDEX 索引名 (column [, column]…);
    唯一索引: CREATE UNIQUE INDEX 索引名 ON 表名 (column [, column]…);
              ALTER TABLE 表名 Add UNIQUE INDEX [索引名] (column [, column]…);
    删除索引: DROP INDEX 索引名;
              DROP INDEX 索引名 ON 表名;
              ALTER TABLE 表名 DROP INDEX 索引名;
  10.创建视图:create view 视图名 as select statement;
     删除视图:DROP view 视图名;


三、注意事项:
    大小写不敏感，即不区分大小写。提倡关键字大写，便于阅读和调试。
    SQL语句是由简单的英语单词构成；这些英语单词称为关键字/保留字，不做它用。SQL由多个关键字构成。
    SQL语句由子句构成，有些子句是必须的，有些是可选的。
    在处理SQL语句时，其中所有的空格都被忽略(空格只用来分开单词，连续多个空格当一个用)。
    SQL语句可以在一行上写出，建议多行写出，便于阅读和调试。
    多条SQL语句必须以分号分隔。多数DBMS不需要在单条SQL语句后加分号，但特定的DBMS可能必须在单条SQL语句后加分号。
    SQL语句的最后一句以 “；”号结束。不同的数据库会有不同的结束符号。(go也会作结束符)
    {} 大括号包起来的单字或词组，表示至少从中选一个。
    [] 中括号包起来的部分，表示可选可不选的。
    () 小括号，表示一定要输入的。与大括号、中括号不同。
    ｜ 表示最多只能从选项中选取一个。
    ， 表示可按需选择多个选项，并且这些选项之间必须以逗号隔开。
    ... 表示可以重复地使用同样的语法部分。
    !  在SQL环境下执行Unix命令。

四、兼顾各数据库的 SQL 语句
    1.自增列:
       Oracle:     建立 Sequence
       MySQL:      create table test_t(id int primary key AUTO_INCREMENT, name varchar(80)); -- AUTO_INCREMENT 是自增关键字
       SQL Server: create table test_t(id int primary key identity(1,1), name varchar(80)); -- identity(1,1) 是自增函数
       access:     create table test_t(id Integer primary key Counter(1,1), name varchar(80));

       通用的: 使用表自身的自增列的最大值+1，如:
       insert into test_t(id, name) values((select nvl(max(id),0)+1 from test_t),'holer');  -- 这里 id 是表的自增列

     2.伪列(序号):
       SELECT (SELECT Count(表名.aa) AS AutoNum FROM xlh WHERE (表名.aa <= 表名_tem.aa)) AS 序号, 表名.aa
       FROM 表名 AS 表名_tem INNER JOIN 表名 ON 表名_tem.aa=表名.aa ORDER BY 表名.aa;


三、常用简单语句:
    clear screen: 清屏
    edit: 编辑刚才的一句。
    desc/describe: (列出所有列名称)
        用法:  DESCRIBE [schema.]object[@db_link]
    dual: 亚表(虚表)，临时用。如: desc dual；／from dual；
    rollback: 回溯，回溯到上次操作前的状态，把这次事务操作作废，只有一次(DDL和DCL语句会自动提交，不能回溯)。
        可以用commit语句提交，这样就回溯不回了。
    set pause on\off : 设置分屏(设置不分屏)
    set pause "please put an enter key" 且 set pause on: 设置带有提示的分屏
    oerr ora 904 : 查看错误
    set head off : 去掉表头
    set feed off : 去掉表尾
    保存在oracle数据库中的所有操作细节:
        spool oracleday01.txt : 开始记录
        spool off : 开始保存细节
     SQL server的变量:
        申明变量:  declare @i int  设变量值:  set @i=0
        DECLARE @sql NVARCHAR(4000)  SET @sql = 'SELECT MEMID, NAME'
        SET @sql = @sql + ', ISNULL(STR(AVG(S.POINTS)), ''0'') AS ''平均成绩'' '
        SET @sql = @sql + ' FROM TB_MEMBER '
        PRINT @sql
        EXEC(@sql)
    update 表名 set 字段名=@i,@i=@i+1  --递增效果
    另一递增效果: identity(1,1) --前参数是从多少开始，后参数是增量


四、SELECT语句: 选择操作、投影操作。
select: 从一个或多个表中检索一个或多个数据列。包含信息: 想选择什么表，从什么地方选择。必须要有From子句。(最常用)
        当从多张表里查询的时候，会产生笛卡尔积；可用条件过滤它。
        当两个表有相同字段时必须加前缀，列名前需加表名和“.”，如“s_emp.id”。
    1、用法: SELECT  columns,prod2,prod3<列>  FROM Table1,table2<表名>  分号结束
       如:  select id from s_emp;
           select last_name,name from s_emp,s_dept where s_emp.dept_id=s_dept.id;--列表每人所在部门
           SELECT *  FROM Products;    --检索所有列。
           数据太多时，最好别使用上句，会使DBMS降低检索和应用程序的性能。(*通配符)
    2、对数据类型的列(字段)可进行运算(如加减乘除)。
    3、对列起别名: 有直接起别名，加AS起别名，用双引号起别名等三种方法
       (单引号，引起字符串；双引号，引起别名。起别名有符号，或者区分大小写时，必须用双引号)
        多表查询时，可给表起别名。(给列起别名，列<空格>列别名；给表起别名，表<空格>表别名；)。
        如: Select first_name EMPLOYEES, 12*(salary+100) AS MONEY, manager_id "ID1" From s_emp E;
    4、字段的拼接,可用双竖线(双竖线只能用于select语句里)。不同的DBMS可能使用不同的操作符;拼接的字段同样可以起别名。
        如: Select  first_name ||' '|| last_name || ', '|| title "Employees" From s_emp;

排他锁: Select id,salary  From s_emp where id=1  For Update;
   可以阻止他人并发的修改，直到你解锁。
   如果已有锁则自动退出: Select id,salary From s_emp where id=1 For Update NoWait;
   FOR UPDATE : 可以再加 OF 精确到某格。如:    ... For Update  OF salary ...
   注意要解锁。

五、ORDER BY 子句，排序
Order by: 按某排序列表(默认升序 asc, 由低到高; 可加 desc,改成降序由高到低)
    检索返回数据的顺序没有特殊意义，为了明确地排序用 SELECT 语句检索出的数据，可使用 ORDER BY 子句。
    ORDER BY 子句取一个或多个列的名字。
    对空值，按无穷大处理(升序中，空值排最后；降序中排最前)。
    1、用法: Select prod_id,prod_price,prod_name From Products  Order By  prod_price,prod_name;
      (从左到右执行排序，先排price)
       ORDER BY子句中使用的列将是为显示所选择的列，但是实际上并不一定要这样，用非检索的列排序数据是完全合法的。
       为了按多个列排序，列名之间用逗号分开。
    2、支持按相对列位置进行排序。位置从1开始。
       输入 SELECT prod_id,prod_price,prod_name
       FROM  Products
       ORDER BY 2，3    --(2指price，3指name)
    3、升序、降序。默认是升序(asc，从小到大排序)，想降序时用desc。
       如: SELECT prod_id,prod_price,prod_name FROM  Products ORDER BY prod_price DESC;
      注意: DESC 关键字只应用到直接位于其前面的列名。如果想在多个列上进行排序，必须对每个列指定DESC关键字。
         升序是默认的，可不写，但降序必须写。


六、WHERE子句，选择、过滤
    其后只能跟逻辑语句，返回值只有ture或false
    如:  select last_name,salary from s_emp where salary＝1000;--找出工资1000的人

WHERE子句操作符:
    1、逻辑比较运算符
        ＝        等于
        ！=       不等于，还有(<>  ^=   这两个同样表示不等于)
        >         大于
        >=        大于等于
        <         小于
        <=        小于等于


    2、SQL 比较运算符

    between...and...    : 在两者之间。(BETWEEN 小值 AND 大值)
    NOT  between ...  and ... :指定不包含的范围。
        如: select last_name,salary from s_emp where salary between 1000 and 1500；
          --工资1000到1500的人，包括1000和1500。

    in(列表): 在列表里面的。  in的括号里可包含次查询，即select子句
        如: select last_name,dept_id from s_emp where dept_id in(41,42);第41、42部门的人

    like    :  包含某内容的。模糊查询
        可以利用通配符创建比较特定数据的搜索模式，通配符只能用于文本，非文本数据类型不能使用通配符。
        通配符在搜索模式中任意位置使用，并且可以使用多个通配符。
        通配符%表示任何字符出现任意次数；还能代表搜索模式中给定位置的0个或多个字符。下划线匹配单个任意字符。
        如: select table_name from user_tables where table_name like 'S\_%' escape'\';
        '  找出“S_“开头的,由于下划线有任意字符的含义，故需另外定义转移符。
           但习惯用“\”，为方便其它程序员阅读和检测，一般不改用其它的。
        like 'M%': M开头的        like '_a%': 第二个字符是a的    like '%a%'所有含a的
            (“_”表示一个任意字符；“%”表示任意多个任意字符。)
        如果将值与串类型的进行比较，则需要限定引号；用来与数值列进行比较时，不用引号。

    is null: 是空。(NULL表示不包含值。与空格、0是不同的。)
        如: SELECT prod_name,prod_price FROM Products WHERE prod_price IS NULL;


七、高级检索(逻辑运算符):
    通常我们需要根据多个条件检索数据。可以使用AND或OR、NOT等连接相关的条件
    计算次序可以通过圆括号()来明确地分组。不要过分依赖默认计算次序，使用圆括号()没有坏处，它能消除二义性。

    and: 条件与
       如 SELECT prod_id,prod_price,prod_name FROM Products WHERE prod_price<4 AND vend_id=‘DELL’
    or: 条件或    (注:  and 的优先级比 or 更高，改变优先级可用括号)
       如 SELECT prod_id,prod_price,prod_name FROM Products WHERE prod_price<4 OR vend_id=‘DELL’
    not: 条件非。否定它之后所跟的任何条件
        否定的SQL 比较运算符:  NOT BETWEEN； NOT IN； NOT LIKE； IS NOT NULL:
         (注意，按英语习惯用 is not，而不是 not is)
        NOT 与 IN 在一起使用时，NOT 是找出与条件列表不匹配的行。
        IN 列表里有 NULL 时不处理，不影响结果；用 NOT IN 时，有 NULL 则出错，必须排除空值再运算。
    in : 选择列表的条件
        使用IN操作符的优点:  在长的选项清单时,语法直观； 计算的次序容易管理；
        比 OR 操作符清单执行更快；最大优点是可以包含其它 SELECT 语句，使用能够动态地建立 WHERE 子句。
     如 SELECT prod_id,prod_price,prod_name FROM Products WHERE vend_id IN(‘DELL’,’RBER’,’TTSR’);
     SELECT au_name FROM authors WHERE au_id NOT IN (SELECT au_id FROM titleauthors WHERE royaltyshare < .50);    #找出版税不小于50%的作者.


八、单行函数:
    函数一般在数据上执行，它给数据的转换和处理提供了方便。不同的DBMS提供的函数不同。
    函数可能会带来系统的不可移植性(可移植性:所编写的代码可以在多个系统上运行)。
    加入注释是一个使用函数的好习惯。
    大多数SQL实现支持以下类型的函数:  文本处理， 算术运算， 日期和时间， 数值处理。

    Null: 空值
        空值当成无穷大处理，所有空值参与的运算皆为空。
        空值与空值并不相等，因为空值不能直接运算。
        如: prod_price=""     这种写法是错的(不要受到corejava的影响)
        prod_price=NULL      这种写法是错的(不要受到corejava的影响)
        prod_price IS NULL   这种写法才是对的

    NVL: 处理空值，把空值转化为指定值。可转化为日期、字符、数值等三种(注意: 转化时，两参数必须要同类型)
        在SQL server 里用"ISNULL(需转的数据,转成什么)"函数代替。
        遇到数值要把空转换成字符串的，需先把数值转成字符串类型。
        如: NVL(date, '01-JAN-95')    NVL(title,'NO Title Yet')        NVL(salary,0)
        错误写法:
         Select last_name,title,salary*commission_pct/100 COMM From s_emp;--没提成的人没法显示工资
        正确写法:
         Select last_name,title,salary*NVL(commission_pct,0)/100 COMM From s_emp;--把提成是空值的转化为0
    注意: 在oracle中的 NVL ，在 SQL server 中用 ISNULL。格式相同。

    DISTINCT: 过滤重复
        把重复的行过滤掉；多个字段组合时，只排除组合重复的。
        DISTINCT必须使用列名前，不能使用计算或者表达式。
        所有的聚合函数都可以使用。如果指定列名，则DISTINCT只能用于COUNT(列名)，DISTINCT不能用于COUNT(*)。
        如: Select  Distinct  name  From  s_dept;
                Select Distinct dept_id,title  From s_emp;
        注意: Distinct 配合字段使用时，无法在字段列表里指定非唯一的单元或运算值。配合聚合函数使用时，需把 distinct 放到聚合函数的括号中，而仅对此函数有效。

文本处理:
    TRIM()/LTRIM()/RTIRM(): 去空格。只能去掉头和尾的空格，中间的不理。
         trim('   heo Are  fdou   ')  -->  heo Are  fdou
         输入: select trim('   heo Are  fdou   ')  from dual; -->: heo Are  fdou
    LOWER: 转小写
        lower('SQL Course') --> sql course
    UPPER: 转大写
        upper('    SQL Course') --->SQL COURSE
    INITCAP: 首字母转大写，其余转小写
        initcap('SQL Course') --> Sql Course

    CONCAT: 合成。双竖线只能在select语句里面用，这个可用于任何语句。
        Concat('Good','String') --> GoodString
    SUBSTR: 截取。
        Substr('String', 1 ,3)  --> Str
            第一个数字“1”，表示从第几个开始截取；若要从倒数第几个开始，用负数，如“－2”表示倒数第2个。
            上式中第2个数字“3”表示截取多少个。
    LENGTH: 统计长度。
        Length('String') --> 6
    NVL: 转换空值,上面已有.

日期和时间处理:
    Oracle日期格式: DD-MMM-YYYY        (D代表日期date，M代表月month，Y代表年year)
    如: SELECT prod_name              (DAY表示完整的星期几，DY显示星期的前三个字母)
        FROM Products
        WHERE prod_time BETWEEN
            to_date(’01-JAN-2008’)
        AND to_date(’31-DEC-2008’);
    日期可以进行加减，默认单位是1天。日期与日期可以相减，得出天数；日期与日期但不能相加。

    sysdate   －>  系统的当天
    Months_Between('01-Sep-95','11-Jan-94')  --> 19.774194    相差多少个月,Between里面也可以填函数。
    Add_months('11-Jan-94',6)                -->  11-Jul-94   增加多少个月
    Next_day('01-Sep-95','Friday')   --> '08-Sep-95'    下一个星期五。其中的'Friday'可用6替代，因为星期日＝1
    Last_day('01-Sep-95')            -->  '30-Sep-95'   这个月的最后一天


数值处理: 可以运用于代数，三角，几何
    ROUND: 四舍五入
        Round(45.925,2)  －> 45.93        Round(45.925,0)  －> 46        Round(45.925,-1)  －> 50
        逗号前一个数是要处理的数据源，后一个参数表示保留多少位小数。
        后一参数是负数时，表示舍去小数点前的几位，例3是舍去个位及其后的。不写后一参数时，默认不保留小数。
    TRUNC: 舍去末位。直接舍去，不会进位。
        Trung(45.925,2)  －> 45.92       Trung(45.925,2)  －> 45.92       Trung(45.925,2)  －> 45.92
日期的舍取:


常用的数值处理函数有:
    ABS()    绝对值        ABS(-5741.5854) --> 5741.5854
    PI()     圆周率        注意: oracle中不支持 PI()函数；MYSql 支持PI()函数。
    SIN()    正统值             Oracle还支持COS()、ASIN()、ACOS()函数
    SQRT()   平方根


  转化:
    TO_CHAR(number,'fmt'): 把数值转换成字符串
        显示数字的命令
        9: 正常显示数字；
        0: 显示包括0的数值形式，空位强制补0；
        $: 以美元符号显示货币；
        L: 按当前环境显示相关的货币符号；
        . 和，: 在固定位置出现“.”点 和“，”逗号；不够位时，四舍五入。
       例题: SQL> select 'Order'||To_char(id)||
      2  'was filled for a total of'
      3  ||To_char(total,'fm$9,999,999')
      4  from s_ord
      5  where ship_date ='21-SEP-92';

    TO_NUMBER(char): 把字符转换成数字


十、组函数:
    分组允许将数据分为多个逻辑组，以便能对每个组进行聚集计算。
    Group: 分组
    Group by:分组。(默认按升序对所分的组排序；想要降序要用 order by)可以包括任意数目的列。
        如果嵌入了分组，数据将在最后规定的分组上进行汇总。
        GROUP BY 子句中列出的每个列都必须是检索列或有效的表达式，但不能是聚集函数。
        *如果在 SELECT 中使用表达式，则必须在 GROUP BY 子句中指定相同的表达式，不能使用别名。
        除聚合计算语句外, SELECT 语句中的每个列都必须在 GROUP BY 子句中给出。
        如果分组列中具有 NULL 值，则 NULL 将作为一个分组返回。如果列中有多行 NULL , 它们将分为一组。

    Having: 过滤。分组之后，不能再用 where , 要用 having 选择过滤。 Having 不能单独存在，必须跟在 group by 后面。
        WHERE 在数据分组前进行过滤, HAVING 在数据分组后过滤。
        可以在SQL中同时使用 WHERE 和 HAVING , 先执行 WHERE , 再执行 HAVING 。


      聚合函数:
    AVG:  平均值    (忽略值为NULL的行，但不能用 AVG(*))
    COUNT:计数    (Count(列)不计算空值；但 COUNT(*)表示统计表中所有行数，包含空值)
    MAX: 最大值    (忽略值为 NULL 的行。但有些DBMS还允许返回文本列中的最大值，
                   在作用于文本数据时，如果数据按照相应的列排序，则 MAX()返回最后一行。)
    MIN: 最小值    (忽略值为 NULL 的行。不能用 MIN(*)。一般是找出数值或者日期值的最小值。
                   但有些DBMS还允许返回文本列中的最小值，这时返回文本最前一行)
    SUM: 求和      (忽略值为 NULL 的值。SUM 不能作用于字符串类型，而 MAX()，MIN()函数能。也不能 SUM(*))
               当AVG(*) 与 SUM(*)/COUNT(*) 不相等时，是NULL在作怪。


子查询: 查询语句的嵌套
    可以用于任意select 语句里面，但子查询不能出现 order by。
    子查询总是从内向外处理。作为子查询的SELECT 语句只能查询单个列，企图检索多个列，将会错误。
    如: 找出工资最低的人select min(last_name),min(salary) from s_emp;
       或者用子查询select last_name,salary from s_emp where salary=(select min(salary) from s_emp);

    E-R图: 属性: E(Entity) -R(Relationship)
            * (Mandatory marked 强制的)   强制的非空属性
            o (Optional marked 可选的)    可选属性(可以有值也可以没有)
            #* (Primary marked )         表示此属性唯一且非空

约束: 针对表中的字段进行定义的。
    PK: primary key (主键约束，PK=UK+NN)保证实体的完整性，保证记录的唯一
        主键约束，唯一且非空，并且每一个表中只能有一个主键，有两个字段联合作为主键，
        只有两个字段放在一起唯一标识记录，叫做联合主键(Composite Primary Key)。
    FK: foreign key (外建约束)保证引用的完整性,外键约束,外键的取值是受另外一张表中的主键或唯一值的约束,不能够取其它值,
        只能够引用主键会唯一键的值，被引用的表，叫做parent table(父表)，引用方的表叫做child table(子表);
        child table(子表)，要想创建子表，就要先创建父表，后创建子表，记录的插入也是如此，先父表后子表，
        删除记录，要先删除子表记录，后删除父表记录，
        要修改记录，如果要修改父表的记录要保证没有被子表引用。要删表时，要先删子表，后删除父表。
    U:  UNIQUE key(唯一键 UK)，值为唯一，不能重复。
        在有唯一性约束的列，可以有多个空值，因为空值不相等。
    NN:  NOT NULL ,不能为空。
    DEFAULT : 制定默认值，当使用者没输入时自动补上。
              如: create table tb_score(memid int , courseid int, points numeric(10,1) default 0);
    CHECK:  指定特定字段里能输入的数据。限定数据范围的方法之一。
              如: create table tb_test(memid int, sex varchar(5), points numeric(10,1),
                  CHECK ( points>=0 and points<=100 and sex in ('man', 'women') ) );
    REFERENCES:  该字段的数据值必须存在于被参考的主键表格里，否则拒绝输入。

        数量关系:  一对一关系
                  多对一关系
                  一对多关系
                  多对多关系

    创建用户组表:
        create table t_group ( id int not null, name varchar(30), primary key (id) );  #只为下面举例用。

    外键约束方式:
    1.级联(cascade)方式
      create table t_user ( userid int not null, name varchar(30), groupid int,
             primary key (userid),  /*定义这表的主键 */
             foreign key (groupid) references t_group(id) on delete cascade on update cascade
             /* 上句: 定义外键，groupid 是 t_group表的 id 字段的外键。而且这边groupid的值对应那边的id。
              当t_group表的 id 字段被删除或修改，这里相应的 groupid 跟着被删除或修改。级联删除、级联修改。
              插入时，如果是t_group表的id字段没有的值，无法插入。参照完整性约束不符。
              比如 insert into t_user values (3, 'dai', 3); 如果t_group表的id没有一个是3的，则插入不成功。 */
      );
      -- 建完表后的修改写法(效果同上):
      ALTER TABLE t_user add FOREIGN KEY(userid) REFERENCES t_group(id) on delete cascade on update cascade;
      -- 刪除外键(key 后面的名称得看具体情况)
      ALTER TABLE t_user drop FOREIGN KEY t_user_ibfk_1;

    2.置空(set null)方式
      create table t_user ( userid int not null primary key, name varchar(30), groupid int,
             foreign key (groupid) references t_group(id) on delete set null on update set null
             /* 插入时，同上。如果是t_group表的id字段没有的值，无法插入。参照完整性约束不符。
              当t_group表的 id 字段被删除或修改，这里相应的 groupid 被设为 null 。 */
      );

    3.禁止(no action / restrict)方式
      create table t_user ( id int not null primary key, name varchar(30), groupid int,
             foreign key (groupid) references t_group(id) on delete no action on update no action
             /* 插入时，还是同上。如果参照完整性约束不符则无法插入。
              当t_group表的 id 字段被删除或修改，参照这里相应的 groupid，如果这里有引用，则主表不能删除或修改 */
      );


外键的定义语法:
    [CONSTRAINT symbol] FOREIGN KEY [id] (index_col_name, ...)
        REFERENCES tbl_name (index_col_name, ...)
        [ON DELETE {RESTRICT | CASCADE | SET NULL | NO ACTION | SET DEFAULT}]
        [ON UPDATE {RESTRICT | CASCADE | SET NULL | NO ACTION | SET DEFAULT}]
    该语法可以在 CREATE TABLE 和 ALTER TABLE 时使用，如果不指定 CONSTRAINT symbol，MYSQL会自动生成一个名字。
    ON DELETE 、 ON UPDATE 表示事件触发限制，可设参数:
    RESTRICT(限制外表中的外键改动)
    CASCADE(跟随外键改动)
    SET NULL(设空值)
    SET DEFAULT(设默认值)
    NO ACTION(无动作,默认的,作用同 RESTRICT )



范式:
    好处: 降低数据冗余；减少完整性问题；标识实体，关系和表
    第一范式(First normal form: 1Nf)，无重复的列
            每一个属性表示一件事情。所有的属性都只表示单一的意义，即实体中的某个属性不能有多个值或者不能有重复的属性。
            如果出现重复的属性，就可能需要定义一个新的实体，新的实体由重复的属性构成，新实体与原实体之间为一对多关系。
            在第一范式(1NF)中表的每一行只包含一个实例的信息。
            说明: 第一范式(1NF)是对关系模式的基本要求，不满足第一范式(1NF)的数据库就不是关系数据库。
    第二范式(2N范式)，属性完全依赖于主键
            最少有一个属性要求唯一且非空PK，其它跟他有关联。即要求数据库表中的每个实例或行必须可以被惟一地区分。
            为实现区分通常需要为表加上一个列，以存储各个实例的惟一标识。
    第三范式(3N范式)，非主属性只能依赖于主属性,不能依赖于其它非主属性。
            任何字段不能由其他字段派生出来，它要求字段没有冗余。(解决数据冗余问题,不能存在推理能得出的数据)
    第四范式(4N范式)，在一个多对多的关系中，独立的实体不能存放在同一个表格中
        表不能包含一个实体的两个或多个相互独立的多值因子
    第五范式(5N范式)，表必须可以分解为更小的表,除非那些表在逻辑上拥有与原始表相同的主键

    说明:第二范式(2NF)是在第一范式(1NF)的基础上建立起来的，即满足第二范式(2NF)必须先满足第一范式(1NF)。
         满足第三范式(3NF)必须先满足第二范式(2NF)。其它范式以此类推，即必须先满足前面的所有范式。
         一般情况会做到第三范式。


创建表:  Create Table 表名
        (字段名1 类型(数据长度)(default ...) 约束条件,
        字段名2  类型(数据长度) 约束条件 );
建表的名称:
    必须字母开头；最多30字符；只能使用“A～Z、a～z、0～9、_、$、#”；
    同一目录下不能有同名的表；表名不能跟关键字、特殊含意字符同样。
    如: create table number_1 (n1 number(2,4), n2 number(3,-1), n3 number);
       create table t_sd0808(id number(12) primary key,name varchar(30) not null);
    MySQL的:  create table student (oid int primary key, ACTNO varchar(20) not null unique,
       BALANCE double); --MySQL的number类型分小类了，Oracle只有number，且MySQL的数值型不用定大小
    Oracle的:  create table t_ad (oid number(15) primary key,
       ACTNO varchar(20) not null unique,BALANCE number(20));

建立数据库:  CREATE DATABASE database_name;
定义特定使用者:  CREATE SCHEMA;


INSERT: 插入(或添加)行到数据库表中的关键字。
    插入方式有以下几种: 插入完整的行；插入行的一部分；插入某些查询的结果。
    对于INSERT操作，可能需要客户机/服务器的DBMS中的特定的安全权限。
     插入行(方式一)   INSERT INTO tableName VALUES(2008,’TV’,222.22,’US’);
    依赖于表中定义的顺序，不提倡使用。有空值时需要自己补上。
     插入行(方式二)   INSERT INTO tableName(id,name,price,vend_name) VALUES(2008,’TV’,222.22,’US’);
    依赖于逻辑顺序，会自动补上空值，提倡使用。

    插入检索出的数据: 可以插入多条行到数据库表中
        INSERT INTO products(*,*,*,*)
        SELECT *,*,*,*
        FROM products_copy;
    如果这个表为空，则没有行被插入，不会产生错误，因为操作是合法的。
    可以使用WHERE加以行过滤。

复制表:    将一个表的内容复制到一个全新的表(在运行中创建，开始可以不存在)
    CREATE TABLE 新表名  AS
    SELECT *
    FROM 表名;

    INSERT INTO 与 CREATE TABLE AS SELECT 不同，前者是导入数据，而后者是导入表。
    任何SELECT选项和子句都可以使用，包括WHERE和GROUP BY。
    可利用联接从多个表插入数据。不管从多少个表中检索数据，数据都只能插入到单个表中。

更新数据 UPDATE 语句
            需要提供以下信息: 要更新的表；列名和新值；确定要更新的哪些行的过滤条件。
    UPDATE 表名
    SET    column_name = expression,
           prod_name = ‘NEWCOMPUTER’
    [WHERE  search_conditions];
    --UPDATE 语句中可以使用子查询，使得能用SELECT语句检索出的数据更新列数据。也可以将一个列值更新为 NULL。
    如果没有用where，则指定列的所有单元格都会设成指定值。

删除数据 DELETE 语句
    DELETE FROM  table_name
    WHERE search_conditions ;
    全行删除，不要省略WHERE，注意安全。
    DELETE不需要列名或通配符。删除整行而不是删除列。DELETE是删除表的内容而不是删除表。
    如果想从表中删除所有内容，可以使用 TRUNCATE TABLE 语句 (清空表格)，它更快。

数字字典表:
Sequence:排列。存储物理地址

Rownum:纬列。内存里排序的前N个。(仅 orcal 能用)
    在where语句中，可以用＝1，和<=N 或 <N；但不能用＝N 或 >N。
    因为这是内存读取，没有1就丢弃再新建1。只能从1开始。需要从中间开始时，需二重子rownum语句需取别名。
    经典应用:  Top-n Analysis  (求前N名或最后N名)
          Select [查询列表], Rownum
          From (Select  [查询列表(要对应)]
                   From 表
                   Order by  Top-N_字段)
          Where Rownum <= N   -- 不写这行则全部显示并排名。
    SQL server的用法:
          Select  top N 查询列表
                  From 表
                  Order by  Top-N_字段

分页显示:
    --取工资第5～10名的员工(二重子rownum语句，取别名)
    select * From (
    select id,last_name,salary,Rownum rn
           From (Select id,last_name,salary
                     from s_emp
                     order by salary desc)
    where rownum <= 10)
    where rn between 5 and 10;


View:视图。看到表的一部分数据。
    限制数据访问。简化查询。数据独立性。本质上是一个sql查询语句。
    Create[or Relace][Force|noForce]  View  视图名
         [(alias[,alias]…)]    别名列表
        As subquery
    [With Check Option [Constraint ……]]
    [With Read Only]
    注意: 有些DBMS不允许分组或排序视图，不能有 Order by 语句。可以有 Select 语句。
    删除视图:     DROP VIEW 视图名
    如:   create view Holer_view1  AS
              select memid, name, classname, points
              from tb_member
              where  type = 'student';

              select * from Holer_view1;
              drop view Holer_view1;


Union: 合并表
    Select …   Union   Select…    把两个Select语句的表合并。
    要求两表的字段数目和类型按顺序对应。合并后的表，自动过滤重复的行。
Intersect: 交。    同上例，把两个Select表相交。
Minus: 减。        把相交的内容减去。
not exists        除运算。


EXISTS :  对其后面的查询语句进行“存在性检查”。有传回至少一倏记录，则为“真”。
NOT  EXISTS :  上式的反相。
                 在 WHERE 子句里的 EXISTS 关键词会检查是否有数据符合次查询的限制条件。
      格式:
                 Start  of  SELECT,  INSERT,  UPDATE,  DELETE  statement;  or  subquery
                 WHERE  expression  comparision_operator  EXISTS (subquery)
                 [End  of  SELECT,  INSERT,  UPDATE,  DELETE  statement;  or  subquery]


修改表结构: Alter Table

添加字段(列):
    Alter Table 表名
    Add (column dataype [Default expr][Not Null]
         [,column datatype]…);
    添加有非空限制的字段时，要加Default语句
    字段名字不可以直接改名，需要添加新字段，再复制旧字段后删除旧字段。
      添加约束:     Alter Table 表名
                  Add [CONSTRAINT constraint] type (column);
    添加非空约束时，要用Modify语句。
    查看约束名时，可以违反约束再看出错提示；或者查看约束字典desc user_constraints

减少字段:
    Alter Table 表名
    Drop (column [,column]…);
      删除约束:     Alter Table 表名
                  Drop CONSTRAINT  column;
      或:    Alter Table 表名
            Drop  Primary Key  Cascade;

暂时关闭约束，并非删除:
    Alter Table 表名
    Disable CONSTRAINT  column  Cascade;
打开刚才关闭的约束:
    Alter Table 表名
    Enable  CONSTRAINTcolumn;

修改字段:
    Alter Table 表名
    Modify  (column dataype [Default expr][Not Null]
             [,column datatype]…);
修改字段的类型、大小、约束、非空限制、空值转换。

删除表:
会删除表的所有数据，所有索引也会删除，约束条件也删除，不可以roll back恢复。
    Drop Table 表名 [Cascade Constraints];
    加 [Cascade Constraints] 把子表的约束条件也删除；但只加 [Cascade]会把子表也删除。



改表名:
Rename 原表名 To 新表名;

清空表格:
    TRUNCATE TABLE 表名;
    相比Delete,Truncate Table清空很快，但不可恢复。清空后释放内存。
    Delete 删除后可以roll back。清空后不释放内存。


事务(交易) Transaction
    [begin transaction statement]
       SQL statement
       SQL statement
    rollback transaction statement
       SQL statement
    commit transaction statement



SQL server创建临时表:
  select identity(int,1,1) as order_num, * into tem  from tb_member
  select * from tem   --"*"需要对应上行的"*"，即需对应列
  drop table tem


ORACLE 设置环境变量:
   ORACLE_SID=oral10g\    --变局部变量
   export ORACLE_SID      --变全局变量
   unset ORACLE_SID       --卸载环境变量
   ORACLE_HOME=...        --安装路径；直接用一句语句也可以，如下
   export ORACLE_HOME=/oracledata/.../bin:


SQL Server 创建用户
 --建立登录帐号
   sp_addlogin   userName, password, userdatabase
   sp_AddUser 'useName'
 --授权访问
   sp_grantdbaccess   userName
  --指定权限
   grant {all|Insert|......}  to  userName
   grant select, insert, delete on tableName to userNameOrGroupName --指定到某张表

SQL Server 修改字符集
    alter database test01 collate Chinese_PRC_CI_AI -- 改成简体中文(默认unicode编码)

SQL Server 查看版本
    1.运行： select @@Version;  或者: print @@version;  -- 8.00.2039表示安装了SP4，8.00.760表示安装了SP3
    2.在添加或删除程序中查看 SQL Server 的支持信息，可直接查看到版本号
    3.在安装目录下(默认是“C:\Program Files\Microsoft SQL Server”)的 “MSSQL\Binn\sqlserver.exe”右键可查看


查看 oracle 表结构:
   1.在 SQLPLUS中，直接用 DESC[ribe] tablename 即可。
     可要是在外部应用程序调用查看ORACLE中的表结构时，这个命令就不能用了。
     只能用下面的语句代替:
   2.看字段名与数据类型
      select * from user_tab_columns WHERE TABLE_name = upper('表名'); //查看全部列
     查看某些列
      select column_name,data_type,data_length,DATA_PRECISION,DATA_SCALE
        from all_tab_columns where table_name=upper('表名');
   3.可以通过 user_constraints 查看所有约束
      select * from user_constraints where table_name = upper('表名');
     查看主键约束:
      select * from user_constraints where constraint_type='P' and TABLE_name=upper('表名');

  在系统表: all_tables / user_tables 中有所有表的信息
  在系统表: all_tab_columns / user_tab_columns 中有所有表的字段信息

    select * from tab/dba_tables/dba_objects/cat;
    看用户建立的表 :
    select table_name from user_tables;  //当前用户的表
    select table_name from all_tables;  //所有用户的表
    select table_name from dba_tables;  //包括系统表
    select * from user_indexes //可以查询出所有的用户表索引

    查所有用户的表在 all_tables
    主键名称、外键在 all_constraints
    索引在 all_indexes
    但主键也会成为索引，所以主键也会在all_indexes里面。
    具体需要的字段可以DESC下这几个view，dba登陆的话可以把all换成dba


    1、查找表的所有索引（包括索引名，类型，构成列):
    select t.*,i.index_type from user_ind_columns t,user_indexes i where t.index_name = i.index_name and t.table_name = i.table_name and t.table_name = 要查询的表
    2、查找表的主键（包括名称，构成列):
    select cu.* from user_cons_columns cu, user_constraints au where cu.constraint_name = au.constraint_name and au.constraint_type = 'P' and au.table_name = 要查询的表
    3、查找表的唯一性约束（包括名称，构成列):
    select column_name from user_cons_columns cu, user_constraints au where cu.constraint_name = au.constraint_name and au.constraint_type = 'U' and au.table_name = 要查询的表
    4、查找表的外键（包括名称，引用表的表名和对应的键名，下面是分成多步查询):
    select * from user_constraints c where c.constraint_type = 'R' and c.table_name = 要查询的表
    查询外键约束的列名:
    select * from user_cons_columns cl where cl.constraint_name = 外键名称
    查询引用表的键的列名:
    select * from user_cons_columns cl where cl.constraint_name = 外键引用表的键名
    5、查询表的所有列及其属性
    select t.*,c.COMMENTS from user_tab_columns t,user_col_comments c where t.table_name = c.table_name and t.column_name = c.column_name and t.table_name = 要查询的表


查看 MySQL 表结构:
    desc 表名;
    describe 表名;
    show columns from 表名;
    show create table 表名;
    select * from information_schema.columns where table_name='表名';

查看 SQL SERVER 表结构:
    SELECT * from   user_cons_columns;
    select COLUMN_NAME from all_cons_columns a, all_constraints b
      where a.CONSTRAINT_NAME=b.CONSTRAINT_NAME and b.CONSTRAINT_TYPE= 'P' AND b.TABLE_NAME='你的表名';



判断空值及转换:
    下面，如果 orders表的 字段price 为null的话，用0.0替换
    SQL Server: select isnull(price,0.0) from orders
    Oracle:     select nvl(price,0.0)    from orders
    MySQL:      select ifnull(price,0.0) from orders
    通用:       select if(price is null, 0.0, price) from orders

    另外，判断条件的 is not null，is null 都一样
    select * from orders where price is not null


实例:
    1. 多重查询( 基于MySQL )
    select count(*) as allNums, sum(isFillIn) as Fillin, sum(if(98Nums=3 or (98Nums=2 and it102 != 0),1,0)) as 98Num3
    from (
        select case item298 when 0 then 1 else 0 end isFillIn, case item298 when -2 then 1 else 0 end isSuspend,
        if(isnull(left(a.item250,1)) or ifnull(item298,-2)<>0,0,left(a.item250,1)) as 98Nums
         FROM ft_running_status AS a where a.years=98 "
    ) f

    select '期初餘額' as type, (a.amt + b.amt) as inAmt
    from (
        (select if(sum(amt) is null,0, sum(amt)) as amt from ev_cash where type=1 and iodate < '2010/06/26') as a,
        (select if(sum(amt) is null,0, sum(amt)) as amt from ev_atm where tdate < '2010/06/26') as b
    )

    2. 找领导: (member表,manager_id表示领导id)
     select id,last_name from member out where exists (select 'x' from member where manager_id = out.id);
     或者(效率低点): select id,last_name from member out where id in (select manager_id from member);

    3. IF 条件 ( 仅MySQL 测试过,其他未测试 )
    -- 如果 表1 里面有 custid='TW00' 的资料,则只查询此一笔资料;否则查询所有资料
    select * from 表1 where if(exists (select 'V' from 表1 where custid='TW00'), custid='TW00',1=1 )

    4.将纵列改成横排:
      表tb_score: create table tb_score(memid varchar(20) , classid varchar(20), points numeric(10,2) )

     select distinct memid,
      (select points from tb_score where classid='1001'  and memid=s.memid ) JAVA,
      (select points from tb_score where classid='1002'  and memid=s.memid) SQL,
      (select points from tb_score where classid='1003'  and memid=s.memid) JSP,
      (select points from tb_score where classid='1004'  and memid=s.memid) C
    from tb_score s

   5. case 用法:
    select MEM_ID, NAME, AVGPOINT,
      (case type when 'student' then '学生' when 'teacher' then '老师' else '其它' end ) 'type',
      (case when (sex='m') then '男' else '女' end ) as 'sex'
    from tb_member

    case + count : count里可用条件语句
     select count(*) as '总数',  count(case when item248 <= 79 then 1 end) as '79前'
     from table1 where item248 is not null and item298=0;

   6. 一次性更新多笔记录:
    update ft_running_status as f set f.item11 = (select (case e.country when 2 then _utf8'美國'
     when 3 then _utf8'加拿大' when 4 then _utf8'其他' else _utf8'本國' end)
     from enterprise as e where e.id=f.item5)

   7.多表更新
    -- 更新東琳有,中壢也有的貨品,改貨品數量(多表同时update,方便复杂的条件)
    update ev_inventory a, ev_inventory b set a.nowqty = a.nowqty+b.nowqty
      where a.wid='中壢' and a.pid=b.pid and b.wid='東琳';


   10. 随机取值
    1、SQL server
       select top 10 * from 表名 order by newid();
    2、Access
       SELECT top 10 * FROM 表名 order by rnd(id); -- id:为你当前表的ID字段名
    3、MySQL
       SELECT * FROM 表名 order by rand() limit 10;
    4、Oracle
       select * from (select object_name from 表名 order by dbms_random.random) where rownum<6; -- 随机取 5 条
       select * from (select OBJECT_NAME from 表名 order by sys_guid()) where rownum < 6;
       -- 使用 sys_guid() 方法时,有时会获取到相同的记录，它并不保证一定是随机。
       -- 为确保随机,大多采用sample函数或者DBMS_RANDOM包获得随机结果集, 其中使用sample函数更常用, 因为其缩小了查询范围, 效率高。

       -- 从表中“全表扫描”随机抽取10%的记录，随机查询5条记录
       SELECT object_name FROM 表名 sample(10) WHERE rownum<6;
       -- 从表中“采样表扫描”随机抽取10%的记录，随机查询5条记录
       SELECT object_name FROM 表名 sample block(10) WHERE rownum<6;
       -- 使用seed, 返回固定的结果集。从表中“采样表扫描”随机抽取10%的记录，随机查询5条记录。
       select object_name from 表名 sample(10) seed(10) where rownum<6;

       select dbms_random.value() from dual; -- 取随机数, 返回 0~1 之间的值
       select dbms_random.value(1,10) from dual; -- 取随机数, 返回 1~10 之间的浮点数
       select trunc(dbms_random.value(0, 1000)) randomNum from dual; -- (0~1000的整数)

    11. 查询自增主键( MySQL, Sql Server )
	SELECT LAST_INSERT_ID(); -- MySQL 专用
	SELECT @@identity; -- Sql Server 及 MySQL 通用

    12.查询字段是否含有汉字
      Oracle
        select * FROM 表 WHERE LEN(字段)<>DATALENGTH(字段);
        select * from 表 where 字段 like '%[吖-座]%'; -- 正则比较强大
      MySQL
        select * FROM 表 WHERE LENGTH(字段) != CHAR_LENGTH(字段);
