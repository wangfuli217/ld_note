#!/usr/local/bin/lua

keys = {
'auto', 'break', 'case', 'char', 'const', 'continue', 'default', 'do',
'double', 'else','enum', 'extern', 'float', 'for', 'goto', 'if',
'int', 'long', 'register', 'return', 'short', 'signed', 'sizeof', 'static',
'struct', 'switch', 'typedef', 'union', 'unsigned', 'void', 'volatile', 'while'
}

reserved_type = {
'uint8_t', 'uint16_t', 'uint32_t', 'int8_t', 'int16_t', 'int32_t', 'NULL', 'main'
}

reserved_string = {
'strlen', 'strncat', 'strncmp', 'strncpy', 'strlen', 'strpbrk', 'strrchr', 'strspn', 
'strstr', 'strtok', 'strtok_r', 'strxfrm', 'strerror', 'strerror_r', 'strdup', 'strcspn', 
'strcpy', 'strcoll', 'strcmp', 'strchr', 'strcat', 'memset', 'memmove', 'memcpy',
'memcmp', 'memchr', 'memccpy' 
}

reserved_unix = {
"accept",
"accept4",
"access",
"acct",
"add_key",
"adjtimex",
"afs_syscall",
"alarm",
"alloc_hugepages",
"arch_prctl",
"bdflush",
"bind",
"break",
"brk",
"cacheflush",
"capget",
"capset",
"chdir",
"chmod",
"chown",
"chown32",
"chroot",
"clock_getres",
"clock_gettime",
"clock_nanosleep",
"clock_settime",
"__clone2",
"clone2",
"clone",
"close",
"connect",
"creat",
"create_module",
"delete_module",
"dup2",
"dup",
"dup3",
"epoll_create1",
"epoll_create",
"epoll_ctl",
"epoll_pwait",
"epoll_wait",
"eventfd2",
"eventfd",
"execve",
"_exit",
"exit",
"_Exit",
"exit_group",
"faccessat",
"fadvise",
"fadvise64",
"fadvise64_64",
"fallocate",
"fattch",
"fchdir",
"fchmod",
"fchmodat",
"fchown",
"fchown32",
"fchownat",
"fcntl",
"fcntl64",
"fdatasync",
"fdetach",
"flock",
"fork",
"free_hugepages",
"fstat",
"fstat64",
"fstatat",
"fstatat64",
"fstatfs",
"fstatfs64",
"fstatvfs",
"fsync",
"ftruncate",
"ftruncate64",
"futex",
"futimesat",
"getcontext",
"getcpu",
"getcwd",
"getdents",
"getdents64",
"getdomainname",
"getdtablesize",
"getegid",
"getegid32",
"geteuid",
"geteuid32",
"getgid",
"getgid32",
"getgroups",
"getgroups32",
"gethostid",
"gethostname",
"getitimer",
"get_kernel_syms",
"get_mempolicy",
"getmsg",
"getpagesize",
"getpeername",
"getpgid",
"getpgrp",
"getpid",
"getpmsg",
"getppid",
"getpriority",
"getresgid",
"getresgid32",
"getresuid",
"getresuid32",
"getrlimit",
"get_robust_list",
"getrusage",
"getsid",
"getsockname",
"getsockopt",
"get_thread_area",
"gettid",
"gettimeofday",
"getuid",
"getuid32",
"getunwind",
"gtty",
"idle",
"inb",
"inb_p",
"init_module",
"inl",
"inl_p",
"inotify_add_watch",
"inotify_init1",
"inotify_init",
"inotify_rm_watch",
"insb",
"insl",
"insw",
"intro",
"inw",
"inw_p",
"io_cancel",
"ioctl",
"ioctl_list",
"io_destroy",
"io_getevents",
"ioperm",
"iopl",
"ioprio_get",
"ioprio_set",
"io_setup",
"io_submit",
"ipc",
"isastream",
"kexec_load",
"keyctl",
"kill",
"killpg",
"lchown",
"lchown32",
"link",
"linkat",
"listen",
"_llseek",
"llseek",
"lock",
"lookup_dcookie",
"lseek",
"lstat",
"lstat64",
"madvise1",
"madvise",
"mbind",
"mincore",
"mkdir",
"mkdirat",
"mknod",
"mknodat",
"mlock",
"mlockall",
"mmap2",
"mmap",
"modify_ldt",
"mount",
"move_pages",
"mprotect",
"mpx",
"mq_getsetattr",
"mq_notify",
"mq_open",
"mq_timedreceive",
"mq_timedsend",
"mq_unlink",
"mremap",
"msgctl",
"msgget",
"msgop",
"msgrcv",
"msgsnd",
"msync",
"multiplexer",
"munlock",
"munlockall",
"munmap",
"nanosleep",
"_newselect",
"nfsservctl",
"nice",
"oldfstat",
"oldlstat",
"oldolduname",
"oldstat",
"olduname",
"open",
"openat",
"outb",
"outb_p",
"outl",
"outl_p",
"outsb",
"outsl",
"outsw",
"outw",
"outw_p",
"path_resolution",
"pause",
"perfmonctl",
"personality",
"pipe2",
"pipe",
"pivot_root",
"poll",
"posix_fadvise",
"ppoll",
"prctl",
"pread",
"pread64",
"preadv",
"prof",
"pselect",
"pselect6",
"ptrace",
"putmsg",
"putpmsg",
"pwrite",
"pwrite64",
"pwritev",
"query_module",
"quotactl",
"read",
"readahead",
"readdir",
"readlink",
"readlinkat",
"readv",
"reboot",
"recv",
"recvfrom",
"recvmsg",
"remap_file_pages",
"rename",
"renameat",
"request_key",
"restart_syscall",
"rmdir",
"rtas",
"rt_sigaction",
"rt_sigpending",
"rt_sigprocmask",
"rt_sigqueueinfo",
"rt_sigreturn",
"rt_sigsuspend",
"rt_sigtimedwait",
"sbrk",
"sched_getaffinity",
"sched_getparam",
"sched_get_priority_max",
"sched_get_priority_min",
"sched_getscheduler",
"sched_rr_get_interval",
"sched_setaffinity",
"sched_setparam",
"sched_setscheduler",
"sched_yield",
"security",
"select",
"select_tut",
"semctl",
"semget",
"semop",
"semtimedop",
"send",
"sendfile",
"sendfile64",
"sendmsg",
"sendto",
"setcontext",
"setdomainname",
"setegid",
"seteuid",
"setfsgid",
"setfsgid32",
"setfsuid",
"setfsuid32",
"setgid",
"setgid32",
"setgroups",
"setgroups32",
"sethostid",
"sethostname",
"setitimer",
"set_mempolicy",
"setpgid",
"setpgrp",
"setpriority",
"setregid",
"setregid32",
"setresgid",
"setresgid32",
"setresuid",
"setresuid32",
"setreuid",
"setreuid32",
"setrlimit",
"set_robust_list",
"setsid",
"setsockopt",
"set_thread_area",
"set_tid_address",
"settimeofday",
"setuid",
"setuid32",
"setup",
"sgetmask",
"shmat",
"shmctl",
"shmdt",
"shmget",
"shmop",
"shutdown",
"sigaction",
"sigaltstack",
"signal",
"signalfd",
"signalfd4",
"sigpending",
"sigprocmask",
"sigqueue",
"sigreturn",
"sigsuspend",
"sigtimedwait",
"sigwaitinfo",
"socket",
"socketcall",
"socketpair",
"splice",
"spu_create",
"spufs",
"spu_run",
"ssetmask",
"stat",
"stat64",
"statfs",
"statfs64",
"statvfs",
"stime",
"stty",
"swapcontext",
"swapoff",
"swapon",
"symlink",
"symlinkat",
"sync",
"sync_file_range",
"_syscall",
"syscall",
"syscalls",
"_sysctl",
"sysctl",
"sysfs",
"sysinfo",
"syslog",
"tee",
"tgkill",
"time",
"timer_create",
"timer_delete",
"timerfd_create",
"timerfd_gettime",
"timerfd_settime",
"timer_getoverrun",
"timer_gettime",
"timer_settime",
"times",
"tkill",
"truncate",
"truncate64",
"tux",
"tuxcall",
"ugetrlimit",
"umask",
"umount2",
"umount",
"uname",
"unimplemented",
"unlink",
"unlinkat",
"unshare",
"uselib",
"ustat",
"utime",
"utimensat",
"utimes",
"vfork",
"vhangup",
"vm86",
"vm86old",
"vmsplice",
"vserver",
"wait",
"wait3",
"wait4",
"waitid",
"waitpid",
"write",
"writev",
"errno"
}
reserved_pthread = {
"pthread_atfork",
"pthread_attr_destroy",
"pthread_attr_getaffinity_np",
"pthread_attr_getdetachstate",
"pthread_attr_getguardsize",
"pthread_attr_getinheritsched",
"pthread_attr_getschedparam",
"pthread_attr_getschedpolicy",
"pthread_attr_getscope",
"pthread_attr_getstack",
"pthread_attr_getstackaddr",
"pthread_attr_getstacksize",
"pthread_attr_init",
"pthread_attr_setaffinity_np",
"pthread_attr_setdetachstate",
"pthread_attr_setguardsize",
"pthread_attr_setinheritsched",
"pthread_attr_setschedparam",
"pthread_attr_setschedpolicy",
"pthread_attr_setscope",
"pthread_attr_setstack",
"pthread_attr_setstackaddr",
"pthread_attr_setstacksize",
"pthread_barrier_destroy",
"pthread_barrier_init",
"pthread_barrier_wait",
"pthread_barrierattr_destroy",
"pthread_barrierattr_getpshared",
"pthread_barrierattr_init",
"pthread_barrierattr_setpshared",
"pthread_cancel",
"pthread_cleanup_pop",
"pthread_cleanup_pop_restore_np",
"pthread_cleanup_push",
"pthread_cleanup_push_defer_np",
"pthread_cond_broadcast",
"pthread_cond_destroy",
"pthread_cond_init",
"pthread_cond_signal",
"pthread_cond_timedwait",
"pthread_cond_wait",
"pthread_condattr_destroy",
"pthread_condattr_getclock",
"pthread_condattr_getpshared",
"pthread_condattr_init",
"pthread_condattr_setclock",
"pthread_condattr_setpshared",
"pthread_create",
"pthread_detach",
"pthread_equal",
"pthread_exit",
"pthread_getaffinity_np",
"pthread_getattr_np",
"pthread_getconcurrency",
"pthread_getcpuclockid",
"pthread_getschedparam",
"pthread_getspecific",
"pthread_join",
"pthread_key_create",
"pthread_key_delete",
"pthread_kill",
"pthread_kill_other_threads_np",
"pthread_mutex_destroy",
"pthread_mutex_getprioceiling",
"pthread_mutex_init",
"pthread_mutex_lock",
"pthread_mutex_setprioceiling",
"pthread_mutex_timedlock",
"pthread_mutex_trylock",
"pthread_mutex_unlock",
"pthread_mutexattr_destroy",
"pthread_mutexattr_getprioceiling",
"pthread_mutexattr_getprotocol",
"pthread_mutexattr_getpshared",
"pthread_mutexattr_gettype",
"pthread_mutexattr_init",
"pthread_mutexattr_setprioceiling",
"pthread_mutexattr_setprotocol",
"pthread_mutexattr_setpshared",
"pthread_mutexattr_settype",
"pthread_once",
"pthread_rwlock_destroy",
"pthread_rwlock_init",
"pthread_rwlock_rdlock",
"pthread_rwlock_timedrdlock",
"pthread_rwlock_timedwrlock",
"pthread_rwlock_tryrdlock",
"pthread_rwlock_trywrlock",
"pthread_rwlock_unlock",
"pthread_rwlock_wrlock",
"pthread_rwlockattr_destroy",
"pthread_rwlockattr_getpshared",
"pthread_rwlockattr_init",
"pthread_rwlockattr_setpshared",
"pthread_self",
"pthread_setaffinity_np",
"pthread_setcancelstate",
"pthread_setcanceltype",
"pthread_setconcurrency",
"pthread_setschedparam",
"pthread_setschedprio",
"pthread_setspecific",
"pthread_sigmask",
"pthread_spin_destroy",
"pthread_spin_init",
"pthread_spin_lock",
"pthread_spin_trylock",
"pthread_spin_unlock",
"pthread_testcancel",
"pthread_timedjoin_np",
"pthread_tryjoin_np",
"pthread_yield",
"pthreads"
}

