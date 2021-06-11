
typedef struct DatabaseConnection DatabaseConnection;

/* Function that takes an SQL query string and sets results to an array of
  pointers with the result of the query.  The value returned specifies the
  number of items in the returned array of results.  The returned array of
  results are statically allocated and should not be deallocated using free()
 
  函数使用SQL查询字符串并将查询到的结果放到一个指针数组，
  返回值是数组的项数（查询结果的个数），数组是静态分配的，不应该使用free()释放。
 */
typedef unsigned int (*QueryDatabase)( DatabaseConnection* const connection, const char * const query_string,void *** const results);

/* Connection to a database. */
struct DatabaseConnection 
{
    const char *url;
    unsigned int port;
    QueryDatabase query_database;  //query_database(connection,query_string,results)
};

DatabaseConnection* connect_to_database(const char * const url,const unsigned int port);
//struct DatabaseConnection  *connect_to_database(); 返回的是一个结构体指针。
