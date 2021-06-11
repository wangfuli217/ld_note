# $(dir names...)
#   Extracts the directory-part of each file name in names. The
#   directory-part of the file name is everything up through
#   (and including) the last slash in it. If the file name contains
#   no slash, the directory part is the string './'.
objs := src/foo.c hacks
dir:
	@echo "\$$(dir names...)"
	@echo "  Extracts the directory-part of each file name in names. The"
	@echo "  directory-part of the file name is everything up through"
	@echo "  (and including) the last slash in it. If the file name contains"
	@echo "  no slash, the directory part is the string './'."
	@echo
	@echo $(objs)
	@echo $(dir $(objs))

