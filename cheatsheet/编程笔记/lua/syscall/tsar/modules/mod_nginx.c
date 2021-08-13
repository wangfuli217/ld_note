#include <sys/socket.h>
#include <sys/un.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include "tsar.h"

struct stats_nginx {
    unsigned long long naccept;     /* accepted connections */
    unsigned long long nhandled;    /* handled connections */
    unsigned long long nrequest;    /* handled requests */
    unsigned long long nactive;     /* number of all open connections including connections to backends */
    unsigned long long nreading;    /* nginx reads request header */
    unsigned long long nwriting;    /* nginx reads request body, processes request, or writes response to a client */
    unsigned long long nwaiting;    /* keep-alive connections, actually it is active - (reading + writing) */
    unsigned long long nrstime;     /* reponse time of handled requests */
    unsigned long long nspdy;       /* spdy requests */
    unsigned long long nsslhds;     /* ssl handshake */
    unsigned long long nssl;        /* ssl requests */
    unsigned long long nsslk;       /* ssl keepalive requests */
    unsigned long long nsslf;       /* ssl failed request */
    unsigned long long nsslv3f;     /* sslv3 failed request */
    unsigned long long nhttp2;      /* http2 requests */
};

struct hostinfo {
    char *host;
    int   port;
    char *server_name;
    char *uri;
};

static char *nginx_usage = "    --nginx             nginx statistics";

static struct mod_info nginx_info[] = {
    {"accept", DETAIL_BIT,  0,  STATS_SUB},
    {"handle", DETAIL_BIT,  0,  STATS_SUB},
    {"  reqs", DETAIL_BIT,  0,  STATS_SUB},
    {"active", DETAIL_BIT,  0,  STATS_NULL},
    {"  read", DETAIL_BIT,  0,  STATS_NULL},
    {" write", DETAIL_BIT,  0,  STATS_NULL},
    {"  wait", DETAIL_BIT,  0,  STATS_NULL},
    {"   qps", SUMMARY_BIT, 0,  STATS_SUB_INTER},
    {"    rt", SUMMARY_BIT, 0,  STATS_NULL},
    {"sslqps", SUMMARY_BIT, 0,  STATS_SUB_INTER},
    {"spdyps", SUMMARY_BIT, 0,  STATS_SUB_INTER},
    {"  sslf", SUMMARY_BIT, 0,  STATS_SUB_INTER},
    {"sslv3f", SUMMARY_BIT, 0,  STATS_SUB_INTER},
    {" h2qps", SUMMARY_BIT, 0,  STATS_SUB_INTER},
    {"sslhds", SUMMARY_BIT, 0,  STATS_SUB_INTER},
    {"  sslk", SUMMARY_BIT, 0,  STATS_SUB_INTER},
};


static void
set_nginx_record(struct module *mod, double st_array[],
    U_64 pre_array[], U_64 cur_array[], int inter)
{
    int i;
    for (i = 0; i < 3; i++) {
        if (cur_array[i] >= pre_array[i]) {
            st_array[i] = cur_array[i] - pre_array[i];
        } else {
            st_array[i] = 0;
        }
    }

    for (i = 3; i < 7; i++) {
        st_array[i] = cur_array[i];
    }

    if (cur_array[2] >= pre_array[2]) {
        st_array[7] = (cur_array[2] - pre_array[2]) * 1.0 / inter;
    } else {
        st_array[7] = 0;
    }

    if (cur_array[8] >= pre_array[8]) {
        if (cur_array[2] > pre_array[2]) {
            st_array[8] = (cur_array[8] - pre_array[8]) * 1.0 / (cur_array[2] - pre_array[2]);
        } else {
            st_array[8] = 0;
        }
    }

    for (i = 9; i < 16;  i++){
        if (cur_array[i] >= pre_array[i]) {
            st_array[i] = (cur_array[i] - pre_array[i]) * 1.0 / inter;
        } else {
            st_array[i] = 0;
        }
    }
}


static void
init_nginx_host_info(struct hostinfo *p)
{
    char *port;

    p->host = getenv("NGX_TSAR_HOST");
    p->host = p->host ? p->host : "127.0.0.1";

    port = getenv("NGX_TSAR_PORT");
    p->port = port ? atoi(port) : 80;

    p->uri = getenv("NGX_TSAR_URI");
    p->uri = p->uri ? p->uri : "/nginx_status";

    p->server_name = getenv("NGX_TSAR_SERVER_NAME");
    p->server_name = p->server_name ? p->server_name : "status.taobao.com";
}


