---
title: Linux文件和进程权限控制
comments: true
---

# 文件和目录权限

目录的执行权限就是搜索权限，目录只有read权限没有执行权限则不能进入该目录，但是可以列出该目录内容，可以ls，有执行权限没有读权限，则不能ls，能cd，有W权限表示可以在该目录创建和删除。

x:1 w:2 r:4 SUID:4 SGID:2 SBIT:1

SUID和SGID用s表示，SBIT用其它组x位置，用t表示。相应位是S或者T表示该权限为空

SUID 只对二进制程序有效，执行者必须对该二进制程序文件有执行权限，执行者在执行该程序时，该程序拥有owner权限，获得的权限只在运行中有效

SGID SGID除了二进制文件，也能用在目录上，用户若对于此目录具有r和x权限，该用户能够进入此目录。用户在此目录下的有效群组会变成该目录所有者所在的群组，若用户在此目录下有w权限，则用户所建立的文件具有与此目录的群组相同的群组。

SBIT，只对目录有效，用户在该目录下建立档案或目录时，只有自己和root才有权利删除该档案

SUID:4 SGID:2 SBIT:1  chmod 4755 filename要使SUID，SGID，SBIT权限生效，必须要有执行权限，比如chmod 7666 filename,将出现大小的S，T表示该权限是空的。

SBIT sticky bit只对目录有效，当用户有此目录的w，x权限时，当在该目录下建立文件或者目录，仅有自己和root才有权力删除所建立的文件或者目录。也无法删除其他人的档案。

/tmp drwxrwxrwt

新创建的文件权限用户ID为进程的有效用户ID，组ID如果该文件所在目录设置了设置组ID，则新文件组ID设置为目录的组ID，否则文件组ID设置为进程的有效组ID

<!--more-->

# 进程权限

实际用户ID  RUID 标志当前用户ID 用于在系统中标识一个用户是谁，当用户使用用户名和密码成功登录后一个UNIX系统后就唯一确定了他的RUID

实际组ID    标志当前用户组ID

有效用户ID  EUID用于系统决定进程对系统资源的访问权限，通常情况下等于RUID，有SUID则等于SUID。EUID是二进制文件运行过程中的概念

有效组ID

附属组ID

保存的设置用户ID SUID，文件用于对外权限的开放。跟RUID及EUID是用一个用户绑定不同，它是跟文件而不是跟用户绑定。即set uid， 或者为saved set-user-ID

保存的设置组ID  SGID除了二进制文件，也能用在目录上，用户若对于此目录具有r和x权限，该用户能够进入此目录。用户在此目录下的有效群组会变成该目录所有者所在的群组，若用户在此目录下有w权限，则用户所建立的文件具有与此目录的群组相同的群组。

-r-s–x–x 1 root root 21944 Feb 12  2006 /usr/bin/passwd


# passwd文件读取

    struct passwd {
    	char   *pw_name;       /* username */
    	char   *pw_passwd;     /* user password */
    	uid_t   pw_uid;        /* user ID */
    	gid_t   pw_gid;        /* group ID */
    	char   *pw_gecos;      /* user information */
    	char   *pw_dir;        /* home directory */
    	char   *pw_shell;      /* shell program */
    };

## 用户名和ID映射
    #include <sys/types.h>
    #include <pwd.h>

    struct passwd *getpwnam(const char *name);//由login函数调用，将用户名映射成ID
    struct passwd *getpwuid(uid_t uid)//将数字用户ID映射成用户登录名
    int getpwnam_r(const char *name, struct passwd *pwd, char *buf, size_t buflen, struct passwd **result);
    int getpwuid_r(uid_t uid, struct passwd *pwd, char *buf, size_t buflen, struct passwd **result);
    int getpw(uid_t uid, char *buf);

    #include <stdio.h>
    #include <sys/types.h>
    #include <pwd.h>

## 组名和组ID映射

#include <sys/types.h>
#include <grp.h>

struct group *getgrnam(const char *name);

struct group *getgrgid(gid_t gid);

int getgrnam_r(const char *name, struct group *grp,
          char *buf, size_t buflen, struct group **result);

