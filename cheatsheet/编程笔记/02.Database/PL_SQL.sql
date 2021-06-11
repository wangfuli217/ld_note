
大小写不敏感。

打印单引号时，需加多一个单引号作转义符。即连用两个单引号才可以打印一个。
    Begin dbms_output.put_line('I''m leaning');
    End;

注释：
单行注释：由两个连字符开始，到行尾。
   --Available
多行注释：由“/*”开头，“*/” 结尾。
	如果在一行代码还没有写完前(指分号结束此语句之前)，一定要使用多行注释格式。
	SQL中的一行代码，不是按手写的格式定义的，而是按计算机解释格式(没有分号终止前，即使按了回车也都解释为一行)


      PL/SQL 块语法
[DECLARE]
        ---declaration statements
BEGIN
        ---executable statements
[EXCEPTION]
        ---exception statements
END


变量声明：Declare
    变量名  Type [Constant] [Not Null] [:=value];
	“：＝”是赋值，而“＝”是比较语句。

数据类型：
        %Type       可以取出某字段的类型；如：s_emp.last_name%Type  --相当于Varchar2。
        %Rowtype    返回一整行的记录类型；如：s_emp%Rowtype       --这得注意各字段的顺序。

数字型：
Number:
Binary_Integer:

BoolLean类型：只有 True 和 False 两类。
        其中，Dull = False。

程序执行顺序的类型可分三种：
顺序
选择
        If ... Then ...
        Elsif  ... Then ...
        Else ...
        End If;
循环
一、LOOP循环：
  1.   Loop ... ;  Exit When boolean_expr ; End Loop;
  2.   Loop  If boolean_expr  Then  Exit;  End If;
            ...;  End Loop;

二、While循环：
       While  boolean_expression
          Loop  ...  End Loop;
        其中boolean_expression 值为False则立即退出循环。免另外写结束条件。
        可以使用Exit或Exit When 语句终止循环处理。

三、For循环：
       For loop_count IN [Reverse] low_bound..high_bound
             Loop   ...;   End Loop;
        免声明，默认loop_count为数值型。简化结束条件。
        IN Reverse 表示倒过来，由大值自减到小值
        例：        For cnt  IN  1..5  Loop  ...;   End Loop;        /*由1到5*/

--循环，例2
declare @num int
set @num = 0
while @num<10
begin
print @num
set @num=@num +1
end


常用PLSQL语句：
    DBMS_OUTPUT.PUT_LINE('v_Num_3 = ' || v_Num_3); --文件中要打印一些内容
    set serveroutput on; --使终端可打印出文件的结果； 使输出无效：set serveroutput off;



Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for 'help'.
clear     (\c) Clear command.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter. NOTE: Takes the rest of the line as new delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Donot write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Donot show warnings after every statement.


