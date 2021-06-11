
EMPTY :=
VARIABLE_WITH_SPACE:=$(EMPTY) foo $(EMPTY)
VARIABLE_WITH_TAB:=$(EMPTY)	foo	$(EMPTY)
VARIABLE_WITH_MANY_SPACE:=$(EMPTY)	 foo      bar $(EMPTY)

all :
	@echo "VARIABLE_WITH_SPACE :_____$(VARIABLE_WITH_SPACE)_____"
	@echo "VARIABLE_WITH_TAB :_____$(VARIABLE_WITH_TAB)_____"
	@echo "VARIABLE_WITH_MANY_SPACE :_____$(VARIABLE_WITH_MANY_SPACE)_____"
	@echo "VARIABLE_WITH_SPACE after strip :_____$(strip $(VARIABLE_WITH_SPACE))_____"
	@echo "VARIABLE_WITH_TAB after strip :_____$(strip $(VARIABLE_WITH_TAB))_____"
	@echo "VARIABLE_WITH_MANY_SPACE after strip :_____$(strip $(VARIABLE_WITH_MANY_SPACE))_____"


