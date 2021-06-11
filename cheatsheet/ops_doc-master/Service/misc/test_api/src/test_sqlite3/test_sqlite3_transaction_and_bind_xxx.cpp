//三、高效的批量数据插入：
//    在给出操作步骤之前先简单说明一下批量插入的概念，以帮助大家阅读其后的示例代码。事实上，批量插入并不是什么新的概念，在其它关系型数据库的C接口API中都提供了一定的支持，只是接口的实现方式不同而已。纵观众多流行的数据库接口，如OCI(Oracle API)、MySQL API和PostgreSQL API等，OCI提供的编程接口最为方便，实现方式也最为高效。SQLite作为一种简单灵活的嵌入式数据库也同样提供了该功能，但是实现方式并不像其他数据库那样方便明显，它只是通过一种隐含的技巧来达到批量插入的目的，其逻辑如下：
//    1). 开始一个事物，以保证后面的数据操作语句均在该事物内完成。在SQLite中，如果没有手工开启一个事物，其所有的DML语句都是在自动提交模式下工作的，既每次操作后数据均被自动提交并写入磁盘文件。然而在非自动提交模式下，只有当其所在的事物被手工COMMIT之后才会将修改的数据写入到磁盘中，之前修改的数据都是仅仅驻留在内存中。显而易见，这样的批量写入方式在效率上势必会远远优于多迭代式的单次写入操作。
//    2). 基于变量绑定的方式准备待插入的数据，这样可以节省大量的sqlite3_prepare_v2函数调用次数，从而节省了多次将同一SQL语句编译成SQLite内部识别的字节码所用的时间。事实上，SQLite的官方文档中已经明确指出，在很多时候sqlite3_prepare_v2函数的执行时间要多于sqlite3_step函数的执行时间，因此建议使用者要尽量避免重复调用sqlite3_prepare_v2函数。在我们的实现中，如果想避免此类开销，只需将待插入的数据以变量的形式绑定到SQL语句中，这样该SQL语句仅需调用sqlite3_prepare_v2函数编译一次即可，其后的操作只是替换不同的变量数值。
//    3). 在完成所有的数据插入后显式的提交事物。提交后，SQLite会将当前连接自动恢复为自动提交模式。

#include <sqlite3.h>
#include <string>
#include <stdio.h>
#include <string.h>
using namespace std;

void doTest()
{
    sqlite3* conn = NULL;
    //1. 打开数据库
    int result = sqlite3_open("./mytest.db",&conn);
    if (result != SQLITE_OK) {
        sqlite3_close(conn);
        return;
    }
    const char* createTableSQL =
        "CREATE TABLE TESTTABLE (int_col INT, float_col REAL, string_col TEXT)";
    sqlite3_stmt* stmt = NULL;
    int len = strlen(createTableSQL);
    //2. 准备创建数据表，如果创建失败，需要用sqlite3_finalize释放sqlite3_stmt对象，以防止内存泄露。
    if (sqlite3_prepare_v2(conn,createTableSQL,len,&stmt,NULL) != SQLITE_OK) {
        if (stmt)
            sqlite3_finalize(stmt);
        sqlite3_close(conn);
        return;
    }
    //3. 通过sqlite3_step命令执行创建表的语句。对于DDL和DML语句而言，sqlite3_step执行正确的返回值
    //只有SQLITE_DONE，对于SELECT查询而言，如果有数据返回SQLITE_ROW，当到达结果集末尾时则返回
    //SQLITE_DONE。
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        sqlite3_finalize(stmt);
        sqlite3_close(conn);
        return;
    }
    //4. 释放创建表语句对象的资源。
    sqlite3_finalize(stmt);
    printf("Succeed to create test table now.\n");

    //5. 显式的开启一个事物。
    sqlite3_stmt* stmt2 = NULL;
    const char* beginSQL = "BEGIN TRANSACTION";
    if (sqlite3_prepare_v2(conn,beginSQL,strlen(beginSQL),&stmt2,NULL) != SQLITE_OK) {
        if (stmt2)
            sqlite3_finalize(stmt2);
        sqlite3_close(conn);
        return;
    }
    if (sqlite3_step(stmt2) != SQLITE_DONE) {
        sqlite3_finalize(stmt2);
        sqlite3_close(conn);
        return;
    }
    sqlite3_finalize(stmt2);

    //6. 构建基于绑定变量的插入数据。
    const char* insertSQL = "INSERT INTO TESTTABLE VALUES(?,?,?)";
    sqlite3_stmt* stmt3 = NULL;
    if (sqlite3_prepare_v2(conn,insertSQL,strlen(insertSQL),&stmt3,NULL) != SQLITE_OK) {
        if (stmt3)
            sqlite3_finalize(stmt3);
        sqlite3_close(conn);
        return;
    }
    int insertCount = 10;
    const char* strData = "This is a test.";
    //7. 基于已有的SQL语句，迭代的绑定不同的变量数据
    for (int i = 0; i < insertCount; ++i) {
        //在绑定时，最左面的变量索引值是1。
        sqlite3_bind_int(stmt3,1,i);
        sqlite3_bind_double(stmt3,2,i * 1.0);
        sqlite3_bind_text(stmt3,3,strData,strlen(strData),SQLITE_TRANSIENT);
        if (sqlite3_step(stmt3) != SQLITE_DONE) {
            sqlite3_finalize(stmt3);
            sqlite3_close(conn);
            return;
        }
        //重新初始化该sqlite3_stmt对象绑定的变量。
        sqlite3_reset(stmt3);
        printf("Insert Succeed.\n");
    }
    sqlite3_finalize(stmt3);

    //8. 提交之前的事物。
    const char* commitSQL = "COMMIT";
    sqlite3_stmt* stmt4 = NULL;
    if (sqlite3_prepare_v2(conn,commitSQL,strlen(commitSQL),&stmt4,NULL) != SQLITE_OK) {
        if (stmt4)
            sqlite3_finalize(stmt4);
        sqlite3_close(conn);
        return;
    }
    if (sqlite3_step(stmt4) != SQLITE_DONE) {
        sqlite3_finalize(stmt4);
        sqlite3_close(conn);
        return;
    }
    sqlite3_finalize(stmt4);

    //9. 为了方便下一次测试运行，我们这里需要删除该函数创建的数据表，否则在下次运行时将无法
    //创建该表，因为它已经存在。
    const char* dropSQL = "DROP TABLE TESTTABLE";
    sqlite3_stmt* stmt5 = NULL;
    if (sqlite3_prepare_v2(conn,dropSQL,strlen(dropSQL),&stmt5,NULL) != SQLITE_OK) {
        if (stmt5)
            sqlite3_finalize(stmt5);
        sqlite3_close(conn);
        return;
    }
    if (sqlite3_step(stmt5) == SQLITE_DONE) {
        printf("The test table has been dropped.\n");
    }
    sqlite3_finalize(stmt5);
    sqlite3_close(conn);
}

int main()
{
    doTest();
    return 0;
}
//输出结果如下：
//Succeed to create test table now.
//Insert Succeed.
//Insert Succeed.
//Insert Succeed.
//Insert Succeed.
//Insert Succeed.
//Insert Succeed.
//Insert Succeed.
//Insert Succeed.
//Insert Succeed.
//Insert Succeed.
//The test table has been dropped.
