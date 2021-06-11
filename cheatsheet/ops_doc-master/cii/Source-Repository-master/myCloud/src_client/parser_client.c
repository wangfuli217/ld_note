#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <malloc.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <sys/types.h>
#include "protocol.h"
#include "parser_client.h"
#include "debug.h"
#include <dirent.h>

/* Convert string to a string array */
static int str2strarr( char* strArr[], int * argc, char * str){
	int len = 0; 
	while(1){
		while(' ' == *str)
		{
			str++;
		}
		*strArr++=str;
		while(1){
			str++;
			if(' '==*str||'\n'==*str){
				*str='\0';
				str++;
				len++;
				break;
			}else if('\0'==*str){
				len++;
				break;
			}
		}
		if('\0'==*str)
			break;
	}
	*argc = len;
}

// get filesize
static unsigned long get_file_size(const char *path)    
{    
	unsigned long filesize = -1;        
	struct stat statbuff;    
	if(stat(path, &statbuff) < 0)
	{    
		return filesize;    
	}
	else
	{    
		filesize = statbuff.st_size;    
	}    
	return filesize;    
}
static int get_files(const char * path, struct file *pfile[], int* len)    
{   

	DIR * dir = opendir("./");
	if(NULL == dir)
	{
		perror("open dir ");
		return -1;
	}
	int cnt  = 0;
	struct dirent * ent = readdir(dir);
	while(NULL  != ent)
	{
		strcpy(pfile[cnt]->fileName,  ent->d_name);
		pfile[cnt]->fileSize = get_file_size(pfile[cnt]->fileName);
		cnt++;
		ent = readdir(dir);
	}
	*len = cnt;
	return 0;
}     
void  print_helpinfo(void )
{
	printf("\n");
	printf("-> signup     <usrname> <passwd>\n");
	printf("-> login      <usrname> <passwd>\n");
	printf("-> download   <filename> \n");
	printf("-> upload     <filename>\n");
	printf("-> list       list files on the server\n");
	printf("-> ls         list local  files\n");
	printf("-> quit \n");
	printf("-> help\n");
}
int parse_cmdline( char cmdline[100],datainfo_t* pdata, pack_t * head)
{

	
	char * argv[100] = {NULL};
	int argc = 0;
	str2strarr(argv, &argc, cmdline);
	deprint("%s\n", argv[0]);
	if(0 == strncmp("signup", argv[0], 6) )//signup
	{	
		if(argc < 3)
		{ 	
			printf("para too few!\n");
			return -1;
		}
	   deprint("enter signup\n");	
	//	pdata->item_type  = USR_TYPE;
		strcpy(pdata->usr.name, argv[1]);
		strcpy(pdata->usr.passwd,  argv[2]);

	//	head->type = CHAT;
		head->cmd = SIGNUP;
		head->status = 0;
		head->len = sizeof(struct usr);

		return  SIGNUP;
	}
	else if(0 == strncmp("login", argv[0], 5) )//login
	{
		if( ONLINE== logflag)
		{
			printf("you have already login!\n");
			return -1;
		}
		if(argc < 3)
		{
			printf("para too few!\n");
			return -1;
		}

		strcpy(pdata->usr.name, argv[1]);
		strcpy(pdata->usr.passwd,  argv[2]);

		head->cmd = LOGIN;
		head->status = 0;
		head->len = sizeof(struct usr);

		return  SIGNUP;

	}
	else if(0 == strncmp("upload", argv[0], 6) )//upload
	{
		if( OFFLINE== logflag)
		{
			printf("please login first!\n");
			return -1;
		}
		if(argc < 2)
		{
			printf("para too few!\n");
		 	 return -1;
		}
		strcpy(pdata->file.fileName, argv[1]);
		char filepath[100] = {0};
		strcat(strcat(filepath, g_filedir), argv[1]);
		pdata->file.fileSize = get_file_size(filepath);
		deprint("==============filesize  :   %d  \n",pdata->file.fileSize );
		if(pdata->file.fileSize < 0)
		printf("filesize less than  0\n");


		head->cmd = UPLOAD;
		head->status = 0;
		head->len = sizeof(struct file);
		return  UPLOAD;
	}
	else if(0 == strncmp("download", argv[0], 8) )//download
	{
		if( OFFLINE== logflag)
		{
			printf("please login first!\n");
			return -1;
		}
		if(argc < 2)
		{
			printf("para too few!\n");
		 	 return -1;
		}

		strcpy(pdata->file.fileName, argv[1]);

		strcpy(g_filename, argv[1]);
		head->cmd = DOWNLOAD;
		head->status = 0;
		head->len = sizeof(struct file);

		return  DOWNLOAD;
	}
   else	if(0 == strncmp("list", argv[0], 4) )//list
	{
		if( OFFLINE== logflag)
		{
			printf("please login first!\n");
			return -1;
		}
		if(argc < 1)
		  return -1;
	
		head->cmd = LIST;
		head->status = 0;
		head->len = 0;
		return  LIST;
	}
   else if(0 == strncmp("sync", argv[0], 4))
   {
		if( OFFLINE== logflag)
		{
			printf("please login first!\n");
			return -1;
		}
	  // if()
   }
   else if(0 == strncmp("quit", argv[0], 4))
   {
		if( OFFLINE== logflag)
		{
			printf("please login first!\n");
			return -1;
		}
	   if(argc <1)
	   {
		   return -1;
	   }
	   head->cmd = QUIT;
	   head->status = 0;
	   head->len = 0;
	   return  QUIT;
   }
	else if(0 == strncmp("ls", argv[0], 2))
	{
		system("ls -l localfiles");
		return  -1;
	}
	else if(0 == strncmp("delete", argv[0], 6))
	{
		if( OFFLINE== logflag)
		{
			printf("please login first!\n");
			return -1;
		}
		if(argc < 2)
		{
			printf("para too few!\n");
		 	 return -1;
		}

		strcpy(pdata->file.fileName, argv[1]);

		strcpy(g_filename, argv[1]);
		head->cmd = DELETE;
		head->status = 0;
		head->len = sizeof(struct file);

		return  DELETE;
	}
	else if(0 == strncmp("rename", argv[0], 6))
	{
		if( OFFLINE== logflag)
		{
			printf("please login first!\n");
			return -1;
		}
		if(argc < 2)
		{
			printf("para too few!\n");
		 	 return -1;
		}
		strcpy(pdata->file.fileName, argv[1]);

		strcpy(g_filename,argv[2]);
	
		head->cmd =  RENAME;
		head->status = 0;
		head->len = 2*sizeof(struct file);

		return  RENAME;

	}
	else if(0 == strncmp("help", argv[0], 4))
	{
		print_helpinfo();
		return  0;
	}

	else  
		printf("unkonow cmd!\n");
	return -1;
}

