#include "circle_buff.h"
#include "tools-util.h"

#define SHM_MANAGE_NAME "/circle_buff.mana"
#define SHM_MANAGE_INSTANCE_NUMS 64
#define SHM_MANAGE_USE_TABLE_NAME_TEMP "/circle_buff_%d.utb"
#define SHM_MANAGE_USE_TABLE_NUMS 1024

typedef enum 
{
	NOT_USE = 0x0,
	USEING = 0x1,
	HEAD = 0x10,
	//NORMAL = 0x100,
	LAST = 0x1000,
}UTB_TYPE;

struct utb_item_t
{
	uint64 id;
	UTB_TYPE type; //可以有use和pos两个属性
	char res[4];
	uint64 next_id;
	uint64 prev_id;
	int32 start_offset;
	int32 end_offset;
	int32 size;
};

void * shm_addr_get(char * shm_name, int32 shm_size)
{
	int32 shm_fd;
	int32 ret;
	void * shm_addr;
	int32 b_first_creat = 0;
	
	if (-1 == (ret = shm_fd = shm_open(shm_name, O_RDWR , 0666)))
	{
		print("%s open error, try creat", shm_name);
		assert_goto(_err, 0 < (ret = shm_fd = shm_open(shm_name, O_RDWR | O_CREAT, 0666)));
		b_first_creat = 1;
	}

	assert_goto(_err, 0 == ftruncate(shm_fd, shm_size));
	assert_goto(_err, NULL != (shm_addr = mmap(NULL, shm_size, PROT_WRITE|PROT_READ, MAP_SHARED, 
		shm_fd, 0)));
	close(shm_fd);
	if (b_first_creat)
	{
		memset(shm_addr, 0, shm_size);
	}
	return shm_addr;
_err:
	perror("errcode:");
	if (shm_fd > 0)
	{
		close(shm_fd);
	}
	if (shm_addr != NULL)
	{
		munmap(shm_addr, shm_size);
	}
	return NULL;
}

int shm_addr_free(void * addr, int size)
{
	assert_return(-1, addr != NULL);
	
	return munmap(addr, size)  ;
	
}

//new a utb share memory
static int manager_new_utb(char * utb_name, int utb_name_len)
{
	char utb_name_str[512] = {0};
	int ret;
	void * utb_mem_addr = NULL;
	struct utb_item_t * tmp_item;
	int i;
	
	assert_return(-1, "inst is null" && (NULL != utb_name));

	//snprintf(utb_name_str, sizeof(utb_name_str), SHM_MANAGE_USE_TABLE_NAME_TEMP, inst_id);
	strncpy(utb_name_str, utb_name, MIN(512, utb_name_len));
	assert_goto(_err, NULL != (utb_mem_addr = 
		shm_addr_get(utb_name_str, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t))));
	
	memset(utb_mem_addr, 0, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t));

	for (i=0; i< SHM_MANAGE_USE_TABLE_NUMS; i++)
	{
		tmp_item = ((struct utb_item_t *)utb_mem_addr) + i;
		tmp_item->id = i;
		tmp_item->type = NOT_USE;
	}
	tmp_item = (struct utb_item_t *)utb_mem_addr;
	tmp_item->type = LAST | HEAD | LAST;
	shm_addr_free(utb_mem_addr, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t));

	return 0;
	
_err:
	shm_addr_free(utb_mem_addr, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t));

	return -1;
}

//得到头部的数据的utb信息
int manager_utb_get_first(char * utb_name, struct utb_item_t * utb_copy_item)
{
	void * utb_mem_addr = NULL;	
	struct utb_item_t * tmp_utb_item = NULL;
	int i;
	
	assert_goto(_err,( utb_name != NULL));

	assert_goto(_err, NULL != (utb_mem_addr = 
		shm_addr_get(utb_name, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t))));

	//find last item
	for (i=0; i< SHM_MANAGE_USE_TABLE_NUMS; i++)
	{
		tmp_utb_item = ((struct utb_item_t *)utb_mem_addr)+i;
		if ((tmp_utb_item->type & HEAD))
		{
			break;
		}
	}

	//if can't find LAST,we will use the first
	if (i == SHM_MANAGE_USE_TABLE_NUMS)
	{
		print("can't find the first utb item");
		//tmp_utb_item = ((struct utb_item_t *)utb_mem_addr);
	}
	assert_goto(_err, tmp_utb_item != NULL);
	memcpy(utb_copy_item, tmp_utb_item, sizeof( struct utb_item_t));
	
	shm_addr_free(utb_mem_addr, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t));
	return 0;
