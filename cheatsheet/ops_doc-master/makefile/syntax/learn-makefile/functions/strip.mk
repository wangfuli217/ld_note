# $(strip string)
#   Removes leading and trailing whitespace from string and replaces each
#   internal sequence of one or more whitespace characters with a single
#   space.
strip:
	@echo "\$$(strip string)"
	@echo "  Removes leading and trailing whitespace from string and replaces each"
	@echo "  internal sequence of one or more whitespace characters with a single"
	@echo "  space."
	@echo
	@echo $(strip a b   c  d  )