int getgrgid_r(gid_t gid, struct group *grp,
          char *buf, size_t buflen, struct group **result);

## 密码文件读取

    struct passwd *getpwent(void);
    void setpwent(void);//反饶密码文件，就是读取位置置为初始位置
    void endpwent(void);//关闭打开的密码文件
    int putpwent(const struct passwd *p, FILE *stream);//将密码写入stream打开的文件
    struct passwd *fgetpwent(FILE *stream);
    int getpwent_r(struct passwd *pwbuf, char *buf, size_t buflen, struct passwd **pwbufp);
    int fgetpwent_r(FILE *stream, struct passwd *pwbuf, char *buf, size_t buflen, struct passwd **pwbufp);

/etc/passwd

## 组文件读取

    struct group {
    	char   *gr_name;        /* group name */
    	char   *gr_passwd;      /* group password */
    	gid_t   gr_gid;         /* group ID */
    	char  **gr_mem;         /* NULL-terminated array of pointers
    							to names of group members */
    };

    #include <sys/types.h>
    #include <grp.h>

    struct group *getgrent(void);
    void setgrent(void);
    void endgrent(void);
    struct group *fgetgrent(FILE *stream);
    int getgrent_r(struct group *gbuf, char *buf, size_t buflen, struct group **gbufp);
    int fgetgrent_r(FILE *stream, struct group *gbuf, char *buf, size_t buflen, struct group **gbufp);
    int putgrent(const struct group *grp, FILE *stream);

/etc/group

## 附属组操作

    #include <sys/types.h>
    #include <unistd.h>
    int getgroups(int size, gid_t list[]);//获取进程所属用户各附属组ID到list
    #include <grp.h>
    int setgroups(size_t size, const gid_t *list);//由超级用户进程设置进程的附属组ID
    int initgroups(const char *user, gid_t group);
    int group_member(gid_t gid);
    int getgrouplist(const char *user, gid_t group, gid_t *groups, int *ngroups);

## 影子文件读取

    #include <shadow.h>
    struct spwd *getspnam(const char *name);
    struct spwd *getspent(void);
    void setspent(void);
    void endspent(void);
    struct spwd *fgetspent(FILE *stream);
    struct spwd *sgetspent(const char *s);
    int putspent(const struct spwd *p, FILE *stream);
    int lckpwdf(void);
    int ulckpwdf(void);

    /* GNU extension */
    #include <shadow.h>

    int getspent_r(struct spwd *spbuf, char *buf, size_t buflen, struct spwd **spbufp);
    int getspnam_r(const char *name, struct spwd *spbuf, char *buf, size_t buflen, struct spwd **spbufp);
    int fgetspent_r(FILE *stream, struct spwd *spbuf, char *buf, size_t buflen, struct spwd **spbufp);
    int sgetspent_r(const char *s, struct spwd *spbuf, char *buf, size_t buflen, struct spwd **spbufp);

/etc/shadow

## /etc/hosts

    struct addrinfo {
        int              ai_flags;
        int              ai_family;
        int              ai_socktype;
        int              ai_protocol;
        socklen_t        ai_addrlen;
        struct sockaddr *ai_addr;
        char            *ai_canonname;
        struct addrinfo *ai_next;
    };

    int getnameinfo(const struct sockaddr *addr, socklen_t addrlen, char *host, socklen_t hostlen, char *serv, socklen_t servlen, int flags);
    int getaddrinfo(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res);
    void freeaddrinfo(struct addrinfo *res);
    const char *gai_strerror(int errcode);


## /etc/networks

    struct netent {
        char      *n_name;     /* official network name */
        char     **n_aliases;  /* alias list */
        int        n_addrtype; /* net address type */
        uint32_t   n_net;      /* network number */
    }

    #include <netdb.h>
    struct netent *getnetent(void);
    struct netent *getnetbyname(const char *name);
    struct netent *getnetbyaddr(uint32_t net, int type);
    void setnetent(int stayopen);
    void endnetent(void);
    int getnetent_r(struct netent *result_buf, char *buf, size_t buflen, struct netent **result, int *h_errnop);

    int getnetbyname_r(const char *name, struct netent *result_buf, char *buf, size_t buflen, struct netent **result, int *h_errnop);

    int getnetbyaddr_r(uint32_t net, int type, struct netent *result_buf, char *buf, size_t buflen, struct netent **result, int *h_errnop);

