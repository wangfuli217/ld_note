#include "database.h"

DatabaseConnection* connect_to_product_database(void);

/* Connect to the database containing customer information. */
DatabaseConnection* connect_to_product_database(void) 
{
    return connect_to_database("products.abcd.org", 322);   //链接数据路的url和port
}

