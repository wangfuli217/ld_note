# $(wildcard pattern)
#   The argument pattern is a file name pattern, typically containing
#   wildcard characters (as in shell file name patterns). The result
#   of wildcrad is space-separated list of the names of existing
#   files that match the pattern.
wildcard:
	@echo "\$$(wildcard pattern)"
	@echo "  The argument pattern is a file name pattern, typically containing"
	@echo "  wildcard characters (as in shell file name patterns). The result"
	@echo "  of wildcrad is space-separated list of the names of existing"
	@echo "  files that match the pattern."
	@echo
	@echo $(wildcard *.mk)

