#include <linux/un.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <dirent.h>
#include "psignal.h"

#define PSIGNAL_ROOT_PATH "/tmp/psignal"

struct call_func_item
{
	struct list_head head;
	//char sid[128];		//接收来自哪个sid的命令
	char sig_name[128];	//signal名称
	sig_callback_func call_func; //回调函数
};

typedef enum _udm_pack_type
{
	UDM_PACK_CALL = 0,
	UDM_PACK_REPLY,
}udm_pack_type;

struct udm_pack_t
{
	char src_sid[128];
	char sig_name[128];
	int session_id;
	udm_pack_type pack_type; //0:call 1:reply
	
	int data_len;
	char data[1024];
};

struct call_items_t
{
	struct list_head head;
	struct udm_pack_t udm_pack;
	struct udm_pack_t reply_udm_pack;
	struct timeval call_time; //调用时间
	sem_t sem;
};

static char g_sun_path[512] = {0};
static char g_this_sid[128] = {0};
static int g_udm_sock_fd = -1;
static struct list_head g_regist_func_head;//注册回调
static struct list_head g_wait_reply_list;//等待回复

static int sig_main_loop();

static void * sig_iner_main_loop(void * args)
{
	sig_main_loop();
}

static void check_timeout_task(int clock_fd)
{
	struct timeval curr_time;
	gettimeofday(&curr_time, NULL);

	struct call_items_t * item;

	list_for_each_entry(item, &g_wait_reply_list, head)
	{
		if (((curr_time.tv_sec*1000 + curr_time.tv_usec/1000) - (item->call_time.tv_sec + item->call_time.tv_usec/1000)) > 1000)
		{
			item->reply_udm_pack.data_len = -1;
			sem_post(&item->sem);
		}
	}

	timer_sleep(1000,check_timeout_task);
}

int sig_init(const char * sid)
{
	char sun_path[512] = {0};
	struct sockaddr_un udm_addr;
	int ret;
	pthread_t pid;

	assert_return(-1, NULL != sid);

	INIT_LIST_HEAD(&g_regist_func_head);
	INIT_LIST_HEAD(&g_wait_reply_list);
	mkdir(PSIGNAL_ROOT_PATH, 0777);

	strcpy(g_this_sid, sid);
	snprintf(g_sun_path, sizeof(g_sun_path), "%s/%s.psig", PSIGNAL_ROOT_PATH, sid);
	assert_warning("old socket is delete, please check!!!" && (0 != remove(g_sun_path)));
	memset(&udm_addr, 0, sizeof(udm_addr));
	udm_addr.sun_family = AF_UNIX;
	strncpy(udm_addr.sun_path, g_sun_path, MIN(UNIX_PATH_MAX, strlen(g_sun_path)));
	assert_goto(_err, 0 < (g_udm_sock_fd = socket(AF_UNIX, SOCK_DGRAM, 0)));
	assert_goto(_err, 0 == (ret = bind(g_udm_sock_fd, (struct sockaddr *)&udm_addr, sizeof(udm_addr))));

	//开启多线程接收信号
	assert_goto(_err, 0 == pthread_create(&pid, NULL, sig_iner_main_loop, NULL));

	//开启定时器，检查超时请求
	timer_init();
	timer_sleep(1000,check_timeout_task);
	
	return 0;

_err:
	print("some error happend");
	perror("errno");
	return -1;
}

int func_call(const struct udm_pack_t * udm_pack, int pack_size)
{
	struct call_func_item * func_item = NULL;
	int success_call = 0;
	struct call_param_t call_param;

	assert_goto(_err, (udm_pack != NULL) && (pack_size == sizeof(struct udm_pack_t)));
	
	list_for_each_entry(func_item, &g_regist_func_head, head)
	{
		if (0 == strcmp(udm_pack->sig_name, func_item->sig_name))
		{
			if (func_item->call_func == NULL)
			{
				continue;
			}
			memcpy(call_param.src_sid, udm_pack->src_sid, 128);
			call_param.session_id = udm_pack->session_id;
			func_item->call_func(&call_param, udm_pack->data, udm_pack->data_len);
			success_call = 1;
			break;
		}
	}

	if (!success_call)
		goto _not_found;

	return 0;

_not_found:
	return 0;

_err:
	print("some error happend");

	return -1;
}

