struct notifier_block {  
	int (*notifier_call)(struct notifier_block *, unsigned long, void *);
	struct notifier_block __rcu *next;
	int priority;
};

#ԭ��֪ͨ��
struct atomic_notifier_head {
	spinlock_t lock;
	struct notifier_block __rcu *head;
};
# ���ж�������������chain�ص������������������ص�����

#������֪ͨ��
struct blocking_notifier_head {
	struct rw_semaphore rwsem;
	struct notifier_block __rcu *head;
};
# �ص������ڽ�����������ִ�У����������ص�����

#ԭʼ֪ͨ��
struct raw_notifier_head {
	struct notifier_block __rcu *head;
};
# �Իص���ע�ᡢע�����κ����ƣ�����ͬ�������������ɵ��÷�����

# SRCU֪ͨ��
struct srcu_notifier_head {
	struct mutex mutex;
	struct srcu_struct srcu;
	struct notifier_block __rcu *head;
};
# ������֪ͨ��֮һ�����кͿ�����֪ͨ����ͬ�����ơ���Ȼchain��Ƶ�����ã���������notifier block��δȫ�����
# �������ʹ��SRCU֪ͨ����Ϊ����Ҫִ������ʱ��ʼ����
