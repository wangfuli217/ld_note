#define MFSMAXFILES 1024

#include <dlfcn.h> 
#include <malloc.h>
#include <sys/prctl.h>

#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/time.h>

#include <signal.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <syslog.h>
#include <string.h>
#include <strings.h>
#include <time.h>
#include <sys/resource.h>
#include <grp.h>
#include <pwd.h>

#include <sys/uio.h>
#include <ucontext.h>
#include <sys/mman.h>
#include <execinfo.h>

#ifdef HAVE_BACKTRACE
#include <execinfo.h>
#include <ucontext.h>
#include <fcntl.h>
#endif 

#include "main.h"
#include "clocks.h"
#include "sockets.h"
#include "cfg.h"
#include "init.h"
#include "massert.h"
#include "slogger.h"
#include "portable.h"
#include "utils.h"

#define RM_RESTART 0
#define RM_START 1
#define RM_STOP 2
#define RM_RELOAD 3
#define RM_INFO 4
#define RM_TEST 5
#define RM_KILL 6
#define RM_TRY_RESTART 7

typedef struct deentry {
    void (*fun)(void);
    struct deentry *next;
} deentry;

static deentry *dehead=NULL;

typedef struct weentry {
    void (*fun)(void);
    struct weentry *next;
} weentry;

static weentry *wehead=NULL;


typedef struct ceentry {
    int (*fun)(void);
    struct ceentry *next;
} ceentry;

static ceentry *cehead=NULL;


typedef struct rlentry {
    void (*fun)(void);
    struct rlentry *next;
} rlentry;

static rlentry *rlhead=NULL;


typedef struct inentry {
    void (*fun)(void);
    struct inentry *next;
} inentry;

static inentry *inhead=NULL;


typedef struct kaentry {
    void (*fun)(void);
    struct kaentry *next;
} kaentry;

static kaentry *kahead=NULL;


typedef struct pollentry {
    void (*desc)(struct pollfd *,uint32_t *);
    void (*serve)(struct pollfd *);
    struct pollentry *next;
} pollentry;

static pollentry *pollhead=NULL;


typedef struct eloopentry {
    void (*fun)(void);
    struct eloopentry *next;
} eloopentry;

static eloopentry *eloophead=NULL;


typedef struct chldentry {
    pid_t pid;
    void (*fun)(int);
    struct chldentry *next;
} chldentry;

static chldentry *chldhead=NULL;

typedef struct activentry {
    void (*fun)(void);
} activentry;

static activentry *activehead = NULL;

typedef struct timeentry {
    uint64_t nextevent;
    uint64_t useconds;
    uint64_t usecoffset;
    void (*fun)(void);
    struct timeentry *next;
} timeentry;


typedef struct fdentry {
    int (*fun)(void);
    const char *desc;
    struct fdentry *next;
} fdentry;

static fdentry *fdhead=NULL;

static timeentry *timehead=NULL;

static uint32_t now;
static uint64_t usecnow;

static int signalpipe[2];

/* interface */

void main_destruct_register (void (*fun)(void)) {
    deentry *aux=(deentry*)malloc(sizeof(deentry));
    passert(aux);
    aux->fun = fun;
    aux->next = dehead;
    dehead = aux;
}

void main_canexit_register (int (*fun)(void)) {
    ceentry *aux=(ceentry*)malloc(sizeof(ceentry));
    passert(aux);
    aux->fun = fun;
    aux->next = cehead;
    cehead = aux;
}

void main_wantexit_register (void (*fun)(void)) {
    weentry *aux=(weentry*)malloc(sizeof(weentry));
    passert(aux);
    aux->fun = fun;
    aux->next = wehead;
    wehead = aux;
}

void main_reload_register (void (*fun)(void)) {
    rlentry *aux=(rlentry*)malloc(sizeof(rlentry));
    passert(aux);
    aux->fun = fun;
    aux->next = rlhead;
    rlhead = aux;
}

void main_info_register (void (*fun)(void)) {
    inentry *aux=(inentry*)malloc(sizeof(inentry));
    passert(aux);
    aux->fun = fun;
    aux->next = inhead;
    inhead = aux;
}

void main_keepalive_register (void (*fun)(void)) {
    kaentry *aux=(kaentry*)malloc(sizeof(kaentry));
    passert(aux);
    aux->fun = fun;
    aux->next = kahead;
    kahead = aux;
}

void main_poll_register (void (*desc)(struct pollfd *,uint32_t *),void (*serve)(struct pollfd *)) {
    pollentry *aux=(pollentry*)malloc(sizeof(pollentry));
    passert(aux);
    aux->desc = desc;
    aux->serve = serve;
    aux->next = pollhead;
    pollhead = aux;
}

void main_eachloop_register (void (*fun)(void)) {
    eloopentry *aux=(eloopentry*)malloc(sizeof(eloopentry));
    passert(aux);
    aux->fun = fun;
    aux->next = eloophead;
    eloophead = aux;
}

void main_chld_register (pid_t pid,void (*fun)(int)) {
    chldentry *aux=(chldentry*)malloc(sizeof(chldentry));
    passert(aux);
    aux->fun = fun;
    aux->pid = pid;
    aux->next = chldhead;
    chldhead = aux;
}

void main_active_register (uint8_t  prio, void (*fun)(void)) {
    if(activehead == NULL)
    {
        activehead = (activentry*)malloc(sizeof(activentry)*(ACTIVE_PRIO_RTU_CONF+1));
        passert(activehead);
        memset(activehead, 0, sizeof(activentry)*(ACTIVE_PRIO_RTU_CONF+1));
    }
    activehead[prio].fun = fun;
}

void main_active_run(void)
{
    uint8_t pos;

    if(activehead == NULL)
        return;
    
    for(pos=0; pos<(ACTIVE_PRIO_RTU_CONF+1); pos++)
        if(activehead[pos].fun != NULL)
        {
            activehead[pos].fun();
        }
}

void main_feeddog_register (int (*fun)(void), const char *desc)
{
    fdentry *aux=(fdentry*)malloc(sizeof(fdentry));
    passert(aux);
    aux->fun = fun;
    aux->desc = desc;
    aux->next = fdhead;
    fdhead = aux;
}