int func_reply(const struct udm_pack_t * udm_pack, int pack_size)
{
	struct call_items_t * item;

	list_for_each_entry(item, &g_wait_reply_list, head)
	{
		if (item->udm_pack.session_id == udm_pack->session_id)
		{
			memcpy(&item->reply_udm_pack, udm_pack, sizeof(struct udm_pack_t));
			sem_post(&item->sem);
		}
	}

	return 0;
}

static int sig_main_loop()
{
	struct sockaddr_un client_addr;
	int client_addr_len;
	int ret;
	char recv_buff[1472] = {0};
	int recv_len;
	struct udm_pack_t * recv_pack;
	
	while(1)
	{
		memset(recv_buff, 0, sizeof(recv_buff));
		recv_len = sizeof(recv_buff);
		ret = recvfrom(g_udm_sock_fd, recv_buff, recv_len, 0, (struct sockaddr *)&client_addr, &client_addr_len);
		//memcpy(&recv_pack, recv_buff, MIN(recv_len, sizeof(struct udm_pack_t)));
		recv_pack = (struct udm_pack_t *)recv_buff;
		//print("pack type: %d", recv_pack->pack_type);
		if (recv_pack->pack_type == UDM_PACK_CALL)
		{
			assert_warning(0 == func_call(recv_pack, sizeof(struct udm_pack_t)));
		}
		else if (recv_pack->pack_type == UDM_PACK_REPLY)
		{
			assert_warning(0 == func_reply(recv_pack, sizeof(struct udm_pack_t)));
		}
	}
}

unsigned int get_random_session_id()
{
	struct timespec curr_time;
	int tmp_rand_num = 0;
	struct call_items_t * item;
	int is_avalible = 1;
	
	while(1)
	{
		clock_gettime(CLOCK_MONOTONIC, &curr_time);
		srand(curr_time.tv_nsec);
		tmp_rand_num = rand();
		//查找冲突
		list_for_each_entry(item, &g_wait_reply_list, head)
		{
			if (item->udm_pack.session_id == tmp_rand_num)
			{
				is_avalible = 0;
				break;
			}
		}

		if (is_avalible)
		{
			break;
		}
	}

	return tmp_rand_num;
}

int sid_do_send_ex(const char * dst_sid, const char * sig_name, 
	const void * data, int data_len, struct udm_pack_t * out_pack)
{
	struct sockaddr_un dst_addr;
	struct udm_pack_t send_pack;
	int ret;

	memset(&send_pack,0, sizeof(send_pack));
	dst_addr.sun_family = AF_UNIX;
	snprintf(dst_addr.sun_path, UNIX_PATH_MAX, "%s/%s.psig", PSIGNAL_ROOT_PATH, dst_sid);
	strcpy(send_pack.src_sid, g_this_sid);
	strcpy(send_pack.sig_name, sig_name);
	send_pack.data_len = data_len;
	send_pack.pack_type = UDM_PACK_CALL;
	send_pack.session_id = get_random_session_id();
	memcpy(send_pack.data, data, data_len);
	
	ret = sendto(g_udm_sock_fd, &send_pack, sizeof(struct udm_pack_t), 0, 
		(struct sockaddr *)&dst_addr, sizeof(struct sockaddr_un));
	assert_goto(_err, ret> 0);

	if (out_pack != NULL)
	{
		memcpy(out_pack, &send_pack, sizeof(struct udm_pack_t));
	}
	return ret;
_err:
	print("some error happend, errno: %d, dst_addr: %s", errno, dst_addr.sun_path);
	if (errno == ECONNREFUSED)
	{
		remove(dst_addr.sun_path);
		print("warning: remove socket %s", dst_addr.sun_path);
	}

	return -1;
}

int sid_do_send(const char * dst_sid, const char * sig_name, 
	const void * data, int data_len)
{
	return sid_do_send_ex(dst_sid, sig_name, 
		data, data_len, NULL);
}


int sig_do_reply(const char * dst_sid, int session_id, const void * data, int data_len)
{
	struct sockaddr_un dst_addr;
	struct udm_pack_t send_pack;
	int ret;

	dst_addr.sun_family = AF_UNIX;
	snprintf(dst_addr.sun_path, UNIX_PATH_MAX, "%s/%s.psig", PSIGNAL_ROOT_PATH, dst_sid);
	//print("reply sid: %s", dst_addr.sun_path);
	strcpy(send_pack.src_sid, g_this_sid);
	memset(send_pack.sig_name, 0, sizeof(send_pack.sig_name));
	send_pack.data_len = data_len;
	send_pack.pack_type = UDM_PACK_REPLY;
	send_pack.session_id = session_id;
	memcpy(send_pack.data, data, data_len);
	
	ret = sendto(g_udm_sock_fd, &send_pack, sizeof(struct udm_pack_t), 0, (struct sockaddr *)&dst_addr, sizeof(struct sockaddr_un));
	assert_goto(_err, ret> 0);

	return ret;
_err:
	print("some error happend");

	return -1;
}

