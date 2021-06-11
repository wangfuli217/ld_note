# $(basename names...)
#   Extracts all but the suffix of each file name in names. If the
#   file name contains a period, the basename is everything starting
#   up to (and not including) the last period. Periods in the
#   directory part are ignored. If there is no period, the basename
#   is the entire file name.
objs := src/foo.c ./src/hack src/bar
basename:
	@echo "\$$(basename names...)"
	@echo "  Extracts all but the suffix of each file name in names. If the"
	@echo "  file name contains a period, the basename is everything starting"
	@echo "  up to (and not including) the last period. Periods in the"
	@echo "  directory part are ignored. If there is no period, the basename"
	@echo "  is the entire file name."
	@echo
	@echo $(objs)
	@echo $(basename $(objs))

