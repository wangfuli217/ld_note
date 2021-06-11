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
#include <ctype.h>
#include <assert.h>
#include <signal.h>

#include "format/fmt.h"
#include "log.h"

/* ------------------------------------------------------------ */
/*
 * All Firebert standalones call these two routines
 *
 */

/*
 * Configure run time environment 
 */
void firebert_init(void);

/*
 * Start event loop 
 */
void firebert_dispatch(void);

/*
 */
const char *strint(int i);
#define tassert(x) fail_unless((x), (char*)strint(__LINE__))
