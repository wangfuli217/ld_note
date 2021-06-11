# 双冒号规则
# 双冒号规则就是使用"::"代替普通规则的":"得到的规则
Newprog :: foo.c
	$(CC) $(CFLAGS) $< -o $@
	
Newprog :: bar.c
	$(CC) $(CFLAGS) $< -o $@