#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

int main (int argc, char *argv[]) {
    int ret;
    int len;
    int sock;
    struct sockaddr_in serv_addr;
    char *message = "hello.";
    if (argc != 3) {
        printf ("usage: %s ip port\n", argv[0]);
        return -1;
    }
    memset (&serv_addr, 0, sizeof (serv_addr));
    sock = socket (AF_INET, SOCK_STREAM, 0);
    if (sock == -1) {
        perror ("socket()");
        return -1;
    }
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = inet_addr (argv[1]);
    serv_addr.sin_port = htons (atoi (argv[2]));

    if (connect (sock, (struct sockaddr *) &serv_addr, sizeof (serv_addr)) == -1) {
        perror ("connect()");
        return -1;
    }

    ret = send (sock, message, strlen (message), 0);
    printf ("message = %s\n", message);

    close (sock);
    return 0;
}
