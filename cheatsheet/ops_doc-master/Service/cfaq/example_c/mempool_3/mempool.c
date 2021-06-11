/*
 * memory.c
 *
 *  Created on: 2013-6-6
 *      Author: xd
 */
#include "mempool.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>


struct errCodeStr globalErrStr[]=
{
	{SETUP_ERR                ,    "SETUP_ERR"},
	{MEM_ERR                  ,    "ERR"},
	{MEM_OK                   ,    "OK"},
	{ALREADY_INSTALL          ,    "ALREADY_INSTALL"},
	{UNINSTALL                ,    "UNINSTALL"},
	{IN_INT                   ,    "IN_INT"},
	{SIZE_TOO_BIG             ,    "SIZE_TOO_BIG"},
	{NO_ENOUGH_MEMORY         ,    "NO_ENOUGH_MEMORY"},
	{ALREADY_MALLOC           ,    "ALREADY_MALLOC"},
	{IMPOSSIBLE_ERR           ,    "IMPOSSIBLE_ERR"},
	{MEM_REGION_CONFLICT      ,    "MEM_REGION_CONFLICT"},
	{NOT_RIGHT_REGION_MEMORY  ,    "NOT_RIGHT_REGION_MEMORY"},
	{CONTROL_BLOCK_LENGTH_ERR ,    "CONTROL_BLOCK_LENGTH_ERR"},
	{STATE_NOT_EXCEPT         ,    "STATE_NOT_EXCEPT"},
	{CTRL_BLOCK_BREAK         ,    "CTRL_BLOCK_BREAK"},
	{IN_CHECK_STATUS		  ,    "IN_CHECK_STATUS"},
	{IN_SHOW_STATUS           ,    "IN_SHOW_STATUS"},
	{CONFIG_ERR               ,    "CONFIG_ERR"},
    {CHECK_SUM_ERR            ,    "CHECK_SUM_ERR"},
	{ERR_MAX                  ,    "ERR_MAX"},

};



struct memStateStr globalMemStateStr[]=
{
	{INIT_STATE     ,    "INIT" },
	{FREE_STATE     ,    "OK"},
	{MALLOC_STATE   ,    "OK"},
	{REMALLOC_STATE ,    "REMALLOC"},
	{BAD_STATE      ,    "BAD"},
	{STATE_MAX      ,    "STATE_MAX"},
};

struct memActionStr globalMemActionStr[]=
{
	{FREE_ACTION    ,  "FREE"},
	{MALLOC_ACTION  ,  "MALLOC"},
	{ACTION_MAX     ,  "ACTION_MAX"},
};




/*内存链的配置*/
struct memControlBlock globalMemCtl[] =
{
	{ BLOCK_64  , 1000, 64  , 0, 0, 1000, 0, 0, 1000, 0, 0, NULL, NULL, NULL, NULL ,(unsigned int *)NULL},
	{ BLOCK_128 , 1000, 128 , 0, 0, 1000, 0, 0, 1000, 0, 0, NULL, NULL, NULL, NULL ,(unsigned int *)NULL},
	{ BLOCK_256 , 1000, 256 , 0, 0, 1000, 0, 0, 1000, 0, 0, NULL, NULL, NULL, NULL ,(unsigned int *)NULL},
	{ BLOCK_512 , 1000, 512 , 0, 0, 1000, 0, 0, 1000, 0, 0, NULL, NULL, NULL, NULL ,(unsigned int *)NULL},
	{ BLOCK_1024, 1000, 1024, 0, 0, 1000, 0, 0, 1000, 0, 0, NULL, NULL, NULL, NULL ,(unsigned int *)NULL},
	{ BLOCK_2048, 1000, 2048, 0, 0, 1000, 0, 0, 1000, 0, 0, NULL, NULL, NULL, NULL ,(unsigned int *)NULL},
	{ BLOCK_4096, 1000, 4096, 0, 0, 1000, 0, 0, 1000, 0, 0, NULL, NULL, NULL, NULL ,(unsigned int *)NULL},
};


/*记录每个内存块的操作*/
struct memRecordlCtrlBlock globalMemRecord[] =
{
	{ BLOCK_64  , 2000, 0, NULL, NULL, NULL },
	{ BLOCK_128 , 2000, 0, NULL, NULL, NULL },
	{ BLOCK_256 , 2000, 0, NULL, NULL, NULL },
	{ BLOCK_512 , 2000, 0, NULL, NULL, NULL },
	{ BLOCK_1024, 2000, 0, NULL, NULL, NULL },
	{ BLOCK_2048, 2000, 0, NULL, NULL, NULL },
	{ BLOCK_4096, 2000, 0, NULL, NULL, NULL },
	{ BLOCK_MAX , 2000, 0, NULL, NULL, NULL },/*记录内存操作的异常情况*/
};


/*记录未释放的内存链*/
struct memLeakRecordCtrlBlock globalMemLeakRecord[]=
{
	{ BLOCK_64  , 1000, 0, NULL, NULL, NULL },
	{ BLOCK_128 , 1000, 0, NULL, NULL, NULL },
	{ BLOCK_256 , 1000, 0, NULL, NULL, NULL },
	{ BLOCK_512 , 1000, 0, NULL, NULL, NULL },
	{ BLOCK_1024, 1000, 0, NULL, NULL, NULL },
	{ BLOCK_2048, 1000, 0, NULL, NULL, NULL },
	{ BLOCK_4096, 1000, 0, NULL, NULL, NULL },
};


