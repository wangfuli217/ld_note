------ Fix it to use EXTRA_CFLAGS  ------

1. ��linux2.6.34.1������ʾ  Fix it to use EXTRA_CFLAGS.  Stop.

��makefile�е� CFLAGS �滻�� EXTRA_CFLAGS�Ϳ����ˡ�

ԭ������2.6���ں˵İ汾�����е� EXTRA_ ����ֻ���������Kbuild Makefile�������á�EXTRA_ ����������Kbuild Makefile������
������ʹ�á�   
$(EXTRA_CFLAGS) ���� $(CC) ����CԴ�ļ�ʱ��ѡ�    

���ӣ�          
# drivers/sound/emu10kl/Makefile          
EXTRA_CFLAGS += -I$(obj)          
ifdef DEBUG              
EXTRA_CFLAGS += -DEMU10KL_DEBUG          
endif    
�ñ����Ǳ���ģ���Ϊ����Makefileӵ�б��� $(CFLAGS) ��������Ϊ����Դ�������ı���ѡ�

------ ��struct task_struct�� has no member named ��uid�� ------
֮ǰ��Ubuntu�����scullʱ�д��󣬻����������ṩ�˽���취����ɾ��config.h�ļ�������#include ����ͷ�ļ���capability.h��sched.h

�����Ubuntu������9.10�汾������������2.6.31�汾���ں�����û�뵽����scullģ��ʱ�����µ�error
error: 'struct task_struct' has no member named 'uid'
error: 'struct task_struct' has no member named 'euid'

struct task_struct������include/linux/sched.h�У�ԭ��task_struct�ṹ�嶨�������Ķ�����uid��euid��Ų��cred�У���include/linux/sched.h��include/linux/cred.h��

���ֻ��Ҫ����error�Ĵ����������޸�
current->uid �޸�Ϊ current->cred->uid
current->euid �޸�Ϊ current->cred->euid