_err:

	shm_addr_free(utb_mem_addr, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t));
	return -1;
}

int manager_utb_get_last(char * utb_name, struct utb_item_t * utb_copy_item)
{
	void * utb_mem_addr = NULL;	
	struct utb_item_t * tmp_utb_item = NULL;
	struct utb_item_t * last_utb_item = NULL;
	int i;
	
	assert_goto(_err,( utb_name != NULL));

	assert_goto(_err, NULL != (utb_mem_addr = 
		shm_addr_get(utb_name, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t))));



	//find last item
	for (i=0; i< SHM_MANAGE_USE_TABLE_NUMS; i++)
	{
		tmp_utb_item = ((struct utb_item_t *)utb_mem_addr)+i;
		if (tmp_utb_item->type & LAST)
		{
			last_utb_item = tmp_utb_item;
			break;
		}
	}
	
	if (i == SHM_MANAGE_USE_TABLE_NUMS)
	{
		print("can't find the last utb item");
		//tmp_utb_item = ((struct utb_item_t *)utb_mem_addr);
	}

	assert_goto(_err,  last_utb_item != NULL)

	memcpy(utb_copy_item, last_utb_item, sizeof( struct utb_item_t));
	
	shm_addr_free(utb_mem_addr, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t));
	return 0;
_err:
	print("some error happened");
	shm_addr_free(utb_mem_addr, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t));
	return -1;
}

int manager_utb_item_delete(char * utb_name, struct utb_item_t * utb_item)
{
	void * utb_mem_addr = NULL;	
	struct utb_item_t * tmp_utb_item = NULL;
	int i;

	assert_goto(_err,( utb_name != NULL));
	assert_goto(_err,( utb_item != NULL));
	
	assert_goto(_err, NULL != (utb_mem_addr = 
		shm_addr_get(utb_name, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t))));

	assert_goto(_err, utb_item->id < SHM_MANAGE_USE_TABLE_NUMS);
	//查找到当前需要删除的节点
	tmp_utb_item = ((struct utb_item_t *)utb_mem_addr)+utb_item->id;
	(((struct utb_item_t *)utb_mem_addr)+tmp_utb_item->prev_id)->next_id = tmp_utb_item->next_id;
	(((struct utb_item_t *)utb_mem_addr)+tmp_utb_item->next_id)->prev_id = tmp_utb_item->prev_id;

	//print("next id: %llu  prev id: %llu", (tmp_utb_item->next_id),
	//	(tmp_utb_item->prev_id));
	

	if (tmp_utb_item->type & HEAD)
	{
	
		tmp_utb_item->type &= (~HEAD);
		(((struct utb_item_t *)utb_mem_addr)+tmp_utb_item->next_id)->type |= HEAD;
	}
	if (tmp_utb_item->type & LAST)
	{
		
		tmp_utb_item->type &= (~LAST);
		(((struct utb_item_t *)utb_mem_addr)+tmp_utb_item->prev_id)->type |= LAST;
	}
	
	tmp_utb_item->type &= (~USEING);

	shm_addr_free(utb_mem_addr, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t));
	return 0;
_err:
	print("some error happened");
	if (utb_mem_addr != NULL)
	{
		shm_addr_free(utb_mem_addr, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t));
	}

	return -1;
}

int manager_utb_delete_first(char * utb_name)
{
	void * utb_mem_addr = NULL;	
	struct utb_item_t tmp_utb_item;

	assert_goto(_err, 0 == manager_utb_get_first(utb_name, &tmp_utb_item));
	assert_goto(_err, 0 == manager_utb_item_delete(utb_name, &tmp_utb_item));
	
	return 0;
_err:
	print("some error happened");

	return -1;
}

