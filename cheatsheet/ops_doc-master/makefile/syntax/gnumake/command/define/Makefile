define run
echo "___"$(1)"__"
endef

define run2
echo "run2"
endef

# space after ","
# call function  and $(function)
all : 
	@$(call run,$(value))
	@$(call run, $(value))
#	@$(run1,$(value))    error format
	@$(run2)
	@$(call run2)

# if foo.c exist, and don't want the default rule takes effect
# then a target without CMD is OK.
foo:;
