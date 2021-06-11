all: sds-test

sds-test: adlist.c adlist.h testhelp.h 
	$(CC) -o adlist-test adlist.c -Wall -std=c99 -pedantic -O2 -DADLIST_TEST_MAIN
	@echo ">>> Type ./adlist-test to run the adlist.c unit tests."
clean:
	rm -f adlist-test
