linux curl是一个利用URL规则在命令行下工作的文件传输工具。
它支持文件的上传和下载，所以是综合传输工具，但按传统，习惯称url为下载工具。
curl(命令参数){
1. curl命令参数，有好多我没有用过，也不知道翻译的对不对，如果有误的地方，还请指正。
-a/--append 上传文件时，附加到目标文件  
 -A/--user-agent <string>  设置用户代理发送给伺服器  
 - anyauth   可以使用「任何」身份验证方法  
 -b/--cookie <name=string/file> cookie字串或文件读取位置  
 - basic 使用HTTP基本验证  
 -B/--use-ascii 使用ASCII /文本传输  
 -c/--cookie-jar <file> 操作结束后把cookie写入到这个文件中  
 -C/--continue-at <offset>  断点续转  
 -d/--data <data>   HTTP POST方式传送数据  
 --data-ascii <data>  以ascii的方式post数据  
 --data-binary <data> 以二进位的方式post数据  
 --negotiate     使用HTTP身份验证  
 --digest        使用数字身份验证  
 --disable-eprt  禁止使用EPRT或LPRT  
 --disable-epsv  禁止使用EPSV  
 -D/--dump-header <file> 把header资讯写入到该文件中  
 --egd-file <file> 为随机数据(SSL)设置EGD socket路径  
 --tcp-nodelay   使用TCP_NODELAY选项  
 -e/--referer 来源网址  
 -E/--cert <cert[:passwd]> 用户端证书文件和密码 (SSL)  
 --cert-type <type> 证书文件类型 (DER/PEM/ENG) (SSL)  
 --key <key>     私钥文件名 (SSL)  
 --key-type <type> 私钥文件类型 (DER/PEM/ENG) (SSL)  
 --pass  <pass>  私钥密码 (SSL)  
 --engine <eng>  加密引擎使用 (SSL). "--engine list" for list  
 --cacert <file> CA证书 (SSL)  
 --capath <directory> CA目录 (made using c_rehash) to verify peer against (SSL)  
 --ciphers <list>  SSL密码  
 --compressed    要求返回是压缩的形势 (using deflate or gzip)  
 --connect-timeout <seconds> 设置最大请求时间  
 --create-dirs   建立本地目录的目录层次结构  
 --crlf          上传是把LF转变成CRLF  
 -f/--fail          连接失败时不显示http错误  
 --ftp-create-dirs 如果远端目录不存在，创建远端目录  
 --ftp-method [multicwd/nocwd/singlecwd] 控制CWD的使用  
 --ftp-pasv      使用 PASV/EPSV 代替连接埠  
 --ftp-skip-pasv-ip 使用PASV的时候,忽略该IP地址  
 --ftp-ssl       尝试用 SSL/TLS 来进行ftp数据传输  
 --ftp-ssl-reqd  要求用 SSL/TLS 来进行ftp数据传输  
 -F/--form <name=content> 模拟http表单提交数据  
 -form-string <name=string> 模拟http表单提交数据  
 -g/--globoff 禁用网址序列和范围使用{}和[]  
 -G/--get 以get的方式来发送数据  
 -h/--help 帮助  
 -H/--header <line>自定义头资讯传递给伺服器  
 --ignore-content-length  忽略的HTTP头资讯的长度  
 -i/--include 输出时包括protocol头资讯  
 -I/--head  只显示文档资讯  
 从文件中读取-j/--junk-session-cookies忽略会话Cookie  
 - 界面<interface>指定网路介面/地址使用  
 - krb4 <级别>启用与指定的安全级别krb4  
 -j/--junk-session-cookies 读取文件进忽略session cookie  
 --interface <interface> 使用指定网路介面/地址  
 --krb4 <level>  使用指定安全级别的krb4  
 -k/--insecure 允许不使用证书到SSL站台  
 -K/--config  指定的配置文件读取  
 -l/--list-only 列出ftp目录下的文件名称  
 --limit-rate <rate> 设置传输速度  
 --local-port<NUM> 强制使用本地连接埠号  
 -m/--max-time <seconds> 设置最大传输时间  
 --max-redirs <num> 设置最大读取的目录数  
 --max-filesize <bytes> 设置最大下载的文件总量  
 -M/--manual  显示全手动  
 -n/--netrc 从netrc文件中读取用户名和密码  
 --netrc-optional 使用 .netrc 或者 URL来覆盖-n  
 --ntlm          使用 HTTP NTLM 身份验证  
 -N/--no-buffer 禁用缓衝输出  
 -o/--output 把输出写到该文件中  
 -O/--remote-name 把输出写到该文件中，保留远端文件的文件名  
 -p/--proxytunnel   使用HTTP代理  
 --proxy-anyauth 选择任一代理身份验证方法  
 --proxy-basic   在代理上使用基本身份验证  
 --proxy-digest  在代理上使用数字身份验证  
 --proxy-ntlm    在代理上使用ntlm身份验证  
 -P/--ftp-port <address> 使用连接埠地址，而不是使用PASV  
 -Q/--quote <cmd>文件传输前，发送命令到伺服器  
 -r/--range <range>检索来自HTTP/1.1或FTP伺服器位元组范围  
 --range-file 读取（SSL）的随机文件  
 -R/--remote-time   在本地生成文件时，保留远端文件时间  
 --retry <num>   传输出现问题时，重试的次数  
 --retry-delay <seconds>  传输出现问题时，设置重试间隔时间  
 --retry-max-time <seconds> 传输出现问题时，设置最大重试时间  
 -s/--silent静音模式。不输出任何东西  
 -S/--show-error   显示错误  
 --socks4 <host[:port]> 用socks4代理给定主机和连接埠  
 --socks5 <host[:port]> 用socks5代理给定主机和连接埠  
 --stderr <file>  
 -t/--telnet-option <OPT=val> Telnet选项设置  
 --trace <file>  对指定文件进行debug  
 --trace-ascii <file> Like --跟踪但没有hex输出  
 --trace-time    跟踪/详细输出时，添加时间戳  
 -T/--upload-file <file> 上传文件  
 --url <URL>     Spet URL to work with  
 -u/--user <user[:password]>设置伺服器的用户和密码  
 -U/--proxy-user <user[:password]>设置代理用户名和密码  
 -v/--verbose  
 -V/--version 显示版本资讯  
 -w/--write-out [format]什麽输出完成后  
 -x/--proxy <host[:port]>在给定的连接埠上使用HTTP代理  
 -X/--request <command>指定什麽命令  
 -y/--speed-time 放弃限速所要的时间。默认为30  
 -Y/--speed-limit 停止传输速度的限制，速度时间 : 秒  
 -z/--time-cond  传送时间设置  
 -0/--http1.0  使用HTTP 1.0  
 -1/--tlsv1  使用TLSv1（SSL）  
 -2/--sslv2 使用SSLv2的（SSL）  
 -3/--sslv3         使用的SSLv3（SSL）  
 --3p-quote      like -Q for the source URL for 3rd party transfer  
 --3p-url        使用url，进行第三方传送  
 --3p-user       使用用户名和密码，进行第三方传送  
 -4/--ipv4   使用IP4  
 -6/--ipv6   使用IP6  
 -#/--progress-bar 用进度条显示当前的传送状态
}
curl(应用实例){
1，抓取页面内容到一个文件中
[root@krlcgcms01 mytest]# curl -o home.html  http://blog.51yip.com  
2，用-O（大写的），后面的url要具体到某个文件，不然抓不下来。我们还可以用正则来抓取东西
[root@krlcgcms01 mytest]# curl -O http://blog.51yip.com/wp-content/uploads/2010/09/compare_varnish.jpg  
[root@krlcgcms01 mytest]# curl -O http://blog.51yip.com/wp-content/uploads/2010/[0-9][0-9]/aaaaa.jpg  
3，模拟表单资讯，模拟登录，保存cookie资讯
[root@krlcgcms01 mytest]# curl -c ./cookie_c.txt -F log=aaaa -F pwd=****** http://blog.51yip.com/wp-login.php  
4，模拟表单资讯，模拟登录，保存头资讯
[root@krlcgcms01 mytest]# curl -D ./cookie_D.txt -F log=aaaa -F pwd=****** http://blog.51yip.com/wp-login.php  
-c(小写)产生的cookie和-D裡面的cookie是不一样的。
5，使用cookie文件
[root@krlcgcms01 mytest]# curl -b ./cookie_c.txt  http://blog.51yip.com/wp-admin  
6，断点续传，-C(大写的)
[root@krlcgcms01 mytest]# curl -C -O http://blog.51yip.com/wp-content/uploads/2010/09/compare_varnish.jpg  
7，传送数据,最好用登录页面测试，因为你传值过去后，curl回抓数据，你可以看到你传值有没有成功
[root@krlcgcms01 mytest]# curl -d log=aaaa  http://blog.51yip.com/wp-login.php  
8，显示抓取错误，下面这个例子，很清楚的表明了。
[root@krlcgcms01 mytest]# curl -f http://blog.51yip.com/asdf  
curl: (22) The requested URL returned error: 404  
[root@krlcgcms01 mytest]# curl http://blog.51yip.com/asdf  
  
<HTML><HEAD><TITLE>404,not found</TITLE>  
。。。。。。。。。。。。  
9，伪造来源地址，有的网站会判断，请求来源地址。
[root@krlcgcms01 mytest]# curl -e http://localhost http://blog.51yip.com/wp-login.php  
10，当我们经常用curl去搞人家东西的时候，人家会把你的IP给屏蔽掉的,这个时候,我们可以用代理
[root@krlcgcms01 mytest]# curl -x 24.10.28.84:32779 -o home.html http://blog.51yip.com  
11，比较大的东西，我们可以分段下载
[root@krlcgcms01 mytest]# curl -r 0-100 -o img.part1 http://blog.51yip.com/wp-  
  
content/uploads/2010/09/compare_varnish.jpg  
 % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current  
 Dload  Upload   Total   Spent    Left  Speed  
100   101  100   101    0     0    105      0 --:--:-- --:--:-- --:--:--     0  
[root@krlcgcms01 mytest]# curl -r 100-200 -o img.part2 http://blog.51yip.com/wp-  
  
content/uploads/2010/09/compare_varnish.jpg  
 % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current  
 Dload  Upload   Total   Spent    Left  Speed  
100   101  100   101    0     0     57      0  0:00:01  0:00:01 --:--:--     0  
[root@krlcgcms01 mytest]# curl -r 200- -o img.part3 http://blog.51yip.com/wp-  
  
content/uploads/2010/09/compare_varnish.jpg  
 % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current  
 Dload  Upload   Total   Spent    Left  Speed  
100  104k  100  104k    0     0  52793      0  0:00:02  0:00:02 --:--:-- 88961  
[root@krlcgcms01 mytest]# ls |grep part | xargs du -sh  
4.0K    one.part1  
112K    three.part3  
4.0K    two.part2  
用的时候，把他们cat一下就OK了,cat img.part* >img.jpg
12，不会显示下载进度资讯
[root@krlcgcms01 mytest]# curl -s -o aaa.jpg  http://blog.51yip.com/wp-content/uploads/2010/09/compare_varnish.jpg  
13，显示下载进度条
[root@krlcgcms01 mytest]# curl -# -O  http://blog.51yip.com/wp-content/uploads/2010/09/compare_varnish.jpg  
######################################################################## 100.0%  
14,通过ftp下载文件
[zhangy@BlackGhost ~]$ curl -u 用户名:密码 -O http://blog.51yip.com/demo/curtain/bbstudy_files/style.css  
 % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current  
 Dload  Upload   Total   Spent    Left  Speed  
101  1934  101  1934    0     0   3184      0 --:--:-- --:--:-- --:--:--  7136  
或者用下面的方式
[zhangy@BlackGhost ~]$ curl -O ftp://用户名:密码@ip:port/demo/curtain/bbstudy_files/style.css  
15，通过ftp上传
[zhangy@BlackGhost ~]$ curl -T test.sql ftp://用户名:密码@ip:port/demo/curtain/bbstudy_files/  
curl 指令用法   from : http://evelynnote.blogspot.tw/2011/03/curl.html
转录整理自: Linux curl使用简单介绍

curl 是 Linux 下一个很强大的 http 命令列工具
1) 取得网页内容，萤幕输出
$ curl http://www.linuxidc.com

