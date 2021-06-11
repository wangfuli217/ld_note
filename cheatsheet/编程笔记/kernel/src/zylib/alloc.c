/*
 * =====================================================================================
 *
 *       Filename:  alloc.c
 *
 *    Description:  CALLOC REALLOC
 *    		    |
 *    		    alloc_calloc alloc_realloc
 *    		    |
 *    		    alloc_malloc
 *    		    |
 *    		    get_new_node malloc		(check the addr align)
 *    		    |
 *    		    nalloc		
 *
 *        Version:  1.0
 *        Created:  01.03.10
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
#include	<string.h>
#include	<assert.h>

#define		ZY_ALLOC_IMPLEMENTATION
#include	<zy/alloc.h>


/*-----------------------------------------------------------------------------
 *  all data types, max is sizeof(long double ld) == 12
 *  so sizeof(union align) == 12
 *-----------------------------------------------------------------------------*/
static union align {
	int i;
	long l;
	long *lp;
	void *p;
	void (*fp)(void);
	float f;
	double d;
	long double ld;                                         /* max, 12 bytes */
};

/*-----------------------------------------------------------------------------
 *  pointer array. every one is a head of a link list in hash table
 *-----------------------------------------------------------------------------*/
static alloc_n *htab[ALLOC_SIZE];

/*-----------------------------------------------------------------------------
 *  just init the 1st element in the struct alloc_n, alloc_n.free
 *  freelist.free -> &freelist  	points to itself
 *-----------------------------------------------------------------------------*/
static alloc_n freelist = { &freelist };

#define		NODE_SIZE		sizeof(struct alloc_n)
#define		ALIGN_SIZE		sizeof(union align)

/*-----------------------------------------------------------------------------
 *  just like nbytes, multiple of union align
 *-----------------------------------------------------------------------------*/
#define		WHOLESALE					\
(4096 + ALIGN_SIZE - 1 ) / ALIGN_SIZE * ALIGN_SIZE

/*-----------------------------------------------------------------------------
 *  hash function
 *-----------------------------------------------------------------------------*/
#define         hash(addr, t)                             \
(((unsigned) (addr) >> 3) & (sizeof(t) / sizeof((t)[0]) - 1))

/*-----------------------------------------------------------------------------
 *  if a given addr(pointer) is not the multiple of union align
 *  it must not be a valid malloc'd addr(pointer)
 *-----------------------------------------------------------------------------*/
#define		addr_align(addr)				\
((unsigned)(addr) % (ALIGN_SIZE))


/*-----------------------------------------------------------------------------
 *  not the interfaces
 *-----------------------------------------------------------------------------*/
static alloc_n *search(void *);
static alloc_n *nalloc(void *, long, const char *, int);
static alloc_n *get_new_node(void *, long, const char *, int);


/*-----------------------------------------------------------------------------
 *  				
 *  				allocate wrapper
 *
 *-----------------------------------------------------------------------------*/
/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  alloc_calloc
 *  Description:  just like calloc in standard lib, calls alloc_malloc
 * =====================================================================================
 */
