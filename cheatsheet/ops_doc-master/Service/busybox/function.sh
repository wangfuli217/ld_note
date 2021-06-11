/sbin/init
/etc/init
/bin/init
/bin/sh


见于Chmod，Cp，Find，Mkdir，Mkfifo，Mknod，Uudecode
见于Ls， stat， tar
## 实现字符和位码之间对应关系，使用union类型也许会简单些。
# int FAST_FUNC bb_parse_mode(const char *s, mode_t *current_mode)
mode_t(tostring)  
{
<1>     mode_t string_to_mode(char *modestr, mode_t mode)
1. extrabits = mode & ~(07777); 保留自身、组、其他用户的读写执行外的其他属性。
2. isdigit(*str); 输入为数字，则进行mode = strtol(str, end, base); 然后，返回mode | extrabits;
3. 如果未指定chmod [who] operator [permission] filename 中的who，那么who默认值为a。
4. 判断是 "=+-" 中何种操作。operator
5. 判断是"xwrstX" 中何种操作。permission
6. 如果未设定 permission则是从其他文件设定相同的属性。
for (i=0; i<4; i++)
    for (j=0; j<3; j++)
*whos = "ogua", *hows = "=+-", *whats = "xwrstX", *whys = "ogu", 与之对应的位运算。

<2>     void mode_to_string(mode_t mode, char *buf)
从mode_t类型到drwxrwxrwx字符串转换。
}

stat(文件属性 stat.h)
{
文件类型
#define S_IFMT  00170000
#define S_IFSOCK 0140000 socket
#define S_IFLNK	 0120000 硬链接
#define S_IFREG  0100000 普通文件
#define S_IFBLK  0060000 块文件
#define S_IFDIR  0040000 目录文件
#define S_IFCHR  0020000 字符文件
#define S_IFIFO  0010000 管道文件
#define S_ISUID  0004000 设置用户组ID位 #当设置用户组ID位为1，则文件执行时，内核将其进程的有效用户组ID设置为文件的所有组ID。
#define S_ISGID  0002000 设置用户ID位   #当设置用户ID位为1，则文件执行时，内核将其进程的有效用户ID设置为文件所有者的用户ID。
#define S_ISVTX  0001000  内存中运行

#define S_ISLNK(m)	(((m) & S_IFMT) == S_IFLNK)
#define S_ISREG(m)	(((m) & S_IFMT) == S_IFREG)
#define S_ISDIR(m)	(((m) & S_IFMT) == S_IFDIR)
#define S_ISCHR(m)	(((m) & S_IFMT) == S_IFCHR)
#define S_ISBLK(m)	(((m) & S_IFMT) == S_IFBLK)
#define S_ISFIFO(m)	(((m) & S_IFMT) == S_IFIFO)
#define S_ISSOCK(m)	(((m) & S_IFMT) == S_IFSOCK)

#define S_IRWXU 00700 #用户
#define S_IRUSR 00400
#define S_IWUSR 00200
#define S_IXUSR 00100

#define S_IRWXG 00070 #组
#define S_IRGRP 00040
#define S_IWGRP 00020
#define S_IXGRP 00010

#define S_IRWXO 00007 #其他
#define S_IROTH 00004
#define S_IWOTH 00002
#define S_IXOTH 00001

#define S_IRWXUGO	(S_IRWXU|S_IRWXG|S_IRWXO)              所有用户可以读写执行
#define S_IALLUGO	(S_ISUID|S_ISGID|S_ISVTX|S_IRWXUGO)    所有用户可以读写执行：设置用户组ID，设置用户ID位和内存运行位
#define S_IRUGO		(S_IRUSR|S_IRGRP|S_IROTH)              所有用户可以读取
#define S_IWUGO		(S_IWUSR|S_IWGRP|S_IWOTH)              所有用户可以写入
#define S_IXUGO		(S_IXUSR|S_IXGRP|S_IXOTH)              所有用户可执行

stat、fstat和lstat函数。
}


struct signame {
  int num;
  char *name;
};

// Signals required by POSIX 2008:
// http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/signal.h.html

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

见于Kill， killall， ps和timeout
sig(tonum)
{
<1>     sig_to_num(char *pidstr)
1. define 命令的作用。"#define SIGNIFY(x) {SIG##x, #x}"
2. 和dns解析具有相似的判断：如果是数字直接返回sig的值，如果是字符串，返回字符串对应的数字。
                            如果由sig开头，去掉sig头，如果没有，直接比较。  
<2>     char *num_to_sig(int sig)   

}

