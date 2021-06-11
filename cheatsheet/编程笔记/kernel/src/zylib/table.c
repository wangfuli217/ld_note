/*
 * =====================================================================================
 *
 *       Filename:  table.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04.03.10
 *       Revision:  
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (ZY), imyeyeslove@163.com
 *        Company:  
 *
 * =====================================================================================
 */

#include	<zy/alloc.h>

#define		DESC_SIZE		sizeof(table_desc)

table_desc *table_create(int hint, table_cmp cmp, table_hash hash)
{
	table_desc *table = CALLOC(1, DESC_SIZE);
	table_n **ptr;
	int primes[] = { 509, 1021, 2053, 4093, 8191, 16381, 32771, 65521, INT_MAX };

	for ( int i = 0; i < 9; i += 1 ) {
		if (hint < primes[i]) {
			break;
		}
	}

	table->size = primes[i - 1];
	table->cmp = cmp ? cmp : cmp_default;
	table->hash = hash ? hash : hash_default;
	ptr = (table_n **)CALLOC(primes[i], sizeof(table_n *));

	if (ptr) {
		table->ptr = ptr;
		return table;
	} else {
		failure("Calloc Node Failure!\n");
	}
}