void* main_msectime_register (uint32_t mseconds,uint32_t offset,void (*fun)(void)) {
    timeentry *aux;
    uint64_t useconds = UINT64_C(1000) * (uint64_t)mseconds;
    uint64_t usecoffset = UINT64_C(1000) * (uint64_t)offset;
    if (useconds==0 || usecoffset>=useconds) {
        return NULL;
    }
    aux = (timeentry*)malloc(sizeof(timeentry));
    passert(aux);
    aux->nextevent = (((usecnow / useconds) * useconds) + usecoffset);
    while (aux->nextevent<usecnow) {
        aux->nextevent+=useconds;
    }
    aux->useconds = useconds;
    aux->usecoffset = usecoffset;
    aux->fun = fun;
    aux->next = timehead;
    timehead = aux;
    return aux;
}

int main_msectime_change(void* x,uint32_t mseconds,uint32_t offset) {
    timeentry *aux = (timeentry*)x;
    uint64_t useconds = UINT64_C(1000) * (uint64_t)mseconds;
    uint64_t usecoffset = UINT64_C(1000) * (uint64_t)offset;
    if (useconds==0 || usecoffset>=useconds) {
        return -1;
    }
    aux->nextevent = (((usecnow / useconds) * useconds) + usecoffset);
    while (aux->nextevent<usecnow) {
        aux->nextevent+=useconds;
    }
    aux->useconds = useconds;
    aux->usecoffset = usecoffset;
    return 0;
}

void* main_time_register (uint32_t seconds,uint32_t offset,void (*fun)(void)) {
    return main_msectime_register(1000*seconds,1000*offset,fun);
}

int main_time_change(void* x,uint32_t seconds,uint32_t offset) {
    return main_msectime_change(x,1000*seconds,1000*offset);

}

/* internal */

void free_all_registered_entries(void) {
    deentry *de,*den;
    ceentry *ce,*cen;
    weentry *we,*wen;
    rlentry *re,*ren;
    inentry *ie,*ien;
    pollentry *pe,*pen;
    eloopentry *ee,*een;
    timeentry *te,*ten;
    fdentry *fd,*fdn;
    
    for (de = dehead ; de ; de = den) {
        den = de->next;
        free(de);
    }

    for (ce = cehead ; ce ; ce = cen) {
        cen = ce->next;
        free(ce);
    }

    for (we = wehead ; we ; we = wen) {
        wen = we->next;
        free(we);
    }

    for (re = rlhead ; re ; re = ren) {
        ren = re->next;
        free(re);
    }

    for (ie = inhead ; ie ; ie = ien) {
        ien = ie->next;
        free(ie);
    }

    for (pe = pollhead ; pe ; pe = pen) {
        pen = pe->next;
        free(pe);
    }

    for (ee = eloophead ; ee ; ee = een) {
        een = ee->next;
        free(ee);
    }

    for (te = timehead ; te ; te = ten) {
        ten = te->next;
        free(te);
    }

    for (fd = fdhead ; fd ; fd = fdn) {
        fdn = fd->next;
        free(fd);
    }

    for (te = timehead ; te ; te = ten) {
        ten = te->next;
        free(te);
    }

    free(activehead);
}

int canexit() {
    ceentry *aux;
    for (aux = cehead ; aux!=NULL ; aux=aux->next ) {
        if (aux->fun()==0) {
            return 0;
        }
    }
    return 1;
}

uint32_t main_time() {
    return now;
}

uint64_t main_usectime(void)
{
    return usecnow;
}

static inline void destruct(void) {
    deentry *deit;
    for (deit = dehead ; deit!=NULL ; deit=deit->next ) {
        deit->fun();
    }
}

void main_keep_alive(void) {
    struct timeval tv;
    gettimeofday(&tv,NULL);
    usecnow = tv.tv_sec;
    usecnow *= 1000000;
    usecnow += tv.tv_usec;
    now = tv.tv_sec;
    kaentry *kait;
    for (kait = kahead ; kait!=NULL ; kait=kait->next ) {
        kait->fun();
    }
}

static void main_feeddog(void)
{
    static int feed_ok = 0;
    int mod_errs = 0;
    int total_errs = 0;
    int feed_errs = 0;
    
    fdentry *fdit;
    for (fdit = fdhead ; fdit!=NULL ; fdit=fdit->next )
    {
        feed_errs = fdit->fun();
        if(feed_errs != 0)
        {
            mod_errs++;
            total_errs+=feed_errs;
            syslog(LOG_ERR,"module %s errors %d (total errors:%d)", fdit->desc, feed_errs, total_errs);
            feed_errs = 0;
        }
    }

    if(mod_errs > WATCHDOG_ERR_MOD_TRIGER || total_errs > WATCHDOG_ERR_COUNT_TRIGER)
    {
        syslog(LOG_ERR,"feeddog stop; rtu restart");
        feed_ok = 1;
        exit(0);
    }

    //if(feed_ok == 0)
    //    enablewatchdog(1000);
}


