/*
 * Copyright (C) Tildeslash Ltd. All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * In addition, as a special exception, the copyright holders give
 * permission to link the code of portions of this program with the
 * OpenSSL library under certain conditions as described in each
 * individual source file, and distribute linked combinations
 * including the two.
 *
 * You must obey the GNU Affero General Public License in all respects
 * for all of the code used other than OpenSSL.
 */
# yywrap： 解析一个文件完毕之后，会调用yywrap:返回1表示结束，0表示继续扫描
# 如果自定义函数yywrap，则可以加入:或者，编译时使用选项: -1f1,表示yywrap返回1
%option noyywrap
# noyywrap 不需要定义noyywrap函数，接口名如：int yywrap (void) 正常情况返回1.  radvd和monit都设置该选项

# 这一函数在文件（或输入）的末尾调用。 如果函数的返回值是1，就停止解析。 因此它可以用来解析多个文件。
#  代码可以写在第三段，这就能够解析多个文件。 方法是使用 yyin 文件指针（见上表）指向不同的文件，直到
# 所有的文件都被解析。 最后，yywrap() 可以返回 1 来表示解析的结束。


# 要求flex在解析配置文件时，记录当前读取配置文件的行。 如果没有，则需要自己通过模式实现。
%option yylineno # lexer不一定支持。


# -i, --case-insensitive 忽略大小
# -L --noline 禁止 #line 指令，即 scanner.l 中的__LINE__不反应在 C代码在scanner.l中的位置，而是lex.yy.c的位置

# #定义段 开始
%{

/*
 * DESCRIPTION
 *
 *   Lexical grammar for tokenizing the control file.
 *
 */

#include "config.h"

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_GLOB_H
#include <glob.h>
#endif

#ifdef HAVE_STRINGS_H
#include <strings.h>
#endif

#include "monit.h"
#include "tokens.h"

// libmonit
#include "util/Str.h"


// we don't use yyinput => do not generate it
# 由flex自己生成input函数，
#define YY_NO_INPUT

#define MAX_STACK_DEPTH 512

int buffer_stack_ptr = 0;

# 用于保存include中获得文件
struct buffer_stack_s {
        int             lineno;
        char           *currentfile;
        YY_BUFFER_STATE buffer;
} buffer_stack[MAX_STACK_DEPTH];


# 跟踪配置文件行号和行信息的字段，用于调试
int lineno = 1;
int arglineno = 1;
char *currentfile = NULL;
char *argcurrentfile = NULL;
char *argyytext = NULL;

# 开始条件下，记录当前的 被监控项 类型
typedef enum {
        Proc_State,
        File_State,
        FileSys_State,
        Dir_State,
        Host_State,
        System_State,
        Fifo_State,
        Program_State,
        Net_State,
        None_State
} __attribute__((__packed__)) Check_State;

static Check_State check_state = None_State;

/* Prototypes */
# 在p.y中定义，用以记录 扫描器 遇到的错误。
extern void yyerror(const char *,...);
extern void yyerror2(const char *,...);
extern void yywarning(const char *,...);
extern void yywarning2(const char *,...);

# 管理 lineno, arglineno和currentfile argcurrentfile argyytext
static void steplinenobycr(char *);
static void save_arg(void);

# include子项处理，用于实现多配置文件
static void include_file(char *);
static char *handle_quoted_string(char *);
static void push_buffer_state(YY_BUFFER_STATE, char*);
static int  pop_buffer_state(void);

# 创建URL_T实例
static URL_T create_URL(char *proto);

%} # 规则段包含模式行和C代码，以空白开始的行或者包围在%{和%}中的内容是C代码。它们会被原封不动地拷贝到yylex()中。
#定义段 结束

