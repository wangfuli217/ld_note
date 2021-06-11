本笔记只记录 MySQL 数据库与其它数据库的不同点，相同的不记录

常用SQL:
  0.远程连接 MySQL:
      MySQL -u用户名 -p密码 -h机器名或者IP -P端口号 -D数据库名
      MySQL -uroot -proot -h127.0.0.1 -P3306 -DEXEC_DB
      客户端显示正常编码: SET NAMES UTF8; / SET NAMES GBK;

  1.建表前检查语句:
    drop table if exists 表名 DEFAULT CHARACTER SET utf8;

  2.建表语句:
    CREATE TABLE if not exists `表名` (
      `id` int(10) unsigned NOT NULL auto_increment, -- 自增
      `playlist_id` int(10) NOT NULL, -- 整形
      `vuchnl_provider_id` int(10) unsigned NOT NULL default '4', -- 非负整型
      `display_order` smallint(5) unsigned NOT NULL,
      `circle_code` varchar(8) character set utf8 NOT NULL default '-', -- 字符串
      `status` enum('active','inactive') character set utf8 NOT NULL default 'active', -- 枚举
      `video_start_date` timestamp NOT NULL default '0000-00-00 00:00:00', -- 日期和时间
      `daily_start_time` time NOT NULL default '00:00:00', -- 时间(没有日期)
      `update_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP, -- 更新时间(更新时自动变值)
      PRIMARY KEY  (`vuchnl_category_playlist_id`), -- 主键
      UNIQUE KEY `vuchnl_category_id_2` (`vuchnl_category_id`,`circle_code`,`status`,`playlist_type`,`playlist_id`), -- 联合唯一键
      KEY `vuchnl_provider_id` (`vuchnl_provider_id`) -- 外键
    ) ENGINE=MyISAM DEFAULT CHARSET=latin1in1;

  3.复制表:
    SHOW TABLES LIKE '表名'; -- 按表名查询是否有这个表
    CREATE TABLE 新表名 LIKE 原表名; -- 复制一张表的结构,内容不复制
    INSERT INTO 新表名 SELECT * FROM 原表名; -- 复制所有旧表的内容到新表(可以加上条件,仅复制部分,表格备份时经常用这两句)
    CREATE TABLE 新表名 AS SELECT * FROM 旧表名; -- 仅复制数据,没复制表结构(自增主键等不会复制)

  4.查询表结构：
    desc `表名`; -- 显示表结构。
    show create table `表名`; -- 会显示出创建表的语句,所有 key 表字段都一目了然。比 desc 命令详细。
    show table status like '表名'; -- 查看表的使用情况，如有多少行数据

  5.查看正在执行的SQL：
    show processlist;


Index:索引。依附于表，为提高检索速度。
    index(索引)是数据库特有的一类对象，实际应用中一定要考虑索引，view(示图)
    复合索引 composite indexes;   唯一性索引 unique indexes;   群集索引 clustered index;
    CREATE  [UNIQUE]  INDEX  index_name   ON  table_name (column_name) ;
    DROP  INDEX  index_name;

    MySQL:
    1. 普通索引
       最基本的索引，它没有任何限制，比如上文中为title字段创建的索引就是一个普通索引。

       -- 直接创建索引
       CREATE INDEX indexName ON tableName(column [, column]…);
       -- 修改表结构的方式添加索引
       ALTER TABLE 表名 ADD INDEX 索引名 (column [, column]…);
       -- 删除索引
       DROP INDEX indexName ON table

    2. 唯一索引
       与普通索引类似，不同的就是：索引列的值必须唯一，但允许有空值（注意和主键不同）。如果是组合索引，则列值的组合必须唯一，创建方法和普通索引类似。

       -- 创建唯一索引
       CREATE UNIQUE INDEX indexName ON tableName(column [, column]…)
       -- 修改表结构
       ALTER TABLE tableName ADD UNIQUE INDEX [索引名](column [, column]…)
       -- 添加PRIMARY KEY（主键索引）
       ALTER TABLE table_name ADD PRIMARY KEY (column)

    3. 全文索引（FULLTEXT）
       MySQL从3.23.23版开始支持全文索引和全文检索，FULLTEXT索引仅可用于 MyISAM 表；他们可以从CHAR、VARCHAR或TEXT列中作为CREATE TABLE语句的一部分被创建，或是随后使用ALTER TABLE 或CREATE INDEX被添加。
       对于较大的数据集，将你的资料输入一个没有FULLTEXT索引的表中，然后创建索引，其速度比把资料输入现有FULLTEXT索引的速度更为快。不过切记对于大容量的数据表，生成全文索引是一个非常消耗时间非常消耗硬盘空间的做法。

       -- 修改表结构添加全文索引
       ALTER TABLE article ADD FULLTEXT index_content(content)
       -- 直接创建索引
       CREATE FULLTEXT INDEX index_content ON article(content)

    4. 单列索引、多列索引
       多个单列索引与单个多列索引的查询效果不同，因为执行查询时，MySQL只能使用一个索引，会从多个索引中选择一个限制最为严格的索引。

    5. 组合索引（最左前缀）
       平时用的SQL查询语句一般都有比较多的限制条件，所以为了进一步榨取MySQL的效率，就要考虑建立组合索引。
       例如上表中针对title和time建立一个组合索引：
       ALTER TABLE article ADD INDEX index_titme_time (title(50),time(10))。
       建立这样的组合索引，其实是相当于分别建立了下面两组组合索引：
        –title,time
        –title
       为什么没有time这样的组合索引呢？这是因为MySQL组合索引“最左前缀”的结果。简单的理解就是只从最左面的开始组合。

       -- 创建表的时候同时创建索引
       CREATE TABLE `table` (
        `id` int(11) NOT NULL AUTO_INCREMENT ,
        `title` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
        `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
        `time` int(10) NULL DEFAULT NULL ,
        PRIMARY KEY (`id`),
        INDEX indexName (title(length)), -- 普通索引
        UNIQUE indexName (title(length)), -- 唯一索引
        FULLTEXT (content), -- 全文索引
       );

    6. 根据sql查询语句确定创建哪种类型的索引，如何优化查询
    　　选择索引列：
    　　a.性能优化过程中，选择在哪个列上创建索引是最重要的步骤之一。可以考虑使用索引的主要有
      　　两种类型的列：在where子句中出现的列，在join子句中出现的列。
    　　b.考虑列中值的分布，索引的列的基数越大，索引的效果越好。
    　　c.使用短索引，如果对字符串列进行索引，应该指定一个前缀长度，可节省大量索引空间，提升查询速度。
    　　d.利用最左前缀
    　　e.不要过度索引，只保持所需的索引。每个额外的索引都要占用额外的磁盘空间，并降低写操作的性能。

    　　在修改表的内容时，索引必须进行更新，有时可能需要重构，因此，索引越多，所花的时间越长。
    　　MySQL只对一下操作符才使用索引：<,<=,=,>,>=,between,in,
    　　以及某些时候的like(不以通配符%或_开头的情形)。


