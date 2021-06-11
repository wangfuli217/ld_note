// #############################################################################
// *****************************************************************************
//                  Copyright (c) 2014, Advantech Automation Corp.
//      THIS IS AN UNPUBLISHED WORK CONTAINING CONFIDENTIAL AND PROPRIETARY
//               INFORMATION WHICH IS THE PROPERTY OF ADVANTECH AUTOMATION CORP.
//
//    ANY DISCLOSURE, USE, OR REPRODUCTION, WITHOUT WRITTEN AUTHORIZATION FROM
//               ADVANTECH AUTOMATION CORP., IS STRICTLY PROHIBITED.
// *****************************************************************************
// #############################################################################
//
// File:   	 main.c
// Author:  suchao.wang
// Created: Nov 5, 2014
//
// Description:  File download process class.
// ----------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////
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

struct BaudRate{
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
char g_comDevicesName[256][256];
int g_comNums;

void LOG(const char* ms, ... )
{
	char wzLog[1024] = {0};
	char buffer[1024] = {0};
	va_list args;
	va_start(args, ms);
	vsprintf( wzLog ,ms,args);
	va_end(args);

	time_t now;
	time(&now);
	struct tm *local;
	local = localtime(&now);
	printf("%04d-%02d-%02d %02d:%02d:%02d %s\n", local->tm_year+1900, local->tm_mon,
			local->tm_mday, local->tm_hour, local->tm_min, local->tm_sec,
			wzLog);
	sprintf(buffer,"%04d-%02d-%02d %02d:%02d:%02d %s\n", local->tm_year+1900, local->tm_mon,
				local->tm_mday, local->tm_hour, local->tm_min, local->tm_sec,
				wzLog);
	FILE* file = fopen("testResut.log","a+");
	fwrite(buffer,1,strlen(buffer),file);
	fclose(file);

//	syslog(LOG_INFO,wzLog);
	return ;
}


int set_com(int fd,int speed,int databits,int stopbits,int parity)
{
	int i;
	struct termios opt;

	if( tcgetattr(fd ,&opt) != 0)
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

	switch(parity)
	{
		case 'n':
		case 'N':
			opt.c_cflag &= ~PARENB;
			opt.c_iflag &= ~INPCK;
			break;
		case 'o':
		case 'O':
			opt.c_cflag |= (PARODD|PARENB);
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

	switch(stopbits)
	{
		case 1:
			opt.c_cflag &= ~CSTOPB;
			break;
		case 2:
			opt.c_cflag |=  CSTOPB;
			break;
		default:
			printf("Unsupported stop bits\n");
			return -1;
	}

	opt.c_iflag &= ~(IXON | IXOFF | IXANY | BRKINT | ICRNL | INPCK | ISTRIP);
	opt.c_lflag &=  ~(ICANON | ECHO | ECHOE | IEXTEN | ISIG);
	opt.c_oflag &= ~OPOST;
	opt.c_cc[VTIME] = 100;
	opt.c_cc[VMIN] = 0;

	tcflush(fd, TCIOFLUSH);
	if (tcsetattr(fd, TCSANOW, &opt) != 0)
	{
		perror("set attr failed!\n");
		return -1;
	}
	return 0;
}

int OpenDev(char* Dev)
{
	int fd = open(Dev,O_RDWR | O_NOCTTY );
	if( -1 == fd)
	{
		perror("open failed!\n");
		return -1;
	}
	else
		return fd;
}

int openDevice(const char* Dev,int speed,int databits,int stopbits,int parity)
{
	int fd;
	fd = open(Dev, O_RDWR | O_NOCTTY);
	if (-1 == fd)
	{
		perror("open failed!\n");
		return -1;
	}

	if (set_com(fd, speed, databits, stopbits, parity) != 0)
	{
		printf("Set Com Error\n");
		return -1;
	}

	return fd;
}

int pairTest(char * coma,char * comb,int speed,int databits,int stopbits,int parity)
{
	char MSG[] = {1,2,3,4,5,6,7,8,9,0};
	int ret;
	char buf[256];
	char result[256];
	int fd1,fd2;
	int idx;
//	time_t old,new;
//	old = time(NULL);


	fd1 = openDevice(coma, speed, databits, stopbits, parity);
	if (fd1 <= 0)
	{
		printf("open device %s failed!\n", coma);
		exit(1);
	}

	fd2 = openDevice(comb, speed, databits, stopbits, parity);
	if (fd2 <= 0)
	{
		printf("open device %s failed!\n", comb);
		exit(1);
	}

	write(fd1,MSG,sizeof(MSG));
//	usleep(1000000/speed*(4+databits)*sizeof(MSG)*2);

	memset(buf, 0, sizeof(buf));
	idx = 0;
	ret = read(fd2, buf, sizeof(MSG));
	idx += ret;
	if(strncmp(MSG,buf,sizeof(MSG)) != 0){
		sprintf(result," fail");
		LOG("test %s to %s %d %d %d %c %s",coma,comb, speed, databits, stopbits, parity,result);
	}else{
		sprintf(result," OK");
	}

	close(fd1);
	close(fd2);
	printf("test %s to %s %d %d %d %c %s\n",coma,comb, speed, databits, stopbits, parity,result);


	return 0;
}

int speedTest(char * coma,char * comb)
{
	int speedIdx, wordIdx, stopIdx, parityIdx;
	time_t old, new;

	old = time(NULL);
	for (speedIdx = 0; speedIdx < sizeof(baudlist) / sizeof(baudlist[0]);
			speedIdx++)
	{
		for (wordIdx = 0;
				wordIdx < sizeof(comDatabits) / sizeof(comDatabits[0]);
				wordIdx++)
		{
			for (stopIdx = 0;
					stopIdx < sizeof(comStopbits) / sizeof(comStopbits[0]);
					stopIdx++)
			{
				for (parityIdx = 0;
						parityIdx < sizeof(comParity) / sizeof(comParity[0]);
						parityIdx++)
				{
					struct BaudRate *rate = &baudlist[speedIdx];
					pairTest(coma, comb, rate->speed, comDatabits[wordIdx],
							comStopbits[stopIdx], comParity[parityIdx]);
					pairTest(comb, coma, rate->speed, comDatabits[wordIdx],
							comStopbits[stopIdx], comParity[parityIdx]);
				}
			}

		}

	}
	new = time(NULL);
	printf("speedtest %s and %s cost %5ld seconds\n",coma,comb, new - old);
	LOG("speedtest %s and %s cost %5ld seconds",coma,comb, new - old);

	return 0;
}

#define FILE_SPEED 		115200
#define FILE_DATABITS 	8
#define FILE_STOPBITS 	1
#define FILE_PARITY 	'n'
#define FILE_BLOCK		512
pthread_t	m_hThread;
sem_t m_hEvent;
struct comData{
	int comFd;
	FILE* fileFd;
	int fileLength;
};
void* ComReadThread( void* arg )
{
	struct comData *data = (struct comData*)arg;
	char buff[FILE_BLOCK*2];
	int idx;
	for(idx = 0;idx <data->fileLength;)
	{
		printf("read idx=%d\n",idx);
		memset(buff,0,sizeof(buff));
		int readn =read(data->comFd,buff,FILE_BLOCK*2);
		if(readn >0)
		{
			fwrite(buff,1,readn,data->fileFd);
			idx += readn;
		}else{
			break;
		}
	}
	printf("read end idx=%d\n",idx);
	return NULL;
}
int fileTest(char * coma,char * comb,const char *filename)
{
	if (access(filename, F_OK))
		return -1;
	char buf[FILE_BLOCK];
	char fileRecvName[256];
	int fd1, fd2;
	FILE * fileSend,*fileRecv;
	time_t old,new;

	fd1 = openDevice(coma, FILE_SPEED, FILE_DATABITS, FILE_STOPBITS,
			FILE_PARITY);
	if (fd1 <= 0)
	{
		printf("open device %s failed!\n", coma);
		exit(1);
	}

	fd2 = openDevice(comb, FILE_SPEED, FILE_DATABITS, FILE_STOPBITS,
			FILE_PARITY);
	if (fd2 <= 0)
	{
		printf("open device %s failed!\n", comb);
		exit(1);
	}

	sprintf(fileRecvName,"%s.recv",filename);
	if(!access(fileRecvName,F_OK))
		remove(fileRecvName);
	fileSend = fopen(filename,"rb");
	fileRecv = fopen(fileRecvName,"wb");

	fseek(fileSend, 0, SEEK_END);
	int sendLen = ftell(fileSend);
	rewind(fileSend);

	struct comData data;
	data.comFd = fd2;
	data.fileFd = fileRecv;
	data.fileLength = sendLen;
	if (sem_init(&m_hEvent, 0, 1) == -1)
			return -1;
	int error = pthread_create(&m_hThread, NULL, ComReadThread,
			(void*) &data);
	if( error)
	{
		printf("pthread create failed!\n");
		return -1;
	}

	old = time(NULL);
	int idx;
	for(idx = 0;idx<sendLen;)
	{
		memset(buf,0,sizeof(buf));
		int readn =	fread(buf,1,FILE_BLOCK,fileSend);
		if(readn >0)
		{
			write(fd1,buf,readn);
			idx += readn;
		}

	}

	printf("send end idx=%d\n",idx);
	pthread_join(m_hThread, NULL);
	new = time(NULL);
	long cost = new - old;
	float rate = 0;
	if(cost > 1)
		rate = 1.0*idx/cost;
	else
		rate = idx;
	LOG("send file %s from %s to %s cost %5ld seconds,%10.2lf bytes per second",filename,coma,comb,cost,rate);
	fclose(fileSend);
	fclose(fileRecv);
	close(fd1);
	close(fd2);


	FILE *procpt;
	char line[100];
	char command[100];
	sprintf(command,"diff %s %s",filename,fileRecvName);

	procpt = popen(command, "r");

	if (fgets(line, sizeof(line), procpt) == NULL)
	{
		LOG("file %s and %s are the same", filename, fileRecvName);
	}
	else
	{
		LOG("%s", line);
	}

	pclose(procpt);
	return 0;
}
int selfTest(char * coma,const char *filename)
{
	if (access(filename, F_OK))
		return -1;
	char buf[FILE_BLOCK];
	char fileRecvName[256];
	int fd1;
	FILE * fileSend,*fileRecv;
	time_t old,new;

	fd1 = openDevice(coma, FILE_SPEED, FILE_DATABITS, FILE_STOPBITS,
			FILE_PARITY);
	if (fd1 <= 0)
	{
		printf("open device %s failed!\n", coma);
		exit(1);
	}

	sprintf(fileRecvName,"%s.recv",filename);
	if(!access(fileRecvName,F_OK))
		remove(fileRecvName);
	fileSend = fopen(filename,"rb");
	fileRecv = fopen(fileRecvName,"wb");

	fseek(fileSend, 0, SEEK_END);
	int sendLen = ftell(fileSend);
	rewind(fileSend);

	struct comData data;
	data.comFd = fd1;
	data.fileFd = fileRecv;
	data.fileLength = sendLen;
	if (sem_init(&m_hEvent, 0, 0) == -1)
			return -1;
	int error = pthread_create(&m_hThread, NULL, ComReadThread,
			(void*) &data);
	if( error)
	{
		printf("pthread create failed!\n");
		return -1;
	}

	old = time(NULL);
	int idx;
	for(idx = 0;idx<sendLen;)
	{
		memset(buf,0,sizeof(buf));
		int readn =	fread(buf,1,FILE_BLOCK,fileSend);
		if(readn >0)
		{
			write(fd1,buf,readn);
			idx += readn;
			usleep(1000.0*100/FILE_SPEED*readn);
		}

	}

	printf("send end idx=%d\n",idx);
	pthread_join(m_hThread, NULL);
	new = time(NULL);
	long cost = new - old;
	float rate = 0;
	if(cost > 1)
		rate = 1.0*idx/cost;
	else
		rate = idx;
	LOG("send file %s use %s cost %5ld seconds,%10.2lf bytes per second",filename,coma,cost,rate);
	fclose(fileSend);
	fclose(fileRecv);
	close(fd1);


	FILE *procpt;
	char line[100];
	char command[100];
	sprintf(command,"diff %s %s",filename,fileRecvName);

	procpt = popen(command, "r");

	if (fgets(line, sizeof(line), procpt) == NULL)
	{
		LOG("file %s and %s are the same", filename, fileRecvName);
	}
	else
	{
		LOG("%s", line);
	}

	pclose(procpt);
	return 0;
}
#define ALLMSG "hello body,welcom to Advantech!"
int allSend(int elapse)
{
	int fd[256];
	int fdNums = 0;
	int i;
	for(i =0;i<g_comNums;i++)
	{
		fd[fdNums] = openDevice(g_comDevicesName[i], FILE_SPEED, FILE_DATABITS, FILE_STOPBITS,
				FILE_PARITY);
		if (fd[fdNums] <= 0)
		{
			printf("open device %s failed!\n", g_comDevicesName[i]);
		}
		fdNums++;
	}

	for(;;)
	{
		for (i = 0; i < fdNums; i++)
		{
			write(fd[i],ALLMSG,strlen(ALLMSG));
		}
		usleep(elapse*1000);
	}


	return 0;
}
int listDevice()
{
	char buf[256];
	char linkName[256];
	int i;
	int fd;
	g_comNums = 0;

	printf("\nlist all devices:\n");
	for(i =0 ;i< 256;i++)
	{
		sprintf(buf, "/dev/ttyS%d", i);
		fd = open(buf, O_RDWR | O_NOCTTY);
		if (-1 == fd)
		{
			continue;
		}
		struct termios opt;
		if( tcgetattr(fd ,&opt) != 0)
		{
			continue;
		}
		memset(linkName,0,sizeof(linkName));
		int linkSize = readlink(buf,linkName,sizeof(linkName));
		printf("%s %s %s\n",buf,(linkSize > 0)?" ->":"",linkName);
		if(linkSize == -1)
		{
			memset(g_comDevicesName[g_comNums],0,sizeof(g_comDevicesName[g_comNums]));
			memcpy(g_comDevicesName[g_comNums],buf,sizeof(buf));
			g_comNums++;

		}

	}
	for (i = 0; i < 256; i++)
	{
		sprintf(buf, "/dev/ttyAP%d", i);
		fd = open(buf, O_RDWR | O_NOCTTY);
		if (-1 == fd)
		{
			continue;
		}
		struct termios opt;
		if (tcgetattr(fd, &opt) != 0)
		{
			continue;
		}
		memset(linkName, 0, sizeof(linkName));
		int linkSize = readlink(buf, linkName, sizeof(linkName));
		printf("%s %s %s\n",buf,(linkSize > 0)?" ->":" ",linkName);
		if (linkSize == -1)
		{
			memset(g_comDevicesName[g_comNums], 0,
					sizeof(g_comDevicesName[g_comNums]));
			memcpy(g_comDevicesName[g_comNums], buf, sizeof(buf));
			g_comNums++;

		}
	}

	printf("\ndevices Index list:\n");
	for(i= 0;i<g_comNums;i++)
	{
		printf("idx[%3d]:%s\n",i,g_comDevicesName[i]);
	}
	return 0;
}

#define APP_NAME "AdvComTest"

#ifndef VERSION_NUMBER
#define VERSION_NUMBER					"1.0.0"
#endif

static void print_app_usage ( void )
{
	printf( "usage: %s [OPTIONS]\n", APP_NAME );
	printf( "\n" );
	printf( "Valid options:\n" );
	printf( "  -l                        : list the com device\n" );
	printf( "  -allsend  ms            : all coms send message every 1000 ms \n" );
	printf( "  -speedtest coma comb     : traversal test speed ,databits,stopbits,parity\n" );
	printf( "  -selftest coma filename     : send file\n" );
	printf( "  -filetest comaIdx combIdx filename    : send file from coma to comb with\n" );
	printf( "                                     speed %d ,%d,%d,%c \n"
				,FILE_SPEED,FILE_DATABITS,FILE_STOPBITS,FILE_PARITY );
	printf( "  example1: ./AdvComTest -speedtest /dev/ttyS0 /dev/ttyS1 \n" );
	printf( "  example2: ./AdvComTest -filetest /dev/ttyS0 /dev/ttyS1 testfile \n" );

}

static void print_app_version ( void )
{
#ifdef REVISION_NUMBER
	printf( "%s %s rev %s\n", APP_NAME, VERSION_NUMBER, REVISION_NUMBER );
#else
	printf( "%s %s build %s %s\n", APP_NAME,VERSION_NUMBER, __DATE__,__TIME__ );
#endif
}

int main(int argc, char *argv[] )
{
	print_app_version();

	if(argc > 1)
	{
		listDevice();
		if(strcmp(argv[1], "-speedtest") == 0)
		{
			if( argc < 4)
			{
				print_app_usage();
				return 0;
			}
			speedTest(argv[2],argv[3]);
			return 0;
		}else if(strcmp(argv[1], "-filetest") == 0)
		{
			if( argc < 5)
			{
				print_app_usage();
				return 0;
			}
			fileTest(argv[2],argv[3],argv[4]);
			return 0;
		}else if(strcmp(argv[1], "-l") == 0)
		{
			listDevice();
			return 0;
		}else if(strcmp(argv[1], "-allsend") == 0)
		{
			int elapse = 1000;
			if(argc > 2)
				elapse = strtoul(argv[2],NULL,10);
			if(elapse < 100)
				elapse = 1000;
			allSend(elapse);
			return 0;
		}else if(strcmp(argv[1], "-selftest") == 0)
		{
			if( argc < 4)
			{
				print_app_usage();
				return 0;
			}
			selfTest(argv[2],argv[3]);
			return 0;
		}
	}else{
		print_app_usage();
		listDevice();
		return 0;
	}
	return 0;
}





