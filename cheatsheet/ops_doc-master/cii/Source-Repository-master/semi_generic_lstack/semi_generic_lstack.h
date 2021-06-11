#ifndef __SEMI_GENERIC_lstack_H__
#define __SEMI_GENERIC_lstack_H__
#include "typedef.h"
/* Initialize a linked lstack */
extern PtLStack_t create_lstack(int dataSize,UdFreeNode_t free_node,UdShowNode_t show_node);

/* Return true if S is empty */
extern int is_empty_lstack(PtLStack_t S);

/* Insert a node at the head */
extern int push_lstack(PtLStack_t S,DataAddr_t dataAddr);

/* Delete the node at the head, 
 * the space pointed by dataAddr must be enough to contain data*/
extern int pop_lstack(PtLStack_t S,DataAddr_t dataAddr);

/* Show data in S */
extern int show_lstack(PtLStack_t S);

/* Destroy S */
extern int destroy_lstack(PtLStack_t S);

/* Save S to file */
extern int save_lstack_to_file(PtLStack_t S,const char* filepath);

/* Load S from file */
extern int load_lstack_from_file(PtLStack_t S,const char* filepath);

#endif //__SEMI_GENERIC_lstack_H___











































































