/*
 * =====================================================================================
 *
 *       Filename:  max_malloc.c
 *
 *    Description:  get the maximum of malloc'd space
 *    		    max == 2942001091 bytes
 *    		    namely 2.9G
 *
 *        Version:  1.0
 *        Created:  03.03.10
 *       Revision:  
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (ZY), imyeyeslove@163.com
 *        Company:  
 *
 * =====================================================================================
 */

#include	<stdio.h>
#include	<stdlib.h>

int main(int argc, char *argv[])
{
	void *p;
	unsigned max = 0;
	unsigned max_test = 0;
	unsigned pow = 1024 * 1024;
	unsigned block[3] = { pow, 1024, 1 };

	/*-----------------------------------------------------------------------------
	 *  1st, block == 1024^2
	 *  when no more place for 1024^2
	 *  2nd, block == 1024
	 *  when no more place for 1024
	 *  3rd, block == 1
	 *-----------------------------------------------------------------------------*/
	for (int i = 0; i < 3; i += 1) {
		for (int j = 1;; j += 1) {
			max_test = max + block[i] * j;
			p = malloc(max_test);
			if (p) {
				max = max_test;
				free(p);
			} else {
				break;
			}
		}
	}

	printf("Max: %u\n", max);
	return EXIT_SUCCESS;
}				/* ----------  end of function main  ---------- */
