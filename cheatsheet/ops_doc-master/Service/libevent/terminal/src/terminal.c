/* Copyright (c) 2017, DesionWang. */
/* All rights reserved. */

/* Redistribution and use in source and binary forms, with or without */
/* modification, are permitted provided that the following conditions are */
/* met: */

/*     * Redistributions of source code must retain the above copyright */
/* notice, this list of conditions and the following disclaimer. */

/*     * Redistributions in binary form must reproduce the above */
/* copyright notice, this list of conditions and the following disclaimer */
/* in the documentation and/or other materials provided with the */
/* distribution. */

/*     * Neither the name of the WEIBO nor the names of its */
/* contributors may be used to endorse or promote products derived from */
/* this software without specific prior written permission. */

/* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS */
/* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT */
/* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR */
/* A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT */
/* OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, */
/* SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT */
/* LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, */
/* DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY */
/* THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT */
/* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE */
/* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

/*
 *   terminal - batch online update key value system
 *
 *
 *  Copyright 2017 DesionWang  All rights reserved.
 *
 *  Use and distribution licensed under the BSD license.  See
 *  the LICENSE file for full text.
 *
 *  Authors:
 *      Desion Wang <wdxin1322@qq.com>
 */

#include "terminal_define.h"
#include "connection.h"
#include "connection_queue.h"
#include "network.h"
#include <sys/resource.h>
#include <pthread.h>
#include <signal.h>
#include <unistd.h>
#include "hdict.h"
#include "util.h"

/***
global area, all the global variable of server
*/
//for server setting
struct settings settings;

//request connect queue
struct conn_queue REQ;

//reponse connect queue
struct conn_queue RSP;

int notify_receive_fd;
int notify_send_fd;

//store the free connection for reuse
conn **freeconns;

//total free connection
int freetotal;

//current free connection
int freecurr;

struct status stats;


static pthread_mutex_t notify_lock = PTHREAD_MUTEX_INITIALIZER;
//status lock
//pthread_mutex_t stats_lock = PTHREAD_MUTEX_INITIALIZER;

static int l_socket = 0;

/***
 * initial the setting of server
 */
static void settings_init() {
    settings.port = DEFAULT_PORT;
    settings.interf.s_addr = htonl(INADDR_ANY);
    settings.maxconns = MAX_CONN_NUM;
    settings.num_threads = DEFAULT_THREAD_NUM;
    settings.verbose = 0;
    settings.timeout = 0;
}

static int find_index(const char* str, char c){
    int index = 0;
    while(*str){
        if(c == *str){
            return index;
        }
        index++;
        str++;
    }
    return -1;
}

/***
 * initial the server status
 */
static void stats_init(){
    stats.curr_conns = stats.conn_structs = 0;
    stats.get_cmds = stats.get_hits = stats.get_misses = 0;
    stats.ialloc_failed = 0;
    stats.started = time(NULL);
    pthread_mutex_init(&stats.stats_lock, NULL);
    return;
}

/***
 * initial the enev of server
 */
static void enev_init(){
    struct rlimit rlim;
    if (getrlimit(RLIMIT_NOFILE, &rlim) != 0) {
        fprintf(stderr, "failed to getrlimit number of files\n");
        exit(1);
    } else {
        int maxfiles = settings.maxconns;
        if (rlim.rlim_cur < maxfiles)
            rlim.rlim_cur = maxfiles;
        if (rlim.rlim_max < rlim.rlim_cur)
            rlim.rlim_max = rlim.rlim_cur;
        if (setrlimit(RLIMIT_NOFILE, &rlim) != 0) {
            fprintf(stderr, "failed to set rlimit for open files. Try running as root or requesting smaller maxconns value.\n");
            exit(1);
        }
    } 
}

/***
 * usage of the server
 */