void *beginAddr = NULL;
void *beginRecordAddr = NULL;
void *beginLeakRecordAddr = NULL;

unsigned int  memInstallFlag=UNINSTALL;
unsigned int  memRecordInstallFlag=UNINSTALL;
unsigned int  memLeakRecordInstallFlag=UNINSTALL;

MEM_LOCK_DEFINE;


/*
 * author xd
 *
 * To change this generated comment edit the template variable "comment":
 * Window > Preferences > C/C++ > Editor > Templates.
 *
 * 用于设置位的值
 */
int BitMap_SetBit(unsigned int* bitAddr, unsigned int index)
{
    unsigned int  _index = index / sizeof(unsigned int*);
    unsigned int  _pos   = index % sizeof(unsigned int*);

    if (NULL == bitAddr)
    {
        return MEM_ERR;
    }
    bitAddr[_index] = (1<<_pos);
    return MEM_OK;

}

/*
 * author xd
 *
 * To change this generated comment edit the template variable "comment":
 * Window > Preferences > C/C++ > Editor > Templates.
 *
 *用于获取位的值
 */
int BitMap_GetBitValue(unsigned int* bitAddr, unsigned int index)
{
    unsigned int  _index = index / sizeof(unsigned int*);
    unsigned int  _pos   = index % sizeof(unsigned int*);

    if (NULL == bitAddr)
    {
        return MEM_ERR;
    }

    if((bitAddr[_index] & (1<<_pos)) == 0 )
    {
        return 0;
    }
    else
    {
        return 1;
    }

}

unsigned long countMemCheckSum(struct memBlock * checkMemBlock)
{
    unsigned long checkSum=0;
    checkSum = (unsigned long)checkMemBlock->index
            & (unsigned long)checkMemBlock->length
            & (unsigned long)checkMemBlock->partition
            & (unsigned long)checkMemBlock->pMemory
            & (unsigned long)checkMemBlock->pNext
            & (unsigned long)checkMemBlock->state
            & (unsigned long)checkMemBlock->taskId;
    return checkSum;
}


/*
 * author xd
 *
 * To change this generated comment edit the template variable "comment":
 * Window > Preferences > C/C++ > Editor > Templates.
 *
 * 内存池初始化
 *
 */

int SYS_MemSetup(void)
{

	unsigned int partitionIndex = 0;
	unsigned int blockIndex = 0;
	unsigned int totalSize = 0;
    unsigned int memBlockSize = sizeof(struct memBlock);
	struct memBlock *tempMemBlock = NULL;
	char *tempAddr = NULL;

	MEM_LOCK_INIT();

	if(memInstallFlag == ALREADY_INSTALL )
	{
		return ALREADY_INSTALL;
	}

	for (partitionIndex = 0; partitionIndex < BLOCK_MAX; partitionIndex++)
	{
        globalMemCtl[partitionIndex].totalSize = (globalMemCtl[partitionIndex].size + memBlockSize) * globalMemCtl[partitionIndex].totalBlocks;
		totalSize += globalMemCtl[partitionIndex].totalSize;
	}

	if (totalSize != 0)
	{
		beginAddr = malloc(totalSize);
		if (beginAddr == NULL )
		{
			return SETUP_ERR;
		}
		memset(beginAddr, 0XAA, totalSize);
		tempAddr = beginAddr;
	}

	/* 每段链的内存空间  >= starArea,< endArea */
	for (partitionIndex = 0; partitionIndex < BLOCK_MAX; partitionIndex++)
	{
		globalMemCtl[partitionIndex].startArea = tempAddr;
		globalMemCtl[partitionIndex].endArea = tempAddr + globalMemCtl[partitionIndex].totalSize;
		globalMemCtl[partitionIndex].pHead = (struct memBlock*) tempAddr;

		for (blockIndex = 0; blockIndex < globalMemCtl[partitionIndex].totalBlocks; blockIndex++)
		{
			tempMemBlock = (struct memBlock*) tempAddr;
            tempMemBlock->pMemory =tempAddr+memBlockSize;
			tempMemBlock->length = 0;
			tempMemBlock->state = INIT_STATE;
			tempMemBlock->partition =partitionIndex;
			tempMemBlock->index = blockIndex;
			tempMemBlock->taskId = 0;
            tempAddr = (tempAddr + globalMemCtl[partitionIndex].size + memBlockSize);
			tempMemBlock->pNext = (struct memBlock*)tempAddr;
		}
		tempMemBlock->pNext = NULL;
		globalMemCtl[partitionIndex].pTail = tempMemBlock;

		/*分配一段内存用来保留每个内存块的状态0为正常，1为异常*/
		globalMemCtl[partitionIndex].pBlockState = malloc(globalMemCtl[partitionIndex].totalSize / sizeof(globalMemCtl[partitionIndex].pBlockState));
		if(globalMemCtl[partitionIndex].pBlockState == NULL)
		{
			free(beginAddr);
			return SETUP_ERR;
		}

	}

	memInstallFlag=ALREADY_INSTALL;
	return MEM_OK;

}

int SYS_MemDestory(void)
{
    if(memInstallFlag==ALREADY_INSTALL)
    {
        free(beginAddr);
        memInstallFlag=UNINSTALL;
    }
    return MEM_OK;
}


