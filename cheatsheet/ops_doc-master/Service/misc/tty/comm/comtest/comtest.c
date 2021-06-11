/*************************************************************************
	> File Name: comtest.c
	> Author: suchao.wang
	> Mail: suchao.wang@advantech.com.cn 
	> Created Time: Sun 12 Jun 2016 02:33:26 PM CST
 ************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <termios.h>
#include <errno.h>
#include <semaphore.h>
#include <pthread.h>
#include <string.h>
#include <time.h>
#include <stdarg.h>
#include <syslog.h>
#include <signal.h>
#include <sys/ioctl.h>
#include <linux/serial.h>

struct BaudRate
{
	int speed;
	int bitmap;
};
struct BaudRate baudlist[] =
{
//{ 50, B50 },
//{ 75, B75 },
//{ 110, B110 },
//{ 134, B134 },
//{ 150, B150 },
//{ 200, B200 },
//{ 300, B300 },
//{ 600, B600 },
		{ 1200, B1200 },
		{ 1800, B1800 },
		{ 2400, B2400 },
		{ 4800, B4800 },
		{ 9600, B9600 },
		{ 19200, B19200 },
		{ 38400, B38400 },
		{ 57600, B57600 },
		{ 115200, B115200 },
		{ 230400, B230400 },
		{ 460800, B460800 },
		{ 500000, B500000 },
		{ 576000, B576000 },
		{ 921600, B921600 },
//{ 1000000, B1000000 },
//{ 1152000, B1152000 },
//{ 1500000, B1500000 },
//{ 2000000, B2000000 },
//{ 2500000, B2500000 },
//{ 3000000, B3000000 },
//{ 3500000, B3500000 },
//{ 4000000, B4000000 },
		};
int comDatabits[] =
{ 5, 6, 7, 8 };
int comStopbits[] =
{ 1, 2 };
int comParity[] =
{ 'n', 'o', 'e' };

int set_com(int fd, int speed, int databits, int stopbits, int parity)
{
	int i;
	struct termios opt;

	if (tcgetattr(fd, &opt) != 0)
	{
		perror("get attr failed!\n");
		return -1;
	}

	for (i = 0; i < sizeof(baudlist) / sizeof(baudlist[0]); i++)
	{
		struct BaudRate *rate = &baudlist[i];
		if (speed == rate->speed)
		{
			cfsetispeed(&opt, rate->bitmap);
			cfsetospeed(&opt, rate->bitmap);
			break;
		}
	}
//	//修改控制模式，保证程序不会占用串口
//	opt.c_cflag |= CLOCAL;
//	//修改控制模式，使得能够从串口中读取输入数据
//	opt.c_cflag |= CREAD;

	opt.c_cflag &= ~CSIZE;
	switch (databits)
	{
	case 5:
		opt.c_cflag |= CS5;
		break;
	case 6:
		opt.c_cflag |= CS6;
		break;
	case 7:
		opt.c_cflag |= CS7;
		break;
	case 8:
		opt.c_cflag |= CS8;
		break;
	default:
		printf("Unsupported data size\n");
		return -1;
	}

	switch (parity)
	{
	case 'n':
	case 'N':
		opt.c_cflag &= ~PARENB;
		opt.c_iflag &= ~INPCK;
		break;
	case 'o':
	case 'O':
		opt.c_cflag |= (PARODD | PARENB);
		opt.c_iflag |= INPCK;
		break;
	case 'e':
	case 'E':
		opt.c_cflag |= PARENB;
		opt.c_cflag &= ~PARODD;
		opt.c_iflag |= INPCK;
		break;
	default:
		printf("Unsupported parity\n");
		return -1;
	}

	switch (stopbits)
	{
	case 1:
		opt.c_cflag &= ~CSTOPB;
		break;
	case 2:
		opt.c_cflag |= CSTOPB;
		break;
	default:
		printf("Unsupported stop bits\n");
		return -1;
	}

	opt.c_iflag &= ~(IXON | IXOFF | IXANY | BRKINT | ICRNL | INPCK | ISTRIP);
	opt.c_lflag &= ~(ICANON | ECHO | ECHOE | IEXTEN | ISIG);
	opt.c_oflag &= ~OPOST;
	opt.c_cc[VTIME] = 10;
	opt.c_cc[VMIN] = 0;

	tcflush(fd, TCIOFLUSH);
	if (tcsetattr(fd, TCSANOW, &opt) != 0)
	{
		perror("set attr failed!\n");
		return -1;
	}
	return 0;
}


static int real_config_fd (int fd)
{
    struct termios stbuf;
    int speed;
    int bits;
    int parity;
    int stopbits;


    memset (&stbuf, 0, sizeof (struct termios));
    if (tcgetattr (fd, &stbuf) != 0) {
        perror("tcgetattr");
    }

    stbuf.c_iflag &= ~(IGNCR | ICRNL | IUCLC | INPCK | IXON | IXANY | IGNPAR );
    stbuf.c_oflag &= ~(OPOST | OLCUC | OCRNL | ONLCR | ONLRET);
    stbuf.c_lflag &= ~(ICANON | XCASE | ECHO | ECHOE | ECHONL);
    stbuf.c_lflag &= ~(ECHO | ECHOE);
    stbuf.c_cc[VMIN] = 1;
    stbuf.c_cc[VTIME] = 0;
    stbuf.c_cc[VEOF] = 1;

    /* Use software handshaking */
    stbuf.c_iflag |= (IXON | IXOFF | IXANY);

    /* Set up port speed and serial attributes; also ignore modem control
     * lines since most drivers don't implement RTS/CTS anyway.
     */
    stbuf.c_cflag &= ~(CBAUD | CSIZE | CSTOPB | PARENB | CRTSCTS);