static  void print_progress(unsigned long totalsize, int unit, int curunit)
{
	int i= 0;
	static int flag = 0;
	if(curunit != flag)
	{
		flag = curunit;
		printf("\r");
		printf("progress:   [");fflush(stdout);
		for(i= 0; i<curunit; i++)
		{
			printf("#");fflush(stdout);		
		}
		for(i=0; i< unit-curunit; i++)
			printf(" ");fflush(stdout);	
		printf("]");fflush(stdout);	
	}
}
int upload_pro(int sockfd,   struct file   * file, pack_t *head )
{

	if(FILE_EXIST == head->status)
	{
		printf("upload :  second transfer!\n");
		return 0;
	}
	else if (PREUPLOAD == head->status)
	{
		char filepath[100] = {0};
		strcat(	strcat(filepath, g_filedir ), file->fileName);
		unsigned long  filesize = get_file_size(filepath);
		FILE * fp  =  fopen(filepath,  "r");
		if(NULL == fp)
		{
			perror("fopen");
			return -1;
		}
		char buf[BUFSIZE] = {0};
		int ret = 0;

		deprint("begin  to transfer file......\n");
		unsigned long num = 0;
		unsigned long seqnum = 1;
		int unit = 50;
		int curunit = 0;
		unsigned long block = filesize/unit;
		while((ret =fread(buf, 1, BUFSIZE , fp)) >  0)
		{
			ret = send(sockfd,  buf, ret, 0);
			if(ret == -1)
			{
				perror("send");
				return -1;
			}
			num += ret;
			print_progress(filesize, unit, num/block);
		}
		fclose(fp);
		printf("\n");
		printf("send %lu bytes\n", num);
		return 0;

	}
	else
	{
		printf("upload:  unknow status!\n");
		return -1;
	}
	return 0;

}
int download_pro(int sockfd, struct file  * file, pack_t *head )
{
	if(head->status == NOSUCHFILE)
	{
		printf("download:  sorry, no such file!\n");
		return -1;
	}
	else if(head->status == PREDOWNLOAD)
	{
		char filepath[100] = {0};
		strcat(	strcat(filepath, g_filedir ), file->fileName);

		FILE * fp  =  fopen(filepath,  "w");
		if( NULL == fp)
		{
			syserr("open file");
		}
		deprint("%s\n", filepath);
		char buf[BUFSIZE] = {0};
		char sendbuf[BUFSIZE] = {0};
		unsigned long fileSize = file->fileSize;
		int ret = 0;
		int unit = 50;
		int curunit = 0;
		unsigned long block = fileSize/unit;

		 unsigned long  recivesize = 0;
	     unsigned long  seqnum = 1;
		while((ret = recv(sockfd, buf,BUFSIZE, 0)) >  0)
		{
			if (-1 == fwrite(buf, 1, ret, fp))
			{

				perror("fwrite");
				fclose(fp);
				return -1;
			}
			recivesize += ret;
			print_progress(fileSize, unit, recivesize/block);

			if ( fileSize == recivesize)
			{
				printf("\nrecive complete!\n");
				
				fclose(fp);
				return 0;
			}
		}
		printf("download not complete:  recive %lu  bytes\n ", recivesize);
	}
	else
	{
		printf("download:  unkonw status!\n");
		return -1;
	}
	return 0;
}



