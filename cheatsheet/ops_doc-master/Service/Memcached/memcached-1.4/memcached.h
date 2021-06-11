/* -*- Mode: C; tab-width: 4; c-basic-offset: 4; indent-tabs-mode: nil -*- */

/** \file
 * The main memcached header holding commonly used data
 * structures and function prototypes.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <event.h>
#include <netdb.h>
#include <pthread.h>
#include <unistd.h>

#include "protocol_binary.h"
#include "cache.h"

#include "sasl_defs.h"

/** Maximum length of a key. */
#define KEY_MAX_LENGTH 250

/** Size of an incr buf. */
#define INCR_MAX_STORAGE_LEN 24

#define DATA_BUFFER_SIZE 2048
#define UDP_READ_BUFFER_SIZE 65536
#define UDP_MAX_PAYLOAD_SIZE 1400
#define UDP_HEADER_SIZE 8
#define MAX_SENDBUF_SIZE (256 * 1024 * 1024)
/* I'm told the max length of a 64-bit num converted to string is 20 bytes.
 * Plus a few for spaces, \r\n, \0 */
#define SUFFIX_SIZE 24

/** Initial size of list of items being returned by "get". */
#define ITEM_LIST_INITIAL 200

/** Initial size of list of CAS suffixes appended to "gets" lines. */
#define SUFFIX_LIST_INITIAL 20

/** Initial size of the sendmsg() scatter/gather array. */
#define IOV_LIST_INITIAL 400

/** Initial number of sendmsg() argument structures to allocate. */
#define MSG_LIST_INITIAL 10

/** High water marks for buffer shrinking */
#define READ_BUFFER_HIGHWAT 8192
#define ITEM_LIST_HIGHWAT 400
#define IOV_LIST_HIGHWAT 600
#define MSG_LIST_HIGHWAT 100

/* Binary protocol stuff */
#define MIN_BIN_PKT_LENGTH 16
#define BIN_PKT_HDR_WORDS (MIN_BIN_PKT_LENGTH/sizeof(uint32_t))

/* Initial power multiplier for the hash table */
#define HASHPOWER_DEFAULT 16

/*
 * We only reposition items in the LRU queue if they haven't been repositioned
 * in this many seconds. That saves us from churning on frequently-accessed
 * items.
 */
#define ITEM_UPDATE_INTERVAL 60

/* unistd.h is here */
#if HAVE_UNISTD_H
# include <unistd.h>
#endif

/* Slab sizing definitions. */
#define POWER_SMALLEST 1 //��1��ʼ�� slabclass�����1��ʼ����slabs_init
#define POWER_LARGEST  200
#define CHUNK_ALIGN_BYTES 8
#define MAX_NUMBER_OF_SLAB_CLASSES (POWER_LARGEST + 1)

/** How long an object can reasonably be assumed to be locked before
    harvesting it on a low memory condition. Default: disabled. */
#define TAIL_REPAIR_TIME_DEFAULT 0

/* warning: don't use these macros with a function, as it evals its arg twice */
#define ITEM_get_cas(i) (((i)->it_flags & ITEM_CAS) ? \
        (i)->data->cas : (uint64_t)0)

#define ITEM_set_cas(i,v) { \
    if ((i)->it_flags & ITEM_CAS) { \
        (i)->data->cas = v; \
    } \
}

#define ITEM_key(item) (((char*)&((item)->data)) \
         + (((item)->it_flags & ITEM_CAS) ? sizeof(uint64_t) : 0))

#define ITEM_suffix(item) ((char*) &((item)->data) + (item)->nkey + 1 \
         + (((item)->it_flags & ITEM_CAS) ? sizeof(uint64_t) : 0))

#define ITEM_data(item) ((char*) &((item)->data) + (item)->nkey + 1 \
         + (item)->nsuffix \
         + (((item)->it_flags & ITEM_CAS) ? sizeof(uint64_t) : 0))

#define ITEM_ntotal(item) (sizeof(struct _stritem) + (item)->nkey + 1 \
         + (item)->nsuffix + (item)->nbytes \
         + (((item)->it_flags & ITEM_CAS) ? sizeof(uint64_t) : 0))

#define STAT_KEY_LEN 128
#define STAT_VAL_LEN 128

/** Append a simple stat with a stat name, value format and value */
#define APPEND_STAT(name, fmt, val) \
    append_stat(name, add_stats, c, fmt, val);

/** Append an indexed stat with a stat name (with format), value format
    and value */
#define APPEND_NUM_FMT_STAT(name_fmt, num, name, fmt, val)          \
    klen = snprintf(key_str, STAT_KEY_LEN, name_fmt, num, name);    \
    vlen = snprintf(val_str, STAT_VAL_LEN, fmt, val);               \
    add_stats(key_str, klen, val_str, vlen, c);

/** Common APPEND_NUM_FMT_STAT format. */
#define APPEND_NUM_STAT(num, name, fmt, val) \
    APPEND_NUM_FMT_STAT("%d:%s", num, name, fmt, val)