int SYS_MemRecordInit(struct memRecordlCtrlBlock* pMemRecordConfig)
{
	unsigned int totalSize = 0;
	unsigned int memRecordSize = sizeof(struct memRecord);
	char *tempAddr = NULL;

	if(pMemRecordConfig==NULL)
	{
		return CONFIG_ERR;
	}

	if(memRecordInstallFlag == ALREADY_INSTALL )
	{
		return ALREADY_INSTALL;
	}

	totalSize=pMemRecordConfig->totalBlocks * memRecordSize;

	if (totalSize != 0)
	{
		beginRecordAddr = malloc(totalSize);
		if (beginRecordAddr == NULL )
		{
			return SETUP_ERR;
		}
		memset(beginRecordAddr, 0XBB, totalSize);
		tempAddr = beginRecordAddr;
	}


	pMemRecordConfig->pHead = (struct memRecord*) tempAddr;
	pMemRecordConfig->pCurrent = (struct memRecord*) tempAddr;
	tempAddr += pMemRecordConfig->totalBlocks * memRecordSize;
	pMemRecordConfig->pTail = (struct memRecord*) (tempAddr) - 1;

	memRecordInstallFlag = ALREADY_INSTALL;
	return MEM_OK;
}


/*
 * author xd
 *
 * To change this generated comment edit the template variable "comment":
 * Window > Preferences > C/C++ > Editor > Templates.
 *
 * 内存记录模块初始化
 *
 *
 */

int SYS_MemRecordSetup(void)
{

	unsigned int partitionIndex = 0;
	unsigned int totalSize = 0;
	unsigned int memRecordSize = sizeof(struct memRecord);
	char *tempAddr = NULL;

	if(memRecordInstallFlag == ALREADY_INSTALL )
	{
		return ALREADY_INSTALL;
	}

	for (partitionIndex = 0; partitionIndex <= BLOCK_MAX; partitionIndex++)
	{
		totalSize += globalMemRecord[partitionIndex].totalBlocks * memRecordSize;
	}

	if (totalSize != 0)
	{
		beginRecordAddr = malloc(totalSize);
		if (beginRecordAddr == NULL )
		{
			return SETUP_ERR;
		}
		memset(beginRecordAddr, 0XBB, totalSize);
		tempAddr = beginRecordAddr;
	}

	/* 记录采用环形队列*/
	for (partitionIndex = 0; partitionIndex <= BLOCK_MAX; partitionIndex++)
	{
		globalMemRecord[partitionIndex].pHead = (struct memRecord*) tempAddr;
		globalMemRecord[partitionIndex].pCurrent = (struct memRecord*) tempAddr;
		tempAddr += globalMemRecord[partitionIndex].totalBlocks * memRecordSize;
		globalMemRecord[partitionIndex].pTail = (struct memRecord*) (tempAddr) - 1;
	}

	memRecordInstallFlag = ALREADY_INSTALL;
	return MEM_OK;
}

int SYS_MemRecordDestory()
{
	if(memRecordInstallFlag == ALREADY_INSTALL)
	{
		free(beginRecordAddr);
		memRecordInstallFlag = UNINSTALL;
	}
	return MEM_OK;
}


int SYS_MemLeakRecordSetup()
{

	unsigned int partitionIndex = 0;
	unsigned int totalSize = 0;
	unsigned int memRecordSize = sizeof(struct memLeakRecord);
	char *tempAddr = NULL;

	if(memLeakRecordInstallFlag == ALREADY_INSTALL )
	{
		return ALREADY_INSTALL;
	}

	for (partitionIndex = 0; partitionIndex < BLOCK_MAX; partitionIndex++)
	{
		totalSize += globalMemLeakRecord[partitionIndex].totalBlocks * memRecordSize;
	}

	if (totalSize != 0)
	{
		beginLeakRecordAddr = malloc(totalSize);
		if (beginLeakRecordAddr == NULL )
		{
			return SETUP_ERR;
		}
		memset(beginLeakRecordAddr, 0X00, totalSize);
		tempAddr = beginLeakRecordAddr;
	}

	for (partitionIndex = 0; partitionIndex < BLOCK_MAX; partitionIndex++)
	{
		globalMemLeakRecord[partitionIndex].pStart = (struct memRecord*) tempAddr;
		tempAddr += globalMemLeakRecord[partitionIndex].totalBlocks * memRecordSize;
	}

	memLeakRecordInstallFlag = ALREADY_INSTALL;
	return MEM_OK;

}

int SYS_MemLeakRecordDestory()
{
	if(memLeakRecordInstallFlag == ALREADY_INSTALL)
	{
		free(beginLeakRecordAddr);
		memLeakRecordInstallFlag = UNINSTALL;
	}
	return MEM_OK;
}


/*
 * author xd
 *
 * To change this generated comment edit the template variable "comment":
 * Window > Preferences > C/C++ > Editor > Templates.
 *
 * 内存系统初始化
 *
 */
void SYS_MemInit(void)
{
	SYS_MemSetup();
	SYS_MemRecordSetup();
	SYS_MemLeakRecordSetup();
}

/*
 * author xd
 *
 * To change this generated comment edit the template variable "comment":
 * Window > Preferences > C/C++ > Editor > Templates.
 *
 * 获取内存链下标
 *
 */

int getIndex(unsigned int size)
{
	int index=0;
	for(index=0;index<BLOCK_MAX;index++)
	{
        if(size <= globalMemCtl[index].size)
		{
			return index;
		}

	}
	return BLOCK_MAX;
}


