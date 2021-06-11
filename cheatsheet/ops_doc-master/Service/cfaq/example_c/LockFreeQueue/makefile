# -fno-schedule-insns -fno-rerun-loop-opt are a workaround for a compiler error in 4.2
# -Wno-unused-parameter

CC      = g++
CFLAGS  = -g -O3 -fopenmp -fno-schedule-insns -fno-schedule-insns2 -W -Wall #-Wno-unused-parameter
CFLAGS += `pkg-config --cflags glib-2.0`
#CFLAGS += -march=i686
#CFLAGS += -march=core2
LDFLAGS = -lgomp
LDFLAGS+= `pkg-config --libs glib-2.0`
# g_blocking_queue also depends on gthread-2.0
CFLAGS_GTHREAD = `pkg-config gthread-2.0`
LDFLAGS_GTHREAD = `pkg-config --libs gthread-2.0`

#compile-time parameters
ifdef N_PRODUCERS
CFLAGS += -DN_PRODUCERS=$(N_PRODUCERS)
endif
ifdef N_CONSUMERS
CFLAGS += -DN_CONSUMERS=$(N_CONSUMERS)
endif
ifdef N_ITERATIONS
CFLAGS += -DN_ITERATIONS=$(N_ITERATIONS)
endif
ifdef QUEUE_SIZE
CFLAGS += -DQUEUE_SIZE=$(QUEUE_SIZE)
endif


LOCK_FREE_Q_INCLUDE = \
    array_lock_free_queue.h \
    array_lock_free_queue_impl.h

BLOCKING_Q_INCLUDE = \
    g_blocking_queue.h \
    g_blocking_queue_impl.h

LOCK_FREE_SINGLE_PRODUCER_Q_INCLUDE = \
    array_lock_free_queue_single_producer.h \
    array_lock_free_queue_single_producer_impl.h

SHARED_INCLUDE = \
    atomic_ops.h

all : test_lock_free_q  test_lock_free_single_producer_q test_blocking_q

test_lock_free_q : test_lock_free_q.o
	$(CC) $(OBJS) -o $@ $@.o $(LDFLAGS)

test_blocking_q : test_blocking_q.o
	$(CC) $(OBJS) -o $@ $@.o $(LDFLAGS) $(LDFLAGS_GTHREAD)

test_lock_free_single_producer_q : test_lock_free_single_producer_q.o
	    $(CC) $(OBJS) -o $@ $@.o $(LDFLAGS)
    
test_lock_free_q.o : test_lock_free_q.cpp $(SHARED_INCLUDE) $(LOCK_FREE_Q_INCLUDE)
	$(CC) -c $< $(CFLAGS)

test_lock_free_single_producer_q.o : test_lock_free_single_producer_q.cpp $(SHARED_INCLUDE) $(LOCK_FREE_SINGLE_PRODUCER_Q_INCLUDE)
	$(CC) -c $< $(CFLAGS)
    
test_blocking_q.o: test_blocking_q.cpp $(SHARED_INCLUDE) $(BLOCKING_Q_INCLUDE)
	$(CC) -c $< $(CFLAGS) $(CFLAGS_GTHREAD) 

clean:
	rm test_lock_free_q test_blocking_q test_lock_free_single_producer_q; rm *.o