void mainloop() {
    uint64_t prevtime = 0;
    struct timeval tv;
    pollentry *pollit;
    eloopentry *eloopit;
    timeentry *timeit;
    ceentry *ceit;
    weentry *weit;
    rlentry *rlit;
    inentry *init;
    static struct pollfd pdesc[MFSMAXFILES];
    uint32_t ndesc;
    int i;
    int t,r;

    t = 0;
    r = 0;
    while (t!=3) {
        memset(pdesc, 0 ,sizeof(struct pollfd)*MFSMAXFILES);
        ndesc=1;
        pdesc[0].fd = signalpipe[0];
        pdesc[0].events = POLLIN;
        pdesc[0].revents = 0;
        for (pollit = pollhead ; pollit != NULL ; pollit = pollit->next) {
            pollit->desc(pdesc,&ndesc);
        }
        i = poll(pdesc,ndesc,10);
        main_feeddog();
        gettimeofday(&tv,NULL);
        usecnow = tv.tv_sec;
        usecnow *= 1000000;
        usecnow += tv.tv_usec;
        now = tv.tv_sec;
        if (i<0) {
            if (!ERRNO_ERROR) {
                syslog(LOG_WARNING,"poll returned EAGAIN");
                portable_usleep(10000);
                continue;
            }
            if (errno!=EINTR) { //EFAULT,EINVAL,ENOMEM
                syslog(LOG_WARNING,"poll error: %s",strerr(errno));
                break;
            }
        } else {
            if ((pdesc[0].revents)&POLLIN) {
                uint8_t sigid;
                if (read(signalpipe[0],&sigid,1)==1) {
                    if (sigid=='\001' && t==0) {
                        syslog(LOG_NOTICE,"terminate signal received");
                        t = 1;
                    } else if (sigid=='\002') {
                        syslog(LOG_NOTICE,"reloading config files");
                        r = 1;
                    } else if (sigid=='\003') {
                        syslog(LOG_NOTICE,"child finished");
                        r = 2;
                    } else if (sigid=='\004') {
                        syslog(LOG_NOTICE,"log extra info");
                        r = 3;
                    } else if (sigid=='\005') {
                        syslog(LOG_NOTICE,"unexpected alarm/prof signal received - ignoring");
                    } else if (sigid=='\006') {
                        syslog(LOG_NOTICE,"internal terminate request");
                        t = 1;
                    }
                }
            }
            for (pollit = pollhead ; pollit != NULL ; pollit = pollit->next) {
                pollit->serve(pdesc);
                if(time(NULL) - now > 2)
                    syslog(LOG_NOTICE,"handle socket time longger than 2");
            }
        }
        for (eloopit = eloophead ; eloopit != NULL ; eloopit = eloopit->next) {
            eloopit->fun();
            if(time(NULL) - now > 2)
                    syslog(LOG_NOTICE,"handle eloophead longger than 2");
        }
        if (usecnow<prevtime) {
            // time went backward !!! - recalculate "nextevent" time
            // adding previous_time_to_run prevents from running next event too soon.
            for (timeit = timehead ; timeit != NULL ; timeit = timeit->next) {
                uint64_t previous_time_to_run = timeit->nextevent - prevtime;
                if (previous_time_to_run > timeit->useconds) {
                    previous_time_to_run = timeit->useconds;
                }
                timeit->nextevent = ((usecnow / timeit->useconds) * timeit->useconds) + timeit->usecoffset;
                while (timeit->nextevent <= usecnow+previous_time_to_run) {
                    timeit->nextevent += timeit->useconds;
                }
            }
        } else if (usecnow>prevtime+UINT64_C(3600000000)) {
            // time went forward !!! - just recalculate "nextevent" time
            for (timeit = timehead ; timeit != NULL ; timeit = timeit->next) {
                timeit->nextevent = ((usecnow / timeit->useconds) * timeit->useconds) + timeit->usecoffset;
                while (usecnow >= timeit->nextevent) {
                    timeit->nextevent += timeit->useconds;
                }
            }
        }
        for (timeit = timehead ; timeit != NULL ; timeit = timeit->next) {
            if (usecnow >= timeit->nextevent) {
                uint32_t eventcounter = 0;
                while (usecnow >= timeit->nextevent && eventcounter<10) { // do not run more than 10 late entries
                    timeit->fun();
                    if(time(NULL) - now > 2)
                        syslog(LOG_NOTICE,"handle timehead longger than 2");
                    timeit->nextevent += timeit->useconds;
                    eventcounter++;
                }
                if (usecnow >= timeit->nextevent) {
                    timeit->nextevent = ((usecnow / timeit->useconds) * timeit->useconds) + timeit->usecoffset;
                    while (usecnow >= timeit->nextevent) {
                        timeit->nextevent += timeit->useconds;
                    }
                }
            }
        }
        prevtime = usecnow;
        if (r==2) {
            chldentry *chldit,**chldptr;
            pid_t pid;
            int status;

            while ( (pid = waitpid(-1,&status,WNOHANG)) >= 0) {
                chldptr = &chldhead;
                while ((chldit = *chldptr)) {
                    if (chldit->pid == pid) {
                        chldit->fun(status);
                        *chldptr = chldit->next;
                        free(chldit);
                    } else {
                        chldptr = &(chldit->next);
                    }
                }
            }
            r = 0;
        }
        if (t==0) {
            if (r==1) {
                cfg_reload();
                for (rlit = rlhead ; rlit!=NULL ; rlit=rlit->next ) {
                    rlit->fun();
                }
                r = 0;
            } else if (r==3) {
                for (init = inhead ; init!=NULL ; init=init->next ) {
                    init->fun();
                }
                r = 0;
            }
        }
        if (t==1) {
            for (weit = wehead ; weit!=NULL ; weit=weit->next ) {
                weit->fun();
            }
            t = 2;
        }
        if (t==2) {
            i = 1;
            for (ceit = cehead ; ceit!=NULL && i ; ceit=ceit->next ) {
                if (ceit->fun()==0) {
                    i=0;
                }
            }
            if (i) {
                t = 3;
            }
        }
    }
}

int initialize(void) {
    uint32_t i;
    int ok;
    ok = 1;
    for (i=0 ; (long int)(RunTab[i].fn)!=0 && ok ; i++) {
        now = time(NULL);
        if (RunTab[i].fn()<0) {
            mfs_arg_syslog(LOG_ERR,"init: %s failed !!!",RunTab[i].name);
            ok=0;
        }
    }
    return ok;
}

int initialize_late(void) {
    uint32_t i;
    int ok;
    ok = 1;
    for (i=0 ; (long int)(LateRunTab[i].fn)!=0 && ok ; i++) {
        now = time(NULL);
        if (LateRunTab[i].fn()<0) {
            mfs_arg_syslog(LOG_ERR,"init: %s failed !!!",RunTab[i].name);
            ok=0;
        }
    }
    now = time(NULL);
    return ok;
}

/* signals */

static int termsignal[]=
{
    SIGTERM,
    -1
};

static int reloadsignal[]=
{
    SIGHUP,
    -1
};

static int infosignal[]=
{
    SIGUSR1,
    -1
};

static int chldsignal[]=
{
    SIGCHLD,
    -1
};

static int ignoresignal[]=
{
    SIGQUIT,
    SIGPIPE,
    SIGTSTP,
    SIGTTIN,
    SIGTTOU,
    SIGUSR2,
    -1
};

static int alarmsignal[]=
{
    SIGVTALRM,
    SIGPROF,
    -1
};

static int daemonignoresignal[]={
    SIGINT,
    -1
};

static int crushsignal[]=
{
    SIGSEGV,
    SIGBUS,
    SIGFPE,
    SIGILL,
    -1
};

void termhandle(int signo) {
    
    syslog(LOG_NOTICE,"termhandle:%s", strsignal(signo));
    signo = write(signalpipe[1],"\001",1); 
    (void)signo; 
}

