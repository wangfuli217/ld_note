
#include "tools-util.h"

void print_hex(char * desc_str, unsigned char * data, int data_len)
{
	int i;
	printf("%s:\n", desc_str);
	for (i=0;i < data_len; i++)
	{
		printf("%hhx ", data[i]);
	}
	printf("\n");
}

uint64 htonll(uint64 val)
{
	return (((uint64)htonl(val)) << 32) + htonl(val >> 32);
}


uint64 ntohll(uint64 val)
{
	return (((uint64)ntohl(val))<<32) + ntohl(val>>32);
}

//读取proc文件系统
//通过返回1，未通过返回0
int check_mem(void * addr, uint64 len, uint32 check_type)
{
	pid_t pid;
	char map_file_name[512] = {0};
	char exe_file_name[512] = {0};
	char exe_str[512] = {0};
	char line_str[512] = {0};
	int succ_flag1 = 0, succ_flag2 = 0, succ_flag3 = 0;
	
	FILE * file = NULL;
	unsigned long long start_addr;
    unsigned long long end_addr;
    char r_flag, w_flag, x_flag, p_flag;
    int offset;
    int major_dev,minor_dev;
    int node;

	assert_return(0, "param error" && (addr != NULL) && (len >= 0))

	pid = getpid();        
    sprintf(map_file_name, "/proc/%d/maps", pid); 
	sprintf(exe_file_name, "/proc/%d/exe", pid);

	assert_goto(_err, 0 < readlink(exe_file_name, exe_str, sizeof(exe_str)));
	assert_goto(_err, NULL != (file = fopen(map_file_name, "r")));

	while(fgets(line_str, 512, file) != NULL)
    {
    	start_addr = end_addr = offset = major_dev = minor_dev = node = 0;
		r_flag = w_flag = x_flag = p_flag = '-';
		//memset(map_file_name, 0, sizeof(map_file_name));
		
        sscanf(line_str, "%llx-%llx %c%c%c%c %x %d:%d %d %s",
               &start_addr, &end_addr, &r_flag, &w_flag, &x_flag, &p_flag,
               &offset, &major_dev, &minor_dev, &node, map_file_name);

		if (((uint64)addr >= start_addr) && ((uint64)addr + len <= end_addr))
		{			
			if (check_type&MEM_TYPE_MASK1)
			{
				succ_flag1 = 1;
				if ((check_type&MEM_TYPE_MASK1) & MEM_TYPE_READ)
				{
					if (r_flag != 'r')
					{
						succ_flag1 = 0;
					}
				}
				if ((check_type&MEM_TYPE_MASK1) & MEM_TYPE_WRITE)
				{
					if (w_flag != 'w')
					{
						succ_flag1 = 0;
					}
				}
				if ((check_type&MEM_TYPE_MASK1) & MEM_TYPE_EXEC)
				{
					if (x_flag != 'x')
					{
						succ_flag1 = 0;
					}
				}

			}

			if (check_type&MEM_TYPE_MASK2)
			{
				if ((check_type&MEM_TYPE_MASK2) == MEM_TYPE_SHARE)
				{
					if (p_flag == 's')
					{
						succ_flag2 = 1;
					}
				}
				else if ((check_type&MEM_TYPE_MASK2) == MEM_TYPE_PRIVITE)
				{
					if (p_flag == 'p')
					{
						succ_flag2 = 1;
					}
				}
				else
				{
					succ_flag2 = 0;
				}

			}

			if (check_type&MEM_TYPE_MASK3)
			{
				succ_flag3 = 0;
				if ((check_type&MEM_TYPE_MASK3) == MEM_TYPE_STACK)
				{
					if (strcmp(map_file_name, "[stack]") == 0)
					{
						succ_flag3 = 1;
					}
				}
				else if ((check_type&MEM_TYPE_MASK3) == MEM_TYPE_HEAP)
				{
					if (strcmp(map_file_name, "[heap]") == 0)
					{
						succ_flag3 = 1;
					}
				}
				else if ((check_type&MEM_TYPE_MASK3) == MEM_TYPE_CODE)
				{
					if (0 == strcmp(exe_str, map_file_name))
					{
						succ_flag3 = 1;
					}
				}
				else if ((check_type&MEM_TYPE_MASK3) == MEM_TYPE_SHARE_LIB)
				{
					if (strstr(map_file_name, ".so"))
					{
						succ_flag3 = 1;
					}
				}
				else
				{
					succ_flag3 = 0;
				}
			}

			break;
		}

    }

	fclose(file);
	file = NULL;
	
	if (check_type&MEM_TYPE_MASK1)
		if (succ_flag1 == 0)
			return 0;
	if (check_type&MEM_TYPE_MASK2)
		if (succ_flag2 == 0)
			return 0;
	if (check_type&MEM_TYPE_MASK3)
		if (succ_flag3 == 0)
			return 0;
	return 1;
	
_err:
	if (file)
	{
		fclose(file);
		file = NULL;
	}
	return 0;
}

