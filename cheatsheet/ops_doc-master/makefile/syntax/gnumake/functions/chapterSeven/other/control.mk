# error & warning
# make 
#make -f control.mk DEBUG=error
ifeq ($(DEBUG),error)
$(error Error test)
#make -f control.mk DEBUG=warning
else ifeq ($(DEBUG),warning)
$(warning Warning test)
endif

all :
	echo "helloworld!"
