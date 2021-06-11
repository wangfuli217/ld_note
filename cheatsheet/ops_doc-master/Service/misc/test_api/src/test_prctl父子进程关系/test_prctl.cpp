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
    //����һ��socket��ַ�ṹserver_addr,���������internet��ַ, �˿�
    struct sockaddr_in server_addr;
    bzero(&server_addr, sizeof(server_addr)); //��һ���ڴ���������ȫ������Ϊ0
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = htons(INADDR_ANY);
    server_addr.sin_port = htons(HELLO_WORLD_SERVER_PORT);

    //��������internet����Э��(TCP)socket,��server_socket���������socket
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

    //��socket��socket��ַ�ṹ��ϵ����
    if (bind(server_socket, (struct sockaddr*) &server_addr,
            sizeof(server_addr))) {
        printf("Server Bind Port : %d Failed!", HELLO_WORLD_SERVER_PORT);
        exit(1);
    }

    //server_socket���ڼ���
    if (listen(server_socket, LENGTH_OF_LISTEN_QUEUE)) {
        printf("Server Listen Failed!");
        exit(1);
    }

    while (1) //��������Ҫһֱ����
    {
        //����ͻ��˵�socket��ַ�ṹclient_addr
        struct sockaddr_in client_addr;
        socklen_t length = sizeof(client_addr);

        //����һ����server_socket�����socket��һ������
        //���û����������,�͵ȴ�������������--����accept����������
        //accept��������һ���µ�socket,���socket(new_server_socket)����ͬ���ӵ��Ŀͻ���ͨ��
        //new_server_socket�����˷������Ϳͻ���֮���һ��ͨ��ͨ��
        //accept���������ӵ��Ŀͻ�����Ϣ��д���ͻ��˵�socket��ַ�ṹclient_addr��
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
                //����buffer�е��ַ�����new_server_socket,ʵ���Ǹ��ͻ���
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
        //�ر���ͻ��˵�����
        close(new_server_socket);
    }
    //�رռ����õ�socket
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
    free(stack); //������Ҳ�������������ﲻ�ͷţ���֪�����߳������󣬸��ڴ��Ƿ���ͷţ�֪���߿��Ը�����,лл
    exit(1);
}

void * forkchild(void * arg) {

    void * stack;
    a = 1;
    stack = malloc(FIBER_STACK);//Ϊ�ӽ�������ϵͳ��ջ

    if(!stack)
    {
        printf("The stack failed\n");
        exit(0);
    }
    printf("creating son thread!!!\n");

    clone(&do_something, (char *)stack + FIBER_STACK, CLONE_VM , 0);//�������߳�

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