int mem_check(mem_t mem, uint32 check_type)
{
	//只比较mem中的type
	if (mem.mem_type & check_type)
	{
		return 1;
	}

	return 0;
}

#if 0
//内存检查，成功返回1，失败返回0
// TODO: 已经废弃，使用check_mem
int mem_check(void * addr)
{
	int fd;
	char maps_text[8192] = {0};
	int ret;
	regex_t regex;
	regmatch_t regmatch[2];
	char tmp_str[8192];
	int flag, file_size, sub_flag;
	unsigned long long start_addr, end_addr;
	
	fd = open("/proc/self/maps", O_RDONLY);
	if (fd < 0)
	{
		print("open maps error\n");
		close(fd);
		return 0;
	}
	file_size = ret = read(fd , maps_text, sizeof(maps_text));
	//print("check point: %p\n", addr);
	
	//print("maps text: %s\n", maps_text);
	assert_return(-1, 0 == regcomp(&regex, "([0-9a-f]+-[0-9a-f]+)", REG_EXTENDED | REG_NEWLINE));
	memset(tmp_str, 0, sizeof(tmp_str));
	for (sub_flag = 0, flag=0; flag< file_size; flag++)
	{
		//取一行匹配
		if (maps_text[flag] == '\n')
		{
			sub_flag = 0;
			memset(regmatch, 0, sizeof(regmatch));
			
			assert_return(-1, 0 == regexec(&regex, maps_text, 2, regmatch, REG_NOTBOL));
			
			if ((regmatch[0].rm_so >= 0) && (regmatch[0].rm_eo >= 0))
			{
				//memset(tmp_str, 0, sizeof(tmp_str));
				//strncpy(tmp_str, maps_text+regmatch[0].rm_so, regmatch[0].rm_eo - regmatch[0].rm_so);
				//print("tmp_str: %s\n", tmp_str);
				sscanf(tmp_str, "%llx-%llx", &start_addr, &end_addr);
				//print("start addr: %llx  end_addr : %llx\n", start_addr, end_addr);
				if (((long)addr > start_addr) && ((long)addr < end_addr))
				{
					//print("addr is ok\n");
					goto _success;
				}
			}
			memset(tmp_str, 0, sizeof(tmp_str));
		}
		else
		{
			tmp_str[sub_flag++] = maps_text[flag];
		}
	}
	
	regfree(&regex);
	close(fd);
	//print("addr is bad\n");
	return 0;
_success:
	regfree(&regex);
	close(fd);
	return 1;
}
#endif

//从文件读取一行,返回读取长度
int read_line(int index, char * src_str, int src_str_len, char * out_str, int out_str_len)
{
	int i;
	int line_start_flag = 0;
	int line_end_flag = 0;
	int line_index = 0;

	for (i=0; i< src_str_len; i++)
	{
		if (src_str[i] == '\n')
		{
			line_index++;
			if (line_index == index)
			{
				line_start_flag = MIN(i+1, src_str_len);
			}
			else if (line_index == index+1)
			{
				line_end_flag = i;
				break;
			}
		}
	}

	if (line_start_flag > line_end_flag)
	{
		line_end_flag = line_start_flag;
	}

	strncpy(out_str, src_str+line_start_flag, MIN(out_str_len, line_end_flag - line_start_flag));

	return line_end_flag - line_start_flag;
	
}

