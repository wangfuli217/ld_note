# $(abspath names...)
#   For each file name in names return an absolute name that does
#   not contain any . or .. components, nor any repeated path
#   separators (/). Note that, in contract to realpath funtion,
#   abspath does not resolve symlinks and does not require the file
#   names to refer to an existing file or directory.
abspath:
	@echo "\$$(abspath names...)"
	@echo "  For each file name in names return an absolute name that does"
	@echo "  not contain any . or .. components, nor any repeated path"
	@echo "  separators (/). Note that, in contract to realpath funtion,"
	@echo "  abspath does not resolve symlinks and does not require the file"
	@echo "  names to refer to an existing file or directory."
	@echo
	@echo $(abspath ../hack Makefile)

