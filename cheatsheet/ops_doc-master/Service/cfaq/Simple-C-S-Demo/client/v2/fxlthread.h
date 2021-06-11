#ifndef _FXL_THREAD_H
#define _FXL_THREAD_H

#include <pthread.h>

//#ifdef _LINUX_
#define FUNCALLBACK void *
#define THDHANDLE pthread_t
#define ThreadCreate(th,fun,prm) {int nRet = pthread_create(&th,NULL,fun,prm);}
#define WaitForThreadEnd(th) {void *p = NULL; pthread_join(th,&p);}
#define ThreadDetach(th) {pthread_detach(th);}
#define ThreadClose(th)
#define SocketClose(sock) close(sock)
//#endif //_LINUX_

#endif  //_FXL_THREAD_H