//获取当前网络速率，单位KiB/s
int sys_net_speed(struct net_speed_t * net_speed)
{
	int file_fd;
	int ret;
	char * net_info_str = NULL;
	char line_str[256] = {0};
	int line_index = 0;
	char net_dev_name[32] = {0};
	char recv_str[32] = {0}, trans_str[32] = {0};
	struct timespec curr_time;
	regex_t reg;
	regmatch_t r_match[4];

	long long recv_nums = 0, trans_nums = 0;

	assert_return(-1, "param error" && (net_speed != NULL));
	
	assert_goto(_err, 0 < (file_fd = open("/proc/net/dev", O_RDONLY)));

	assert_goto(_err, NULL != (net_info_str = (char *)malloc(8192)));
	assert_goto(_err, 0 < (ret = read(file_fd, net_info_str, 8192)));
	
	assert_goto(_err, 0 == regcomp(&reg, "([a-zA-Z0-9]+):[ ]*([0-9]+)[ ]*([0-9]+)", REG_EXTENDED));

	memset(r_match, -1, sizeof(r_match));
	while(0 < read_line(line_index, net_info_str, strlen(net_info_str), line_str, sizeof(line_str)))
	{		
		line_index++;
		//print("line_str: %s", line_str);
		
		ret = regexec(&reg, line_str, 4, r_match, 0);
		//print("regexec: %d", ret)
		if (ret < 0)
		{
			regerror(ret, &reg, line_str, sizeof(line_str));
			print("regerror: %s", line_str);
			goto _err;
		}

		strncpy(net_dev_name, line_str+r_match[1].rm_so, MIN(r_match[1].rm_eo - r_match[1].rm_so, sizeof(net_dev_name)));
		strncpy(recv_str, line_str+r_match[2].rm_so, MIN(r_match[2].rm_eo - r_match[2].rm_so, sizeof(recv_str)));
		strncpy(trans_str, line_str+r_match[3].rm_so, MIN(r_match[3].rm_eo - r_match[3].rm_so, sizeof(trans_str)));
		
		if (0 == strncmp(net_dev_name, net_speed->net_dev_name, strlen(net_speed->net_dev_name)))
		{
			sscanf(recv_str, "%lld", &recv_nums);
			sscanf(trans_str, "%lld", &trans_nums);
			//print("net_dev_name: %s recv_nums: %lld  trans_nums: %lld", net_dev_name, recv_nums, trans_nums);
			break;
		}
		
	}

	if (line_index == 0)
	{
		print("sys error");
		goto _err;
	}

	clock_gettime(CLOCK_MONOTONIC, &curr_time);
	int totle_msec = (curr_time.tv_sec - net_speed->curr_time.tv_sec)*1000 + (curr_time.tv_nsec - net_speed->curr_time.tv_nsec)/1000000;

	
	long long totle_recv = (recv_nums) - net_speed->curr_recv_nums;
	long long totle_trans = (trans_nums) - net_speed->curr_trans_nums;

	totle_recv = totle_recv>0?totle_recv:1;
	totle_msec = totle_msec>0?totle_msec:1;
	totle_trans = totle_trans>0?totle_trans:1;

	net_speed->recv_speed = (totle_recv/1024.0)/(totle_msec/1000.0); //byte/ms == kb/s
	net_speed->trans_speed = (totle_trans/1024.0)/(totle_msec/1000.0);
	
	//print("totle_recv: %lld totle_trans: %lld", totle_recv, totle_trans);
	
	net_speed->curr_time = curr_time;
	net_speed->curr_recv_nums = (recv_nums);
	net_speed->curr_trans_nums = (trans_nums);

	if (file_fd > 0)
			close(file_fd);
	if (net_info_str != NULL)
			free(net_info_str);
	regfree(&reg);
	return 0;

_err:
	if (file_fd > 0)
		close(file_fd);
	if (net_info_str != NULL)
		free(net_info_str);
	regfree(&reg);

	return -1;
}

//定时器



//定时器线程
struct timer_list_t
{
	struct list_head head;
	int timer_fd;
	//int v_fd; //临时文件fd
	timer_callback_func call_back;
	struct timespec start_time; //开始时间
	unsigned long ms;			//持续时间，ms计算
};

static struct list_head l_timer_list_head; //struct timer_list_t
static int timer_ready = -1;
static pthread_t pid;
static pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