void reloadhandle(int signo) {
    syslog(LOG_NOTICE,"reloadhandle:%s", strsignal(signo));
    signo = write(signalpipe[1],"\002",1); 
    (void)signo;
}

void chldhandle(int signo) {
    syslog(LOG_NOTICE,"chldhandle:%s", strsignal(signo));
    signo = write(signalpipe[1],"\003",1); 
    (void)signo;
}

void infohandle(int signo) {
    syslog(LOG_NOTICE,"infohandle:%s", strsignal(signo));
    signo = write(signalpipe[1],"\004",1); 
    (void)signo;
}

void alarmhandle(int signo) {
    syslog(LOG_NOTICE,"alarmhandle:%s", strsignal(signo));
    signo = write(signalpipe[1],"\005",1); 
    (void)signo;
}

#if (defined __X86_64__)  
    #define REGFORMAT   "%016lx"      
#elif (defined __I386__)  
    #define REGFORMAT   "%08x"  
#elif (defined __ARM__)  
    #define REGFORMAT   "%lx"  
#endif  


static void print_reg(ucontext_t *uc)   
{  
#if (defined __X86_64__) || (defined __I386__)  
    int i;  
    for (i = 0; i < NGREG; i++) {  
        mfs_arg_syslog(LOG_ERR, "reg[%02d]: 0x"REGFORMAT, i, uc->uc_mcontext.gregs[i]);  
    }  
#elif (defined __ARM__)  
    mfs_arg_syslog(LOG_ERR, "reg[%02d]     = 0x"REGFORMAT, 0, uc->uc_mcontext.arm_r0);  
    mfs_arg_syslog(LOG_ERR, "reg[%02d]     = 0x"REGFORMAT, 1, uc->uc_mcontext.arm_r1);  
    mfs_arg_syslog(LOG_ERR, "reg[%02d]     = 0x"REGFORMAT, 2, uc->uc_mcontext.arm_r2);  
    mfs_arg_syslog(LOG_ERR, "reg[%02d]     = 0x"REGFORMAT, 3, uc->uc_mcontext.arm_r3);  
    mfs_arg_syslog(LOG_ERR, "reg[%02d]     = 0x"REGFORMAT, 4, uc->uc_mcontext.arm_r4);  
    mfs_arg_syslog(LOG_ERR, "reg[%02d]     = 0x"REGFORMAT, 5, uc->uc_mcontext.arm_r5);  
    mfs_arg_syslog(LOG_ERR, "reg[%02d]     = 0x"REGFORMAT, 6, uc->uc_mcontext.arm_r6);  
    mfs_arg_syslog(LOG_ERR, "reg[%02d]     = 0x"REGFORMAT, 7, uc->uc_mcontext.arm_r7);  
    mfs_arg_syslog(LOG_ERR, "reg[%02d]     = 0x"REGFORMAT, 8, uc->uc_mcontext.arm_r8);  
    mfs_arg_syslog(LOG_ERR, "reg[%02d]     = 0x"REGFORMAT, 9, uc->uc_mcontext.arm_r9);  
    mfs_arg_syslog(LOG_ERR, "reg[%02d]     = 0x"REGFORMAT, 10, uc->uc_mcontext.arm_r10);  
    mfs_arg_syslog(LOG_ERR, "FP        = 0x"REGFORMAT, uc->uc_mcontext.arm_fp);  
    mfs_arg_syslog(LOG_ERR, "IP        = 0x"REGFORMAT, uc->uc_mcontext.arm_ip);  
    mfs_arg_syslog(LOG_ERR, "SP        = 0x"REGFORMAT, uc->uc_mcontext.arm_sp);  
    mfs_arg_syslog(LOG_ERR, "LR        = 0x"REGFORMAT, uc->uc_mcontext.arm_lr);  
    mfs_arg_syslog(LOG_ERR, "PC        = 0x"REGFORMAT, uc->uc_mcontext.arm_pc);  
    mfs_arg_syslog(LOG_ERR, "CPSR      = 0x"REGFORMAT, uc->uc_mcontext.arm_cpsr);  
    mfs_arg_syslog(LOG_ERR, "Fault Address = 0x"REGFORMAT, uc->uc_mcontext.fault_address);  
    mfs_arg_syslog(LOG_ERR, "Trap no       = 0x"REGFORMAT, uc->uc_mcontext.trap_no);  
    mfs_arg_syslog(LOG_ERR, "Err Code  = 0x"REGFORMAT, uc->uc_mcontext.error_code);  
    mfs_arg_syslog(LOG_ERR, "Old Mask  = 0x"REGFORMAT, uc->uc_mcontext.oldmask);  
#endif  
}  
  
static void print_call_link(ucontext_t *uc)   
{  
    int i = 0;  
    void **frame_pointer = (void **)NULL;  
    void *return_address = NULL;  
    Dl_info dl_info;  

    memset(&dl_info, 0, sizeof(dl_info));
#if (defined __I386__)  
    frame_pointer = (void **)uc->uc_mcontext.gregs[REG_EBP];  
    return_address = (void *)uc->uc_mcontext.gregs[REG_EIP];  
#elif (defined __X86_64__)  
    frame_pointer = (void **)uc->uc_mcontext.gregs[REG_RBP];  
    return_address = (void *)uc->uc_mcontext.gregs[REG_RIP];  
#elif (defined __ARM__)  
/* sigcontext_t on ARM: 
        unsigned long trap_no; 
        unsigned long error_code; 
        unsigned long oldmask; 
        unsigned long arm_r0; 
        ... 
        unsigned long arm_r10; 
        unsigned long arm_fp; 
        unsigned long arm_ip; 
        unsigned long arm_sp; 
        unsigned long arm_lr; 
        unsigned long arm_pc; 
        unsigned long arm_cpsr; 
        unsigned long fault_address; 
*/  
    frame_pointer = (void **)uc->uc_mcontext.arm_fp;  
    return_address = (void *)uc->uc_mcontext.arm_pc;  
#endif  
  
    mfs_syslog(LOG_ERR, "\nStack trace:");  
    while (frame_pointer && return_address) {  
        if (!dladdr(return_address, &dl_info))  break;  
        const char *sname = dl_info.dli_sname;    
        
        /* No: return address <sym-name + offset> (filename) */  
        mfs_arg_syslog(LOG_ERR, "%02d: %p <%s + %lu> (%s)", ++i, return_address, sname,   
            (unsigned long)return_address - (unsigned long)dl_info.dli_saddr,   
                                                    dl_info.dli_fname);  

        if (dl_info.dli_sname && !strcmp(dl_info.dli_sname, "main")) {  
            break;  
        }  
  
#if (defined __X86_64__) || (defined __I386__)  
        return_address = frame_pointer[1];  
        frame_pointer = frame_pointer[0];  
#elif (defined __ARM__)  
        return_address = frame_pointer[-1];   
        frame_pointer = (void **)frame_pointer[-3];  
#endif  
    }  
    mfs_syslog(LOG_ERR, "Stack trace end.");  
}  
  
