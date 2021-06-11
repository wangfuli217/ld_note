#ifndef __SEMI_GENERIC_LQUEUE_H__
#define __SEMI_GENERIC_LQUEUE_H__

/* Initialize a linked queue */
extern PtLQu_t create_lqueue(int dataSize,UdFreeNode_t free_node,UdShowNode_t show_node);

/* Return true if Q is empty */
extern int is_empty_lqueue(PtLQu_t Q);

/* Output a node in the queue, 
 * the space pointed by dataAddr must be enough to contain data*/
extern int out_lqueue(PtLQu_t Q,DataAddr_t dataAddr);

/* Insert a node to the queue */
extern int in_lqueue(PtLQu_t Q,DataAddr_t dataAddr);

/* Show data in Q */
extern int show_lqueue(PtLQu_t Q);

/* Destroy Q */
extern int destroy_lqueue(PtLQu_t Q);

/* Save Q to file */
extern int save_lqueue_to_file(PtLQu_t Q,const char* filepath);

/* Load Q from file */
extern int load_lqueue_from_file(PtLQu_t Q,const char* filepath);

#endif //__SEMI_GENERIC_LQUEUE_H__











































































