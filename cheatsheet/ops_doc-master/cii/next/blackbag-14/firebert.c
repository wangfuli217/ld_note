#include <sys/time.h>
#include <sys/types.h>
#include <sys/resource.h>

#include <stdlib.h>

#include "firebert.h"
#include "event.h"
#include "timer.h"
#include "log.h"
#include "format/fmt.h"
#include "format/fmt-extra.h"
#if 0
#include "stacktrace.h"
#endif
#include <unistd.h>

#include "event.h"

static void heap_ticker(int fd, short code, void *arg);
static void siginfo(int fd, short code, void *arg);
static void sigpipe(int fd, short code, void *arg);

#if 0
static void diaper(int sig, siginfo_t *info, struct sigcontext *scp);
static void sig_stacktrace(int sig, siginfo_t *info, struct sigcontext *scp);
#endif

static time_t ProgramStarted = 0;

/* --------------------------------------------------------- */

void
firebert_init(void)
{
	static struct event siginfo_ctx;
	static struct event sigpipe_ctx;
	struct timeval tv = { 0, 0 }; 

	ProgramStarted = time(NULL);

	log_level_set(LOG_STATUS);

        event_init();

#ifdef SIGINFO
	signal_set(&siginfo_ctx, SIGINFO, siginfo, NULL);
	signal_add(&siginfo_ctx, &tv);
#endif

	signal_set(&sigpipe_ctx, SIGPIPE, sigpipe, NULL);
	signal_add(&sigpipe_ctx, &tv);

	/* Can't REALLY use libevent for these --- 
	 * memory is corrupt!
	 */	

#if 0
	if (diaper_on) {
		signal(SIGSEGV, (sig_t)diaper);
		signal(SIGBUS, (sig_t)diaper);
		signal(SIGABRT, (sig_t)diaper);
		signal(SIGILL, (sig_t)diaper);
		signal(SIGFPE, (sig_t)diaper);
	}

	signal(SIGUSR2, (sig_t)sig_stacktrace);
#endif
}

/* --------------------------------------------------------- */

void
firebert_dispatch(void) {
	static struct event timeout_ctx;
	int go = 1;

	while (go) {
		static struct timeval next, *np = NULL;

		event_del(&timeout_ctx);
		if((np = timer_timeout(&next))) {
			timeout_set(&timeout_ctx, heap_ticker, NULL);
			timeout_add(&timeout_ctx, np);
		}

		if (event_loop(EVLOOP_ONCE) == -1)
			go = 0;
	}
}

/* --------------------------------------------------------- */

static void
heap_ticker(int fd, short code, void *arg) {
	timer_process_all();
}

/* --------------------------------------------------------- */

time_t
program_started(void) {
	return(ProgramStarted);
}

/* --------------------------------------------------------- */

static void
siginfo(int fd, short code, void *arg) {
	log_level_set((log_level_get() + 1) % (LOG_CODE + 1));
//	log_warn("#DEBUG-SET-TO %d", log_level_get());		
}

/* --------------------------------------------------------- */

static void
sigpipe(int fd, short code, void *arg) {
	log_code("#CAUGHT-SIGPIPE");
}

/* --------------------------------------------------------- */

#if 0 

#define HEADER 	"*** ABNORMAL TERMINATION"
#define STACKH  "Trace:\t"
#define TRAILR  "*** --------------------"

/* Remember, this is called post-SEGV --- memory isn't 
 * trustworthy, and, in particular, you aren't allowed
 * to allocate more of it.
 */
static void
diaper(int sig, siginfo_t *info, struct sigcontext *scp) {
	time_t ended = time(0);
	time_t lasted = ended - program_started();
	char buf[100];
	u_int32_t *trace = NULL;
	int ret = 0, i = 0, l = 0;

	l = fmt_sfmt(buf, 100, "\n(sig %d)\nProgram ran %d seconds\n", sig, lasted);

	write(2, HEADER, sizeof HEADER - 1);
	write(2, buf, l);
	write(2, STACKH, sizeof STACKH - 1);

	ret = stack_trace(&trace);
	/* 
	 * overwrite signal trampoline address with the address the program
	 * was at when the signal was received.
	 */
	trace[1] = scp->sc_eip;

	for(i = 0; i < ret; i++) {
		l = fmt_sfmt(buf, 100, "\t\t0x%x\n", trace[i]);
		write(2, buf, l);
	}

	write(2, TRAILR, sizeof TRAILR - 1);

	kill(getpid(), SIGTRAP); /* generate actual core */	
}

static void
sig_stacktrace(int sig, siginfo_t *info, struct sigcontext *scp)
{
	u_int32_t *trace = NULL;
	char buf[100];
	int ret = 0, i = 0, l = 0;

#define STHEADER 	"*** STACK TRACE"

	log_status(STHEADER);
	log_status(STACKH);

	ret = stack_trace(&trace);
	/* 
	 * overwrite signal trampoline address with the address the program
	 * was at when the signal was received.
	 */
	trace[1] = scp->sc_eip;

	for(i = 0; i < ret; i++) {
		l = fmt_sfmt(buf, 100, "\t\t0x%x\n", trace[i]);
		log_status(buf);
	}

	log_status(TRAILR);

	return;
}

#endif

/* ------------------------------------------------------------ */

