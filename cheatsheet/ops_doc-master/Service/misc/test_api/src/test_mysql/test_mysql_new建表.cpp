#include <mysql.h>

#include <string>
#include <iostream>
#include <vector>

#include <string.h>

using namespace std;

class MySQLManager {
public:
    /*
     * Init MySQL
     * @param hosts:         Host IP address
     * @param userName:        Login UserName
     * @param password:        Login Password
     * @param dbName:        Database Name
     * @param port:                Host listen port number
     */
    MySQLManager(std::string hosts, std::string userName, std::string password,
            std::string dbName, unsigned int port);
    ~MySQLManager();
    void initConnection();
    /*
     * Making query from database
     * @param mysql:        MySQL Object
     * @param sql:                Running SQL command
     */
    bool runSQLCommand(std::string sql);
    /*
     * 执行插入语句
     * @param sql: 执行的SQL语句
     * @return: 受影响的行数
     */
    unsigned int insert(std::string sql);
    /**
     * Destroy MySQL object
     * @param mysql                MySQL object
     */
    void destroyConnection();
    bool getConnectionStatus();
    vector<vector<string> > getResult();
protected:
    void setUserName(std::string userName);
    void setHosts(std::string hosts);
    void setPassword(std::string password);
    void setDBName(std::string dbName);
    void setPort(unsigned int port);
private:
    bool IsConnected;
    vector<vector<string> > resultList;
    MYSQL mySQLClient;
    unsigned int DEFAULTPORT;
    char * HOSTS;
    char * USERNAME;
    char * PASSWORD;
    char * DBNAME;
};

MySQLManager::MySQLManager(string hosts, string userName, string password,
        string dbName, unsigned int port) {
    IsConnected = false;
    this->setHosts(hosts);            //    设置主机IP地址
    this->setUserName(userName);            //    设置登录用户名
    this->setPassword(password);            //    设置登录密码
    this->setDBName(dbName);            //    设置数据库名
    this->setPort(port);            //    设置端口号
}

MySQLManager::~MySQLManager() {
    this->destroyConnection();
}

void MySQLManager::setDBName(string dbName) {
    if (dbName.empty()) {            //        用户没有指定数据库名
        std::cout << "DBName is null! Used default value: mysql" << std::endl;
        this->DBNAME = new char[5];
        strcpy(this->DBNAME, "mysql");
    } else {
        this->DBNAME = new char[dbName.length()];
        strcpy(this->DBNAME, dbName.c_str());
    }
}

void MySQLManager::setHosts(string hosts) {
    if (hosts.empty()) {            //    用户没有指定数据库IP地址
        std::cout << "Hosts is null! Used default value: localhost"
                << std::endl;
        this->HOSTS = new char[9];
        strcpy(this->HOSTS, "localhost");
    } else {
        this->HOSTS = new char[hosts.length()];
        strcpy(this->HOSTS, hosts.c_str());
    }
}

void MySQLManager::setPassword(string password) {            //    用户没有指定密码
    if (password.empty()) {
        std::cout << "Password is null! Used default value: " << std::endl;
        this->PASSWORD = new char[1];
        strcpy(this->PASSWORD, "");
    } else {
        this->PASSWORD = new char[password.length()];
        strcpy(this->PASSWORD, password.c_str());
    }
}

void MySQLManager::setPort(unsigned int port) {          //    用户没有指定端口号，使用默认端口号
    if (port <= 0) {
        std::cout << "Port number is null! Used default value: 0" << std::endl;
        this->DEFAULTPORT = 0;
    } else {
        this->DEFAULTPORT = port;
    }
}

void MySQLManager::setUserName(string userName) {            //    用户没有指定登录用户名
    if (userName.empty()) {
        std::cout << "UserName is null! Used default value: root" << std::endl;
        this->USERNAME = new char[4];
        strcpy(this->USERNAME, "root");
    } else {
        this->USERNAME = new char[userName.length()];
        strcpy(this->USERNAME, userName.c_str());
    }
}

void MySQLManager::initConnection() {
    if (IsConnected) {            //    已经连接到服务器
        std::cout << "Is connected to server!" << std::endl;
        return;
    }
    mysql_init(&mySQLClient);            //    初始化相关对象
    if (!mysql_real_connect(&mySQLClient, HOSTS, USERNAME, PASSWORD, DBNAME,
            DEFAULTPORT, NULL, 0)) {            //    连接到服务器
        cout << "HHHHHHHHHHHHH" << endl;
        std::cout << "Error connection to database: \n"
                << mysql_error(&mySQLClient) << std::endl;
    }
    IsConnected = true;            //    修改连接标识
}

bool MySQLManager::runSQLCommand(string sql) {
    if (!IsConnected) {            //    没有连接到服务器
        std::cout << "Not connect to database!" << std::endl;
        return false;
    }
    if (sql.empty()) {            //    SQL语句为空
        std::cout << "SQL is null!" << std::endl;
        return false;
    }

    MYSQL_RES *res;
    MYSQL_ROW row;

    unsigned int i, j = 0;

    i = mysql_real_query(&mySQLClient, sql.c_str(),
            (unsigned int) strlen(sql.c_str()));            //    执行查询
    if (i < 0) {
        std::cout << "Error query from database: \n"
                << mysql_error(&mySQLClient) << std::endl;
        return false;
    }
    res = mysql_store_result(&mySQLClient);
    vector < string > objectValue;
    while ((row = mysql_fetch_row(res))) {            //    遍历结果集
        objectValue.clear();
        for (j = 0; j < mysql_num_fields(res); j++) {
            objectValue.push_back(row[j]);
        }
        this->resultList.push_back(objectValue);
    }
    mysql_free_result(res);         //free result after you get the result

    return true;
}

unsigned int MySQLManager::insert(std::string sql) {
    if (!isConnected) {
        cout << "" << endl;
        return -1;
    }
    if (sql.empty()) {
        cout << "sql is null " << endl;
        return -1;
    }
    int rows = -1;
    int res = mysql_query(&mySQLClient, sql.c_str());
    if (res >= 0) {
        // 返回受影响的行数
        rows = mysql_affected_rows(&mySQLClient);
        cout << "Inserted " << rows << " rows\n";
        return rows;
    } else {
        cout << "Insert error " << mysql_errno(&mySQLClient) << ","
                << mysql_error(&mySQLClient) << endl;
        return -1;
    }
}

vector<vector<string> > MySQLManager::getResult() {
    return resultList;
}

void MySQLManager::destroyConnection() {
    mysql_close(&mySQLClient);
    this->IsConnected = false;
}

bool MySQLManager::getConnectionStatus() {
    return IsConnected;
}

using namespace std;

int main() {
    MySQLManager *mysql = new MySQLManager("127.0.0.1", "root", "xufeiyang",
            "mytest", (unsigned int) 3306);
    mysql->initConnection();
    if (mysql->getConnectionStatus()) {
        if (mysql->runSQLCommand("select * from student")) {
            vector < vector<std::string> > result = mysql->getResult();
            for (auto & vec : result) {
                for (auto &str : vec) {
                    cout << str.c_str() << " ";
                }
                cout << endl;
            }
        } else
            cout << "执行失败" << endl;
    } else
        cout << "连接未建立" << endl;

    return 0;
}

