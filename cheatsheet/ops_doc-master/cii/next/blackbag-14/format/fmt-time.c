#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <time.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
#include <assert.h>
#include <ctype.h>

#include "format/fmt.h"
#include "format/fmt-extra.h"

/* -------------------------------------------------------------------- */

static void
fmt_netflow_time(fmt_code_info_t *cvt)
{
	char buf[256];
	size_t l = 0;
	const time_t rp = va_arg(*cvt->app, const time_t);
	struct tm *tp = localtime(&rp);
	l = strftime(buf, sizeof buf, "%Y-%m-%d %H:%T", tp);
	fmt_puts(buf, l, cvt);
}

void
fmt_register_time(char c)
{
	fmt_register(toupper(c), fmt_netflow_time);
}


