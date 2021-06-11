# Makefile Copyright 2008 Groetker, Holtmann, Keding, Wloka

include ../../Makefile.include

max_example:
	g++ -E max_example.cc >max_example.post.cc
	g++ -Wall -o max_example -g max_example.cc

clean:
	rm -rf $(CLEAN_TARGETS) max_example max_example.post.cc