# 尽量不要将 { } [ ] ;作为关键字和模式进行匹配
# 定义段包括文字块、定义、内部表声明、起始条件和转换。
# [name]       [definition]                  # [comment]
ws             [ \r\t]+                      # 空白
wws            [ \r\t;,()]+                  # 空白;,() 宽字符空白表示
number         [0-9]+                        # 正整数
real           [0-9]+([.][0-9]+)?            # 实数  +正整数是实数的子类
str            [^\000-\041@:{}"';(),%]+      # 字符串，不包含@:{}"'(),% 和 ! " # $ % & ? ( )
address        [^\000-\041<>{}\[\]]+         # 地址，不包含<>{}[]               041   33    21    ! 
addrname       [^\000-\037@<>{}\[\]]+        # 地址名，不包含@<>{}[]            037   31    1F    US  (unit separator)
hostname       {str}(\.{str})*               # 主机名 +hostname是字符串的子类
dec-octet      [0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5] # 255内数字 1位表示+2位表示+3位表示(100以内)+3位表示(250以内)+3位表示(255以内)
h16            [0-9A-Fa-f]{1,4}              # 1到4位 hex数
ipv4           {dec-octet}\.{dec-octet}\.{dec-octet}\.{dec-octet} # ipv4地址
ls32           {h16}:{h16}|{ipv4}            # ipv6地址表示格式，
ipv6           ({h16}:){6}{ls32}|::({h16}:){5}{ls32}|({h16})?::({h16}:){4}{ls32}|(({h16}:){0,1}{h16})?::({h16}:){3}{ls32}|(({h16}:){0,2}{h16})?::({h16}:){2}{ls32}|(({h16}:){0,3}{h16})?::{h16}:{ls32}|(({h16}:){0,4}{h16})?::{ls32}|(({h16}:){0,5}{h16})?::{h16}|(({h16}:){0,6}{h16})?::
greater        ("more"|"greater"|"gt"|">"|"older") # 大于
greaterorequal ("ge"|">=")                         # 大于等于
less           ("less"|"lt"|"<"|"newer")           # 小于
lessorequal    ("le"|"<=")                         # 小于等于
equal          ("equal"|"eq"|"=="|"=")             # 等于
notequal       ("notequal"|"ne"|"!=")              # 不等于

# 上述是一个单词的匹配规则，下面是多个单词的匹配规则。
# 1. 上述是一些基本模式定义，目的是为了后续引用。定义之间不存在优先级关系，存在的是包含和互斥的关系。
# 2. 多个单词的匹配规则，2.1 要区分单词如何分割(默认使用空格进行分割)
# 2.2 要区分哪些是关键单词|单词组(load(avg) 可视为关键单词词组， cpu start stop可视为关键单词)，
# 2.3 哪些是可选单词 usage和program是可选单词，存在与否不影响匹配结果；
# 2.4 哪些是必选单词 us|usr|user sy|sys|system wa|wait m|min 是必须要选择一个

#  "LOADAVG([1min|5min|15min])"
loadavg1       load(avg)[ ]*(\([ ]*1[ ]*(m|min)?[ ]*\))?  # 1分钟负载        LOADAVG(1min)   LOADAVG(1m)  loadavg
loadavg5       load(avg)[ ]*\([ ]*5[ ]*(m|min)?[ ]*\)     # 5分钟负载        LOADAVG(5min)   LOADAVG(5m) 
loadavg15      load(avg)[ ]*\([ ]*15[ ]*(m|min)?[ ]*\)    # 15分钟负载       LOADAVG(15min)  LOADAVG(15m) 
cpuuser        cpu[ ]*(usage)*[ ]*\([ ]*(us|usr|user)?[ ]*\)    # usr cpu    cpu(usage)  cpu usage (us|usr|user) # usage可以忽略
cpusyst        cpu[ ]*(usage)*[ ]*\([ ]*(sy|sys|system)?[ ]*\)  # sys cpu 
cpuwait        cpu[ ]*(usage)*[ ]*\([ ]*(wa|wait)?[ ]*\)        # wait cpu
startarg       start{ws}?(program)?{ws}?([=]{ws})?["]           # start 方法 <START | STOP | RESTART> [PROGRAM] = "program" program可有可无
stoparg        stop{ws}?(program)?{ws}?([=]{ws})?["]            # stop  方法
restartarg     restart{ws}?(program)?{ws}?([=]{ws})?["]         # restart 方法
execarg        exec(ute)?{ws}?["]                               # exec 方法

#  PATH <path>
pathtokarg     path{ws}?["]                                     # 路径

# 下述内容体现了单词词义多样性，复数|单数，简略|全词，符号|单词。形式多样内容一致。
percent        ("percent"|"%")                                  # 百分比
byte           ("byte"|"bytes"|"b")("/s")?                      # 字节
kilobyte       ("kilobyte"|"kilobytes"|"kb")("/s")?             # 千字节
megabyte       ("megabyte"|"megabytes"|"mb")("/s")?             # 兆字节
gigabyte       ("gigabyte"|"gigabytes"|"gb")("/s")?             # G字节
millisecond    ("millisecond"|"milliseconds"|"ms")              # 毫秒
second         ("second"|"seconds"|"s")                         # 秒
minute         ("minute"|"minutes"|"m")                         # 分
hour           ("hour"|"hours"|"h")                             # 时
day            ("day"|"days")                                   # 天
month          ("month"|"months")                               # 月
atime          ("atime"|"access time"|"access timestamp")       # 访问时间
ctime          ("ctime"|"change time"|"change timestamp")       # 改变时间
mtime          ("mtime"|"modification time"|"modification timestamp"|"modify time"|"modify timestamp")  # 修改时间

# 起始状态和嵌套输入文件
#  起始状态指定在特定时刻哪些模式可以用来匹配，尖括号括起的起始状态之后的模式为其指定的模式
#  %x指定独占的起始状态，当该状态被激活时，只有它的模式可以进行匹配；
#  %s声明包含的起始状态，允许未被标记的模式匹配
#  宏BEGIN用来切换到另一个起始状态
#  切换缓冲区的步骤：保存当前缓冲区，然后yy_switch_buffer切换缓冲区，设置状态INITIATE后，使用正常模式进行匹配

%x ARGUMENT_COND DEPEND_COND SERVICE_COND URL_COND ADDRESS_COND STRING_COND EVERY_COND HTTP_HEADER_COND INCLUDE

# 规则段 开始
%%
# 规则段包含模式行和C代码，以空白开始的行或者包围在%{和%}中的内容是C代码。它们会被原封不动地拷贝到yylex()中。
# 规则顺序暗示，优先级越来越高
{wws}             { /* Wide white space */ } # 忽略空白
(#.*)?\\?\n?      { lineno++; }              # 行号

# 规则部分开始的行会被放在生成的yylex()函数中临近开头的地方，也暗示了 先声明优先级越高。即 is比as优先级高 ...
# 忽略输入内容
# 对于忽略有两种方式，一种是单个单词，使得这些单词不出现在p.y中，另一种是多个单词组中，某些单词是可以忽略的。
# pattern         action
is                {/* EMPTY */}
as                {/* EMPTY */}
are               {/* EMPTY */}
for               {/* EMPTY */}
via               {/* EMPTY */}
on(ly)?           {/* EMPTY */}
with(in|out)?     {/* EMPTY */}
program(s)?       {/* EMPTY */}
and               {/* EMPTY */}
has               {/* EMPTY */}
using             {/* EMPTY */}
use               {/* EMPTY */}
the               {/* EMPTY */}
to                {/* EMPTY */}
sum               {/* EMPTY */}
than              {/* EMPTY */}
usage             {/* EMPTY */}
was               {/* EMPTY */}
times             {/* EMPTY */}
but               {/* EMPTY */}
of                {/* EMPTY */}
or                {/* EMPTY */}
does              {/* EMPTY */}
per               {/* EMPTY */}
in                {/* EMPTY */}
last              {/* EMPTY */}
rate              {/* EMPTY */}
capacity          {/* EMPTY */}
option(s)?        {/* EMPTY */}
ssl[ \t]+disable  {/* EMPTY */}
disable[ \t]+ssl  {/* EMPTY */}

# 返回指定值 START 宏或 枚举值
# {startarg} '{}'表示引用， { BEGIN(ARGUMENT_COND); return START; } '{}' 表示处理过程。
# 先返回 START 标识， 再返回 STRING 标识。
{startarg}        { BEGIN(ARGUMENT_COND); return START; }      # start{ws}?(program)?{ws}?([=]{ws})?["]
{stoparg}         { BEGIN(ARGUMENT_COND); return STOP; }       # stop{ws}?(program)?{ws}?([=]{ws})?["]
{restartarg}      { BEGIN(ARGUMENT_COND); return RESTART; }    # restart{ws}?(program)?{ws}?([=]{ws})?["]
{execarg}         { BEGIN(ARGUMENT_COND); return EXEC; }       # exec{ws}?(program)?{ws}?([=]{ws})?["]

# path ["] 表示路径
{pathtokarg}      {                                            # path{ws}?["]
                        if (check_state == Program_State) {  # 如果是program, 则支持 start形式的配置，否则不支持
                                BEGIN(ARGUMENT_COND); // Parse Path for program as arguments
                                return PATHTOK;
                        } else {
                                unput('"'); # 回写字符c到输入流，并被下一个扫描进行匹配
                                return PATHTOK;
                        }
                  }

# 标识符
# 多个模式可以返回相同的标识符，和相同C类型表示    STRING标识符，即 关联的前驱和后继可以 确定字符串含义
# 多个模式可以返回不同的标识符，和相同C类型表示    MAIL相关      即 STRING标识的前后关系不能确定字符串含义
# 开始条件 总是先发返回匹配条件的标识符，然后返回匹配 开始条件后续的标识符 {startarg} {BEGIN(ARGUMENT_COND); start START}
# 开始条件 不总是需要返回标识符给p.y，可以进行内部的 函数进行处理。 include 
# 保留字只返回 标识符。
# 忽略字不返回任何信息
                  
# 如果一个单词的被另一个单词包含(从开头都是包含的)，这两个单词之间存在顺序关系吗? 
if                { return IF; }
then              { return THEN; }
failed            { return FAILED; }
tls               { return SSL; }
ssl               { return SSL; }
ssl[ \t]+enable   { return SSL; }
enable[ ]+ssl     { return SSL; }
enable            { return ENABLE; }
disable           { return DISABLE; }
verify            { return VERIFY; }
valid             { return VALID; }
certificate       { return CERTIFICATE; }
cacertificatefile { return CACERTIFICATEFILE; }
cacertificatepath { return CACERTIFICATEPATH; }
set               { return SET; }
daemon            { return DAEMON; }
delay             { return DELAY; }
terminal          { return TERMINAL; }
batch             { return BATCH; }
log               { return LOGFILE; }
logfile           { return LOGFILE; }
syslog            { return SYSLOG; }
facility          { return FACILITY; }
httpd             { return HTTPD; }
address           { return ADDRESS; }
interface         { return INTERFACE; }
link              { return LINK; }
packet(s)?("/s")? { return PACKET; }
bytein            { return BYTEIN; }
byteout           { return BYTEOUT; }
packetin          { return PACKETIN; }
packetout         { return PACKETOUT; }
upload(ed)?       { return UPLOAD; }
download(ed)?     { return DOWNLOAD; }
saturation        { return SATURATION; }
speed             { return SPEED; }
total             { return TOTAL; }
clientpemfile     { return CLIENTPEMFILE; }
allowselfcertification  { return ALLOWSELFCERTIFICATION; }
selfsigned        { return SELFSIGNED; }
certmd5           { return CERTMD5; }
pemfile           { return PEMFILE; }
init              { return INIT; }
allow             { return ALLOW; }
reject            { return REJECTOPT; }
read[-]?only      { return READONLY; }
disk              { return DISK; }
read              { return READ; }
write             { return WRITE; }
service[ ]?time   { return SERVICETIME; }
operation(s)?("/s")? { return OPERATION; }
pidfile           { return PIDFILE; }
idfile            { return IDFILE; }
statefile         { return STATEFILE; }
path              { return PATHTOK; }
start             { return START; }
stop              { return STOP; }
port(number)?     { return PORT; }
unix(socket)?     { return UNIXSOCKET; }
ipv4              { return IPV4; }
ipv6              { return IPV6; }
type              { return TYPE; }
proto(col)?       { return PROTOCOL; }
tcp               { return TCP; }
tcpssl            { return TCPSSL; }
udp               { return UDP; }
alert             { return ALERT; }
noalert           { return NOALERT; }
mail-format       { return MAILFORMAT; }
resource          { return RESOURCE; }
restart(s)?       { return RESTART; }
cycle(s)?         { return CYCLE;}
timeout           { return TIMEOUT; }
retry             { return RETRY; }
checksum          { return CHECKSUM; }
mailserver        { return MAILSERVER; }
host              { return HOST; }
hostheader        { return HOSTHEADER; }
method            { return METHOD; }
get               { return GET; }
head              { return HEAD; }
status            { return STATUS; }
default           { return DEFAULT; }
http              { return HTTP; }
https             { return HTTPS; }
apache-status     { return APACHESTATUS; }
ftp               { return FTP; }
smtp              { return SMTP; }
smtps             { return SMTPS; }
postfix-policy    { return POSTFIXPOLICY; }
pop               { return POP; }
pops              { return POPS; }
imap              { return IMAP; }
imaps             { return IMAPS; }
clamav            { return CLAMAV; }
dns               { return DNS; }
mysql             { return MYSQL; }
nntp              { return NNTP; }
ntp3              { return NTP3; }
ssh               { return SSH; }
redis             { return REDIS; }
mongodb           { return MONGODB; }
fail2ban          { return FAIL2BAN; }
sieve             { return SIEVE; }
spamassassin      { return SPAMASSASSIN; }
dwp               { return DWP; }
ldap2             { return LDAP2; }
ldap3             { return LDAP3; }
rdate             { return RDATE; }
lmtp              { return LMTP; }
rsync             { return RSYNC; }
tns               { return TNS; }
pgsql             { return PGSQL; }
websocket         { return WEBSOCKET; }
origin            { return ORIGIN; }
version           { return VERSIONOPT; }
sip               { return SIP; }
gps               { return GPS; }
radius            { return RADIUS; }
memcache          { return MEMCACHE; }
target            { return TARGET; }
maxforward        { return MAXFORWARD; }
mode              { return MODE; }
active            { return ACTIVE; }
passive           { return PASSIVE; }
manual            { return MANUAL; }
onreboot          { return ONREBOOT; }
nostart           { return NOSTART; }
laststate         { return LASTSTATE; }
uid               { return UID; }
euid              { return EUID; }
security          { return SECURITY; }
attribute(s)?     { return ATTRIBUTE; }
gid               { return GID; }
request           { return REQUEST; }
secret            { return SECRET; }
loglimit          { return LOGLIMIT; }
closelimit        { return CLOSELIMIT; }
dnslimit          { return DNSLIMIT; }
keepalivelimit    { return KEEPALIVELIMIT; }
replylimit        { return REPLYLIMIT; }
requestlimit      { return REQUESTLIMIT; }
startlimit        { return STARTLIMIT; }
waitlimit         { return WAITLIMIT; }
gracefullimit     { return GRACEFULLIMIT; }
cleanuplimit      { return CLEANUPLIMIT; }
mem(ory)?         { return MEMORY; }
swap              { return SWAP; }
total[ ]?mem(ory)? { return TOTALMEMORY; }
cpu               { return CPU; }
total[ ]?cpu      { return TOTALCPU; }
child(ren)?       { return CHILDREN; }
thread(s)?        { return THREADS; }
time(stamp)?      { return TIME; }
changed           { return CHANGED; }
sslv2             { return SSLV2; }
sslv3             { return SSLV3; }
tlsv1             { return TLSV1; }
tlsv11            { return TLSV11; }
tlsv12            { return TLSV12; }
tlsv13            { return TLSV13; }
cipher(s)?        { return CIPHER; }
auto              { return AUTO; }
sslauto           { return SSLAUTO; }
inode(s)?         { return INODE; }
space             { return SPACE; }
free              { return TFREE; }
perm(ission)?     { return PERMISSION; }
exec(ute)?        { return EXEC; }
size              { return SIZE; }
uptime            { return UPTIME; }
basedir           { return BASEDIR; }
slot(s)?          { return SLOT; }
eventqueue        { return EVENTQUEUE; }
match(ing)?       { return MATCH; }
not               { return NOT; }
ignore            { return IGNORE; }
connection        { return CONNECTION; }
unmonitor         { return UNMONITOR; }
action            { return ACTION; }
icmp              { return ICMP; }
ping              { return PING; }
ping4             { return PING4; }
ping6             { return PING6; }
echo              { return ICMPECHO; }
send              { return SEND; }
expect            { return EXPECT; }
expectbuffer      { return EXPECTBUFFER; }
limits            { return LIMITS; }
sendexpectbuffer  { return SENDEXPECTBUFFER; }
filecontentbuffer { return FILECONTENTBUFFER; }
httpcontentbuffer { return HTTPCONTENTBUFFER; }
programoutput     { return PROGRAMOUTPUT; }
networktimeout    { return NETWORKTIMEOUT; }
programtimeout    { return PROGRAMTIMEOUT; }
stoptimeout       { return STOPTIMEOUT; }
starttimeout      { return STARTTIMEOUT; }
restarttimeout    { return RESTARTTIMEOUT; }
cleartext         { return CLEARTEXT; }
md5               { return MD5HASH; }
sha1              { return SHA1HASH; }
crypt             { return CRYPT; }
signature         { return SIGNATURE; }
nonexist(s)?      { return NONEXIST; }
exist(s)?         { return EXIST; }
invalid           { return INVALID; }
data              { return DATA; }
recovered         { return RECOVERED; }
passed            { return PASSED; }
succeeded         { return SUCCEEDED; }
else              { return ELSE; }
mmonit            { return MMONIT; }
url               { return URL; }
content           { return CONTENT; }
pid               { return PID; }
ppid              { return PPID; }
count             { return COUNT; }
repeat            { return REPEAT; }
reminder          { return REMINDER; }
instance          { return INSTANCE; }
hostname          { return HOSTNAME; }
username          { return USERNAME; }
password          { return PASSWORD; }
credentials       { return CREDENTIALS; }
register          { return REGISTER; }
fsflag(s)?        { return FSFLAG; }
fips              { return FIPS; }
{byte}            { return BYTE; }
{kilobyte}        { return KILOBYTE; }
{megabyte}        { return MEGABYTE; }
{gigabyte}        { return GIGABYTE; }
{loadavg1}        { return LOADAVG1; }
{loadavg5}        { return LOADAVG5; }
{loadavg15}       { return LOADAVG15; }
{cpuuser}         { return CPUUSER; }
{cpusyst}         { return CPUSYSTEM; }
{cpuwait}         { return CPUWAIT; }
{greater}         { return GREATER; }
{greaterorequal}  { return GREATEROREQUAL; }
{less}            { return LESS; }
{lessorequal}     { return LESSOREQUAL; }
{equal}           { return EQUAL; }
{notequal}        { return NOTEQUAL; }
{millisecond}     { return MILLISECOND; }
{second}          { return SECOND; }
{minute}          { return MINUTE; }
{hour}            { return HOUR; }
{day}             { return DAY; }
{month}           { return MONTH; }
{atime}           { return ATIME; }
{ctime}           { return CTIME; }
{mtime}           { return MTIME; }

# 宏BEGIN切换起始状态，你通常在特定模式的动作代码里调用它，如下所示
# BEGIN statename;
# 词法分析器从0开始，该状态也被称为INITIAL，其他所有状态必须在定义部分通过%s或者%x行来命名。

#  起始状态可以要求某个token必须出现在另一个token之前，下面的second必定出现在first之后
#  %s MYSTATE
#  %%
#  first {BEGIN MYSTATE;}
#  ... 
#  second {BEGIN 0;}

# BEGIN一般分成两层。先返回整体匹配 标识(start头匹配返回的标识)，然后返回 开始条件中，开始部分的标识。
# include 处理比较特殊， 整体匹配部分没有返回标识， INCLUDE内部也没有返回值，而是调用了个处理函数
include           { BEGIN(INCLUDE); }

# 在规则-处理中也可以有，
not[ ]+every      {
                    BEGIN(EVERY_COND);
                    return NOTEVERY;
                  }

every             {
                    BEGIN(EVERY_COND);
                    return EVERY;
                  }

depend(s)?[ \t]+(on[ \t]*)? {
                    BEGIN(DEPEND_COND);
                    return DEPENDS;
                  }

check[ \t]+(process[ \t])? {
                    BEGIN(SERVICE_COND);
                    check_state = Proc_State;
                    return CHECKPROC;
                  }

check[ \t]+(program[ \t])? {
                    BEGIN(SERVICE_COND);
                    check_state = Program_State;
                    return CHECKPROGRAM;
                  }

check[ \t]+device { /* Filesystem alias for backward compatibility  */
                    BEGIN(SERVICE_COND);
                    check_state = FileSys_State;
                    return CHECKFILESYS;
                  }

check[ \t]+filesystem {
                    BEGIN(SERVICE_COND);
                    check_state = FileSys_State;
                    return CHECKFILESYS;
                  }

check[ \t]+file   {
                    BEGIN(SERVICE_COND);
                    check_state = File_State;
                    return CHECKFILE;
                  }

check[ \t]+directory {
                    BEGIN(SERVICE_COND);
                    check_state = Dir_State;
                    return CHECKDIR;
                  }

check[ \t]+host   {
                    BEGIN(SERVICE_COND);
                    check_state = Host_State;
                    return CHECKHOST;
                  }

check[ \t]+network {
                    BEGIN(SERVICE_COND);
                    check_state = Net_State;
                    return CHECKNET;
                  }

check[ \t]+fifo   {
                    BEGIN(SERVICE_COND);
                    check_state = Fifo_State;
                    return CHECKFIFO;
                  }

check[ \t]+program   {
                    BEGIN(SERVICE_COND);
                    check_state = Program_State;
                    return CHECKPROGRAM;
                  }

check[ \t]+system {
                    BEGIN(SERVICE_COND);
                    check_state = System_State;
                    return CHECKSYSTEM;
                  }

group[ \t]+       {
                    BEGIN(STRING_COND);
                    return GROUP;
                  
                  
#http headers [name:value, name:value,..]
"http headers"{ws} {
                        BEGIN(HTTP_HEADER_COND);
                        return '[';
                  }

# 匹配模式的文本存储在这一变量中(char*)。
[a-zA-Z0-9]+"://" {
                    yylval.url = create_URL(Str_ndup(yytext, strlen(yytext)-3)); # 匹配模式的文本存储在这一变量中（char*）。
                    BEGIN(URL_COND);
                  }
# 整数
{number}          {
                    yylval.number = atoi(yytext);
                    save_arg();
                    return NUMBER;
                  }
# 实数
{real}            {
                    yylval.real = atof(yytext);
                    save_arg();
                    return REAL;
                  }
# 百分比
{percent}         {
                    return PERCENT;
                  }
# 字符串 以字母和数字开头的字符串
[a-zA-Z0-9]{str}  {
                    yylval.string = Str_dup(yytext);
                    save_arg();
                    return STRING;
                  }
# 同下
\"[/][^\"\n]*\"   {
                    yylval.string = handle_quoted_string(yytext);
                    save_arg();
                    return PATH;
                  }
# 路径表示，很少用到
\'[/][^\'\n]*\'   {
                    yylval.string = handle_quoted_string(yytext);
                    save_arg();
                    return PATH;
                  }

# 形式不一样，但返回的标识一样，说明: 一个标识可以反应多种模式。
# 保留字 和 标识是一一对应关系。
# "string" 格式的，支持多行的字符串
\"[^\"]*\"        {
                    steplinenobycr(yytext);
                    yylval.string = handle_quoted_string(yytext);
                    save_arg();
                    return STRING;
                  }
# 'string' 格式的，支持多行的字符串
\'[^\']*\'        {
                    steplinenobycr(yytext);
                    yylval.string = handle_quoted_string(yytext);
                    save_arg();
                    return STRING;
                  }

# 有时候，即使都是字符串，通过不同标识， 表示模式不同。
{str}[@]{str}     {
                    yylval.string = Str_dup(yytext);
                    save_arg();
                    return MAILADDR;
                  }
# 绝对路径
[/]{str}          {
                     yylval.string = Str_dup(yytext);
                     save_arg();
                    return PATH;
                  }
# 根路径，唯一匹配(完全匹配)
"/"               {
                     yylval.string = Str_dup(yytext);
                     save_arg();
                    return PATH;
                  }
# from: 和 空格部分，后续内容由ADDRESS_COND处理
"from:"[ \t]* {
                      yylval.address = Address_new();
                      BEGIN(ADDRESS_COND);
                      return MAILFROM;
                  }
# reply-to: 和 空格部分，后续内容由ADDRESS_COND处理
"reply-to:"[ \t]* {
                      yylval.address = Address_new();
                      BEGIN(ADDRESS_COND);
                      return MAILREPLYTO;
                  }
# subject: 除'}'和'\n'外所有字符串，只能单行。
"subject:"[^}\n]* {
                      char *p = yytext+strlen("subject:");
                      yylval.string = Str_trim(Str_dup(p));
                      save_arg();
                      return MAILSUBJECT;
                  }
# message: 除'}'外所有字符串。可以多行。
"message:"[^}]*   {
                      char *p = yytext+strlen("message:");
                      steplinenobycr(yytext);
                      yylval.string = Str_trim(Str_dup(p)); # 复制, 去除头尾空白
                      save_arg();
                      return MAILBODY;
                  }
# {str}(\.{str})* 主机名
{hostname}        {
                      yylval.string = Str_dup(yytext);
                      save_arg();
                      return STRING;
                  }
# ipv4/masklength
{ipv4}[/]?[0-9]{0,2} {
                      yylval.string = Str_dup(yytext);
                      save_arg();
                      return STRING;
                  }
# ipv6/masklength
{ipv6}[/]?[0-9]{0,3} {
                      yylval.string = Str_dup(yytext);
                      save_arg();
                      return STRING;
                  }

# 全局上，关注 "unbalanced quotes"
[\"\']            {
                      yyerror("unbalanced quotes");
                  }

recursive(whitespace){
    service # 逗号分隔多实例；
    # 忽略空白 ;,()
    # 处理过程中关注 "unbalanced quotes"
}
                  
# check[ \t]+(process[ \t])?
<SERVICE_COND>{

  {ws}            ; # 空格

  [\n]            { # 换行
                    lineno++;
                  }

  {str}           {
                    yylval.string = Str_dup(yytext);
                    BEGIN(INITIAL);  # 总是在return之间设定
                    save_arg();
                    return SERVICENAME;
                  }

  \"{str}\"       {
                    yylval.string = handle_quoted_string(yytext);
                    BEGIN(INITIAL);
                    save_arg();
                    return SERVICENAME;
                  }

  \'{str}\'       {
                    yylval.string = handle_quoted_string(yytext);
                    BEGIN(INITIAL);
                    save_arg();
                    return SERVICENAME;
                  }

  [\"\']          { # 非平衡引用，为何在 'DEPEND_COND' 中不需要这个处理过程
                      yyerror("unbalanced quotes");
                  }

}