unsigned int find_min_sleep_time()
{
	struct timer_list_t * tmp_timer_item;
	struct timespec curr_time;
	unsigned int min_ms = 1000;

	clock_gettime(CLOCK_MONOTONIC, &curr_time);
	
	list_for_each_entry(tmp_timer_item, &l_timer_list_head, head)
	{
		if (tmp_timer_item != NULL)
		{
			min_ms = MIN(min_ms,  tmp_timer_item->ms - ((curr_time.tv_sec - tmp_timer_item->start_time.tv_sec) * 1000 + (curr_time.tv_nsec - tmp_timer_item->start_time.tv_nsec)/1000000));
		}
	}

	min_ms = min_ms < 0?0:min_ms;

	return min_ms;
}

int timer_exec_callback()
{
	struct timer_list_t * tmp_timer_item;
	struct timespec curr_time;
	
	clock_gettime(CLOCK_MONOTONIC, &curr_time);

	list_for_each_entry(tmp_timer_item, &l_timer_list_head, head)
	{
        assert_break((tmp_timer_item->call_back != NULL));
		if ((curr_time.tv_sec - tmp_timer_item->start_time.tv_sec) * 1000 + (curr_time.tv_nsec - tmp_timer_item->start_time.tv_nsec)/1000000 >= tmp_timer_item->ms)
		{
			tmp_timer_item->call_back(tmp_timer_item->timer_fd);		
			list_del(&tmp_timer_item->head);
			break;
		}
	}
	return 0;
}


void * timer_task(void * args)
{
	unsigned int sleep_time;
	struct timespec timeout;
	int ret;

	timer_ready = 0;

	for ( ; ; )
	{		
		pthread_mutex_lock(&mutex);
		sleep_time = find_min_sleep_time();
		//print("sleep_time: %u", sleep_time)
		gettimeofday((struct timeval *)&timeout, 0);
		timeout.tv_sec += sleep_time / 1000;
		timeout.tv_nsec += (sleep_time % 1000) * 1000000;
		ret = pthread_cond_timedwait(&cond, &mutex, &timeout);
		pthread_mutex_unlock(&mutex);

		if (ret == ETIMEDOUT)
		{
			timer_exec_callback();
		}
		else
		{
			//发生异常
			//print("retry time out")
		}
	}
}

int timer_init()
{
	if (timer_ready < 0)
	{
		INIT_LIST_HEAD(&l_timer_list_head);
		pthread_create(&pid, NULL, timer_task, NULL);
		while(timer_ready < 0)
		{
			usleep(1000);
		}
	}
	return 0;
}

int timer_sleep(unsigned long msec, timer_callback_func call_back)
{	
	static  int timer_sleep_max_fd = 0;
	struct timer_list_t * tmp_timer_item = NULL;

	assert_return(-1, "param error" && (call_back != NULL) && (msec > 0));

	assert_goto(_err, NULL != (tmp_timer_item = (struct timer_list_t *)malloc(sizeof(struct timer_list_t))));
	//tmp_timer_item->v_fd = v_fd;
	tmp_timer_item->timer_fd = ++timer_sleep_max_fd;
	tmp_timer_item->call_back = call_back;
	clock_gettime(CLOCK_MONOTONIC, &tmp_timer_item->start_time);
	tmp_timer_item->ms = msec;
	list_add(&tmp_timer_item->head, &l_timer_list_head);

	//通过信号中断
	pthread_mutex_lock(&mutex);
	pthread_cond_signal(&cond);
	pthread_mutex_unlock(&mutex);
	return tmp_timer_item->timer_fd;

_err:
	
	if (tmp_timer_item != NULL)
	{
		list_del(&tmp_timer_item->head);
		free(tmp_timer_item);
	}
	return -1;
}

int str_endwith(const char * str, const char * flag)
{
	int str_len, flag_len;
	int i;

	assert_return(-1, (str != NULL) && (flag != NULL));
	str_len = strlen(str);
	flag_len = strlen(flag);

	for (i=0; i< MIN(str_len, flag_len); i++)
	{
		if (str[str_len-i-1] != flag[flag_len-i-1])
		{
			return 0;
		}
	}

	return 1;
}

int str_startwith(const char * str, const char * flag)
{
	int str_len, flag_len;
	int i;

	assert_return(-1, (str != NULL) && (flag != NULL));
	str_len = strlen(str);
	flag_len = strlen(flag);

	for (i=0; i< MIN(str_len, flag_len); i++)
	{
		if (str[i] != flag[i])
		{
			return 0;
		}
	}

	return 1;
}