#define RECORD_MEM_START(taskId,fileName,funName,codeLine)\
    TASK_ID_TYPE _taskId= taskId;\
    char * _fileName    = fileName;\
    char * _funName     = funName;\
    unsigned _codeLine  = codeLine;\
    int _fileNameLength = strlen(fileName);\
    int _funNameLength  = strlen(funName);\
    time_t timeNow      = time(NULL);\
    if(_fileNameLength >= FILE_NAME_LENGTH)\
    {\
        _fileNameLength=FILE_NAME_LENGTH-1;\
    }\
    if(_funNameLength >= FUNCTION_NAME_LENGTH)\
    {\
        _funNameLength=FUNCTION_NAME_LENGTH-1;\
    }


/*记录正常操作的宏，包括动作，动作结果状态，任务id,操作内存，代码行号，代码文件名，代码文件名长度，代码函数名，代码函数名长度*/
#define RECORD_MEM(_action,_actMem,index,_state)\
{\
	if(memRecordInstallFlag == ALREADY_INSTALL)\
	{\
		globalMemRecord[index].pCurrent->action     = _action;\
		globalMemRecord[index].pCurrent->state      = _state;\
		globalMemRecord[index].pCurrent->taskId     = _taskId;\
		globalMemRecord[index].pCurrent->pMemBlock  = _actMem;\
		globalMemRecord[index].pCurrent->line       = _codeLine;\
	/*	globalMemRecord[index].pCurrent->index      = _actMem->index;*/\
		memset(globalMemRecord[index].pCurrent->file,0,FILE_NAME_LENGTH);\
		memset(globalMemRecord[index].pCurrent->function,0,FUNCTION_NAME_LENGTH);\
		memcpy(globalMemRecord[index].pCurrent->file,_fileName,_fileNameLength);\
		memcpy(globalMemRecord[index].pCurrent->function,_funName,_funNameLength);\
		globalMemRecord[index].recordnum++;\
		globalMemRecord[index].pCurrent=&(globalMemRecord[index].pHead[globalMemRecord[index].recordnum % globalMemRecord[index].totalBlocks]);\
	}\
}

/*记录正常操作异常情况的宏*/
#define RECORD_MEM_ERR(_action,_actMem,_state,_errcode)\
{\
	if(memRecordInstallFlag == ALREADY_INSTALL)\
	{\
		globalMemRecord[BLOCK_MAX].pCurrent->action     = _action;\
		globalMemRecord[BLOCK_MAX].pCurrent->state      = _state;\
		globalMemRecord[BLOCK_MAX].pCurrent->errcode    = _errcode;\
		globalMemRecord[BLOCK_MAX].pCurrent->taskId     = _taskId;\
		globalMemRecord[BLOCK_MAX].pCurrent->pMemBlock  = _actMem;\
		globalMemRecord[BLOCK_MAX].pCurrent->line       = _codeLine;\
		/*globalMemRecord[BLOCK_MAX].pCurrent->index      = _actMem->index;*/\
		memset(globalMemRecord[BLOCK_MAX].pCurrent->file,0,FILE_NAME_LENGTH);\
		memset(globalMemRecord[BLOCK_MAX].pCurrent->function,0,FUNCTION_NAME_LENGTH);\
		memcpy(globalMemRecord[BLOCK_MAX].pCurrent->file,_fileName,_fileNameLength);\
		memcpy(globalMemRecord[BLOCK_MAX].pCurrent->function,_funName,_funNameLength);\
		globalMemRecord[BLOCK_MAX].recordnum++;\
		globalMemRecord[BLOCK_MAX].pCurrent=&(globalMemRecord[BLOCK_MAX].pHead[globalMemRecord[BLOCK_MAX].recordnum % globalMemRecord[BLOCK_MAX].totalBlocks]);\
	}\
}

#define RECORD_MEM_LEAK_ADD(_actMem,_index)\
{\
	if(memRecordInstallFlag == ALREADY_INSTALL)\
	{\
		if(globalMemLeakRecord[_index].pHead==NULL)\
		{\
			globalMemLeakRecord[_index].pHead=&globalMemLeakRecord[_index].pStart[_actMem->index]; \
			globalMemLeakRecord[_index].pHead->pPrev=NULL;\
		}\
		else\
		{\
			globalMemLeakRecord[_index].pTail->pNext=&globalMemLeakRecord[_index].pStart[_actMem->index];\
			globalMemLeakRecord[_index].pStart[_actMem->index].pPrev=globalMemLeakRecord[_index].pTail;\
		}\
		globalMemLeakRecord[_index].pTail=&globalMemLeakRecord[_index].pStart[_actMem->index]; \
		globalMemLeakRecord[_index].pTail->pNext=NULL;\
		memset(globalMemLeakRecord[_index].pStart[_actMem->index].file,0,FILE_NAME_LENGTH);\
		memset(globalMemLeakRecord[_index].pStart[_actMem->index].function,0,FUNCTION_NAME_LENGTH);\
		memcpy(globalMemLeakRecord[_index].pStart[_actMem->index].file,_fileName,_fileNameLength);\
		memcpy(globalMemLeakRecord[_index].pStart[_actMem->index].function,_funName,_funNameLength);\
        globalMemLeakRecord[_index].pStart[_actMem->index].timeNow = timeNow;\
		globalMemLeakRecord[_index].pStart[_actMem->index].line=codeLine;\
		globalMemLeakRecord[_index].pStart[_actMem->index].taskId=_taskId;\
		globalMemLeakRecord[_index].pStart[_actMem->index].pMemBlock=_actMem;\
		globalMemLeakRecord[_index].recordnum++;\
	}\
}