int manager_utb_delete_last(char * utb_name, struct utb_item_t * utb_item)
{
	void * utb_mem_addr = NULL; 
	struct utb_item_t tmp_utb_item;

	assert_goto(_err, 0 == manager_utb_get_last(utb_name, &tmp_utb_item));
	assert_goto(_err, 0 == manager_utb_item_delete(utb_name, &tmp_utb_item));
	
	return 0;
_err:
	print("some error happened");

	return -1;

}

//检查1维两个线段是否交叉
//顶点可以相等0,4  4,8不算交叉, 0, 4: 0,4交叉
//交叉返回1，不交叉返回0
int check_1dim_cross(int32 s1, int32 e1, int32 s2, int32 e2)
{
	//print("s1: %d  e1: %d  s2: %d  e2: %d", s1, e1, s2, e2);
	if ((s1 >= s2) && (s1 < e2))
	{
		return 1;
	}
	else if ((s2 >= s1) && (s2 < e1))
	{
		return 1;
	}
	else if((e1 > s2) && (e1 <= e2))
	{
		return 1;
	}
	else if((e2 > s1) && (e2 <= e1))
	{
		return 1;
	}
	else if (e1 < s1)
	{
		if ((e1 > s2) || (e1 > e2))
		{
			return 1;
		}
	}
	else if (e2 < s2)
	{
		if ((e2 > s1) || (e2 > e1))
		{
			return 1;
		}
	}
	return 0;
}

//insert a item into utb instance
int manager_utb_insert(char * utb_name, int start_offset, int end_offset,  int size)
{
	void * utb_mem_addr = NULL;
	struct utb_item_t * tmp_utb_item = NULL;
	struct utb_item_t * this_utb_item = NULL;
	struct utb_item_t head_utb_item;
	int i,j;
	int find_last = 0;

	//print("start_offset: %d  end_offset: %d", start_offset, end_offset);
	assert_goto(_err,( utb_name != NULL) && (size >= 0) && (start_offset >= 0));
	
	assert_goto(_err, NULL != (utb_mem_addr = 
		shm_addr_get(utb_name, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t))));

	//优先返回HEAD并且NOTUSE
	for (i=0; i< SHM_MANAGE_USE_TABLE_NUMS; i++)
	{
		tmp_utb_item = ((struct utb_item_t *)utb_mem_addr)+i;
		
		if ((tmp_utb_item->type & HEAD) && !(tmp_utb_item->type & USEING))
		{
			this_utb_item = tmp_utb_item;
			break;
		}
	}

	if (this_utb_item == NULL)
	{
		//find a not use item
		for (i=0; i< SHM_MANAGE_USE_TABLE_NUMS; i++)
		{
			tmp_utb_item = ((struct utb_item_t *)utb_mem_addr)+i;
			if (0 == (tmp_utb_item->type &(USEING)))
			{
				this_utb_item = tmp_utb_item;
				//this_utb_item->id = i;
				this_utb_item->type |= USEING;

				break;
			}
		}
	}

	assert_goto(_err, this_utb_item!=NULL);
	
	manager_utb_get_first(utb_name, &head_utb_item);
	//find last item
	for (i=0; i< SHM_MANAGE_USE_TABLE_NUMS; i++)
	{
		tmp_utb_item = ((struct utb_item_t *)utb_mem_addr)+i;
		if (tmp_utb_item->type & LAST)
		{
			tmp_utb_item->type &= ~LAST;			
			tmp_utb_item->next_id= this_utb_item->id;	
			
			this_utb_item->type |= (LAST | USEING);
			this_utb_item->prev_id = tmp_utb_item->id;
			this_utb_item->next_id = head_utb_item.id;
			//head_utb_item.prev_id = this_utb_item->id;
			this_utb_item->start_offset = start_offset;
			this_utb_item->end_offset = end_offset;
			this_utb_item->size = size;

			for (j=0; j< SHM_MANAGE_USE_TABLE_NUMS; j++)
			{
				
				tmp_utb_item = ((struct utb_item_t *)utb_mem_addr)+j;
				if (tmp_utb_item->type & HEAD)
				{
					//print("this_utb_item->id: %d", this_utb_item->id);
					tmp_utb_item->prev_id = this_utb_item->id;
					break;
				}
			}
			find_last = 1;
			break;
		}
	}
	assert_goto(_err, find_last == 1);

