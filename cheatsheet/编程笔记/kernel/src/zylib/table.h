/*
 * =====================================================================================
 *
 *       Filename:  table.h
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04.03.10 01:32
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (ZY), imyeyeslove@163.com
 *        Company:  
 *
 * =====================================================================================
 */

typedef int (*table_cmp)(const void *, const void *);
typedef unsigned (*table_hash)(const void *);

struct table_n {
	struct table_n *link;
	const void *keyword;
	const void *value;
};
typedef struct table_n table_n;

struct table_desc {
	int size;
	table_cmp cmp;
	table_hash hash;
	table_n **ptr;
};
typedef struct table_desc table_desc;
