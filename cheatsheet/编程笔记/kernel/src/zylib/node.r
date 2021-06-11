/*
 * =====================================================================================
 *
 *       Filename:  node.r
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  29.03.10 19:30
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (), imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */
#ifndef		NODE_R
#define		NODE_R

#ifndef		TYPE
#define		TYPE			int
#endif

struct node {
	struct node * link;
	TYPE x;
};

#endif
