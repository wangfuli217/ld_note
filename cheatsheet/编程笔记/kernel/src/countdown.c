/*
 * =====================================================================================
 *
 *       Filename:  countdown.c
 *
 *    Description:  just 4 my job application
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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <errno.h>

int month2days(int);

int main(int argc, char *argv[])
{
	int day = 30;
	int month = 6;
	int now;
	int goal;

	/*-----------------------------------------------------------------------------
	 *  allocate space for timep, no initialization, but the address is sure
	 *  if use "time_t *timep", just allocate space for a pointer,
	 *  'cause no initialization, it has random value, so it could point to anywhere,
	 *  namely not a certain address
	 *-----------------------------------------------------------------------------*/
	time_t timep;
	struct tm *tm_time;

	/*-----------------------------------------------------------------------------
	 *  1st    time(time_t *a)	to fill
	 *  2nd  gmtime(time_t *a)	to deal
	 *-----------------------------------------------------------------------------*/
	if (time(&timep) == (time_t) -1) {
		fprintf(stderr, "ERROR: %s\n", strerror(errno)); /* strerror -- string.h */
	}
	tm_time = gmtime(&timep);

	now = month2days(tm_time->tm_mon + 1) + tm_time->tm_mday; /* tm_mon, 0~11 */
	goal = month2days(month) + day;

	printf("Hey bro, only ----- %d ----- days left!!\n", goal - now);
	printf("Hurry up!\t\t\tU Can Make It!!\n");

	return EXIT_SUCCESS;
}				/* ----------  end of function main  ---------- */

int month2days(int month)
{
	int month2days = 0;                                     /* same name with it's func */

	/*-----------------------------------------------------------------------------
	 *  NO BREAK!!!
	 *  i like C switch strategy here, but only here...
	 *
	 *  if month == n, total = 1 + 2 + 3 + ... + (n - 1)
	 *-----------------------------------------------------------------------------*/
	switch (month) {
	case 12:
		month2days += 30;
	case 11:
		month2days += 31;
	case 10:
		month2days += 30;
	case 9:
		month2days += 31;
	case 8:
		month2days += 31;
	case 7:
		month2days += 30;
	case 6:
		month2days += 31;
	case 5:
		month2days += 30;
	case 4:
		month2days += 31;
	case 3:
		month2days += 28;
	case 2:
		month2days += 31;
	case 1:
		break;		/* terminator */
	default:
		fprintf(stderr, "not a digit between 1 and 12");
		return EXIT_FAILURE;
	}			/* -----  end switch  ----- */

	return month2days;
}				/* -----  end of function month2days  ----- */
