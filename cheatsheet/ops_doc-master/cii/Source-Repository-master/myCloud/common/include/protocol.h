#ifndef __PROTOCOL_H__
#define __PROTOCOL_H__

// type cmd  status len data0 .. dataN

//cmd type
#define   SIGNUP  1
#define   LOGIN   2
#define   UPLOAD  3
#define   DOWNLOAD 4
#define   LIST    5
#define   SYNC    6
#define   QUIT    7
#define   DELETE  8
#define   RENAME   9
//msg  type
#define   CHAT      1
#define   FILEDATA  2 
//typedef  enum {SIGNUP, LOGIN, UPLOAD, DOWNLOAD, LIST, SYNC}E_CMD;
//msg type
//typedef  enum {CHAT=1, FILEDATA}E_MSGTYPE;
#define  USR_TYPE  1
#define  FILE_TYPE 2
typedef struct  datainfo
{
//	int item_type;
	union{
    struct usr{
		char name[20];
		char passwd[20];  
		}usr;
 	 struct file{
		char fileName[20];
		unsigned   int   fileSize;
		 }file;
	};
}datainfo_t;

extern char g_filename[100];
extern  int g_transferflag;
extern char g_filedir[100];
#define  ONLINE  1
#define  OFFLINE  0
extern int logflag;
/*typedef struct{
	char fileName[20];
	unsigned   int   fileSize;
}fileInfo_t;
*/
typedef struct{
//	char type;			//char
	char cmd;
	char status;
	int len;				//int
}pack_t;
// state状态值宏定义
#define  SUCCESS   0
#define  FAILED    1

// signup  error_stat define 
#define  USR_EXIST        2  

// login error_stat define
#define  ERR_PASSWD       3
#define  NO_USR           4

//upload  state define
#define   FILE_EXIST      5
#define   TRANSFER_COMPLETE  7//(服务器端接收的状态)
//download  
#define   NOSUCHFILE      6
#define   PREDOWNLOAD     9
#define   PREUPLOAD       9
//list  
#define   EMPTY     8
//sync
//#define   

#endif