#define RECORD_MEM_LEAK_DEL(_actMem,_index)\
{\
	if(memRecordInstallFlag == ALREADY_INSTALL)\
	{\
		struct memLeakRecord * pTemp=&globalMemLeakRecord[_index].pStart[freeMem->index];\
		if(pTemp->pPrev!=NULL && pTemp->pNext!=NULL)\
		{\
			pTemp->pPrev->pNext=pTemp->pNext;\
			pTemp->pNext->pPrev=pTemp->pPrev;\
		}\
		if(pTemp->pPrev!=NULL && pTemp->pNext==NULL)\
		{\
			pTemp->pPrev->pNext=NULL;\
			globalMemLeakRecord[_index].pTail=pTemp->pPrev;\
		}\
		if(pTemp->pPrev==NULL && pTemp->pNext!=NULL)\
		{\
			pTemp->pNext->pPrev=NULL;\
			globalMemLeakRecord[_index].pHead=pTemp->pNext;\
		}\
		if(pTemp->pPrev==NULL && pTemp->pNext==NULL)\
		{\
			globalMemLeakRecord[_index].pHead=NULL;\
			globalMemLeakRecord[_index].pTail=NULL;\
		}\
		memset(pTemp,0,sizeof(struct memLeakRecord));\
		globalMemLeakRecord[_index].recordnum--;\
	}\
}

/*
 * author xd
 *
 * To change this generated comment edit the template variable "comment":
 * Window > Preferences > C/C++ > Editor > Templates.
 * 对于vxworks系统，只能在任务上下文中调用
 *
 *
 */
void * SYS_MemAllocate(unsigned int size,char * fileName, char* funName,unsigned int codeLine)
{
    int index = getIndex(size);
    struct memBlock *returnMem = NULL;
    unsigned long memBlockSize = sizeof(struct memBlock);
    TASK_ID_TYPE taskId= TASK_ID_SELF();
    RECORD_MEM_START(taskId,fileName,funName,codeLine);
    MEM_LOCK_START();

	if(index >= BLOCK_MAX)
	{
		MEM_DEBUG("can't alloc mem ,because the szie %d is to big\n",size,0,0,0,0,0);
        RECORD_MEM_ERR(MALLOC_ACTION,returnMem,size,SIZE_TOO_BIG);
		return NULL;
	}

	MEM_LOCK();
	while (globalMemCtl[index].freeBlocks == 0)
	{
		index++;
		if(index >= BLOCK_MAX)
		{
            MEM_DEBUG("1 don't have any memory left\n",0,0,0,0,0,0);
            RECORD_MEM_ERR(MALLOC_ACTION,returnMem,STATE_MAX,NO_ENOUGH_MEMORY);
			MEM_UNLOCK();
			return NULL;
		}
	}

	/*从头部取出内存*/
	if (globalMemCtl[index].pHead!=NULL)
	{
		returnMem = globalMemCtl[index].pHead;
	}
	else
	{
        MEM_DEBUG("2 Can't return in this point,The system maybe wrong,globalMemCtl[%d].pHead ==NULL\n",index,0,0,0,0,0);
        RECORD_MEM_ERR(MALLOC_ACTION,returnMem,STATE_MAX,IMPOSSIBLE_ERR);
		MEM_UNLOCK();
		return NULL;
	}


    if(returnMem->state == INIT_STATE
      || returnMem->state == FREE_STATE
      && returnMem->partition == index
      && (unsigned long)returnMem->pMemory  == (unsigned long)returnMem + memBlockSize
      && returnMem->index == ((unsigned long)returnMem - (unsigned long)globalMemCtl[index].startArea ) /(globalMemCtl[index].size + memBlockSize)
      )
    {
        if(globalMemCtl[index].pHead->pNext == NULL)
        {
            globalMemCtl[index].pTail=NULL;
        }
        globalMemCtl[index].pHead = globalMemCtl[index].pHead->pNext;

        if(returnMem->state == INIT_STATE)
        {
            globalMemCtl[index].unUsedBlocks--;
        }
        globalMemCtl[index].freeBlocks--;
        globalMemCtl[index].usedBlocks++;
        globalMemCtl[index].usedTimes++;
        returnMem->state  = MALLOC_STATE;
        returnMem->taskId = taskId;
        returnMem->pNext  = NULL;
        returnMem->length = size;
        returnMem->checkSum=countMemCheckSum(returnMem);

    }
    else
    {
        RECORD_MEM_ERR(MALLOC_ACTION,returnMem,returnMem->state,MEM_BLOCK_ERR);
        if(globalMemCtl[index].pHead->pNext == NULL)
        {
            globalMemCtl[index].pTail=NULL;
        }
        globalMemCtl[index].pHead = globalMemCtl[index].pHead->pNext;
        globalMemCtl[index].freeBlocks--;
        globalMemCtl[index].badBlocks++;
        /*returnMem->state = BAD_STATE;*/
        MEM_UNLOCK();
        return NULL;
    }

    RECORD_MEM(MALLOC_ACTION,returnMem,index,MALLOC_STATE);
    RECORD_MEM_LEAK_ADD(returnMem,index);

	MEM_UNLOCK();

	return returnMem->pMemory;
}


/*
 * author xd
 *
 * To change this generated comment edit the template variable "comment":
 * Window > Preferences > C/C++ > Editor > Templates.
 *
 * 内存释放函数
 *
 */