见于bootchartd， pidof， killall
方式回调：将处理过程和检索过程分离。
names_to_pid(从程序名到pid数字)
{
void names_to_pid(char **names, int (*callback)(pid_t pid, char *name))
1. 循环查找/proc/[pid]/cmdline 中与names名字相同的，然后打印对应的pid值。

}

dev(主设备号，次设备号)
{
dev_minor(){}
dev_major(){}
dev_makedev(){}
}

快速排序 + 折半查找法 基本算法
qsort(快速排序)
{
参数：1 待排序数组首地址
      2 数组中待排序元素数量
      3 各元素的占用空间大小
      4 指向函数的指针，用于确定排序的顺序
      
qsort（即，quicksort）主要根据你给的比较条件给一个快速排序，主要是通过指针移动实现排序功能。
排序之后的结果仍然放在原来数组中。   
}

bsearch(折半查找法)
{
void *bsearch(const void *key, const void *base,
                     size_t nmemb, size_t size,
                     int (*compar)(const void *, const void *));
参数： 第一个：要查找的关键字。
        第二个：要查找的数组。
        第三个：指定数组中元素的数目。
        第四个：每个元素的长度（以字符为单位）。
        第五个：指向比较函数的指针。
功能： 函数用折半查找法在从数组元素buf[0]到buf[num-1] 匹配参数key。
       如果函数compare 的第一个参数小于第二个参数，返回负值；
       如果等于返回零值；如果大于返回正值。
       数组buf 中的元素应以升序排列。函数bsearch()的返回值是指向匹配项，
       如果没有发现匹配项，返回NULL                     
}

lfind(man search.h)
{
函数名: lfind
功 能: 执行线性搜索
用 法: void *lfind(void *key, void *base, int *nelem, int width,
int (*fcmp)(const void *, const void *));

哈希表
int    hcreate(size_t);
void   hdestroy(void);
ENTRY *hsearch(ENTRY, ACTION);

链表
insque, remque - insert/remove an item from a queue
void   insque(void *, void *);
void   remque(void *);

顺序查找
void  *lfind(const void *, const void *, size_t *,
        size_t, int (*)(const void *, const void *));
void  *lsearch(const void *, void *, size_t *,
        size_t, int (*)(const void *, const void *));

树
void  *tdelete(const void *restrict, void **restrict,
        int(*)(const void *, const void *));
void  *tfind(const void *, void *const *,
        int(*)(const void *, const void *));
void  *tsearch(const void *, void **,
        int(*)(const void *, const void *));
void   twalk(const void *,
        void (*)(const void *, VISIT, int ));

        
        
        
}

strsuftoll：    从人可读性的数值到计算机可以识别的数值
human_readable：从计算机可识别的数值到人可识别的数值
struct pair {
  char *name;
  unsigned val;
};

static struct pair suffixes[] = {
  { "c", 1 }, { "w", 2 }, { "b", 512 },
  { "kD", 1000 }, { "k", 1024 }, { "K", 1024 },
  { "MD", 1000000 }, { "M", 1048576 },
  { "GD", 1000000000 }, { "G", 1073741824 }
};
strsuftoll(计算机可读性数值)
{
    static unsigned long long strsuftoll(char* arg, int def, unsigned long long max)
    arg：字符串
    def：默认值
    max；最大值
    用于：将dd命令中bs，ibs，obs，count，skip，seek参数指定数量，转化为真实的数值。
}

见于：dd, df, du, free, ls, ps
human_readable(人可读性的数字解释)
{
int human_readable(char *buf, unsigned long long num, int style)
buf: 输出缓冲区
num: 需要显示的数字
style； HR_SPACE #单位和数字是否有空格
        HR_B     #按B结尾
        HR_1000  #按照1024字节显示还是按1000显示
}


