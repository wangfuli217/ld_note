//二、常规数据插入：
//    1). 创建测试数据表。
//    2). 通过INSERT语句插入测试数据。
//    3). 删除测试表。

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

    int insertCount = 10;
    //5. 构建插入数据的sqlite3_stmt对象。
    const char* insertSQL = "INSERT INTO TESTTABLE VALUES(%d,%f,'%s')";
    const char* testString = "this is a test.";
    char sql[1024];
    sqlite3_stmt* stmt2 = NULL;
    for (int i = 0; i < insertCount; ++i) {
        sprintf(sql,insertSQL,i,i * 1.0,testString);
        if (sqlite3_prepare_v2(conn,sql,strlen(sql),&stmt2,NULL) != SQLITE_OK) {
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
        printf("Insert Succeed.\n");
    }
    sqlite3_finalize(stmt2);
    //6. 为了方便下一次测试运行，我们这里需要删除该函数创建的数据表，否则在下次运行时将无法
    //创建该表，因为它已经存在。
    const char* dropSQL = "DROP TABLE TESTTABLE";
    sqlite3_stmt* stmt3 = NULL;
    if (sqlite3_prepare_v2(conn,dropSQL,strlen(dropSQL),&stmt3,NULL) != SQLITE_OK) {
        if (stmt3)
            sqlite3_finalize(stmt3);
        sqlite3_close(conn);
        return;
    }
    if (sqlite3_step(stmt3) == SQLITE_DONE) {
        printf("The test table has been dropped.\n");
    }
    sqlite3_finalize(stmt3);
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
