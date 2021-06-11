malloc(tcmalloc tcmalloc_minimal jemalloc)
{
1. 内存管理有 ---性能----
    1. TCMalloc (google-perftools) 是用于优化C++写的多线程应用，比glibc 2.3的malloc快。这个模块可以用来让MySQL在高并发下内存占用更加稳定。
    2. Jemalloc聚集了malloc的使用过程中所验证的很多技术。忽略细节，从架构着眼，最出色的部分仍是arena和thread cache。（事实上，这两个与
       tcmalloc的架构几乎相同。Jemalloc only的部分将会在另一次posting中继续探讨。
    3. glibc自身支持的

2. Makefile
tcmalloc:  动态链接
	FINAL_CFLAGS+= -DUSE_TCMALLOC
	FINAL_LIBS+= -ltcmalloc
tcmalloc_minimal: 动态链接
	FINAL_CFLAGS+= -DUSE_TCMALLOC
	FINAL_LIBS+= -ltcmalloc_minimal
jemalloc: 静态链接
	DEPENDENCY_TARGETS+= jemalloc
	FINAL_CFLAGS+= -DUSE_JEMALLOC -I../deps/jemalloc/include
	FINAL_LIBS+= ../deps/jemalloc/lib/libjemalloc.a -ldl 
    
3. used_memory   用于统计内存使用量的变量

4. calloc和malloc
void *malloc(unsigned size)
//动态申请size个字节的内存空间；功能：在内存的动态存储区中分配一块长度为" size" 
//字节的连续区域。函数的返回值为该区域的首地址。。(类型说明符*)表示把返回值强制转换为该类型指针。

(void *)calloc(unsigned n,unsigned size)
//用于向系统动态申请n个, 每个占size个字节的内存空间; 并把分配的内存全都初始化为零值。函数的返回值
//为该区域的首地址

区别：两者都是动态分配内存。主要的不同是malloc不初始化分配的内存，已分配的内存中可以是任意的值.　
      calloc初始化已分配的内存为0。次要的不同是calloc返回的是一个数组，而malloc返回的是一个对象。
}   
       
