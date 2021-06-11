#include <memory.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <asm/io.h>
#include <time.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <stdarg.h>
#include <sys/types.h>
#include<pthread.h>

#define datalen 15
unsigned char wdata[2][datalen] = {
																		{'1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'}
																		,{'F', 'E', 'D', 'C', 'B', 'A', '9', '8', '7', '6', '5', '4', '3', '2', '1'}
																	};
unsigned char rdata[datalen];

int mac_port = -1;
char *vrts;


int open_data_port(char * port, int baud, int checkpar)
{
 int fd;
 struct termios oldtio, newtio;

 /* Open device for reading and writing and not as controlling tty
    because we don't want to get killed if linenoise sends CTRL-C.
 */

 fd = open(port, O_RDWR|O_NOCTTY|O_NONBLOCK);
 if (fd<0)
 { 
	perror(port); 
	return -1; 
 }

 tcgetattr(fd, &oldtio); /* save current serial port settings */
 memset(&newtio, 0, sizeof(struct termios) ); /* clear struct for new port settings */

 /*
 BAUDRATE: Set bps rate. You could also use cfsetispeed and cfsetospeed.
 CRTSCTS: output hardware flow control (only used if the cable has
	all necessary lines. See sect.7 of Serial-HOWTO)
 CS8	: 8n1(8bit, no parity, 1 stopbit)
 CLOCAL	: local connection, no modem control
 CREAD	: enable receiving characters 
 */

 //newtio.c_cflag = baud | CRTSCTS | CS8 | CLOCAL | CREAD;
 newtio.c_cflag = baud | CS8 | CLOCAL | CREAD;
 if ( checkpar == 2 )
 	newtio.c_cflag |= PARENB;
 if ( checkpar == 1 )
 	newtio.c_cflag |= PARODD;

 /* IGNPAR: ignore byte with parity errors 
    ICRNL	: map CR to NL (otherwise a CR input on the other computer
		will not terminate input )
		otherwise make device raw (no other input processing )
 */
 //	newtio.c_iflag = IGNPAR | ICRNL;
 newtio.c_iflag = IGNPAR;

 /* Raw output */
 newtio.c_oflag = 0;

 /*
 ICANON	: enable canonical input
	disable all echo functionality, and don't send signal to calling
	program
 */

 //newtio.c_lflag = ICANON | ECHO;
 // non-canonical, no echo
 newtio.c_lflag = 0;

 /* initialize all control characters
    default values can be found in /usr/include/termios.h, and are given
    in the comments, but we don't need them here
 */

 newtio.c_cc[VTIME]= 0;
 newtio.c_cc[VMIN]= 1;

 /* now clean the modem line and activate the settings for the port
 */
 tcflush(fd, TCIFLUSH);
 tcsetattr(fd, TCSANOW, &newtio);

 return fd;
}

