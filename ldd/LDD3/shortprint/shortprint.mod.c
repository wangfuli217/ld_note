#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

MODULE_INFO(vermagic, VERMAGIC_STRING);

struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
 .name = KBUILD_MODNAME,
 .init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
 .exit = cleanup_module,
#endif
 .arch = MODULE_ARCH_INIT,
};

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0x14522340, "module_layout" },
	{ 0x6bc3fbc0, "__unregister_chrdev" },
	{ 0x1fedf0f4, "__request_region" },
	{ 0x4f1939c7, "per_cpu__current_task" },
	{ 0x6980fe91, "param_get_int" },
	{ 0x6307fc98, "del_timer" },
	{ 0xc8b57c27, "autoremove_wake_function" },
	{ 0x3457cb68, "param_set_long" },
	{ 0xfc4f55f3, "down_interruptible" },
	{ 0x7ef6ef76, "queue_work" },
	{ 0xfa0d49c7, "__register_chrdev" },
	{ 0x6a9f26c9, "init_timer_key" },
	{ 0xff964b25, "param_set_int" },
	{ 0x712aa29b, "_spin_lock_irqsave" },
	{ 0x3c2c5af5, "sprintf" },
	{ 0x7d11c268, "jiffies" },
	{ 0xe83fea1, "del_timer_sync" },
	{ 0xff7559e4, "ioport_resource" },
	{ 0xea147363, "printk" },
	{ 0x85f8a266, "copy_to_user" },
	{ 0xb4390f9a, "mcount" },
	{ 0x20f26c14, "destroy_workqueue" },
	{ 0x4b07e779, "_spin_unlock_irqrestore" },
	{ 0x45450063, "mod_timer" },
	{ 0x46085e4f, "add_timer" },
	{ 0x859c6dc7, "request_threaded_irq" },
	{ 0x9c14f8c3, "__create_workqueue_key" },
	{ 0x21c9ef83, "flush_workqueue" },
	{ 0x8bd5b603, "param_get_long" },
	{ 0x93fca811, "__get_free_pages" },
	{ 0x1000e51, "schedule" },
	{ 0xd62c833f, "schedule_timeout" },
	{ 0x27f96468, "pv_cpu_ops" },
	{ 0x7c61340c, "__release_region" },
	{ 0x4302d0eb, "free_pages" },
	{ 0x642e54ac, "__wake_up" },
	{ 0x1d2e87c6, "do_gettimeofday" },
	{ 0x33d92f9a, "prepare_to_wait" },
	{ 0x3f1899f1, "up" },
	{ 0x9ccb2622, "finish_wait" },
	{ 0x3302b500, "copy_from_user" },
	{ 0x9e7d6bd0, "__udelay" },
	{ 0xf20dabd8, "free_irq" },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";


MODULE_INFO(srcversion, "21002C382831D629BDE6F96");

static const struct rheldata _rheldata __used
__attribute__((section(".rheldata"))) = {
	.rhel_major = 6,
	.rhel_minor = 3,
};
