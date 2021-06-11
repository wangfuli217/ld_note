#ifndef __EBT_H__
#define __EBT_H__

#define EBT_API extern

struct ev;
struct eb_t;
typedef void e_cb_t (short, void *);

enum e_kind {
    E_READ = 0x01,              /* IO读 */
    E_WRITE = 0x02,             /* IO写 */
    E_TIMER = 0x04,             /* 定时器 */
    E_SIGNAL = 0x08,            /* 信号 */
    E_CHILD = 0x10,             /* 进程 */
    E_FLAG = 0x20               /* 用户自定义 */
};

enum e_opt {
    E_ONCE = 0x01,              /* 一次性事件, 当事件dipsatch到队列后,  激活后立该从eb_t移除, 并标记为ONCE */
    E_FREE = 0x02               /* 事件已经从eb_t实例被移除, 将其标记为E_FREE, 释放其存储空间 */
};

EBT_API struct ev *ev_read (int fd, e_cb_t * cb, void *arg);
EBT_API struct ev *ev_write (int fd, e_cb_t * cb, void *arg);
EBT_API struct ev *ev_timer (const struct timeval *tv, e_cb_t * cb, void *arg);
EBT_API struct ev *ev_signal (int sig, e_cb_t * cb, void *arg);
EBT_API struct ev *ev_child (pid_t child, e_cb_t * cb, void *arg);
EBT_API struct ev *ev_flag (int flag, e_cb_t * cb, void *arg);
EBT_API void ev_opt (struct ev *e, enum e_opt opt);
EBT_API void ev_free (struct ev *e);

EBT_API int ev_attach (struct ev *e, struct eb_t *ebt);
EBT_API int ev_detach (struct ev *e, struct eb_t *ebt);

EBT_API struct eb_t *ebt_new (enum e_kind kinds);
EBT_API int ebt_loop_once (struct eb_t *ebt);
EBT_API int ebt_loop (struct eb_t *ebt);
EBT_API void ebt_free (struct eb_t *ebt);

enum r_type {
    E_START = 0,
    E_CONNECT = 1,
    E_RECEIVE = 2,
    E_TIMEOUT = 3,
    E_CLOSE = 4,
    E_SHUTDOWN = 5,
    E_ERROR = 6
};

enum s_type {
    E_CLOSED = 0,
    E_CLOSING = 1,
    E_CONNECTING = 2,
    E_CONNECTED = 3,
    E_RECEIVING = 4,
    E_RECEIVED = 5,
    E_STARTED = 6,
    E_STARTING = 7,
    E_SHUTDOWNED = 8
};

#define E_TCP_PACKAGE_LEN 8129

struct ebt_srv;

struct EventData {
    int fd;
    int type;
    uint16_t len;
    uint16_t from_reactor_id;
    char buf[E_TCP_PACKAGE_LEN];
};

typedef int (*e_handle_t) (struct EventData *);

EBT_API int ebt_srv_create (struct ebt_srv *srv);
EBT_API int ebt_srv_start (struct ebt_srv *srv);
EBT_API int ebt_srv_listen (struct ebt_srv *srv, short port);
EBT_API int ebt_srv_on (struct ebt_srv *srv, enum r_type type, e_handle_t cb);
EBT_API void ebt_srv_free (struct ebt_srv *srv);

#endif
