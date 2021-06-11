# 1) $$HOSTNAME , expanded as $HOSTNAME in shell
#    $(HOSTNAME) , expanded as dfkigs in shell

# 2) default SHELL
# default SHELL is /bin/sh in my environment, and HOSTNAME in sh is empty 
# so changed it for a test
SHELL := /bin/bash
HOSTNAME := dfkigs

define myfuc
	@echo "$(HOSTNAME)"
	@echo "$$HOSTNAME"
	@echo "shell is $(SHELL)"
endef

.PHONY : debug
debug :
	$(myfuc)