static void sigsegv_handler(int signo, siginfo_t *info, void *context)  
{  
    if (context) {  
        ucontext_t *uc = (ucontext_t *)context;  
  
        mfs_syslog(LOG_ERR, "Segmentation Fault!");  
        mfs_arg_syslog(LOG_ERR, "info.si_signo = %d", signo);  
        mfs_arg_syslog(LOG_ERR, "info.si_errno = %d", info->si_errno);  
        mfs_arg_syslog(LOG_ERR, "info.si_code  = %d (%s)", info->si_code,   
            (info->si_code == SEGV_MAPERR) ? "SEGV_MAPERR" : "SEGV_ACCERR");  
        mfs_arg_syslog(LOG_ERR, "info.si_addr  = %p\n", info->si_addr);  
  
        print_reg(uc);  
        print_call_link(uc);  
    }  
  
    _exit(0);  
}  

void set_signal_handlers(int daemonflag) {
    struct sigaction sa;
    uint32_t i;

    zassert(pipe(signalpipe));

    sa.sa_flags = SA_RESTART;
    sigemptyset(&sa.sa_mask);

    sa.sa_handler = termhandle;
    for (i=0 ; termsignal[i]>0 ; i++) {
        sigaction(termsignal[i],&sa,(struct sigaction *)0);
    }
    sa.sa_handler = reloadhandle;
    for (i=0 ; reloadsignal[i]>0 ; i++) {
        sigaction(reloadsignal[i],&sa,(struct sigaction *)0);
    }
    sa.sa_handler = infohandle;
    for (i=0 ; infosignal[i]>0 ; i++) {
        sigaction(infosignal[i],&sa,(struct sigaction *)0);
    }
    sa.sa_handler = alarmhandle;
    for (i=0 ; alarmsignal[i]>0 ; i++) {
        sigaction(alarmsignal[i],&sa,(struct sigaction *)0);
    }
    sa.sa_handler = chldhandle;
    for (i=0 ; chldsignal[i]>0 ; i++) {
        sigaction(chldsignal[i],&sa,(struct sigaction *)0);
    }
    sa.sa_handler = SIG_IGN;
    for (i=0 ; ignoresignal[i]>0 ; i++) {
        sigaction(ignoresignal[i],&sa,(struct sigaction *)0);
    }
    sa.sa_handler = daemonflag?SIG_IGN:termhandle;
    for (i=0 ; daemonignoresignal[i]>0 ; i++) {
        sigaction(daemonignoresignal[i],&sa,(struct sigaction *)0);
    }
    
    sa.sa_flags = SA_NODEFER | SA_RESETHAND | SA_SIGINFO;
    sa.sa_sigaction = sigsegv_handler;
    for (i=0 ; crushsignal[i]>0 ; i++) {
        sigaction(crushsignal[i],&sa,(struct sigaction *)0);
    }
}

int main_thread_create(pthread_t *th,const pthread_attr_t *attr,void *(*fn)(void *),void *arg) {
    sigset_t oldset;
    sigset_t newset;
    uint32_t i;
    int res;

    sigemptyset(&newset);
    for (i=0 ; termsignal[i]>0 ; i++) {
        sigaddset(&newset, termsignal[i]);
    }
    for (i=0 ; reloadsignal[i]>0 ; i++) {
        sigaddset(&newset, reloadsignal[i]);
    }
    for (i=0 ; infosignal[i]>0 ; i++) {
        sigaddset(&newset, infosignal[i]);
    }
    for (i=0 ; alarmsignal[i]>0 ; i++) {
        sigaddset(&newset, alarmsignal[i]);
    }
    for (i=0 ; chldsignal[i]>0 ; i++) {
        sigaddset(&newset, chldsignal[i]);
    }
    for (i=0 ; ignoresignal[i]>0 ; i++) {
        sigaddset(&newset, ignoresignal[i]);
    }
    for (i=0 ; daemonignoresignal[i]>0 ; i++) {
        sigaddset(&newset, daemonignoresignal[i]);
    }
    pthread_sigmask(SIG_BLOCK, &newset, &oldset);
    res = pthread_create(th,attr,fn,arg);
    pthread_sigmask(SIG_SETMASK, &oldset, NULL);
    return res;
}

int main_minthread_create(pthread_t *th,uint8_t detached,void *(*fn)(void *),void *arg) {
    static pthread_attr_t *thattr = NULL;
    static uint8_t thattr_detached;
    if (thattr == NULL) {
        size_t mystacksize;
        thattr = malloc(sizeof(pthread_attr_t));
        passert(thattr);
        zassert(pthread_attr_init(thattr));
        mystacksize = 40960;

        zassert(pthread_attr_setstacksize(thattr,mystacksize));
        thattr_detached = detached + 1; // make it different
    }
    if (detached != thattr_detached) {
        if (detached) {
            zassert(pthread_attr_setdetachstate(thattr,PTHREAD_CREATE_DETACHED));
        } else {
            zassert(pthread_attr_setdetachstate(thattr,PTHREAD_CREATE_JOINABLE));
        }
        thattr_detached = detached;
    }
    return main_thread_create(th,thattr,fn,arg);
}

void main_exit(void) {
    int i;
    i = write(signalpipe[1],"\006",1);
    (void)i;
}

void signal_cleanup(void) {
    close(signalpipe[0]);
    close(signalpipe[1]);
}

