#include <stdio.h>  
#include <stdlib.h>  
#include <string.h>  
#include <fcntl.h>  
#include <unistd.h>  
#include <sys/time.h>  
#include <sys/types.h>  
#include <sys/stat.h>  
  
int main(int argc, char *argv[])  
{  
    fd_set rfds, wfds;  
    int fd0, fd1, fd2, fd3;  
    char buf[100];  
    int retval;      
  
    /* Wait up to ten seconds. */  
    struct timeval tv;  
    tv.tv_sec = 10;  
    tv.tv_usec = 0;  
  
    if(argc != 2 || ((strcmp(argv[1], "read") != 0) \
			&& (strcmp(argv[1], "write") != 0))) {  
        printf("usage: ./select_test read|write\n");  
        exit(-1);  
    }  
  
    fd0 = open("/dev/scullpipe0", O_RDWR);  
    if ( fd0 < 0) {  
        printf("open scullpipe0 error\n");  
        exit(-1);  
    }  
      
    fd1 = open("/dev/scullpipe1", O_RDWR);  
    if ( fd1 < 0) {  
        printf("open scullpipe1 error\n");  
        exit(-1);  
    }  
      
    fd2 = open("/dev/scullpipe2", O_RDWR);  
    if ( fd2 < 0) {  
        printf("open scullpipe2 error\n");  
        exit(-1);  
    }  
      
    fd3 = open("/dev/scullpipe3", O_RDWR);  
    if ( fd3 < 0) {  
        printf("open scullpipe3 error\n");  
        exit(-1);  
    }  
  
    if(strcmp(argv[1], "read") == 0) {  
        FD_ZERO(&rfds);  
        FD_SET(fd0, &rfds);  
        FD_SET(fd1, &rfds);  
        FD_SET(fd2, &rfds);  
        FD_SET(fd3, &rfds);  
        retval = select(fd3 + 1, &rfds, NULL, NULL, &tv);  
    } else {  
        FD_ZERO(&wfds);  
        FD_SET(fd0, &wfds);  
        FD_SET(fd1, &wfds);  
        FD_SET(fd2, &wfds);  
        FD_SET(fd3, &wfds);  
        retval = select(fd3 + 1, NULL, &wfds, NULL, &tv);  
    }  

	if (retval == -1) {  
		printf("select error!\n");  
		exit(-1);  
	}  
	else if (retval) {  
		if(strcmp(argv[1], "read") == 0) {  
			if(FD_ISSET(fd0, &rfds)) {  
				printf("/dev/scullpipe0 is readable!\n");  
				memset(buf, 0, 100);  
				read(fd0, buf, 100);  
				printf("%s\n", buf);  
			}  
  
			if(FD_ISSET(fd1, &rfds)) {  
				printf("/dev/scullpipe1 is readable!\n");  
				memset(buf, 0, 100);  
				read(fd1, buf, 100);  
				printf("%s\n", buf);  
			}  
  
			if(FD_ISSET(fd2, &rfds)) {  
				printf("/dev/scullpipe2 is readable!\n");  
				memset(buf, 0, 100);  
				read(fd2, buf, 100);  
				printf("%s\n", buf);  
			}  
  
			if(FD_ISSET(fd3, &rfds)) {  
				printf("/dev/scullpipe3 is readable!\n");  
				memset(buf, 0, 100);  
				read(fd3, buf, 100);  
				printf("%s\n", buf);  
			}  
		} else {  
			if(FD_ISSET(fd0, &wfds)) {  
				printf("/dev/scullpipe0 is writable!\n");  
			}  
  
			if(FD_ISSET(fd1, &wfds)) {  
				printf("/dev/scullpipe1 is writable!\n");  
			}  
  
			if(FD_ISSET(fd2, &wfds)) {  
				printf("/dev/scullpipe2 is writable!\n");  
			}  
  
			if(FD_ISSET(fd3, &wfds)) {  
				printf("/dev/scullpipe3 is writable!\n");  
			}  
		}  
	} else { 
		if(strcmp(argv[1], "read") == 0) {  
			printf("No data within ten seconds.\n");  
		} else {  
			printf("Can not write within ten seconds.\n");  
		}  
	}  

    exit(0);  
}  