recursive(,){
   depends # 逗号分隔多实例；
   # 忽略空白 ;,()
   # 处理过程中忽略 [ \r\n\t]+[^,] 
}
# DEPENDS on service[, service [,...]]
# depends on oracle
# 在 p.y 中使用 递归来表示序列表。
<DEPEND_COND>{

  {wws}           ;               # 逗号',' 会在此处被忽略掉

  {wws}?[\n]{wws}? {
                    lineno++;     # 流方式处理，而不是行方式处理
                  }

  {str}           { # 裸字符串
                    yylval.string = Str_dup(yytext);
                    save_arg();
                    return SERVICENAME;
                  }

  \"{str}\"       { # "" 字符串
                    yylval.string = handle_quoted_string(yytext);
                    save_arg();
                    return SERVICENAME;
                  }

  \'{str}\'       { # '' 字符串
                    yylval.string = handle_quoted_string(yytext);
                    save_arg();
                    return SERVICENAME;
                  }

# unput(c)
# 将字符c送回到输入中。该字符将是下一个被扫描到的字符。
# 空白+不是逗号(一个) 该模式会"吃掉"一个字符。 而unput会把吃掉的字符返回yytext.
  [ \r\n\t]+[^,]  { # 剔除空白
                    steplinenobycr(yytext);          # 条件增加行累计
                    unput(yytext[strlen(yytext)-1]); # 将 某个非','字母 返回给yytext中， 退出depend
                    BEGIN(INITIAL);
                  }
}