void changeugid(void) {
    char pwdgrpbuff[16384];
    struct passwd pwd,*pw;
    struct group grp,*gr;
    char *wuser;
    char *wgroup;
    uid_t wrk_uid;
    gid_t wrk_gid;
    int gidok;

    if (geteuid()==0) {
        wuser = cfg_getstr("WORKING_USER",DEFAULT_USER);
        wgroup = cfg_getstr("WORKING_GROUP",DEFAULT_GROUP);

        gidok = 0;
        wrk_gid = -1;
        if (wgroup[0]=='#') {
            wrk_gid = strtol(wgroup+1,NULL,10);
            gidok = 1;
        } else if (wgroup[0]) {
            getgrnam_r(wgroup,&grp,pwdgrpbuff,16384,&gr);
            if (gr==NULL) {
                mfs_arg_syslog(LOG_WARNING,"%s: no such group !!!",wgroup);
                exit(1);
            } else {
                wrk_gid = gr->gr_gid;
                gidok = 1;
            }
        }

        if (wuser[0]=='#') {
            wrk_uid = strtol(wuser+1,NULL,10);
            if (gidok==0) {
                getpwuid_r(wrk_uid,&pwd,pwdgrpbuff,16384,&pw);
                if (pw==NULL) {
                    mfs_arg_syslog(LOG_ERR,"%s: no such user id - can't obtain group id",wuser+1);
                    exit(1);
                }
                wrk_gid = pw->pw_gid;
            }
        } else {
            getpwnam_r(wuser,&pwd,pwdgrpbuff,16384,&pw);
            if (pw==NULL) {
                mfs_arg_syslog(LOG_ERR,"%s: no such user !!!",wuser);
                exit(1);
            }
            wrk_uid = pw->pw_uid;
            if (gidok==0) {
                wrk_gid = pw->pw_gid;
            }
        }
        free(wuser);
        free(wgroup);

        if (setgid(wrk_gid)<0) {
            mfs_arg_errlog(LOG_ERR,"can't set gid to %d",(int)wrk_gid);
            exit(1);
        } else {
            syslog(LOG_NOTICE,"set gid to %d",(int)wrk_gid);
        }
        if (setuid(wrk_uid)<0) {
            mfs_arg_errlog(LOG_ERR,"can't set uid to %d",(int)wrk_uid);
            exit(1);
        } else {
            syslog(LOG_NOTICE,"set uid to %d",(int)wrk_uid);
        }
    }
}

static int lfd = -1;    // main lock

pid_t mylock(int fd) {
    struct flock fl;
    fl.l_start = 0;
    fl.l_len = 0;
    fl.l_pid = getpid();
    fl.l_type = F_WRLCK;
    fl.l_whence = SEEK_SET;
    for (;;) {
        if (fcntl(fd,F_SETLK,&fl)>=0) {    // lock set
            return 0;    // ok
        }
        if (ERRNO_ERROR) {    // error other than "already locked"
            return -1;    // error
        }
        if (fcntl(fd,F_GETLK,&fl)<0) {    // get lock owner
            return -1;    // error getting lock
        }
        if (fl.l_type!=F_UNLCK) {    // found lock
            return fl.l_pid;    // return lock owner
        }
    }
    return -1;    // pro forma
}

void wdunlock(void) {
    if (lfd>=0) {
        close(lfd);
    }
}

uint8_t wdlock(uint8_t runmode,uint32_t timeout) 
{
    pid_t ownerpid;
    pid_t newownerpid;
    uint32_t l;

    if(lfd == -1)
    {
        lfd = open(".rtud.lock",O_WRONLY|O_CREAT,0666);
        if (lfd<0) {
            mfs_errlog(LOG_ERR,"can't create lockfile in working directory");
            return 1;
        }
    }
    ownerpid = mylock(lfd);
    if (ownerpid<0) {
        mfs_errlog(LOG_ERR,"fcntl error");
        return 1;
    }
    if (ownerpid>0) {
        if (runmode==RM_TEST) {
            fprintf(stderr,"rtud  pid: %ld\n",(long)ownerpid);
            return 0;
        }
        if (runmode==RM_START) {
            fprintf(stderr,"can't start: lockfile is already locked by another process\n");
            return 1;
        }
        if (runmode==RM_RELOAD) {
            if (kill(ownerpid,SIGHUP)<0) {
                mfs_errlog(LOG_WARNING,"can't send reload signal to lock owner");
                return 1;
            }
            fprintf(stderr,"reload signal has been sent\n");
            return 0;
        }
        if (runmode==RM_INFO) {
            if (kill(ownerpid,SIGUSR1)<0) {
                mfs_errlog(LOG_WARNING,"can't send info signal to lock owner");
                return 1;
            }
            fprintf(stderr,"info signal has been sent\n");
            return 0;
        }
        if (runmode==RM_KILL) {
            fprintf(stderr,"sending SIGKILL to lock owner (pid:%ld)\n",(long int)ownerpid);
            if (kill(ownerpid,SIGKILL)<0) {
                mfs_errlog(LOG_WARNING,"can't kill lock owner");
                return 1;
            }
        } else {
            fprintf(stderr,"sending SIGTERM to lock owner (pid:%ld)\n",(long int)ownerpid);
            if (kill(ownerpid,SIGTERM)<0) {
                mfs_errlog(LOG_WARNING,"can't kill lock owner");
                return 1;
            }
        }
        l=0;
        fprintf(stderr,"waiting for termination ");
        fflush(stderr);
        do {
            newownerpid = mylock(lfd);
            if (newownerpid<0) {
                mfs_errlog(LOG_ERR,"fcntl error");
                return 1;
            }
            if (newownerpid>0) {
                l++;
                if (l>=timeout) {
                   if (kill(newownerpid,SIGKILL)<0) 
                    return 1;
                }
                if (l%10==0) {
                    syslog(LOG_WARNING,"about %"PRIu32" seconds passed and lock still exists",l);
                    fprintf(stderr,".");
                    fflush(stderr);
                }
                if (newownerpid!=ownerpid) {
                    fprintf(stderr,"\nnew lock owner detected\n");
                    if (runmode==RM_KILL) {
                        fprintf(stderr,":sending SIGKILL to lock owner (pid:%ld):",(long int)newownerpid);
                        fflush(stderr);
                        if (kill(newownerpid,SIGKILL)<0) {
                            mfs_errlog(LOG_WARNING,"can't kill lock owner");
                            return 1;
                        }
                    } else {
                        fprintf(stderr,":sending SIGTERM to lock owner (pid:%ld):",(long int)newownerpid);
                        fflush(stderr);
                        if (kill(newownerpid,SIGTERM)<0) {
                            mfs_errlog(LOG_WARNING,"can't kill lock owner");
                            return 1;
                        }
                    }
                    ownerpid = newownerpid;
                }
            }
            sleep(1);
        } while (newownerpid!=0);
        fprintf(stderr,"terminated\n");
        return 0;
    }
    if (runmode==RM_START || runmode==RM_RESTART) {
        char pidstr[20];
        l = snprintf(pidstr,20,"%ld\n",(long)(getpid()));
        if (ftruncate(lfd,0)<0) {
            fprintf(stderr,"can't truncate pidfile\n");
        }
        if (write(lfd,pidstr,l)!=(ssize_t)l) {
            fprintf(stderr,"can't write pid to pidfile\n");
        }
        fprintf(stderr,"lockfile created and locked\n");
    } else if (runmode==RM_TRY_RESTART) {
        fprintf(stderr,"can't find process to restart\n");
        return 1;
    } else if (runmode==RM_STOP || runmode==RM_KILL) {
        fprintf(stderr,"can't find process to terminate\n");
        return 0;
    } else if (runmode==RM_RELOAD) {
        fprintf(stderr,"can't find process to send reload signal\n");
        return 1;
    } else if (runmode==RM_INFO) {
        fprintf(stderr,"can't find process to send info signal\n");
        return 1;
    } else if (runmode==RM_TEST) {
        fprintf(stderr,"rtud is not running\n");
        return 1;
    }
    return 0;
}

