# 1)  overrided variable cannot be overrided by input v or redefined without KEYWORDS : override.
# 2)  usually, override being used not for "lock" a variable;  but for override the input variable
# $make FOO=input_foo BAR=input_bar HEI=input_hei
# $FOO = native_foo
# $BAR = input_bar
# $HEI = input_hei hei

override FOO := native_foo
BAR := native_bar

FOO := replaced_foo
BAR := replaced_bar
HEI := native_hei
override HEI += hei
ZOO := sss

all :
	@echo "FOO" = $(FOO)
	@echo "BAR" = $(BAR)
	@echo "HEI" = $(HEI)
	@echo "ZOO" = $(ZOO)

override define ZOO
zoo
endef
