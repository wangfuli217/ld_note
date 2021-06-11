/*
 * =====================================================================================
 *
 *       Filename:  stack.c
 *
 *    Description:  gdb 栈的使用,对栈的分析过程
 *
 *        Version:  1.0
 *        Created:  2013年02月10日 13时48分02秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  LeoK, 
 *   Organization:  
 *
 * =====================================================================================
 */
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#define  	MAX		(1UL<<20)

typedef unsigned long long u64;
typedef unsigned int u32;

u32 max_addend = MAX;
u64 sum_till_MAX(u32 n)
{
	u64 sum;
	n++;
	sum = n;
	
	if (n < max_addend)
	{
		sum += sum_till_MAX(n);
	}
	return sum;
}

int main(int argc, char** argv)
{
	u64 sum = 0;
	if (argc == 2 && isdigit(*(argv[1])))
		max_addend = strtoul(argv[1], NULL, 0);
	if (max_addend >= MAX || max_addend == 0)
	{
		fprintf(stderr, "Invalid number is specidied\n");
		return 1;
	}
	sum = sum_till_MAX(0);
	printf("sum(0..%lu) = %llu\n", max_addend, sum);
	return 0;
}
