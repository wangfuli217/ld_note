# libevent 中 hashtable 的介绍
在libevent 中用宏定义了一个hashtable,你可以用它方便的定义一个类型安全的hashtable,我们尝试做下面一个hashtable,有下面两个类型.

struct BTMessage{
   int x;
   int y;
   char* message;
   char* description;
};

我们将body对象保存在 hashtable 中,并以 x和y同时作为主键来快速访问 body 对象, 为了达到这个目的,我们需要完成下面的事情

1.由于 hashtable 是侵入式的需要重新定义BTMessage
struct BTMessage{
   HT_ENTRY(BTMessage) key;

   int x;
   int y;
   char* message;
   char* description;
};


2.定义如何产生hash值
unsigned hashkey(struct BTMessage *e){
    // 非常不高效,但作为例子够了
	return e->x * 10 + e->y;
}

2.定义key的如何判断相等
int eqkey(struct BTMessage *e1, struct BTMessage *e2){
	return e1->x == e2->x && e1->y == e2->y;
}


3 定义保存body对象的hashtable的类型
HT_HEAD(BTMessageMap, BTMessage);
HT_PROTOTYPE(BTMessageMap, BTMessage, key, hashkey, eqkey);
HT_GENERATE(BTMessageMap, BTMessage, key, hashkey, eqkey,
			0.5, malloc, realloc, free);
			

4.如何使用呢
   // 定义map变量
	BTMessageMap map;
	// 初始化变量
	HT_INIT(BTMessageMap, &map);
	
	// 插入值
	HT_INSERT( BTMessageMap, &map, new BTMessage(1,2,"a"));
	HT_INSERT( BTMessageMap, &map, new BTMessage(1,3,"b"));
	HT_INSERT( BTMessageMap, &map, new BTMessage(1,4,"c"));
	HT_INSERT( BTMessageMap, &map, new BTMessage(1,5,"d"));
	HT_INSERT( BTMessageMap, &map, new BTMessage(1,6,"e"));
	HT_INSERT( BTMessageMap, &map, new BTMessage(1,7,"f"));

    // 查找原来的值
    BTMessage* m = HT_FIND(BTMessageMap,&map, new BTMessage(1,2) );
    BTMessage* m2 = HT_FIND(BTMessageMap,&map, new BTMessage(1,4) );

4,函数
HT_INIT(name, head)                  name##_HT_INIT(head)
HT_CLEAR(name, head)                 name##_HT_CLEAR(head)
HT_FIND(name, head, elm)             name##_HT_FIND((head), (elm))
HT_INSERT(name, head, elm)           name##_HT_INSERT((head), (elm))
HT_REPLACE(name, head, elm)          name##_HT_REPLACE((head), (elm))
HT_REMOVE(name, head, elm)           name##_HT_REMOVE((head), (elm))
HT_START(name, head)                 name##_HT_START(head)
HT_NEXT(name, head, elm)             name##_HT_NEXT((head), (elm))
HT_NEXT_RMV(name, head, elm)         name##_HT_NEXT_RMV((head), (elm))


5. clear
    struct event_map_entry **ent, **next, *this;                                                     
    for (ent = HT_START(event_io_map, ctx); ent; ent = next) {                                       
        this = *ent;                                                                                 
        next = HT_NEXT_RMV(event_io_map, ctx, ent);                                                  
        mm_free(this);                                                                               
    }                                                                                                
    HT_CLEAR(event_io_map, ctx); /* remove all storage held by the ctx. */ 
    
    
Libevent采用HT_PROTOTYPE和HT_GENERATE两个宏定义封装了对哈希表操作的函数声明和实现。
HT_PROTOTYPE(event_io_map,event_map_entry, map_node, hashsocket, eqsocket)
HT_PROTOTYPE(name,        type,           field,     hashfn,    eqfn)


