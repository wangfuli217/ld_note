//������Ч���������ݲ��룺
//    �ڸ�����������֮ǰ�ȼ�˵��һ����������ĸ���԰�������Ķ�����ʾ�����롣��ʵ�ϣ��������벢����ʲô�µĸ����������ϵ�����ݿ��C�ӿ�API�ж��ṩ��һ����֧�֣�ֻ�ǽӿڵ�ʵ�ַ�ʽ��ͬ���ѡ��ݹ��ڶ����е����ݿ�ӿڣ���OCI(Oracle API)��MySQL API��PostgreSQL API�ȣ�OCI�ṩ�ı�̽ӿ���Ϊ���㣬ʵ�ַ�ʽҲ��Ϊ��Ч��SQLite��Ϊһ�ּ�����Ƕ��ʽ���ݿ�Ҳͬ���ṩ�˸ù��ܣ�����ʵ�ַ�ʽ�������������ݿ������������ԣ���ֻ��ͨ��һ�������ļ������ﵽ���������Ŀ�ģ����߼����£�
//    1). ��ʼһ������Ա�֤��������ݲ��������ڸ���������ɡ���SQLite�У����û���ֹ�����һ����������е�DML��䶼�����Զ��ύģʽ�¹����ģ���ÿ�β��������ݾ����Զ��ύ��д������ļ���Ȼ���ڷ��Զ��ύģʽ�£�ֻ�е������ڵ����ﱻ�ֹ�COMMIT֮��ŻὫ�޸ĵ�����д�뵽�����У�֮ǰ�޸ĵ����ݶ��ǽ���פ�����ڴ��С��Զ��׼�������������д�뷽ʽ��Ч�����Ʊػ�ԶԶ���ڶ����ʽ�ĵ���д�������
//    2). ���ڱ����󶨵ķ�ʽ׼������������ݣ��������Խ�ʡ������sqlite3_prepare_v2�������ô������Ӷ���ʡ�˶�ν�ͬһSQL�������SQLite�ڲ�ʶ����ֽ������õ�ʱ�䡣��ʵ�ϣ�SQLite�Ĺٷ��ĵ����Ѿ���ȷָ�����ںܶ�ʱ��sqlite3_prepare_v2������ִ��ʱ��Ҫ����sqlite3_step������ִ��ʱ�䣬��˽���ʹ����Ҫ���������ظ�����sqlite3_prepare_v2�����������ǵ�ʵ���У�����������࿪����ֻ�轫������������Ա�������ʽ�󶨵�SQL����У�������SQL���������sqlite3_prepare_v2��������һ�μ��ɣ����Ĳ���ֻ���滻��ͬ�ı�����ֵ��
//    3). ��������е����ݲ������ʽ���ύ����ύ��SQLite�Ὣ��ǰ�����Զ��ָ�Ϊ�Զ��ύģʽ��

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

    //5. ��ʽ�Ŀ���һ�����
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

    //6. �������ڰ󶨱����Ĳ������ݡ�
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
    //7. �������е�SQL��䣬�����İ󶨲�ͬ�ı�������
    for (int i = 0; i < insertCount; ++i) {
        //�ڰ�ʱ��������ı�������ֵ��1��
        sqlite3_bind_int(stmt3,1,i);
        sqlite3_bind_double(stmt3,2,i * 1.0);
        sqlite3_bind_text(stmt3,3,strData,strlen(strData),SQLITE_TRANSIENT);
        if (sqlite3_step(stmt3) != SQLITE_DONE) {
            sqlite3_finalize(stmt3);
            sqlite3_close(conn);
            return;
        }
        //���³�ʼ����sqlite3_stmt����󶨵ı�����
        sqlite3_reset(stmt3);
        printf("Insert Succeed.\n");
    }
    sqlite3_finalize(stmt3);

    //8. �ύ֮ǰ�����
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

    //9. Ϊ�˷�����һ�β������У�����������Ҫɾ���ú������������ݱ��������´�����ʱ���޷�
    //�����ñ���Ϊ���Ѿ����ڡ�
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
//���������£�
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
