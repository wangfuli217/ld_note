/*
 * =====================================================================================
 *
 *       Filename:  main.c
 *
 *    Description:  pkt_cache test
 *
 *        Version:  1.0
 *        Created:  12/24/2013 10:11:49 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *   Organization:  
 *
 * =====================================================================================
 */
#include <stdlib.h>
#include <stdio.h>
#include "lja_pkt_cache.h"

int main(int argc, char const* argv[])
{
	pkt_cache_module_test();
	printf("OK!\n");
	return 0;
}