声明了3个函数，实现了几个内联函数，说明如下：
int name##_HT_GROW(struct name *ht, unsigned min_capacity);
展开后就是：
int event_io_map_HT_GROW(struct event_io_map *ht,unsigned min_capacity);
该函数实现的是哈希表增长的功能，当知道哈希表空间不足时，调用该函数实现空间增长。

void name##_HT_CLEAR(struct name *ht);  
展开后就是：
void event_io_map _HT_CLEAR(struct event_io_map *ht); 
该函数实现哈希表清空功能。

int _##name##_HT_REP_IS_BAD(const struct name *ht);
展开后就是：
int  event_io_map_HT_REP_IS_BAD(const struct event_io_map *ht);
该函数是协助调试功能，主要看该哈希表是否正常，如果正常返回0，不正常返回对应的数字表示不同的含义。

内联函数1：
HT_INIT(name, head)
static inline void name##_HT_INIT(struct name *head)
static inline void event_io_map_HT_INIT(struct event_io_map *head);
对哈希表进行初始化。

内联函数2：
static inline struct type **name##_HT_FIND_P_(struct name *head, struct type *elm)
static inline struct event_map_entry **_ event_io_map_HT_FIND_P(struct event_io_map *head, structevent_map_entry *elm) ;
该函数内部又调用了一个宏定义（真麻烦！！！！！！！！！）
_HT_BUCKET(head,field, elm, hashfn);
该宏定义是根据hashfn算法返回elm在该哈希表中的位置。
该位置是event_map_entry类型的双重指针。
然后比较elm和该指针列表内的Socket内的fd是否相同，如果相同的话则返回该指针。

内联函数3：
static inline struct event_map_entry * event_io_map _HT_FIND(const structevent_io_map *head, struct event_map_entry*elm);
还是对上一个函数的调用，只不过返回的是指针类型。

内联函数4：
static inline struct type *name##_HT_FIND(const struct name *head, struct type *elm)
static inline void event_io_map_HT_INSERT(struct event_io_map *head, struct event_map_entry *elm) ;
将elm插入到哈希表中。

内联函数5：
static inline struct type * name##_HT_REPLACE(struct name *head, struct type *elm)
static inline struct event_map_entry*   event_io_map_HT_REPLACE(struct event_io_map *head, struct event_map_entry *elm)
插入一个要素，如果已经存在，则进行替换。

static inline struct type * name##_HT_REMOVE(struct name *head, struct type *elm)
static inline struct event_map_entry*   event_io_map_HT_REMOVE(struct event_io_map *head, struct event_map_entry *elm);
删除一个要素。

static inline void name##_HT_FOREACH_FN(struct name *head
                                        int (*fn)(struct type *, void *),
                                        void *data);



Libevent用如下宏定义实现了哈希方法，和相关变量。
HT_GENERATE(event_io_map,event_map_entry, map_node, hashsocket, eqsocket,0.5, mm_malloc, mm_realloc,mm_free)
define HT_GENERATE(name, type, field, hashfn, eqfn,load, mallocfn, reallocfn, freefn)
static unsigned event_io_map_PRIMES[] = {                                   
    53, 97, 193, 389,                                                   
    769, 1543, 3079, 6151,                                              
    12289, 24593, 49157, 98317,                                         
    196613, 393241, 786433, 1572869,                                    
    3145739, 6291469, 12582917, 25165843,                              
    50331653, 100663319, 201326611, 402653189,                         
    805306457, 1610612741                                             
  };       

该常量定义了一个素数的数组，各个素数定义了哈希数组的大小。
static unsigned event_io_mapN_PRIMES =    (unsigned)(sizeof(event_io_map _PRIMES)/sizeof(event_io_map_PRIMES[0]));
event_io_map N_PRIMES得到了素数数组的长度。

方法1
int  event_io_map_HT_GROW(struct event_io_map *head, unsigned size)
该方法实现了哈希数组的增长，每次插入数据时都需要判断是否需要增长，如果需要则调用该函数。

方法2
void event_io_map _HT_CLEAR(structevent_io_map *head)
释放数组资源并重新初始化。