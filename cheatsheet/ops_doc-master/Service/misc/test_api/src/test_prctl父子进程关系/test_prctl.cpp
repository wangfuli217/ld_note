#include <sys/prctl.h>
#include <signal.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <netinet/in.h>    // for sockaddr_in
#include <sys/types.h>    // for socket
#include <sys/socket.h>    // for socket
#include <stdio.h>        // for printf
#include <stdlib.h>        // for exit
#include <string.h>        // for bzero
#include <pthread.h>

 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>

#include <unistd.h>
#include <sys/syscall.h>   /* For SYS_xxx definitions */
#include <sys/types.h>
#include <sched.h>
#include <sys/mman.h>
#include <signal.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <sys/wait.h>

#define HELLO_WORLD_SERVER_PORT    6666
#define LENGTH_OF_LISTEN_QUEUE 20
#define BUFFER_SIZE 1024
#define FILE_NAME_MAX_SIZE 512

void* tcpServer(void * arg) {
    //设置一个socket地址结构server_addr,代表服务器internet地址, 端口
    struct sockaddr_in server_addr;
    bzero(&server_addr, sizeof(server_addr)); //把一段内存区的内容全部设置为0
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = htons(INADDR_ANY);
    server_addr.sin_port = htons(HELLO_WORLD_SERVER_PORT);

    //创建用于internet的流协议(TCP)socket,用server_socket代表服务器socket
    int server_socket = socket(PF_INET, SOCK_STREAM, 0);
    if (server_socket < 0) {
        printf("Create Socket Failed!");
        exit(1);
    }

    {
        int opt = 1;
        setsockopt(server_socket, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
    }

    int flags = fcntl(server_socket, F_GETFD);
    printf("flags = %d\n", flags);
    flags |= FD_CLOEXEC;
    fcntl(server_socket, F_SETFD, flags);
    printf("flags = %d\n", flags);

    //把socket和socket地址结构联系起来
    if (bind(server_socket, (struct sockaddr*) &server_addr,
            sizeof(server_addr))) {
        printf("Server Bind Port : %d Failed!", HELLO_WORLD_SERVER_PORT);
        exit(1);
    }

    //server_socket用于监听
    if (listen(server_socket, LENGTH_OF_LISTEN_QUEUE)) {
        printf("Server Listen Failed!");
        exit(1);
    }

    while (1) //服务器端要一直运行
    {
        //定义客户端的socket地址结构client_addr
        struct sockaddr_in client_addr;
        socklen_t length = sizeof(client_addr);

        //接受一个到server_socket代表的socket的一个连接
        //如果没有连接请求,就等待到有连接请求--这是accept函数的特性
        //accept函数返回一个新的socket,这个socket(new_server_socket)用于同连接到的客户的通信
        //new_server_socket代表了服务器和客户端之间的一个通信通道
        //accept函数把连接到的客户端信息填写到客户端的socket地址结构client_addr中
        int new_server_socket = accept(server_socket,
                (struct sockaddr*) &client_addr, &length);
        if (new_server_socket < 0) {
            printf("Server Accept Failed!\n");
            break;
        }

        char buffer[BUFFER_SIZE];
        bzero(buffer, BUFFER_SIZE);
        length = recv(new_server_socket, buffer, BUFFER_SIZE, 0);
        if (length < 0) {
            printf("Server Recieve Data Failed!\n");
            break;
        }
        char file_name[FILE_NAME_MAX_SIZE + 1];
        bzero(file_name, FILE_NAME_MAX_SIZE + 1);
        strncpy(file_name, buffer,
                strlen(buffer) > FILE_NAME_MAX_SIZE ?
                        FILE_NAME_MAX_SIZE : strlen(buffer));
//        int fp = open(file_name, O_RDONLY);
//        if( fp < 0 )
        printf("%s\n", file_name);
        FILE * fp = fopen(file_name, "r");
        if (NULL == fp) {
            printf("File:\t%s Not Found\n", file_name);
        } else {
            bzero(buffer, BUFFER_SIZE);
            int file_block_length = 0;
//            while( (file_block_length = read(fp,buffer,BUFFER_SIZE))>0)
            while ((file_block_length = fread(buffer, sizeof(char), BUFFER_SIZE,
                    fp)) > 0) {
                printf("file_block_length = %d\n", file_block_length);
                //发送buffer中的字符串到new_server_socket,实际是给客户端
                if (send(new_server_socket, buffer, file_block_length, 0) < 0) {
                    printf("Send File:\t%s Failed\n", file_name);
                    break;
                }
                bzero(buffer, BUFFER_SIZE);
            }
//            close(fp);
            fclose(fp);
            printf("File:\t%s Transfer Finished\n", file_name);
        }
        //关闭与客户端的连接
        close(new_server_socket);
    }
    //关闭监听用的socket
    close(server_socket);
    return NULL;
}
#if 1
void * forkchild(void * arg) {
    sleep(5);

    pid_t pid = fork();
//        prctl(PR_SET_PDEATHSIG, SIGHUP);
    if (pid == 0) {
//        sleep(10);
        prctl(PR_SET_PDEATHSIG, SIGUSR1);
//        for (;;) {
        printf("I'm a child\n");
//            sleep(1);
//        }
//        ::setsid();
        execl("/bin/sh", "sh", "-c", "./test.sh", (char *) 0);
        printf("execl");
    } else if (pid > 0) {
        printf("I'm a parent\n");
//        while(1)
            sleep(5);
        printf("I'm a parent exit\n");
        exit(1);
    } else {
        fprintf(stderr, "can't fork ,error %d\n", errno);
        exit(1);
    }
    printf("This is the end !");
    return NULL;
}
#else
#include <malloc.h>
#include <sched.h>
#define FIBER_STACK 8192
int a;
void * stack;
int do_something(void * arg)
{
    sleep(5);
    printf("This is son, the pid is:%d, the a is: %d\n", getpid(), ++a);
    prctl(PR_SET_PDEATHSIG, SIGUSR1);
//        for (;;) {
    printf("I'm a child\n");
//            sleep(1);
//        }
    ::setsid();
    execl("/bin/sh", "sh", "-c", "./test.sh", (char *) 0);
    printf("execl");
    printf("free\n");
    free(stack); //这里我也不清楚，如果这里不释放，不知道子线程死亡后，该内存是否会释放，知情者可以告诉下,谢谢
    exit(1);
}

void * forkchild(void * arg) {

    void * stack;
    a = 1;
    stack = malloc(FIBER_STACK);//为子进程申请系统堆栈

    if(!stack)
    {
        printf("The stack failed\n");
        exit(0);
    }
    printf("creating son thread!!!\n");

    clone(&do_something, (char *)stack + FIBER_STACK, CLONE_VM , 0);//创建子线程

    sleep(10);
    printf("I'm a parent exit\n");
    exit(1);

    return NULL;
}
#endif
int main() {
    pthread_t tid;
    pthread_attr_t attr;

    pthread_attr_init (&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);

    pthread_create(&tid, &attr, forkchild, NULL);
    pthread_attr_destroy(&attr);

    tcpServer (NULL);
    return 0;
}