修改MySQL的字符集:
   安装目录下找到“my.ini”，设置“default-character-set=utf8”重启MySQL生效
   可设成: gbk,gb2312,big5,utf8
   通过MySQL命令行修改:
   mysql> set character_set_client=utf8;
   mysql> set character_set_connection=utf8;
   mysql> set character_set_database=utf8;
   mysql> set character_set_results=utf8;
   mysql> set character_set_server=utf8;
   mysql> set character_set_system=utf8;
   mysql> set collation_connection=utf8;
   mysql> set collation_database=utf8;
   mysql> set collation_server=utf8;
   查看其字符集: show variables like 'character%';

   修改数据库的字符集
   mysql>use mydb
   mysql>alter database mydb character set utf8;
   创建数据库指定数据库的字符集
   mysql>create database mydb character set utf8; --ft_running_status
   查看某表的字符集: show create table 表名;
   修改某表的字符集: ALTER TABLE 表名 DEFAULT CHARSET utf8;


MySql用户创建、授权以及删除
    mysql> CREATE USER 用户名 IDENTIFIED BY '密码';  -- 填上想要的用户名密码即可
     上面建立的用户可以在任何地方登陆。
     如果要限制在固定地址登陆，比如localhost 登陆:
    mysql> CREATE USER 用户名@localhost IDENTIFIED BY '密码';
    -- localhost 可换上任意ip地址，“%”表示任意地址

    若需要授权，用 grant:
    格式: grant select on 数据库.* to 用户名@登录主机 identified by "密码";
    如: mysql> GRANT ALL PRIVILEGES ON *.* TO 用户名@登录主机;
    如: mysql> grant select,insert,update,delete on *.* to utest1@"%" Identified by "abc";

    修改密码:
    mysql> grant all privileges on 数据库.* to utest1@localhost identified by 'mimi';

    flush:
    mysql> flush privileges;

    查看用户信息:
    mysql> select host,user from mysql.user;

    注: 创建用户时，如果提示“table 'user' is read only”，则需要在控制台运行:
    "安装目录下\bin\mysqladmin" -u<用户名> -p<密码> flush-tables



查看 MySQL 表结构:
    desc 表名;
    describe 表名;
    show columns from 表名;
    show create table 表名;
    select * from information_schema.columns where table_name='表名';


MySQL 注释符号:
       #  单行注释
       -- 单行注释
       /* ... */ 多行注释

MySQL 的大小写的:
      MySQL 的查询默认是不区分大小写的 如:
       select * from table_name where a like 'a%'
       select * from table_name where a like 'A%'
      效果是一样的。

      要让mysql查询区分大小写，可以:
       select * from table_name where binary a like 'a%'
       select * from table_name where binary a like 'A%'
      也可以在建表时，加以标识
       create table table_name(a varchar (20) binary);


MySQL 查询时使用变量:
    如果查询时需要用变量,而又不希望用存储过程,可以直接使用临时变量(仅本次连结有效)
    变量以“@”开头,赋值时用“:=”符号; 事先可以不需声明而直接使用,只是初始值为空
    如: (注意:第一次使用时,值为空,故需要用 ifnull 函数)
     Select openaccount, iodate, amt as inAmt, 0 as outAmt, @a:=ifnull(@a,0)+amt as _sum
      From ev_cash where type=1 and openaccount={?OpenAccount} And iodate between '{?StartDate}' and '{?EndDate}'
     union
     Select openaccount, iodate, 0 as inAmt, amt as outAmt, remark, @a:=@a-amt as _sum
      From ev_cash where type=2 and openaccount={?OpenAccount} And iodate between '{?StartDate}' and '{?EndDate}'


