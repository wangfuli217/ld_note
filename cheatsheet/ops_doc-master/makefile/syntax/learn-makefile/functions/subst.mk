comma := ,
empty :=
space := $(empty) $(empty)
foo := a b c
bar := $(subst $(space),$(comma),$(foo))

# $(subst from,to,text)
# Performs a textual replacement on the text text: each occurrence 
#   of from is repalced by to.
subst:
	@echo "\$$(subst from,to,text)"
	@echo "Performs a textual replacement on the text text: each occurrence" 
	@echo "  of from is repalced by to."
	@echo
	@echo $(bar)
	@echo $(subst ee,EE,feet on the street)