static void usage(void) {
    printf("-p <num>   TCP port to listen on (default: 9898)\n"
        "-l <ip_addr>  interface to listen on, default is INDRR_ANY\n"
        "-c <num>      max simultaneous connections (default: 1024)\n"
        "-d            daemon\n"
        "-h            help\n"
        "-v            verbose (print errors/warnings)\n"
        "-s            strict mode (exit while open hdb failed before startup)\n"
        "-t <num>      number of worker threads to use, default 4\n"
        "-T <num>      timeout in millisecond, 0 for none, default 0\n");
    return;
}

/***
 * thread worker with memcached protocol
 */
static void* worker(void *arg)
{
    pthread_detach(pthread_self()); //detach the work thread

    hdb_t *hdb = (hdb_t *)arg;
    hdict_t *hdict;
    conn *c;
    while(1) {
        c = cq_pop(&REQ);

        struct timeval now;
        gettimeofday(&now, NULL);

        struct timeval tv;
        mytimesub(&now, &c->tv, &tv);
        
        if (settings.timeout > 0 && tv.tv_sec * 1000 + tv.tv_usec/1000 > settings.timeout) {    /* process timeout */
            pack_string(c, "SERVER_ERROR timeout");
            STATS_LOCK(stats);
            stats.timeouts++;
            STATS_UNLOCK(stats);
        } else if (strcmp(c->cmd, "stats") == 0) {      /* process stats command */
            char temp[1024];
            pid_t pid = getpid();
            char *pos = temp;

            uint32_t length = cq_length(&REQ);
            STATS_LOCK(stats);
            pos += sprintf(pos, "STAT pid %u\r\n", pid);
            pos += sprintf(pos, "STAT uptime %lld\r\n", (long long)stats.started);
            pos += sprintf(pos, "STAT curr_connections %u\r\n", stats.curr_conns - 1); /* ignore listening conn */
            pos += sprintf(pos, "STAT connection_structures %u\r\n", stats.conn_structs);
            pos += sprintf(pos, "STAT cmd_get %u\r\n", stats.get_cmds);
            pos += sprintf(pos, "STAT get_hits %u\r\n", stats.get_hits);
            pos += sprintf(pos, "STAT get_misses %u\r\n", stats.get_misses);
            pos += sprintf(pos, "STAT threads %u\r\n", settings.num_threads);
            pos += sprintf(pos, "STAT timeouts %u\r\n", stats.timeouts);
            pos += sprintf(pos, "STAT waiting_requests %u\r\n", length);
            pos += sprintf(pos, "STAT ialloc_failed %u\r\n", stats.ialloc_failed);
            pos += sprintf(pos, "END");
            STATS_UNLOCK(stats);
            pack_string(c, temp);
        } else if (strcmp(c->cmd, "stats reset") == 0) {    /* reset the status */
            STATS_LOCK(stats);
            stats.get_cmds = 0;
            stats.get_hits = 0;
            stats.get_misses = 0;
            stats.timeouts = 0;
            stats.ialloc_failed = 0;
            STATS_UNLOCK(stats);
            pack_string(c, "RESET");
        } else if (strncmp(c->cmd, "open ", 5) == 0 ||
            strncmp(c->cmd, "reopen ", 7) == 0) {   /* open or reopen the db */

            char path[256];
            int res = sscanf(c->cmd, "%*s %255s\n", path);
            if (res != 1 || strlen(path) == 0) {
                pack_string(c, "CLIENT_ERROR bad command line format");
            } else {
                int status = hdb_reopen(hdb, path);
                if (status == 0) {
                    pack_string(c, "OPENED");
                } else {
                    if (settings.verbose > 0)
                        fprintf(stderr, "failed to open %s, return %d\n",
                            path, status);
                    if (status == EHDICT_OUT_OF_MEMERY) {
                        STATS_LOCK(stats);
                        stats.ialloc_failed++;
                        STATS_UNLOCK(stats);
                    }
                    pack_string(c, "SERVER_ERROR open failed");
                }
            }
        } else if (strncmp(c->cmd, "append ", 7) == 0) {   /* open or reopen the db */
            char path[256];
            int res = sscanf(c->cmd, "%*s %255s\n", path);
            if (res != 1 || strlen(path) == 0) {
                pack_string(c, "CLIENT_ERROR bad command line format");
            } else {
                int status = hdb_append(hdb, path);
                if (status == 0) {
                    pack_string(c, "OPENED");
                } else {
                    if (settings.verbose > 0)
                        fprintf(stderr, "failed to open %s, return %d\n",path, status);
                    if (status == EHDICT_OUT_OF_MEMERY) {
                        STATS_LOCK(stats);
                        stats.ialloc_failed++;
                        STATS_UNLOCK(stats);
                    }
                    pack_string(c, "SERVER_ERROR open failed");
                }
            }
        } else if (strncmp(c->cmd, "close ", 6) == 0) {     /* close the db */
            char label[21];
            int res;
            const char* command = c->cmd + 6;
            int pos = find_index(command, ' ');
            if (pos < 0){
                res = hdb_close(hdb, command, 0);
            }else{
                strncpy(label, command, pos);
                uint32_t version = strtoul(command + pos + 1, NULL, 10);
                res = hdb_close(hdb, label, version); 
            }
            if (res >= 1) {
                pack_string(c, "CLOSED");
            } else {
                pack_string(c, "NOT_FOUND");
            }
        } else if (strncmp(c->cmd, "info", 4) == 0) {   /* show the hdb info */
            char temp[4096];
            hdb_info(hdb, temp, 4096);
            pack_string(c, temp);
        } else if (strncmp(c->cmd, "get ", 4) == 0) {   /* get the key from db */
            char *start = c->cmd + 4;
            char token[251];
            char label[21];
            int next;
            //uint64_t key;
            off_t off;
            uint32_t length;
            c->wbytes = 0;
            int res, nc;
            char *en_dash;
            while(sscanf(start, " %250s%n", token, &next) >= 1) {
                start += next;

                STATS_LOCK(stats);
                stats.get_cmds++;
                STATS_UNLOCK(stats);
                char *str_key;
                if ((en_dash = strchr(token, '-')) == NULL) {
                    //key = strtoull(token, NULL, 10);
                    str_key = token;
                } else {
                    *en_dash = '\0';
                    strcpy(label, token);
                    //key = strtoull(en_dash+1, NULL, 10);
                    str_key = en_dash+1;
                }
                if (hdict_search(hdb, label, str_key, &off, &length, &hdict)) {
                    STATS_LOCK(stats);
                    stats.get_hits++;
                    STATS_UNLOCK(stats);
                    if (length < HDICT_VALUE_LENGTH_MAX) {
                        if (c->wsize - c->wbytes < 512 + length) {
                            int relloc_length = c->wsize * 2;
                            if (relloc_length - c->wbytes < 512 + length) {
                                relloc_length = 512 + length + c->wbytes;
                                relloc_length = (relloc_length/DATA_BUFFER_SIZE + 1) * DATA_BUFFER_SIZE;
                            }
                            char *newbuf = (char *)realloc(c->wbuf, relloc_length);
                            if (newbuf) {
                                c->wbuf = newbuf;
                                c->wsize = relloc_length;
                            } else {
                                if (settings.verbose > 0)
                                    fprintf(stderr, "Couldn't realloc output buffer\n");
                            }
                        }

                        nc = sprintf(c->wbuf + c->wbytes, "VALUE %s %u %u\r\n", token, 0, length);
                        res = hdict_read(hdict, c->wbuf + c->wbytes + nc, length, off);
                        if (res != length) {
                            if (settings.verbose > 0)
                                fprintf(stderr, "Failed to read from hdict\n");
                        }

                        c->wbytes += nc;
                        c->wbytes += length;
                        c->wbytes += sprintf(c->wbuf + c->wbytes, "\r\n");
                    }
                } else {
                    STATS_LOCK(stats);
                    stats.get_misses++;
                    STATS_UNLOCK(stats);
                }
            }
            c->wbytes += sprintf(c->wbuf + c->wbytes, "END\r\n");
        } else {
            pack_string(c, "ERROR");
        }

        cq_push(&RSP, c);
        pthread_mutex_lock(&notify_lock);
        if (write(notify_send_fd, "", 1) != 1) {
            perror("Writing to thread notify pipe");
        }
        pthread_mutex_unlock(&notify_lock);
    }

    return NULL;
}

