/*
 * memory.h
 *
 *  Created on: 2013-6-6
 *      Author: xd
 */

#ifndef MEMORY_H_
#define MEMORY_H_

#define __POSIX__
#ifdef  __POSIX__
#include <pthread.h>
#endif
#define __MINGW__
#define __MEM_DEBUG__


enum memErrCode{
	SETUP_ERR=0,
	MEM_ERR,
	MEM_OK,
	ALREADY_INSTALL,
	UNINSTALL,
	IN_INT,
	SIZE_TOO_BIG,
	NO_ENOUGH_MEMORY,
	ALREADY_MALLOC,
	IMPOSSIBLE_ERR,
	MEM_REGION_CONFLICT,
	NOT_RIGHT_REGION_MEMORY,
	CONTROL_BLOCK_LENGTH_ERR,
	STATE_NOT_EXCEPT,
	CTRL_BLOCK_BREAK,
	IN_CHECK_STATUS,
	IN_SHOW_STATUS,
	CONFIG_ERR,
    CHECK_SUM_ERR,
    MEM_BLOCK_ERR,
	ERR_MAX,
};

struct errCodeStr
{
	enum memErrCode err;
	char* str;
};

enum memState {
	INIT_STATE = 0,
	FREE_STATE,
	MALLOC_STATE,
	REMALLOC_STATE,
	BAD_STATE,
	STATE_MAX,
};

struct memStateStr
{
	enum memState state;
	char* str;
};

enum memAction {
	FREE_ACTION=0,
	MALLOC_ACTION,
	ACTION_MAX,
};

struct memActionStr
{
	enum memAction state;
	char* str;
};

enum memPartition {
	BLOCK_64=0,
	BLOCK_128,
	BLOCK_256,
	BLOCK_512,
	BLOCK_1024,
	BLOCK_2048,
	BLOCK_4096,
	BLOCK_MAX,
};



struct memBlock {
	enum memPartition partition;           /* Partition ID号       */
	struct memBlock  *pNext;               /* 指向下一个节点*/
	unsigned int index;                    /* 内存块编号*/
	enum memState state;                   /* 指示内存状态*/
	unsigned int taskId;                   /* 当前使用内存的任务id*/
	unsigned int length;                   /* 申请的长度*/
	void *pMemory;                         /* 实际内存地址*/
    unsigned long checkSum;                /* check sum*/
};

struct memControlBlock {
	enum memPartition partition;   /* Partition ID号       */
	unsigned int totalBlocks;      /* 该Partition区的块个数*/
	unsigned int size;             /* 每个块的大小         */
	unsigned int totalSize;        /* 分配区域大小*/
	unsigned int usedBlocks;       /* 已使用的块数*/
	unsigned int freeBlocks;       /* 未使用的块数*/
	unsigned int badBlocks;        /* 已发现的损坏的内存块个数，*/
	unsigned int reReleaseBlocks;  /* 重复释放的块*/
	unsigned int unUsedBlocks;     /* 从未使用的块数*/
	unsigned int usedTimes;        /* 分配次数*/
	unsigned int freeTimes;        /* 释放次数*/
	struct memBlock *pHead;        /* 指向本大小内存块链头 */
	struct memBlock *pTail;        /* 指向本大小内存块链尾 */
	void *startArea;               /* 启始内存区*/
	void *endArea;                 /* 结束内存区*/
	unsigned int *pBlockState;     /* 记录内存块状态*/
};

#define FILE_NAME_LENGTH 256
#define FUNCTION_NAME_LENGTH 32

struct memRecord
{
    unsigned int taskId;                  /* 使用内存的任务id*/
    char file[FILE_NAME_LENGTH];          /* 使用内存的文件名*/
    char function[FUNCTION_NAME_LENGTH];  /* 使用内存的任务名*/
    unsigned int line;                    /* 使用内存的函数*/
    enum memAction action;                /* 使用内存的动作*/
    enum memState state;                  /* 使用内存的动作后的状态*/
    enum memErrCode errcode;              /* 使用内存的错误*/
    /*unsigned int index;*/               /* 内存块编号*/
    struct memBlock *pMemBlock;           /* 被使用的内存块*/
    struct memRecord *pNext;              /* 用来记录未被释放 的内存*/
};


struct memRecordlCtrlBlock{
    enum memPartition partition;          /* Partition ID号       */
    unsigned int totalBlocks;             /* 预先分配的记录块数*/
    unsigned int recordnum;               /* 当前记录的块数*/
    struct memRecord *pHead;              /* 记录头*/
    struct memRecord *pTail;              /* 记录尾*/
    struct memRecord *pCurrent;           /* 当前记录的节点*/
};

