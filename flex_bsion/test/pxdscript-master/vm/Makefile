# Makefile for the PxdScript VM
CPP = g++
CPPFLAGS = -Wall -Wno-sign-compare -Wno-unused
LINKFLAGS = 

# Debug
CPPFLAGS += -g 
LINKFLAGS +=
# Optimize
#CPPFLAGS += -O3 -ffast-math -finline-limit=1200
#LINKFLAGS += -s

.PHONY: default
default: vm

# Pattern rule for generating .d (depend) files
%.d: %.cpp
	@echo Generating $@ from source ; \
	set -e; $(CPP) -MM $(CPPFLAGS) $< \
	| sed 's/\($(*F)\)\.o[ ]*:/$(subst /,\/,$*)\.o $(subst /,\/,$@) : /g' > '$@'; \
	[ -s $@ ] || rm -f $@

# Pattern rule for compiling .cpp files
%.o : %.cpp
	$(CPP) -c $(CPPFLAGS) $< -o $@

# --- Sources -----------------------------------------------------------------------------

SOURCES += main.cpp 
SOURCES += Logger.cpp
SOURCES += Player.cpp
SOURCES += VM.cpp
SOURCES += os.cpp
SOURCES += ScriptManager.cpp
SOURCES += ScriptTypes.cpp

# --- End sources -----------------------------------------------------------------------------

OBJECTS = $(SOURCES:.cpp=.o) 
DEPENDS = $(SOURCES:.cpp=.d) 

# Include depend files based on goal
GOAL := $(MAKECMDGOALS)

# If empty assume vm
ifeq ($(GOAL),)
	GOAL := vm
endif

# If vm
ifeq ($(findstring vm, $(GOAL)), vm)
  -include $(DEPENDS)
endif

# --- vm -----------------------------------------------------------------------------
vm: $(OBJECTS) 
	@echo -------------------------------------------------------------------------------;\
	echo Linking with flags: $(LINKFLAGS); \
	$(CPP) -o vm.exe $(OBJECTS) $(LINKFLAGS) 

# --- clean -----------------------------------------------------------------------------
.PHONY: clean
clean: clean-objects clean-depends
	-rm vmlog.txt
	-find . -type d -name ii_files -print | xargs rm -rf
	-find . -type f -name '*~' -print | xargs rm -rf

.PHONY: clean-objects
clean-objects:
	-find . -type f -name '*.o' -print | xargs rm -f
	-rm vm.exe

.PHONY: clean-depends
clean-depends:
	-find . -type f -name '*.d' -print | xargs rm -f
