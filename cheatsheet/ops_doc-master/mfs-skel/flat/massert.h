#ifndef _MASSERT_H_
#define _MASSERT_H_

#include <stdio.h>
#include <syslog.h>
#include <stdlib.h>
#include <errno.h>

#include "strerr.h"

#define ldebug() (fprintf(stderr,"%s:%u - failed assertion \n",__FILE__,__LINE__) )

#define massert(e,msg) ((e) ? (void)0 : (fprintf(stderr,"%s:%u - failed assertion '%s' : %s\n",__FILE__,__LINE__,#e,(msg)),syslog(LOG_ERR,"%s:%u - failed assertion '%s' : %s",__FILE__,__LINE__,#e,(msg)),abort()))
#define sassert(e) ((e) ? (void)0 : (fprintf(stderr,"%s:%u - failed assertion '%s'\n",__FILE__,__LINE__,#e),syslog(LOG_ERR,"%s:%u - failed assertion '%s'",__FILE__,__LINE__,#e),abort()))
#define passert(ptr) if (ptr==NULL) { \
        fprintf(stderr,"%s:%u - out of memory: %s is NULL\n",__FILE__,__LINE__,#ptr); \
        syslog(LOG_ERR,"%s:%u - out of memory: %s is NULL",__FILE__,__LINE__,#ptr); \
        abort(); \
    } else if (ptr==((void*)(-1))) { \
        const char *_mfs_errorstring = strerr(errno); \
        syslog(LOG_ERR,"%s:%u - mmap error on %s, error: %s",__FILE__,__LINE__,#ptr,_mfs_errorstring); \
        fprintf(stderr,"%s:%u - mmap error on %s, error: %s\n",__FILE__,__LINE__,#ptr,_mfs_errorstring); \
        abort(); \
    }
#define eassert(e) if (!(e)) { \
        const char *_mfs_errorstring = strerr(errno); \
        syslog(LOG_ERR,"%s:%u - failed assertion '%s', error: %s",__FILE__,__LINE__,#e,_mfs_errorstring); \
        fprintf(stderr,"%s:%u - failed assertion '%s', error: %s\n",__FILE__,__LINE__,#e,_mfs_errorstring); \
        abort(); \
    }
#define zassert(e) { \
    int _mfs_assert_ret = (e); \
    if (_mfs_assert_ret!=0) { \
        const char *_mfs_errorstring = strerr(errno); \
        syslog(LOG_ERR,"%s:%u - unexpected status, '%s' returned: %d (errno: %s)",__FILE__,__LINE__,#e,_mfs_assert_ret,_mfs_errorstring); \
        fprintf(stderr,"%s:%u - unexpected status, '%s' returned: %d (errno: %s)\n",__FILE__,__LINE__,#e,_mfs_assert_ret,_mfs_errorstring); \
        abort(); \
    } \
}

#endif