struct memLeakRecord
{
	unsigned int taskId;                  /* 使用内存的任务id*/
	char file[FILE_NAME_LENGTH];          /* 使用内存的文件名*/
	char function[FUNCTION_NAME_LENGTH];  /* 使用内存的任务名*/
	unsigned int line;                    /* 使用内存的函数*/
	struct memBlock *pMemBlock;           /* 被使用的内存块*/
    time_t timeNow;                       /* 记录申请操作的时间*/
    struct memLeakRecord *pNext;          /* 用来记录未被释放的内存的上一跳*/
    struct memLeakRecord *pPrev;          /* 用来记录未被释放的内存的下一跳*/
};

struct memLeakRecordCtrlBlock
{
    enum memPartition partition;          /* Partition ID号       */
    unsigned int totalBlocks;             /* 预先分配的记录块数*/
    unsigned int recordnum;               /* 当前记录的块数*/
    struct memLeakRecord *pStart;         /* 记录开始的区域*/
    struct memLeakRecord *pHead;          /* 记录头*/
    struct memLeakRecord *pTail;          /* 记录头*/
};


void SYS_MemInit(void);

int SYS_MemSetup(void);
int SYS_MemRecordSetup();
int SYS_MemLeakRecordSetup();

int SYS_MemDestory();
int SYS_MemRecordDestory();
int SYS_MemLeakRecordDestory();

void* SYS_MemAllocate(unsigned int size,char * fileName, char* funName,unsigned int codeLine);
void SYS_MemFree(void *addr,char * fileName, char* funName,unsigned int codeLine);

void showMemAll();
unsigned int showMemRecord(unsigned int blcokInex,unsigned int num); /*显示内存区块的记录*/
unsigned int showMemErrRecord(unsigned int num);
unsigned int showMemLeakRecord(unsigned int blcokInex,unsigned int num);
unsigned int memLeakAnalyse(unsigned int blcokInex,unsigned int minute);
int getIndex(unsigned int size);



#ifdef __VXWORKS__
	extern void intUnlock(int lockKey);
	extern int intLock(void);
	extern int taskIdSelf(void);
	#define TASK_ID_SELF    taskIdSelf

	#define MEM_LOCK_DEFINE
	#define MEM_LOCK_INIT()
	#define MEM_LOCK_START() int key
	#define MEM_LOCK()    key=intLock()
	#define MEM_UNLOCK()  inUnLock(key)

	extern int logMsg (char *fmt, int arg1, int arg2,int arg3, int arg4, int arg5, int arg6);
	#define IN_INT_CONTEXT() intContext()
    #ifdef __MEM_DEBUG__
        #define MEM_DEBUG logMsg
	#endif
#endif



#ifdef __POSIX__

	#define TASK_ID_TYPE    unsigned long int
	#ifdef __MINGW__
		#define TASK_ID_SELF()    \
		({\
			pthread_t temp=pthread_self();\
			temp.p;\
		})
	#else
		#define TASK_ID_SELF    pthread_self
	#endif
	#define MEM_LOCK_DEFINE pthread_mutex_t memMutex
	#define MEM_LOCK_INIT() pthread_mutex_init(&memMutex,NULL)
	#define MEM_LOCK_START()
	#define MEM_LOCK()    pthread_mutex_lock(&memMutex)
	#define MEM_UNLOCK()  pthread_mutex_unlock(&memMutex)

	#ifdef __MEM_DEBUG__
		#define MEM_DEBUG printf
	#endif

	#define IN_INT_CONTEXT() 0
	#define TASK_DELAY

#endif



#define SYS_MALLOC(mallocMem,size)\
{\
	if(IN_INT_CONTEXT() )\
	{\
		MEM_DEBUG("can't alloc mem in int context\n",0,0,0,0,0,0);\
		RECORD_MEM_ERR(MALLOC_ACTION,NULL,STATE_MAX,IN_INT,0,__FILE__,__FUNCTION__,__LINE__);\
		mallocMem=NULL;\
	}\
	else\
	{\
		extern memInstallFlag;\
		while(memInstallFlag==IN_CHECK_STATUS)\
		{\
			/*这里需要向监控模块注册，说明系统是正常的*/\
			TASK_DELAY(1);\
		}\
		mallocMem=SYS_MemAllocate(size,__FILE__,__FUNCTION__,__LINE__);\
	}\
}

#define SYS_FREE(freeMem)\
{\
	if(IN_INT_CONTEXT() )\
	{\
		MEM_DEBUG("can't free mem in int context\n",0,0,0,0,0,0);\
		RECORD_MEM_ERR(MALLOC_ACTION,freeMem,STATE_MAX,IN_INT,0,__FILE__,__FUNCTION__,__LINE__);\
	}\
	else\
	{\
		extern memInstallFlag;\
		while(memInstallFlag==IN_CHECK_STATUS)\
		{\
			/*这里需要向监控模块注册，说明系统是正常的*/\
			TASK_DELAY(1);\
		}\
		SYS_MemFree(freeMem,__FILE__,__FUNCTION__,__LINE__);\
	}\
}

#endif /* MEMORY_H_ */