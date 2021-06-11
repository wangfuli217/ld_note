# These functions control the way make runs. Generally, they are
#   used to provide information to the user of the makefile or to
#   cause make to stop if some sort of environmental error is
#   detected.
#
# $(error text...)
#   Generates a fatal error where the message is text. Note that
#   the error is generated whenever this function is evaluated.
#   So, if you put it inside a recipe or on the right side of a
#   recursive variable assignment, it won't be evaluated until
#   later. The text will be expanded before the error is generated.
ERR = $(error found an error!)
error:
	@echo "\$$(error text...)"
	@echo "  Generates a fatal error where the message is text. Note that"
	@echo "  the error is generated whenever this function is evaluated."
	@echo "  So, if you put it inside a recipe or on the right side of a"
	@echo "  recursive variable assignment, it won't be evaluated until"
	@echo "  later. The text will be expanded before the error is generated."
	@echo 
	$(ERR)

# $(warning text...)
#   This function works similarly to the error function, except that
#   make doesn't exit. Instead, text is expanded and the resulting
#   message is displayed, but processing of the makefile continues.
#   The result of the expansion of this function is the empty string.
WARN = $(warning warning message)
warning:
	@echo "\$$(warning text...)"
	@echo "  This function works similarly to the error function, except that"
	@echo "  make doesn't exit. Instead, text is expanded and the resulting"
	@echo "  message is displayed, but processing of the makefile continues."
	@echo "  The result of the expansion of this function is the empty string."
	@echo
	$(WARN)	

# $(info text...)
#   This function does nothing more than print its (expanded)
#   arguments to standard output. No makefile name or line number
#   is added. The result of the expansion of this function is the
#   empty string.
INFO = $(info info message)
info:
	@echo "\$$(info text...)"
	@echo "  This function does nothing more than print its (expanded)"
	@echo "  arguments to standard output. No makefile name or line number"
	@echo "  is added. The result of the expansion of this function is the"
	@echo "  empty string."
	@echo ""
	$(INFO)
