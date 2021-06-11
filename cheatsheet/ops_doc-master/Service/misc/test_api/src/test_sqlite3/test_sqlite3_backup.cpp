#include <sqlite3.h>
#include <stdio.h>
#include <string>
#include <string.h>

//����˵��:
//pInMemory: ָ���ڴ����ݿ�ָ��
//zFilename: ָ���ļ����ݿ�Ŀ¼���ַ���ָ��
//isSave  0: ���ļ����ݿ����뵽�ڴ����ݿ� 1�����ڴ����ݿⱸ�ݵ��ļ����ݿ�
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

    //1. �����ڴ����ݿ�
    int result = sqlite3_open("memory:", &connMemory);
    if (result != SQLITE_OK) {
        sqlite3_close(connMemory);
        return;
    }
    printf("Create memory database succeed.\n");

    //2. �ļ����ݿ⵼�뵽�ڴ����ݿ�
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

    //3. ׼���������ݱ��������ʧ�ܣ���Ҫ��sqlite3_finalize�ͷ�sqlite3_stmt�����Է�ֹ�ڴ�й¶��
    if (sqlite3_prepare_v2(connMemory,createTableSQL,len,&stmt,NULL) != SQLITE_OK) {
        if (stmt)
            sqlite3_finalize(stmt);
        sqlite3_close(connMemory);
        return;
    }

    //4. ͨ��sqlite3_step����ִ�д��������䡣����DDL��DML�����ԣ�sqlite3_stepִ����ȷ�ķ���ֵ
    //ֻ��SQLITE_DONE������SELECT��ѯ���ԣ���������ݷ���SQLITE_ROW������������ĩβʱ�򷵻�
    //SQLITE_DONE��
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        sqlite3_finalize(stmt);
        sqlite3_close(connMemory);
        return;
    }

    //5. �ͷŴ��������������Դ��
    sqlite3_finalize(stmt);
    printf("Succeed to create test table now in the memory database.\n");

    int insertCount = 5;
    //6. �����������ݵ�sqlite3_stmt����
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

    //2. �ڴ����ݿ⵼���ļ����ݿ�
    result = loadOrSaveDb(connMemory, "./mytest.db", 1);
    if (result != SQLITE_OK) {
        sqlite3_close(connMemory);
        return;
    }
    printf("Load file database from memory succeed.\n");
    sqlite3_close(connMemory);

    sqlite3* conn = NULL;
    //7. �����ݿ�
    result = sqlite3_open("./mytest.db",&conn);
    if (result != SQLITE_OK) {
        sqlite3_close(conn);
        return;
    }
    printf("Open file database succeed.\n");

    //8. ִ��SELECT����ѯ���ݡ�
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
                //������Ҫ���жϵ�ǰ��¼��ǰ�ֶε����ͣ��ٸ��ݷ��ص�����ʹ�ò�ͬ��API����
                //��ȡʵ�ʵ�����ֵ��
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

    //8. Ϊ�˷�����һ�β������У�����������Ҫɾ���ú������������ݱ��������´�����ʱ���޷�
    //�����ñ���Ϊ���Ѿ����ڡ�
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