MySQL 存储过程:
    一个存储过程包括名字，参数列表，以及可以包括很多SQL语句的SQL语句集。
    在这里对局部变量，异常处理，循环控制和IF条件句有新的语法定义。
    在5.0以上版本可用存储过程，检查版本可用语句:  SHOW VARIABLES LIKE 'version'; 或者 SELECT VERSION();

    CREATE PROCEDURE procedure1                      /* name 存储过程名 */
    (IN parameter1 INTEGER)                          /* parameters 参数 */
    BEGIN                                            /* start of block 语句块头 */
       DECLARE variable1 CHAR(10);                   /* variables变量声明, 一定要在開頭的語句 */
       IF parameter1 = 17 or parameter1 > 50 THEN    /* start of IF IF条件开始 */
        SET variable1 = 'birds';                     /* assignment 赋值 */
        SET variable1 = 'ddd';                       /* assignment 操作語句2,這裡只為模擬 */
       ELSE
        SET variable1 = 'beasts';                    /* assignment 赋值 */
       END IF;                                       /* end of IF IF结束 */
        INSERT INTO table1 VALUES (variable1);       /* statement SQL语句 */
    END                                              /* end of block 语句块结束 */


    最简单的存储过程:
    CREATE PROCEDURE p1() SELECT * FROM tableName;
    呼叫它:   CALL p1();

    注意:
    1. 存储过程名对大小写不敏感。
    2.在同一个数据库不能给两个存储过程取相同的名字，否则会导致重载。MySQL还不支持重载(希望以后会支持。)
    3.可以采取“数据库名.存储过程名”，如“db5.p1”。存储过程名可以分开，它可以包括空格符，其长度限制为64个字符
    4.但注意不要使用MySQL内建函数的名字，否则将会出错。


    Pick a Delimiter 选择分隔符:
        DELIMITER //                                 /* 也可以用“|”或“@”符号 */
        如果以后要恢复使用“;”(分号)作为分隔符，只需输入:  DELIMITER ;//
    用法如(使用“$$”作为分隔符):
        DELIMITER $$
        drop procedure if exists ff $$
        CREATE PROCEDURE `ff`()
        BEGIN
            declare i integer; # 临时变量
            set i=1;
            # 循环
            while i <=10 do
            begin
                #操作
                set i=i+1; # 递增量
            end;
            end while;
        END $$
        DELIMITER ;$$   # 恢复分号作分隔符


MySQL 存储过程 循环
    在MySQL存储过程的语句中有三个标准的循环方式：
    WHILE 循环, LOOP 循环 以及 REPEAT 循环。
    还有一种非标准的循环方式:GOTO,不过这种循环方式最好别用，很容易引起程序的混乱。

    这几个循环语句的格式如下：
    WHILE……DO……END WHILE
    REPEAT……UNTIL END REPEAT
    LOOP……END LOOP
    GOTO。

    # 示例(WHILE 循环)
    create procedure pro10()
    begin
        declare i int;
        set i=0; # 这句为了防止一个常见的错误，如果没有初始化，i默认变量值为NULL，而NULL和任何值操作的结果都是NULL。
        while i<5 do # 当变量i大于等于5的时候就退出循环
            insert into t1(filed) values(i);
            set i=i+1;
        end while;
    end;//

    # 示例(REPEAT 循环)
    create procedure pro11()
    begin
        declare i int default 0;
        repeat
            insert into t1(filed) values(i);
            set i=i+1;
            until i>=5 # 检查是否满足循环条件。注意 until i>=5 后面不要加分号，如果加分号，就是提示语法错误。
        end repeat;
    end;//

    # 示例(LOOP 循环)
    create procedure pro12()
    begin
        declare i int default 0;
        loop_label: loop # 设 LOOP 循环 的标号为 loop_label
            insert into t1(filed) values(i);
            set i=i+1;
            if i>=5 then
                leave loop_label; # LEAVE语句的意思是离开循环，LEAVE的格式是：LEAVE 循环标号。
            end if;
        end loop;
    end;//


    # 真实案例
    -- 按 type 和 uid 分表(按 type 类型分4类表, 按 uid 的最后一位分 10 张表, 总共分 40 张表)
    DROP PROCEDURE IF EXISTS pro_tem;
    CREATE PROCEDURE pro_tem()
    BEGIN
        declare t integer; # 临时变量
        declare u integer; # 临时变量
        set t=1;
        -- 两重循环,建40个表
        while t <=4 do
            set u=0;
            while u <10 do
                #操作语句
                SET @sql = CONCAT("CREATE TABLE `contacts_t", t, "_u", u, "` LIKE `auto_contacts`");
                PREPARE stmt1 FROM @sql;
                -- 执行字符串
                EXECUTE stmt1;
                -- 删除临时变量 stmt1
                DEALLOCATE PREPARE stmt1;
                set u=u+1; # 递增量
            end while;
            set t=t+1; # 递增量
        end while;
    END;
    -- 运行存储过程
    CALL pro_tem();
    -- 删除运行存储过程
    DROP PROCEDURE IF EXISTS pro_tem;



MySQL 存储过程 影响的行数:
    select FOUND_ROWS();  # select 读取的行数
    select ROW_COUNT();   # update delete insert 等操作所影响的行数
    注意: 只能在存储过程中使用，仅能读取上一次的影响行数


  mysql 执行字符串的sql语句:
    mysql> PREPARE stmt1 FROM 'SELECT SQRT(POW(?,2) + POW(?,2)) AS hypotenuse';
    mysql> SET @a = 3;
    mysql> SET @b = 4;
    mysql> EXECUTE stmt1 USING @a, @b;

    没参数的:
    mysql> PREPARE stmt1 FROM 'SELECT * from articalinfo';
    mysql> EXECUTE stmt1

    执行完的sql删除的时候用下面的语句:
    mysql> DEALLOCATE PREPARE stmt1;


mysql 创建表时:
        CREATE TABLE IF NOT EXISTS tableName (
          `item1` date NOT NULL COMMENT '记录日期',
          `item2` varchar(50) default NULL,
          `item3` int(10) unsigned NOT NULL,
          PRIMARY KEY  (`item2`)
        ) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
        # ENGINE=MyISAM 表示不支持事务，ENGINE=InnoDB 支持事务。 DEFAULT CHARSET=utf8 默认字符集

windows控制台执行MySQL:
        运行 cmd，输入:  绝对路径的MySQL安装目录\bin\mysql.exe -h192.168.0.133 -uroot -p13726402698
        有mysql的环境变量时可运行 cmd，输入:  mysql -h192.168.0.133 -uroot -p13726402698
        参数说明:  -h地址(不输入这个时，默认本机localhost)， -u用户名， -p密码
        在安装目录下，写一个“mysql-startup.cmd”的文件，内容为“"bin\mysql" -uroot -proot -h127.0.0.1”,双击运行即可

