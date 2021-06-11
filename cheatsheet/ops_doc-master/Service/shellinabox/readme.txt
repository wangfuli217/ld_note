https://github.com/shellinabox/shellinabox

apt-get install git libssl-dev libpam0g-dev zlib1g-dev dh-autoreconf

aclocal
libtoolize --force
automake --add-missing
autoconf
autoreconf -vi

export PATH="${PATH}:/usr/local/arm/arm-2009q3/bin/"
./configure --disable-pam --disable-ssl CC=/usr/local/arm/arm-2009q3/bin/arm-none-linux-gnueabi-gcc --host=arm

make

/etc/default/shellinaboxd   # 配置文件
/etc/shellinaboxd/          # 配置文件夹

shellinaboxd -u root -g root                # 启动即可正常
shellinaboxd -s /:LOGIN  -u root -g root    # 启动即可正常
shellinaboxd -t root -g root                # 开启一个login shell

shellinaboxd 1. 如果非root用户启动此进程，则通过ssh代替/bin/login; 2. 非https访问转向https方式访问
             3. 当前目录没有证书正生成证书
shellinaboxd -t 1.  login shell 不需要证书支持
shellinaboxd -t -f beep.wav:/dev/null 1. 没有蜂鸣
shellinaboxd -s /:SSH:example.org     1. 通过ssh转向其他服务器
shellinaboxd -t -s /:AUTH:HOME:/bin/bash 1. 在启动bash之前要求用户名：密码。2. 支持非root用于启动，只允许指定用户登录
shellinaboxd -c certificates -g shellinaboxd 1. 要求证书，2. shellinaboxd 组用户可写
shellinaboxd -t -s /:LOGIN -s /who:nobody:nogroup:/:w 1. http://localhost:4200/who， 必须root启动
shellinaboxd -t -s '/:root:root:/:wy60 -c /bin/login'  1.  Wyse 60 terminal
shellinaboxd --css white-on-black.css 指定css
shellinaboxd --user-css Normal:+black-on-white.css,Reverse:-white-on-black.css 1. 


? shellinaboxd -t -s '/:root:root:/:/bin/bash' --port=8080 (不需要输入密码,直接登陆)

--------------------------------------------------------------------------------
三：生成pem证书，以https方式启动，pem证书的格式为公钥加私钥，并以x509的格式进行打包 
[root@rhel6 ~]# openssl genrsa -des3 -out my.key 1024
[root@rhel6 ~]# openssl req -new -key my.key -out my.csr 
[root@rhel6 ~]# cp my.key my.key.org 
[root@rhel6 ~]# openssl rsa -in my.key.org -out my.key 
[root@rhel6 ~]# openssl x509 -req -days 3650 -in my.csr -signkey my.key -out my.crt 
[root@rhel6 ~]# cat my.crt my.key > certificate.pem


[root@rhel6 ~]# /usr/local/shellinabox/bin/shellinaboxd -c /root -u root -b //-c参数指定pem证书目录，默认证书名为certificate.pem，-u 选项指定启动的用户身份 
[root@rhel6 ~]# netstat -ntpl |grep 4200 tcp 0 0 0.0.0.0:4200 0.0.0.0:* LISTEN 26445/shellinaboxd

--------------------------------------------------------------------------------
nohup shellinaboxd -c /tmp -t &
    nohup 防止shellinabox 死掉
    -c 指定证书所在目录
    -t disable ssl 防止浏览器安全警告