sds(sds.c)
 {
 
 struct sdshdr {
    int len;
    int free;
    char buf[];
};
                           C字符串和SDS之间的区别
--------------------------------------------------------------------------------------------
                C字符串                           SDS
获取字符串长度的复杂度为O(N)              获取字符串长度的复杂度为O(1) 
API是不安全的，可能会造成缓冲区溢出       API是安全的，不会造成缓冲区溢出
修改字符串N次必然需要执行N次内存重分配    修改字符串长度N次最多需要执行N次内存分配
只能保存文本数据                          可以保存文本或者二进制数据
可以使用所有<string.h>库中的函数          可以使用一部分<string.h>库中的函数

                            SDS的主要的操作API
--------------------------------------------------------------------------------------------
sdsnew          创建一个包含给定C字符串的SDS
sdsempty        创建一个不包含任何内容的空SDS
sdsfree         释放给定的SDS
sdslen          返回SDS的已使用空间字符数
sdsupdatelen    修改过字符串，更新sds中字符串的长度
sdsavail        返回未使用空间字符数
sdsdup          创建一个给定SDS的副本
sdsclear        清空SDS保存的字符串内容
sdscat          将给定C字符串拼接到SDS字符串的末尾
sdscatsds       将给定SDS字符串拼接到另一个SDS字符串的末尾
sdscpy          将给定的C字符串复制到SDS里面，覆盖SDS原有的字符串
sdsgrowzero     用空字符将SDS扩展至给定的长度
sdsrange        保留SDS给定区间内的数据，不在区间内的数据会被覆盖或清除 [用在sds发送过程中，write部分数据的情况下调用]
sdstrim         接受一个SDS和一个C字符串作为参数，从SDS中移除所有在C字符串出现过的字符
sdscmp          比对两个SDS字符串是否相同

1. <C语言接口与实现：创建可重用软件的技术> 一书的第15章和第16章介绍了一个和SDS类似的通用字符串实现。
2. 维基百科的Binary Safe词条 http:en.wikipendia.org/wiki.Binary-safe 给出了二进制安全的定义。
3. 维基百科的Null-terminated string词条给出了空字符结尾字符串的定义。说明了这种表示的来源，以及C语言使用这种
   字符串表示的历史原因：http://en.wikipedia.org/wiki/Null-terminated_string
4. http://www.gnu.org/software/libc中的string.h

sdsnewlen(const void *init, size_t initlen) 
init如果等于0，则通过calloc创建指定长度initlen长度的字符串。
init如果不等于0，则通过malloc创建指定长度Initlen长度的字符串。

5. SDS_MAX_PREALLOC 1024*1024
初始分配，非扩展分配不进行预分配。
如果数据扩展长度小于SDS_MAX_PREALLOC，进行预分配
如果数据扩展长度大于SDS_MAX_PREALLOC，不进行预分配。

6.  sdscpy      sdscpylen     sdsMakeRoomFor sds复制字符串接口
    sdscat      sdscpylen     sdsMakeRoomFor 字符串扩展sds接口
    sdscatsds   sdscatlen     sdsMakeRoomFor sds扩展sds接口  
    sdsgrowzero               sdsMakeRoomFor 零扩展

7.  sdsll2str           有符号longlong类型到字符串
    sdsull2str          无符号longlong类型到字符串
    sdsfromlonglong     有符号longlong类型到字符串的长度
    
8.  sds sdscatvprintf(sds s, const char *fmt, va_list ap)       va_copy，vsnprintf
    sds sdscatprintf(sds s, const char *fmt, ...)               va_list，va_start，va_end调用
    sds sdscatfmt(sds s, char const *fmt, ...)                  sdscatprintf
    
9.  sdstolower
    sdstoupper
    sdscmp
    is_hex_digit      字符是否一个hex值
    hex_digit_to_int   
10. sds *sdssplitlen(const char *s, int len, const char *sep, int seplen, int *count)   
    将长度为len的字符串s，使用长度seplen的字符串sep，进行分割，count为返回的sds的个数。
    sds *sdssplitargs(const char *line, int *argc)                                      
    将字符串Line使用空格进行分割，argc为分割的个数。

11. chrtos  /* deps/hiredis/hiredis.c */ 将转义类型的char转换为字符串形式。
    intlen  /* deps/hiredis/hiredis.c */ 计算int类型需要字符串的长度
    bulklen /* deps/hiredis/hiredis.c */ 计算bulklen类型需要字符串的长度
    
redisvFormatCommand
redisFormatCommand
redisFormatCommandArgv


 }
 
list(adlist.c)
 {
                            链表的特性
--------------------------------------------------------------------------------------------
 1. 双端：链表节点带有prev和next指针，获取某个节点的前置节点和后置节点的复杂度都是O(1).
 2. 无环：表头节点的prev指针和表尾节点的next指针都指向NULL，对链表的访问以NULL为终点。
 3. 带表头指针和表尾指针：通过list结构的head指针和tail指针，程序获取链表的头结点和表尾节点的复杂度为O(1).
 4. 带链表长度计数器：程序使用list结构的len属性来对list持有的链表节点进行计数，程序获取链表中节点数量的复杂度为O(1).
 5. 多态：链表节点使用void*指针来保存节点值，并且可以通过list结构的dup、free、match三个属性为节点设置类型特定函数。
 所以链表可以用于保存各种不同类型的值。
 
 
                        链表和链表节点API
 --------------------------------------------------------------------------------------------
 listSetDupMethod      将给定的函数设置为链表的节点值复制函数
 listGetDupMethod      返回链表当前正在使用的节点值复制函数
 listSetFreeMethod     将给定的函数设置为链表的节点值释放函数
 listGetFree           返回链表当前正在使用的节点值释放函数
 listSetMathchMethod   将给定的函数设置为链表的节点值比对函数
 listGetMathchMethod   返回链表当前正在使用的节点值比对函数
 
 listLength            返回链表的长度
 listFirst             返回链表的表头结点
 listLast              返回链表的表尾节点
 listPrevNode          返回给定的前置节点
 listNextNode          返回给定的后置节点
 listSearchKey         查找并返回链表中包含给定值的节点
 listIndex             返回链表在给定索引上的节点
 
 listNodeValud         返回给定节点目前正在保存的值
 listAddNodeHead       将一个包含给定值的新节点添加到给定链表表头
 listAddNodeTail       将一个包含给定值的新节点添加到给定链表表尾
 listInsertNode        将一个包含给定值的新节点添加到给定节点之前或之后
 listDelNode           从链表中删除给定节点
 
 listRotate            将链表的表尾节点弹出，然后将弹出的节点插入到链表的表头，成为新的表头节点
 listDup               复制一个给定链表的副本
 listCreate            创建一个不包含任何节点的新链表
 listRelease           释放给定链表，以及链表中的所有节点。
 
 1. 用于列表键，发布和订阅，慢查询，监视器等等
 2. 每个链表节点有一个listNode结构来表示，每个节点都有一个执行前置节点和后置节点的指针。
 3. 每个链表使用一个list结构来表示，这个结构带有表头节点指针、表尾节点指针以及链表的长度等信息
 
 
 typedef struct listNode{
 struct listNode *prev;     前置节点
 struct listNode *next;     后置节点
 void *value;               节点的值
 
 }
 

typedef struct listIter {   双端链表迭代器    
    listNode *next;         当前迭代到的节点 
    int direction;          迭代的方向

} listIter;
 
 typedef struct list{                    双端链表结构
  struct listNode *head;                 表头节点
  struct listNode *tail;                 表尾节点
  unsigned long len;                     链表所包含的节点数量
  void *(*dup)(void *ptr);               节点值复制函数
  void *(*free)(void *ptr);              节点值释放函数
  void *(*match)(void *ptr, void *key);  节点值比对函数
  }
  
4. 迭代器的创建和使用
listIter *listGetIterator(list *list, int direction)
void listReleaseIterator(listIter *iter) 
void listRewind(list *list, listIter *li)
void listRewindTail(list *list, listIter *li) 
listNode *listNext(listIter *iter)

使用
while((node = listNext(iter)) != NULL) {}

 }
 
