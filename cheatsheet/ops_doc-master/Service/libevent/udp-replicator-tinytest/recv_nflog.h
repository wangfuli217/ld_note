#ifdef RECV_NFLOG_H
#error "recv_nflog.h included multiple times"
#endif
#define RECV_NFLOG_H
#include <sys/socket.h>

typedef void (*recv_nflog_cb_t)(char *, size_t, unsigned short,
    struct sockaddr *, socklen_t, void *);

struct recv_nflog {
	unsigned long		magic;
#define RECV_NFLOG_MAGIC	0xe039a182
	struct nflog_handle	*nf_h;
	struct nflog_g_handle	*nf_gh;
	recv_nflog_cb_t		cb_func;
	void			*cb_ctx;
};

struct recv_nflog *recv_nflog_new(int, recv_nflog_cb_t, void *);
void recv_nflog_free(struct recv_nflog *);
int recv_nflog_packet_dispatch(struct recv_nflog *);
