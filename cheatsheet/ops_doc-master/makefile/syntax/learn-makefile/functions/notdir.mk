# $(notdir names...)
#   Extracts all bt the directory-part of each file name in names.
#   If the file name contains no slash, it is left unchanged.
#   Otherwise, everything through the last slast is removed from it.
objs = src/foo.c hacks
notdir:
	@echo "\$$(notdir names...)"
	@echo "  Extracts all bt the directory-part of each file name in names."
	@echo "  If the file name contains no slash, it is left unchanged."
	@echo "  Otherwise, everything through the last slast is removed from it."
	@echo
	@echo $(objs)
	@echo $(notdir $(objs))

