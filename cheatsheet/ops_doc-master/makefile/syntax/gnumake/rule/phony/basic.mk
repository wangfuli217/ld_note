# phony target
# 1) not for create a file, but only exec some cmd
# 2) use .PHONY to define it
# 3) if file test is exist,  and delete the line : .PHONY : test  , then make test , will see:
#	$make: `test' is up to date.

.PHONY : all
all : test test2 test3


.PHONY : test
test :
	@echo "Hello phony : test!"

.PHONY : test2
test2 :
	@echo "Hello phony : test2!"

.PHONY : test3
test3 :
	@echo "Hello phony : test3!"

.PHONY : clean
clean : FORCE
	@echo "clean"

FORCE :
	@echo "force"
