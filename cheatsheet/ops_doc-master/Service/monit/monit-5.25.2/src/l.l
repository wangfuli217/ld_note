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


%option noyywrap


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
#define YY_NO_INPUT

#define MAX_STACK_DEPTH 512

int buffer_stack_ptr = 0;

struct buffer_stack_s {
        int             lineno;
        char           *currentfile;
        YY_BUFFER_STATE buffer;
} buffer_stack[MAX_STACK_DEPTH];

int lineno = 1;
int arglineno = 1;
char *currentfile = NULL;
char *argcurrentfile = NULL;
char *argyytext = NULL;
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
extern void yyerror(const char *,...);
extern void yyerror2(const char *,...);
extern void yywarning(const char *,...);
extern void yywarning2(const char *,...);
static void steplinenobycr(char *);
static void save_arg(void);
static void include_file(char *);
static char *handle_quoted_string(char *);
static void push_buffer_state(YY_BUFFER_STATE, char*);
static int  pop_buffer_state(void);
static URL_T create_URL(char *proto);

%}

ws             [ \r\t]+
wws            [ \r\t;,()]+
number         [0-9]+
real           [0-9]+([.][0-9]+)?
str            [^\000-\041@:{}"';(),%]+
address        [^\000-\041<>{}\[\]]+
addrname       [^\000-\037@<>{}\[\]]+
hostname       {str}(\.{str})*
dec-octet      [0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]
h16            [0-9A-Fa-f]{1,4}
ipv4           {dec-octet}\.{dec-octet}\.{dec-octet}\.{dec-octet}
ls32           {h16}:{h16}|{ipv4}
ipv6           ({h16}:){6}{ls32}|::({h16}:){5}{ls32}|({h16})?::({h16}:){4}{ls32}|(({h16}:){0,1}{h16})?::({h16}:){3}{ls32}|(({h16}:){0,2}{h16})?::({h16}:){2}{ls32}|(({h16}:){0,3}{h16})?::{h16}:{ls32}|(({h16}:){0,4}{h16})?::{ls32}|(({h16}:){0,5}{h16})?::{h16}|(({h16}:){0,6}{h16})?::
greater        ("more"|"greater"|"gt"|">"|"older")
greaterorequal ("ge"|">=")
less           ("less"|"lt"|"<"|"newer")
lessorequal    ("le"|"<=")
equal          ("equal"|"eq"|"=="|"=")
notequal       ("notequal"|"ne"|"!=")
loadavg1       load(avg)[ ]*(\([ ]*1[ ]*(m|min)?[ ]*\))?
loadavg5       load(avg)[ ]*\([ ]*5[ ]*(m|min)?[ ]*\)
loadavg15      load(avg)[ ]*\([ ]*15[ ]*(m|min)?[ ]*\)
cpuuser        cpu[ ]*(usage)*[ ]*\([ ]*(us|usr|user)?[ ]*\)
cpusyst        cpu[ ]*(usage)*[ ]*\([ ]*(sy|sys|system)?[ ]*\)
cpuwait        cpu[ ]*(usage)*[ ]*\([ ]*(wa|wait)?[ ]*\)
startarg       start{ws}?(program)?{ws}?([=]{ws})?["]
stoparg        stop{ws}?(program)?{ws}?([=]{ws})?["]
restartarg     restart{ws}?(program)?{ws}?([=]{ws})?["]
execarg        exec(ute)?{ws}?["]
pathtokarg     path{ws}?["]
percent        ("percent"|"%")
byte           ("byte"|"bytes"|"b")("/s")?
kilobyte       ("kilobyte"|"kilobytes"|"kb")("/s")?
megabyte       ("megabyte"|"megabytes"|"mb")("/s")?
gigabyte       ("gigabyte"|"gigabytes"|"gb")("/s")?
millisecond    ("millisecond"|"milliseconds"|"ms")
second         ("second"|"seconds"|"s")
minute         ("minute"|"minutes"|"m")
hour           ("hour"|"hours"|"h")
day            ("day"|"days")
month          ("month"|"months")
atime          ("atime"|"access time"|"access timestamp")
ctime          ("ctime"|"change time"|"change timestamp")
mtime          ("mtime"|"modification time"|"modification timestamp"|"modify time"|"modify timestamp")

%x ARGUMENT_COND DEPEND_COND SERVICE_COND URL_COND ADDRESS_COND STRING_COND EVERY_COND HTTP_HEADER_COND INCLUDE

%%

{wws}             { /* Wide white space */ }
(#.*)?\\?\n?      { lineno++; }

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

{startarg}        { BEGIN(ARGUMENT_COND); return START; }
{stoparg}         { BEGIN(ARGUMENT_COND); return STOP; }
{restartarg}      { BEGIN(ARGUMENT_COND); return RESTART; }
{execarg}         { BEGIN(ARGUMENT_COND); return EXEC; }
{pathtokarg}      {
                        if (check_state == Program_State) {
                                BEGIN(ARGUMENT_COND); // Parse Path for program as arguments
                                return PATHTOK;
                        } else {
                                unput('"');
                                return PATHTOK;
                        }
                  }

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

include           { BEGIN(INCLUDE); }

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
                  }

"http headers"{ws} {
                        BEGIN(HTTP_HEADER_COND);
                        return '[';
                  }

[a-zA-Z0-9]+"://" {
                    yylval.url = create_URL(Str_ndup(yytext, strlen(yytext)-3));
                    BEGIN(URL_COND);
                  }

{number}          {
                    yylval.number = atoi(yytext);
                    save_arg();
                    return NUMBER;
                  }

{real}            {
                    yylval.real = atof(yytext);
                    save_arg();
                    return REAL;
                  }

{percent}         {
                    return PERCENT;
                  }

[a-zA-Z0-9]{str}  {
                    yylval.string = Str_dup(yytext);
                    save_arg();
                    return STRING;
                  }

\"[/][^\"\n]*\"   {
                    yylval.string = handle_quoted_string(yytext);
                    save_arg();
                    return PATH;
                  }

\'[/][^\'\n]*\'   {
                    yylval.string = handle_quoted_string(yytext);
                    save_arg();
                    return PATH;
                  }

\"[^\"]*\"        {
                    steplinenobycr(yytext);
                    yylval.string = handle_quoted_string(yytext);
                    save_arg();
                    return STRING;
                  }

\'[^\']*\'        {
                    steplinenobycr(yytext);
                    yylval.string = handle_quoted_string(yytext);
                    save_arg();
                    return STRING;
                  }

{str}[@]{str}     {
                    yylval.string = Str_dup(yytext);
                    save_arg();
                    return MAILADDR;
                  }

[/]{str}          {
                     yylval.string = Str_dup(yytext);
                     save_arg();
                    return PATH;
                  }

"/"               {
                     yylval.string = Str_dup(yytext);
                     save_arg();
                    return PATH;
                  }

"from:"[ \t]* {
                      yylval.address = Address_new();
                      BEGIN(ADDRESS_COND);
                      return MAILFROM;
                  }

"reply-to:"[ \t]* {
                      yylval.address = Address_new();
                      BEGIN(ADDRESS_COND);
                      return MAILREPLYTO;
                  }

"subject:"[^}\n]* {
                      char *p = yytext+strlen("subject:");
                      yylval.string = Str_trim(Str_dup(p));
                      save_arg();
                      return MAILSUBJECT;
                  }

"message:"[^}]*   {
                      char *p = yytext+strlen("message:");
                      steplinenobycr(yytext);
                      yylval.string = Str_trim(Str_dup(p));
                      save_arg();
                      return MAILBODY;
                  }