2) -o: 取得网页内容，档案输出
$ curl -o page.html http://www.linuxidc.com

3) -x: 指定 http 使用的 proxy 
$ curl -x 123.45.67.89:1080 -o page.html http://www.linuxidc.com

4) -D: 把 http response 裡面的 cookie 资讯另存新档
$ curl -x 123.45.67.89:1080 -o page.html -D cookie0001.txt http://www.linuxidc.com

5）-b: 把 cookie 资讯加到 http request 裡
$ curl -x 123.45.67.89:1080 -o page1.html -D cookie0002.txt -b cookie0001.txt http://www.linuxidc.com

6）-A: 设定浏览器资讯
#Windows 2000上的 IE6.0
$ curl -A "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)" -x 123.45.67.89:1080 -o page.html -D cookie0001.txt http://www.linuxidc.com
# Linux Netscape 4.73
$ curl -A "Mozilla/4.73 [en] (X11; U; Linux 2.2; 15 i686" -x 123.45.67.89:1080 -o page.html -D cookie0001.txt http://www.linuxidc.com

7）-e: 设定 referrer
另外一个伺服器端常用的限制方法，就是检查 http 访问的 referer。比如你先访问首页，再访问裡面所指定的下载页，这第二次访问的 referer 位址就是第一次访问成功后的页面位址。这样，伺服器端只要发现对下载页面某次访问的 referer 位址不是首页的位址，就可以断定那是个盗连了
$ curl -A "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)" -x 123.45.67.89:1080 -e "mail.linuxidc.com" -o page.html -D cookie0001.txt http://www.linuxidc.com