// TODO: 检查溢出
#if 1
_continue_check:

	assert_goto(_err, 0 == manager_utb_get_first(utb_name, &head_utb_item));
	
	//delete all conflict items
	//if (this_utb_item->end_offset > this_utb_item->start_offset)
	{
		if (head_utb_item.type & LAST)
		{
			//首尾在一起
			//print("head and last is one");
		}
		else
		{
			if(check_1dim_cross(head_utb_item.start_offset,head_utb_item.end_offset,
				this_utb_item->start_offset,this_utb_item->end_offset))
			{
				//覆盖
				//print("conflict, delete %ld s: %d  e: %d  curr id: %ld s: %d  e: %d", head_utb_item.id, 
				//	head_utb_item.start_offset, head_utb_item.end_offset, this_utb_item->id, 
				//	this_utb_item->start_offset, this_utb_item->end_offset);
				manager_utb_delete_first(utb_name);
				goto _continue_check;
			}
		}
	}
	

#endif
	shm_addr_free(utb_mem_addr, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t));
	return 0;
	
_err:

	shm_addr_free(utb_mem_addr, SHM_MANAGE_USE_TABLE_NUMS*sizeof(struct utb_item_t));

	return -1;
}

//锁定instance中的utb_lock
int manager_lock_instance(uint32 id)
{
	int shm_namage_fd;
	int ret;
	int i;
	void * shm_manage_start;

	assert_return(-1, "id error" && (id < SHM_MANAGE_INSTANCE_NUMS))
	
	assert_goto(_err, NULL != (shm_manage_start = shm_addr_get(SHM_MANAGE_NAME, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t))));
	//print("lock: %d __count: %d", id, (((struct cb_inst_t *)shm_manage_start) + id)->utb_lock.__data.__count);
	while(0 != pthread_mutex_lock(&((((struct cb_inst_t *)shm_manage_start) + id)->utb_lock)))
	{
		perror("pthread_mutex_lock");
		usleep(1000);
	}
	shm_addr_free(shm_manage_start, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t));

	return 0;
_err:
	perror("error str");
	if (shm_manage_start != NULL)
	{
		shm_addr_free(shm_manage_start, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t));
	}

	return -1;
}

//锁定instance中的utb_lock
int manager_unlock_instance(uint32 id)
{
	int shm_namage_fd;
	int ret;
	int i;
	void * shm_manage_start;

	assert_return(-1, "id error" && (id < SHM_MANAGE_INSTANCE_NUMS))

	assert_goto(_err, NULL != (shm_manage_start = shm_addr_get(SHM_MANAGE_NAME, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t))));
	//print("unlock: %d", id);
	while(0 != pthread_mutex_unlock(&((((struct cb_inst_t *)shm_manage_start) + id)->utb_lock)))
	{
		perror("pthread_mutex_unlock");
		usleep(1000);
	}
	shm_addr_free(shm_manage_start, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t));

	return 0;
_err:
	perror("error str");
	if (shm_manage_start != NULL)
	{
		shm_addr_free(shm_manage_start, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t));
	}

	return -1;
}


//浠庡叡浜唴瀛樹腑鑾峰彇瀹炰緥瀵硅薄
static int manager_get_instance(uint32 id, struct cb_inst_t * inst)
{
	int shm_namage_fd;
	int ret;
	int i;
	void * shm_manage_start;

	assert_return(-1, "inst is null" && (NULL != inst));
	assert_return(-1, "id error" && (id < SHM_MANAGE_INSTANCE_NUMS))

	assert_goto(_err, NULL != (shm_manage_start = shm_addr_get(SHM_MANAGE_NAME, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t))));

	if ((((struct cb_inst_t *)shm_manage_start) + id)->b_use == 1)
	{
		memcpy(inst, (char *)(((struct cb_inst_t *)shm_manage_start) + id), sizeof(struct cb_inst_t));
	}
	else
	{
		print("instance not use");
		goto _err;
	}
	shm_addr_free(shm_manage_start, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t));

	return 0;
_err:
	perror("error str");
	if (shm_manage_start != NULL)
	{
		shm_addr_free(shm_manage_start, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t));
	}

	return -1;
}