/**
 * Callback for any function producing stats.
 *
 * @param key the stat's key
 * @param klen length of the key
 * @param val the stat's value in an ascii form (e.g. text form of a number)
 * @param vlen length of the value
 * @parm cookie magic callback cookie
 */
typedef void (*ADD_STAT)(const char *key, const uint16_t klen,
                         const char *val, const uint32_t vlen,
                         const void *cookie);

/*
 * NOTE: If you modify this table you _MUST_ update the function state_text
 */
/**
 * Possible states of a connection.
 */
enum conn_states { //conn������״̬
    conn_listening,  /**< the socket which listens for connections */
    //���߳�accept�����µ�fd��֪ͨ���߳�
    conn_new_cmd,    /**< Prepare connection for next command */
    //�ȴ����ݵĵ��������read���¼���Ȼ��״̬����conn_read���ȴ����ݵ���
    conn_waiting,    /**< waiting for a readable socket */
    conn_read,       /**< reading in a command line */
    //��������������
    conn_parse_cmd,  /**< try to parse a command from the input buffer */
    conn_write,      /**< writing out a simple response */
    conn_nread,      /**< reading in a fixed number of bytes */
    conn_swallow,    /**< swallowing unnecessary bytes w/o storing */
    conn_closing,    /**< closing this connection */
    conn_mwrite,     /**< writing out many items sequentially */
    conn_closed,     /**< connection is closed */
    conn_max_state   /**< Max state value (used for assertion) */
};

enum bin_substates {
    bin_no_state,
    bin_reading_set_header,
    bin_reading_cas_header,
    bin_read_set_value,
    bin_reading_get_key,
    bin_reading_stat,
    bin_reading_del_header,
    bin_reading_incr_header,
    bin_read_flush_exptime,
    bin_reading_sasl_auth,
    bin_reading_sasl_auth_data,
    bin_reading_touch_key,
};

enum protocol {
    ascii_prot = 3, /* arbitrary value. */
    binary_prot,
    negotiating_prot /* Discovering the protocol */
};

enum network_transport {
    local_transport, /* Unix sockets*/
    tcp_transport,
    udp_transport
};

/*
    ���ֻʹ��һ��������������ʹ�ù�ϣ������������ʹ�á���ômemcached��Ч�ʽ�����൱�͡�Ϊ�ˣ�memcached��
���������ݿ�Ĳ��ԣ�ʹ�ò�ͬ���������memcached��������������������μ����ȫ�ּ�����ƽʱ(�����й�ϣ����
չʱ)��ʹ�öμ������������չ��ϣ��ʱ��ʹ��ȫ�ּ��������
    �μ�����ʲô���𣿽���ϣ���ռ���Ͱһ�μ���Ͱһ�ε�ƽ���֣�һ���ζ�Ӧ�ж��Ͱ��ÿһ���ζ�Ӧ��һ����������
������ϣ���ж���μ����������ڶμ������������ڳ����һ��ʼ���Ѿ�ȷ���ˣ������ٱ���ˡ������Ź�ϣ�����չ��Ͱ��
�����ǻ����ӵġ��������Ź�ϣ�����չ��Խ��Խ���Ͱ��Ӧһ���Σ�Ҳ����˵Խ��Խ���Ͱ��Ӧһ������
*/
//�ο�http://blog.csdn.net/luotuo44/article/details/42913549
enum item_lock_types {//item������  
    ITEM_LOCK_GRANULAR = 0, //�μ���  
    ITEM_LOCK_GLOBAL //ȫ�ּ���  
}; 

#define IS_UDP(x) (x == udp_transport)

//��Ӧ add set replace append prepend cas������
#define NREAD_ADD 1
#define NREAD_SET 2
#define NREAD_REPLACE 3
#define NREAD_APPEND 4
#define NREAD_PREPEND 5
#define NREAD_CAS 6

enum store_item_type {
    NOT_STORED=0, STORED, EXISTS, NOT_FOUND
};

enum delta_result_type {
    OK, NON_NUMERIC, EOM, DELTA_ITEM_NOT_FOUND, DELTA_ITEM_CAS_MISMATCH
};

/** Time relative to server start. Smaller than time_t on 64-bit systems. */
typedef unsigned int rel_time_t;

/** Stats stored per slab (and per thread). */
struct slab_stats { //�洢��thread_stats->slab_stats
    uint64_t  set_cmds; //set����
    uint64_t  get_hits;
    uint64_t  touch_hits;
    uint64_t  delete_hits;
    uint64_t  cas_hits;
    uint64_t  cas_badval;
    uint64_t  incr_hits; //inc����ִ�д���
    uint64_t  decr_hits; //dec����ִ�д���
};

/**
 * Stats stored per-thread.
 */
struct thread_stats { //�洢��LIBEVENT_THREAD->stats
    pthread_mutex_t   mutex;
    uint64_t          get_cmds;
    uint64_t          get_misses;
    uint64_t          touch_cmds;
    uint64_t          touch_misses;
    uint64_t          delete_misses;
    uint64_t          incr_misses;
    uint64_t          decr_misses;
    uint64_t          cas_misses; //cas����û���ҵ�
    uint64_t          bytes_read; //�ӿͻ��˶�ȡ���ֽ���
    uint64_t          bytes_written;
    uint64_t          flush_cmds;
    //һ���߳�һ�δ����������������ƣ�����������drive_machine
    uint64_t          conn_yields; /* # of yields for connections (-R option)*/
    uint64_t          auth_cmds;
    uint64_t          auth_errors;
    struct slab_stats slab_stats[MAX_NUMBER_OF_SLAB_CLASSES];
};

