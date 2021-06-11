struct notifier_block {  
	int (*notifier_call)(struct notifier_block *, unsigned long, void *);
	struct notifier_block __rcu *next;
	int priority;
};

#原子通知链
struct atomic_notifier_head {
	spinlock_t lock;
	struct notifier_block __rcu *head;
};
# 在中断上下文中运行chain回调函数，不允许阻塞回调函数

#可阻塞通知链
struct blocking_notifier_head {
	struct rw_semaphore rwsem;
	struct notifier_block __rcu *head;
};
# 回调函数在进程上下文中执行，允许阻塞回调函数

#原始通知链
struct raw_notifier_head {
	struct notifier_block __rcu *head;
};
# 对回调、注册、注销无任何限制，所有同步及保护机制由调用方运行

# SRCU通知链
struct srcu_notifier_head {
	struct mutex mutex;
	struct srcu_struct srcu;
	struct notifier_block __rcu *head;
};
# 可阻塞通知链之一，具有和可阻塞通知链相同的限制。虽然chain被频繁调用，但必须在notifier block中未全部清除
# 的情况下使用SRCU通知链，为此需要执行运行时初始化。
