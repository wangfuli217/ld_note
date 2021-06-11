# make的控制函数
# make 提供了两个控制 make 运行方式的函数。通常它们用在 Makefile 中,当 make执行过程中检测到某些错误是为用户提供消息,
# 并且可以控制 make 过程是否继续。
# $(error TEXT...)
# 假设我们的 Makefile 中包含以下两个片断;
# 示例 1:
ifdef ERROR1
$(error error is $(ERROR1))
endif

# 示例 2:
ERR = $(error found an error!)
.PHONY: err
err: ; $(ERR)
# 这个例子,在 make 读取 Makefile 时不会出现致命错误。只有目标"err"被作为一个目标被执行时才会出现。

# $(warning TEXT...)
# 函数功能:函数"warning"类似于函数"error",区别在于它不会导致致命错误(make 不退出),而只是提示"TEXT...",make 的执行过程继续。