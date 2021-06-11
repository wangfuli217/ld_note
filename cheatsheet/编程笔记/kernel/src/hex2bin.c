/*
 * =====================================================================================
 *
 *       Filename:  hex2bin.c
 *
 *    Description:  input  -- hex/dec
 *    		    output -- bin
 *
 *        Version:  1.0
 *        Created:  26.02.10
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
#include	<math.h>

#define		STACK_TYPE		char
#include	<zy/stack.h>

static int atoh(char *);

int main(int argc, char *argv[])
{
	/* dec -> bin */
	/* int num = atoi(argv[1]); */
	/* hex -> bin */
	char c;
	int num = atoh(argv[1]);
	
	int remainder;
	int flag_space = 0;
	int fill = 0;
	stack_t *stk_p = stack_create();

	while (num) {
		/*-----------------------------------------------------------------------------
		 *  space to separate every 4 chars
		 *-----------------------------------------------------------------------------*/
		if (flag_space == 4) {
			stack_push(stk_p, ' ');                 /* push ' ' */
			flag_space = 0;                         /* clear */
			fill=0;                                 /* clear */
		}
		remainder = num % 2;
		stack_push(stk_p, (char)(remainder + '0'));    /* 1 -> '1' */
		num /= 2;                                       /* quotient */
		flag_space++;
		fill++;
	}

	/*-----------------------------------------------------------------------------
	 *  fill 0 to make the length be multiply of 4
	 *-----------------------------------------------------------------------------*/
	fill = 4 - fill;
	while (fill) {
		stack_push(stk_p, '0');                         /* push '0' */
		fill--;
	}


	/*-----------------------------------------------------------------------------
	 *  output
	 *-----------------------------------------------------------------------------*/
	printf("Bin:\t");
        while (c = stack_pop(stk_p)) {                          /* latest to oldest */
		printf("%c", c);
	}
	printf("\n");

	/*-----------------------------------------------------------------------------
	 *  free all
	 *-----------------------------------------------------------------------------*/
	stack_free(stk_p);

	return 0;
}				/* ----------  end of function main  ---------- */


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  atoh
 *  Description:  string to hex
 * =====================================================================================
 */
static int atoh(char *buf)
{
	char c;
	char *p = buf;
	double i = 0;
	double num = 0;


	/*-----------------------------------------------------------------------------
	 *  move the pointer to the end
	 *-----------------------------------------------------------------------------*/
	while (*(p + 1)) {
		p++;
	}

	/*-----------------------------------------------------------------------------
	 *  0x11 == 1 * 16^0 + 1* 16^1
	 *-----------------------------------------------------------------------------*/
	while (p >= buf) {
		c = *p;

		if (c > 0x40 && c < 0x47) {                     /* A-F */
			num += (c - 'A' + 10) * pow(16.0, i);
		} else if (c > 0x60 && c < 0x67) {              /* a-f */
			num += (c - 'a' + 10) * pow(16.0, i);
		} else {
			num += (c - '0') * pow(16.0, i);       /* 0-9 */
		}

		i += 1.0;
		p--;
	}
	printf("num: %d\n", (int)num);

	return (int) num;
}