string(查找)
{
4 查找
 
char* strchr (const char *s, int ch);
void* memchr (const void *s, int ch, size_t len);
在s中查找给定字符(字节值)ch第一次出现的位置
 
char* strrchr (const char *s, int ch);
在串s中查找给定字符ch最后一次出现的位置, r表示从串尾开始
 
char* strstr (const char *s1, const char *s2);
在串s1中查找指定字符串s2第一次出现的位置
 
size_t strspn (const char *s1, const char *s2);
返回s1中第一个在s2中不存在的字符的索引(find_first_not_of)
 
size_t strcspn (const char *s1, const char *s2);
返回s1中第一个也在s2中存在的字符的索引(find_first_of)
 
char* strpbrk (const char *s1, const char *s2);
与strcspn类似, 区别是返回指针而不是索引
 
char* strtok (char *s1, const char *s2);
从串s1中分离出由串s2中指定的分界符分隔开的记号(token)
第一次调用时s1为需分割的字串, 此后每次调用都将s1置为NULL,
每次调用strtok返回一个记号, 直到返回NULL为止

}
strsep(分解字符串为一组字符串){
char *strsep(char **stringp, const char *delim);
分解字符串为一组字符串。从stringp指向的位置起向后扫描，遇到delim指向的字符串中的字符后，将此字符替换为NULL，
返回stringp指向的地址。它适用于分割"关键字"在两个字符串之间只"严格出现一次"的情况。

1.strsep淘汰strtok
2.strtok是不可重入的，strseq是可重入的。(还有一个strtok_r是strtok的可重入版本)
3.strsep和strtok都对修改了src字符串。
4.strsep和strtok对字符串分割结果不一致。

char input[] = "a;a,;bc,;d";  
char *p;  
for(p = strtok(input, ",;");p!=NULL;p=strtok(NULL, ",;")){  
        printf("%s\n", p);  
}
printf("original String:%s\n",input); 
# a
# a
# bc
# d
# original String:a
char input[] = "a;a,;bc,;d";  
char *string = input;  
char *p;  
while((p = strsep(&string,",;"))!=NULL)  
printf("%s\n",p);
# a
# a
# 
# bc
# 
# d
# original String:a
}

strpbrk(在源字符串（s1）中找出最先含有搜索字符串（s2）中任一字符的位置)
{
strpbrk是在源字符串（s1）中找出最先含有搜索字符串（s2）中任一字符的位置并返回，若找不到则返回空指针。
}

base64：base64 encode/decode data and print to standard output 

在回调函数中可以使用全局变量，更好的使用的动态输入。可以更好的轮询。
base64、blkid、fstype、zcat、cat、cksum、gunzip、gzip
dos2unix、unix2dos、expand、unexpand、flod、head、tail、iconv、more、nl、od、hexdump
partprobe、readahead、rev、sort、split
loopfiles(循环对指定文件进行操作)
{
void loopfiles(char **argv, void (*function)(int fd, char *name)) 循环打开一个文件对之进行操作
void loopfiles_rw(char **argv, int flags, int permissions, int failok, void (*function)(int fd, char *name))

}

verror_msg(正常打印，错误打印，正常打印+退出, 错误打印+退出；){}
void verror_msg(char *msg, int err, va_list va)
error_msg(char *msg, ...)       = verror_msg(msg, 0, va);
perror_msg(char *msg, ...)      = verror_msg(msg, errno, va);
error_exit(char *msg, ...)      = verror_msg(msg, 0, va); + exit()
perror_exit(char *msg, ...)     = verror_msg(msg, errno, va); + exit()
error_msg_raw(char *msg)        = error_msg("%s", msg);
perror_msg_raw(char *msg)       = perror_msg("%s", msg);
error_exit_raw(char *msg)       = error_exit("%s", msg);
perror_exit_raw(char *msg)      = perror_exit("%s", msg);

xread(读取指定长度的数据，直到EOF -- 已处理信号中断){busybox
xread -> 调用full_read，提供了错误打印提示
full_read -> 调用safe_read，尽力读取指定长度数据
safe_read -> 处理了EINTR，未处理EAGAIN和EWOULDBLOCK，尽力读取指定长度数据。

nonblock_safe_read -> 处理EAGAIN，尽力读取指定长度数据，非阻塞方式读取，阻塞在poll，而不是read
safe_read -> 处理了EINTR，未处理EAGAIN和EWOULDBLOCK，尽力读取指定长度数据。

open_read_close  -> open 一次去读文件内所有数据
read_close  -> full_read - close 
full_read - read

xmalloc_read   -> 不提供缓存，调用函数自动申请缓冲区
full_read - read
}
readall(读取指定长度的数据，直到EOF -- 未处理信号中断){toybox}
# Keep reading until full or EOF
readall(int fd, void *buf, size_t len)
{
#  size_t count = 0;
#
#  while (count<len) {
#    int i = read(fd, (char *)buf+count, len-count);
#    if (!i) break;
#    if (i<0) return i;
#    count += i;
#  }
#
#  return count;
}

