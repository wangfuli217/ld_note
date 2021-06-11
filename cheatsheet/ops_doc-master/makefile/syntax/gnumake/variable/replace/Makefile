dir = foo

# 1) variable name  use another variable
$(dir)_sources := $(wildcard $(dir)/*.c)

# 2) function's name use variable
define $(dir)_print
ls $($(dir)_sources)
endef

all :
	$($(dir)_print)