static  void signup_pro(int status)
{
	switch(status)
	{
	case SUCCESS: 
		printf("sign up sucess!\n");
		break;
	case USR_EXIST:
		printf("user exist!\n");
		break;
	default:
		break;
	}
}
static  void login_pro(int status)
{
	deprint("login ack status: %c", status );
	switch(status)
	{
	case SUCCESS: 
		printf("login sucess!\n");
		logflag = ONLINE;
		break;
	case ERR_PASSWD:
		printf("password  wrong!\n");
		break;
	case NO_USR:
		printf("no such user!\n");
		break;
	default:
		break;
	}
}
static int  listfile_pro(int sockfd, pack_t * head)
{
	if (EMPTY ==head->status)
	{
		printf("list :   empty!\n");
		return 0;
	}
	else if(PREDOWNLOAD == head->status)
	{
		int listsize = head->len;
		deprint("begin  to receive  list files......\n");
		unsigned long number = 1;
		char buf[sizeof(struct file )] = {0};
		int ret = 0;
		int cnt = 0;
		while((ret = recv(sockfd, buf, sizeof(struct file), MSG_WAITALL)) >  0)
		{
			cnt++;

			if (listsize == cnt)
			{
				printf("%-4lu%s\t\t%u\n", number++,((struct file *)buf)->fileName, ((struct file *)buf)->fileSize);
				printf("recive complete!\n");
				return 0;
			}

			printf("%-4lu%s\t\t%u\n", number++,((struct file *)buf)->fileName, ((struct file *)buf)->fileSize);

		}
	}
	return 0;
}

static int delete_pro(pack_t * head)
{
	if(NOSUCHFILE == head->status)
	{
		printf("delete:  no such file \n");
		return -1;
	}
	else if (SUCCESS == head->status)
	{
		printf("delete success!\n");
		return 0;
	}
	else
	{
		printf("delete: unkonow status!\n");
		return -1;
	}
}
static  int rename_pro(struct file * file, pack_t * head)
{
	if(NOSUCHFILE == head->status)
	{
		printf("rename :  no such file!\n");
		return -1;
	}
	else if(SUCCESS == head->status)
	{
		printf("rename success!\n");
		return 0;
	}
	else
	{
		printf("unkonow status \n");
	}
	return 0;
}
static  void sync_pro(int status)
{
#if 0
	switch(status)
	{
		case 
	}
#endif 
}
int  pack(const datainfo_t * pdata, const  pack_t * head,  char *  buf , int * buflen)
{

	int totallen = 0;
	int headsize = sizeof(pack_t);
	int usrsize = sizeof(struct usr);
	int filesize = sizeof(struct  file);
	struct file tmp = {0};
	strcpy(tmp.fileName,  g_filename);
	switch(head->cmd)
	{
		case SIGNUP:
		case LOGIN:
			memcpy(buf, head, headsize);
			memcpy(&buf[headsize], &(pdata->usr), usrsize);
			*buflen = usrsize + headsize;
			break;
		case UPLOAD:
		case DOWNLOAD:
			memcpy(buf, head, headsize);
			memcpy(&buf[headsize], &(pdata->file), filesize);
			*buflen = headsize + filesize;
			g_transferflag = 1;
			break;
		case LIST:
			memcpy(buf, head, headsize);
			*buflen = headsize;
			break;
		case QUIT:
			memcpy(buf, head, headsize);
			*buflen = headsize;
		case DELETE:
			memcpy(buf, head, headsize);
			memcpy(&buf[headsize], &(pdata->file), filesize);
			*buflen = headsize+filesize;	
			break;
		case RENAME:
			memcpy(buf, head, headsize);
			memcpy(&buf[headsize], &(pdata->file), filesize);
			memcpy(&buf[headsize+filesize], &tmp,  filesize);
			*buflen = headsize+filesize*2;	
	}
	return 0;
}


int unpack( char * buf, int sockfd )
{
	pack_t  head;
    bzero(&head, sizeof(head));
	memcpy(&head, buf, sizeof(pack_t));
	char tmpbuf[BUFSIZE] = {0};
	int headsize = sizeof(pack_t);
	deprint("");
  	detohex(buf, headsize);
	deprint("*************len = %d \n",head.len );
	if (head.len > 0)
	{
		memcpy(tmpbuf, (unsigned char *)&buf[headsize], head.len);
	}

		switch(head.cmd)
		{
			case  SIGNUP:
				deprint("signup ack\n");
				signup_pro(head.status);
				break;
			case  LOGIN:
				deprint("login ack\n");
				login_pro(head.status);
				return -1;
				break;
			case  UPLOAD:
				deprint("upload ack\n");
				upload_pro(sockfd,  (struct file *)tmpbuf, &head);
				break;
			case  DOWNLOAD:
			    download_pro(sockfd, (struct file *)tmpbuf, &head);
				break;
			case LIST:
				listfile_pro(sockfd,  &head);
				break;
			 case  QUIT:
				exit(0);
				break;
			case  SYNC:
				sync_pro(head.status);
				break;
			case DELETE:
				delete_pro(&head);
				break;
			case RENAME:
				rename_pro((struct file* )tmpbuf, &head);
				break;
			default:
				break;
		}
}