# 可以将 ARGUMENT_COND 视作一个小型的 flex 规则库。
# <START | STOP | RESTART> [PROGRAM] = "program"
# stop = "/bin/bash -c 'kill -s SIGTERM `cat /var/run/process.pid`'"   # "" 之中部分
# 1. 在" " 中可以包含 ' ' 字符串。
# 2. startarg stoparg restartarg execarg以 "为匹配结束符。
# 3. 在' ' 中允许多行，
<ARGUMENT_COND>{

  {ws}            ;   # 空操作

  [\n]            {
                    lineno++; # 记录行号
                  }

  \"              {
                      BEGIN(INITIAL); # 结束，转到匹配的开始位置
                  }

  \'[^\']*\'      {
                      steplinenobycr(yytext); # 增加lineno
                      yylval.string = handle_quoted_string(yytext);  # yytext 是匹配 '[^\']*' 的字符串
                      save_arg();
                      return STRING;
                  }

  \'              {
                      yyerror("unbalanced quotes");  # 单个"'" 是不合法的
                  }

  [^ \t\n\"]+     {
                      yylval.string = Str_dup(yytext);  # yytext 是匹配 [^ \t\n\"]+ 的字符串
                      save_arg();
                      return STRING;
                  }
}

# 
<URL_COND>{

  {ws}|[\n]       {
                      BEGIN(INITIAL);
                      if (! yylval.url->hostname)
                                yyerror("missing hostname in URL");
                      if (! yylval.url->path)
                                yylval.url->path = Str_dup("/");
                      yylval.url->url = Str_cat("%s://[%s]:%d%s%s%s",
                                yylval.url->protocol,
                                /* possible credentials are hidden */
                                yylval.url->hostname,
                                yylval.url->port,
                                yylval.url->path,
                                yylval.url->query ? "?" : "",
                                yylval.url->query ? yylval.url->query : "");
                      save_arg();
                      return URLOBJECT;
                  }

  [^:@ ]+/[:][^@: ]+[@] {
                      yylval.url->user = Str_dup(yytext);
                  }

  [:][^@ ]+[@]    {
                      yytext++;
                      yylval.url->password = Str_ndup(yytext, strlen(yytext)-1);
                  }

  ([a-zA-Z0-9\-]+)([.]([a-zA-Z0-9\-]+))* {
                      yylval.url->hostname = Str_dup(yytext);
                  }

  \[[0-9a-zA-Z.:%]+\] {
                      yylval.url->hostname = Str_ndup(yytext + 1, yyleng - 2); # 给出匹配模式的长度。
                      yylval.url->ipv6 = true;
                  }

  [:]{number}     {
                      yylval.url->port = atoi(++yytext);
                  }

  [/][^?#\r\n ]*  {
                      yylval.url->path = Util_urlEncode(yytext, false);
                  }

  [?][^#\r\n ]*   {
                      yylval.url->query = Util_urlEncode(++yytext, false);
                  }

  [#][^\r\n ]*    {
                      /* EMPTY - reference is ignored */
                  }

}

