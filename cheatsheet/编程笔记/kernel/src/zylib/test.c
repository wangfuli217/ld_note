/*
 * =====================================================================================
 *
 *       Filename:  test.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  20.03.10
 *       Revision:  
 *       Compiler:  GCC 4.4.3
 *
 *         Author:  Yang Zhang, imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#include	"point.h"


#include	<stdlib.h>

	int
main ( int argc, char *argv[] )
{
	init_point();
	void * p = new(point, 1, 2);
	draw(p);

	return EXIT_SUCCESS;
}				/* ----------  end of function main  ---------- */
