# PHONY target
# make -f param-t.mk test -t 
# do nothing

# normal target
# make -f param-t.mk all -t
# touch all

.PHONY : test
test :
	echo "test"

all :
	echo "all"
