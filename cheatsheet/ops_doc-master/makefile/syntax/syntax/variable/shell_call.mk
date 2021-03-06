# 为规则书写命令
# 在Makefile中书写在同一行中的多个命令属于一个完整的shell命令行，书写在独立行的一条命令是一个独立的shell命令行。
# 因此:在一个规则的命令中，命令行"cd"改变目录不会对其后的命令的执行产生影响。
# 就是说其后的命令执行的工作目录不会是之前使用"cd"进入的那个目录。
# 如果要实现这个目的，就不能把"cd"和其后的命令放在两行来书写。而应该把这两条命令写在一行上，用分号分隔。

foo : bar/lose
	@cd bar; echo "echo hello world" > ../foo
	@$(SHELL) hello.sh
	