mysql 备份与恢复用法
        运行 cmd，输入:  绝对路径的MySQL安装目录\bin\mysqldump.exe -h192.168.0.133 -uroot -proot ftc > D:\ftc.sql
        有mysql的环境变量时可运行 cmd，输入:  mysqldump -h192.168.0.133 -uroot -proot ftc > D:\ftc.sql
        参数说明:  -h地址(不输入这个时，默认本机localhost)， -u用户名， -p密码， 数据库名称 > 导出文件的路径和名称
        在安装目录下，写一个“mysqldump.cmd”的文件，内容为“"bin\mysqldump" -h127.0.0.1 -uroot -proot ftc > ftc.sql”,双击运行即可将“ftc”数据库导出到当前目录下

  详细说明:
        1.导出整个数据库: mysqldump -u用戶名 -p密码 数据库名称 > 导出文件的路径和名称
        2.导出一个表:     mysqldump -u用戶名 -p密码 数据库名称 表名> 导出文件的路径和名称
        3.导出一个数据库结构: mysqldump -u用戶名 -p密码 -d --add-drop-table 数据库名称 > 导出文件的路径和名称
          -d 没有数据 --add-drop-table 在每个create語句之前增加一个drop table
        4.导出整个数据库: mysqldump -u用戶名 -p密码 数据库名称   # 不写“>”则是屏幕显示,而非导出文件

   导入数据库:
      方法一,进入mysql的控制台后，使用 source 命令执行
        mysql>use 数据库;
        mysql>source 导出文件的路径和名称
        如: mysql>source d:\wcnc_db.sql

      方法二 使用cmd命令执行(以windows为例，unix或linux的在其类似的控制台下运行)
        格式：【Mysql的bin目录】\mysql –u用户名 –p密码 –D数据库<【sql脚本文件路径全名】
        示例：D:\mysql\bin\mysql –uroot –p123456 -Dtest<d:\test\ss.sql
        注意事项：
          1、如果在sql脚本文件中使用了 use 数据库，则-D数据库选项可以忽略
          2、如果【Mysql的bin目录】中包含空格，则需要使用“”包含，如：
            “C:\Program Files\mysql\bin\mysql” –u用户名 –p密码 –D数据库<【sql脚本文件路径全名】
          3、如果需要将执行结果输出到文件，可以采用以下模式
              D:\mysql\bin\mysql –uroot –p123456 -Dtest<d:\test\ss.sql>d:\dd.txt


MYSQL的事务处理
  1、用begin,rollback,commit来实现
       begin    开始一个事务
       rollback 事务回滚
       commit   事务确认
   2、直接用set来改变mysql的自动提交模式
       MYSQL默认是自动提交的，也就是你提交一个QUERY，它就直接执行！我们可以通过
     set autocommit=0  禁止自动提交
     set autocommit=1 开启自动提交
   但注意当你用 set autocommit=0 的时候，你以后所有的SQL都将做为事务处理，直到你用commit确认或rollback结束，注意当你结束这个事务的同时也开启了个新的事务！按第一种方法只将当前的作为一个事务！
   MYSQL中只有INNODB和BDB类型的数据表才能支持事务处理！其他的类型是不支持的！（切记！)

    show processlist  -- mysql 查看SQL语句操作的耗时


判断空值及转换:
    下面，如果 orders表的 字段price 为null的话，用0.0替换
    SQL Server: select isnull(price,0.0) from orders
    Oracle:     select nvl(price,0.0)    from orders
    MySQL:      select ifnull(price,0.0) from orders
    通用:       select if(price is null, 0.0, price) from orders

    另外，判断条件的 is not null，is null 都一样
    select * from orders where price is not null