8）-O: 使用伺服器上的档案名，存在本地 
$ curl -O http://cgi2.tky.3web.ne.jp/~zzh/screen1.JPG

9）可使用 Regular Expression 抓取所有 match 的档案，指定 match 的群组内容为新档名
$ curl -O http://cgi2.tky.3web.ne.jp/~zzh/screen[1-10].JPG
$ curl -o #2-#1.jpg http://cgi2.tky.3web.ne.jp/~{zzh,nick}/[001-201].JPG
原来： ~zzh/001.JPG -> 下载后：001-zzh.JPG 
原来： ~nick/001.JPG -> 下载后：001-nick.JPG

10）-c: 续传 (只能用在原本是 curl 传输的档案)
$ curl -c -O http://cgi2.tky.3wb.ne.jp/~zzh/screen1.JPG

11) -r: 分块下载
$ curl -r 0-10240 -o "zhao.part1" http:/cgi2.tky.3web.ne.jp/~zzh/zhao1.mp3 &\
$ curl -r 10241-20480 -o "zhao.part1" http:/cgi2.tky.3web.ne.jp/~zzh/zhao1.mp3 &\
$ curl -r 20481-40960 -o "zhao.part1" http:/cgi2.tky.3web.ne.jp/~zzh/zhao1.mp3 &\
$ curl -r 40961- -o "zhao.part1" http:/cgi2.tky.3web.ne.jp/~zzh/zhao1.mp3
Linux用 cat zhao.part* > zhao.mp3合併
Windows用copy /b 合併