void *alloc_calloc(long cnt, long nbytes, const char *file, int line)
{
	long size = cnt * nbytes;
	void *addr = alloc_malloc(size, file, line);
	memset(addr, 0, size);
	return addr;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  alloc_realloc
 *  Description:  1st. alloc_malloc
 *  		  2nd. alloc_free
 * =====================================================================================
 */
void *alloc_realloc(void *addr, long nbytes, const char *file, int line)
{
	assert(addr_align(addr) == 0);
	assert(nbytes > 0);

	void *new_addr = alloc_malloc(nbytes, file, line);
	long size = search(addr)->size;

	if (new_addr) {
		memmove(new_addr, addr, size < nbytes ? size : nbytes);
		alloc_free(addr, file, line);	 
	} else {
		FAILURE();
	}
	
	return new_addr;
}


/*-----------------------------------------------------------------------------
 *  				
 *  				allocate core
 *
 *-----------------------------------------------------------------------------*/
/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  alloc_malloc
 *  Description:  search for adequate free node, call malloc&nalloc
 * =====================================================================================
 */
void *alloc_malloc(long nbytes, const char *file, int line)
{
	assert(nbytes > 0);

	alloc_n *node;

	/*-----------------------------------------------------------------------------
	 *  nbytes is the multiple of ALIGN_SIZE && nbytes_new >= nbytes_old
	 *-----------------------------------------------------------------------------*/
	nbytes = (nbytes + ALIGN_SIZE - 1) / ALIGN_SIZE * ALIGN_SIZE;

	for (node = freelist.free; node; node = node->free) {
		/*--------------------------------------------------------------------
		 *  2 tests, 1 is size, 1 is addr. 'cause it's a circle
		 *
		 *  First-Fit Algorithm
		 *
		 *  size > nbytes, then divide the whole into 2 parts:
		 *  one is dirty, start at the original addr;
		 *  the other is free, start at original addr + nbytes
		 *  apply a new node for the other one
		 *--------------------------------------------------------------------*/
		if (node->size > nbytes) {
			/*------------------------------------------------------------
			 *  old node, free&size
			 *------------------------------------------------------------*/
			node->free = NULL;
			node->size = nbytes;
			/*------------------------------------------------------------
			 *  new node, free&link
			 *------------------------------------------------------------*/
			get_new_node((char *)node + nbytes, \
					 	 node->size - nbytes, file, line);
                        return (void *) node->addr;                /* only 1 exit */
		}

		/*-----------------------------------------------------------------------------
		 *  no more space fitted, wholesale with a node
		 *
		 *  will find the right in the next loop
		 *-----------------------------------------------------------------------------*/
                if (node == &freelist) {                      /* back to the circle start? */
			void *addr = malloc(nbytes + WHOLESALE);
			if (!addr) {
				FAILURE();
			}
			get_new_node(addr, nbytes + WHOLESALE, file, line);
		}
	}

	assert(0);                                              /* can't arrive here */
	return NULL;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  alloc_free
 *  Description:  make the node->free be in freelist again
 *
 *  		  that's the point of element "free" in node:
 *  		  avoid freeing a free space
 * =====================================================================================
 */
void alloc_free(void *addr, const char *file, int line)
{
	assert(addr);
	alloc_n *node = search(addr);

	/*-----------------------------------------------------------------------------
	 *  addr should be the multiple of sizeof(union align)
	 *-----------------------------------------------------------------------------*/
	if (node && node->free && (!addr_align(addr))) {        /* node->free */
		node->free = freelist.free;
		freelist.free = node;
	} else {
		FAILURE();
	}
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  alloc_failure
 *  Description:  dealing with exceptions
 * =====================================================================================
 */
void alloc_failure()
{
 	fprintf(stderr, "Alloc Failure!\n"); 					
	fflush(stderr);                                         
	exit(EXIT_FAILURE);                                     
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  search
 *  Description:  only called by other func in this file,
 *  		  so no need to assert explicitly, 
 *  		  they all have been checked already
 * =====================================================================================
 */
static alloc_n *search(void *addr)
{
	alloc_n *node = htab[hash(addr, htab)];
	while (node && node->addr != addr) {
		node = node->link;
	}
	return node;                                            /* NULL/the dest */
}


/*-----------------------------------------------------------------------------
 *  
 *  				allocate auxiliary
 *
 *-----------------------------------------------------------------------------*/
/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  nalloc
 *  Description:  wholesale 512 nodes, then retail it 1 by 1
 *  		  don't use directly, so static
 * =====================================================================================
 */
static alloc_n *nalloc(void *addr, long nbytes, const char *file, int line)
{
	/*-----------------------------------------------------------------------------
	 *  need them be static
	 *-----------------------------------------------------------------------------*/
	static int left;
	static alloc_n *node;

	/*-----------------------------------------------------------------------------
	 *  namely, no one left. so wholesale again
	 *-----------------------------------------------------------------------------*/
	if (!left) {
		left = 512;
		if (!(node = (alloc_n *) malloc(left * NODE_SIZE))) {
			FAILURE();
		}
	}

	node->free = node->link = NULL;                         /* default non-free */
	node->addr = addr;
	node->size = nbytes;
	node->file = file;
	node->line = line;

        left--;                                                 /* cut down */
	/*-----------------------------------------------------------------------------
	 *  return current one, make the static points to the next
	 *-----------------------------------------------------------------------------*/
	return node++;                                   
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  get_new_node
 *  Description:  apply&init a new alloc_n, return it
 *  		  just use in this file, static one
 * =====================================================================================
 */
static alloc_n *get_new_node(void *addr, long nbytes, const char *file, int line)
{
	assert(addr_align(addr) == 0);
	assert(nbytes > 0);

	int key;
	alloc_n *node = nalloc(addr, nbytes, file, line);

	if (node) {
                node->free = freelist.free;             /* alloc_n.free */
		freelist.free = node;

		key = hash(node->addr, htab);
                node->link = htab[key]->link;           /* NULL also works */
		htab[key]->link = node;                 /* add to the start */
	} else {
		FAILURE();
	}

	return node;
}