//    stbuf.c_cflag |= (speed | bits | CREAD | 0 | parity | stopbits | CLOCAL);
    stbuf.c_cflag |= (CS8 | CS8 | CREAD | 0 | 0 | 0 | CLOCAL);

    if (tcsetattr (fd, TCSANOW, &stbuf) < 0) {
        return 0;
    }

    return 1;
}


int mm_serial_port_open ()
{
    char *devfile = "/dev/ttyAP0";
//    const char *device;
    struct serial_struct sinfo;
    struct termios old_t;

    printf ("(%s) opening serial port...", devfile);


    /* Only open a new file descriptor if we weren't given one already */
        int fd = open (devfile, O_RDWR | O_EXCL | O_NONBLOCK | O_NOCTTY);

    if (fd < 0) {
        perror(devfile);
        return 0;
    }

    if (ioctl (fd, TIOCEXCL) < 0) {
        perror ("Could not lock serial device %s: %s");
        goto error;
    }

    /* Flush any waiting IO */
    tcflush (fd, TCIOFLUSH);

    if (tcgetattr (fd, &old_t) < 0) {
        perror ("Could not open serial device %s: %s");
        goto error;
    }

    /* Don't wait for pending data when closing the port; this can cause some
     * stupid devices that don't respond to URBs on a particular port to hang
     * for 30 seconds when probin fails.
     */
    if (ioctl (fd, TIOCGSERIAL, &sinfo) == 0) {
    	sinfo.closing_wait = ASYNC_CLOSING_WAIT_NONE;
        ioctl (fd, TIOCSSERIAL, &sinfo);
    }

    set_com(fd,115200,8,1,'n');
    while(1)
    {
    	int i = 0;
    	char buf[32];
    	for(i = 0;i<256;i++)
    	{
    		buf[0]=i;
    		write(fd,buf,1);
    		usleep(100*1000);
    	}
    }


error:
    close (fd);
    fd = -1;
    return 0;
}

int main()
{
	daemon(0,0);
	mm_serial_port_open();
	return 0;
}
