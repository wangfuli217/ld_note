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
	{ 0x4f1939c7, "per_cpu__current_task" },
	{ 0xc8b57c27, "autoremove_wake_function" },
	{ 0xaed2f3f9, "sock_release" },
	{ 0x1cefe352, "wait_for_completion" },
	{ 0x8ce3169d, "netlink_kernel_create" },
	{ 0xea147363, "printk" },
	{ 0xb4390f9a, "mcount" },
	{ 0x1c740bd6, "init_net" },
	{ 0x312919, "netlink_broadcast" },
	{ 0x1000e51, "schedule" },
	{ 0x6d6b15ff, "create_proc_entry" },
	{ 0x642e54ac, "__wake_up" },
	{ 0x236c8c64, "memcpy" },
	{ 0x33d92f9a, "prepare_to_wait" },
	{ 0x9ccb2622, "finish_wait" },
	{ 0x7e9ebb05, "kernel_thread" },
	{ 0xc96b4a07, "skb_dequeue" },
	{ 0xe456bd3a, "complete" },
	{ 0xdc43a9c8, "daemonize" },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";


MODULE_INFO(srcversion, "0C9D668BCE7F1B493510531");

static const struct rheldata _rheldata __used
__attribute__((section(".rheldata"))) = {
	.rhel_major = 6,
	.rhel_minor = 3,
};