reserved_mem={
"calloc", "malloc", "free", "realloc"
}

reserved_atox={
"atoi", "atol", "atoll", "atoq",
"strtol", "strtoll", "strtod", "strtof", "strtold"
}
reserved_inet={
"inet_addr",
"inet_aton",
"inet_lnaof",
"inet_makeaddr",
"inet_netof",
"inet_network",
"inet_ntoa",
"inet_ntop",
"inet_pton"
}

reserved_io={
"clearerr",
"fclose",
"fdopen",
"feof",
"ferror",
"fflush",
"fgetc",
"fgetpos",
"fgets",
"fileno",
"fopen",
"fprintf",
"fpurge",
"fputc",
"fputs",
"fread",
"freopen",
"fscanf",
"fseek",
"fsetpos",
"ftell",
"fwrite",
"getc",
"getchar",
"gets",
"getw",
"mktemp",
"perror",
"printf",
"putc",
"putchar",
"puts",
"putw",
"remove",
"rewind",
"scanf",
"setbuf",
"setbuffer",
"setlinebuf",
"setvbuf",
"sprintf",
"sscanf",
"strerror",
"sys_errlist",
"sys_nerr",
"tempnam",
"tmpfile",
"tmpnam",
"ungetc",
"vfprintf",
"vfscanf",
"vprintf",
"vscanf",
"vsprintf",
"vsscanf"
}

