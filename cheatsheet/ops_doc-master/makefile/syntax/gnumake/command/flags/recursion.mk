# 1) use $(MAKE) nor make  for recursion call
# 2) make -t/  -n /  -q

all:
	@echo "all"
	@$(MAKE) -C test

param_n_t_q1 :
	@make -C test

param_n_t_q2 :
	@$(MAKE) -C test
