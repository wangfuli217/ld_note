colife

MYSQL常用操作语句

1.进入数据库：

    mysql -u root -p   
    mysql -h localhost -u root -p database_name  

2.列出数据库：

    show databases;  

3.选择数据库：

    use databases_name;  

4.列出数据表：

    show tables;  

5.显示表格列的属性：

    show columns from table_name;   
    describe table_name;  

6.导出整个数据库：

    mysqldump -u user_name -p database_name > /tmp/file_name  

例如：mysqldump -u root -p test_db > d:/test_db.sql

7.导出一个表：

    mysqldump -u user_name -p database_name table_name > /tmp/file_name  

例如：mysqldump -u root -p test_db table1 > d:/table1.sql

8.导出一个数据库结构：

    mysqldump -u user_name -p -d --add-drop-table database_name > file_name  

例如：mysqldump -u root -p -d --add-drop-table test_db > test_db.sql

9.导入数据库：

    source file_name;   
    或   
    mysql -u user_name -p database_name < file_name  

例如：

source /tmp/bbs.sql；

source d:/bbs.sql；

mysql -u root -p bbs < "d:/bbs.sql"

mysql -u root -p bbs < "/tmp/bbs.sql"

10.将文本文件导入数据表中（excel与之相同）

    load data infile "tables.txt" into table table_name;  

例如：

load data infile "/tmp/bbs.txt" into table bbs；

load data infile "/tmp/bbs.xls" into table bbs；

load data infile "d:/bbs.txt" into table bbs；

load data infile "d:/bbs.xls" into table bbs；

11.将数据表导出为文本文件（excel与之相同）

    select * into outfile "path_file_name" from table_name;  

例如：

select * into outfile "/tmp/bbs.txt" from bbs；

select * into outfile "/tmp/bbs.xls" from bbs where id=1;

select * into outfile "d:/bbs.txt" from bbs;

select * into outfile "d:/bbs.xls" from bbs where id=1;

12.创建数据库时先判断数据库是否存在：

    create database if not exists database_name;  

例如：create database if not exists bbs

13.创建数据库：

    create database database_name;  

例如：create database bbs;

14.删除数据库：

    drop database database_name;  

例如：drop database bbs;

15.创建数据表：

    mysql> create table <table_name> ( <column 1 name> <col. 1 type> <col. 1 details>,<column 2 name> <col. 2 type> <col. 2 details>, ...);  

例如：create table (id int not null auto_increment primary key,name char(16) not null default "jack",date_year date not null);

16.删除数据表中数据：

    delete from table_name;  

例如：

delete from bbs;

delete from bbs where id=2;

17.删除数据库中的数据表：

    drop table table_name;  

例如：

drop table test_db;

