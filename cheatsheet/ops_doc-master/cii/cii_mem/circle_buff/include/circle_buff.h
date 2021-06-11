#ifndef _CIRCLE_BUFF_H
#define _CIRCLE_BUFF_H
/* 缓冲增长方向
* -------------------------------------------------
*   |  head  |      normal      |     normal     |      last     |  notuse  |
*   -------------------------------------------------
*		>--------------------------------->
*/



#include <stdio.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "tools-util.h"

#ifdef __cplusplus
extern "C"{
#endif
typedef enum _cb_type
{
	CB_TYPE_MEMORY = 1,
	CB_TYPE_SHM,
	CB_TYPE_FILE,
}CB_TYPE;

struct cb_inst_mem_t
{
	void * start_addr;
	void * end_addr;
	//uint32 size;
};
struct cb_inst_shm_t
{
	char name[256];
	char mana_name[264];
};

struct cb_inst_file_t
{
	char name[512];
};

struct cb_inst_t
{
	uint32 inst_id; 
	CB_TYPE type;
	uint32 size;
	int32 b_use;
	char utb_name[128];
	uint32 utb_ref_counter; //utb的引用计数器
	pthread_mutex_t utb_lock;
	union
	{
		struct cb_inst_mem_t m;
 		struct cb_inst_shm_t shm;
		struct cb_inst_file_t f;
	};
};



/*存储到环形缓冲的一个单元，缓冲对单元是整存整取
*
*/
struct cb_slice_t
{
	uint64 slice_id;
	void * start_addr;
	void * end_addr;
	int32 size;
};

struct _m
{
	int32 size;
};

struct _shm
{
	int32 size;
	char name[256];
};
struct _f
{
	int size;
	char file_name[512];
};

struct cb_init_param_t
{
	CB_TYPE type;
	union
	{
		struct _m m;
		struct _shm shm;
		struct _f f;
	};
};

/*
* 删除循环缓冲区
* 输入:circle_buff [in]: 缓冲区结构体
* 输出:返回新的buff的id
*/
int32 circle_buff_new(struct cb_init_param_t * param);
int32 circle_buff_destroy(uint32 cb_id);
int32 circle_buff_push(uint32 cb_id, void * data, uint32 size);
int32 circle_buff_pop(uint32 cb_id, void ** data, uint32 *size);
int32 circle_buff_clean(uint32 cb_id);
#ifdef __cplusplus
}
#endif

#endif


