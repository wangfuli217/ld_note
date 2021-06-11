/*
 * =====================================================================================
 *
 *       Filename:  hash_file.c
 *
 *    Description:  copied from 'Experts in C'
 *
 *        Version:  1.0
 *        Created:  31.01.10
 *       Revision:  
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (ZY), imyeyeslove@163.com
 *        Company:  
 *
 * =====================================================================================
 */
#include	<stdlib.h>

#define 	FILE_HASH	1000

struct s_file {
	struct file *flink;
	char *fname;
};				/* ----------  end of struct file  ---------- */
typedef struct s_file file;



int main(int argc, char *argv[])
{
	file_hash_table = (file *) calloc((size_t) (FILE_HASH), sizeof(file));
	if (file_hash_table == NULL) {
		fprintf(stderr, "\ndynamic memory allocation failed\n");
		exit(EXIT_FAILURE);
	}

	free(file_hash_table);
	file_hash_table = NULL;

	return EXIT_SUCCESS;
}				/* ----------  end of function main  ---------- */


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  hash_file
 *  Description:  calculate the hash key
 * =====================================================================================
 */
int hash_file()
{
//      int length = strlen(str);
//      return (length + 4 * (str[0] + 4 * str[length / 2])) % FILE_HASH;
	return 0;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  find_file_name
 *  Description:  check whether a certain file name has been in the hash table
 * =====================================================================================
 */
file find_file_name(char *str)
{
	int hash_val = hash_file(str);
	file f;

	for (f = file_hash_table[hash_val]; f != NIL; f = f->flink) {
		if (strcmp(f->fname, str) == SAME) {
			return f;
		}
	}

	/*-----------------------------------------------------------------------------
	 *  nowhere, make it a new one
	 *-----------------------------------------------------------------------------*/
	f = allocate_file(str);
	f->flink = file_hash_table[hash_val];
	file_hash_table[hash_val] = f;

	return f;
}
