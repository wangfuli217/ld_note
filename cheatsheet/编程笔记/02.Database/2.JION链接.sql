
SQL JOIN (连接)
    SQL join 用于根据两个或多个表中的列之间的关系，从这些表中查询数据。
    Join 和 Key 有时为了得到完整的结果，我们需要从两个或更多的表中获取结果。我们就需要执行 join 。
    连接可以对同一个表操作，也可以对多表操作，对同一个表操作的连接称为自连接。


类型，以及它们之间的差异。
    JOIN: 如果表中有至少一个匹配，则返回行
    LEFT JOIN: 即使右表中没有匹配，也从左表返回所有的行
    RIGHT JOIN: 即使左表中没有匹配，也从右表返回所有的行
    FULL JOIN: 只要其中一个表中存在匹配，就返回行
    INNER JOIN: 组合两个表中的记录，只返回严格匹配两表的行

    外连接分为三种：左外连接，右外连接，全外连接。对应SQL: LEFT/RIGHT/FULL OUTER JOIN 。
    自连接(self join)是SQL语句中经常要用的连接方式，使用自连接可以将自身表的一个镜像当作另一个表来对待，从而能够得到一些特殊的数据。


left join 左连接
    它的全称为 左外连接(left outer join),是外连接的一种。

    其语法格式为:
        select colunm_name1,colunm_name2
        from table_name1
        left join table_name2 on table_name1.colunmname=table_name2.colunmname
        where table_name1.colunm_name1 = ...

    举例说明:
      表A记录如下:
        aID aNum
        1 a20050111
        2 a20050112
        3 a20050113
      表B记录如下:
        bID bName
        1 2006032401
        2 2006032402
        8 2006032408

      测试数据生成:
        CREATE TABLE A ( aID int(11) AUTO_INCREMENT PRIMARY KEY , aNum char(20) );
        CREATE TABLE B ( bID int(11) AUTO_INCREMENT PRIMARY KEY , bName char(20) );
        INSERT INTO A VALUES (1, 'a20050111'), (2, 'a20050112'), (3, 'a20050113');
        INSERT INTO B VALUES (1, '2006032401'),(2, '2006032402'),(8, '2006032408');

      SQL语句:
        select * from A left join B on A.aID = B.bID;
        select * from A LEFT OUTER JOIN B on A.aID = B.bID;

      结果如下:
        aID aNum bID bName
        1 a20050111 1 2006032401
        2 a20050112 2 2006032402
        3 a20050113 NULL NULL
       （所影响的行数为 3 行）

    结果说明:
        left join 是以 A表 的记录为基础的,A可以看成左表,B可以看成右表, left join 是以左表为准的。
        换句话说,左表(A)的记录将会全部表示出来,而右表(B)只会显示符合搜索条件的记录(例子中为: A.aID = B.bID)。
        B表记录不足的地方均为 NULL 。


right join 右连接
    它的全称为 右外连接(right outer join),是外连接的一种。

    其语法格式为:
        select colunm_name1,colunm_name2
        from table_name1
        right join table_name2 on table_name1.colunmname=table_name2.colunmname
        where table_name1.colunm_name1 = ...

    举例说明:
      表A记录如下:
        aID aNum
        1 a20050111
        2 a20050112
        3 a20050113
      表B记录如下:
        bID bName
        1 2006032401
        2 2006032402
        8 2006032408

      测试数据生成:
        CREATE TABLE A ( aID int(11) AUTO_INCREMENT PRIMARY KEY , aNum char(20) );
        CREATE TABLE B ( bID int(11) AUTO_INCREMENT PRIMARY KEY , bName char(20) );
        INSERT INTO A VALUES (1, 'a20050111'), (2, 'a20050112'), (3, 'a20050113');
        INSERT INTO B VALUES (1, '2006032401'),(2, '2006032402'),(8, '2006032408');

      SQL语句:
        select * from A right join B on A.aID = B.bID;
        select * from A right OUTER JOIN B on A.aID = B.bID;

      结果如下:
        aID aNum bID bName
        1 a20050111 1 2006032401
        2 a20050112 2 2006032402
        NULL NULL 8 2006032408
        （所影响的行数为 3 行）

    结果说明:
        right join 是以B表的记录为基础的,A可以看成左表,B可以看成右表, right join 是以右表为准的。
        换句话说,右表(B)的记录将会全部表示出来,而左表(A)只会显示符合搜索条件的记录(例子中为: A.aID = B.bID)。
        A表记录不足的地方均为 NULL 。


