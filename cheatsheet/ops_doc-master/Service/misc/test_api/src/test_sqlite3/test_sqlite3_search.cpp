//�ġ����ݲ�ѯ��
//    ���ݲ�ѯ��ÿ����ϵ�����ݿⶼ���ṩ����������ܣ�����Ĵ���ʾ�����������ͨ��SQLite API��ȡ���ݡ�
//    1). �����������ݱ�
//    2). ����һ���������ݵ������ݱ��Ա��ں���Ĳ�ѯ��
//    3). ִ��SELECT���������ݡ�
//    4). ɾ�����Ա�

#include <sqlite3.h>
#include <string>
#include <stdio.h>
#include <string.h>

using namespace std;

void doTest()
{
    sqlite3* conn = NULL;
    //1. �����ݿ�
    int result = sqlite3_open("./mytest.db",&conn);
    if (result != SQLITE_OK) {
        sqlite3_close(conn);
        return;
    }
    const char* createTableSQL =
        "CREATE TABLE TESTTABLE (int_col INT, float_col REAL, string_col TEXT)";
    sqlite3_stmt* stmt = NULL;
    int len = strlen(createTableSQL);
    //2. ׼���������ݱ��������ʧ�ܣ���Ҫ��sqlite3_finalize�ͷ�sqlite3_stmt�����Է�ֹ�ڴ�й¶��
    if (sqlite3_prepare_v2(conn,createTableSQL,len,&stmt,NULL) != SQLITE_OK) {
        if (stmt)
            sqlite3_finalize(stmt);
        sqlite3_close(conn);
        return;
    }
    //3. ͨ��sqlite3_step����ִ�д��������䡣����DDL��DML�����ԣ�sqlite3_stepִ����ȷ�ķ���ֵ
    //ֻ��SQLITE_DONE������SELECT��ѯ���ԣ���������ݷ���SQLITE_ROW������������ĩβʱ�򷵻�
    //SQLITE_DONE��
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        sqlite3_finalize(stmt);
        sqlite3_close(conn);
        return;
    }
    //4. �ͷŴ��������������Դ��
    sqlite3_finalize(stmt);
    printf("Succeed to create test table now.\n");

    //5. Ϊ����Ĳ�ѯ��������������ݡ�
    sqlite3_stmt* stmt2 = NULL;
    const char* insertSQL = "INSERT INTO TESTTABLE VALUES(20,21.0,'this is a test.')";
    if (sqlite3_prepare_v2(conn,insertSQL,strlen(insertSQL),&stmt2,NULL) != SQLITE_OK) {
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
    printf("Succeed to insert test data.\n");
    sqlite3_finalize(stmt2);

    //6. ִ��SELECT����ѯ���ݡ�
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

    //7. Ϊ�˷�����һ�β������У�����������Ҫɾ���ú������������ݱ��������´�����ʱ���޷�
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
}

int main()
{
    doTest();
    return 0;
}
//���������£�
//Succeed to create test table now.
//Succeed to insert test data.
//The INTEGER value is 20.
//The DOUBLE value is 21.000000.
//The TEXT value is this is a test..
//Select Finished.
//The test table has been dropped.