rm -f database_name/table_name.* (linux下）

例如：

rm -rf bbs/accp.*

18.向数据库中添加数据：

    insert into table_name set column_name1=value1,column_name2=value2;  

例如：insert into bbs set name="jack",date_year="1993-10-01";

    insert into table_name values (column1,column2,...);  

例如：insert into bbs ("2","jack","1993-10-02")

    insert into table_name (column_name1,column_name2,...) values (value1,value2);  

例如：insert into bbs (name,data_year) values ("jack","1993-10-01");

19.查询数据表中的数据：

    select * from table_name;  

例如：select * from bbs where id=1;

20.修改数据表中的数据：

    update table_name set col_name=new_value where id=1;  

例如：update bbs set name="tom" where name="jack";

21.增加一个字段：

    alter table table_name add column field_name datatype not null default "1";  

例如：alter table bbs add column tel char(16) not null;

22.增加多个字段：(column可省略不写）

    alter table table_name add column filed_name1 datatype,add column filed_name2 datatype;  

例如：alter table bbs add column tel char(16) not null,add column address text;

23.删除一个字段：

    alter table table_name drop field_name;  

例如：alter table bbs drop tel;

24.修改字段的数据类型：

    alter table table_name modify id int unsigned;//修改列id的类型为int unsigned    
    alter table table_name change id sid int unsigned;//修改列id的名字为sid，而且把属性修改为int unsigned  

25.修改一个字段的默认值：

    alter table table_name modify column_name datatype not null default "";  

例如：alter table test_db modify name char(16) default not null "yourname";

26.对表重新命名：

    alter table table_name rename as new_table_name;  

例如：alter table bbs rename as bbs_table;

    rename table old_table_name to new_table_name;  

例如：rename table test_db to accp;

27.从已经有的表中复制表的结构：

    create table table2 select * from table1 where 1<>1;  

例如：create table test_db select * from accp where 1<>1;

28.查询时间：

    select now();  

29.查询当前用户：

    select user();  

30.查询数据库版本：

    select version();  

31.创建索引：

    alter table table1 add index ind_id(id);   
    create index ind_id on table1(id);   
    create unique index ind_id on table1(id);//建立唯一性索引  

32.删除索引：

    drop index idx_id on table1;   
    alter table table1 drop index ind_id;  

33.联合字符或者多个列（将id与":"和列name和"="连接）

    select concat(id，':',name,'=') from table;  

34.limit（选出10到20条）

    select * from bbs order by id limit 9,10;  

（从查询结果中列出第几到几条的记录）

35.增加一个管理员账号：

    grant all on *.* to user@localhost identified by "password";  

36.创建表是先判断表是否存在

    create table if not exists students(……);  

37.复制表：

    create table table2 select * from table1;  

例如：create table test_db select * from accp;

38.授于用户远程访问mysql的权限

    grant all privileges on *.* to "root"@"%" identified by "password" with grant option;  

或者是修改mysql数据库中的user表中的host字段

    use mysql;   
    select user,host from user;   
    update user set host="%" where user="user_name";  

39.查看当前状态

    show status;  

40.查看当前连接的用户

    show processlist;  

（如果是root用户，则查看全部的线程，得到的用户连接数同show status;里的 Threads_connected值是相同的）

41、常用查询语句

一查询数值型数据:
 SELECT * FROM tb_name WHERE sum > 100;
 查询谓词:>,=,<,<>,!=,!>,!<,=>,=<
 
二查询字符串
 SELECT * FROM tb_stu  WHERE sname  =  '小刘'
 SELECT * FROM tb_stu  WHERE sname like '刘%'
 SELECT * FROM tb_stu  WHERE sname like '%程序员'
 SELECT * FROM tb_stu  WHERE sname like '%PHP%'
 
三查询日期型数据
 SELECT * FROM tb_stu WHERE date = '2011-04-08'
 注:不同数据库对日期型数据存在差异: ：
 (1)MySQL:SELECT * from tb_name WHERE birthday = '2011-04-08'
 (2)SQL Server:SELECT * from tb_name WHERE birthday = '2011-04-08'
 (3)Access:SELECT * from tb_name WHERE birthday = #2011-04-08#
 
四查询逻辑型数据
 SELECT * FROM tb_name WHERE type = 'T'
 SELECT * FROM tb_name WHERE type = 'F'
 逻辑运算符:and or not
 
五查询非空数据
 SELECT * FROM tb_name WHERE address <>'' order by addtime desc
 注:<>相当于PHP中的!=
 
六利用变量查询数值型数据
 SELECT * FROM tb_name WHERE id = '$_POST[text]' 
注:利用变量查询数据时，传入SQL的变量不必用引号括起来，因为PHP中的字符串与数值型数据进行连接时，程序会自动将数值型数据转变成字符串，然后与要连接的字符串进行连接
 
七利用变量查询字符串数据 
SELECT * FROM tb_name WHERE name LIKE '%$_POST[name]%' 
完全匹配的方法"%%"表示可以出现在任何位置
 
八查询前n条记录
 SELECT * FROM tb_name LIMIT 0,$N;
 limit语句与其他语句，如order by等语句联合使用，会使用SQL语句千变万化，使程序非常灵活
 
九查询后n条记录
 SELECT * FROM tb_stu ORDER BY id ASC LIMIT $n
 
十查询从指定位置开始的n条记录
 SELECT * FROM tb_stu ORDER BY id ASC LIMIT $_POST[begin],$n
 注意:数据的id是从0开始的
 
十一查询统计结果中的前n条记录
 SELECT * ,(yw+sx+wy) AS total FROM tb_score ORDER BY (yw+sx+wy) DESC LIMIT 0,$num
 
十二查询指定时间段的数据
 SELECT  要查找的字段 FROM 表名 WHERE 字段名 BETWEEN 初始值 AND 终止值
 SELECT * FROM tb_stu WHERE age BETWEEN 0 AND 18
 
十三按月查询统计数据
 SELECT * FROM tb_stu WHERE month(date) = '$_POST[date]' ORDER BY date ;
 注：SQL语言中提供了如下函数，利用这些函数可以很方便地实现按年、月、日进行查询
 year(data):返回data表达式中的公元年分所对应的数值
 month(data):返回data表达式中的月分所对应的数值
 day(data):返回data表达式中的日期所对应的数值
 
十四查询大于指定条件的记录
 SELECT * FROM tb_stu WHERE age>$_POST[age] ORDER BY age;
 
十五查询结果不显示重复记录
 SELECT DISTINCT 字段名 FROM 表名 WHERE 查询条件 
注:SQL语句中的DISTINCT必须与WHERE子句联合使用，否则输出的信息不会有变化 ,且字段不能用*代替
 
十六NOT与谓词进行组合条件的查询
 (1)NOT BERWEEN … AND … 对介于起始值和终止值间的数据时行查询 可改成 <起始值 AND >终止值
 (2)IS NOT NULL 对非空值进行查询 
 (3)IS NULL 对空值进行查询
 (4)NOT IN 该式根据使用的关键字是包含在列表内还是排除在列表外，指定表达式的搜索，搜索表达式可以是常量或列名，而列名可以是一组常量，但更多情况下是子查询
 
十七显示数据表中重复的记录和记录条数
 SELECT  name,age,count(*) ,age FROM tb_stu WHERE age = '19' group by date
 
十八对数据进行降序/升序查询
 SELECT 字段名 FROM tb_stu WHERE 条件 ORDER BY 字段 DESC 降序
 SELECT 字段名 FROM tb_stu WHERE 条件 ORDER BY 字段 ASC  升序
 注:对字段进行排序时若不指定排序方式，则默认为ASC升序
 
十九对数据进行多条件查询
 SELECT 字段名 FROM tb_stu WHERE 条件 ORDER BY 字段1 ASC 字段2 DESC  …
 注意:对查询信息进行多条件排序是为了共同限制记录的输出，一般情况下，由于不是单一条件限制，所以在输出效果上有一些差别。
 
二十对统计结果进行排序
 函数SUM([ALL]字段名) 或 SUM([DISTINCT]字段名),可实现对字段的求和，函数中为ALL时为所有该字段所有记录求和,若为DISTINCT则为该字段所有不重复记录的字段求和
 如：SELECT name,SUM(price) AS sumprice  FROM tb_price GROUP BY name
 
SELECT * FROM tb_name ORDER BY mount DESC,price ASC
 
二十一单列数据分组统计
 SELECT id,name,SUM(price) AS title,date FROM tb_price GROUP BY pid ORDER BY title DESC
 注:当分组语句group by排序语句order by同时出现在SQL语句中时，要将分组语句书写在排序语句的前面，否则会出现错误
 
二十二多列数据分组统计
 多列数据分组统计与单列数据分组统计类似 
SELECT *，SUM(字段1*字段2) AS (新字段1) FROM 表名 GROUP BY 字段 ORDER BY 新字段1 DESC
 SELECT id,name,SUM(price*num) AS sumprice  FROM tb_price GROUP BY pid ORDER BY sumprice DESC
 注：group by语句后面一般为不是聚合函数的数列，即不是要分组的列
 
二十三多表分组统计
 SELECT a.name,AVG(a.price),b.name,AVG(b.price) FROM tb_demo058 AS a,tb_demo058_1 AS b WHERE a.id=b.id GROUP BY b.type;

42、关联查询
SELECT * FROM score, student WHERE score.id = student.id ...  
SELECT * FROM score JOIN student ON (score.id = student.id) WHERE ...  
SELECT * FROM score JOIN student USING (id) WHERE ... 
内联：select * from T1 inner join T2 on T1.userid = T2.userid
左联：select * from T1 left outer join T2 on T1.userid = T2.userid
右联：select * from T1 right outer join T2 on T1.userid = T2.userid
全联：select * from T1 full outer join T2 on T1.userid = T2.userid