CPPCHECK_FLAGS += --enable=all
CPPCHECK_FLAGS += --suppress=missingIncludeSystem
CPPCHECK_FLAGS += --suppress=readdirCalled
CPPCHECK_FLAGS += --suppress=unmatchedSuppression
CPPCHECK_FLAGS += --std=posix

ifneq ($(CSTD),)
CPPCHECK_FLAGS += --std=$(CSTD)
else
CPPCHECK_FLAGS += --std=c99
endif

CPPCHECK_SOURCES += $(OBJECTS:.o=.c)

ifeq ($(TYPE),prog)
CPPCHECK_SOURCES += $(NAME).c
endif

.PHONY:
cppcheck: $(SOURCES) $(HEADERS)
	cppcheck $(CPPCHECK_FLAGS) $(CPPCHECK_SOURCES)
