# 1) 
$(eval foo.o:foo.c)

# no return
# 2) a example
PROGRAMS = server client
server_OBJS = server.o server_priv.o server_access.o
server_LIBS = priv protocol

client_OBJS = client.o client_api.o client_mem.o
client_LIBS = protocol

.PHONY: all
all : $(PROGRAMS)

define PROGRAMS_template
$(1) : $$($(1)_OBJS) $$($(1)_LIBS:%=-l%)
ALL_OBJS += $$($(1)_OBJS)
endef

$(foreach prog,$(PROGRAMS),$(eval $(call PROGRAMS_template,$(prog))))
#server : $(server_OBJS) $(server_LIBS:%=-l%)
#client : $(client_OBJS) $(client_LIBS:%=-l%)
#ALL_OBJS += $(server_OBJS) $(client_OBJS)

# 
# $(CC) $(LDFLAGS)
$(PROGRAMS) :
	@echo "$(LINK.o) $^ $(LDLIBS) -o $@"
#	$(LINK.o) $^ $(LDLIBS) -o $@

clean :
	$(RM) *.o
