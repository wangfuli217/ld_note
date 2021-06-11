# 1)  basically
# DEBUG=true
# DEBUG= true   ----------- see 2) for solution
# and compare the results
EMPTY := 
#DEBUG := $(EMPTY) true
#DEBUG := $(EMPTY) true $(EMPTY)
#DEBUG := true
DEBUG := false


ifeq ($(DEBUG),true)
$(warning "DEBUG is true")
else
$(warning "DEBUG is not true")
endif

ifeq '$(DEBUG)' 'true'
$(warning "DEBUG is true 2")
else
$(warning "DEBUG is not true 2")
endif

ifeq "$(DEBUG)" "true"
$(warning "DEBUG is true 3")
else
$(warning "DEBUG is not true 3")
endif

ifeq "$(DEBUG)" 'true'
$(warning "DEBUG is true 4")
else
$(warning "DEBUG is not true 4")
endif


# 2) strip
#
ifeq ($(strip $(DEBUG)),true)
$(warning "DEBUG is true 5")
else
$(warning "DEBUG is not true 5")
endif

# ifneq
# same rules as ifeq
ifneq ($(DEBUG),true)
$(warning "DEBUG is true 6")
else
$(warning "DEBUG is not true 6")
endif

# 3) ifdef
#    ifndef, same rules as ifdef
bar = 
foo = $(bar)
ifdef bar
$(warning "bar is defined")
else
$(warning "bar is not defined")
endif
ifdef foo
$(warning "foo is defined")
else
$(warning "foo is not defined")
endif


all :
ifeq ($(strip $(DEBUG)),true)
	echo "DEBUG__$(DEBUG)__"
else
	echo "DEBUG***$(DEBUG)***"
endif



