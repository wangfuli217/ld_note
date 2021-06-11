//һ����ȡ���Schema��Ϣ��
//    1). ��̬������
//    2). ����sqlite3�ṩ��API����ȡ���ֶε���Ϣ�����ֶ������Լ�ÿ���ֶε����͡�
//    3). ɾ���ñ�
#include <sqlite3.h>
#include <stdio.h>
#include <string>
#include <string.h>

using namespace std;

//����д�ַ�ת����Сд
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
    //5. �����ѯ�����ݵ�sqlite3_stmt����
    const char* selectSQL = "SELECT * FROM TESTTABLE WHERE 1 = 0";
    sqlite3_stmt* stmt2 = NULL;
    if (sqlite3_prepare_v2(conn,selectSQL,strlen(selectSQL),&stmt2,NULL) != SQLITE_OK) {
        if (stmt2)
            sqlite3_finalize(stmt2);
        sqlite3_close(conn);
        return;
    }
    //6. ����select���Ķ��󣬻�ȡ������е��ֶ�������
    int fieldCount = sqlite3_column_count(stmt2);
    printf("The column count is %d.\n",fieldCount);
    //7. �����������ÿ���ֶ�meta��Ϣ������ȡ������ʱ�����͡�
    for (int i = 0; i < fieldCount; ++i) {
        //���ڴ�ʱTable�в����������ݣ����о���SQLite�е��������ͱ����Ƕ�̬�ģ�������û������ʱ
        //�޷�ͨ��sqlite3_column_type������ȡ����ʱsqlite3_column_typeֻ�᷵��SQLITE_NULL��
        //ֱ��������ʱ���ܷ��ؾ�������ͣ��������ʹ����sqlite3_column_decltype��������ȡ����
        //��ʱ�������������͡�
        string stype = sqlite3_column_decltype(stmt2,i);
        stype = strlwr((char*)stype.c_str());
        //����Ľ����������ϵ�еġ���������-->1. �����ֶ���Ե�ԵĹ��򡱲��֣����������£�
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
    //8. Ϊ�˷�����һ�β������У�����������Ҫɾ���ú������������ݱ��������´�����ʱ���޷�
    //�����ñ���Ϊ���Ѿ����ڡ�
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
//������Ϊ��
//Succeed to create test table now.
//The column count is 3.
//The type of 0th column is INTEGER.
//The type of 1th column is DOUBLE.
//The type of 2th column is TEXT.
//The test table has been dropped.
