#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <sys/un.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char * argv[]) {
    int fd;
    struct sockaddr_un s_address, c_address;
    int s_len,c_len;

    char ch_recv, ch_send;
    int i, bytes;
    int ret;

    unlink("./c_socket"); /*ɾ��ԭ��client_socket����*/

    /*����socket,AF_UNIXͨ��Э��,SOCK_STREAM���ݷ�ʽ*/
    if ((fd = socket(AF_UNIX, SOCK_STREAM, 0)) == -1) {
        perror("socket");
        exit( EXIT_FAILURE);
    }

    /*���÷�������Ϣ(ͨ��Э��)*/
    c_address.sun_family = AF_UNIX;

    /*���÷�������Ϣ(socket ����)*/
    strcpy(c_address.sun_path, "./c_socket");

    /*���÷�������Ϣ(��������ַ����)*/
    c_len = sizeof(c_address);

    /*�� socket ����*/
    bind(fd, (struct sockaddr *) &c_address, c_len);

    s_address.sun_family = AF_UNIX;
    strcpy(s_address.sun_path, "./s_socket");
    s_len = sizeof(s_address);

    /*�������������������*/
    ret = connect(fd, (struct sockaddr *) &s_address, s_len);
    if (ret == -1) {
        printf("ensure the server is up \n ");
        perror("connect");
        exit( EXIT_FAILURE);
    }

    for (i = 0, ch_send = 'A'; i < 5; i++, ch_send++) {
        if ((bytes = write(fd, &ch_send, 1)) == -1) { /*����Ϣ��������*/
            perror("write");
            exit( EXIT_FAILURE);
        }

        sleep(2); /*��Ϣ�������ٷ�һ��*/

        if ((bytes = read(fd, &ch_recv, 1)) == -1) { /*������Ϣ*/
            perror("read");
            exit( EXIT_FAILURE);
        }

        printf("receive from server data is %c \n ", ch_recv);
    }
    close(fd);

    return (0);
}