static int32 manager_find_shm_instance(char * shm_name, uint32 shm_size)
{
	void * shm_manage_start;
	int32 i, id, find_inst = 0;
	struct cb_inst_t * tmp_inst;

	assert_return(-1, "inst is null" && (NULL != shm_name));

	
	assert_goto(_err, NULL != (shm_manage_start = shm_addr_get(SHM_MANAGE_NAME, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t))));

	for (i=0; i< SHM_MANAGE_INSTANCE_NUMS; i++)
	{
		tmp_inst = ((struct cb_inst_t *)shm_manage_start) + i;
		if ((tmp_inst->b_use) && (tmp_inst->type == CB_TYPE_SHM) && (0 == strncmp(tmp_inst->shm.name, shm_name, 256)))
		{
			if (tmp_inst->size == shm_size)
			{
				id = tmp_inst->inst_id;
				find_inst = 1;
				break;
			}
			else
			{
				print("size is not equal");
			}
		}
	}

	shm_addr_free(shm_manage_start, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t));
	if (find_inst == 0)
	{
		print("can't find this instance");
		goto _err;
	}

	return id;

_err:
	print("some error happened");
	if (shm_manage_start != NULL)
	{
		shm_addr_free(shm_manage_start, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t));
	}
	return -1;
}
//manager上分配一个实例空间
static int manager_new_instance(struct cb_inst_t * inst)
{
	int shm_namage_fd;
	int ret;
	int i;
	void * shm_manage_start;
	int first_creat = 0;
	int tmp_id = -1;
	char tmp_utb_name[128] = {0};
	pthread_mutexattr_t mutexattr;

	assert_return(-1, "inst is null" && (NULL != inst));

	assert_goto(_err, NULL != (shm_manage_start = shm_addr_get(SHM_MANAGE_NAME, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t))));
	
	//memcpy(inst, (struct cb_inst_t *)shm_manage_start[id], sizeof(struct cb_inst_t));
	for (i=0; i< SHM_MANAGE_INSTANCE_NUMS; i++)
	{
		if ((((struct cb_inst_t *)shm_manage_start))[i].b_use == 0)
		{
			tmp_id = i;
			break;
		}
	}
	
	if (tmp_id >= 0)
	{
		((struct cb_inst_t *)shm_manage_start)[i].b_use = 1;
		((struct cb_inst_t *)shm_manage_start)[i].inst_id = tmp_id;
		((struct cb_inst_t *)shm_manage_start)[i].type = inst->type;
		((struct cb_inst_t *)shm_manage_start)[i].size = inst->size;
		
		pthread_mutexattr_init(&mutexattr);
		pthread_mutexattr_setpshared(&mutexattr, PTHREAD_PROCESS_SHARED);
		pthread_mutex_init(&(((struct cb_inst_t *)shm_manage_start)[i].utb_lock), &mutexattr);
		
		switch (inst->type)
		{
			case CB_TYPE_MEMORY:
				((struct cb_inst_t *)shm_manage_start)[i].m.start_addr = inst->m.start_addr;
				((struct cb_inst_t *)shm_manage_start)[i].m.end_addr = inst->m.end_addr;
				//((struct cb_inst_t *)shm_manage_start)[i].m.size = inst->m.size;
				break;
			case CB_TYPE_SHM:
				strcpy(((struct cb_inst_t *)shm_manage_start)[i].shm.name, inst->shm.name);
				break;
			case CB_TYPE_FILE:
				strcpy(((struct cb_inst_t *)shm_manage_start)[i].f.name, inst->f.name);
				break;

				
		}
	}
	else
	{
		print("can't find tmp_id");
		goto _err;
	}

	snprintf(tmp_utb_name, sizeof(tmp_utb_name), SHM_MANAGE_USE_TABLE_NAME_TEMP, tmp_id);
	assert_goto(_err, 0 <= (ret = manager_new_utb(tmp_utb_name, strlen(tmp_utb_name))));
	strcpy(((struct cb_inst_t *)shm_manage_start)[i].utb_name, tmp_utb_name);
	((struct cb_inst_t *)shm_manage_start)[i].utb_ref_counter++;
	shm_addr_free(shm_manage_start, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t));

	return tmp_id;
