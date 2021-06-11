#include <linux/kernel.h>
#include <linux/module.h>
static int noop(void *dummy)
{
        int i = 0;
        daemonize("mythread");
        while(i++ < 5) {
                printk("current->mm = %p/n", current->mm);
                printk("current->active_mm = %p/n", current->active_mm);
                set_current_state(TASK_INTERRUPTIBLE);
                schedule_timeout(10 * HZ);
        }
        return 0;
}
static int test_init(void)
{
        kernel_thread(noop, NULL, CLONE_KERNEL | SIGCHLD);
        return 0;
}
static void test_exit(void) {}
module_init(test_init);
module_exit(test_exit);