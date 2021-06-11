# Makefile Copyright 2008 Groetker, Holtmann, Keding, Wloka

include ../../Makefile.include

beancounter:
	gcc -Wall -g -c beancounter.c
	gcc -o beancounter beancounter.o -lpthread

clean:
	rm -rf $(CLEAN_TARGETS) beancounter
