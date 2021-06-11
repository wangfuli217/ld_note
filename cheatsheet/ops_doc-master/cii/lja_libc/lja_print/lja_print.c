#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include "lja_print.h"

void
lja_print_x(
	char *prefix,
	char *suffix,
	char *inter,
	char *mem,
	int len)
{
	printf("%s",prefix);

	int i = 0;
	while(i<len){
		printf("%02x%s", *(mem+i) &0xff, inter);
		i++;
	}

	printf("%s",suffix);
}

void
lja_print_X(
	char *prefix,
	char *suffix,
	char *inter,
	char *mem,
	int len)
{
	printf("%s",prefix);

	int i = 0;
	while(i<len){
		printf("%02X%s", *(mem+i) &0xff, inter);
		i++;
	}

	printf("%s",suffix);
}

// TODO:
#if 0
void
lja_print_stat(
	char *prefix,
	char *suffix,
	struct stat *buf)
{
	printf("%s",prefix);

	printf("dev_t (device id): %d", stat->st_dev);
	printf("st_ino (inode)   : %d", stat->st_dev);
	printf("mode_t (mode)"   :    , stat->st_mode);
	printf("nlink_t (nlink_t):  " , stat->")



	printf("%s",suffix);
}
#endif
