#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <limits.h>
#include <sys/types.h>
#include <sys/stat.h>

#define SERVER_FIFO_NAME "/tmp/serv_fifo"
#define CLIENT_FIFO_NAME "/tmp/cli_%d_fifo"

#define BUFFER_SIZE 20

struct data_to_pass_st {
    pid_t  client_pid;
    char   some_data[BUFFER_SIZE - 1];
};
/*
	�������������ȴ���FIFO[mkfifo];Ȼ��򿪸��ļ�open(file,O_RDONLY);
	�������ȴ��ͻ��˽�����д���������ļ��С�

	�����ݴӷ������˶������� ���ݰ����ͻ��˽���pd������
	�����ݽ��з�����Ȼ������д���ͻ������档
*/
/*
	�ͻ��˴򿪷������ˣ�Ȼ�󴴽��ͻ���FIFO[mkfifo];
	������������д���������ļ��С�

	�򿪿ͻ����ļ�����ȡ�ͻ����ļ��е����ݣ�open(file,O_RDONLY);
	�����ݽ��зֽ⡣
*/