# reply-to: support@domain.com
# RTU253 <monit@nidey.com>
# name   <address>

# from: Monit Support <monit@foo.bar>
# name                <address>
<ADDRESS_COND>{ # 地址
# yymore告诉我们扫描器下次会匹配一个规则，(该规则)相应的行为应该是附属到了当前yytext
# 的值中，而不是取代它(译注：指当前yytext的值)。

# yyless(n)返回输入流中当前标识符(token)中除去前面n个字符的所有字符，当扫描器寻
# 找下一个匹配时，这些字符将会被再次扫描。yytext以及yyleng会适当的做一些调整(比如
# ，yyleng会和n相等)

# yymore()是将本次匹配的所有字符放置到下次匹配成功yytext的开头。 1. 本次匹配的放置到下次匹配的，2. 下次匹配不依赖本次已匹配的
# yyless(n)是将本次匹配的截去header(n)之后的剩余部分放置到未匹配的yytext头部。1， 本次匹配的部分放置，2， 下次匹配依赖本次截取后剩余尾部
   [}\n]        {
                        if (yytext[0] == '}')
                                yyless(0);
                        BEGIN(INITIAL); # 结束位置
                        if (! yylval.address->address)
                                yyerror("missing address");
                        save_arg();
                        return ADDRESSOBJECT;
                }
                  # "monit@$HOST"
  {address}     { # [^\000-\041<>{}\[\]]+         # 地址，不包含<>{}[]
                        yylval.address->address = Str_dup(yytext);
                }
                  # 不清楚
  {addrname}    { # [^\000-\037@<>{}\[\]]+        # 地址名，不包含@<>{}[]
                        char *name = Str_unquote(Str_dup(yytext));
                        if (name && *name)
                                yylval.address->name = Str_unquote(Str_dup(yytext));
                }

  [<>:\[\]]     {
                        // Ignore
                }
