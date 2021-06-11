#ifndef DB_H
#define DB_H

#include "table.h"

extern table_t s_db;

int db_init();
int db_dstr();

#endif
