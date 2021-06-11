xstrncpy        xstrncat            字符串的边界
xmalloc  xzalloc xrealloc           NULL就崩
xstrndup xstrdup xmemdup xmprintf   NULL就崩
xprintf                             封装打印，如stderr
xputc xputs xflush                  0为正常返回值
xexec                               execvp(argv[0], argv);
xwaitpid                            返回子进程崩溃原因 

access      xaccess                 # 执行错误就崩溃 1. 返回值不等于0，2. 返回值等于-1； 3. 返回值等于NULL
unlink      xunlink
open        xcreate
pipe        xpipe
close       xclose
dup         xdup
fdopen      xfdopen
fopen       xfopen
read        xread
lseek       xlseek
getcwd      xgetcwd
stat        xstat
chdir       xchdir
chroot      xchroot
getpwuid    xgetpwuid   getpwnam
getgrgid    xgetgrgid   getgrnam
ioctl       xioctl
signal      xsignal

popen       xpopen(char **argv, int *pipe, int stdout)
pclose      xpclose(pid_t pid, int pipe)

malloc_or_warn
open3_or_warn
open_or_warn
rename_or_warn
warn_opendir
bb_ioctl_or_warn
# 拼接字符串
char *act_name = "sysinit\0wait\0once\0respawn\0askfirst\0ctrlaltdel\0"
                "shutdown\0restart\0";
for (tmp = act_name, i = 0; *tmp; i++, tmp += strlen(tmp) +1) 
# 整型数组
int types[] = {RB_AUTOBOOT, RB_HALT_SYSTEM, RB_POWER_OFF},
  sigs[] = {SIGTERM, SIGUSR1, SIGUSR2}, idx;
reboot(types[idx]);
kill(1, sigs[idx]);
# 映射表
struct signame {
  int num;
  char *name;
};
#define SIGNIFY(x) {SIG##x, #x}

static struct signame signames[] = {
  SIGNIFY(ABRT), SIGNIFY(ALRM), SIGNIFY(BUS),
  SIGNIFY(FPE), SIGNIFY(HUP), SIGNIFY(ILL), SIGNIFY(INT), SIGNIFY(KILL),
  SIGNIFY(PIPE), SIGNIFY(QUIT), SIGNIFY(SEGV), SIGNIFY(TERM),
  SIGNIFY(USR1), SIGNIFY(USR2), SIGNIFY(SYS), SIGNIFY(TRAP),
  SIGNIFY(VTALRM), SIGNIFY(XCPU), SIGNIFY(XFSZ),

  // Start of non-terminal signals

  SIGNIFY(CHLD), SIGNIFY(CONT), SIGNIFY(STOP), SIGNIFY(TSTP),
  SIGNIFY(TTIN), SIGNIFY(TTOU), SIGNIFY(URG)
};