/**
 * Global stats.
 */
struct stats_t { //struct stats_t stats;
    pthread_mutex_t mutex;
    unsigned int  curr_items; //��ǰʹ��item������do_item_link
    unsigned int  total_items; //�ܹ�ʹ��item����ֻ�Ӳ���
    uint64_t      curr_bytes; //��ǰռ���ֽ�������do_item_link
    unsigned int  curr_conns; //��ǰ��ʹ��conn�ṹ��Ŀ  conn_new������conn_close�Լ�������listenʹ���˵�conn
    unsigned int  total_conns; //�ܹ�ʹ�ù�����conn�ṹ��ֻ������
    //�����������ڴӶ��ܾ����ӵ�������
    uint64_t      rejected_conns;
    uint64_t      malloc_fails;
    unsigned int  reserved_fds;
    unsigned int  conn_structs;
    uint64_t      get_cmds;
    uint64_t      set_cmds;
    uint64_t      touch_cmds;
    uint64_t      get_hits;
    uint64_t      get_misses;
    uint64_t      touch_hits;
    uint64_t      touch_misses;
    uint64_t      evictions;
    uint64_t      reclaimed;
    time_t        started;          /* when the process was started */
    bool          accepting_conns;  /* whether we are currently accepting */
    uint64_t      listen_disabled_num;
    //��ϣ��ĳ�����2^n�����ֵhash_power_level��n��ֵ��
    unsigned int  hash_power_level; /* Better hope it's not over 9000 */
    uint64_t      hash_bytes;       /* size used for hash tables */
    bool          hash_is_expanding; /* If the hash table is being expanded */
    uint64_t      expired_unfetched; /* items reclaimed but never touched */
    uint64_t      evicted_unfetched; /* items evicted but never touched */
    bool          slab_reassign_running; /* slab reassign in progress */ //�Ƿ����ڽ���ҳǨ�� slab_rebalance_finish
    uint64_t      slabs_moved;       /* times slabs were moved around */ //����ҳǨ�ƵĴ��� slab_rebalance_finish
    bool          lru_crawler_running; /* crawl in progress */
};

#define MAX_VERBOSITY_LEVEL 2

/* When adding a setting, be sure to update process_stat_settings */
/**
 * Globally accessible settings as derived from the commandline.
 */
