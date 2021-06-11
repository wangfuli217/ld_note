# basename

# return "empty string"  or "space"

all :
	echo "basenames = ___$(basename .o)___"
	echo "basenames = ___$(basename main main)___"
	echo "basenames = ___$(basename main .o main)___"
	echo "basenames = ___$(basename foo.c bar.c inc.h)___"
