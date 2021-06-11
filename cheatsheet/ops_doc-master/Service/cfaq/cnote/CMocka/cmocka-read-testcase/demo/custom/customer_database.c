#include <stddef.h>
#include <stdio.h>
#include "database.h"

#ifdef _WIN32
#define snprintf _snprintf
#endif /* _WIN32 */

DatabaseConnection* connect_to_customer_database(void);

unsigned int get_customer_id_by_name(DatabaseConnection * const connection, const char * const customer_name);

/* Connect to the database containing customer information.
   链接到 用户信息数据库.
*/
DatabaseConnection* connect_to_customer_database(void) 
{
    return connect_to_database("customers.abcd.org", 321);
}

/* Find the ID of a customer by his/her name returning a value > 0 if successful, 0 otherwise. */
unsigned int get_customer_id_by_name(DatabaseConnection * const connection,const char * const customer_name)
 {
    char query_string[256];    //将查询到的字符串放到数组中
    int number_of_results;     //查询结果的个数；
    void **results;            //查询到的某个字符串
	
    snprintf(query_string, sizeof(query_string),"SELECT ID FROM CUSTOMERS WHERE NAME = %s", customer_name);
    number_of_results = connection->query_database(connection, query_string,&results);

    if (number_of_results != 1) 
	{
        return -1;
    }

    return (unsigned int)*((int *)results);
}
