PROJ	= client
OBJS	= main.o client.o logreader.o consolesender.o socketsender.o
CXX		= g++
RM		= rm -rf
CFLAGS	= -c -Wall -I. -D_DEBUG
$(PROJ) : $(OBJS)
	$(CXX) $^ -o $@
.cpp.o:
	$(CXX) $(CFLAGS) $^ 
clean:
	$(RM) $(PROJ) $(OBJS)