实例:
    0.select * from tableName limit 10\G
    使用“\G”结尾的查询语句，会让查询结果按列换行显示，当列很多或者一列的内容很长时显示效果很好。

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
    -- 更新東琳有,中壢也有的貨品,改貨品数量(多表同时update,方便复杂的条件)
    update ev_inventory a, ev_inventory b set a.nowqty = a.nowqty+b.nowqty
      where a.wid='中壢' and a.pid=b.pid and b.wid='東琳';

   8.update的select子查詢裡面使用自身表(MySQL)
    -- 建立臨時表,因為同一个表没法在update的select子查詢裡面使用
    drop table if EXISTS tem_inventory;
    CREATE TABLE tem_inventory  AS  SELECT *  FROM ev_inventory where wid='東琳' or wid='中壢';

    -- 更新東琳有,而中壢没有的貨品,直接改倉庫ID即可
    update ev_inventory a set a.wid='中壢' where a.wid='東琳' and a.pid not in(
      select b.pid from tem_inventory b where b.wid='中壢'
    );

    -- 刪除臨時表
    drop table if EXISTS tem_inventory;

   9. MySQL 查询及删除重复记录的方法
    1、查找表中多余的重复记录，重复记录是根据单个字段(pId)来判断(查询出所有重复的资料)
    select * from 表1
    where pId in (select pId from 表1 group by pId having count(*) > 1);

    2、删除表中多余的重复记录，重复记录是根据单个字段(pId)来判断，只留有rowid最小的记录
    delete from 表1
    where pId in (select pId from 表1 group by pId having count(*) > 1)
    and pId not in (select min(pId) from 表1 group by pId having count(*)>1);
    -- 建立唯一键来限制也可以,只是会改变表结构
    ALTER IGNORE TABLE 資料表 ADD UNIQUE INDEX(字段1,字段2);

    3、查找表中多余的重复记录(多个字段)
    select * from 表1 a
    where (a.pId, a.seq) in (select pId, seq from 表1 group by pId,seq having count(*) > 1);

    4、删除表中多余的重复记录(多个字段)，只留有rowid最小的记录
    delete from 表1 a
    where (a.pId,a.seq) in (select pId,seq from 表1 group by pId,seq having count(*) > 1)
    and rowid not in (select min(rowid) from 表1 group by pId,seq having count(*)>1);

    /* 用临时表来做重复查询和删除操作; 方便提高效率以及解决不能同表子查询删除的情况 */
    -- 原本查询重复的SQL
    select * from music a where (a.moid, a.seqno) in
       (select moid, seqno from music group by moid, seqno having count(*) > 1);
    -- 上面SQL太慢，換用临时表來做
    drop table if exists tem;
    create table tem as
       select min(oid) as oid, moid, seqno from music  group by moid, seqno having count(*) > 1;
    select a.* from music a, tem t where a.moid=t.moid and a.seqno=t.seqno;
    -- 刪除错误资料
    delete from music where (moid, seqno) in
       (select moid, seqno from tem) and oid not in (select oid from tem);
    drop table tem;

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


   11. 按时间段分组查询
    1、MySQL
       数据库里面有一字段类型为 datetime ,想按时间段来分组,用 DATE_FORMAT 函数
       SELECT `Id`, sum(`Number`) Number, DATE_FORMAT(`Date`, '%Y-%m-%d %k:%i:%s') d FROM `classifycount` Group By d

       时间时的格式
        %W 星期名字(Sunday……Saturday)
        %D 有英语前缀的月份的日期(1st, 2nd, 3rd, 等等)
        %Y 年, 数字, 4 位
        %y 年, 数字, 2 位
        %a 缩写的星期名字(Sun……Sat)
        %d 月份中的天数, 数字(00……31)
        %e 月份中的天数, 数字(0……31)
        %m 月, 数字(01……12)
        %c 月, 数字(1……12)
        %b 缩写的月份名字(Jan……Dec)
        %j 一年中的天数(001……366)
        %H 小时(00……23)
        %k 小时(0……23)
        %h 小时(01……12)
        %I 小时(01……12)
        %l 小时(1……12)
        %i 分钟, 数字(00……59)
        %r 时间,12 小时(hh:mm:ss [AP]M)
        %T 时间,24 小时(hh:mm:ss)
        %S 秒(00……59)
        %s 秒(00……59)
        %p AM或PM
        %w 一个星期中的天数(0=Sunday ……6=Saturday )
        %U 星期(0……52), 这里星期天是星期的第一天
        %u 星期(0……52), 这里星期一是星期的第一天
        %% 一个文字“%”。
        所有的其他字符不做解释被复制到结果中。

       http://zhidao.baidu.com/question/293828754.html
       http://hlee.iteye.com/blog/435507

   12. 查询自增主键( MySQL, Sql Server )
	SELECT LAST_INSERT_ID(); -- MySQL 专用
	SELECT @@identity; -- Sql Server 及 MySQL 通用

   13. 聚合函数的条件
    SELECT SUM(if(pay_status=1,goods_amount,0)) AS money, -- sum 只累计 pay_status=1 的 goods_amount 值
        count( * ) AS num,
        count(if(pay_status=1,true,null)) AS success, -- count 统计 pay_status=1 的出现数量
        count(if(pay_status=2,true,null)) AS fall
    FROM `tab_order_info` WHERE user_id = 2;

    SELECT COUNT(case when date(`present_time`)=CURDATE() then 1 else null end) as day, -- 统计今天的数据
        COUNT(case when YEARWEEK(date_format(`present_time`,'%Y-%m-%d'))=YEARWEEK(NOW()) then 1 else null end) as week, -- 统计本周的数据
        COUNT(case when date_format(`present_time`,'%Y-%m')=date_format(NOW(),'%Y-%m') then 1 else null end) as month -- 统计本月的数据
    FROM `t_present_log`;

    SELECT SUM(if(date(`present_time`)=CURDATE(),present_num,null)) as day, -- 累计今天的 present_num 值
        SUM(if(YEARWEEK(date_format(`present_time`,'%Y-%m-%d'))=YEARWEEK(NOW()),present_num,null)) as week,  -- 累计本周的 present_num 值
        SUM(if(date_format(`present_time`,'%Y-%m')=date_format(NOW(),'%Y-%m'),present_num,null)) as month -- 累计本月的 present_num 值
    FROM `t_present_log`;

    SELECT `bid`, COUNT(DISTINCT `uid`), COUNT(DISTINCT `orderid`), -- count 里面的 DISTINCT 去重统计,多个相同的 uid 值只统计 1 次
        SUM(IF (`left_time` != -1,  `left_time`, 0)), sum(if (`left_flow` != -1,  `left_flow`, 0)) -- 条件聚合
    FROM `user_package`
    WHERE `ctime`>=CURDATE() - interval 1 DAY and `ctime`<CURDATE() -- 统计昨天的数据
    GROUP BY `bid`;

   14.查询指定日期的数据
        SELECT * FROM t_goods_log WHERE flag='n' AND time>NOW()-interval 1 DAY; -- 只查1天内的数据, time 字段是1天前的不会出来
        SELECT * FROM t_goods_log WHERE flag='n' AND time>NOW()-interval 1 Hour; -- 只查1小时内的数据(数据库保存的是插入时的时间)
        SELECT * FROM t_goods_log WHERE endtime<NOW()+interval 1 MINUTE; -- 只查1分钟内的数据(数据库保存的是结束时间)

