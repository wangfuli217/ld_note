#include <errno.h>
#include <fcntl.h>
#include <rpc/des_crypt.h>
#include <stdio.h>
#include <string.h>
#include <syslog.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <termios.h>
#include <sys/time.h>
#include <signal.h>

#include "utils.h"


static const char des_key[]={'1','q','a','z','@','W','S','Z'};


void parse(int *parc, char *parv[], char *src,int maxpar)
{
    int i;
    int willbeword;

    *parc=0;
    willbeword=1;
    i=0;

    if (src == NULL)
    return ;

    while(src[i]!=0 && *parc<maxpar){
        if(src[i]==' '){
            willbeword=1;
            src[i]=0;
        } else{
            if(willbeword){
                parv[*parc]=&src[i];
                (*parc)++;
                willbeword=0;
            }
        }
        i++;
    }
}

void parseex(int *parc,char *parv[],char *src,int maxpar,char separator)
{
    int i;
    int willbeword;

    *parc = 0;
    parv[*parc] = NULL;
    willbeword = 1;
    i=0;

    if (src == NULL)
    return ;

    while ( *parc < maxpar) {
        if (src[i] == ' ') {
            src[i]=0;
        } else if (src[i] == separator) {
            src[i]=0;
            willbeword = 1;
            (*parc)++;
            parv[*parc] = NULL;
        } else if ((src[i] == 0) && (willbeword == 0)) {
            (*parc)++;
            break;
        } else {
            if (willbeword) {
                parv[*parc]=&src[i];
                willbeword=0;
            }
        }
        i++;
    }
}

void hex2str(char *str, uint8_t *hex,int len)
{
    int i;
    uint8_t l4,h4;

    for(i=0; i<len; i++) {
        h4=(hex[i] & 0xf0)>>4;
        l4=hex[i] & 0x0f;
        if (h4<=9) 
        str[2*i] = h4 + ('0' -0);
        else
        str[2*i] = h4 + ('A'-10);

        if (l4<=9) 
        str[2*i+1] = l4 + ('0' -0);
        else
        str[2*i+1] = l4 + ('A'-10);
    }
    str[2*i]=0;
}

static uint8_t asc2hex(char asccode)
{
    uint8_t ret;
    if('0'<=asccode && asccode<='9')
    ret=asccode-'0';
    else if('a'<=asccode && asccode<='f')
    ret=asccode-'a'+10;
    else if('A'<=asccode && asccode<='F')
    ret=asccode-'A'+10;
    else
    ret=0;
    return ret;
}

void ascs2hex(uint8_t *hex,uint8_t *ascs,int srclen)
{
    uint8_t l4,h4;
    int i,lenstr;
    lenstr = srclen;
    if(lenstr==0){
        return;
    }

    if(lenstr%2)
    return;

    for(i=0; i<lenstr; i+=2){
        h4=asc2hex(ascs[i]);
        l4=asc2hex(ascs[i+1]);
        hex[i/2]=(h4<<4)+l4;
    }
}

void str2hex(uint8_t *hex, int *len, char *str)
{
    uint8_t l4,h4;
    int i,lenstr;
    lenstr = strlen(str);
    if(lenstr==0){
        *len = 0;
        return;
    }
    for(i=0; i<lenstr-(lenstr%2); i+=2){
        h4=asc2hex(str[i]);
        l4=asc2hex(str[i+1]);
        hex[i/2]=(h4<<4)+l4;
    }
    if(lenstr%2)
    hex[(lenstr+1)/2-1]=asc2hex(str[lenstr-1]) << 4;
    *len=(lenstr+1)/2;
}

int setnonblock(int fd) {
    int flags = fcntl(fd, F_GETFL, 0);
    if (flags == -1) {
        return -1;
    }
    return fcntl(fd, F_SETFL, flags | O_NONBLOCK);
}

FILE* fopen_for_read(const char *path)
{
    struct stat buf;
    int ret = stat(path, &buf);
    if(ret != 0)
    return NULL;
    if(!S_ISREG(buf.st_mode))
    return NULL;

    FILE *fp = fopen(path, "r");
    if (fp == NULL)
    syslog(LOG_ERR, "can't open '%s'", path);
    return fp;
}

static ssize_t _write(int fd, const void *buf, size_t len)
{
    ssize_t nr;
    while (1) 
    {
        nr = write(fd, buf, len);
        if (unlikely(nr < 0) && (errno == EAGAIN || errno == EINTR))
        continue;
        return nr;
    }
}

ssize_t xwrite(int fd, const void *buf, size_t count)
{
    const char *p = buf;
    ssize_t total = 0;

    while (count > 0) 
    {
        ssize_t written = _write(fd, p, count);
        if (written < 0)
        return -1;
        if (!written) 
        {
            errno = ENOSPC;
            return -1;
        }
        count -= written;
        p += written;
        total += written;
    }

    return total;
}

static int g_watchdog_period = 0;

void watchdogsignalhandler(int sig, siginfo_t *info, void *secret) {
    ((void)info);
    ((void)sig);
    ((void)secret);

    syslog(LOG_INFO,"\n--- WATCHDOG TIMER EXPIRED ---");
    syslog(LOG_INFO,"Sorry: no support for backtrace().");
    syslog(LOG_INFO,"--------\n");
}


void watchdogschedulesignal(int period) {
    struct itimerval it;

    it.it_value.tv_sec = period/1000;
    it.it_value.tv_usec = (period%1000)*1000;

    it.it_interval.tv_sec = 0;
    it.it_interval.tv_usec = 0;
    setitimer(ITIMER_REAL, &it, NULL);
}


void enablewatchdog(int period) {
    int min_period;

    if (g_watchdog_period == 0) {
        struct sigaction act;

        sigemptyset(&act.sa_mask);
        act.sa_flags = SA_NODEFER | SA_ONSTACK | SA_SIGINFO;
        act.sa_sigaction = watchdogsignalhandler;
        sigaction(SIGALRM, &act, NULL);
    }

    min_period = 1000;
    if (period < min_period) period = min_period;
    watchdogschedulesignal(period); 
    g_watchdog_period = period;
}

void disablewatchdog(void) {
    struct sigaction act;
    if (g_watchdog_period == 0) return; 
    watchdogschedulesignal(0); 

    sigemptyset(&act.sa_mask);
    act.sa_flags = 0;
    act.sa_handler = SIG_IGN;
    sigaction(SIGALRM, &act, NULL);
    g_watchdog_period = 0;
}

