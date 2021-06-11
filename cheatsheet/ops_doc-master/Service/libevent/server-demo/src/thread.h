#ifndef __THREAD_H__
#define __THREAD_H__

void thread_init (int nthreads);
void dispatch_conn_new (int sfd, enum conn_states init_state, int event_flags);

#endif