_err:
	perror("errcode:");
	shm_addr_free(shm_manage_start, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t));

	return -1;
}

static int manager_clean_instance(struct cb_inst_t * inst)
{
	
	manager_lock_instance(inst->inst_id);
	assert_goto(_err, 0 == manager_new_utb(inst->utb_name, strlen(inst->utb_name)));
	manager_unlock_instance(inst->inst_id);

	return 0;
_err:
	manager_unlock_instance(inst->inst_id);
	print("some error happend");
	return -1;
}

static int manager_free_instance(struct cb_inst_t * inst)
{
	int shm_namage_fd;
	int ret;
	int i;
	void * shm_manage_start;
	int first_creat = 0;

	assert_return(-1, "inst is null" && (NULL != inst));

	shm_manage_start = shm_addr_get(SHM_MANAGE_NAME, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t));
	
	//memcpy(inst, (struct cb_inst_t *)shm_manage_start[id], sizeof(struct cb_inst_t));
	for (i=0; i< SHM_MANAGE_INSTANCE_NUMS; i++)
	{
		if ((((struct cb_inst_t *)shm_manage_start))[i].inst_id != inst->inst_id)
		{
			continue;
		}
		print("free instance id : %d", (((struct cb_inst_t *)shm_manage_start))[i].inst_id);
		if ((((struct cb_inst_t *)shm_manage_start))[i].b_use == 1)
		{
			(((struct cb_inst_t *)shm_manage_start))[i].b_use = 0;
			(((struct cb_inst_t *)shm_manage_start))[i].utb_ref_counter--;
			if ((((struct cb_inst_t *)shm_manage_start))[i].type == CB_TYPE_MEMORY)
			{
				//free((((struct cb_inst_t *)shm_manage_start))[i].m.start_addr);
			}
			else if ((((struct cb_inst_t *)shm_manage_start))[i].type == CB_TYPE_SHM)
			{
				//shm_unlink((((struct cb_inst_t *)shm_manage_start))[i].shm.name);
			}
			else
			{
				
			}
			
			//shm_unlink((((struct cb_inst_t *)shm_manage_start))[i].utb_name);
			print("(((struct cb_inst_t *)shm_manage_start))[i].utb_ref_counter: %d", (((struct cb_inst_t *)shm_manage_start))[i].utb_ref_counter)
			if ((((struct cb_inst_t *)shm_manage_start))[i].utb_ref_counter == 0)
			{
				//释放utb
				print("free utb: %s", (((struct cb_inst_t *)shm_manage_start))[i].utb_name);
				shm_unlink((((struct cb_inst_t *)shm_manage_start))[i].utb_name);
			}
			break;
		}
	}
	
	shm_addr_free(shm_manage_start, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t));

	return 0;
_err:
	perror("errcode:");
	if (shm_namage_fd > 0)
	{
		shm_unlink(SHM_MANAGE_NAME);
	}
	if (shm_manage_start != NULL)
	{
		munmap(shm_manage_start, SHM_MANAGE_INSTANCE_NUMS*sizeof(struct cb_inst_t));
	}

	return -1;
}

//返回instance id
int mem_buff_new(struct cb_init_param_t * param)
{
	struct cb_inst_t cb_inst;
	int ret;
	int i;
	int shm_namage_fd;
	void * shm_manage_start;

	assert_return(-1, param != NULL);
	memset(&cb_inst, 0, sizeof(cb_inst));

	assert_return(-1, NULL != (cb_inst.m.start_addr = malloc(param->m.size)));
	cb_inst.m.end_addr = param->m.size + cb_inst.m.start_addr;
	cb_inst.size =  param->m.size;
	cb_inst.type = CB_TYPE_MEMORY;
	cb_inst.b_use = 1;

	return manager_new_instance(&cb_inst);
	
}