void makedaemon() {
    int f;
    uint8_t pipebuff[1000];
    ssize_t r;
    size_t happy;
    int piped[2];

    fflush(stdout);
    fflush(stderr);
    if (pipe(piped)<0) {
        fprintf(stderr,"pipe error\n");
        exit(1);
    }
    f = fork();
    if (f<0) {
        syslog(LOG_ERR,"first fork error: %s",strerr(errno));
        exit(1);
    }
    if (f>0) {
        wait(&f);    
        if (f) {
            fprintf(stderr,"Child status: %d\n",f);
            exit(1);
        }
        close(piped[1]);
        while ((r=read(piped[0],pipebuff,1000))) {
            if (r>0) {
                if (pipebuff[r-1]==0) {
                    if (r>1) {
                        happy = fwrite(pipebuff,1,r-1,stderr);
                        (void)happy;
                    }
                    exit(1);
                }
                happy = fwrite(pipebuff,1,r,stderr);
                (void)happy;
            } else {
                fprintf(stderr,"Error reading pipe: %s\n",strerr(errno));
                exit(1);
            }
        }
        exit(0);
    }
    setsid();
    setpgid(0,getpid());
    f = fork();
    if (f<0) {
        syslog(LOG_ERR,"second fork error: %s",strerr(errno));
        if (write(piped[1],"fork error\n",11)!=11) {
            syslog(LOG_ERR,"pipe write error: %s",strerr(errno));
        }
        close(piped[1]);
        exit(1);
    }
    if (f>0) {
        exit(0);
    }
    set_signal_handlers(1);

    close(STDIN_FILENO);
    sassert(open("/dev/null", O_RDWR, 0)==STDIN_FILENO);
    close(STDOUT_FILENO);
    sassert(dup(STDIN_FILENO)==STDOUT_FILENO);
    close(STDERR_FILENO);
    sassert(dup(piped[1])==STDERR_FILENO);
    close(piped[1]);

}

void close_msg_channel() {
    fflush(stderr);
    close(STDERR_FILENO);
    sassert(open("/dev/null", O_RDWR, 0)==STDERR_FILENO);
}

void createpath(const char *filename) {
    char pathbuff[1024];
    const char *src = filename;
    char *dst = pathbuff;
    if (*src=='/') *dst++=*src++;

    while (*src) {
        while (*src!='/' && *src) {
            *dst++=*src++;
        }
        if (*src=='/') {
            *dst='\0';
            if (mkdir(pathbuff,(mode_t)0777)<0) {
                if (errno!=EEXIST) {
                    mfs_arg_errlog(LOG_NOTICE,"creating directory %s",pathbuff);
                }
            } else {
                mfs_arg_syslog(LOG_NOTICE,"directory %s has been created",pathbuff);
            }
            *dst++=*src++;
        }
    }
}

void usage(const char *appname) {
    printf(
"%s\n"      
"usage: %s [-vfun] [-t locktimeout] [-c cfgfile]  [start|stop|restart|info|kill]\n"
"\n"
"-v : print version number and exit\n"
"-f : run in foreground\n"
"-u : log undefined config variables\n"
"-n : do not attempt to increase limit of core dump size\n"
"-t locktimeout : how long wait for lockfile\n"
"-c cfgfile : use given config file\n"
    ,RTUDRELEASE, appname);
    exit(1);
}