配置文件 详解
    linux 下 mysql 配置文件是 my.cnf
    windows 下配置文件是 my.ini

    basedir = path	使用给定目录作为根目录(安装目录)。
    character-sets-dir = path	给出存放着字符集的目录。
    datadir = path	从给定目录读取数据库文件。
    pid-file = filename	为mysqld程序指定一个存放进程ID的文件(仅适用于UNIX/Linux系统); Init-V脚本需要使用这个文件里的进程ID结束mysqld进程。
    socket = filename	为MySQL客户程序与服务器之间的本地通信指定一个套接字文件(仅适用于UNIX/Linux系统; 默认设置一般是/var/lib/mysql/mysql.sock文件)。在Windows环境下，如果MySQL客户与服务器是通过命名管道进行通信 的，–sock选项给出的将是该命名管道的名字(默认设置是MySQL)。
    lower_case_table_name = 1/0	新目录和数据表的名字是否只允许使用小写字母; 这个选项在Windows环境下的默认设置是1(只允许使用小写字母)。


mysqld程序：语言设置

    character-sets-server = name	新数据库或数据表的默认字符集。为了与MySQL的早期版本保持兼容，这个字符集也可以用–default-character-set选项给出; 但这个选项已经显得有点过时了。
    collation-server = name	新数据库或数据表的默认排序方式。
    lanuage = name	用指定的语言显示出错信息。


mysqld程序：通信、网络、信息安全

    enable-named-pipes	允许Windows 2000/XP环境下的客户和服务器使用命名管道(named pipe)进行通信。这个命名管道的默认名字是MySQL，但可以用–socket选项来改变。
    local-infile [=0]	允许/禁止使用LOAD DATA LOCAL语句来处理本地文件。
    myisam-recover [=opt1, opt2, ...]	在启动时自动修复所有受损的MyISAM数据表。这个选项的可取值有4种:DEFAULT、BACKUP、QUICK和FORCE; 它们与myisamchk程序的同名选项作用相同。
    old-passwords	使用MySQL 3.23和4.0版本中的老算法来加密mysql数据库里的密码(默认使用MySQL 4.1版本开始引入的新加密算法)。
    port = n	为MySQL程序指定一个TCP/IP通信端口(通常是3306端口)。
    safe-user-create	只有在mysql.user数据库表上拥有INSERT权限的用户才能使用GRANT命令; 这是一种双保险机制(此用户还必须具备GRANT权限才能执行GRANT命令)。
    shared-memory	允许使用内存(shared memory)进行通信(仅适用于Windows)。
    shared-memory-base-name = name	给共享内存块起一个名字(默认的名字是MySQL)。
    skip-grant-tables	不使用mysql数据库里的信息来进行访问控制(警告:这将允许用户任何用户去修改任何数据库)。
    skip-host-cache	不使用高速缓存区来存放主机名和IP地址的对应关系。
    skip-name-resovle	不把IP地址解析为主机名; 与访问控制(mysql.user数据表)有关的检查全部通过IP地址行进。
    skip-networking	只允许通过一个套接字文件(Unix/Linux系统)或通过命名管道(Windows系统)进行本地连接，不允许ICP/IP连接; 这提高了安全性，但阻断了来自网络的外部连接和所有的Java客户程序(Java客户即使在本地连接里也使用TCP/IP)。
    user = name	mysqld程序在启动后将在给定UNIX/Linux账户下执行; mysqld必须从root账户启动才能在启动后切换到另一个账户下执行; mysqld_safe脚本将默认使用–user=mysql选项来启动mysqld程序。


mysqld程序：内存管理、优化、查询缓存区

    bulk_insert_buffer_size = n	为一次插入多条新记录的INSERT命令分配的缓存区长度(默认设置是8M)。
    key_buffer_size = n	用来存放索引区块的RMA值(默认设置是8M)。
    join_buffer_size = n	在参加JOIN操作的数据列没有索引时为JOIN操作分配的缓存区长度(默认设置是128K)。
    max_heap_table_size = n	HEAP数据表的最大长度(默认设置是16M); 超过这个长度的HEAP数据表将被存入一个临时文件而不是驻留在内存里。
    max_connections = n	MySQL服务器同时处理的数据库连接的最大数量(默认设置是100)。
    query_cache_limit = n	允许临时存放在查询缓存区里的查询结果的最大长度(默认设置是1M)。
    query_cache_size = n	查询缓存区的最大长度(默认设置是0，不开辟查询缓存区)。
    query_cache_type = 0/1/2	查询缓存区的工作模式:0, 禁用查询缓存区; 1，启用查询缓存区(默认设置); 2，”按需分配”模式，只响应SELECT SQL_CACHE命令。
    read_buffer_size = n	为从数据表顺序读取数据的读操作保留的缓存区的长度(默认设置是128KB); 这个选项的设置值在必要时可以用SQL命令SET SESSION read_buffer_size = n命令加以改变。
    read_rnd_buffer_size = n	类似于read_buffer_size选项，但针对的是按某种特定顺序(比如使用了ORDER BY子句的查询)输出的查询结果(默认设置是256K)。
    sore_buffer = n	为排序操作分配的缓存区的长度(默认设置是2M); 如果这个缓存区太小，则必须创建一个临时文件来进行排序。
    table_cache = n	同时打开的数据表的数量(默认设置是64)。
    tmp_table_size = n	临时HEAP数据表的最大长度(默认设置是32M); 超过这个长度的临时数据表将被转换为MyISAM数据表并存入一个临时文件。