void SYS_MemFree(void *addr,char * fileName, char* funName,unsigned int codeLine)
{
    int index=0;
    int indexInBlock=0;
    struct memBlock *freeMem = NULL;
    unsigned long memBlockSize = sizeof(struct memBlock);
    TASK_ID_TYPE taskId= TASK_ID_SELF();
    RECORD_MEM_START(taskId,fileName,funName,codeLine);
    MEM_LOCK_START();


	/*如果地址不在内存池空间中，记录相关的异常*/
	if(addr < globalMemCtl[0].startArea+sizeof(struct memBlock) || addr >= globalMemCtl[BLOCK_MAX-1].endArea)
	{
		MEM_DEBUG("5 The release mem %p is not in mem pool，start: 0X%p, end: %p\n",addr,globalMemCtl[0].startArea,globalMemCtl[BLOCK_MAX-1].endArea,0,0,0);
        RECORD_MEM_ERR(FREE_ACTION,freeMem,STATE_MAX,NOT_RIGHT_REGION_MEMORY);
		return;
	}

	freeMem=(struct memBlock*)((char*)addr - sizeof(struct memBlock));

    MEM_LOCK();
    if(freeMem->checkSum != countMemCheckSum(freeMem))
    {
        RECORD_MEM_ERR(FREE_ACTION,freeMem,STATE_MAX,CHECK_SUM_ERR);
        MEM_UNLOCK();
        return;
    }

    index=freeMem->partition;
	if(index >= BLOCK_MAX)
	{

		for(index=0;index<BLOCK_MAX;index++)
		{
			if(freeMem < globalMemCtl[index].endArea)
			{
				break;
			}
		}
		/*BitMap_SetBit(globalMemCtl[index].badBlocks,);*/
		freeMem->state=BAD_STATE;
		globalMemCtl[index].badBlocks++;
        RECORD_MEM_ERR(FREE_ACTION,freeMem,STATE_MAX,CTRL_BLOCK_BREAK);
        MEM_UNLOCK();
		return;
	}

    if(freeMem->state == MALLOC_STATE
      && freeMem->pNext == NULL
      && (unsigned long)freeMem->pMemory == (unsigned long)freeMem + memBlockSize
      && (unsigned long)freeMem->pMemory == addr
      && freeMem->length <= globalMemCtl[index].size
      && freeMem->index == ((unsigned long)freeMem - (unsigned long)globalMemCtl[index].startArea ) /(globalMemCtl[index].size + memBlockSize)
      )
    {
        /*将释放的内存添加到链尾*/
        freeMem->taskId=0;
        freeMem->length=0;
        freeMem->pNext=NULL;
        freeMem->state = FREE_STATE;
        globalMemCtl[index].freeBlocks++;
        globalMemCtl[index].usedBlocks--;
        globalMemCtl[index].freeTimes++;


        if(globalMemCtl[index].pTail==NULL)
        {
            globalMemCtl[index].pHead=freeMem;
            globalMemCtl[index].pTail = freeMem;
        }
        else
        {
            globalMemCtl[index].pTail->pNext=freeMem;
            globalMemCtl[index].pTail = freeMem;
        }

        RECORD_MEM(FREE_ACTION,freeMem,index,FREE_STATE);
        RECORD_MEM_LEAK_DEL(freeMem,index);
        MEM_UNLOCK();
        return;
    }

	/*校验内存头部控制块*/

	/*检查内存是否在正确的内存链上*/
	if(addr < globalMemCtl[index].startArea || addr >= globalMemCtl[index].endArea)
	{
		/*由于此内存的控制块数据出错，这里只做标识不做内存块记录*/
		MEM_DEBUG("6 the release mem %p is not in right mem chain，start: 0X%p, end: 0X%p\n",addr,globalMemCtl[index].startArea,globalMemCtl[index].endArea,0,0,0);
		freeMem->state = BAD_STATE;
        RECORD_MEM_ERR(FREE_ACTION,freeMem,STATE_MAX,MEM_REGION_CONFLICT);
		MEM_UNLOCK();
		return;
	}
	else
	{

		/*内存记录的分配长度大于内存所在链的长度*/
		if(freeMem->length > globalMemCtl[index].size)
		{
			MEM_DEBUG("the free mem %p legth %d is bigger than size %d\n",freeMem,freeMem->length,globalMemCtl[index].size,0,0,0);
			freeMem->state = BAD_STATE;
			globalMemCtl[index].badBlocks++;
            RECORD_MEM_ERR(FREE_ACTION,freeMem,STATE_MAX,CONTROL_BLOCK_LENGTH_ERR);
/*			RECORD_MEM(FREE_ACTION,freeMem,BAD_STATE);*/
			MEM_UNLOCK();
			return;
		}

	}


	switch(freeMem->state)
	{
	case INIT_STATE:
		MEM_DEBUG("7  Init mem block %p ,0X%X ,Can't be released\n",freeMem,freeMem->state,0,0,0,0);
		globalMemCtl[index].reReleaseBlocks++;
        RECORD_MEM_ERR(FREE_ACTION,freeMem,INIT_STATE,REMALLOC_STATE);
	case FREE_STATE:
		MEM_DEBUG("8 Free mem block %p , 0X%X ,Can't be released\n",freeMem,freeMem->state,0,0,0,0);
		globalMemCtl[index].reReleaseBlocks++;
        RECORD_MEM_ERR(FREE_ACTION,freeMem,FREE_STATE,REMALLOC_STATE);
	default:
		MEM_DEBUG("9 The mem %p state 0X%X is not right\n",freeMem,freeMem->state,0,0,0,0);
        RECORD_MEM_ERR(FREE_ACTION,freeMem,freeMem->state,STATE_NOT_EXCEPT);
		globalMemCtl[index].badBlocks++;
		freeMem->state = BAD_STATE;
	}

	MEM_UNLOCK();
	return;

}