# 包含任意都会出错
  .             { # '.' 不包括换行
                        BEGIN(INITIAL); # 结束位置
                        yyerror("invalid mail format");
                }
}

<STRING_COND>{ # 字符串, 用在group

  {str}           {
                    yylval.string = Str_dup(yytext);
                    BEGIN(INITIAL);
                    save_arg();
                    return STRINGNAME;
                  }

  \"{str}\"       {
                    yylval.string = handle_quoted_string(yytext);
                    BEGIN(INITIAL);
                    save_arg();
                    return STRINGNAME;
                  }

  \'{str}\'       {
                    yylval.string = handle_quoted_string(yytext);
                    BEGIN(INITIAL);
                    save_arg();
                    return STRINGNAME;
                  }

  [\"\']          {
                      yyerror("unbalanced quotes");
                  }

}

# every 条件
# EVERY [number] CYCLES
# EVERY [cron]
# NOT EVERY [cron]
<EVERY_COND>{

  {ws}            ;

  {number}        {
                    yylval.number = atoi(yytext);
                    BEGIN(INITIAL);
                    save_arg();
                    return NUMBER; # every 2 cycles
                  }

  ['"]{ws}?[0-9,*-]+{ws}[0-9,*-]+{ws}[0-9,*-]+{ws}[0-9,*-]+{ws}[0-9,*-]+{ws}?['"] { // A minimal syntax check of the cron format string; 5 fields separated with white-space
                    yylval.string = Str_dup(Str_unquote(yytext));
                    BEGIN(INITIAL);
                    save_arg();
                    return TIMESPEC; # every "* 8-19 * * 1-5"
                  }

  .               { # '.' 不包括换行
                      BEGIN(INITIAL);
                      yyerror("invalid every format");
                  }

}

