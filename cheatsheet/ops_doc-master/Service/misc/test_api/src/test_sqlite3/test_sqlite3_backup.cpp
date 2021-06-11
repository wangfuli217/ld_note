#include <sqlite3.h>
#include <stdio.h>
#include <string>
#include <string.h>

//参数说明:
//pInMemory: 指向内存数据库指针
//zFilename: 指向文件数据库目录的字符串指针
//isSave  0: 从文件数据库载入到内存数据库 1：从内存数据库备份到文件数据库
int loadOrSaveDb(sqlite3 *pInMemeory, const char *zFilename, int isSave) {
    int rc;
    sqlite3 *pFile;

    sqlite3_backup *pBackup;

    sqlite3 *pTo;
    sqlite3 *pFrom;

    rc = sqlite3_open(zFilename, &pFile);
    if (rc == SQLITE_OK) {
        pFrom = (isSave ? pInMemeory : pFile);
        pTo = (isSave ? pFile : pInMemeory);

        pBackup = sqlite3_backup_init(pTo, "main", pFrom, "main");
        if (pBackup) {
            (void) sqlite3_backup_step(pBackup, -1);
            (void) sqlite3_backup_finish(pBackup);
        }

        rc = sqlite3_errcode(pTo);
    }

    (void) sqlite3_close(pFile);

    return rc;
}

void doTest() {
    sqlite3 *connMemory = NULL;

    //1. 创建内存数据库
    int result = sqlite3_open("memory:", &connMemory);
    if (result != SQLITE_OK) {
        sqlite3_close(connMemory);
        return;
    }
    printf("Create memory database succeed.\n");

    //2. 文件数据库导入到内存数据库
    result = loadOrSaveDb(connMemory, "./mytest.db", 0);
    if (result != SQLITE_OK) {
        sqlite3_close(connMemory);
        return;
    }
    printf("Load file database to memory succeed.\n");

    const char* createTableSQL =
        "CREATE TABLE TESTTABLE (int_col INT, float_col REAL, string_col TEXT)";
    sqlite3_stmt* stmt = NULL;
    int len = strlen(createTableSQL);

    //3. 准备创建数据表，如果创建失败，需要用sqlite3_finalize释放sqlite3_stmt对象，以防止内存泄露。
    if (sqlite3_prepare_v2(connMemory,createTableSQL,len,&stmt,NULL) != SQLITE_OK) {
        if (stmt)
            sqlite3_finalize(stmt);
        sqlite3_close(connMemory);
        return;
    }

    //4. 通过sqlite3_step命令执行创建表的语句。对于DDL和DML语句而言，sqlite3_step执行正确的返回值
    //只有SQLITE_DONE，对于SELECT查询而言，如果有数据返回SQLITE_ROW，当到达结果集末尾时则返回
    //SQLITE_DONE。
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        sqlite3_finalize(stmt);
        sqlite3_close(connMemory);
        return;
    }

    //5. 释放创建表语句对象的资源。
    sqlite3_finalize(stmt);
    printf("Succeed to create test table now in the memory database.\n");

    int insertCount = 5;
    //6. 构建插入数据的sqlite3_stmt对象。
    const char* insertSQL = "INSERT INTO TESTTABLE VALUES(%d,%f,'%s')";
    const char* testString = "this is a test.";
    char sql[1024];
    sqlite3_stmt* stmt2 = NULL;
    for (int i = 0; i < insertCount; ++i) {
        sprintf(sql,insertSQL,i+100,i * 1.0,testString);
        if (sqlite3_prepare_v2(connMemory,sql,strlen(sql),&stmt2,NULL) != SQLITE_OK) {
            if (stmt2)
                sqlite3_finalize(stmt2);
            sqlite3_close(connMemory);
            return;
        }
        if (sqlite3_step(stmt2) != SQLITE_DONE) {
            sqlite3_finalize(stmt2);
            sqlite3_close(connMemory);
            return;
        }
        printf("Insert Succeed.\n");
    }
    sqlite3_finalize(stmt2);

    //2. 内存数据库导入文件数据库
    result = loadOrSaveDb(connMemory, "./mytest.db", 1);
    if (result != SQLITE_OK) {
        sqlite3_close(connMemory);
        return;
    }
    printf("Load file database from memory succeed.\n");
    sqlite3_close(connMemory);

    sqlite3* conn = NULL;
    //7. 打开数据库
    result = sqlite3_open("./mytest.db",&conn);
    if (result != SQLITE_OK) {
        sqlite3_close(conn);
        return;
    }
    printf("Open file database succeed.\n");

    //8. 执行SELECT语句查询数据。
    const char* selectSQL = "SELECT * FROM TESTTABLE";
    sqlite3_stmt* stmt3 = NULL;
    if (sqlite3_prepare_v2(conn,selectSQL,strlen(selectSQL),&stmt3,NULL) != SQLITE_OK) {
        if (stmt3)
            sqlite3_finalize(stmt3);
        sqlite3_close(conn);
        return;
    }
    int fieldCount = sqlite3_column_count(stmt3);
    do {
        int r = sqlite3_step(stmt3);
        if (r == SQLITE_ROW) {
            for (int i = 0; i < fieldCount; ++i) {
                //这里需要先判断当前记录当前字段的类型，再根据返回的类型使用不同的API函数
                //获取实际的数据值。
                int vtype = sqlite3_column_type(stmt3,i);
                if (vtype == SQLITE_INTEGER) {
                    int v = sqlite3_column_int(stmt3,i);
                    printf("The INTEGER value is %d.\n",v);
                } else if (vtype == SQLITE_FLOAT) {
                    double v = sqlite3_column_double(stmt3,i);
                    printf("The DOUBLE value is %f.\n",v);
                } else if (vtype == SQLITE_TEXT) {
                    const char* v = (const char*)sqlite3_column_text(stmt3,i);
                    printf("The TEXT value is %s.\n",v);
                } else if (vtype == SQLITE_NULL) {
                    printf("This value is NULL.\n");
                }
            }
        } else if (r == SQLITE_DONE) {
            printf("Select Finished.\n");
            break;
        } else {
            printf("Failed to SELECT.\n");
            sqlite3_finalize(stmt3);
            sqlite3_close(conn);
            return;
        }
    } while (true);
    sqlite3_finalize(stmt3);

    //8. 为了方便下一次测试运行，我们这里需要删除该函数创建的数据表，否则在下次运行时将无法
    //创建该表，因为它已经存在。
    const char* dropSQL = "DROP TABLE TESTTABLE";
    sqlite3_stmt* stmt4 = NULL;
    if (sqlite3_prepare_v2(conn,dropSQL,strlen(dropSQL),&stmt4,NULL) != SQLITE_OK) {
        if (stmt4)
            sqlite3_finalize(stmt4);
        sqlite3_close(conn);
        return;
    }
    if (sqlite3_step(stmt4) == SQLITE_DONE) {
        printf("The test table has been dropped.\n");
    }
    sqlite3_finalize(stmt4);
    sqlite3_close(conn);

    return;
}

int main()
{
    doTest();
    return 0;
}