struct settings_s {
    size_t maxbytes; //memcached�ܹ�ʹ�õ�����ڴ�
    //ע���������memcache�ڲ�ʹ�õ�fd��ʵ�����ṩ���ͻ��˽�����fdҪ�������100�࣬��������-c 1024��ʵ����������900�������
    int maxconns;//���������ٸ��ͻ���ͬʱ���ߡ���ͬ��setting.backlog
    int port; //�����˿ڣ�Ĭ��11211
    int udpport; //memcached������udp�˿�
    //�׽��ִ�����server_sockets //�������ٸ�TCP�׽��־ͻᴴ�����ٸ�udp�׽��֣�IP��ַ����һ����
    char *inter;//memcached�󶨵�ip��ַ�������ֵΪNULL����ô����INADDR_ANY�������ֵָ��һ��ip�ַ���
    //-v   -vv   -vvv����������־��ӡ����
    int verbose;//������Ϣ��������𡣸�ֵԽ���������Ϣ��Խ��ϸ
    //flush_all�����ʱ����ޡ�����ʱ��С�����ʱ���itemɾ��
    rel_time_t oldest_live; /* ignore existing items older than this */
    //���memcached�Ƿ�����LRU��̭���ơ�Ĭ���ǿ��Եġ�����ͨ��-Mѡ���ֹ
    int evict_to_free;
    //unix_socket������socket·����Ĭ�ϲ�ʹ��unix_socket
    char *socketpath;   /* path to unix socket if using local socket */
    //unix socket��Ȩ����Ϣ
    int access;  /* access mask (a la chmod) for unix domain socket */
    //item����������
    double factor;          /* chunk size growth factor */
    int chunk_size;//��С��һ��item�ܴ洢�����ֽڵ�����(set��add�����е�����) Ĭ��48
    //worker�̵߳ĸ���
    int num_threads;        /* number of worker (without dispatcher) libevent threads to run */
    //���ٸ�worker�߳�Ϊһ��udp socket����
    int num_threads_per_udp; /* number of worker threads serving each udp socket */
    /*
    �Ѹ���Ҫ�洢�ļ���ǰ��Ӹ�ǰ׺(prefix),����ʶһ���������ռ�,�������ּ������ڱ������ռ������ǲ����ظ���
    (��ȻҲ�����ظ�,���ǻ�ѹ�ȥ�ĸ���,:)),
    ����������memcache��������ظ�����,ͨ����δ�����Բ鿴ĳЩ�����ռ�(prefix)�Ļ�ȡ�����������ʡ����ô�����ָ�ꡣ
    */
    //�ָ���  ���Բο�http://www.cnblogs.com/xianbei/archive/2011/01/02/1921258.html
    char prefix_delimiter;  /* character that marks a key prefix (for stats) */ //һ���ҵ���ܵ�ʱ�����õ�
    //http://www.cnblogs.com/xianbei/archive/2011/01/02/1921258.html
    //�Ƿ��Զ��ռ�״̬��Ϣ  -D��������stats detail on
    int detail_enabled;     /* nonzero if we're collecting detailed stats */
    //worker�߳�����Ϊĳ���ͻ���ִ����������������������Ҫ��Ϊ�˷�ֹһ���ͻ��˰�ռ����worker�߳� ��Ч�ط���drive_machine
    int reqs_per_event;     /* Maximum number of io to process on each
                               io-event. */
    //����CASҵ�������������ô��item����ͻ��һ������CAS���ֶΡ�����������memcached��ʱ��ͨ��-Cѡ�����
    bool use_cas; //�ο�do_item_alloc
    //�û�����Э�飬���ļ��Ͷ��������֡�negotiating_port��Э�̣��Զ��������������ж�
    enum protocol binding_protocol;
    int backlog;//listen�����ĵڶ�����������ͬ��settings.maxconns
    //slab���ڴ�ҳ��С����λ���ֽ�  Ĭ��1M��Ҳ���Ǵ洢һ��key-value���1M
    int item_size_max;        /* Maximum item size, and upper end for slabs */
    bool sasl;              /* SASL on/off */
    //������������������ͬʱ������(��-Cѡ��ָ��)���Ƿ������ر������������ϵĿͻ���
    bool maxconns_fast;     /* Whether or not to early close connections */
    //����ָ��memcached�Ƿ�������LRU�����̡߳�Ĭ��ֵΪfalse��������LRU�����̡߳�
	//����������memcachedʱͨ��-o lru_crawler�������ĸ�ֵΪtrue������LRU�����߳�
	//����Ƿ��Ѿ����������̣߳����Ա����ظ����ο�start_item_crawler_thread
    bool lru_crawler;        /* Whether or not to enable the autocrawler thread */
    //�Ƿ������ڲ�ͬ����item��ռ�õ��ڴ���������ͨ��-o slab_reassignѡ���
    bool slab_reassign;     /* Whether or not slab reassignment is allowed */

    /*
    Ĭ��������ǲ������Զ���⹦�ܵģ���ʹ������memcached��ʱ�������-o slab_reassign�������Զ���⹦����
    ȫ�ֱ���settings.slab_automove����(Ĭ��ֵΪ0��0���ǲ�����)�����Ҫ��������������memcached��ʱ�����
    slab_automoveѡ����������������Ϊ1����������$memcached -o slab_reassign,slab_automove=1�Ϳ�����
    �Զ���⹦�ܡ���ȻҲ�ǿ���������memcached��ͨ���ͻ�����������automove���ܣ�ʹ������slabsautomove <0|1>��
    ����0��ʾ�ر�automove��1��ʾ����automove���ͻ��˵��������ֻ�Ǽ򵥵�����settings.slab_automove��ֵ��
    ���������κι�����
    */
    
