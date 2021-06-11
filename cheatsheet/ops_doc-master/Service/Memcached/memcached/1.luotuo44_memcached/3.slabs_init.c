#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include "memcached.h"

static size_t mem_limit = 0;
static size_t mem_malloced = 0;
static int power_largest;
static void *mem_base = NULL;
static void *mem_current = NULL;
static size_t mem_avail = 0;

struct settings settings;

typedef struct _stritem {
	struct _stritem *next;
	struct _stritem *prev;
	struct _stritem *h_next;    /* hash chain next */
	rel_time_t      time;       /* least recent access */
	rel_time_t      exptime;    /* expire time */
	int             nbytes;     /* size of data */
	unsigned short  refcount;
	uint8_t         nsuffix;    /* length of flags-and-length string */
	uint8_t         it_flags;   /* ITEM_* above */
	uint8_t         slabs_clsid;/* which slab class we're in */
	uint8_t         nkey;       /* key length, w/terminating null and padding */
	union {
		uint64_t cas;
		char end;
	} data[];
} item;

typedef struct {
    unsigned int size;      /* sizes of items */
    unsigned int perslab;   /* how many items per slab */
    void *slots;           /* list of item ptrs */
    unsigned int sl_curr;   /* total free items in list */
    unsigned int slabs;     /* how many slabs were allocated for this class */
    void **slab_list;       /* array of slab pointers */
    unsigned int list_size; /* size of prev array */
    unsigned int killing;  /* index+1 of dying slab, or zero if none */
    size_t requested; /* The number of requested bytes */
} slabclass_t;

static slabclass_t slabclass[MAX_NUMBER_OF_SLAB_CLASSES];


static void slabs_preallocate (const unsigned int maxslabs) {
	int i;
	unsigned int prealloc = 0;

	for (i = POWER_SMALLEST; i <= POWER_LARGEST; i++) {
		if (++prealloc > maxslabs)
			return;

		//printf("i:%d\n", i);//打印 1->42

		//if (do_slabs_newslab(i) == 0) {
		//    fprintf(stderr, "Error while preallocating slab memory!\n"
		//        "If using -L or other prealloc options, max memory must be "
		//        "at least %d megabytes.\n", power_largest);
		//    exit(1);
		//}
	}

}