# http headers [name:value, name:value,..] , 在bison中，确定 name:value的循环
<HTTP_HEADER_COND>{

        {wws}   ; # 定义对全部或部分正则表达式进行命名，并通过名字引用他们{NAME}

        "["     ;

        [\n]    {
                        lineno++;
                }
# |/ | 向前匹配。如果在匹配的模版中的"/"后跟有后续表达式，只匹配模版中"/"前 面的部分。如：如果输入 A01，那么在模版 A0/1 中的 A0 是匹配的
        ([^\t\r\n,\[\]:]+)/[:] { // name/:
                        save_arg();
                }

        [:](({ws}?["][^"]+["])|({ws}?['][^']+['])|([^\r\n\],:]+)) { // : value
                        yylval.string = Str_cat("%s:%s", Str_trim(argyytext), Str_unquote(yytext + 1));
                        save_arg();
                        return HTTPHEADER; # 解析出数据，告知bison， 具有return的一般都存在多实例
                }

        "]"     {
                        BEGIN(INITIAL); # INITIAL： 默认起始状态
                        save_arg();
                        return ']';
                }

        .       { # '.' 不包括换行
                        BEGIN(INITIAL);
                        yyerror("invalid HTTP header list format");
                }

}

# <> 位于模式开头的尖括号内的一个或者一列名字，使那个模式只应用于指定的起始状态。
# 只有在当前起始状态为INITIAL,STRING或QUOTE之一时才会启动。
<INITIAL,ARGUMENT_COND,SERVICE_COND,DEPEND_COND,URL_COND,ADDRESS_COND,STRING_COND,EVERY_COND,HTTP_HEADER_COND>. {
                      check_state = None_State;
                      return yytext[0]; # return语句来返回一个由某函数调用yylex()后所返回的值
                  }  # 如果行为包含一个'{'字符，那么在遇到匹配的'}'之前，该行为就跨越这段空间，从而这个行为可能会跨越多行。

#     起始状态在输入文件的定义部分说明，在无缩进行中，以'%s'或者'%x'开头，后面跟着一列名字。
# 前者(指'%s')声明了包含了容他性起始状态(inclusive start condition)，后者(声明)排他性起始状态(exclusive start condition)。
# 一个起始状态用BEGIN动作来启动。给定起始状态的规则会被激活，并且有其它起始状态的规则不会激活，直到下一个BEGIN行为执行。
# 如果起始状态为容他的，则全然没有起始状态的规则也会被激活。如果(性质)为排他性，则只有被标识为起始状态的规则会被激活。
# 一系列依赖于同一个exclusive性质的start condition的规则描述了一个扫描器，它独立于flex输入文件中的任何东西。基于此，
# 排他性的起始条件使得(我们)很容易指定一个"迷你扫描器"，它可以分割输入(数据)，进而使得(这些数据)跟输入的其它部分在语法上
# 保持不同。
<INCLUDE>[ \t]*      /* eat the whitespace */

# |+              | 匹配 1个或者多个上述模式
# |\              | 用来转义元字符。同样用来覆盖字符在此表中定义的特殊意义，只取字符的本意。
<INCLUDE>\"[^\"\r\n]+\" { /* got the include file name with double quotes */
                     char *temp = Str_dup(yytext);
                     Str_unquote(temp);
                     include_file(temp);
                     FREE(temp);
                     BEGIN(INITIAL); # INITIAL： 默认起始状态
                   }                 # BEGIN： 切换到指定的初始状态

<INCLUDE>\'[^\'\r\n]+\' { /* got the include file name with single quotes*/
                     char *temp = Str_dup(yytext);
                     Str_unquote(temp);
                     include_file(temp);
                     FREE(temp);
                     BEGIN(INITIAL);
                   }
# <> 位于模式开头的尖括号内的一个或者一列名字，使那个模式只应用于指定的起始状态。
<INCLUDE>[^ \t\r\n]+ { /* got the include file name without quotes*/
                     char *temp = Str_dup(yytext);
                     include_file(temp);
                     FREE(temp);
                     BEGIN(INITIAL);
                   }

# | EOF           | 只用于flex中，这个特殊模式匹配文件的结尾。
<<EOF>>           {

                       BEGIN(INITIAL);
                       check_state = None_State;
                       if (! pop_buffer_state())
                                yyterminate();  # 结束
                  }
# 规则段 结束
%%

# 用户子例程序段
/*
 * Do lineno++ for every occurrence of '\n' in a string.  This is
 * necessary whenever a yytext has an unknown number of CRs.
 */

static void steplinenobycr(char *string) {

        char *pos = string;

        while (*pos)
        if ('\n' == *pos++) {
                lineno++;
        }

}


static char *handle_quoted_string(char *string) {
        char *buf = Str_dup(string);
        Str_unquote(buf);
        Util_handleEscapes(buf);
        return buf;
}


static void _include(const char *path) {
        if (Str_cmp(Run.files.control, path) == 0) {
                yywarning("Include loop detected when trying to include %s", path);
                return;
        }
        for (int i = 0; i < buffer_stack_ptr; i++) {
                if (Str_cmp(buffer_stack[i].currentfile, path) == 0) {
                        yywarning("Include loop detected when trying to include %s", path);
                        return;
                }
        }
        FILE *_yyin = fopen(path, "r");
        if (! _yyin)
                yyerror("Cannot include file '%s' -- %s", path, STRERROR);
        else
                push_buffer_state(yy_create_buffer(_yyin, YY_BUF_SIZE), (char *)path);
}