dictht(dict.c)
 {
    哈希表
    typedef struct dictht{
    dictEntry **table;        哈希表数组
    unsigned long size;       哈希表大小
    unsigned long sizemask;   哈希表大小掩码，用于计算索引值，总是等于size-1
    unsigned long uesd;       该哈希表已有的数据
    }
    
    哈希表节点
    typedef struct dictEntry{
    void *key;                     键
    union <>{                      值
    void *val;                  
    uint64_t u64;               
    int64_t s64;                
    } ;                          
    struct dictEntry *next;     指向下一个哈希表节点，形成链表
    }
 
    字典
    typedef struct dict{    
    dictType *type;         类型特定函数
    void *privdata;         私有数据
    dictht ht[2];           哈希表
    int rehashidx;          rehash索引，当rehash不在进行时，值为-1；
    }
    type属性和privdata属性是针对不同类型的键值对，为创建多态字典而设置的。
    1. type属性是一个指向dictType结构的指针，每个dictType结构保存了一族用于操作
       特定类型键值对的函数，Redis会为用途不同的字典设置不同的类型特定函数。
    2. 而privdata则保存了需要传给那个类型特定函数的可选参数。
    
 
 
    操作
    typedef struct dictType{                                                  
    unsigned int (*hashFunction)(const void *key);                            计算哈希值的函数
    void *(*keyDup)(void *privdata, const void *key);                         复制键的函数
    void *(*ValDup)(void *privdata, const void *obj);                         复制值的函数
    void *(*KeyCompare)(void *privdata, const void *key1, const void *key2);  对比键的函数
    void *(*keyDestructor)(void *privdata, const void *key);                  销毁键的函数
    void *(*valDestructor)(void *privdata, const void *obj);                  销毁值的函数
    }                                                                         
1. MuremurHash算法最初由Austin Appleby于2008年发明，这种算法的优点在于，即使输入的键有规律，算法仍能给
   出一个很好的随机分布性，并且算法的计算速度也非常快。
   Murmurhash算法目前的最新版本为MurmurHash3，而Redis使用的是MurmurHash2，关于MurmurHash算法的更多信息可以
   参考该算法的主页：http://code.google.com/p/smhasher
    
                        字典和字典节点API
 --------------------------------------------------------------------------------------------
 dictCreate          创建一个新的字典
 dictAdd             将给定的键值对添加到字典里面
 dictEntry *dictAddRaw(dict *d, void *key)
    尝试将键插入到字典中
    1. 如果键已经在字典存在，那么返回 NULL
    2. 如果键不存在，那么程序创建新的哈希节点，将节点和键关联，并插入到字典，然后返回节点本身。
 
 dictReplace         将给定的键值对添加到字典里面，如果键已经存在于字典，那么，用新值取代原有的值
 dictEntry *dictReplaceRaw(dict *d, void *key) 
    dictAddRaw() 根据给定 key 释放存在，执行以下动作：
    1. key 已经存在，返回包含该 key 的字典节点
    2. key 不存在，那么将 key 添加到字典 
    不论发生以上的哪一种情况，
    dictAddRaw() 都总是返回包含给定 key 的字典节点。

 dictFetchValue      返回给定键的值
 dictGetRandomKey    从字典中随机返回一个键值对
 
 dictDelete          从字典中删除给定键所对应的键值对
 int dictDeleteNoFree(dict *ht, const void *key)
 
 dictRelease         释放给定字典，以及字典中包含的所有键值对。
 
 2. int _dictInit(dict *d, dictType *type, void *privDataPtr)   hash表初始化函数。
    static void _dictReset(dictht *ht)                          hash表头初始化函数。
 
 3. dict_can_resize：指示字典是否采用rehash策略；
    dict_force_resize_ratio：已使用节点数和字典大小之间的比率超过 dict_force_resize_ratio，进行重新hash

迭代器实例： while ((de = dictNext(it)) != NULL)
 }
 