mysqld程序：日志

    log [= file]	把所有的连接以及所有的SQL命令记入日志(通用查询日志); 如果没有给出file参数，MySQL将在数据库目录里创建一个hostname.log文件作为这种日志文件(hostname是服务器的主机名)。
    log-slow-queries [= file]	把执行用时超过long_query_time变量值的查询命令记入日志(慢查询日志); 如果没有给出file参数，MySQL将在数据库目录里创建一个hostname-slow.log文件作为这种日志文件(hostname是服务器主机 名)。
    long_query_time = n	慢查询的执行用时上限(默认设置是10s)。
    long_queries_not_using_indexs	把慢查询以及执行时没有使用索引的查询命令全都记入日志(其余同–log-slow-queries选项)。
    log-bin [= filename]	把对数据进行修改的所有SQL命令(也就是INSERT、UPDATE和DELETE命令)以二进制格式记入日志(二进制变更日志，binary update log)。这种日志的文件名是filename.n或默认的hostname.n，其中n是一个6位数字的整数(日志文件按顺序编号)。
    log-bin-index = filename	二进制日志功能的索引文件名。在默认情况下，这个索引文件与二进制日志文件的名字相同，但后缀名是.index而不是.nnnnnn。
    max_binlog_size = n	二进制日志文件的最大长度(默认设置是1GB)。在前一个二进制日志文件里的信息量超过这个最大长度之前，MySQL服务器会自动提供一个新的二进制日志文件接续上。
    binlog-do-db = dbname	只把给定数 据库里的变化情况记入二进制日志文件，其他数据库里的变化情况不记载。如果需要记载多个数据库里的变化情况，就必须在配置文件使用多个本选项来设置，每个数据库一行。
    binlog-ignore-db = dbname	不把给定数据库里的变化情况记入二进制日志文件。
    sync_binlog = n	每经过n次日志写操作就把日志文件写入硬盘一次(对日志信息进行一次同步)。n=1是最安全的做法，但效率最低。默认设置是n=0，意思是由操作系统来负责二进制日志文件的同步工作。
    log-update [= file]	记载出错情况的日志文件名(出错日志)。这种日志功能无法禁用。如果没有给出file参数，MySQL会使用hostname.err作为种日志文件的名字。


mysqld程序：镜像(主控镜像服务器)

    server-id = n	给服务器分配一个独一无二的ID编号; n的取值范围是1~2的32次方启用二进制日志功能。
    log-bin = name	启用二进制日志功能。这种日志的文件名是filename.n或默认的hostname.n，其中的n是一个6位数字的整数(日志文件顺序编号)。
    binlog-do/ignore-db = dbname	只把给定数据库里的变化情况记入二进制日志文件/不把给定的数据库里的变化记入二进制日志文件。


mysqld程序：镜像(从属镜像服务器)

    server-id = n	给服务器分配一个唯一的ID编号
    log-slave-updates	启用从属服务器上的日志功能，使这台计算机可以用来构成一个镜像链(A->B->C)。
    master-host = hostname	主控服务器的主机名或IP地址。如果从属服务器上存在mater.info文件(镜像关系定义文件)，它将忽略此选项。
    master-user = replicusername	从属服务器用来连接主控服务器的用户名。如果从属服务器上存在mater.info文件，它将忽略此选项。
    master-password = passwd	从属服务器用来连接主控服务器的密码。如果从属服务器上存在mater.info文件，它将忽略此选项。
    master-port = n	从属服务器用来连接主控服务器的TCP/IP端口(默认设置是3306端口)。
    master-connect-retry = n	如果与主控服务器的连接没有成功，则等待n秒(s)后再进行管理方式(默认设置是60s)。如果从属服务器存在mater.info文件，它将忽略此选项。
    master-ssl-xxx = xxx	对主、从服务器之间的SSL通信进行配置。
    read-only = 0/1	0: 允许从属服务器独立地执行SQL命令(默认设置); 1: 从属服务器只能执行来自主控服务器的SQL命令。
    read-log-purge = 0/1	1: 把处理完的SQL命令立刻从中继日志文件里删除(默认设置); 0: 不把处理完的SQL命令立刻从中继日志文件里删除。
    replicate-do-table = dbname.tablename	与–replicate-do-table选项的含义和用法相同，但数据库和数据库表名字里允许出现通配符”%” (例如: test%.%–对名字以”test”开头的所有数据库里的所以数据库表进行镜像处理)。


    replicate-do-db = name	只对这个数据库进行镜像处理。
    replicate-ignore-table = dbname.tablename	不对这个数据表进行镜像处理。
    replicate-wild-ignore-table = dbn.tablen	不对这些数据表进行镜像处理。
    replicate-ignore-db = dbname	不对这个数据库进行镜像处理。
    replicate-rewrite-db = db1name > db2name	把主控数据库上的db1name数据库镜像处理为从属服务器上的db2name数据库。
    report-host = hostname	从属服务器的主机名; 这项信息只与SHOW SLAVE HOSTS命令有关–主控服务器可以用这条命令生成一份从属服务器的名单。
    slave-compressed-protocol = 1	主、从服务器使用压缩格式进行通信–如果它们都支持这么做的话。
    slave-skip-errors = n1, n2, …或all	即使发生出错代码为n1、n2等的错误，镜像处理工作也继续进行(即不管发生什么错误，镜像处理工作也继续进行)。如果配置得当，从属服务器不应该在执行 SQL命令时发生错误(在主控服务器上执行出错的SQL命令不会被发送到从属服务器上做镜像处理); 如果不使用slave-skip-errors选项，从属服务器上的镜像工作就可能因为发生错误而中断，中断后需要有人工参与才能继续进行。