reserved_sig = {
"SIGHUP",
"SIGINT",
"SIGQUIT",
"SIGILL",
"SIGTRAP",
"SIGABRT",
"SIGBUS",
"SIGFPE",
"SIGKILL",
"SIGUSR1",
"SIGSEGV",
"SIGUSR2",
"SIGPIPE",
"SIGALRM",
"SIGTERM",
"SIGSTKFLT",
"SIGCHLD",
"SIGCONT",
"SIGSTOP",
"SIGTSTP",
"SIGTTIN",
"SIGTTOU",
"SIGURG",
"SIGXCPU",
"SIGXFSZ",
"SIGVTALRM",
"SIGPROF",
"SIGWINCH",
"SIGIO",
"SIGPWR"
}

reserved_fmode ={
"O_RDONLY",
"O_WRONLY",
"O_RDWR",
"O_APPEND",
"O_ASYNC",
"O_CLOEXEC",
"O_CREAT",
"O_DIRECT",
"O_DIRECTORY",
"O_EXCL",
"O_LARGEFILE",
"O_NOATIME",
"O_NOCTTY",
"O_NOFOLLOW",
"O_NONBLOCK",
"O_SYNC",
"O_TRUNC",

}

reserved_macros = {

}

variables={}

for _,v in ipairs(reserved_type) do
keys[#keys+1]=v
end

for _,v in ipairs(reserved_string) do
keys[#keys+1]=v
end

for _,v in ipairs(reserved_unix) do
keys[#keys+1]=v
end

for _,v in ipairs(reserved_pthread) do
keys[#keys+1]=v
end

for _,v in ipairs(reserved_mem) do
keys[#keys+1]=v
end

for _,v in ipairs(reserved_atox) do
keys[#keys+1]=v
end

for _,v in ipairs(reserved_inet) do
keys[#keys+1]=v
end

for _,v in ipairs(reserved_io) do
keys[#keys+1]=v
end

for _,v in ipairs(reserved_sig) do
keys[#keys+1]=v
end

for _,v in ipairs(reserved_fmode) do
keys[#keys+1]=v
end

for _,v in ipairs(reserved_macros) do
keys[#keys+1]=v
end

for _, file in ipairs(arg) do 
  local words = ""
  local annotate = false
  local split = true
  for line in io.lines(file) do
  
    -- annotate one line
    fs, fe = string.find(line, '#include', 1, false)
    if fs then
       line = ""
    end
    
    -- annotate one line
    fs, fe = string.find(line, '//', 1, false)
    if fs then
       line = string.sub(line, 1, fs-1)
    end
    
    -- annotate multilines begin 
    if not annotate then
      fs, fe = string.find(line, '%/%*', 1, false)
      if fs then
        words = line
        annotate = true
      else
        words = line
      end
    else
      words = words .. line
    end
    
    -- annotate multilines end
    if annotate then
      fs, fe = string.find(words, '%*%/', 1, false)
      if fs then
        words = string.sub(words, fe+1)
        annotate = false
      end
    end
    
    if not annotate then
      -- print(words)
      for word in string.gmatch(words, "[%a_][%w_]+") do
          local valid = true
          for k, v in ipairs(keys) do
              if v == word then
                  valid = false
                  break;
              end
          end
          if valid then
            if variables[word] then
              variables[word]=variables[word]+1
            else
              variables[word]=1
            end
          end
      end
      words = ""
    end
    
  end
end

for key, count in pairs(variables) do
  print(key, '\t', count)
end

-- lua variable_desc.lua hostd.c  host.c | sort -k2 -n  按统计排序
-- lua variable_desc.lua hostd.c  host.c | sort         按字母排序
-- lua variable_desc.lua hostd.c  host.c | sort         按字母排序
-- sort otdrcode.txt  | grep -E -v "[a-z]+" 不包含小写字母
-- sort otdrcode.txt  | grep -E -v "[A-Z]+" 不包含大写字母
-- sort otdrcode.txt  | grep -E -v "[A-Z]+" 不包含大写字母
-- sort otdrcode.txt  | grep -E -v "[a-zA-Z]+" 不包含字母
-- sort otdrcode.txt  | grep -E  "[a-z]+[A-Z]+" 既有小写又有大写字母

