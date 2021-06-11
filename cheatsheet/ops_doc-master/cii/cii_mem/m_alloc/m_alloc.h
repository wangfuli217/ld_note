#ifndef _M_ALLOC_H_
#define _M_ALLOC_H_

#ifdef __cplusplus
extern "C"{
#endif

struct mem_tail
{
	//struct list_head list_head;
	unsigned int addr_offset; //开始地址,相对于共享内存开始的偏移
	unsigned int size; //长度, MEM_SIZE_16_M
	unsigned int size_real;//真实长度
	unsigned int size_index; //长度index, MEM_SIZE_INDEX_16_M
	int b_use; //是否被使用
	unsigned int m_id; //memory id
	unsigned int reference_count; //引用计数器
	
	int mana_index;
	int mana_use; 
};


int m_init(char * shm_name);
int m_set_zeros(); //清空所有数据

void * m_alloc(size_t mem_size, struct mem_tail * ret_tail);
int m_free(void * mem_addr);
void * m_addr(struct mem_tail * ret_tail);


#ifdef __cplusplus
}
#endif

#endif

