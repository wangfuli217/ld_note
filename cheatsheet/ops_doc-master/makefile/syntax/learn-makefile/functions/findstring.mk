# $(findstring find,in)
#   Searches in for an occurrence of find. If it occurs, the value is
#   find; otherwise, the value is empty.
findstring:
	@echo "\$$(findstring find,in)"
	@echo "  Searches in for an occurrence of find. If it occurs, the value is"
	@echo "  find; otherwise, the value is empty."
	@echo
	@echo $(findstring a,a b c)
	@echo $(findstring a,b c)

