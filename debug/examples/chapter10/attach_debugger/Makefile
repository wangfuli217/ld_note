# Makefile Copyright 2008 Groetker, Holtmann, Keding, Wloka

include ../../Makefile.include

attach_debugger:
	g++ -Wall -g -o attach_debugger static_conflict.cc initial_delay.cc MyClass.cc

clean:
	rm -rf $(CLEAN_TARGETS) attach_debugger