mysqld–InnoDB：基本设置、表空间文件

    skip-innodb	不加载InnoDB数据表驱动程序–如果用不着InnoDB数据表，可以用这个选项节省一些内存。
    innodb-file-per-table	为每一个新数据表创建一个表空间文件而不是把数据表都集中保存在中央表空间里(后者是默认设置)。该选项始见于MySQL 4.1。
    innodb-open-file = n	InnoDB数据表驱动程序最多可以同时打开的文件数(默认设置是300)。如果使用了innodb-file-per-table选项并且需要同时打开很多数据表的话，这个数字很可能需要加大。
    innodb_data_home_dir = p	InnoDB主目录，所有与InnoDB数据表有关的目录或文件路径都相对于这个路径。在默认的情况下，这个主目录就是MySQL的数据目录。
    innodb_data_file_path = ts	用来容纳InnoDB为数据表的表空间: 可能涉及一个以上的文件; 每一个表空间文件的最大长度都必须以字节(B)、兆字节(MB)或千兆字节(GB)为单位给出; 表空间文件的名字必须以分号隔开; 最后一个表空间文件还可以带一个autoextend属性和一个最大长度(max:n)。例如，ibdata1:1G; ibdata2:1G:autoextend:max:2G的意思是: 表空间文件ibdata1的最大长度是1GB，ibdata2的最大长度也是1G，但允许它扩充到2GB。除文件名外，还可以用硬盘分区的设置名来定义表 空间，此时必须给表空间的最大初始长度值加上newraw关键字做后缀，给表空间的最大扩充长度值加上raw关键字做后缀(例如/dev/hdb1: 20Gnewraw或/dev/hdb1:20Graw); MySQL 4.0及更高版本的默认设置是ibdata1:10M:autoextend。
    innodb_autoextend_increment = n	带有autoextend属性的表空间文件每次加大多少兆字节(默认设置是8MB)。这个属性不涉及具体的数据表文件，那些文件的增大速度相对是比较小的。
    innodb_lock_wait_timeout = n	如果某个事务在等待n秒(s)后还没有获得所需要的资源，就使用ROLLBACK命令放弃这个事务。这项设置对于发现和处理未能被InnoDB数据表驱动 程序识别出来的死锁条件有着重要的意义。这个选项的默认设置是50s。
    innodb_fast_shutdown 0/1	是否以最快的速度关闭InnoDB，默认设置是1，意思是不把缓存在INSERT缓存区的数据写入数据表，那些数据将在MySQL服务器下次启动时再写入 (这么做没有什么风险，因为INSERT缓存区是表空间的一个组成部分，数据不会丢失)。把这个选项设置为0反面危险，因为在计算机关闭时，InnoDB 驱动程序很可能没有足够的时间完成它的数据同步工作，操作系统也许会在它完成数据同步工作之前强行结束InnoDB，而这会导致数据不完整。


mysqld程序：InnoDB–日志

    innodb_log_group_home_dir = p	用来存放InnoDB日志文件的目录路径(如ib_logfile0、ib_logfile1等)。在默认的情况下，InnoDB驱动程序将使用 MySQL数据目录作为自己保存日志文件的位置。
    innodb_log_files_in_group = n	使用多少个日志文件(默认设置是2)。InnoDB数据表驱动程序将以轮转方式依次填写这些文件; 当所有的日志文件都写满以后，之后的日志信息将写入第一个日志文件的最大长度(默认设置是5MB)。这个长度必须以MB(兆字节)或GB(千兆字节)为单 位进行设置。
    innodb_flush_log_at_trx_commit = 0/1/2	这个选项决定着什么时候把日志信息写入日志文件以及什么时候把这些文件物理地写(术语称为”同步”)到硬盘上。设置值0的意思是每隔一秒写一次日志并进行 同步，这可以减少硬盘写操作次数，但可能造成数据丢失; 设置值1(设置设置)的意思是在每执行完一条COMMIT命令就写一次日志并进行同步，这可以防止数据丢失，但硬盘写操作可能会很频繁; 设置值2是一般折衷的办法，即每执行完一条COMMIT命令写一次日志，每隔一秒进行一次同步。
    innodb_flush_method = x	InnoDB日志文件的同步办法(仅适用于UNIX/Linux系统)。这个选项的可取值有两种: fdatasync，用fsync()函数进行同步; O_DSYNC，用O_SYNC()函数进行同步。
    innodb_log_archive = 1	启用InnoDB驱动程序的archive(档案)日志功能，把日志信息写入ib_arch_log_n文件。启用这种日志功能在InnoDB与 MySQL一起使用时没有多大意义(启用MySQL服务器的二进制日志功能就足够用了)。


mysqld程序–InnoDB：缓存区的设置和优化

    innodb_log_buffer_pool_size = n	为InnoDB数据表及其索引而保留的RAM内存量(默认设置是8MB)。这个参数对速度有着相当大的影响，如果计算机上只运行有 MySQL/InnoDB数据库服务器，就应该把全部内存的80%用于这个用途。


    innodb_log_buffer_size = n	事务日志文件写操作缓存区的最大长度(默认设置是1MB)。
    innodb_additional_men_pool_size = n	为用于内部管理的各种数据结构分配的缓存区最大长度(默认设置是1MB)。
    innodb_file_io_threads = n	I/O操作(硬盘写操作)的最大线程个数(默认设置是4)。
    innodb_thread_concurrency = n	InnoDB驱动程序能够同时使用的最大线程个数(默认设置是8)。


mysqld程序：其它选项

    bind-address = ipaddr	MySQL服务器的IP地址。如果MySQL服务器所在的计算机有多个IP地址，这个选项将非常重要。
    default-storage-engine = type	新数据表的默认数据表类型(默认设置是MyISAM)。这项设置还可以通过–default-table-type选项来设置。
    default-timezone = name	为MySQL服务器设置一个地理时区(如果它与本地计算机的地理时区不一样)。
    ft_min_word_len = n	全文索引的最小单词长度工。这个选项的默认设置是4，意思是在创建全文索引时不考虑那些由3个或更少的字符构建单词。
    Max-allowed-packet = n	客户与服务器之间交换的数据包的最大长度，这个数字至少应该大于客户程序将要处理的最大BLOB块的长度。这个选项的默认设置是1MB。
    Sql-mode = model1, mode2, …	MySQL将运行在哪一种SQL模式下。这个选项的作用是让MySQL与其他的数据库系统保持最大程度的兼容。这个选项的可取值包括ansi、db2、 oracle、no_zero_date、pipes_as_concat。


