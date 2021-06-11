#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <sys/un.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char * argv[]) {
    int s_fd, c_fd;
    int s_len, c_len;
    struct sockaddr_un s_addr,c_addr; /*����һ��UNIX���׽��ֽṹ*/
    int i, bytes;
    char ch_send, ch_recv;


    unlink("./s_socket"); /*ɾ��ԭ��server_socket����*/

    /*���� socket, ͨ��Э��ΪAF_UNIX, SCK_STREAM ���ݷ�ʽ*/
    s_fd = socket(AF_UNIX, SOCK_STREAM, 0);

    /*���÷�������Ϣ(ͨ��Э��)*/
    s_addr.sun_family = AF_UNIX;

    /*���÷�������Ϣ(socket ����)*/
    strcpy(s_addr.sun_path, "./s_socket");

    /*���÷�������Ϣ(��������ַ����)*/
    s_len = sizeof(s_addr);

    /*�� socket ����*/
    bind(s_fd, (struct sockaddr *) &s_addr, s_len);

    /*��������,������Ϊ5*/
    listen(s_fd, 5);
    printf("Server is waiting for client connect... \n ");
    c_len = sizeof(c_addr);

    /*���ܿͻ�������; ��2�����������洢�ͻ��˵�ַ; ��3�����������洢�ͻ��˵�ַ�Ĵ�С*/
    /*����(����)һ�����ͻ��˵��ļ�������,���ԶԿͻ��˵Ķ�д����*/
    c_fd = accept(s_fd, (struct sockaddr *) &s_addr,
            (socklen_t *) &c_len);
    if (c_fd == -1) {
        perror("accept");
        exit( EXIT_FAILURE);
    }
    printf("The server is waiting for client data... \n ");

    for (i = 0, ch_send = '1'; i < 5; i++, ch_send++) {
        if ((bytes = read(c_fd, &ch_recv, 1)) == -1) {
            perror("read");
            exit( EXIT_FAILURE);
        }
        printf("The character receiver from client is %c \n ", ch_recv);
        sleep(1);
        if ((bytes = write(c_fd, &ch_send, 1)) == -1) {
            perror("read");
            exit( EXIT_FAILURE);
        }
    }

    close(c_fd);

    unlink("server socket");
}
