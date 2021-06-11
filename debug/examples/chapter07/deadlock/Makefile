# Makefile Copyright 2008 Groetker, Holtmann, Keding, Wloka

include ../../Makefile.include

bean_counter_deadlock:
	gcc -Wall -g -c beancounter_deadlock.c
	gcc -o beancounter_deadlock beancounter_deadlock.o -lpthread

clean:
	rm -rf $(CLEAN_TARGETS) bean_counter_deadlock
