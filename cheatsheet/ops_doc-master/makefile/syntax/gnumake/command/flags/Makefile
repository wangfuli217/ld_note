# make -s or --slient, == @echo "helloworld"
# make -n or --just-print,only show the command ,but not execute 
# make -i or --ignore-errors, ignore cmd runtime error
# make -k or --keep-going, ignore make runtime error

# makefile's CURDIR
# make[1]: Entering directory `make/chapterFour/test'
# hello in dir:Test
# make[1]: Leaving directory `make/chapterFour/test'


# ** 1)
fooValue = foo
# export will add param to environment, so subdir mkfile can use it
export barValue = bar

# ** 2)
# export without any param <==> export all params
# export 
# .EXPORT_ALL_VARIABLES :


# $(MAKEFLAGS) $(MAKEOVERRIDES)
# MAKEOVERRIDES=

# make option -w is auto open, when make -C or cd subdir and make
# make[1]: Entering directory `make/chapterFour/test'
# -w canbe close by -s
one:
	echo "parent: value=" $(value)
	echo "parent: MAKELEVEL=" $(MAKELEVEL)
	echo "subdir: MAKEOVERRIDES=" $(MAKEOVERRIDES)
	$(MAKE) -C test -f param.mk
