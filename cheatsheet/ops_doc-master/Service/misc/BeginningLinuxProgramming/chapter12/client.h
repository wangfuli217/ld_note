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
	服务器进程首先创建FIFO[mkfifo];然后打开该文件open(file,O_RDONLY);
	接下来等待客户端将数据写到服务器文件中。

	将数据从服务器端读出来， 数据包括客户端进程pd和数据
	对数据进行分析，然后将数据写到客户端里面。
*/
/*
	客户端打开服务器端，然后创建客户端FIFO[mkfifo];
	接下来将数据写到服务器文件中。

	打开客户端文件，读取客户端文件中的数据，open(file,O_RDONLY);
	对数据进行分解。
*/
