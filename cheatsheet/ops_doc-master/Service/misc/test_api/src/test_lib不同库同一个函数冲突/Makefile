CC=g++
FLAG=-g

all:
	$(CC) test_lib1.cpp -fPIC -shared -o libtestlib1.so
	$(CC) test_lib2.cpp -fPIC -shared -o libtestlib2.so
	$(CC) -o test_user1 test_user.cpp -L ./ -ltestlib1 -ltestlib2
	$(CC) -o test_user2 test_user.cpp -L ./ -ltestlib2 -ltestlib1
	 
clean:
	@for f in $(SOURCES); do \
		rm -rf $$f; \
	done
	