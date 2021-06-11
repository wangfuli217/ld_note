#ifndef __SEMI_GENERIC_LLIST_H__
#define __SEMI_GENERIC_LLIST_H__
#include "typedef.h"
/* Initialize a linked list */
extern PtLList_t create_llist(int dataSize,UdFreeNode_t free_node,UdShowNode_t show_node,UdCmp_t is_equal_node);

/* Return true if L is empty */
extern int is_empty_llist(PtLList_t L);

/* Insert a node at the head */
extern int insert_head_llist(PtLList_t L,DataAddr_t dataAddr);

/* Delete the node at the head, 
 * the space pointed by dataAddr must be enough to contain data*/
extern int delete_head_llist(PtLList_t L,DataAddr_t dataAddr);

/* Return the address of the node at tail */
extern PtNode_t find_tail_llist(PtLList_t L);

/* Insert a node at the tail */
extern int insert_tail_llist(PtLList_t L,DataAddr_t dataAddr);

/* Return the address of the previous node at tail */
extern PtNode_t find_pretail_llist(PtLList_t L);

/* Delete the node at the tail */
extern int delete_tail_llist(PtLList_t L,DataAddr_t dataAddr);

/* Return the address of the node containing the data given */
extern PtNode_t find_node_llist(PtLList_t L,DataAddr_t dataAddr);

/* Insert a node with a data given */
extern int insert_node_llist(PtLList_t L,DataAddr_t dataAddr_obj,DataAddr_t dataAddr_new);

/* Modify a node with a data given */
extern int modify_node_llist(PtLList_t L, DataAddr_t dataAddr_obj,DataAddr_t dataAddr_new);

/* Return the address of the previous node of the node given */
extern PtNode_t find_prenode_llist(PtLList_t L,DataAddr_t dataAddr);

/* Delete a node with a data given */
extern int delete_node_llist(PtLList_t L,DataAddr_t dataAddr);

/* Show data in L */
extern int show_llist(PtLList_t L);

/* Destroy L */
extern int destroy_llist(PtLList_t L);

/* Save L to file */
extern int save_llist_to_file(PtLList_t L,const char* filepath);

/* Load L from file */
extern int load_llist_from_file(PtLList_t L,const char* filepath);

#endif //__SEMI_GENERIC_LLIST_H___











































