static void include_file(char *pattern) {
        glob_t globbuf;
        errno = 0;
        if (glob(pattern, GLOB_MARK, NULL, &globbuf) == 0) {
                for (int i = 0; i < globbuf.gl_pathc; i++) {
                        size_t filename_length = strlen(globbuf.gl_pathv[i]);
                        if ((filename_length == 0) || (globbuf.gl_pathv[i][filename_length - 1] == '~' ) || (globbuf.gl_pathv[i][filename_length - 1] == '/'))
                                continue; // skip subdirectories and file backup copies
                        _include(globbuf.gl_pathv[i]);
                }
                globfree(&globbuf);
        } else if (errno != 0) {
                yywarning("Include failed -- %s", STRERROR);
        } // else no include files found -- silently ignore
}

/*
# 它带一个函数指针参数以及一个指定文件的缓冲区大小的整数，该整数足够容纳size个字节(如果尚存疑虑，
就是用YY_BUF_SIZE作为size值)。该函数返回一个YY_BUFFER_STATE句柄(handle)，接下来该句柄会被传递给
其他函数(见下文)。YY_BUFFER_STATE是一个指向晦涩结构体yy_buffer_state的指针，所以，愿意的话，
你可以安全的用((YY_BUFFER_STATE)0)来初始化YY_BUFFER_STATE类型的变量，并且还可以将它refer to那
个晦涩的结构体，以将源文件中的输入缓冲区正确地声明，而不仅仅是存在于你的扫描器中。

注意，yy_create_buffer 调用中的FILE指针只能用于被YY_INPUT所见的yyin的值。如果你重定义了YY_INPUT()，
那么YY_INPUT()就不会再使用yyin,然后你就可以安全的传递一个空文件指针给yy_create_buffer。你可以选择
扫描一个特定的缓冲区，使用：
YY_BUFFER_STATE yy_create_buffer ( FILE *file, int size ) # YY_BUFFER_STATE:词法分析器读取输入的结构，通过yy_create_buffer创建

# 上面的函数会选择扫描器的输入，所以接下来的标识符就来自new_buffer中。注意，yy_switch_to_buffer()可以可以为yywrap()所用，
以此来为继续扫描做相关设置，而不用打开一个新文件并将yyin指向该文件。如果你正查找一个输入缓冲区栈，那么你将要使用
yypush_buffer_state()来代替本函数。同时要注意的是，通过yy_switch_to_buffer()或yywrap()来选择输入源并不会改变起始状态。
void yy_switch_to_buffer ( YY_BUFFER_STATE new_buffer )   # yy_switch_to_buffer:切换缓冲区结构

# 该函数用于改造一个缓冲区中的存储。(缓冲区可以为NULL，此事函数啥也不错)你也可以使用下面的函数来清除当前缓冲区中的内容：
void yy_delete_buffer ( YY_BUFFER_STATE buffer )          # yy_delete_buffer：释放缓冲区

# 该函数将一个新的缓冲区压栈到一个内部栈中。被压栈状态成为新的当前状态。该栈由flex管理，并按需做相应增长。
该函数的目的是代替yy_switch_to_buffer()函数，当你希望改变状态，但又要保存当前状态，以供后续使用时，可以使用
void yypush_buffer_state ( YY_BUFFER_STATE buffer )

# 该函数把当前状态从栈顶移除，并通过调用yy_delete_buffer来删除当前状态。栈中的下一个状态，如果有的话，则成为新的当前状态。
void yypop_buffer_state ()

# 该函数丢弃buffer中的内容，所以，当下一次扫描器试图为该buffer匹配一个标识符时，扫描器将首先用YY_INPUT()来填充这个buffer。
void yy_flush_buffer ( YY_BUFFER_STATE buffer             # yy_flush_buffer：放弃缓冲区中的内容，可以在交互式词法分析器中做错误恢复
YY_BUFFER_STATE yy_scan_string ( const char *str )
YY_BUFFER_STATE yy_scan_bytes ( const char *bytes, int len )
YY_BUFFER_STATE yy_scan_buffer (char *base, yy_size_t size)
*/
static void push_buffer_state(YY_BUFFER_STATE buffer, char *filename) {
        if (buffer_stack_ptr >= MAX_STACK_DEPTH) {
                yyerror("include files limit reached");
                exit( 1 );
        }

        buffer_stack[buffer_stack_ptr].lineno = lineno;
        buffer_stack[buffer_stack_ptr].currentfile = currentfile;
        buffer_stack[buffer_stack_ptr].buffer = YY_CURRENT_BUFFER; 
        // YY_CURRENT_BUFFER宏返回一个YY_BUFFER_STATE句柄给当前状态，它不能作为左值来使用。

        buffer_stack_ptr++;

        lineno = 1;
        currentfile = Str_dup(filename);

        yy_switch_to_buffer(buffer);

        BEGIN(INITIAL);

}


static int pop_buffer_state(void) {

        if ( --buffer_stack_ptr < 0 ) {

                return 0;

        } else {

                fclose(yyin); # FILE* 类型。 它指向 lexer 正在解析的当前文件。
                lineno = buffer_stack[buffer_stack_ptr].lineno;

                FREE(currentfile);
                currentfile = buffer_stack[buffer_stack_ptr].currentfile;

                yy_delete_buffer(YY_CURRENT_BUFFER);
                yy_switch_to_buffer(buffer_stack[buffer_stack_ptr].buffer);

        }

        return 1;

}


static void save_arg(void) {
        arglineno = lineno;             # 当前行
        argcurrentfile = currentfile;   # 当前文件名
        FREE(argyytext);                # 
        argyytext = Str_dup(yytext);    # 当前match字符串
}

# l.l 用于实现 多个配置文件的管理和返回模式匹配值(或模式匹配值和值对应的数据对象)，所有，l.l中的函数也
# 主要实现这两方面的功能。而save_arg这提供除此之外的调试信息。
static URL_T create_URL(char *proto) {
        URL_T url;
        ASSERT(proto);
        NEW(url);
        url->protocol = proto;
        if (IS(url->protocol, "https")) {
                url->port = 443;
#ifndef HAVE_OPENSSL
                yyerror("HTTPS protocol not supported -- SSL support disabled" );
#endif
        } else if (IS(url->protocol, "http")) {
                url->port = 80;
        } else {
                yyerror("URL protocol not supported -- ");
        }
        return url;
}

