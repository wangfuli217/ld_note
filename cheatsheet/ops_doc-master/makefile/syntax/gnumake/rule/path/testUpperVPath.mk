# very important: VPATH is valid in Makefile !!
# so you can look at error and ok .
# and think !

#  read me : 
# this file will test VPATH & GPATH
# VPATH is easy , just set and do,  all is ok ; only the prerequisites must use  $^, since it will be changed by path search
# GPATH must use "$@" for dynamic change target rule;  and the GPATH Value must use ./src not src
#

# GPATH TEST
GPATH = ./src
# GPATH = ./ : ./src          ------- ok
# GPATH = src  ----------------- not ok

VPATH = ./ : ./src

# main.c in prerequisites is ok.  will replaced it with ./src/main.c
error : main.c
# main.c in below line is not ok, it will be passed to shell as main.c
	-cc     main.c   -o main
	@echo "================================="
	@echo "================================="
	@echo "you can use target : ok for test"
	@echo "================================="
	@echo "================================="

# GPATH test !
# if src/main is exist and main is newer than main.c,  make -f testUpperVPath.mk main 
# $make: `./src/main' is up to date
# 
# then change main.c , and make again
# $cc     ./src/main.c   -o main
# main will be generated in local path.
main : main.c
# when test GPATH main must be changed to $@ 
# because target $@ will be changed by final path search
	cc     $^   -o main
	cc     $^   -o $@

clean :
	-rm main
