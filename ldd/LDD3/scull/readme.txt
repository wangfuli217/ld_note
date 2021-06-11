------ Fix it to use EXTRA_CFLAGS  ------

1. 在linux2.6.34.1编译提示  Fix it to use EXTRA_CFLAGS.  Stop.

将makefile中的 CFLAGS 替换成 EXTRA_CFLAGS就可以了。

原因是在2.6的内核的版本中所有的 EXTRA_ 变量只在所定义的Kbuild Makefile中起作用。EXTRA_ 变量可以在Kbuild Makefile中所有
命令中使用。   
$(EXTRA_CFLAGS) 是用 $(CC) 编译C源文件时的选项。    

例子：          
# drivers/sound/emu10kl/Makefile          
EXTRA_CFLAGS += -I$(obj)          
ifdef DEBUG              
EXTRA_CFLAGS += -DEMU10KL_DEBUG          
endif    
该变量是必须的，因为顶层Makefile拥有变量 $(CFLAGS) 并用来作为整个源代码树的编译选项。

------ ‘struct task_struct’ has no member named ‘uid’ ------
之前在Ubuntu里编译scull时有错误，还好有网友提供了解决办法，即删除config.h文件和增加#include 两个头文件：capability.h和sched.h

最近将Ubuntu升级到9.10版本后，重新生成了2.6.31版本的内核树，没想到编译scull模块时出现新的error
error: 'struct task_struct' has no member named 'uid'
error: 'struct task_struct' has no member named 'euid'

struct task_struct定义在include/linux/sched.h中，原来task_struct结构体定义有所改动，将uid和euid等挪到cred中，见include/linux/sched.h和include/linux/cred.h。

因此只需要将报error的代码做如下修改
current->uid 修改为 current->cred->uid
current->euid 修改为 current->cred->euid

