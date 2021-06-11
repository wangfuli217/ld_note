/*  Make the necessary includes and set up the variables.  */

#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <sys/un.h>
#include <unistd.h>
#include <sys/stat.h>

#define offsetof( s_name, m_name )  (size_t)&(((s_name *)0)->m_name)
#define SERVER_NAME  "/etc/server_socket"

int main(void)
{
    int server_sockfd, client_sockfd;
    int server_len, client_len;
    struct sockaddr_un server_address;
    struct sockaddr_un client_address;
	struct stat sta;
	char system_command[256];
/*  Remove any old socket and create an unnamed socket for the server.  */

    unlink("server_socket");

//	if( stat(SERVER_NAME, &sta) < 0)
//	{
//		sprintf(system_command, "touch %s", SERVER_NAME);
//		system(system_command);
//	}
	
    server_sockfd = socket(AF_UNIX, SOCK_STREAM, 0);

/*  Name the socket.  */

	memset(&server_address, 0, sizeof(server_address));
    server_address.sun_family = AF_UNIX;
    strcpy(server_address.sun_path, SERVER_NAME);
    server_len = sizeof(server_address);
	printf("---server_len=%d---\n",server_len);
	server_len = offsetof(struct sockaddr_un, sun_path) + strlen((char *)SERVER_NAME);
	printf("~~~server_len=%d---\n",server_len);
    bind(server_sockfd, (struct sockaddr *)&server_address, server_len);

/*  Create a connection queue and wait for clients.  */

    listen(server_sockfd, 5);
    while(1) 
	{
        char ch;

        printf("server waiting\n");

/*  Accept a connection.  */

        client_len = sizeof(client_address);
        client_sockfd = accept(server_sockfd, 
            (struct sockaddr *)&client_address, &client_len);

/*  We can now read/write to client on client_sockfd.  */

        read(client_sockfd, &ch, 1);
        ch++;
		sleep(1);
        write(client_sockfd, &ch, 1);
        close(client_sockfd);
    }
}

