# $(shell command[ param[ param...]])
#   The shell function communicates with the world outside of make.
#   After the shell function or '!=' assignment operator is used,
#   its exit status is placed in the .SHELLSTATUS variable.
shell:
	@echo "\$$(shell command[ param[ param...]])"
	@echo "  The shell function communicates with the world outside of make."
	@echo "  After the shell function or '!=' assignment operator is used,"
	@echo "  its exit status is placed in the .SHELLSTATUS variable."
	@echo ""
	@echo $(shell whoami)
	@echo status: $(.SHELLSTATUS)
