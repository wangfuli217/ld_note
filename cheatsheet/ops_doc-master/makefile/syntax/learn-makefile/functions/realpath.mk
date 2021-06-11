# $(realpath names...)
#   For each file name in names return the canonical absolute name.
#   A conanical name does not contains any . or .. components, nor
#   any repeated path separators (/) or symlinks. In case of a 
#   failure the empty string is returned.
realpath:
	@echo "\$$(realpath names...)"
	@echo "  For each file name in names return the canonical absolute name."
	@echo "  A conanical name does not contains any . or .. components, nor"
	@echo "  any repeated path separators (/) or symlinks. In case of a "
	@echo "  failure the empty string is returned."
	@echo
	@echo $(realpath Makefile ./realpath.mk)

