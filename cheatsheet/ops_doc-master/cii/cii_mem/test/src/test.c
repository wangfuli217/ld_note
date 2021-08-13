#include "tools-util.h"
#include "circle_buff.h"
int a_add_b(int a, int b)
{
	return a+b;
}

int t_break()
{
	static int i=1;
	int j;
	while (i++)
	{
		assert_break(j = (i<100));
	}
}
int test_assert()
{
	assert_perror(0 == a_add_b(-1, -4));
	assert_return(-1, 0 < a_add_b(-1, -4));
	return 0;
}

void tm_callback(int timer_id)
{
	print("tm_calback, timer_id: %d", timer_id);
}

void SECTION(".own.func") __sleep(int value)
{
	print("weak sleep");
}

int main(int argc, char * argv)
{
#if 0
	test_assert();
	
	TIME_SPEND(t_break());
#endif
#if 0
	struct net_speed_t net_speed;
	int i;
	strcpy(net_speed.net_dev_name, "enp3s0");
	
	for (i = 0; i< 10; i++)
	{
		assert_return(-1, 0 == sys_net_speed(&net_speed));
		print("recv_speed: %d", net_speed.recv_speed);
		print("trans_speed: %d", net_speed.trans_speed);
		printf("\n");
		//sleep(1);
	}
#endif
#if 0
	timer_callback_func call_back = tm_callback;

	timer_init();
	int tm_id = timer_sleep(300, call_back);
	print("tm_id: %d", tm_id);
#endif
#if 0
	printf( "Sum = %d\n", lambda( int, (int x, int y){ return x - y; })(3, 4) );
	sleep(1);
#endif
#if 0
	struct circle_buff_t * buff = NULL;
	char data[128] = "1234567890";
	struct iovec pop_data[2];
	assert_warning(NULL != (buff = circle_buff_new(15)));
	int i;
	for (i = 0; i< 10; i++)
	{
		circle_buff_push(buff, data, strlen(data));
		print(" s_f: %d  e_f: %d", buff->start_offset, buff->end_offset);
		circle_buff_pop(buff, 4, pop_data);
		print_hex("circle buff", buff->buff_addr, buff->size);
		print_hex("hex", pop_data[0].iov_base, pop_data[0].iov_len);
		circle_buff_pop(buff, 5, pop_data);
		print_hex("circle buff", buff->buff_addr, buff->size);
		print_hex("hex", pop_data[0].iov_base, pop_data[0].iov_len);
		printf("\n");
	}

	circle_buff_delete(buff);
	print("%p", buff);
#endif
	int ret;
	uint32 id;
	int test_data[100];
	int copy_data[100];
	int i;
	int rand_i;
	uchar * pop_data = NULL;
	uint32 pop_size = 0;
	struct cb_init_param_t param;
	param.type = CB_TYPE_SHM;
	param.shm.size = 100;
	strcpy(param.shm.name, "device_yuv_mem");
	TIME_SPEND(id = ret = circle_buff_new(&param));
	print("id : %d", ret);
	struct timespec curr_time;
	int loop_times = 0;
	int input_ch;
	memset(test_data, 0, sizeof(test_data));
	char cmd_str[1024] = {0};
#if 0
	while(1)
	{
		loop_times++;
		clock_gettime(CLOCK_MONOTONIC, &curr_time);
		srand(curr_time.tv_nsec);
		rand_i = rand()%10 + 10;
		memset(test_data, rand_i, sizeof(test_data));
		print_hex("push data", (uchar *)test_data, rand_i);
		if (rand_i % 2 == 0)
		{
			assert_return(-1, 0 == (ret = circle_buff_push(id, test_data, rand_i)));
			//assert_return(-1, 0 == (ret = circle_buff_push(id, test_data, rand_i)));
		}
		else
		{
			assert_return(-1, 0 == (ret = circle_buff_push(id, test_data, rand_i)));
		}
		//snprintf(cmd_str, sizeof(cmd_str), "cp /dev/shm/circle_buff_0.utb /dev/shm/circle_buff_0_%d.utb", loop_times);
		//system(cmd_str);

		assert_warning(0 == (ret = circle_buff_pop(id, (void **)&pop_data, &pop_size)));
		if (pop_data != NULL)
		{
			print_hex("pop data", pop_data, pop_size);
			free(pop_data);
			pop_data = NULL;
		}

		//sleep(1);
	}
#endif
	//assert_return(-1, 0 == (ret = circle_buff_push(id, test_data, 4)));
	while(loop_times < 1000)
	{
		loop_times++;

		input_ch = getc(stdin);
		if (input_ch == 'i')
		{
		
			clock_gettime(CLOCK_MONOTONIC, &curr_time);
			srand(curr_time.tv_nsec);
			rand_i = rand()%30 + 1;
			memset(test_data, rand_i, sizeof(test_data));
			print_hex("push data", (uchar *)test_data, rand_i);
			assert_return(-1, 0 == (ret = circle_buff_push(id, test_data, rand_i)));

			//snprintf(cmd_str, sizeof(cmd_str), "cp /dev/shm/circle_buff_0.utb /dev/shm/circle_buff_0_%d.utb", loop_times);
			//system(cmd_str);

		}
		else if (input_ch == 'o')
		{
			assert_warning(0 == (ret = circle_buff_pop(id, (void **)&pop_data, &pop_size)));
			if (pop_data != NULL)
			{
				int fd;
				fd = open("save.yuv", O_RDWR | O_CREAT, 0666);
				write(fd, pop_data, pop_size);
				close(fd);
				print_hex("pop data", pop_data, pop_size);
				free(pop_data);
				pop_data = NULL;
			}
		}
		else if(input_ch == 'e')
		{
			break;
		}
	}
	//print("pop data size: %d", pop_size);
	//print_hex("pop data", pop_data, pop_size);


	//circle_buff_destroy(id);
	return 0;
}
