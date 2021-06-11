redisContext()
{
/* Context for a connection to Redis */
typedef struct redisContext {   
    int err;                    /* Error flags, 0 when there is no error */
    char errstr[128];           /* String representation of error when applicable */
    int fd;
    int flags;
    char *obuf;                 /* Write buffer */          sds处理函数集  sdsempty
    redisReader *reader;        /* Protocol reader */
} redisContext;

redisContextInit();  创建一个redisContext对象。




/* State for the protocol parser */
typedef struct redisReader {
    int err;                /* Error flags, 0 when there is no error */             
    char errstr[128];       /* String representation of error when applicable */    
                                                                                    
    char *buf;              /* Read buffer */                                       sds处理函数集  sdsempty
    size_t pos;             /* Buffer cursor */                                     
    size_t len;             /* Buffer length */                                     
    size_t maxbuf;          /* Max length of unused buffer */                       
                                                                                    
    redisReadTask rstack[9];                                                        
    int ridx;               /* Index of current read task */                        
    void *reply;            /* Temporary reply pointer */                           

    redisReplyObjectFunctions *fn;                          defaultFunctions为默认的处理函数
    void *privdata;
} redisReader;

redisReaderCreate();    创建一个redisReader对象。



typedef struct redisReplyObjectFunctions {
    void *(*createString)(const redisReadTask*, char*, size_t);
    void *(*createArray)(const redisReadTask*, int);
    void *(*createInteger)(const redisReadTask*, long long);
    void *(*createNil)(const redisReadTask*);
    void (*freeObject)(void*);
} redisReplyObjectFunctions;

static redisReplyObjectFunctions defaultFunctions = {
    createStringObject,
    createArrayObject,
    createIntegerObject,
    createNilObject,
    freeReplyObject
};

/* This is the reply object returned by redisCommand() */
typedef struct redisReply {
    int type; /* REDIS_REPLY_* */
    long long integer; /* The integer when type is REDIS_REPLY_INTEGER */
    int len; /* Length of string */
    char *str; /* Used for both REDIS_REPLY_ERROR and REDIS_REPLY_STRING */
    size_t elements; /* number of elements, for REDIS_REPLY_ARRAY */
    struct redisReply **element; /* elements vector for REDIS_REPLY_ARRAY */
} redisReply;

typedef struct redisReadTask {
    int type;
    int elements; /* number of elements in multibulk container */
    int idx; /* index in parent (array) object */
    void *obj; /* holds user-generated value for a read task */
    struct redisReadTask *parent; /* parent task */
    void *privdata; /* user-settable arbitrary field */
} redisReadTask;

}

function()
{
createReplyObject   创建一个redisReply对象，并设定类型；
freeReplyObject     释放一个redisReply对象，并释放关联类型的对象
                                            REDIS_REPLY_ERROR    str字段申请内存
                                            REDIS_REPLY_STATUS   str字段申请内存
                                            REDIS_REPLY_STRING   str字段申请内存
                                            REDIS_REPLY_ARRAY    elements字段申请的内存
调用createReplyObject创建不同类型的redisReply对象，并将该对象关联到redisReadTask对象上。
createStringObject      REDIS_REPLY_ERROR   REDIS_REPLY_STATUS  REDIS_REPLY_STRING
createArrayObject       REDIS_REPLY_ARRAY
createIntegerObject     REDIS_REPLY_INTEGER
createNilObject         REDIS_REPLY_NIL

关联Reader
__redisReaderSetError  将错误填充到redisReader对象的buf和type中。
__redisReaderSetErrorProtocolByte   REDIS_ERR_PROTOCOL
__redisReaderSetErrorOOM            REDIS_ERR_OOM

关联Context
__redisSetError        将错误填充到redisContext对象的buf和type中。 REDIS_ERR_IO
__redisSetErrorFromErrno    存在错误码的IO问题
__redisSetError             不存在错误码的IO问题

redisBufferRead         REDIS_ERR_EOF


readBytes       从redisReader对象的buf缓冲区中读取指定长度的字符。
seekNewline     返回指定字符串种\r\n结尾的下一个字符串头位置
readLongLong    返回一个LongLong类型的数字
readLine        新行，与seekNewline不同的是，返回新行到当前行的偏移量
moveToNextTask  修改redisReader中对redisReadTask处理任务的位置

processItem         处理各种类型的对象类型

processLineItem         REDIS_REPLY_INTEGER REDIS_REPLY_ERROR   REDIS_REPLY_STATUS
processBulkItem         REDIS_REPLY_STRING
processMultiBulkItem    REDIS_REPLY_ARRAY

REDIS_REPLY_ERROR       '-'
REDIS_REPLY_STATUS      '+'
REDIS_REPLY_INTEGER     ':'
REDIS_REPLY_STRING      '$'
REDIS_REPLY_ARRAY       '*'


redisReader
redisReaderCreate       创建
redisReaderFree         释放
redisReaderFeed         新增请求
redisReaderGetReply     处理响应

redisContextInit
redisFree
redisBufferRead
redisBufferWrite


redisConnect
redisConnectWithTimeout
redisConnectNonBlock
redisConnectUnix
redisConnectUnixWithTimeout
redisConnectUnixNonBlock

redisSetTimeout


redisGetReplyFromReader
redisGetReply

__redisAppendCommand
redisvAppendCommand
redisAppendCommand
redisAppendCommandArgv
__redisBlockForReply
redisvCommand
redisCommand
redisCommandArgv

}

async(function-async.c)
{
调用关系：
    redisAsyncConnect
        redisConnectNonBlock
        redisAsyncInitialize
        
    redisAsyncConnectUnix
        redisConnectUnixNonBlock
        redisAsyncInitialize

static dictType callbackDict = {
    callbackHash,
    NULL,
    callbackValDup,
    callbackKeyCompare,
    callbackKeyDestructor,
    callbackValDestructor
};






}



