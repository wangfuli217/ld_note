// Thread pool server 

#include <sys/types.h>
#include <signal.h>
#include <sys/uio.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <netdb.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/time.h>
#include <pthread.h>
#include <string.h>

#define BACKLOG 200
#define N_THREADS 5
// if more than BACKLOG clients in the server accept queue, client connect will fail

void error (char *msg) {
    fprintf (stderr, "ERROR: %s failed\n", msg);
    exit (-1);
}

struct sockaddr_in make_server_addr (short port) {
    struct sockaddr_in addr;
    memset (&addr, 0, sizeof addr);
    addr.sin_family = AF_INET;
    addr.sin_port = htons (port);
    addr.sin_addr.s_addr = INADDR_ANY;
    return addr;
}

int create_server_socket (short port) {
    int s = socket (AF_INET, SOCK_STREAM, 0);
    int optval = 1;
    setsockopt (s, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof optval);
    struct sockaddr_in my_addr = make_server_addr (port);
    if (s == -1)
        error ("socket()");
    bind (s, (struct sockaddr *) &my_addr, sizeof my_addr);
    listen (s, BACKLOG);
    return s;
}

void get_file_request (int socket, char *fileName) {
    char buf[BUFSIZ];
    int n = read (socket, buf, BUFSIZ);
    if (n < 0)
        error ("read from socket");
    buf[n] = '\0';
    strcpy (fileName, buf);
    //printf("Server got file name of '%s'\n", fileName);
}

void write_file_to_client_socket (char *file, int socket) {
    char buf[BUFSIZ];
    int n;
    int ifd = open (file, O_RDONLY);
    if (ifd == -1)
        error ("open()");
    while ((n = read (ifd, buf, BUFSIZ)) > 0)
        write (socket, buf, n);
    close (ifd);
}

void handle_request (int client_socket) {
    char fileName[BUFSIZ];
    get_file_request (client_socket, fileName);
    write_file_to_client_socket (fileName, client_socket);
    close (client_socket);
}

void time_out (int arg) {
    fprintf (stderr, "Server timed out\n");
    exit (0);
}

void set_time_out (int seconds) {
    struct itimerval value = { 0 };
    value.it_value.tv_sec = seconds;
    setitimer (ITIMER_REAL, &value, NULL);
    signal (SIGALRM, time_out);
}

//////////////////////////////////////////////////////////
int q[5];
int first = 0, last = 0, numInQ = 0;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;  // mutual exclusion 
pthread_mutex_t empty = PTHREAD_MUTEX_INITIALIZER;  // synchronization 

void putOnQ (int sockfd) {
    pthread_mutex_lock (&mutex);
    q[first] = sockfd;
    first = (first + 1) % 5;
    numInQ++;
    pthread_mutex_unlock (&mutex);
    pthread_mutex_unlock (&empty);
}

int getOffQ () {
    while (numInQ == 0)
        pthread_mutex_lock (&empty);
    pthread_mutex_lock (&mutex);
    int sockfd = q[last];
    last = (last + 1) % 5;
    numInQ--;
    pthread_mutex_unlock (&mutex);
    return sockfd;
}

void *threadWork (void *arg) {
    while (1) {
        int client_socket = getOffQ ();
        handle_request (client_socket);
    }
}

void accept_client_requests (int server_socket) {
    int client_socket;
    struct sockaddr_in client_addr;
    socklen_t sin_size = sizeof client_addr;
    set_time_out (5);
    while ((client_socket = accept (server_socket, (struct sockaddr *) &client_addr, &sin_size)) > 0) {
        set_time_out (5);
        putOnQ (client_socket);
    }
}

/*
   Note, I put in a 5 second time out so you don't leave servers running.
*/

int main (int argc, char *argv[]) {
    if (argc != 2)
        error ("usage: server port");
    short port = atoi (argv[1]);
    int server_socket = create_server_socket (port);

    pthread_t threads[N_THREADS];
    for (int i = 0; i < N_THREADS; i++)
        pthread_create (&threads[i], NULL, threadWork, NULL);

    accept_client_requests (server_socket);
    shutdown (server_socket, 2);
    return 0;
}