int main(int argc, char* argv[]){
    int c;
    int i;
    struct in_addr addr;
    settings_init();
    while ((c = getopt(argc, argv, "p:c:hvdl:t:T:i:")) != -1) {
        switch (c) {
        case 'p':
            settings.port = atoi(optarg);
            break;
        case 'c':
            settings.maxconns = atoi(optarg);
            break;
        case 'h':
            usage();
            exit(EXIT_SUCCESS);
        case 'l':
            if (inet_pton(AF_INET, optarg, &addr) <= 0) {
                fprintf(stderr, "Illegal address: %s\n", optarg);
                return 1;
            } else {
                settings.interf = addr;
            }
            break;
        case 'd':
            settings.daemonize = 1;
            break;
        case 'v':
            settings.verbose++;
            break;
        case 't':
            settings.num_threads = atoi(optarg);
            if (settings.num_threads == 0) {
                fprintf(stderr, "Number of threads must be greater than 0\n");
                return 1;
            }
            break;
        case 'T':
            settings.timeout = atoi(optarg);
            break;
        default:
            fprintf(stderr, "Illegal argument \"%c\"\n", c);
            return 1;
        }
    }

    srand(time(NULL)^getpid());
    //enev_init();

    if (settings.daemonize) {
        int res;
        res = daemon(1, settings.verbose);
        if (res == -1) {
            fprintf(stderr, "failed to daemon() in order to daemonize\n");
            return 1;
        }
    }

    stats_init();
    conn_init();
    /* create the socket */
    l_socket = server_socket(settings.port);
    if (l_socket == -1) {
        fprintf(stderr, "failed to listen\n");
        exit(1);
    }

    cq_init(&REQ, 1);
    cq_init(&RSP, 0);

    /* create the pipe for receive/send notify */
    int fds[2];
    if (pipe(fds)) {
        fprintf(stderr, "can't create notify pipe\n");
        exit(1);
    }
    notify_receive_fd = fds[0];
    notify_send_fd = fds[1];

    hdb_t hdb;
    hdb_init(&hdb);

    /* hdb manager thread */
    pthread_t tid;
    pthread_create(&tid, NULL, hdb_mgr, &hdb);

    /* start worker thread */
    for (i = 0; i < settings.num_threads; i++) {
        pthread_create(&tid, NULL, worker, &hdb);
    }
    
    /* signal process */
    struct sigaction sa;
    sa.sa_handler = SIG_IGN;
    sa.sa_flags = 0;
    if (sigemptyset(&sa.sa_mask) == -1 ||
        sigaction(SIGPIPE, &sa, 0) == -1) {
        perror("failed to ignore SIGPIPE; sigaction");
        exit(1);
    }

    /* libevent */
    struct event_base *main_base = event_init();
    struct event notify_event;

    event_set(&notify_event, notify_receive_fd,
        EV_READ | EV_PERSIST, notify_handler, NULL);
    event_base_set(main_base, &notify_event);

    if (event_add(&notify_event, 0) == -1) {
        fprintf(stderr, "can't monitor libevent notify pipe\n");
        exit(1);
    }

    conn *listen_conn;
    if (!(listen_conn = conn_new(l_socket, conn_listening,
            EV_READ | EV_PERSIST, main_base))) {
        fprintf(stderr, "failed to create listening connection");
        exit(1);
    }
    event_base_loop(main_base, 0);
    return 0;
}
