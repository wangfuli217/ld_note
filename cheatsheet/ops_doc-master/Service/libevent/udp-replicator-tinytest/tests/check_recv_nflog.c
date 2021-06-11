#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "tinytest.h"
#include "tinytest_macros.h"
#include "../recv_nflog.h"

#define RULE "--dst 198.18.0.0 -p udp --dport 9 -j NFLOG"

struct context {
	int			fd;
	int			port;
	int			recv_pkts;
};

void
process_packet(char *payload, size_t payload_len, unsigned short dst_port,
    struct sockaddr *sa_src, socklen_t sa_srclen, void *ctx_)
{
	struct context *ctx = ctx_;

	switch (ctx->recv_pkts) {
	case 0:
		tt_want_str_op(payload, ==, "test");
		break;
	case 1:
		tt_want_str_op(payload, ==, "1234");
		break;
	default:
		tt_fail_msg("Unsolicited packet received");
		break;
	}
	ctx->recv_pkts++;
}

void
test_recv_nflog(void *ctx_)
{
	struct context *ctx = ctx_;
	struct recv_nflog *rcv;
	struct sockaddr_in sin;
	ssize_t n;

	rcv = recv_nflog_new(0, process_packet, ctx);
	tt_assert_msg(rcv, "Unable to open NFLOG handle");
	memset(&sin, 0, sizeof(sin));
	sin.sin_family = AF_INET;
	sin.sin_port = htons(9);
	sin.sin_addr.s_addr = htonl(0xc6120000);
	n = sendto(ctx->fd, "test", 4, 0, (struct sockaddr *)&sin, sizeof(sin));
	tt_int_op(n, ==, 4);
	recv_nflog_packet_dispatch(rcv);
	n = sendto(ctx->fd, "1234", 4, 0, (struct sockaddr *)&sin, sizeof(sin));
	tt_int_op(n, ==, 4);
	recv_nflog_packet_dispatch(rcv);
	tt_want_int_op(ctx->recv_pkts, ==, 2);

end:
	;
}


static void *
setup(const struct testcase_t *testcase)
{
	struct context *ctx;
	struct sockaddr_in sin;
	int fd;
	int rc;
	socklen_t salen;

	if (geteuid() != 0)
		return (void *)TT_SKIP;
	ctx = calloc(1, sizeof(*ctx));
	if (!ctx)
		goto err;
	ctx->fd = -1;
	memset(&sin, 0, sizeof(sin));
	sin.sin_family = AF_INET;
	ctx->fd = socket(sin.sin_family, SOCK_DGRAM, 17);
	if (ctx->fd < 0)
		goto err;
	if (bind(ctx->fd, (struct sockaddr *)&sin, sizeof(sin)) < 0)
		goto err;
	salen = sizeof(sin);
	if (getsockname(ctx->fd, (struct sockaddr *)&sin, &salen) < 0)
		goto err;
	ctx->port = ntohs(sin.sin_port);
	if (system("iptables -C OUTPUT " RULE " 2>/dev/null") != 0) {
		rc = system("iptables -I OUTPUT " RULE);
		if (rc != 0)
			goto err;
	}
	return ctx;

err:
	if (ctx->fd != -1)
		close(ctx->fd);
	if (ctx)
		free(ctx);
	return NULL;
}

static int
cleanup(const struct testcase_t *testcase, void *ctx_)
{
	struct context *ctx = ctx_;
	int rc;
	int fd;


	rc = system("iptables -D OUTPUT " RULE);
	close(ctx->fd);
	free(ctx);
	if (rc != 0)
		return 0;
	return 1;
}


static struct testcase_setup_t tc_setup = {setup, cleanup};

struct testcase_t tc_recv_nflog[] = {
	{"test_recv_nflog", test_recv_nflog, 0, &tc_setup},
	END_OF_TESTCASES
};