/*
 * author xd
 *
 * To change this generated comment edit the template variable "comment":
 * Window > Preferences > C/C++ > Editor > Templates.
 *
 * 显示所有内存块信息
 *
 */
void showMemAll()
{
	int blcokInex=0;
	printf("block  size   blockNum  startArea         endArea           used    free    bad     unused  rerelease   usedTimes   freeTimes\n");
	for(blcokInex = 0; blcokInex < sizeof(globalMemCtl) / sizeof(struct memControlBlock); blcokInex++)
	{

		printf("%-7d%-7d%-10d%16p  %-16p  %-8d%-8d%-8d%-8d%-12d%-12u%-12u\n",
				blcokInex,
				globalMemCtl[blcokInex].size,
				globalMemCtl[blcokInex].totalBlocks,
				globalMemCtl[blcokInex].startArea,
				globalMemCtl[blcokInex].endArea,
				globalMemCtl[blcokInex].usedBlocks,
				globalMemCtl[blcokInex].freeBlocks,
				globalMemCtl[blcokInex].badBlocks,
				globalMemCtl[blcokInex].unUsedBlocks,
				globalMemCtl[blcokInex].reReleaseBlocks,
				globalMemCtl[blcokInex].usedTimes,
				globalMemCtl[blcokInex].freeTimes);
	}
	return;


}

/*
 * author xd
 *
 * To change this generated comment edit the template variable "comment":
 * Window > Preferences > C/C++ > Editor > Templates.
 *
 * 显示单个内存块信息
 *
 */
void showMem(unsigned int blcokInex)
{
	if(blcokInex>BLOCK_MAX)
	{
		printf("input blockNum %d is err\n",blcokInex);
		return;
	}

	printf("block  size   blockNum  startArea         endArea           used    free    bad     unused  rerelease   usedTimes   freeTimes\n");


	printf("%-7d%-7d%-10d%p  %p  %-8d%-8d%-8d%-8d%-12d%-12u%-12u\n",
			blcokInex,
			globalMemCtl[blcokInex].size,
			globalMemCtl[blcokInex].totalBlocks,
			globalMemCtl[blcokInex].startArea,
			globalMemCtl[blcokInex].endArea,
			globalMemCtl[blcokInex].usedBlocks,
			globalMemCtl[blcokInex].freeBlocks,
			globalMemCtl[blcokInex].badBlocks,
			globalMemCtl[blcokInex].unUsedBlocks,
			globalMemCtl[blcokInex].reReleaseBlocks,
			globalMemCtl[blcokInex].usedTimes,
			globalMemCtl[blcokInex].freeTimes);
	return;
}


/*
 * author xd
 *
 * To change this generated comment edit the template variable "comment":
 * Window > Preferences > C/C++ > Editor > Templates.
 *
 * 显示内存记录信息
 *
 */
unsigned int showMemRecord(unsigned int blcokInex,unsigned int num)
{
	int index=0;
	struct memRecord *tempRecord=NULL;

	memRecordInstallFlag=IN_SHOW_STATUS;

	if(blcokInex>BLOCK_MAX)
	{
		printf("input blockNum %d is err\n",blcokInex);
		return;
	}

	if(num > globalMemRecord[blcokInex].totalBlocks)
	{
		printf("num %d is bigger than the size of record %d \n",num,globalMemRecord[blcokInex].totalBlocks);
		num = globalMemRecord[blcokInex].totalBlocks;
	}

	if(num > globalMemRecord[blcokInex].recordnum)
	{
		num= globalMemRecord[blcokInex].recordnum;
	}

	if(globalMemRecord[index].recordnum > globalMemRecord[blcokInex].totalBlocks)
	{
		tempRecord=globalMemRecord[blcokInex].pCurrent++;
	}
	else
	{
		tempRecord=globalMemRecord[blcokInex].pHead;
	}

	printf("block:%d ,totalBlocks:%d ,recordNum:%d\n",blcokInex,globalMemRecord[blcokInex].totalBlocks,globalMemRecord[blcokInex].recordnum);
	printf("record:\n");
	printf("pHead:%p,pTail:%p,pCurrent:%p\n",
			globalMemRecord[blcokInex].pHead,
			globalMemRecord[blcokInex].pTail,
			globalMemRecord[blcokInex].pCurrent
		    );

	for(index=0;index<num;index++)
	{
		printf("action:%-12s,state:%-10s,mem:%p,taskId:0x%x,file:%s,function:%s,line:%d\n",
				globalMemActionStr[tempRecord->action].str,
				globalMemStateStr[tempRecord->state].str,
				tempRecord->pMemBlock,
				/*tempRecord->index,*/
				tempRecord->taskId,
				tempRecord->file,
				tempRecord->function,
				tempRecord->line);

		tempRecord++;
		if(tempRecord > globalMemRecord[blcokInex].pTail)
		{
			tempRecord=globalMemRecord[blcokInex].pHead;
		}

	}

	memRecordInstallFlag = ALREADY_INSTALL;
    return  num;
}

/*
 * author xd
 *
 * To change this generated comment edit the template variable "comment":
 * Window > Preferences > C/C++ > Editor > Templates.
 *
 * 显示错误内存记录
 *
 */