//slab class :1 , chunk size(每个item大小,单位:字节):96 ,preslab(可以放入几个item):10922
//slab class :2 , chunk size(每个item大小,单位:字节):120 ,preslab(可以放入几个item):8738
//slab class :3 , chunk size(每个item大小,单位:字节):150 ,preslab(可以放入几个item):6990
//slab class :4 , chunk size(每个item大小,单位:字节):187 ,preslab(可以放入几个item):5607
//slab class :5 , chunk size(每个item大小,单位:字节):233 ,preslab(可以放入几个item):4500
//slab class :6 , chunk size(每个item大小,单位:字节):291 ,preslab(可以放入几个item):3603
//slab class :7 , chunk size(每个item大小,单位:字节):363 ,preslab(可以放入几个item):2888
//slab class :8 , chunk size(每个item大小,单位:字节):453 ,preslab(可以放入几个item):2314
//slab class :9 , chunk size(每个item大小,单位:字节):566 ,preslab(可以放入几个item):1852
//slab class :10 , chunk size(每个item大小,单位:字节):707 ,preslab(可以放入几个item):1483
//slab class :11 , chunk size(每个item大小,单位:字节):883 ,preslab(可以放入几个item):1187
//slab class :12 , chunk size(每个item大小,单位:字节):1103 ,preslab(可以放入几个item):950
//slab class :13 , chunk size(每个item大小,单位:字节):1378 ,preslab(可以放入几个item):760
//slab class :14 , chunk size(每个item大小,单位:字节):1722 ,preslab(可以放入几个item):608
//slab class :15 , chunk size(每个item大小,单位:字节):2152 ,preslab(可以放入几个item):487
//slab class :16 , chunk size(每个item大小,单位:字节):2690 ,preslab(可以放入几个item):389
//slab class :17 , chunk size(每个item大小,单位:字节):3362 ,preslab(可以放入几个item):311
//slab class :18 , chunk size(每个item大小,单位:字节):4202 ,preslab(可以放入几个item):249
//slab class :19 , chunk size(每个item大小,单位:字节):5252 ,preslab(可以放入几个item):199
//slab class :20 , chunk size(每个item大小,单位:字节):6565 ,preslab(可以放入几个item):159
//slab class :21 , chunk size(每个item大小,单位:字节):8206 ,preslab(可以放入几个item):127
//slab class :22 , chunk size(每个item大小,单位:字节):10257 ,preslab(可以放入几个item):102
//slab class :23 , chunk size(每个item大小,单位:字节):12821 ,preslab(可以放入几个item):81
//slab class :24 , chunk size(每个item大小,单位:字节):16026 ,preslab(可以放入几个item):65
//slab class :25 , chunk size(每个item大小,单位:字节):20032 ,preslab(可以放入几个item):52
//slab class :26 , chunk size(每个item大小,单位:字节):25040 ,preslab(可以放入几个item):41
//slab class :27 , chunk size(每个item大小,单位:字节):31300 ,preslab(可以放入几个item):33
//slab class :28 , chunk size(每个item大小,单位:字节):39125 ,preslab(可以放入几个item):26
//slab class :29 , chunk size(每个item大小,单位:字节):48906 ,preslab(可以放入几个item):21
//slab class :30 , chunk size(每个item大小,单位:字节):61132 ,preslab(可以放入几个item):17
//slab class :31 , chunk size(每个item大小,单位:字节):76415 ,preslab(可以放入几个item):13
//slab class :32 , chunk size(每个item大小,单位:字节):95518 ,preslab(可以放入几个item):10
//slab class :33 , chunk size(每个item大小,单位:字节):119397 ,preslab(可以放入几个item):8
//slab class :34 , chunk size(每个item大小,单位:字节):149246 ,preslab(可以放入几个item):7
//slab class :35 , chunk size(每个item大小,单位:字节):186557 ,preslab(可以放入几个item):5
//slab class :36 , chunk size(每个item大小,单位:字节):233196 ,preslab(可以放入几个item):4
//slab class :37 , chunk size(每个item大小,单位:字节):291495 ,preslab(可以放入几个item):3
//slab class :38 , chunk size(每个item大小,单位:字节):364368 ,preslab(可以放入几个item):2
//slab class :39 , chunk size(每个item大小,单位:字节):455460 ,preslab(可以放入几个item):2
//slab class :40 , chunk size(每个item大小,单位:字节):569325 ,preslab(可以放入几个item):1
//slab class :41 , chunk size(每个item大小,单位:字节):711656 ,preslab(可以放入几个item):1
//============================
//size:889570
//============================
//slab class :42 , chunk size(每个item大小,单位:字节):1048576 ,preslab(可以放入几个item):1
void slab_init(const size_t limit, const double factor, const bool prealloc)
{
	int i = POWER_SMALLEST - 1;
	unsigned int size = sizeof(item) + settings.chunk_size;
	mem_limit = limit;//默认64M

	if (prealloc) {
		/* Allocate everything in a big chunk with malloc */
		mem_base = malloc(mem_limit);
		if (mem_base != NULL) {
			mem_current = mem_base;
			mem_avail = mem_limit;
		} else {
			fprintf(stderr, "Warning: Failed to allocate requested memory in"
					" one large chunk.\nWill allocate in smaller chunks\n");
		}
	}

	int perslab;
	while (++i < POWER_LARGEST && size <= settings.item_size_max / factor) {
		size = size;
		perslab = 1024*1024/ size;
		printf("slab class :%d , chunk size(每个item大小,单位:字节):%d ,preslab(可以放入几个item):%d\n",
				i, size, perslab);
		size *= factor;
	}

	memset(slabclass, 0, sizeof(slabclass));

	printf("============================\n");
	printf("size:%d\n",size);
	printf("============================\n");

	power_largest = i;
	size = 1024*1024;
	perslab = 1;
	printf("slab class :%d , chunk size(每个item大小,单位:字节):%d ,preslab(可以放入几个item):%d\n",
			i, size, perslab);
	if (prealloc) {
		slabs_preallocate(power_largest);
	}
}//end of slab_init()

void test1()
{
	int prealloc = 0;
	slab_init(64*1024*1024, 1.25, prealloc);
}

void test2()
{
	int prealloc=1;
	slab_init(64*1024*1024, 1.25, prealloc);
}

int main(int argc, const char *argv[])
{

	settings.chunk_size=48;
	settings.item_size_max=1024*1024;//1M

	//test1();

	test2();

	return 0;
}
