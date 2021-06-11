#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include "m_alloc.h"
#include "tools-util.h"

typedef enum
{
	MEM_SIZE_INDEX_4_B = 0,
	MEM_SIZE_INDEX_8_B,
	MEM_SIZE_INDEX_16_B,
	MEM_SIZE_INDEX_32_B,
	MEM_SIZE_INDEX_64_B,
	MEM_SIZE_INDEX_128_B,
	MEM_SIZE_INDEX_256_B,
	MEM_SIZE_INDEX_512_B,
	MEM_SIZE_INDEX_1_K,
	MEM_SIZE_INDEX_2_K,
	MEM_SIZE_INDEX_4_K,
	MEM_SIZE_INDEX_8_K,
	MEM_SIZE_INDEX_16_K,
	MEM_SIZE_INDEX_32_K,
	MEM_SIZE_INDEX_64_K,
	MEM_SIZE_INDEX_128_K,
	MEM_SIZE_INDEX_256_K,
	MEM_SIZE_INDEX_512_K,
	MEM_SIZE_INDEX_1_M,
	MEM_SIZE_INDEX_2_M,
	MEM_SIZE_INDEX_4_M,
	MEM_SIZE_INDEX_8_M,
	MEM_SIZE_INDEX_16_M,
	MEM_SIZE_INDEX_MAX,
}MEM_SIZE_INDEX;

typedef enum 
{
	MEM_SIZE_4_B = 4,
	MEM_SIZE_8_B = 8,
	MEM_SIZE_16_B = 16,
	MEM_SIZE_32_B = 32,
	MEM_SIZE_64_B = 64,
	MEM_SIZE_128_B = 128,
	MEM_SIZE_256_B = 256,
	MEM_SIZE_512_B = 512,
	MEM_SIZE_1_K = 1024,
	MEM_SIZE_2_K = 2048,
	MEM_SIZE_4_K = 4096,
	MEM_SIZE_8_K = 8192,
	MEM_SIZE_16_K = 16384,
	MEM_SIZE_32_K = 32768,
	MEM_SIZE_64_K = 65536,
	MEM_SIZE_128_K = 131072,
	MEM_SIZE_256_K = 262144,
	MEM_SIZE_512_K = 524288,
	MEM_SIZE_1_M = 1048576,
	MEM_SIZE_2_M = 2097152,
	MEM_SIZE_4_M = 4194304,
	MEM_SIZE_8_M = 8388608,
	MEM_SIZE_16_M = 16777216,
}MEM_SIZE;


int mem_size_map_t[] = 
{
	MEM_SIZE_4_B,
	MEM_SIZE_8_B,
	MEM_SIZE_16_B,
	MEM_SIZE_32_B,
	MEM_SIZE_64_B,
	MEM_SIZE_128_B,
	MEM_SIZE_256_B,
	MEM_SIZE_512_B,
	MEM_SIZE_1_K ,
	MEM_SIZE_2_K ,
	MEM_SIZE_4_K ,
	MEM_SIZE_8_K ,
	MEM_SIZE_16_K,
	MEM_SIZE_32_K ,
	MEM_SIZE_64_K ,
	MEM_SIZE_128_K ,
	MEM_SIZE_256_K ,
	MEM_SIZE_512_K ,
	MEM_SIZE_1_M ,
	MEM_SIZE_2_M ,
	MEM_SIZE_4_M ,
	MEM_SIZE_8_M,
	MEM_SIZE_16_M,
};

#if 0
struct mem_tail
{
	//struct list_head list_head;
	unsigned int addr_offset; //开始地址,相对于共享内存开始的偏移
	unsigned int size; //长度, MEM_SIZE_16_M
	unsigned int size_index; //长度, MEM_SIZE_INDEX_16_M
	int b_use; //是否被使用

	int mana_index;
	int mana_use; 
};
#endif

union mana_item
{
	struct mem_tail tail;
	char res[64];
};

static char * l_mem_addr;
static char * l_mana_addr;
static int g_m_id = 0xf0000000;

int mana_init(char * mana_addr)
{

	struct mem_tail * tail = NULL;
	int i;
	
	if (mana_addr == NULL)
	{
		printf("mana init error\n");
		return -1;
	}
	
	l_mana_addr = mana_addr;
	tail = (struct mem_tail *)l_mana_addr;

	for (i=0; i< 1024; i++)
	{
		tail[i].mana_index = i;
		tail[i].mana_use = 0;
	}
	
	return 0;
}

