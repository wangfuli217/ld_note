#ifndef _MAIN_H_
#define _MAIN_H_


#include <inttypes.h>
#include <poll.h>
#include <pthread.h>
#include <sys/types.h>

enum 
{
    ACTIVE_PRIO_OTDR_TASK,
    ACTIVE_PRIO_OTDR_MAIN, /* wait */
    ACTIVE_PRIO_RTU_REPORT,
    ACTIVE_PRIO_RTU_TTY,    /* wait */
    ACTIVE_PRIO_RTU_BELL,    /* wait hardware  */
    ACTIVE_PRIO_FIBRE_CONF,
    ACTIVE_PRIO_RTU_CONF,
    ACTIVE_PRIO_RTU_MON,
};

void main_feeddog_register (int (*fun)(void), const char *desc);
void main_destruct_register (void (*fun)(void));
void main_canexit_register (int (*fun)(void));
void main_wantexit_register (void (*fun)(void));
void main_reload_register (void (*fun)(void));
void main_info_register (void (*fun)(void));
void main_chld_register (pid_t pid,void (*fun)(int));
void main_active_register (uint8_t  prio, void (*fun)(void));
void main_active_run(void);
void main_keepalive_register (void (*fun)(void));
void main_poll_register (void (*desc)(struct pollfd *,uint32_t *),void (*serve)(struct pollfd *));
void main_eachloop_register (void (*fun)(void));
void* main_msectime_register (uint32_t mseconds,uint32_t offset,void (*fun)(void));
int main_msectime_change(void* x,uint32_t mseconds,uint32_t offset);
void* main_time_register (uint32_t seconds,uint32_t offset,void (*fun)(void));
int main_time_change(void *x,uint32_t seconds,uint32_t offset);
void main_exit(void);
uint32_t main_time(void);
uint64_t main_usectime(void);
void main_keep_alive(void);
int main_thread_create(pthread_t *th,const pthread_attr_t *attr,void *(*fn)(void *),void *arg);
int main_minthread_create(pthread_t *th,uint8_t detached,void *(*fn)(void *),void *arg);

#define DEFAULT_USER "root"
#define DEFAULT_GROUP "root"
#define ETC_PATH "/etc/"
#define VERSSTR  "1.0.1"
#define DATA_PATH  "/var/rtud/"


#endif
