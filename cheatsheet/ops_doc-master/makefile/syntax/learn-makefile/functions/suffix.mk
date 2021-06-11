# $(suffix names...)
#   Extracts the suffix of each file name in names. If the name
#   contains a period, the suffix is everything starting with the
#   last perid. Otherwise, the suffix is the empty string. This
#   frequently means that the result will be empty when names is
#   not, and if names contains multiple file names, the result
#   may contains fewer file names.
objs = src/foo.c src/foo.h src-1.0/bar.c hacks
suffix:
	@echo "\$$(suffix names...)"
	@echo "  Extracts the suffix of each file name in names. If the name"
	@echo "  contains a period, the suffix is everything starting with the"
	@echo "  last perid. Otherwise, the suffix is the empty string. This"
	@echo "  frequently means that the result will be empty when names is"
	@echo "  not, and if names contains multiple file names, the result"
	@echo "  may contains fewer file names."
	@echo
	@echo $(objs)
	@echo $(suffix $(objs))

