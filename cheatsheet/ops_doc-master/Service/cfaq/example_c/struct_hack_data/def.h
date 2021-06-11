#ifndef __DEF_H_
#define __DEF_H_
#endif


#include <stdlib.h>
#include <stdio.h>

#if 1
#define __POINTER__(p) printf("%s: %p\n", #p, p);
#else
#define __POINTER__(p) 
#endif 

typedef struct slot_s slot_t;
struct slot_s {
	unsigned short ssz;
	unsigned short nodes[0];
};

typedef struct slot_list_s slot_list_t;
struct slot_list_s {
	unsigned int 	ssz;
	slot_t 			**slots;
};

#define __NEW_SLOT_LIST__(sl, slz, nsz) do {							\	
	sl = (slot_list_t*)malloc(sizeof(slot_list_t));__POINTER__(sl);					\
	if (sl) {														\
		sl->slots = (slot_t**)malloc(sizeof(slot_t*) * slz);__POINTER__(sl->slots)			\
		if (sl->slots) {											\
			sl->ssz = slz;											\
			for (unsigned int idx = 0; idx < sl->ssz; idx++) {			\
				*(sl->slots + idx) = (slot_t*)malloc(sizeof(slot_t) + sizeof(unsigned short) * nsz);	\
				(*(sl->slots + idx))->ssz = nsz;																		\
			}																						\
		}																							\
	}																								\
} while(0)