{hostname}        {
                      yylval.string = Str_dup(yytext);
                      save_arg();
                      return STRING;
                  }

{ipv4}[/]?[0-9]{0,2} {
                      yylval.string = Str_dup(yytext);
                      save_arg();
                      return STRING;
                  }

{ipv6}[/]?[0-9]{0,3} {
                      yylval.string = Str_dup(yytext);
                      save_arg();
                      return STRING;
                  }

[\"\']            {
                      yyerror("unbalanced quotes");
                  }

<SERVICE_COND>{

  {ws}            ;

  [\n]            {
                    lineno++;
                  }

  {str}           {
                    yylval.string = Str_dup(yytext);
                    BEGIN(INITIAL);
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

  [\"\']          {
                      yyerror("unbalanced quotes");
                  }

}

<DEPEND_COND>{

  {wws}           ;

  {wws}?[\n]{wws}? {
                    lineno++;
                  }

  {str}           {
                    yylval.string = Str_dup(yytext);
                    save_arg();
                    return SERVICENAME;
                  }

  \"{str}\"       {
                    yylval.string = handle_quoted_string(yytext);
                    save_arg();
                    return SERVICENAME;
                  }

  \'{str}\'       {
                    yylval.string = handle_quoted_string(yytext);
                    save_arg();
                    return SERVICENAME;
                  }

  [ \r\n\t]+[^,]  {
                    steplinenobycr(yytext);
                    unput(yytext[strlen(yytext)-1]);
                    BEGIN(INITIAL);
                  }

}

<ARGUMENT_COND>{

  {ws}            ;

  [\n]            {
                    lineno++;
                  }

  \"              {
                      BEGIN(INITIAL);
                  }

  \'[^\']*\'      {
                      steplinenobycr(yytext);
                      yylval.string = handle_quoted_string(yytext);
                      save_arg();
                      return STRING;
                  }

  \'              {
                      yyerror("unbalanced quotes");
                  }

  [^ \t\n\"]+     {
                      yylval.string = Str_dup(yytext);
                      save_arg();
                      return STRING;
                  }

}

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
                      yylval.url->hostname = Str_ndup(yytext + 1, yyleng - 2);
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