//从mana中获取一个空闲的索引
struct mem_tail * mana_get_index()
{
	struct mem_tail * head_tail = NULL;
	head_tail = (struct mem_tail *)l_mana_addr;

	int i;

	for (i=0; i< 1024; i++)
	{
		if (head_tail[i].mana_use == 0)
		{
			head_tail[i].mana_use = 1;
			//printf("mana_get_index: %d\n", i);
			return &head_tail[i];
		}
	}

	return NULL;
}

int mana_free_index(struct mem_tail * tail)
{
	tail->mana_use = 0;
}

struct mem_tail * new_tail(int addr_offset, MEM_SIZE_INDEX size_index)
{
	struct mem_tail * mem = NULL;

	if (size_index >= MEM_SIZE_INDEX_MAX)
	{
		printf("new tail param error, size index: %d\n", size_index);
		return NULL;
	}
	
	mem = (struct mem_tail *)mana_get_index();

	if (mem == NULL)
	{
		printf("mana_get_index return NULL\n");
		return NULL;
	}
	//INIT_LIST_HEAD(&mem->list_head);
	
	mem->addr_offset = addr_offset;
	mem->b_use = 0;
	mem->size = mem_size_map_t[size_index];
	mem->size_index = size_index;
	return mem;
}
#if 1
int add_tail(MEM_SIZE_INDEX index, struct mem_tail * list_tail)
{
	list_tail->mana_use = 1;
}

int del_tail(struct mem_tail * list_tail)
{
	list_tail->mana_use = 0;
}
#endif

int m_set_zeros()
{
	memset(l_mana_addr, 0, sizeof(struct mem_tail) * 1024);
	memset(l_mem_addr, 0, 16*1024*1024);

	return 0;
}