int shm_buff_new(struct cb_init_param_t * param)
{
	
	struct cb_inst_t cb_inst;
	void * shm_addr = NULL; 
	int32 inst_id = -1;
	
	assert_return(-1, param != NULL);
	memset(&cb_inst, 0, sizeof(cb_inst));
	//查找存在
	inst_id = manager_find_shm_instance(param->shm.name,param->shm.size);
	if (inst_id >= 0)
	{
		return inst_id;
	}

	assert_goto(_err, NULL !=(shm_addr = shm_addr_get(param->shm.name,param->shm.size)));

	cb_inst.type = CB_TYPE_SHM;
	cb_inst.size = param->shm.size;
	cb_inst.b_use = 1;
	strcpy(cb_inst.shm.name,param->shm.name);
	
	shm_addr_free(shm_addr, param->shm.size);
	return manager_new_instance(&cb_inst);

_err:
	print("some error happened");

	return -1;
}

/*
* 删除循环缓冲区
* 输入:circle_buff [in]: 缓冲区结构体
* 输出:返回新的buff的id
*/
int circle_buff_new(struct cb_init_param_t * param)
{
	assert_return(-1,param != NULL);

	if(param->type == CB_TYPE_MEMORY)
	{
		return mem_buff_new(param);
	}
	else if (param->type == CB_TYPE_SHM)
	{
		return shm_buff_new(param);
	}
	else if (param->type == CB_TYPE_FILE)
	{
		print("not support CB_TYPE_FILE yet");
		return -1;
	}
	else
	{
		return -1;
	}
}

/*
* 内存循环缓冲区添加数据
* cb_id [in]: 循环缓冲区id
* data [in]: 数据
* size [in]: 数据长度
* 输出:0/-1
*/
int mem_buff_push(struct cb_inst_t *inst, void * data, uint32 size)
{
	struct utb_item_t last_utb_item;
	unsigned char * start_addr;
	int start_offset, end_offset;
	int i;

	assert_return(-1, inst != NULL);
	assert_return(-1, data != NULL);
	assert_return(-1, size <  inst->size);
	assert_return(-1, 0 == manager_utb_get_last(inst->utb_name, &last_utb_item));

	start_offset =  (last_utb_item.start_offset+last_utb_item.size)%(inst->size);
	end_offset = (start_offset + size)%(inst->size);

	start_addr = inst->m.start_addr;// + start_offset;

	//add one item in utb
	assert_return(-1,0 ==  manager_utb_insert(inst->utb_name, start_offset, end_offset, size));
	for (i=0; i< size; i++)
	{
		//data copy
		*(start_addr+((start_offset + i)%inst->size)) = ((unsigned char *)data)[i];
	}

	return 0;
}

/*
* 内存循环缓冲区取出数据
* cb_id [in]: 循环缓冲区id
* data [out]: 数据
* size [out]: 数据长度
* 输出:0/-1
*/
int mem_buff_pop(struct cb_inst_t *inst, void ** data, uint32 *size)
{
	struct utb_item_t utb_item;
	void * tmp_data = NULL;
	int i;

	assert_goto(_err, (NULL != inst) && (data != NULL) && (size != NULL));
	
	assert_goto(_err, 0 == manager_utb_get_first(inst->utb_name, &utb_item));

	assert_goto(_err, 0 < utb_item.size);
	assert_goto(_err, 0 < (utb_item.type & USEING));
	assert_goto(_err, NULL != (tmp_data = malloc(utb_item.size)));
	for (i=0; i< utb_item.size; i++)
	{
		((uchar *)tmp_data)[i] = ((uchar *)inst->m.start_addr)[(utb_item.start_offset+i)%inst->size];
	}
	assert_goto(_err, 0 == manager_utb_delete_first(inst->utb_name));

	*data = tmp_data;
	*size = utb_item.size;

	return 0;
_err:
	print("some error happened");

	return -1;
}

int shm_buff_push(struct cb_inst_t *inst, void * data, uint32 size)
{
	struct cb_inst_t mem_inst;
	int ret;

	assert_return(-1, inst != NULL);
	assert_return(-1, data != NULL);
	assert_return(-1, size > 0);

	memcpy(&mem_inst, (uint8 *)inst, sizeof(struct cb_inst_t));

	assert_goto(_err, NULL != (mem_inst.m.start_addr = shm_addr_get(inst->shm.name, inst->size)));
	mem_inst.m.end_addr = ((uint8 *)mem_inst.m.start_addr)+inst->size;

	assert_goto(_err, 0 == (ret = mem_buff_push(&mem_inst, data, size)));

	shm_addr_free(mem_inst.m.start_addr, inst->size);
	return ret;

_err:
	print("some error happened");

	if (mem_inst.m.start_addr!=NULL)
	{
		shm_addr_free(mem_inst.m.start_addr, inst->size);
	}
	return -1;
}