    //�Զ�����Ƿ���Ҫ���в�ͬ����item���ڴ������������setting.slab_reassign�Ŀ���
    //��Ч�ط���slab_maintenance_thread
    int slab_automove;     /* Whether or not to automatically move slabs */ 
    //��ϣ��ĳ�����2^n�����ֵ��n�ĳ�ʼֵ������������memcached��ʱ��ͨ��-o hashpower_init����
	//���õ�ֵҪ��[12,64]֮�䡣��������ã���ֵΪ0.��ϣ����ݽ�ȡĬ��ֵ16
    int hashpower_init;     /* Starting hash power level */
    //�Ƿ�֧�ֿͻ��˵Ĺر�����������ر�memcached����
    //��ͨ��-A������shutdown���ܣ����ͻ��˷�������shutdown������memcached�����ᷢ��INT�źŸ��Լ��������˳�
    bool shutdown_command; /* allow shutdown command */
    //�����޸�item�������������һ��worker�߳�������ĳ��item����û���ü������������߳̾͹���
	//��ô���item����Զ������������߳������ö������ͷš�memcached�����ֵ������Ƿ��������
	//�������Ϊ����������ٷ��������Ըñ�����Ĭ��ֵΪ0���������м��
/*
tail_repair_time��
    �������������:ĳ��worker�߳�ͨ��refcount_incr������һ��item����������������ĳ��ԭ��(�������ں˳�������)��
���worker�̻߳�û���ü�����refcount_decr�͹��ˡ���ʱ���item���������Ϳ϶��������0��Ҳ��������worker�߳�ռ
������.��ʵ�������worker�߳���͹��ˡ����Զ������������Ҫ�޸����޸�Ҳ�ܶ�򵥣�ֱ�Ӱ����item�����ü�����ֵΪ1��
    ����ʲô�ж�ĳһ��worker�̹߳�����?������memcached���棬һ����˵���κκ������ĵ��ö������ʱ̫��ģ���ʹ�������
��Ҫ����������������item�����һ�η���ʱ��������ڶ��Ƚ�ңԶ�ˣ�����ȴ����һ��worker�߳������ã���ô�ͼ�����
���ж����worker�̹߳��ˡ���1.4.16�汾֮ǰ�����ʱ����붼�ǹ̶���Ϊ3��Сʱ����1.4.16����ʹ��settings.tail_repair_time
�洢ʱ����룬����������memcached��ʱ�����ã�Ĭ��ʱ�����Ϊ1��Сʱ����������汾1.4.21Ĭ�϶�����������޸��ˣ�
settings.tail_repair_time��Ĭ��ֵΪ0����Ϊmemcached�����ߺ��ٿ������bug�ˣ���������Ϊ����ϵͳ�Ľ�һ���ȶ���

    �����е�settings.tail_repair_timeָ����û�п������ּ�⣬Ĭ����û�п�����(Ĭ��ֵ����0)������������memcached��ʱ��
ͨ��-o tail_repair_timeѡ���
*/
    int tail_repair_time;   /* LRU tail refcount leak repair time */
    //�Ƿ�����ͻ���ʹ��flush_all���� 
    bool flush_enabled;     /* flush_all enabled */
    //hash�㷨������hash_init
    char *hash_algorithm;     /* Hash algorithm in use */
    //LRU�����̹߳���ʱ�����߼������λ��΢��
    int lru_crawler_sleep;  /* Microsecond sleep between items */
    //LRU������ÿ��LRU�����еĶ��ٸ�item���������LRU���湤�������޸����ֵ
    //ʵ������Ч����lru_crawler tocrawl numָ����
    uint32_t lru_crawler_tocrawl; /* Number of items to crawl per run */
};

extern struct stats_t stats;
extern time_t process_started;
extern struct settings_s settings;

//��item���뵽LRU������
#define ITEM_LINKED 1 //��do_item_link
//��itemʹ��CAS
#define ITEM_CAS 2

/* temp */
//��item����slab�Ŀ��ж������棬û�з����ȥ
#define ITEM_SLABBED 4  //��do_slabs_free
//��item ���뵽LRU���к󣬱�worker�̷߳��ʹ�
#define ITEM_FETCHED 8

/*
//itemɾ������
һ��item����������»����ʧЧ��1.item��exptimeʱ������ˡ�2.�û�ʹ��flush_all���ȫ��item��ɹ���ʧЧ��
�ο�http://blog.csdn.net/luotuo44/article/details/42963793
*/
/**
 * Structure for storing items within memcached.
 */ //�����洢��slabclass[id]�е�tunck�е����ݸ�ʽ��item_make_header
typedef struct _stritem {
	//nextָ�룬����LRU����
    struct _stritem *next;
	//prevָ�룬����LRU����
    struct _stritem *prev;
	//h_nextָ�룬���ڹ�ϣ��ĳ�ͻ��
    struct _stritem *h_next;    /* hash chain next */
	//���һ�η���ʱ�䡣����ʱ��  lru���������item�Ǹ���time���������
    rel_time_t      time;       /* least recent access */
	//����ʧЧʱ�䣬����ʱ�� һ��item����������»����ʧЧ��1.item��exptimeʱ������ˡ�2.�û�ʹ��flush_all���ȫ��item��ɹ���ʧЧ��
	rel_time_t      exptime;    /* expire time */
	//��item��ŵ����ݵĳ���   nbytes��������\r\n�ַ��ģ���do_item_alloc���   �ο�item_make_header�е�
    int             nbytes;     /* size of data */

    /*
    ���Կ�����������Ϊ����һ��item������������Ҫɾ�����item��Ϊʲô�أ������������龰���߳�A��ΪҪ��һ��item�����������item��
    ���ü�������ʱ�߳�B�����ˣ���Ҫɾ�����item�����ɾ�������ǿ϶���ִ�еģ�������˵���item������߳������˾Ͳ�ִ��ɾ�����
    ���ֿ϶���������ɾ������Ϊ�߳�A����ʹ�����item����ʱmemcached�Ͳ����ӳ�ɾ�����������߳�Bִ��ɾ������ʱ����һ��item����������
    ʹ�õ��߳�A�ͷ��Լ���item�����ú�item�����������0����ʱitem�ͱ��ͷ���(�黹��slab������)��
    */
    
	//��item�������� ��ʹ��do_item_remove������slab�黹itemʱ�����Ȳ������item���������Ƿ����0��
	//���������Լ����Ϊ�Ƿ���worker�߳���ʹ�����item   ��¼���item������(��worker�߳�ռ��)������
	//�ο�http://blog.csdn.net/luotuo44/article/details/42913549
    unsigned short  refcount;  //��do_item_link������  //�¿��̵�Ĭ�ϳ�ֵΪ1
	//��׺���ȣ�  (nkey + *nsuffix + nbytes)�е�nsuffix  �ο�item_make_header�е�
    uint8_t         nsuffix;    /* length of flags-and-length string */
	//item������  �Ƿ�ʹ��cas��settings.use_cas   // item������flag: ITEM_SLABBED, ITEM_LINKED,ITEM_CAS
    uint8_t         it_flags;   /* ITEM_* above */
    //��item�Ǵ��ĸ�slabclass��ȡ�õ�
    uint8_t         slabs_clsid;/* which slab class we're in */
	//��ֵ�ĳ��� ʵ������ʵ�õ����ڴ���nkey+1,��do_item_alloc  �ο�item_make_header�е�
    uint8_t         nkey;       /* key length, w/terminating null and padding */
    
    /* this odd type prevents type-punning issues when we do
     * the little shuffle to save space when not using CAS. */
    union {
        //ITEM_set_cas  ֻ���ڿ���settings.use_cas������
        //ITEM_set_cas   get_cas_id  ITEM_get_cas  ÿ�ζ�ȡ�����ݲ��ֺ󣬴洢��item�к�stored��ʱ�򶼻����do_store_item����
        uint64_t cas; //�ο�process_update_command�е�req_cas_id,ʵ���Ǵӿͻ��˵�set�������л�ȡ����
        char end;
    } data[];
    //+ DATA �����ľ���ʵ������ (nkey + *nsuffix + nbytes) �ο�item_make_header
    /* if it_flags & ITEM_CAS we have 8 bytes CAS */
    /* then null-terminated key */
    /* then " flags length\r\n" (no terminating null) */
    /* then data with terminating \r\n (no terminating null; it's binary!) */
} item;