//内部函数
int mem_alloc(mem_t * mem, int32 size)
{
	void * addr = NULL;

	assert_return(-1, "param error" && (NULL != mem) && (size > 0));
	assert_goto(_err, NULL != (addr = malloc(size)));
	memset(addr, 0, size);
	mem->data = addr;
	mem->capacity = size;
	mem->data_len = 0;
	mem->mem_type = MEM_TYPE_READ | MEM_TYPE_WRITE | MEM_TYPE_PRIVITE | MEM_TYPE_HEAP;
	return 0;
_err:
	print("some error happend");
	return -1;
}
//内部函数
int mem_free(mem_t * mem)
{
	assert_return(-1, "param error" && (NULL != mem));
	if (!check_mem(mem->data,mem->data_len, MEM_TYPE_HEAP | MEM_TYPE_WRITE))
	{
		return -1;
	}
	
	if (mem->data != NULL)
	{
		free(mem->data);
	}

	return 0;
}

mem_t * mem_new(int32 size)
{
	mem_t * mem = NULL;

	assert_goto(_err, NULL != (mem = malloc(sizeof(mem_t))));
	assert_goto(_err, 0 == mem_alloc(mem, size));
	
	return mem;

_err:
	if (mem)
		free(mem);
	return NULL;
}

mem_t * mem_new_with_pointer(void * data, int32 data_size)
{
	mem_t * mem = NULL;

	assert_goto(_err, NULL != (mem = malloc(sizeof(mem_t))));
	mem->capacity = data_size;
	mem->data_len = data_size;
	mem->data = data;

	mem->mem_type = 0x0;
	if(check_mem(data, data_size, MEM_TYPE_READ))
		mem->mem_type |= MEM_TYPE_READ;
	if(check_mem(data, data_size, MEM_TYPE_WRITE))
		mem->mem_type |= MEM_TYPE_WRITE;
	if(check_mem(data, data_size, MEM_TYPE_EXEC))
		mem->mem_type |= MEM_TYPE_EXEC;
	
	if(check_mem(data, data_size, MEM_TYPE_SHARE))
		mem->mem_type |= MEM_TYPE_SHARE;
	else if(check_mem(data, data_size, MEM_TYPE_PRIVITE))
		mem->mem_type |= MEM_TYPE_PRIVITE;
	
	if(check_mem(data, data_size, MEM_TYPE_STACK))
		mem->mem_type |= MEM_TYPE_STACK;
	else if(check_mem(data, data_size, MEM_TYPE_HEAP))
		mem->mem_type |= MEM_TYPE_HEAP;
	else if(check_mem(data, data_size, MEM_TYPE_CODE))
		mem->mem_type |= MEM_TYPE_CODE;
	else if(check_mem(data, data_size, MEM_TYPE_SHARE_LIB))
		mem->mem_type |= MEM_TYPE_SHARE_LIB;
	
	return mem;
_err:
	return NULL;
}

int mem_delete(mem_t ** mem)
{
	if (mem)
	{
		if (*mem)
		{
			if (mem_free(*mem))
			{
				(*mem)->data = NULL;
				(*mem)->capacity = 0;
				(*mem)->data_len = 0;
			}
		}
		if (check_mem(*mem, sizeof(mem_t), MEM_TYPE_HEAP | MEM_TYPE_WRITE))
		{
			free(*mem);
			*mem = NULL;
		}
	}

	return 0;
}


int mem_append(mem_t * mem, const char * data, int32 len)
{
	assert_return(-1, "param error" && (NULL != mem) && (data != NULL) && (len > 0));

	if((mem->data_len + len) <= mem->capacity)
	{
		//需要扩大内存
	}

	//判断内存是否刻写
	assert_goto(_err, "memory isn't writeable" && check_mem(mem->data, len, MEM_TYPE_WRITE));

	memcpy(mem->data + mem->data_len, data, len);
	mem->data_len += len;

	return 0;


_err:
	print("some error happend");
	return -1;
}

int mem_put(mem_t * mem, const char * data, int32 len)
{
	assert_return(-1, "param error" && (NULL != mem) && (data != NULL) && (len > 0));
	
	mem->data_len = 0;
	assert_return(-1, 0 == mem_append(mem, data, len));

	return 0;
}
int mem_get(mem_t * mem, char ** data, int32 * len)
{
	assert_return(-1, "param error" && (NULL != mem) && (data != NULL) && (len != NULL));

	*data = mem->data;
	*len = mem->data_len;

	return 0;
}