unsigned int showMemErrRecord(unsigned int num)
{
	int index=0;
	struct memRecord *tempRecord=NULL;

	memRecordInstallFlag = IN_SHOW_STATUS;

	if(num > globalMemRecord[BLOCK_MAX].totalBlocks)
	{
		printf("num %d is bigger than the size of record %d \n",num,globalMemRecord[BLOCK_MAX].totalBlocks);
		num = globalMemRecord[BLOCK_MAX].totalBlocks;
	}

	if(num > globalMemRecord[BLOCK_MAX].recordnum)
	{
		num = globalMemRecord[BLOCK_MAX].recordnum;
	}

	if(globalMemRecord[BLOCK_MAX].recordnum > globalMemRecord[BLOCK_MAX].totalBlocks)
	{
		tempRecord=globalMemRecord[BLOCK_MAX].pCurrent++;
	}
	else
	{
		tempRecord=globalMemRecord[BLOCK_MAX].pHead;
	}

	printf("ErrBlock ,totalBlocks:%d ,recordNum:%d\n",globalMemRecord[BLOCK_MAX].totalBlocks,globalMemRecord[BLOCK_MAX].recordnum);
	printf("record:\n");
	printf("pHead:0X%p,pTail:0X%p,pCurrent:0X%p\n",
			globalMemRecord[BLOCK_MAX].pHead,
			globalMemRecord[BLOCK_MAX].pTail,
			globalMemRecord[BLOCK_MAX].pCurrent
			);

	for(index=0;index<num;index++)
	{
		printf("action:%-12s,err:%-25s,state:%d,mem:%p,taskId:0x%x,file:%s,function:%s,line:%d\n",
				globalMemActionStr[tempRecord->action].str,
				globalErrStr[tempRecord->errcode].str,
				tempRecord->state,
				tempRecord->pMemBlock,
				/*tempRecord->index,*/
				tempRecord->taskId,
				tempRecord->file,
				tempRecord->function,
				tempRecord->line);

		tempRecord++;
		if(tempRecord>globalMemRecord[BLOCK_MAX].pTail)
		{
			tempRecord=globalMemRecord[BLOCK_MAX].pHead;
		}

	}

	memRecordInstallFlag=ALREADY_INSTALL;
    return num;
}


/*
 * author xd
 *
 * To change this generated comment edit the template variable "comment":
 * Window > Preferences > C/C++ > Editor > Templates.
 *
 * 显示内存记录信息
 *
 */
unsigned int showMemLeakRecord(unsigned int blcokInex,unsigned int num)
{
	int index=0;
	struct memLeakRecord *tempRecord=NULL;

	memLeakRecordInstallFlag=IN_SHOW_STATUS;

	if(blcokInex>BLOCK_MAX)
	{
		printf("input blockNum %d is err\n",blcokInex);
		return;
	}

	if(num > globalMemLeakRecord[blcokInex].totalBlocks)
	{
		printf("num %d is bigger than the size of record %d \n",num,globalMemLeakRecord[blcokInex].totalBlocks);
		num = globalMemLeakRecord[blcokInex].totalBlocks;
	}

	if(num > globalMemLeakRecord[blcokInex].recordnum)
	{
		num= globalMemLeakRecord[blcokInex].recordnum;
	}



	printf("block:%d ,totalBlocks:%d ,recordnum:%d\n",blcokInex,globalMemLeakRecord[blcokInex].totalBlocks,globalMemLeakRecord[blcokInex].recordnum);
	printf("record:\n");
	printf("pHead:%p,pTail:%p\n",
			globalMemLeakRecord[blcokInex].pHead,
			globalMemLeakRecord[blcokInex].pTail
		    );

    tempRecord=globalMemLeakRecord[blcokInex].pHead;

    for(tempRecord; tempRecord != NULL && index < num; tempRecord=tempRecord->pNext)
    {
        index++;
        printf("memCtlB:%p,memIndex:%-8x,mem:%p,taskId:0x%x,file:%s,function:%s,line:%d :%s",
                tempRecord->pMemBlock,
                tempRecord->pMemBlock->index,
                tempRecord->pMemBlock->pMemory,
                tempRecord->taskId,
                tempRecord->file,
                tempRecord->function,
                tempRecord->line,
                asctime(gmtime(&tempRecord->timeNow))
               );
    }

    memLeakRecordInstallFlag = ALREADY_INSTALL;
    return num;
}


unsigned int memLeakAnalyse(unsigned int blcokInex,unsigned int minute)
{
    int index=0;
    int seconds= 60*minute;
    struct memLeakRecord *tempRecord=NULL;
    time_t timeNow      = time(NULL);\
	memInstallFlag = IN_CHECK_STATUS;
    tempRecord=globalMemLeakRecord[blcokInex].pHead;
    printf("You think %d minutes without releasing memory is a memory leak\n",minute);
    printf("Memory leaks are listed as follows:\n");
    for(tempRecord; tempRecord != NULL; tempRecord=tempRecord->pNext)
    {
        if((timeNow - tempRecord->timeNow)>=seconds)
        {
            printf("memCtlB:%p,memIndex:%-8x,mem:%p,taskId:0x%x,file:%s,function:%s,line:%d :%s",
                    tempRecord->pMemBlock,
                    tempRecord->pMemBlock->index,
                    tempRecord->pMemBlock->pMemory,
                    tempRecord->taskId,
                    tempRecord->file,
                    tempRecord->function,
                    tempRecord->line,
                    asctime(gmtime(&tempRecord->timeNow))
                   );
        }
        else
        {
            break;
        }
    }
	memInstallFlag = ALREADY_INSTALL;
	return ;
}