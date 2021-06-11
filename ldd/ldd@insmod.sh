现在，我们看看加载模块时的内部函数。当调用内核函数 sys_init_module 时，会开始一个许可检查，查明调用者是否有权执行这个操作（通过 capable 函数完成）。然后，调用 load_module 函数，这个函数负责将模块加载到内核并执行必要的调试（后面还会讨论这点）。load_module 函数返回一个指向最新加载模块的模块引用。这个模块加载到系统内具有双重链接的所有模块的列表上，并且通过 notifier 列表通知正在等待模块状态改变的线程。最后，调用模块的 init() 函数，更新模块状态，表明模块已经加载并且可用。

/* This is where the real work happens */
asmlinkage long
sys_init_module(void __user *umod,
        unsigned long len,
        const char __user *uargs)
{
    struct module *mod;
    int ret = 0;

    /* Must have permission */
    if (!capable(CAP_SYS_MODULE))
        return -EPERM;

    /* Only one module load at a time, please */
    if (mutex_lock_interruptible(&module_mutex) != 0)
        return -EINTR;

    /* Do all the hard work */
    mod = load_module(umod, len, uargs);
    if (IS_ERR(mod)) {
        mutex_unlock(&module_mutex);
        return PTR_ERR(mod);
    }

    /* Drop lock so they can recurse */
    mutex_unlock(&module_mutex);

    blocking_notifier_call_chain(&module_notify_list,
            MODULE_STATE_COMING, mod);

    /* Start the module */
    if (mod->init != NULL)
        ret = do_one_initcall(mod->init);
    if (ret < 0) {
        /* Init routine failed: abort.  Try to protect us from
                   buggy refcounters. */
        mod->state = MODULE_STATE_GOING;
        synchronize_sched();
        module_put(mod);
        blocking_notifier_call_chain(&module_notify_list,
                         MODULE_STATE_GOING, mod);
        mutex_lock(&module_mutex);
        free_module(mod);
        mutex_unlock(&module_mutex);
        wake_up(&module_wq);
        return ret;
    }
    if (ret > 0) {
        printk(KERN_WARNING "%s: '%s'->init suspiciously returned %d, "
                    "it should follow 0/-E convention/n"
               KERN_WARNING "%s: loading module anyway.../n",
               __func__, mod->name, ret,
               __func__);
        dump_stack();
    }

    /* Now it is a first class citizen!  Wake up anyone waiting for it. */
    mod->state = MODULE_STATE_LIVE;
    wake_up(&module_wq);

    mutex_lock(&module_mutex);
    /* Drop initial reference. */
    module_put(mod);
    unwind_remove_table(mod->unwind_info, 1);
    module_free(mod, mod->module_init);
    mod->module_init = NULL;
    mod->init_size = 0;
    mod->init_text_size = 0;
    mutex_unlock(&module_mutex);

    return 0;
}

加载模块的内部细节是 ELF 模块解析和操作。load_module 函数（位于 ./linux/kernel/module.c）首先分配一块用于容纳整个 ELF 模块的临时内存。然后，通过 copy_from_user 函数将 ELF 模块从用户空间读入到临时内存。作为一个 ELF 对象，这个文件的结构非常独特，易于解析和验证。

这个函数的代码比较长，实现的就是一个模块的解析，找出各个Section，这个有兴趣的人可以看看Linux内核的源码。

下一步是对加载的 ELF 映像执行一组健康检查（它是有效的 ELF 文件吗？它适合当前的架构吗？等等）。完成健康检查后，就会解析 ELF 映像，然后会为每个区段头创建一组方便变量，简化随后的访问。因为 ELF 对象的偏移量是基于 0 的（除非重新分配），所以这些方便变量将相对偏移量包含到临时内存块中。在创建方便变量的过程中还会验证 ELF 区段头，确保加载的是有效模块。

任何可选的模块参数都从用户空间加载到另一个已分配的内核内存块（第 4 步），并且更新模块状态，表明模块已加载（MODULE_STATE_COMING）。如果需要 per-CPU 数据（这在检查区段头时确定），那么就分配 per-CPU 块。

在前面的步骤，模块区段被加载到内核（临时）内存，并且知道哪个区段应该保持，哪个可以删除。步骤 7 为内存中的模块分配最终的位置，并移动必要的区段（ELF 头中的 SHF_ALLOC， 或在执行期间占用内存的区段）。然后执行另一个分配，大小是模块必要区段所需的大小。迭代临时 ELF 块中的每个区段，并将需要执行的区段复制到新的块中。接下来要进行一些额外的维护。同时还进行符号解析，可以解析位于内核中的符号（被编译成内核映象）， 或临时的符号（从其他模块导出）。

然后为每个剩余的区段迭代新的模块并执行重新定位。这个步骤与架构有 关，因此依赖于为架构（./linux/arch/<arch>/kernel/module.c）定义的 helper 函数。最后，刷新指令缓存（因为使用了临时 .text 区段），执行一些额外的维护（释放临时模块内存，设置系统文件），并将模块最终返回到 load_module。