12) -u: 指定 FTP 帐号密码
$ curl -u name:passwd ftp://ip:port/path/file
$ curl ftp://name:passwd@ip:port/path/file

13) -T: 上传档案
$ curl -T localfile -u name:passwd ftp://upload_site:port/path/
$ curl -T localfile http://cgi2.tky.3web.ne.jp/~zzh/abc.cgi
(注意这时候使用的协定是 HTTP 的 PUT method)

14) Http GET 与 POST 模式
GET 模式什麽 option 都不用，只需要把变数写在 url 裡面就可以了比如：
$ curl http://www.linuxidc.com/login.cgi?user=nickwolfe&password=12345
而 POST 模式的 option 则是 -d
$ curl -d "user=nickwolfe&password=12345" http://www.linuxidc.com/login.cgi
到底该用 GET 模式还是 POST 模式，要看对面伺服器的程式设定。比如 POST 模式下的文件上传
<form action="http://cgi2.tky.3web.ne.jp/~zzh/up_file.cgi" enctype="multipar/form-data" method="POST">
<input name="upload" type="file"/>
<input name="nick" type="submit" value="go"/></form>
这样一个 HTTP 表单，我们要用 curl 进行模拟，就该是这样的语法：
$ curl -F upload=@localfile -F nick=go http://cgi2.tky.3web.ne.jp/~zzh/up_file.cgi

15) https 使用本地认证
$ curl -E localcert.pem https://remote_server

16) 通过 dict 协定去查字典
$ curl dict://dict.org/d:computer
}