## /etc/protocols

    struct protoent {
        char  *p_name;       /* official protocol name */
        char **p_aliases;    /* alias list */
        int    p_proto;      /* protocol number */
    }

    #include <netdb.h>

    struct protoent *getprotoent(void);
    struct protoent *getprotobyname(const char *name);
    struct protoent *getprotobynumber(int proto);
    void setprotoent(int stayopen);
    void endprotoent(void);
    #include <netdb.h>
    int getprotoent_r(struct protoent *result_buf, char *buf,  size_t buflen, struct protoent **result);
    int getprotobyname_r(const char *name, struct protoent *result_buf, char *buf, size_t buflen, struct protoent **result);
    int getprotobynumber_r(int proto, struct protoent *result_buf, char *buf, size_t buflen, struct protoent **result);

## /etc/services

    struct servent {
    	char  *s_name;       /* official service name */
    	char **s_aliases;    /* alias list */
    	int    s_port;       /* port number */
    	char  *s_proto;      /* protocol to use */
    }

    #include <netdb.h>
    struct servent *getservent(void);
    struct servent *getservbyname(const char *name, const char *proto);
    struct servent *getservbyport(int port, const char *proto);
    void setservent(int stayopen);
    void endservent(void);

    #include <netdb.h>

    int getservent_r(struct servent *result_buf, char *buf, size_t buflen, struct servent **result);
    int getservbyname_r(const char *name, const char *proto, struct servent *result_buf, char *buf, size_t buflen, struct servent **result);
    int getservbyport_r(int port, const char *proto, struct servent *result_buf, char *buf, size_t buflen, struct servent **result);

## /etc/hostname

    #include <unistd.h>

    int getdomainname(char *name, size_t len);
    int setdomainname(const char *name, size_t len);

    int gethostname(char *name, size_t len);
    int sethostname(const char *name, size_t len);


## uname

    struct utsname {
        char sysname[];    /* Operating system name (e.g., "Linux") */
        char nodename[];   /* Name within "some implementation-defined
                              network" */
        char release[];    /* Operating system release (e.g., "2.6.28") */
        char version[];    /* Operating system version */
        char machine[];    /* Hardware identifier */
    #ifdef _GNU_SOURCE
        char domainname[]; /* NIS or YP domain name */
    #endif
    };

    #include <sys/utsname.h>
    int uname(struct utsname *buf);

# RUID, SUID, EUID, SUID

    #include <sys/types.h>
    #include <unistd.h>

    int setuid(uid_t uid);
    uid_t getuid(void);
    1. 进程有超级用户权限，可以设置实际用户ID、有效用户ID以及SUID为uid，特权用户或设置用户ID是root，调用setuid后，进程不能再获取root权限
    2. 没有超级用户权限，但是uid等于实际用户ID，或保存的设置用户ID，则setuid只将有效用户ID设置为uid，不更改实际用户和保存的设置用户ID
    3. 以上都不满足errno设置为EPERM，并返回-1

    int seteuid(uid_t euid);//将有效用户ID设置为实际用户ID或保存的设置用户ID
    uid_t geteuid(void);

    int setreuid(uid_t ruid, uid_t euid);//交换实际用户ID和有效用户ID

    int setresuid(uid_t ruid, uid_t euid, uid_t suid);//同时分别设置RUID, EUID,SUID，只有特权进程可以设置RUID
    int getresuid(uid_t *ruid, uid_t *euid, uid_t *suid);

# RGID, SGID, EGID, SGID

    int setgid(gid_t gid);
    gid_t getgid(void);

    int setegid(gid_t egid);
    gid_t getegid(void);

    int setregid(gid_t rgid, gid_t egid);//交换实际组ID合有效组ID
    int setresgid(gid_t rgid, gid_t egid, gid_t sgid);
    int getresgid(gid_t *rgid, gid_t *egid, gid_t *sgid);