int main(int argc,char **argv) {
    char *logappname;
//    char *lockfname;
    char *wrkdir;
    char *cfgfile;
    char *ocfgfile;
    char *appname;
    int ch;
    uint8_t runmode;
    int rundaemon,logundefined;
    int lockmemory;
    int forcecoredump;
    int32_t nicelevel;
    uint32_t locktimeout;
    int fd;
    uint8_t movewarning;
    struct rlimit rls;

    strerr_init();

    movewarning = 0;
    cfgfile=strdup(ETC_PATH "/rtud/rtud.cfg");
    passert(cfgfile);
    if ((fd = open(cfgfile,O_RDONLY))<0 && errno==ENOENT) {
        ocfgfile=strdup(ETC_PATH "/rtud.cfg");
        passert(ocfgfile);
        if ((fd = open(ocfgfile,O_RDONLY))>=0) {
            free(cfgfile);
            cfgfile = ocfgfile;
            movewarning = 1;
        }
    }
    if (fd>=0) {
        close(fd);
    }
    locktimeout = 1800;
    rundaemon = 1;
    runmode = RM_RESTART;
    logundefined = 0;
    lockmemory = 0;
    forcecoredump = 1;
    appname = argv[0];

    while ((ch = getopt(argc, argv, "nuvfdc:t:h?")) != -1) {
        switch(ch) {
            case 'v':
                printf("version: %s\n",RTUDRELEASE);
                return 0;
            case 'd':
                printf("option '-d' is deprecated - use '-f' instead\n");
                // no break on purpose
            case 'f':
                rundaemon=0;
                break;
            case 't':
                locktimeout=strtoul(optarg,NULL,10);
                break;
            case 'c':
                free(cfgfile);
                cfgfile = strdup(optarg);
                passert(cfgfile);
                movewarning = 0;
                break;
            case 'u':
                logundefined=1;
                break;
            case 'n':
                forcecoredump = 0;
                break;
            default:
                usage(appname);
                return 1;
        }
    }
    argc -= optind;
    argv += optind;
    if (argc==1) {
        if (strcasecmp(argv[0],"start")==0) {
            runmode = RM_START;
        } else if (strcasecmp(argv[0],"stop")==0) {
            runmode = RM_STOP;
        } else if (strcasecmp(argv[0],"restart")==0) {
            runmode = RM_RESTART;
        } else if (strcasecmp(argv[0],"try-restart")==0) {
            runmode = RM_TRY_RESTART;
        } else if (strcasecmp(argv[0],"reload")==0) {
            runmode = RM_RELOAD;
        } else if (strcasecmp(argv[0],"info")==0) {
            runmode = RM_INFO;
        } else if (strcasecmp(argv[0],"test")==0 || strcasecmp(argv[0],"status")==0) {
            runmode = RM_TEST;
        } else if (strcasecmp(argv[0],"kill")==0) {
            runmode = RM_KILL;
        } else {
            usage(appname);
            return 1;
        }
    } else if (argc!=0) {
        usage(appname);
        return 1;
    }

    if (movewarning) {
        mfs_syslog(LOG_WARNING,"default sysconf path has changed - please move rtud.cfg from "ETC_PATH"/ to "ETC_PATH"/mfs/");
    }

    if (runmode==RM_START || runmode==RM_RESTART || runmode==RM_TRY_RESTART) {
        if (rundaemon) {
            makedaemon();
        } else {
            set_signal_handlers(0);
        }
    }

    if (cfg_load(cfgfile,logundefined)==0) {
        fprintf(stderr,"can't load config file: %s - using defaults\n",cfgfile);
    }
    free(cfgfile);

    logappname = cfg_getstr("SYSLOG_IDENT","rtud");

    if (rundaemon) {
        if (logappname[0]) {
            openlog(logappname, LOG_PID | LOG_NDELAY , LOG_DAEMON);
        } else {
            openlog("rtud", LOG_PID | LOG_NDELAY , LOG_DAEMON);
        }
    } else {
        if (logappname[0]) {
            openlog(logappname, LOG_PID | LOG_NDELAY, LOG_USER);
        } else {
            openlog("rtud", LOG_PID | LOG_NDELAY, LOG_USER);
        }
    }

    if (runmode==RM_START || runmode==RM_RESTART || runmode==RM_TRY_RESTART) {
        rls.rlim_cur = MFSMAXFILES;
        rls.rlim_max = MFSMAXFILES;
        if (setrlimit(RLIMIT_NOFILE,&rls)<0) {
            syslog(LOG_NOTICE,"can't change open files limit to: %u (trying to set smaller value)",MFSMAXFILES);
            if (getrlimit(RLIMIT_NOFILE,&rls)>=0) {
                uint32_t limit;
                if (rls.rlim_max > MFSMAXFILES) {
                    limit = MFSMAXFILES;
                } else {
                    limit = rls.rlim_max;
                }
                while (limit>1024) {
                    rls.rlim_cur = limit;
                    if (setrlimit(RLIMIT_NOFILE,&rls)>=0) {
                        mfs_arg_syslog(LOG_NOTICE,"open files limit has been set to: %"PRIu32,limit);
                        break;
                    }
                    limit *= 3;
                    limit /= 4;
                }
            }
        } else {
            mfs_arg_syslog(LOG_NOTICE,"open files limit has been set to: %u",MFSMAXFILES);
        }

        lockmemory = cfg_getnum("LOCK_MEMORY",0);
        nicelevel = cfg_getint32("NICE_LEVEL",-19);
        setpriority(PRIO_PROCESS,getpid(),nicelevel);
    }

    changeugid();

    wrkdir = cfg_getstr("DATA_PATH",DATA_PATH);
    if (runmode==RM_START || runmode==RM_RESTART || runmode==RM_TRY_RESTART) {
        fprintf(stderr,"working directory: %s\n",wrkdir);
    }

    if (chdir(wrkdir)<0) {
        mfs_arg_syslog(LOG_ERR,"can't set working directory to %s",wrkdir);
        if (rundaemon) {
            fputc(0,stderr);
            close_msg_channel();
        }
        closelog();
        free(logappname);
        return 1;
    }
    free(wrkdir);

    umask(cfg_getuint32("FILE_UMASK",027)&077);

    ch = wdlock(runmode,locktimeout);
    if (ch) {
        if (rundaemon) {
            fputc(0,stderr);
            close_msg_channel();
        }
        closelog();
        free(logappname);
        wdunlock();
        return ch;
    }

    if (runmode==RM_STOP || runmode==RM_KILL || runmode==RM_RELOAD || runmode==RM_INFO || runmode==RM_TEST) {
        if (rundaemon) {
            close_msg_channel();
        }
        closelog();
        free(logappname);
        wdunlock();
        return 0;
    }


    if (lockmemory) {
        mfs_syslog(LOG_WARNING,"memory lock not supported !!!");
    }

    if (forcecoredump) {
        rls.rlim_cur = RLIM_INFINITY;
        rls.rlim_max = RLIM_INFINITY;
        setrlimit(RLIMIT_CORE,&rls);
    }

    syslog(LOG_NOTICE,"monotonic clock function: %s",monotonic_method());
    syslog(LOG_NOTICE,"monotonic clock speed: %"PRIu32" ops / 10 mili seconds",monotonic_speed());

    fprintf(stderr,"initializing %s modules ...\n",logappname);

    slogger_config_init();
    
    if (initialize()) {
        fprintf(stderr,"%s daemon initialized properly\n",logappname);
        if (rundaemon) {
            close_msg_channel();
        }
        if (initialize_late()) {
            mainloop();
            mfs_syslog(LOG_NOTICE,"exited from main loop");
            ch=0;
        } else {
            ch=1;
        }
    } else {
        fprintf(stderr,"error occured during initialization - exiting\n");
        if (rundaemon) {
            fputc(0,stderr);
            close_msg_channel();
        }
        ch=1;
    }
    mfs_syslog(LOG_NOTICE,"exititng ...");
    destruct();
    free_all_registered_entries();
    signal_cleanup();
    cfg_term();
    closelog();
    free(logappname);
    wdunlock();
    mfs_arg_syslog(LOG_NOTICE,"process exited successfully (status:%d)",ch);
    return ch;
}