xwrite(写入文件指定长度的数据 -- 已处理信号中断){busybox
xwrite -> 调用full_write，提供了错误打印提示
full_write -> 调用full_write，尽力读取指定长度数据
safe_write -> 处理了EINTR，未处理EAGAIN和EWOULDBLOCK，尽力读取指定长度数据。

}
writeall(写入文件指定长度的数据 -- 未处理信号中断){toybox}
# Keep writing until done or EOF
writeall(int fd, void *buf, size_t len)
{
#  size_t count = 0;
#  while (count<len) {
#    int i = write(fd, count+(char *)buf, len-count);
#    if (i<1) return i;
#    count += i;
#  }
#
#  return count;
}

struct dirtree {
  struct dirtree *next, *parent, *child;
  long extra; // place for user to store their stuff (can be pointer)
  struct stat st;
  char *symlink;
  int dirfd;
  char again;
  char name[];
};

dir()
{
notdotdot(文件名开头不是.. 或 .){是..或. 返回0；否则返回1}
dirtree_notdotdot(文件名开头不是.. 或 . 返回值依赖于输入参数){是..或. 返回0；否则返回根据输入进行返回非0值}
dirtree_add_node(Create a dirtree node from a path, with stat and symlink info){}
dirtree_path(){}
dirtree_parentfd(){}
dirtree_handle_callback(){}
dirtree_recurse(){}
dirtree_flagread(){}
dirtree_read(){}



}

sysconf()
{
linux运行环境限制
unix中有以下三种限制：
（1）编译时限制（头文件）
（2）不与文件或目录相关联的运行时限制（sysconf函数）
（3）与文件或目录相关联的运行时限制（pathconf函数和fpahtconf函数
第一种是属于编译时限制，这类限制一般都作为宏定义在头文件中，例如CHAR_MAX等，关键是后两种限制，它们属于运行时的环境限制，需要使用以下三种函数进行检测：


    long sysconf(int name);  
    long pathconf(const char *pathname, int name);  
    long fpathname(int filedes, int name);  

它们是用来检测linux运行环境的限制的，成功返回响应值，出错则返回-1。
第一个函数是检测不与文件或目录相关联的运行时限制，例如OPEN_MAX，它返回用户可打开文件的最大数量。
而后两个函数则是分别用于检测与目录或文件相关联的运行时限制，例如LINK_MAX，它返回文件链接数的最大值。
}

isatty()
{
isatty，函数名。主要功能是检查设备类型 ， 判断文件描述词是否是为终端机。
用 法: int isatty(int desc);
返回值：如果参数desc所代表的文件描述词为一终端机则返回1，否则返回0。
}

getpwnam(getpwnam函数功能是获取用户登录相关信息。)
{
原型定义: struct passwd *getpwnam(const char *name);
返回值：若成功，返回指针；若出错或者达到文件尾端，返回NULL。
信息存贮在如下的结构体之中
struct passwd {
char * pw_name; /* Username. */
char * pw_passwd; /* Password. */
__uid_t pw_uid; /* User ID. */
__gid_t pw_gid; /* Group ID. */
char * pw_gecos; /* Real name. */
char * pw_dir; /* Home directory. -*/
char * pw_shell; /* Shell program. */
};
}

getspnam(getspnam是linux函数库中访问shadow的口令)
{
getspnam() 函数功能：访问shadow口令
原型定义：struct spwd *getspnam(char *name);
信息存贮在如下的结构体之中
struct spwd {
char *sp_namp; /* Login name. */
char *sp_pwdp; /* Encrypted password. */
long int sp_lstchg; /* Date of last change. */
long int sp_min; /* Minimum number of days between changes. */
long int sp_max; /* Maximum number of days between changes. */
long int sp_warn; /* Number of days to warn user to change
the password. */
long int sp_inact; /* Number of days the account may be
inactive. */
long int sp_expire; /* Number of days since 1970-01-01 until
account expires. */
unsigned long int sp_flag; /* Reserved. */
};
}

crypt()
{
char *crypt(const char *key, const char *salt);
key：要加密的明文。
salt：密钥。
salt 默认使用DES加密方法。DES加密时，salt只能取两个字符，多出的字符会被丢弃。
}