skiplist(t_zset.c)
{
MemSQL uses skiplists as its prime indexing structure for its database technology.
Cyrus IMAP server offers a "skiplist" backend DB implementation (source file)
Lucene uses skip lists to search delta-encoded posting lists in logarithmic time.[citation needed]
QMap (up to Qt 4) template class of Qt that provides a dictionary.
Redis, an ANSI-C open-source persistent key/value store for Posix systems, uses skip lists in its implementation of ordered sets.[7]
nessDB, a very fast key-value embedded Database Storage Engine (Using log-structured-merge (LSM) trees), uses skip lists for its memtable.
skipdb is an open-source database format using ordered key/value pairs.
ConcurrentSkipListSet and ConcurrentSkipListMap in the Java 1.6 API.
leveldb, a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values

 }
skiplist(有序集合)
{
Skip List概述
1. 跳表是一种有序数据结构，它通过在每个节点中维持多个纸箱其他节点的指针，从而达到快速访问节点的目的。
2. 跳表支持平均O(logN)、最坏O(N)复杂度的节点查找，还可以通过顺序性操作来批量处理节点。
3. 在多部分情况下，跳表的效率可以和平衡树相媲美，并且因为跳表的实现比平衡树要来的简单，所以有不少程序都是用跳表来代替平衡数。
 
Skip List定义
像下面这样（初中物理经常这样用，这里我也盗用下）：
一个跳表，应该具有以下特征：
    1. 一个跳表应该有几个层（level）组成；
    2. 跳表的第一层包含所有的元素；
    3. 每一层都是一个有序的链表；
    4. 如果元素x出现在第i层，则所有比i小的层都包含x；
    5. 第i层的元素通过一个down指针指向下一层拥有相同值的元素；
    6. 在每一层中，-1和1两个元素都出现(分别表示INT_MIN和INT_MAX)；
    7. Top指针指向最高层的第一个元素。
}
skiplist(算法：C语言实现(第1~4部分
跨度?
)
 {
 Redis的跳表由redis.h/zskiplistNode和redis.h/zskiplist两个结构定义，其中zzskiplistNode结构用于表示跳表节点，
 而zskiplist结构则用于保存跳表节点的相关信息，比如节点的数量，以及指向表头节点和表尾节点的指针等等。
 
 typedef struct zskiplistNode {
    robj *obj;                          各个节点中的O1，O2,O3是节点所保存的成员对象。
    double score;                       各个节点中的1.0,2.0和3.0是节点保存的分值。在跳表中，节点按各自所保存的分值从小到大排序。
    struct zskiplistNode *backward;     后退指针
    struct zskiplistLevel {             // 层
        struct zskiplistNode *forward;  前进指针；前进指针用于访问位于表尾方向的其他节点，
        unsigned int span;              跨度       跨度则记录了前进指针所指向节点和当前节点的距离
    } level[];
} zskiplistNode;

typedef struct zskiplist {
    struct zskiplistNode *header; 指向跳表的表头节点
    struct zskiplistNode *tail;   指向跳表的表尾节点
    unsigned long length;         记录跳表的长度，也即是，跳表目前包含节点的数量(表头节点不计算在内)
    int level;                    记录目前跳表内，层数最大的那个节点层数(表头节点的层数不计算在内)
                                  level是随机选取的，在创建zskiplistNode的时候，随机获取。
} zskiplist;
 
1. 跳表节点的level数组可以包含多个元素，每个元素都包含一个指向其他节点的指针，程序可以通过这些层来加快访问其他节点的速度。
   一般来说，层的数量越多，访问其他节点的速度就越快。
   每次创建一个新跳表节点的时候，程序都根据幂次定律(越大的数出现的概率越小)随机生成一个介于1到32之间的值作为level数组
的大小，这个大小就是层的高度。

2. 前进指针：每个层都有一个指向表尾的前进指针，用于从表头向表尾方向访问节点。
3. 跨度：用于记录两个节点之间的距离：跨度实际上是用来计算排位的：在查找某个节点的过程中，将沿途访问过的所有层的跨度累计起来。
得到的结果就是目标节点在跳表中的排位。
   两个节点之间的跨度越大，它们相距的就越远。
   指向NULL的所有前进指针的跨度都为0，因为它们没有连向任何节点。
4. 后退指针：节点的后退指针用于从表尾向表头方向访问节点：根可以一次跳过多个节点的前进指针不同，因为每个节点只有一个后退指针
所以每次只怎能后退至前一个节点。
5. 分值和成员：
    分值是一个double类型的浮点数，跳表中的所有节点都按分值从小到大来排序。
    节点的对象是一个指针，它指向一个字符串对象，而字符串对象则保存着一个SDS值。
 
                        跳表API
 --------------------------------------------------------------------------------------------
 zslCreate                创建一个新的跳表 
 zslFree                  释放给定跳表，以及表中包含的所有节点
 zslInsert                将包含给定成员和分值的新节点添加到跳表中
 zslDelete                删除跳表中包含的给定成员和分值的节点
 zslGetRank               返回包含给定成员和分值的节点在跳表的排数
 zslGetElementByRank      返回跳表在给定排数的节点
 zslIsInRange             给定一个分值范围，比如0到15,20到28诸如此类，如果跳表中有至少一个节点的分值在这个范围内，那么返回1，否则返回0.
 zslFirstInRange          给定一个分值范围，返回跳表中第一个符合这个范围的节点。
 zslLastInRange           给定一个分值范围，返回跳表中最后一个符合这个范围的节点。
 zslDeleteRangeByScore    给定一个分值范围，删除跳表中所有在这个范围之内的节点。
 zslDeleteRangeByRank     给定一个排位范围，删除跳表中所有在这个范围之内的节点。
 
 1. 是否支持范围查找
因为是有序结构，所以能够很好的支持范围查找。

2. 集合是否能够随着数据的增长而自动扩展
可以，因为核心数据结构是链表，所以是可以很好的支持数据的不断增长的

3. 读写性能如何
因为从宏观上可以做到一次排除一半的数据，并且在写入时也没有进行其他额外的数据查找性工作，所以对于skiplist来说，其读写的时间复杂度都是O(log2n)

4. 是否面向磁盘结构
磁盘要求顺序写，顺序读，一次读写必须是一整块的数据。而对于skiplist来说，查询中每一次从高层跳跃到底层的操作，都会对应一次磁盘随机读，而skiplist的层数从宏观上来看一定是O(log2n)层。因此也就对应了O(log2n)次磁盘随机读。
因此这个数据结构不适合于磁盘结构。

5. 并行指标
终于来到这个指标了， skiplist的并行指标是非常好的，只要不是在同一个目标插入点插入数据，所有插入都可以并行进行，而就算在同一个插入点，插入本身也可以使用无锁自旋来提升写入效率。因此skiplist是个并行度非常高的数据结构。

6. 内存占用
与平衡二叉树的内存消耗基本一致。
 
 }
 
intset(intset.c)
{
1. 是集合键的底层实现之一，当一个集合只包含整数值元素，并且这个集合的元素数量不多时，Redis就会使用
   整数集合作为集合键的底层实现。
typedef struct intset{
uint32_t encoding;  编码方式
uint32_t length;    集合包含的元素数量
int8_t contents[];  保存元素的数组
}intset;

INTSET_ENC_INT16:那么contents[]就是一个int16_t类型的数组，数组的每个项都是一个int16_t类型的整数值。
INTSET_ENC_INT32:那么contents[]就是一个int32_t类型的数组，数组的每个项都是一个int32_t类型的整数值。
INTSET_ENC_INT64:那么contents[]就是一个int64_t类型的数组，数组的每个项都是一个int64_t类型的整数值。

升级 VS 降级
                       整数集合API
 --------------------------------------------------------------------------------------------
 intsetNew       创建一个新的压缩列表
 intsetAdd       将给定元素添加到整数集合里面
 intsetRemove    从整数集合中移除给定元素
 intsetFind      检索给定值是否存在于集合
 intsetRandom    从整数集合中随机返回一个元素
 intsetGet       去除低层数组在给定索引上的元素
 intsetLen       返回数组集合包含的元素的个数
 intsetBloblen   返回整数集合占用的内存字节数
 
}

ziplist(压缩列表ziplist.c)
{
压缩列表是列表键和哈希键的底层实现之一。当一个列表键只包含少量列表项，并且每个列表项要么就是小整数值，要么就是长度比较短的字符串，那么Redis
就会使用压缩列表来做列表键的底层实现。

压缩列表
格式： zlbytes zltail zllen entry1 entry2 ... entryN zlend
zlbytes   uint32_t   记录整个压缩列表占用的内存字节数，在对压缩列表进行内存重分配，或计算zlend的位置时使用。
zltail    uint32_t   记录压缩列表尾节点距离压缩列表的起始地址有多少字节；通过这个偏移量，程序无须遍历整个压缩列表就可以确定表尾节点的地址。
zllen     uint16_t   记录了压缩列表包含的字节数量
entryX    列表节点   压缩列表包含的各个节点，节点的长度由节点保存的内容决定
zlend     uint8_t    特殊值0xFF,用于标记压缩列表的尾端。

压缩列表节点
1. 字节数组有三种长度表示形式：
长度小于等于63字节的字节数组。
长度小于等于16383字节的字节数组。
长度小于等于4294967295字节的字节数组。
2. 整数值可以有六种长度的其中的一种：
4位长，介于0到12之间的无符号整数。
1个字节长度的有符号整数
3个字节长度的有符号整数
int16_t类型整数
int32_t类型整数
int64_t类型整数

格式： previous_entry_length encoding content
previous_entry_length：以字节为单位，记录了压缩列表中前一个节点的长度。
previous_entry_length可以是一个字节或者五个字节。
1. 如果前一个节点的长度小于254字节，那么previous_entry_length属性的长度为1字节；前一字节
2. 如果前一个节点的长度大于254字节，那么previous_entry_length属性的长度为5字节；其中属性的第一个字节会被设置为0xFE，而之后的四个字节则会用于保存前一节点的长度。

因为节点的previous_entry_length属性记录了前一个节点的长度，所以程序可以通过指针运算，根据当前节点的起始
地址来计算出前一个节点的起始地址。

encoding：记录了节点的content属性所保存的数据的类型以及长度。
1. 一字节、两字节或者五字节长，值的最高位为00、01或10的是字节数组编码，这种编码表示字节的content属性保存
   着字节数组，数组的长度由编码除去最高两位之后的其它位记录。
2. 一字节长，值的最高位以11开头的是整数编码：这种编码

3. 编码的最高位00表示节点保存的的是一个字节数组。

                       压缩列表API
 --------------------------------------------------------------------------------------------
ziplistNew           创建一个新的压缩列表
ziplistPush          创建一个包含给定值的新节点，并将这个新节点添加到压缩列表的表头或表尾
ziplistInsert        将包含给定值的新节点插入到给定节点之后
ziplistIndex         返回压缩列表给定索引上的节点
ziplistFind          在压缩列表中查找并返回包含了给定值的节点
ziplistNext          返回给定节点的下一个节点
ziplistPrev          返回给定节点的上一个节点
ziplistGet           获取给定节点所保存的值
ziplistDelete        从压缩列表中删除给定的节点
ziplistDeleteRange   删除压缩列表在给定索引上的连续多个节点
ziplistBloblen       返回压缩列表目前占用的内存字节数
ziplistLen           返回压缩列表目前包含的节点数量

}

redisObject(object.c)
{
    typedef struct redisObject{
    unsigned type:4;          类型                         checkType
    unsigned encoding:4;      编码                         
    void *ptr;                指向底层实现数据结构的指针   
    unsigned lru:REDIS_LRU_BITS;  对象最近一次访问的时间   
    int refcount;             引用计数                     incrRefCount decrRefCount decrRefCountVoid  resetRefCount
    }  
    createObject：
        
对Redis数据库保存的键值来说，键总是一个字符串对象，而值则可以是字符串对象、列表对象、哈希对象、集合对象、有序集合对象之一。    
type：
                             TYPE命令的输出
REDIS_STRING   字符串对象      "string"          freeStringObject
REDIS_LIST     列表对象        "list"            freeListObject
REDIS_HASH     哈希对象        "hash"            freeHashObject
REDIS_SET      集合对象        "set"             freeSetObject
REDIS_ZSET     有序集合对象    "zset"            freeZsetObject


strEncoding:光路


---- 内存管理方式 ----
    编码常量                编码所对应的底层数据结构        object encoding 命令的输出
REDIS_ENCODING_INT           long类型的整数                "int"
REDIS_ENCODING_EMBSTR        embstr编码的简单动态字符串    "embstr"   小于32字节的字符串
REDIS_ENCODING_RAW           简单动态字符串                "raw"      大于32字节的字符串
REDIS_ENCODING_HT            字典                          "hashtable"
REDIS_ENCODING_LINKEDLIST    双端列表                      "linkdlist"
REDIS_ENCODING_ZIPLIST       压缩列表                      "ziplist"
REDIS_ENCODING_INTSET        整数集合                      "intset"
REDIS_ENCODING_SKIPLIST      跳表和字典                    "skiplist"

---- 数据管理类型 ----  ---- 内存实现方式 ----                                                      ---- 内存管理方式 ---- 
    类型              编码                      对象
REDIS_STRING        REDIS_ENCODING_INT         使用整数值实现的字符串对象                           createStringObjectFromLongLong
REDIS_STRING        REDIS_ENCODING_EMBSTR      使用embstr编码实现的简单动态字符串实现的字符串对象   createEmbeddedStringObject
REDIS_STRING        REDIS_ENCODING_RAW         使用简单动态字符串实现的字符串对象                   createRawStringObject           createStringObjectFromLongDouble
REDIS_LIST          REDIS_ENCODING_ZIPLIST     使用压缩列表实现的列表对象                           createZiplistObject
REDIS_LIST          REDIS_ENCODING_LINKEDLIST  使用双端链表实现的列表对象                           createListObject
REDIS_HASH          REDIS_ENCODING_ZIPLIST     使用压缩列表实现的哈希对象                           createHashObject
REDIS_HASH          REDIS_ENCODING_HT          使用字典实现的哈希对象                               
REDIS_SET           REDIS_ENCODING_INTSET      使用整数集合实现的集合对象                           createIntsetObject
REDIS_SET           REDIS_ENCODING_HT          使用字典实现的集合对象                               createSetObject
REDIS_ZSET          REDIS_ENCODING_ZIPLIST     使用压缩列表实现的有序集合对象                       createZsetZiplistObject
REDIS_ZSET          REDIS_ENCODING_SKIPLIST    使用跳表和字典实现的有序集合对象                     createZsetObject
通过encoding可以修改type对象的存储方式。

---- 对象管理命令 ---- 
void objectCommand(redisClient *c)  处理客户端的请求命令
    object refcount     addReplyLongLong
    object encoding     addReplyBulkCString
    object idletime     addReplyLongLong

    
robj *objectCommandLookupOrReply(redisClient *c, robj *key, robj *reply) 返回对应客户端的请求
robj *objectCommandLookup(redisClient *c, robj *key)  是否在hash字典中


getDoubleFromObject             getDoubleFromObjectOrReply
getLongDoubleFromObject         getLongDoubleFromObjectOrReply
getLongLongFromObject           getLongLongFromObjectOrReply        getLongFromObjectOrReply

}