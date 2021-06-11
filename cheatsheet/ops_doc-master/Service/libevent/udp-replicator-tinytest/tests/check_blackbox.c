#include <sys/param.h>
#include <sys/stat.h>

#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "tinytest.h"
#include "tinytest_macros.h"


struct context {
	char			fname_err[64];
	int			fd_err;
	int			fd_err_old;
	int			keep_err; /* preserve stderr file */
};

int
has_str_in_file(int fd, const char *str)
{
	char buf[512];
	ssize_t n;

	if (lseek(fd, 0, 0) == -1)
		return 0;
	n = read(fd, buf, sizeof(buf));
	if (n < 0)
		return 0;
	buf[n] = '\0';
	if (strstr(buf, str) == NULL)
		return 0;
	return 1;
}

int timeout_flag = 0;

void timeout(int signal)
{

	timeout_flag = 1;
}

void
test_empty_port(void *ctx_)
{
	struct context *ctx = ctx_;
	struct stat st;
	char path[8];
	char cmd[64];
	int rc;

	if (stat("./udp-replicator", &st) == 0)
		strncpy(path, ".", sizeof(path) - 1);
	else if (stat("../udp-replicator", &st) == 0)
		strncpy(path, "..", sizeof(path) - 1);
	else
		tt_abort_perror("stat(udp-replicator)");
	rc = snprintf(cmd, sizeof(cmd), "%s/udp-replicator -g 1 127.0.0.1", path);
	if (rc >= sizeof(cmd))
		tt_abort_perror("snprintf");
	signal(SIGALRM, timeout);
	alarm(2);
	rc = system(cmd);
	if (timeout_flag)
		tt_abort_msg("timeout during test");
	alarm(0);
	tt_want_int_op(rc, !=, 0);
	if (!has_str_in_file(ctx->fd_err, "doesn't include port")) {
		ctx->keep_err = 1;
		tt_abort_msg("stderr didn't include error message");
	}

end:
	;
}

static void *
setup(const struct testcase_t *testcase)
{
	struct context *ctx;

	ctx = calloc(1, sizeof(*ctx));
	if (!ctx)
		goto err;
	ctx->fd_err = ctx->fd_err_old = -1;
	strncpy(ctx->fname_err, "stderr.XXXXXX", sizeof(ctx->fname_err) - 1);
	ctx->fd_err = mkstemp(ctx->fname_err);
	if (ctx->fd_err < 0)
		goto err;
	ctx->fd_err_old = dup(STDERR_FILENO);
	dup2(ctx->fd_err, STDERR_FILENO);
	return ctx;

err:
	if (ctx)
		free(ctx);
	return NULL;
}

static int
cleanup(const struct testcase_t *testcase, void *ctx_)
{
	struct context *ctx = ctx_;

	if (ctx->fd_err_old) {
		dup2(ctx->fd_err_old, STDERR_FILENO);
		close(ctx->fd_err_old);
	}
	if (ctx->fd_err)
		close(ctx->fd_err);
	if (ctx->keep_err == 0)
		unlink(ctx->fname_err);
	free(ctx);
	return 1;
}


static struct testcase_setup_t tc_setup = {setup, cleanup};

struct testcase_t tc_blackbox[] = {
	{"test_empty_port", test_empty_port, TT_FORK, &tc_setup},
	END_OF_TESTCASES
};