static void
read_nginx_stats(struct module *mod, char *parameter)
{
    int                 write_flag = 0, addr_len, domain;
    int                 m, sockfd, send, pos;
    void               *addr;
    char                buf[LEN_4096], request[LEN_4096], line[LEN_4096];
    FILE               *stream = NULL;

    struct timeval      timeout;
    struct hostinfo     hinfo;
    struct sockaddr_in  servaddr;
    struct sockaddr_un  servaddr_un;


    init_nginx_host_info(&hinfo);
    if (atoi(parameter) != 0) {
       hinfo.port = atoi(parameter);
    }
    struct stats_nginx st_nginx;
    memset(&st_nginx, 0, sizeof(struct stats_nginx));

    if (*hinfo.host == '/') {
        addr = &servaddr_un;
        addr_len = sizeof(servaddr_un);
        bzero(addr, addr_len);
        domain = AF_LOCAL;
        servaddr_un.sun_family = AF_LOCAL;
        strncpy(servaddr_un.sun_path, hinfo.host, sizeof(servaddr_un.sun_path) - 1);

    } else {
        addr = &servaddr;
        addr_len = sizeof(servaddr);
        bzero(addr, addr_len);
        domain = AF_INET;
        servaddr.sin_family = AF_INET;
        servaddr.sin_port = htons(hinfo.port);
        inet_pton(AF_INET, hinfo.host, &servaddr.sin_addr);
    }

    if ((sockfd = socket(domain, SOCK_STREAM, 0)) == -1) {
        goto writebuf;
    }

    sprintf(request,
            "GET %s HTTP/1.0\r\n"
            "User-Agent: taobot\r\n"
            "Host: %s\r\n"
            "Accept:*/*\r\n"
            "Connection: Close\r\n\r\n",
            hinfo.uri, hinfo.server_name);

    if ((m = connect(sockfd, (struct sockaddr *) addr, addr_len)) == -1 ) {
        goto writebuf;
    }

    timeout.tv_sec = 10;
    timeout.tv_usec = 0;
    setsockopt(sockfd, SOL_SOCKET, SO_SNDTIMEO, (char *)&timeout, sizeof(struct timeval));
    setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, (char *)&timeout, sizeof(struct timeval));

    if ((send = write(sockfd, request, strlen(request))) == -1) {
        goto writebuf;
    }

    if ((stream = fdopen(sockfd, "r")) == NULL) {
        goto writebuf;
    }

    while (fgets(line, LEN_4096, stream) != NULL) {
        if (!strncmp(line, "Active connections:", sizeof("Active connections:") - 1)) {
            sscanf(line + sizeof("Active connections:"), "%llu", &st_nginx.nactive);
            write_flag = 1;
        } else if (!strncmp(line,
                            "server accepts handled requests request_time",
                            sizeof("server accepts handled requests request_time") - 1)
                  ) {
            /*for tengine*/
            if (fgets(line, LEN_4096, stream) != NULL) {
                 if (!strncmp(line, " ", 1)) {
                    sscanf(line + 1, "%llu %llu %llu %llu",
                             &st_nginx.naccept, &st_nginx.nhandled, &st_nginx.nrequest, &st_nginx.nrstime);
                    write_flag = 1;
                }
            }
        } else if (!strncmp(line,
                            "server accepts handled requests",
                            sizeof("server accepts handled requests") - 1)
                  ) {
            /*for nginx*/
            if (fgets(line, LEN_4096, stream) != NULL) {
                 if (!strncmp(line, " ", 1)) {
                    sscanf(line + 1, "%llu %llu %llu",
                             &st_nginx.naccept, &st_nginx.nhandled, &st_nginx.nrequest);
                    write_flag = 1;
                }
            }
        } else if (!strncmp(line, "Server accepts:", sizeof("Server accepts:") - 1)) {
            sscanf(line , "Server accepts: %llu handled: %llu requests: %llu request_time: %llu",
                    &st_nginx.naccept, &st_nginx.nhandled, &st_nginx.nrequest, &st_nginx.nrstime);
            write_flag = 1;

        } else if (!strncmp(line, "Reading:", sizeof("Reading:") - 1)) {
            sscanf(line, "Reading: %llu Writing: %llu Waiting: %llu",
                    &st_nginx.nreading, &st_nginx.nwriting, &st_nginx.nwaiting);
            write_flag = 1;
        } else if (!strncmp(line, "SSL:", sizeof("SSL:") - 1)) {
            sscanf(line, "SSL: %llu SPDY: %llu",
                    &st_nginx.nssl, &st_nginx.nspdy);
            write_flag = 1;
        } else if (!strncmp(line, "HTTP2:", sizeof("HTTP2:") - 1)) {
            sscanf(line, "HTTP2: %llu",
                    &st_nginx.nhttp2);
            write_flag = 1;
        } else if (!strncmp(line, "SSL_failed:", sizeof("SSL_failed:") - 1)) {
            sscanf(line, "SSL_failed: %llu",
                    &st_nginx.nsslf);
            write_flag = 1;
        } else if (!strncmp(line, "SSLv3_failed:", sizeof("SSLv3_failed:") - 1)) {
            sscanf(line, "SSLv3_failed: %llu",
                    &st_nginx.nsslv3f);
            write_flag = 1;
        } else if (!strncmp(line, "SSL_handshake:", sizeof("SSL_handshake:") - 1)) {
            sscanf(line, "SSL_handshake: %llu",
                    &st_nginx.nsslhds);
            write_flag = 1;
        } else if (!strncmp(line, "SSL_keepalive_reqs:", sizeof("SSL_keepalive_reqs:") - 1)) {
            sscanf(line, "SSL_keepalive_reqs: %llu",
                    &st_nginx.nsslk);
            write_flag = 1;
        } else {
            ;
        }
    }
    if (st_nginx.nrequest == 0) {
        write_flag = 0;
    }

writebuf:
    if (stream) {
        fclose(stream);
    }

    if (sockfd != -1) {
        close(sockfd);
    }

    if (write_flag) {
        pos = sprintf(buf, "%lld,%lld,%lld,%lld,%lld,%lld,%lld,%lld,%lld,%lld,%lld,%lld,%lld,%lld,%lld,%lld",
                st_nginx.naccept,
                st_nginx.nhandled,
                st_nginx.nrequest,
                st_nginx.nactive,
                st_nginx.nreading,
                st_nginx.nwriting,
                st_nginx.nwaiting,
                st_nginx.nrequest,
                st_nginx.nrstime,
                st_nginx.nssl,
                st_nginx.nspdy,
                st_nginx.nsslf,
                st_nginx.nsslv3f,
                st_nginx.nhttp2,
                st_nginx.nsslhds,
                st_nginx.nsslk
                 );
        buf[pos] = '\0';
        set_mod_record(mod, buf);
    }
}

void
mod_register(struct module *mod)
{
    register_mod_fields(mod, "--nginx", nginx_usage, nginx_info, 16, read_nginx_stats, set_nginx_record);
}
