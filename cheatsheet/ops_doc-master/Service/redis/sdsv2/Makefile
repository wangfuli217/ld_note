all: sds-test

sds-test: sds.c sds.h testhelp.h sdstest.c
	$(CC) -o sds-test sds.c -Wall -std=c99 -pedantic -O2 -DSDS_TEST_MAIN
	@echo ">>> Type ./sds-test to run the sds.c unit tests."
	$(CC) -o sdstest sds.c  sdstest.c -Wall -std=c99 -pedantic -O2
clean:
	rm -f sds-test
	rm -f sdstest
