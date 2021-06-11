# 1)  delete file bar, then make foo / make bar and compare results
# 2) touch foo bar  ,  for create 2 files, then make foo / make bar and compare results again
foo :
	echo "foo 1"

foo :
	echo "foo 2"

# echo "bar 1" \
# echo "bar 2"  will be executed , whether bar is exist or not
bar ::
	echo "bar 1"
	
bar ::
	echo "bar 2"

# error  :  / :: 
#  target cannot use : and :: rules at the same time
#doo :
#	echo "doo 1"
#doo ::
#	echo "doo 2"

# make extradeps=foo  
# make extradeps=bar
extradeps = 
hei : $(extradeps)
	@echo "Hello $?"