//����ṹ���item�ṹ�峤�ú���,��αitem�ṹ�壬����LRU���� 
typedef struct { //��ֵ�ͳ�ʼ���ο�lru_crawler_crawl
    struct _stritem *next;
    struct _stritem *prev;
    struct _stritem *h_next;    /* hash chain next */
    rel_time_t      time;       /* least recent access */
    rel_time_t      exptime;    /* expire time */
    int             nbytes;     /* size of data */
    unsigned short  refcount;
    uint8_t         nsuffix;    /* length of flags-and-length string */
    uint8_t         it_flags;   /* ITEM_* above */ //��ʶ��һ������αitem,Ϊ1��ʶ��Ҫ�������ڵ�slabclass���ο�item_crawler_thread
    uint8_t         slabs_clsid;/* which slab class we're in */
    uint8_t         nkey;       /* key length, w/terminating null and padding */
    //lru_crawler tocrawl numָ��
    uint32_t        remaining;  /* Max keys to crawl per slab per invocation */
} crawler;

//memcached�߳̽ṹ�ķ�װ�ṹ
typedef struct {
    pthread_t thread_id;        /* unique ID of this thread */ //�߳�id
    //libevent�Ĳ����̰߳�ȫ�ģ�ÿ�������̳߳���һ��libeventʵ��������pipe�ܵ�ͨ�ź�socketͨ��
    struct event_base *base;    /* libevent handle this thread uses */ //�߳���ʹ�õ�event_base
    struct event notify_event;  /* listen event for notify pipe */ //���ڼ����ܵ����¼���event
    //���̺߳͹������߳�ͨ���ܵ�����ͨ��      �������߳�ͨ����fd������setup_thread->thread_libevent_process
    int notify_receive_fd;      /* receiving end of notify pipe */ //�ܵ��Ķ���fd
    //���߳�ͨ����fdд����dispatch_conn_new
    int notify_send_fd;         /* sending end of notify pipe */ //�ܵ���д��fd
    //ÿ���̶߳�Ӧ��ͳ����Ϣ
    struct thread_stats stats;  /* Stats generated by this thread */
    //setup_thread��ʼ����
    //dispatch_conn_new���߳̽���accept�ͻ��˷�����fd�󴴽�һ��CQ_ITEM������У��������߳�thread_libevent_process�Ӷ���ȡ������
    struct conn_queue *new_conn_queue; /* queue of new connections to handle */
    //��׺cache
    cache_t *suffix_cache;      /* suffix cache */
    //�̲߳���hash����е������ͣ��оֲ�����ȫ����
    uint8_t item_lock_type;     /* use fine-grained or global item lock */
} LIBEVENT_THREAD; //static LIBEVENT_THREAD *threads;
//�ַ��̵߳ķ�װ
typedef struct {
    //�߳�id
    pthread_t thread_id;        /* unique ID of this thread */
    //libeventʵ��
    struct event_base *base;    /* libevent handle this thread uses */
} LIBEVENT_DISPATCHER_THREAD;

/**
 * The structure representing a connection into memcached.
 */
typedef struct conn_t conn;
struct conn_t {
	//��conn��Ӧ��socket fd
    int    sfd;
    sasl_conn_t *sasl_conn;
    bool authenticated;
	//��ǰ״̬ conn_set_state��������    �鿴״̬��state_text
    enum conn_states  state;
    enum bin_substates substate;
    rel_time_t last_cmd_time;//���һ�δ���ͻ�������key value��ʱ��
	//��conn��Ӧ��event
    struct event event;
	//event��ǰ�������¼�����
    short  ev_flags;
	//����event�ص�������ԭ��
    short  which;   /** which events were just triggered */