int shm_buff_pop(struct cb_inst_t *inst, void ** data, uint32 *size)
{
	struct cb_inst_t mem_inst;
	int ret;

	assert_return(-1, inst != NULL);
	assert_return(-1, data != NULL);

	memcpy(&mem_inst, (uint8 *)inst, sizeof(struct cb_inst_t));
	
	assert_goto(_err, NULL != (mem_inst.m.start_addr = shm_addr_get(inst->shm.name, inst->size)));
	mem_inst.m.end_addr = ((uint8 *)mem_inst.m.start_addr)+inst->size;

	assert_goto(_err, 0 == (ret = mem_buff_pop(&mem_inst, data, size)));
	shm_addr_free(mem_inst.m.start_addr, inst->size);

	return ret;
_err:
	print("some error happened");
	if (mem_inst.m.start_addr!=NULL)
	{
		shm_addr_free(mem_inst.m.start_addr, inst->size);
	}
	return -1;
}

/*
* 往循环缓冲区添加数据片
* cb_id [in]: 循环缓冲区id
* data [in]: 数据
* size [in]: 数据长度
* 输出:0/-1
*/
int circle_buff_push(uint32 cb_id, void * data, uint32 size)
{
	struct cb_inst_t inst;
	int ret;
	
	ret = manager_get_instance(cb_id, &inst);
	if (ret < 0)
	{
		print("can't find instance by id: %d", cb_id);
		return -1;
	}

	if (inst.type == CB_TYPE_MEMORY)
	{
		manager_lock_instance(cb_id);
		ret = mem_buff_push(&inst, data, size);
		manager_unlock_instance(cb_id);
		return ret;
	}
	else if (inst.type == CB_TYPE_SHM)
	{
		manager_lock_instance(cb_id);
		ret = shm_buff_push(&inst, data, size);
		manager_unlock_instance(cb_id);
		return ret;
	}
	else if (inst.type == CB_TYPE_FILE)
	{
		print("not support CB_TYPE_MEMORY yet");
	}
	else
	{
		print("not support type %d", inst.type);
	}
	
	return -1;
}


/*
* 往循环缓冲区添加数据片
* cb_id [in]: 循环缓冲区id
* data [out]: malloc申请的内存，需要释放。数据
* size [out]: 数据长度
* 输出:0/-1
*/
int circle_buff_pop(uint32 cb_id, void ** data, uint32 *size)
{
	struct cb_inst_t inst;
	int ret;
	
	ret = manager_get_instance(cb_id, &inst);
	if (ret < 0)
	{
		print("can't find instance by id: %d", cb_id);
		return -1;
	}

	if (inst.type == CB_TYPE_MEMORY)
	{
		manager_lock_instance(cb_id);
		ret = mem_buff_pop(&inst, data, size);
		manager_unlock_instance(cb_id);
		return ret;
	}
	else if (inst.type == CB_TYPE_SHM)
	{
		manager_lock_instance(cb_id);
		ret =  shm_buff_pop(&inst, data, size);		
		manager_unlock_instance(cb_id);
		return ret;
	}
	else if (inst.type == CB_TYPE_FILE)
	{
		print("not support CB_TYPE_MEMORY yet");
	}
	else
	{
		print("not support type %d", inst.type);
	}

	return -1;
}

int32 circle_buff_destroy(uint32 cb_id)
{
	struct cb_inst_t inst;
	
	assert_goto(_err, 0 == manager_get_instance(cb_id, &inst));
	assert_goto(_err, 0 == manager_free_instance(&inst));

	return 0;
_err:
	print("some error happened");

	return -1;
}

int32 circle_buff_clean(uint32 cb_id)
{
	struct cb_inst_t inst;
	
	assert_goto(_err, 0 == manager_get_instance(cb_id, &inst));
	assert_goto(_err, 0 == manager_clean_instance(&inst));
	
	return 0;
_err:
	print("some error happened");

	return -1;
}