//shm_nam: 一个普通字符串
int m_init(char * shm_name)
{
	int i;
	struct mem_tail * first_mem_tail;
	char _shm_name[256] = {0};
	char _shm_mana_name[256] = {0};
	int shm_fd, shm_mana_fd;

	snprintf(_shm_name, sizeof(_shm_name), "/%s.shm", shm_name);
	snprintf(_shm_mana_name, sizeof(_shm_mana_name), "/%s_mana.shm", shm_name);

	shm_fd = shm_open(_shm_name, O_RDWR | O_CREAT, 0666);
	shm_mana_fd = shm_open(_shm_mana_name, O_RDWR | O_CREAT, 0666);

	assert_return(-1, shm_fd>0);
	assert_return(-1, shm_mana_fd>0);

	ftruncate(shm_fd, 16*1024*1024);
	ftruncate(shm_mana_fd, sizeof(struct mem_tail)*1024);

	l_mem_addr = mmap(NULL, 16*1024*1024, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
	l_mana_addr = mmap(NULL, sizeof(struct mem_tail)*1024, PROT_READ | PROT_WRITE, MAP_SHARED, shm_mana_fd, 0);

	assert_return(-1, l_mem_addr!=NULL);
	assert_return(-1, l_mana_addr!=NULL);
	
	assert_return(-1, !mana_init(l_mana_addr));

	//memset(l_mem_addr, 0, 16*1024*1024);

	first_mem_tail = new_tail(0, MEM_SIZE_INDEX_16_M);
	assert_return(-1, NULL != first_mem_tail);
	add_tail(MEM_SIZE_INDEX_16_M, first_mem_tail);
	//add_tail(MEM_SIZE_INDEX_16_M, first_mem_tail);
	return 0;
}

//得到大于等于当前大小的内存index
int get_suitable_size_index(size_t size)
{
	int i;
	int index = -1;
	
	for (i=MEM_SIZE_INDEX_4_B; i < MEM_SIZE_INDEX_MAX; i++)
	{
		if (mem_size_map_t[i] >= size)
		{
			index = i;
			break;
		}
		else
		{
			continue;
		}
	}

	return index;
}

//只从index大小的进行cut
int do_cut_memory(MEM_SIZE_INDEX size_index)
{
	struct mem_tail * mem_tail_item;
	struct mem_tail * sub_1, *sub_2;
	int i;
	mem_tail_item = (struct mem_tail *)l_mana_addr;

	//printf("do_cut_memory index: %d\n", size_index);
	//判断当前是否有可用的空余节点	

	for (i=0; i< 1024; i++)
	{

		if ((mem_tail_item[i].mana_use == 1) && (mem_tail_item[i].b_use == 0) && (size_index == mem_tail_item[i].size_index))
		{
			//printf("cut mem size_index: %d size: %d\n", mem_tail_item[i].size_index, mem_tail_item[i].size);
			sub_1 = new_tail(mem_tail_item[i].addr_offset, size_index-1);
			assert_return(-1, sub_1 != NULL);
			sub_2 = new_tail(mem_tail_item[i].addr_offset + mem_size_map_t[size_index]/2, size_index-1);
			assert_return(-1, sub_2 != NULL);
			add_tail(size_index-1, sub_1);
			add_tail(size_index-1, sub_2);

			del_tail(&mem_tail_item[i]);

			return 0;
		}
		else if (mem_tail_item[i].mana_use == 1)
		{
			//printf("mem_tail_item[i].size_index : %d  mem_tail_item[i].b_use: %d\n", mem_tail_item[i].size_index, mem_tail_item[i].b_use);
		}
		else
		{
			//printf("mem is in using\n");
		}

	}
	return -1;
}

//切割大内存为小块
//input: 切个的内存index
int cut_memory(MEM_SIZE_INDEX size_index)
{
	int i;
	struct mem_tail * mem_tail_item;
	struct mem_tail * sub_1, *sub_2;
	int success = 0;
	int list_for_each_null = 1;

	//printf("cut_memory  -->  size_index: %d\n", size_index);
	if (((size_index<=MEM_SIZE_INDEX_4_B)||(size_index>=MEM_SIZE_INDEX_MAX)))
	{
		return -1;
	}

	success = do_cut_memory(size_index);

	//当前节点分配失败，向上层节点查找分配
	if (success < 0)
	{
		//printf("can't cut mem, curr index: %d\n", size_index);
		if (size_index+1 < MEM_SIZE_INDEX_MAX)
		{
			cut_memory(size_index+1);			
			success = do_cut_memory(size_index);
		}
		else
		{
			printf("cut mem error\n");
		}
	}
	return success;
}
struct mem_tail * find_mem_on_mana(MEM_SIZE_INDEX mem_size_index)
{
	//查找mana是否有分配好未使用的
	int i;
	
	struct mem_tail * head_tail = NULL;
	head_tail = (struct mem_tail *)l_mana_addr;

	for (i=0; i< 1024; i++)
	{
		if (head_tail[i].mana_use == 1)
		{
			if ((head_tail[i].size_index == mem_size_index) && (head_tail[i].b_use == 0))
			{
				head_tail[i].b_use = 1;
				head_tail[i].reference_count = 0;
				head_tail[i].m_id = ++g_m_id;
				return head_tail+i;
			}
		}
	}
	

	return NULL;
}

struct mem_tail * find_nouse_mana_info(int offset, MEM_SIZE_INDEX mem_size_index)
{
	struct mem_tail * tmp_mem_tail;
	int i;
	
	tmp_mem_tail = (struct mem_tail *)l_mana_addr;
	for (i=0; i< 1024; i++)
	{
		if (tmp_mem_tail[i].mana_use == 1)
		{
			if ((tmp_mem_tail[i].b_use == 0) && (tmp_mem_tail[i].size_index == mem_size_index) && (tmp_mem_tail[i].addr_offset == offset))
			{
				return &tmp_mem_tail[i];
			}
		}
	}

	return NULL;
}


int do_merge(MEM_SIZE_INDEX mem_size_index)
{
	struct mem_tail * tmp_mem_tail;
	struct mem_tail * tmp_sub_mem_tail = NULL;
	int i;
	
	for (i=0; i< 1024; i++)
	{
		tmp_mem_tail = (struct mem_tail *)&l_mana_addr[i];
		if (tmp_mem_tail->mana_use == 1)
		{
			if ((tmp_mem_tail->b_use == 0) && (tmp_mem_tail->size_index == mem_size_index))
			{
				tmp_sub_mem_tail = NULL;
				tmp_sub_mem_tail = find_nouse_mana_info(tmp_mem_tail->addr_offset + tmp_mem_tail->size, mem_size_index);
				if (tmp_sub_mem_tail != NULL)
				{
					//合并两个tail
					del_tail(tmp_sub_mem_tail);
					new_tail(tmp_mem_tail->addr_offset, mem_size_index+1);
					del_tail(tmp_mem_tail);

					//printf("merge new mem index; %d\n", mem_size_index+1);
				}
			}
		}
	}
}

//从最小内存单元开始合并
int merge_memory(MEM_SIZE_INDEX mem_size_index)
{
	int i;
	
	for (i=MEM_SIZE_INDEX_4_B; i< mem_size_index; i++)
	{
		do_merge(i);
	}

	return 0;
}

//通过mem_tail获取共享地址
void * m_addr(struct mem_tail * ret_tail)
{

	struct mem_tail * tmp_tail = NULL;
	int i;
	
	if (ret_tail == NULL)
	{
		printf("m_addr param error\n");
		return NULL;
	}

	// TODO: 查找与shm_mana中的m_id是否相等
	tmp_tail = (struct mem_tail *)l_mana_addr;
	for (i=0; i< 1024; i++)
	{
		if ((tmp_tail[i].addr_offset == ret_tail->addr_offset) && (tmp_tail[i].m_id == ret_tail->m_id))
		{
			tmp_tail[i].reference_count++;
			return tmp_tail[i].addr_offset + l_mem_addr;
		}
		else if ((tmp_tail[i].addr_offset == ret_tail->addr_offset) && (tmp_tail[i].m_id != ret_tail->m_id))
		{
			//printf("tmp_tail->addr_offset %d,  ret_tail->addr_offset %d\ttmp_tail->m_id %d,  ret_tail->m_id %d\n", tmp_tail->addr_offset, ret_tail->addr_offset, tmp_tail->m_id, ret_tail->m_id);
		}
	}
	printf("m_addr error, addr_offset %d m_id: %x\n", ret_tail->addr_offset, ret_tail->m_id);
	return NULL;
}

//释放分配但未使用的内存
//可能后面会使用，到时候获取地址时返回NULL
//ret: 释放的个数
int do_free_not_use_memory()
{
	
	struct mem_tail * tmp_tail = NULL;
	int i;
	int free_count = 0;

	tmp_tail = (struct mem_tail *)l_mana_addr;
	for (i=0; i< 1024; i++)
	{
		if ((tmp_tail[i].reference_count == 0) && (tmp_tail[i].b_use == 1) && (tmp_tail[i].mana_use == 1))
		{
			tmp_tail[i].b_use = 0;
			free_count++;
		}
	}

	return free_count;
}

//字节为单位
//进程间共享，需要传递mem_tail信息
void * m_alloc(size_t mem_size, struct mem_tail * ret_tail)
{
	int curr_alloc_size_index = -1;
	//char * tmp_ret_addr = NULL;
	int ret;
	struct mem_tail * tmp_mem_tail;

	curr_alloc_size_index = get_suitable_size_index(mem_size);

	//printf("curr_alloc_size_index: %d\n", curr_alloc_size_index);
	
	//4  1.查找当前大小的mana上是否有空余	
	tmp_mem_tail = find_mem_on_mana(curr_alloc_size_index);
	if (tmp_mem_tail != NULL)
	{
		//返回内存信息
		if (ret_tail != NULL)
		{
			tmp_mem_tail->size_real = mem_size;
			memcpy(ret_tail, tmp_mem_tail, sizeof(struct mem_tail));
		}
		//printf("m_alloc 1\n");
		return tmp_mem_tail->addr_offset + l_mem_addr;
	}
	else
	{
		//printf("find_mem_on_mana error 1\n");
	}
	//4 2.查找比当前大的内存进行切割
	ret = cut_memory(curr_alloc_size_index+1);
	//printf("cut memory ret: %d\n", ret);
	if (ret == 0)
	{
		tmp_mem_tail = find_mem_on_mana(curr_alloc_size_index);
		if (tmp_mem_tail != NULL)
		{
			//返回内存信息
			if (ret_tail != NULL)
			{
				tmp_mem_tail->size_real = mem_size;
				memcpy(ret_tail, tmp_mem_tail, sizeof(struct mem_tail));
			}
			//printf("m_alloc 2\n");
			return tmp_mem_tail->addr_offset + l_mem_addr;
		}
		else
		{
			//printf("find_mem_on_mana error 2\n");
		}
	}
	//4 3.合并零散内存
	ret = merge_memory(curr_alloc_size_index);
	tmp_mem_tail = find_mem_on_mana(curr_alloc_size_index);
	if (tmp_mem_tail != NULL)
	{
		//返回内存信息
		if (ret_tail != NULL)
		{
			tmp_mem_tail->size_real = mem_size;
			memcpy(ret_tail, tmp_mem_tail, sizeof(struct mem_tail));
		}
		//printf("m_alloc 3\n");
		return tmp_mem_tail->addr_offset + l_mem_addr;
	}
	else
	{
		//printf("find_mem_on_mana error 1\n");
	}
	//4 4.释放引用计数为0的内存
	ret = do_free_not_use_memory();
	if (ret > 0)
	{	
		printf("auto free nums: %d\n", ret);
		ret = merge_memory(curr_alloc_size_index);
		tmp_mem_tail = find_mem_on_mana(curr_alloc_size_index);
		if (tmp_mem_tail != NULL)
		{
			//返回内存信息
			if (ret_tail != NULL)
			{
				tmp_mem_tail->size_real = mem_size;
				memcpy(ret_tail, tmp_mem_tail, sizeof(struct mem_tail));
			}
			//printf("m_alloc 4\n");
			return tmp_mem_tail->addr_offset + l_mem_addr;
		}
		else
		{
			//printf("find_mem_on_mana error 1\n");
		}
	}
	else
	{
		printf("do free failed, ret: %d\n", ret);
	}
	return NULL;
}


int m_free(void * mem_addr)
{
	//查找addr属于哪一块，置0
	
	int i;
	
	struct mem_tail * head_tail = NULL;
	head_tail = (struct mem_tail *)l_mana_addr;

	assert_return(-1, head_tail != NULL);

	if (mem_addr == NULL)
	{
		printf("m_free param error\n");
		return -1;
	}

	for (i=0; i< 1024; i++)
	{
		if (head_tail[i].mana_use == 1)
		{
			if ((head_tail[i].addr_offset + l_mem_addr == mem_addr) && (head_tail[i].b_use == 1))
			{
				head_tail[i].b_use = 0;

			}
		}
	}

	return 0;
}

#if 0
int main(int argc, char * argv[])
{
	int * tmp1, *tmp2 = NULL;
	int ret;
	int i, j;
	int curr_size = 1;
	struct mem_tail tmp_tail;
	ret = m_init("test_share");

	tmp1 = m_alloc(MEM_SIZE_16_K, &tmp_tail);
	tmp2 = m_alloc(MEM_SIZE_1_K, &tmp_tail);

	m_free(tmp1);
	m_free(tmp2 );

	
	tmp1 = m_alloc(MEM_SIZE_16_M, &tmp_tail);
	printf("m_alloc MEM_SIZE_16_M: %p\n", tmp1);
	//m_free(tmp1);

	
	tmp1 = m_alloc(MEM_SIZE_16_K, &tmp_tail);
	printf("m_alloc MEM_SIZE_16_K: %p\n", tmp1);
	m_free(tmp1);
	tmp2 = m_alloc(MEM_SIZE_64_K, &tmp_tail);
	printf("m_alloc MEM_SIZE_64_K: %p\n", tmp2);
	m_free(tmp2 );

	return 0;
}
#endif

int _rfc_save_log_file(char * file_name, char * data, int data_len)
{
	char _file_name[256] = {0};

	snprintf(_file_name, sizeof(_file_name), "rfc_%s.log", file_name);
	
	int fd = -1;
	fd = open(_file_name, O_RDWR | O_CREAT, 0666);
	write(fd, data, data_len);
	close(fd);

	return 0;
};

int m_save_all(char * file_name)
{
	_rfc_save_log_file(file_name, l_mem_addr, 16*1024*1024);
	return 0;
}

char * m_base_addr()
{
	printf("base addr: %p\n", l_mem_addr);
}

