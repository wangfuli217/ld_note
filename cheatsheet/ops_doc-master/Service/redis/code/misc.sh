HAVE_ATOMIC(
__sync_add_and_fetch
__sync_sub_and_fetch
)
{

#if (__i386 || __amd64) && __GNUC__
#define GNUC_VERSION (__GNUC__ * 10000 + __GNUC_MINOR__ * 100 + __GNUC_PATCHLEVEL__)
#if (GNUC_VERSION >= 40100) || defined(__clang__)
#define HAVE_ATOMIC
#endif
#endif

}

BYTE_ORDER(config.h){}
{
#if defined(__i386__) || defined(__x86_64__) || defined(__amd64__) || \
   defined(vax) || defined(ns32000) || defined(sun386) || \
   defined(MIPSEL) || defined(_MIPSEL) || defined(BIT_ZERO_ON_RIGHT) || \
   defined(__alpha__) || defined(__alpha)
#define BYTE_ORDER    LITTLE_ENDIAN
#endif

#if defined(sel) || defined(pyr) || defined(mc68000) || defined(sparc) || \
    defined(is68k) || defined(tahoe) || defined(ibm032) || defined(ibm370) || \
    defined(MIPSEB) || defined(_MIPSEB) || defined(_IBMR2) || defined(DGUX) ||\
    defined(apollo) || defined(__convex__) || defined(_CRAY) || \
    defined(__hppa) || defined(__hp9000) || \
    defined(__hp9000s300) || defined(__hp9000s700) || \
    defined (BIT_ZERO_ON_LEFT) || defined(m68k) || defined(__sparc)
#define BYTE_ORDER	BIG_ENDIAN
#endif
}

endian(endian.h){}
endian(endian.h)
{
#include <endian.h>
uint16_t htobe16(uint16_t host_16bits);
uint16_t htole16(uint16_t host_16bits);
uint16_t be16toh(uint16_t big_endian_16bits);
uint16_t le16toh(uint16_t little_endian_16bits);

uint32_t htobe32(uint32_t host_32bits);
uint32_t htole32(uint32_t host_32bits);
uint32_t be32toh(uint32_t big_endian_32bits);
uint32_t le32toh(uint32_t little_endian_32bits);

uint64_t htobe64(uint64_t host_64bits);
uint64_t htole64(uint64_t host_64bits);
uint64_t be64toh(uint64_t big_endian_64bits);
uint64_t le64toh(uint64_t little_endian_64bits);

/usr/include/linux/byteorder
}

getRandomHexChars(获取指定长度的随机HEX值)
{
/dev/urandom                          随机数生成设备
                                      
gettimeofday(&tv,NULL);               使用tv和pid作为随机数
pid_t pid = getpid();                 
                                      
char *charset = "0123456789abcdef";   随机数的取值范围
}


typedef void redisCommandProc(redisClient *c);
typedef int *redisGetKeysProc(struct redisCommand *cmd, robj **argv, int argc, int *numkeys);

struct redisCommand {
    char *name;                       命令的名字
    redisCommandProc *proc;           一个指向命令的实现函数的指针                         
    int arity;                        参数的数量。可以用 -N 表示 >= N
    char *sflags;                     字符串形式的 FLAG ，用来计算以下的真实 FLAG
    int flags;                        位掩码形式的 FLAG ，根据 sflags 的字符串计算得出
    redisGetKeysProc *getkeys_proc;   一个可选的函数，用于从命令中取出 key 参数，仅在以下三个参数都不足以表示 key 参数时使用
    int firstkey;                     第一个 key 参数的位置
    int lastkey;                      最后一个 key 参数的位置
    int keystep;                      从 first 参数和 last 参数之间，所有 key 的步数（step）；比如说， MSET 命令的格式为 MSET key value [key value ...]；它的 step 就为 2
    long long microseconds, calls;    执行这个命令耗费的总微秒数
    命令被执行的总次数
};

memtest_test(对内存进行测试)
{
1. Addressing test      memtest_addressing(m,bytes);
2. Random fill          memtest_fill_random(m,bytes);
3. Solid fill           memtest_fill_value(m,bytes,0,(unsigned long)-1,'S');
4. Checkerboard fill    memtest_fill_value(m,bytes,ULONG_ONEZERO,ULONG_ZEROONE,'C');

1) memtest86: http://www.memtest86.com/
2) memtester: http://pyropus.ca/software/memtester/
}
 
 Redis(数据备份与恢复)
 {
 #数据备份
 Redis SAVE 命令用于创建当前数据库的备份。
 redis 127.0.0.1:6379> SAVE 
 该命令将在 redis 安装目录中创建dump.rdb文件。
 
 #恢复数据
 如果需要恢复数据，只需将备份文件 (dump.rdb) 移动到 redis 安装目录并启动服务即可。获取 redis 目录可以使用 CONFIG 命令，
 CONFIG GET dir
 
#Bgsave
创建 redis 备份文件也可以使用命令 BGSAVE，该命令在后台执行。
 }
 
Redis(安全)
{
我们可以通过 redis 的配置文件设置密码参数，这样客户端连接到 redis 服务就需要密码验证，这样可以让你的 redis 服务更安全。
CONFIG get requirepass
CONFIG set requirepass "runoob"
设置密码后，客户端连接 redis 服务就需要密码验证，否则无法执行命令。
AUTH password
AUTH "runoob"
SET mykey "Test value"
GET mykey

}

Redis(客户端连接)
{
最大连接数
maxclients 的默认值是 10000，你也可以在 redis.conf 中对这个值进行修改。
config get maxclients
1) "maxclients"
2) "10000"

redis-server --maxclients 100000

1 	CLIENT LIST 	返回连接到 redis 服务的客户端列表
2 	CLIENT SETNAME 	设置当前连接的名称
3 	CLIENT GETNAME 	获取通过 CLIENT SETNAME 命令设置的服务名称
4 	CLIENT PAUSE 	挂起客户端连接，指定挂起的时间以毫秒计
5 	CLIENT KILL 	关闭客户端连接

}

Redis(管道技术)
{
Redis是一种基于客户端-服务端模型以及请求/响应协议的TCP服务。这意味着通常情况下一个请求会遵循以下步骤：
    客户端向服务端发送一个查询请求，并监听Socket返回，通常是以阻塞模式，等待服务端响应。
    服务端处理命令，并将结果返回给客户端。
$(echo -en "PING\r\n SET runoobkey redis\r\nGET runoobkey\r\nINCR visitor\r\nINCR visitor\r\nINCR visitor\r\n"; sleep 10) | nc localhost 6379

+PONG
+OK
redis
:1
:2
:3



}

redis(fwrite 和 fread的参数问题)
{
    fwrite(buff, 1, 8912, fout);  
    fread(buff, 1, 8912, fin);  
    
    
    fwrite(buff, 8912, 1, fout);  
    fread(buff, 8912, 1, fin); 
从回答中可以看到，第一种写完更合理一点。首先，实现fwrite和fread函数的人不是傻蛋，其不会实现为：每次只写一个字节，写8912次 。最重要的是，在第一种写法中可以知道写了/读了多少字节。特别是在读的时候，很有必要。
如果是第二种写法，在读的时候，只能返回0或者1，根本就不知道究竟读了多少字节。
}

 