INNER JOIN 内链接(或者称 相等联接)
    严格匹配两表都存在的记录。
    注意: 在一个 INNER JOIN 之中，可以嵌套 LEFT JOIN 或 RIGHT JOIN ,但是在 LEFT JOIN 或 RIGHT JOIN 中不能嵌套 INNER JOIN

    其语法格式为:
        SELECT * FROM a INNER JOIN b ON a.aID=b.bID
        SELECT * FROM a, b WHERE a.aID = b.bID -- 与上面一句等效(INNER JOIN 换成逗号, ON 换成 WHERE)

    举例说明:
      表A记录如下:
        aID aNum
        1 a20050111
        2 a20050112
        3 a20050113
      表B记录如下:
        bID bName
        1 2006032401
        2 2006032402
        8 2006032408

      测试数据生成:
        CREATE TABLE A ( aID int(11) AUTO_INCREMENT PRIMARY KEY , aNum char(20) );
        CREATE TABLE B ( bID int(11) AUTO_INCREMENT PRIMARY KEY , bName char(20) );
        INSERT INTO A VALUES (1, 'a20050111'), (2, 'a20050112'), (3, 'a20050113');
        INSERT INTO B VALUES (1, '2006032401'),(2, '2006032402'),(8, '2006032408');

      SQL语句:
        select * from A, B WHERE A.aID = B.bID;
        select * from A INNER JOIN B ON A.aID = B.bID;

      结果如下:
        aID aNum bID bName
        1 a20050111 1 2006032401
        2 a20050112 2 2006032402
        （所影响的行数为 2 行）

    结果说明:
        这里只显示出了 A.aID = B.bID 的记录.这说明 inner join 并不以谁为基础,它只显示同时符合两边条件的记录。


FULL JOIN 全连接
    SELECT column_name(s) FROM table_name1 FULL JOIN table_name2 ON table_name1.column_name=table_name2.column_name
    注释：在某些数据库中， FULL JOIN 称为 FULL OUTER JOIN 。

    举例说明:
      表A记录如下:
        aID aNum
        1 a20050111
        2 a20050112
        3 a20050113
      表B记录如下:
        bID bName
        1 2006032401
        2 2006032402
        8 2006032408

      测试数据生成:
        CREATE TABLE A ( aID int(11) AUTO_INCREMENT PRIMARY KEY , aNum char(20) );
        CREATE TABLE B ( bID int(11) AUTO_INCREMENT PRIMARY KEY , bName char(20) );
        INSERT INTO A VALUES (1, 'a20050111'), (2, 'a20050112'), (3, 'a20050113');
        INSERT INTO B VALUES (1, '2006032401'),(2, '2006032402'),(8, '2006032408');

      SQL语句:
        select * from A full join B on A.aID = B.bID;

      结果如下:
        aID aNum bID bName
        1 a20050111 1 2006032401
        2 a20050112 2 2006032402
        3 a20050113 NULL NULL
        NULL NULL 8 2006032408
        （所影响的行数为 4 行）

    结果说明:
        FULL JOIN 会从左表和右表那里返回所有的行。


    MySQL 没有 full join 功能, 可以使用间接实现:   A Left JOIN B   UNION   A Right JOIN B
    这里的原理，是因为 UNION 操作， 会合并掉重复的行。

    上面例子的写法:
        select * from A left JOIN B on A.aID = B.bID union select * from A right JOIN B on A.aID = B.bID;



