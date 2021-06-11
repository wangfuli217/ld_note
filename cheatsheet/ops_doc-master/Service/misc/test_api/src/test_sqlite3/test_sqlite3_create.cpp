//一、获取表的Schema信息：
//    1). 动态创建表。
//    2). 根据sqlite3提供的API，获取表字段的信息，如字段数量以及每个字段的类型。
//    3). 删除该表。
#include <sqlite3.h>
#include <stdio.h>
#include <string>
#include <string.h>

using namespace std;

//将大写字符转换成小写
char *strlwr(char *s)
{
 char *str;
 str = s;
 while(*str != '\0')
 {
  if(*str >= 'A' && *str <= 'Z') {
     *str += 'a'-'A';
 }
 str++;
 }
 return s;
}

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
    //5. 构造查询表数据的sqlite3_stmt对象。
    const char* selectSQL = "SELECT * FROM TESTTABLE WHERE 1 = 0";
    sqlite3_stmt* stmt2 = NULL;
    if (sqlite3_prepare_v2(conn,selectSQL,strlen(selectSQL),&stmt2,NULL) != SQLITE_OK) {
        if (stmt2)
            sqlite3_finalize(stmt2);
        sqlite3_close(conn);
        return;
    }
    //6. 根据select语句的对象，获取结果集中的字段数量。
    int fieldCount = sqlite3_column_count(stmt2);
    printf("The column count is %d.\n",fieldCount);
    //7. 遍历结果集中每个字段meta信息，并获取其声明时的类型。
    for (int i = 0; i < fieldCount; ++i) {
        //由于此时Table中并不存在数据，再有就是SQLite中的数据类型本身是动态的，所以在没有数据时
        //无法通过sqlite3_column_type函数获取，此时sqlite3_column_type只会返回SQLITE_NULL，
        //直到有数据时才能返回具体的类型，因此这里使用了sqlite3_column_decltype函数来获取表声
        //明时给出的声明类型。
        string stype = sqlite3_column_decltype(stmt2,i);
        stype = strlwr((char*)stype.c_str());
        //下面的解析规则见该系列的“数据类型-->1. 决定字段亲缘性的规则”部分，其链接如下：
        //http://www.cnblogs.com/stephen-liu74/archive/2012/01/18/2325258.html
        if (stype.find("int") != string::npos) {
            printf("The type of %dth column is INTEGER.\n",i);
        } else if (stype.find("char") != string::npos
            || stype.find("text") != string::npos) {
            printf("The type of %dth column is TEXT.\n",i);
        } else if (stype.find("real") != string::npos
            || stype.find("floa") != string::npos
            || stype.find("doub") != string::npos ) {
            printf("The type of %dth column is DOUBLE.\n",i);
        }
    }
    sqlite3_finalize(stmt2);
    //8. 为了方便下一次测试运行，我们这里需要删除该函数创建的数据表，否则在下次运行时将无法
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
//输出结果为：
//Succeed to create test table now.
//The column count is 3.
//The type of 0th column is INTEGER.
//The type of 1th column is DOUBLE.
//The type of 2th column is TEXT.
//The test table has been dropped.