<ADDRESS_COND>{

   [}\n]        {
                        if (yytext[0] == '}')
                                yyless(0);
                        BEGIN(INITIAL);
                        if (! yylval.address->address)
                                yyerror("missing address");
                        save_arg();
                        return ADDRESSOBJECT;
                }

  {address}     {
                        yylval.address->address = Str_dup(yytext);
                }

  {addrname}    {
                        char *name = Str_unquote(Str_dup(yytext));
                        if (name && *name)
                                yylval.address->name = Str_unquote(Str_dup(yytext));
                }

  [<>:\[\]]     {
                        // Ignore
                }

  .             {
                        BEGIN(INITIAL);
                        yyerror("invalid mail format");
                }
}

<STRING_COND>{

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

<EVERY_COND>{

  {ws}            ;

  {number}        {
                    yylval.number = atoi(yytext);
                    BEGIN(INITIAL);
                    save_arg();
                    return NUMBER;
                  }

  ['"]{ws}?[0-9,*-]+{ws}[0-9,*-]+{ws}[0-9,*-]+{ws}[0-9,*-]+{ws}[0-9,*-]+{ws}?['"] { // A minimal syntax check of the cron format string; 5 fields separated with white-space
                    yylval.string = Str_dup(Str_unquote(yytext));
                    BEGIN(INITIAL);
                    save_arg();
                    return TIMESPEC;
                  }

  .               {
                      BEGIN(INITIAL);
                      yyerror("invalid every format");
                  }

}

<HTTP_HEADER_COND>{

        {wws}   ;

        "["     ;

        [\n]    {
                        lineno++;
                }

        ([^\t\r\n,\[\]:]+)/[:] { // name/:
                        save_arg();
                }

        [:](({ws}?["][^"]+["])|({ws}?['][^']+['])|([^\r\n\],:]+)) { // : value
                        yylval.string = Str_cat("%s:%s", Str_trim(argyytext), Str_unquote(yytext + 1));
                        save_arg();
                        return HTTPHEADER;
                }

        "]"     {
                        BEGIN(INITIAL);
                        save_arg();
                        return ']';
                }

        .       {
                        BEGIN(INITIAL);
                        yyerror("invalid HTTP header list format");
                }

}


<INITIAL,ARGUMENT_COND,SERVICE_COND,DEPEND_COND,URL_COND,ADDRESS_COND,STRING_COND,EVERY_COND,HTTP_HEADER_COND>. {
                      check_state = None_State;
                      return yytext[0];
                  }


<INCLUDE>[ \t]*      /* eat the whitespace */

<INCLUDE>\"[^\"\r\n]+\" { /* got the include file name with double quotes */
                     char *temp = Str_dup(yytext);
                     Str_unquote(temp);
                     include_file(temp);
                     FREE(temp);
                     BEGIN(INITIAL);
                   }

<INCLUDE>\'[^\'\r\n]+\' { /* got the include file name with single quotes*/
                     char *temp = Str_dup(yytext);
                     Str_unquote(temp);
                     include_file(temp);
                     FREE(temp);
                     BEGIN(INITIAL);
                   }

<INCLUDE>[^ \t\r\n]+ { /* got the include file name without quotes*/
                     char *temp = Str_dup(yytext);
                     include_file(temp);
                     FREE(temp);
                     BEGIN(INITIAL);
                   }


<<EOF>>           {

                       BEGIN(INITIAL);
                       check_state = None_State;
                       if (! pop_buffer_state())
                                yyterminate();
                  }

%%

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


static void push_buffer_state(YY_BUFFER_STATE buffer, char *filename) {
        if (buffer_stack_ptr >= MAX_STACK_DEPTH) {
                yyerror("include files limit reached");
                exit( 1 );
        }

        buffer_stack[buffer_stack_ptr].lineno = lineno;
        buffer_stack[buffer_stack_ptr].currentfile = currentfile;
        buffer_stack[buffer_stack_ptr].buffer = YY_CURRENT_BUFFER;

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

                fclose(yyin);
                lineno = buffer_stack[buffer_stack_ptr].lineno;

                FREE(currentfile);
                currentfile = buffer_stack[buffer_stack_ptr].currentfile;

                yy_delete_buffer(YY_CURRENT_BUFFER);
                yy_switch_to_buffer(buffer_stack[buffer_stack_ptr].buffer);

        }

        return 1;

}


static void save_arg(void) {
        arglineno = lineno;
        argcurrentfile = currentfile;
        FREE(argyytext);
        argyytext = Str_dup(yytext);
}


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