	//��������    ���ڴ洢�ͻ������ݱ����е����
    char   *rbuf;   /** buffer to read commands into */
    //
	//��Ч���ݵĿ�ʼλ�á���rbuf��rcurr֮����������Ѿ�������ˣ������Ч������   δ������������ַ�ָ�롣
    char   *rcurr;  /** but if we parsed some already, this is where we stopped */

	//���������ĳ���     rbuf�Ĵ�С��
	int    rsize;   /** total allocated size of rbuf */
	//��Ч���ݵĳ���   δ����������ĳ��ȡ�
    int    rbytes;  /** how much data, starting from rcur, do we have unparsed */

    char   *wbuf;
    char   *wcurr;
    int    wsize;
    int    wbytes;
    /** which state to go into after finishing current write */
    enum conn_states  write_and_go;//д������һ��״̬  
    void   *write_and_free; /** free this memory after finishing writing */

	//����ֱͨ��   ���ݲ��ָ�ֵ���̣���ֵ��process_update_command��drive_machine
    char   *ritem;  /** when we read in an item's value, it goes here */
    //�ʼrlbytesΪ���ݲ����ܳ��ȣ��������ݲ������ú���ֵ�͸պ�Ϊ0
    int    rlbytes; //���ݲ��ֻ������ ��ֵ��process_update_command��drive_machine

    /* data for the nread state */

    /**
     * item is used to hold an item structure created after reading the command
     * line of set/add/replace commands, but before we finished reading the actual
     * data. The data is read into ITEM_data(item) to avoid extra copying.
     */
    //��ֵ��process_update_command  
    //�����ӵ�ǰ�����������item�ṹ��Ϣ
    void   *item;     /* for commands set/add/replace  */

    /* data for the swallow state */
    int    sbytes;    /* how many bytes to swallow */

    /* data for the mwrite state */
	//iovec����ָ��  conn_new�����ռ�
    struct iovec *iov;
	//�����С
    int    iovsize;   /* number of elements allocated in iov[] */
	//�Ѿ�ʹ�õ�iov����Ԫ�ظ���
    int    iovused;   /* number of elements used in iov[] */

	//��Ϊmsghdr�ṹ�������iovec�ṹ�����鳤���������Ƶġ�����Ϊ��
	//�ܴ����������ݣ�ֻ������msghdr�ṹ��ĸ���.add_msghdr������������
    struct msghdr *msglist; //ָ��msghdr����  add_msghdr����ռ�
    //�����С  Ĭ��MSG_LIST_INITIAL
    int    msgsize;   /* number of elements allocated in msglist[] */
	//�Ѿ�ʹ���˵�msghdrԪ�ظ���
    int    msgused;   /* number of elements used in msglist[] */
	//������sendmsg��������msghdr�����е���һ��Ԫ��
    int    msgcurr;   /* element in msglist[] being transmitted now */
	//msgcurrָ���msghdr�ܹ����ٸ��ֽ�
    int    msgbytes;  /* number of bytes in current msg */

	//worker�߳���Ҫռ�����item��ֱ����item�����ݶ�д�ظ��ͻ�����
	//����Ҫһ��itemָ�������¼��connռ�е�item
    item   **ilist;   /* list of items to write out */
	//����Ĵ�С
    int    isize;
	//��ǰʹ�õ���item(���ͷ�ռ��itemʱ���õ�)
    item   **icurr;
	//ilist�������ж��ٸ�item��Ҫ�ͷ�
    int    ileft;

    char   **suffixlist;
    int    suffixsize;
    char   **suffixcurr;
    int    suffixleft;

    //settings.binding_protocol //���ݽ��յĵ�һ���ַ���ȷ��������Э��try_read_command
    enum protocol protocol;   /* which protocol this connection speaks */
    
    enum network_transport transport; /* what transport is used by this connection */

    /* data for UDP clients */
    int    request_id; /* Incoming UDP request ID, if this is a UDP "connection" */
    //�ͻ���IP��ַ����conn_new
    struct sockaddr_in6 request_addr; /* udp: Who sent the most recent request */
    socklen_t request_addr_size;
    unsigned char *hdrbuf; /* udp packet headers */
    int    hdrsize;   /* number of headers' worth of space is allocated */

    //�Ƿ��ûظ��ͻ�����Ϣ��set_noreply_maybe
    bool   noreply;   /* True if the reply should not be sent. */
    /* current stats command */
    struct {
        char *buffer;
        size_t size;
        size_t offset;
    } stats;

    /* Binary protocol stuff */
    /* This is where the binary header goes */
    protocol_binary_request_header binary_header;
    uint64_t cas; /* the cas to return */
    //NREAD_SET�ȣ���ʾʲô����
    short cmd; /* current command being processed */
    int opaque;
    int keylen;
    //ָ����һ��conn
    conn   *next;     /* Used for generating a list of conn structures */
	//���conn�����ĸ�worker�߳�
    LIBEVENT_THREAD *thread; /* Pointer to the thread object serving this connection */
};

/* array of conn structures, indexed by file descriptor */
extern conn **conns;

