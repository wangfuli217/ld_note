#ifndef __HASH_H__KJAHC38DJ__
#define __HASH_H__KJAHC38DJ__

#include "../hash_table.h"
#include "file.h"

typedef void (*TestFunction)(void*);

typedef enum {INT, STR, FLOAT} type;

struct param {
  Entry_p* aEntry;
  size_t asize;
  HashTable_p hash_table;
  type val;
};

#endif