int open_mac_port(char * port, int baud)
{
	int fd;

	struct termios oldtio, newtio;
	/* Open device for reading and writing and not as controlling tty
	because we don't want to get killed if linenoise sends CTRL-C.
	*/
	fd = open(port, O_RDWR|O_NOCTTY|O_NONBLOCK);
	if (fd<0) { 
		perror(port); 
		return -1; 
	}
	tcgetattr(fd, &oldtio); /* save current serial port settings */

	memset(&newtio, 0, sizeof(struct termios) ); /* clear struct for new port settings */


	/*
	BAUDRATE: Set bps rate. You could also use cfsetispeed and cfsetospeed.
	CRTSCTS: output hardware flow control (only used if the cable has
		all necessary lines. See sect.7 of Serial-HOWTO)
	CS8	: 8n1(8bit, no parity, 1 stopbit)
	CLOCAL	: local connection, no modem control
	CREAD	: enable receiving characters 
	*/
//	newtio.c_cflag = baud | CRTSCTS | CS8 | CLOCAL | CREAD;
	newtio.c_cflag = baud | CS8 | CLOCAL | CREAD;

	/* IGNPAR: ignore byte with parity errors 
	ICRNL	: map CR to NL (otherwise a CR input on the other computer
		will not terminate input )
		otherwise make device raw (no other input processing )
	*/
	newtio.c_iflag = IGNPAR | ICRNL;

//	newtio.c_iflag = ICRNL;

	/* Raw output */
	newtio.c_oflag = 0;

	/*

ICANON	: enable canonical input
		disable all echo functionality, and don't send signal to calling
		program
	*/

	newtio.c_lflag = ICANON | ECHO;

	/* initialize all control characters
	   default values can be found in /usr/include/termios.h, and are given
	   in the comments, but we don't need them here
	*/
	   newtio.c_cc[VINTR] 	= 0;
	   newtio.c_cc[VQUIT] 	= 0;
	   newtio.c_cc[VERASE] 	= 0;
	   newtio.c_cc[VKILL] 	= 0;
	   newtio.c_cc[VEOF] 	= 4;
	   newtio.c_cc[VTIME] 	= 0;
	   newtio.c_cc[VMIN] 	= 1;
	   newtio.c_cc[VSWTC] 	= 0;
	   newtio.c_cc[VSTART] 	= 0;
	   newtio.c_cc[VSTOP] 	= 0;
	   newtio.c_cc[VSUSP] 	= 0;
	   newtio.c_cc[VEOL] 	= 0;
	   newtio.c_cc[VREPRINT] 	= 0;
	   newtio.c_cc[VDISCARD] 	= 0;
	   newtio.c_cc[VWERASE] 	= 0;
	   newtio.c_cc[VLNEXT]	 	= 0;
	   newtio.c_cc[VEOL2]	 	= 0;

	   /* now clean the modem line and activate the settings for the port
	   */
	   tcflush(fd, TCIFLUSH);
	   tcsetattr(fd, TCSANOW, &newtio);
	return fd;
}

int main(int argc, char *argv[])
{
	int getval, wlen, rlen, i, ret = -1;
	char rts[2] = " ";
	char tx[4] = "   ";
	char dev1[12] = "           ";
	char sendidx[2] = " ";
	
	if(argc <= 4)
	{
		printf("Command line error, please enter: program config_file\n");
    		return 0;
  	}
  	sprintf (dev1, "%s", argv[1]);
//  	sprintf (rts, "%s", argv[2]);
//  	sprintf (tx, "%s", argv[3]);
//  	sprintf (sendidx, "%s", argv[4]);


	vrts=(char *)TIOCM_RTS;
	
	mac_port = open_data_port(dev1, B38400, 0);

	if (mac_port < 0)
	{
		printf("[MAC] Cannot open Led1 at %s, programe terminated.\n", dev1);
		return 0;
	}

	printf("[MAC] %s: set RTS to %s, set TX send %s\n", dev1, rts, tx);
	
	
	if(!strcmp(rts, "1"))
		ret = ioctl(mac_port, TIOCMBIC, &vrts);
	if(!strcmp(rts, "0"))
		ret = ioctl(mac_port, TIOCMBIS, &vrts);
	if(ret<0)
		printf("[MAC] set rts errot!\n");

	while(1)
	{
		if(!strcmp(tx, "on"))
		{
				if(!strcmp(sendidx, "1"))
					wlen = write(mac_port, "123456789ABCDEF", datalen);
				if(!strcmp(sendidx, "2"))
					wlen = write(mac_port, "FEDCBA987654321", datalen);
				if(wlen != datalen)   
					printf("[MAC] TX write data error!  %d\n", wlen);
				else
					printf("[MAC] TX write data OK!\n");
		}
		else
			printf("[MAC] TX doesn't write\n");		
			
		if((rlen = read(mac_port, rdata, datalen))>0)
		{
			printf("[MAC] read context is: ");
			for(i=0;i<datalen;i++)   
				printf("%c ",rdata[i]);
			printf("\n");
		}
		else
			printf("[MAC] no receive!\n");

		
		ret = ioctl(mac_port, TIOCMGET, &getval);
		if(ret<0)
			printf("[MAC] get %s status is fault\n", dev1);
		else
		{		
			printf("[MAC] in %s: RTS is %d     ", dev1, getval & TIOCM_RTS? 0: 1);
			printf("CTS is %d     ", getval & TIOCM_CTS? 0: 1);
			printf("TX is %d\n", getval & TIOCM_ST? 0: 1);
		}
		usleep(1000000);	  	
	}
	

	close(mac_port);
	return 0;
}
