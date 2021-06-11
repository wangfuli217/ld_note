# TEST
# touch foo.c or bar.c or both,  then make  and look result
# 
print : foo.c bar.c
#	lpr -p $?
	@echo '$?' = $?
	@echo '$@' = $@
	@echo '$<' = $<
	touch print

# if foo.c bar.c is not existed, .DEFAULT will be called
# whether or not foo.c bar.c be created.
.DEFAULT :
	touch foo.c bar.c