/* current time of day (updated periodically) */
extern volatile rel_time_t current_time;

/* TODO: Move to slabs.h? */
extern volatile int slab_rebalance_signal;

struct slab_rebalance { //�洢��slab_rebal   ��ֵ���Բο�slab_rebalance_start  �ط�ҳ��ʱ����
    //��¼Ҫ�ƶ���ҳ����Ϣ��slab_startָ��ҳ�Ŀ�ʼλ�á�slab_endָ��ҳ  
    //�Ľ���λ�á�slab_pos���¼��ǰ�����λ��(item)  
    void *slab_start;
    void *slab_end;
    void *slab_pos;
    //����automove��Դslabclass[]id��Ŀ��slabclass[]id
    int s_clsid;//Դslab class���±�����  
    int d_clsid;//Ŀ��slab class���±�����  
    int busy_items;//�Ƿ�worker�߳�������ĳ��item,��¼������   slabǨ�ƹ��������ڱ������̷߳��ʵ�trunk������ֵ��slab_rebalance_move
    uint8_t done;//�Ƿ�������ڴ�ҳ�ƶ�  
};

extern struct slab_rebalance slab_rebal;

/*
 * Functions
 */
void do_accept_new_conns(const bool do_accept);
enum delta_result_type do_add_delta(conn *c, const char *key,
                                    const size_t nkey, const bool incr,
                                    const int64_t delta, char *buf,
                                    uint64_t *cas, const uint32_t hv);
enum store_item_type do_store_item(item *item, int comm, conn* c, const uint32_t hv);
conn *conn_new(const int sfd, const enum conn_states init_state, const int event_flags, const int read_buffer_size, enum network_transport transport, struct event_base *base);
extern int daemonize(int nochdir, int noclose);

static inline int mutex_lock(pthread_mutex_t *mutex)
{
    while (pthread_mutex_trylock(mutex));
    return 0;
}

#define mutex_unlock(x) pthread_mutex_unlock(x)

#include "stats.h"
#include "slabs.h"
#include "assoc.h"
#include "items.h"
#include "trace.h"
#include "hash.h"
#include "util.h"

/*
 * Functions such as the libevent-related calls that need to do cross-thread
 * communication in multithreaded mode (rather than actually doing the work
 * in the current thread) are called via "dispatch_" frontends, which are
 * also #define-d to directly call the underlying code in singlethreaded mode.
 */

void thread_init(int nthreads, struct event_base *main_base);
int  dispatch_event_add(int thread, conn *c);
void dispatch_conn_new(int sfd, enum conn_states init_state, int event_flags, int read_buffer_size, enum network_transport transport);

/* Lock wrappers for cache functions that are called from main loop. */
enum delta_result_type add_delta(conn *c, const char *key,
                                 const size_t nkey, const int incr,
                                 const int64_t delta, char *buf,
                                 uint64_t *cas);
void accept_new_conns(const bool do_accept);
conn *conn_from_freelist(void);
bool  conn_add_to_freelist(conn *c);
int   is_listen_thread(void);
item *item_alloc(char *key, size_t nkey, int flags, rel_time_t exptime, int nbytes);
char *item_cachedump(const unsigned int slabs_clsid, const unsigned int limit, unsigned int *bytes);
void  item_flush_expired(void);
item *item_get(const char *key, const size_t nkey);
item *item_touch(const char *key, const size_t nkey, uint32_t exptime);
int   item_link(item *it);
void  item_remove(item *it);
int   item_replace(item *it, item *new_it, const uint32_t hv);
void  item_stats(ADD_STAT add_stats, void *c);
void  item_stats_totals(ADD_STAT add_stats, void *c);
void  item_stats_sizes(ADD_STAT add_stats, void *c);
void  item_unlink(item *it);
void  item_update(item *it);

void item_lock_global(void);
void item_unlock_global(void);
void item_lock(uint32_t hv);
void *item_trylock(uint32_t hv);
void item_trylock_unlock(void *arg);
void item_unlock(uint32_t hv);
void switch_item_lock_type(enum item_lock_types type);
unsigned short refcount_incr(unsigned short *refcount);
unsigned short refcount_decr(unsigned short *refcount);
void STATS_LOCK(void);
void STATS_UNLOCK(void);
void threadlocal_stats_reset(void);
void threadlocal_stats_aggregate(struct thread_stats *stats);
void slab_stats_aggregate(struct thread_stats *stats, struct slab_stats *out);

/* Stat processing functions */
void append_stat(const char *name, ADD_STAT add_stats, conn *c,
                 const char *fmt, ...);

enum store_item_type store_item(item *item, int comm, conn *c);

#if HAVE_DROP_PRIVILEGES
extern void drop_privileges(void);
#else
#define drop_privileges()
#endif

/* If supported, give compiler hints for branch prediction. */
#if !defined(__GNUC__) || (__GNUC__ == 2 && __GNUC_MINOR__ < 96)
#define __builtin_expect(x, expected_value) (x)
#endif

#define likely(x)       __builtin_expect((x),1)
#define unlikely(x)     __builtin_expect((x),0)
