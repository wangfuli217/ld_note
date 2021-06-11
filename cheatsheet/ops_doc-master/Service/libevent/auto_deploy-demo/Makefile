# Makefile for Auto Deploy
C = clang
CFLAGS = -g -c `pkg-config --cflags libevent` `pkg-config --cflags hiredis`
LDFLAGS = -lm -lpthread `pkg-config --libs libevent` `pkg-config --libs hiredis`

OS_KERNEL = $(shell uname -s)
ifeq ($(OS_KERNEL), Darwin)
MICRO =	 -D __OSX__
else
MICRO =	 -D __LINUX__
LDFLAGS += -lutil
endif


all: deploy.c
	$(CC) -o daemonize.o daemonize.c $(CFLAGS)
	$(CC) -o worker.o worker.c $(CFLAGS)
	$(CC) -o redis.o redis.c $(CFLAGS)
	$(CC) -o cJSON.o cJSON.c $(CFLAGS)
	$(CC) -o process.o process.c $(CFLAGS) $(MICRO)
	$(CC) -o utils.o utils.c $(CFLAGS)
	$(CC) -o ini.o ini.c $(CFLAGS)
	$(CC) -o deploy.o deploy.c $(CFLAGS)
	$(CC) -o deploy deploy.o daemonize.o worker.o redis.o cJSON.o process.o utils.o ini.o $(LDFLAGS)

clean:
	rm -rf *.o
	rm -rf deploy