int sig_send_wait_reply(const char * dst_sid, const char * sig_name, 
	const void * data, int data_len, void * reply_data, int * reply_data_len)
{
	struct call_items_t * call_items = NULL;
	assert_goto(_err1, dst_sid != NULL);

	call_items = malloc(sizeof(struct call_items_t));
	memset(call_items, 0, sizeof(struct call_items_t));
	assert_goto(_err1, 0 < sid_do_send_ex(dst_sid,sig_name,data,data_len, &call_items->udm_pack));
	gettimeofday(&call_items->call_time, NULL);
	sem_init(&call_items->sem, 0, 0);
	list_add((struct list_head *)call_items, &g_wait_reply_list);
	//wait
	sem_wait(&call_items->sem);
	if (call_items->reply_udm_pack.data_len > 0)
	{
		memcpy(reply_data, call_items->reply_udm_pack.data, call_items->reply_udm_pack.data_len);
	}
	else if (call_items->reply_udm_pack.data_len == -1)
	{
		print("time out");
		goto _err;
	}
	list_del((struct list_head *)call_items);
	free(call_items);
	return 0;
_err1:
	//call_items未加入链表
	print("some error happend");
	if (call_items != NULL)
		free(call_items);
	return -1;
	
_err:
	print("some error happend");
	if (call_items != NULL)
	{
		list_del((struct list_head *)call_items);
		free(call_items);
	}
	return -1;
}

int sig_reply(const char * dst_sid, int session_id, const void * data,int data_len)
{
	return sig_do_reply(dst_sid, session_id, data, data_len);
}

int sig_send(const char * dst_sid, const char * sig_name, const void * data, int data_len)
{
	struct sockaddr_un dst_addr;
	struct udm_pack_t send_pack;
	int ret;
	char sid_str[128] = {0};

	assert_goto(_err, (data_len <= 1024) && (data_len >= 0));
	assert_goto(_err, sig_name != NULL);
	if (data_len > 0)
	{
		assert_goto(_err, data != NULL);
	}

	//广播到所有进程
	if (dst_sid == NULL)
	{
		DIR * dst_dir;
		struct dirent * dir_item;
		assert_goto(_err, NULL != (dst_dir = opendir(PSIGNAL_ROOT_PATH)));
		while(NULL != (dir_item = readdir(dst_dir)))
		{
			
			if (str_startwith(dir_item->d_name, g_this_sid) || 
				str_startwith(dir_item->d_name, ".") || !str_endwith(dir_item->d_name, ".psig"))
			{
				continue;
			}
			memset(sid_str, 0, sizeof(sid_str));
			strncpy(sid_str, dir_item->d_name, strlen(dir_item->d_name) - strlen(".psig"));
			//print("broadcast to sid: %s", sid_str);
			assert_goto(_err, 0 < sid_do_send(sid_str,sig_name,data,data_len));
		}

		closedir(dst_dir);
	}
	else
	{
		assert_goto(_err, 0 < sid_do_send(dst_sid,sig_name,data,data_len));
	}

	return 0;
_err:

	return -1;
}

int check_signame_used(const char * sig_name)
{
	struct call_func_item * tmp_item;
	int ret = 0;

	assert_return(-1, NULL != sig_name);
	//检查是否已经注册
	list_for_each_entry(tmp_item, &g_regist_func_head, head)
	{
		if (0 == strcmp(tmp_item->sig_name, sig_name))
		{
			ret = 1;
			break;
		}
	}

	return ret;
}

int sig_regist_callback(const char * sig_name, sig_callback_func callback)
{
	struct call_func_item * add_item = NULL;

	assert_goto(_err, sig_name != NULL);
	assert_goto(_err, callback != NULL);
	assert_goto(_err, NULL != (add_item = malloc(sizeof(struct call_func_item))));

	memset(add_item, 0, sizeof(struct call_func_item));
	//检查名称是否冲突
	assert_goto(_err, 0 == check_signame_used(sig_name));

	strncpy(add_item->sig_name, sig_name, MIN(128, strlen(sig_name)));
	add_item->call_func = callback;

	list_add((struct list_head *)add_item, &g_regist_func_head);

	return 0;
_err:
	print("some error happend");

	return -1;
}

