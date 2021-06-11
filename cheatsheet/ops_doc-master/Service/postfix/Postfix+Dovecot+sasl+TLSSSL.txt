---
title: CentOS邮件服务器 Postfix+Dovecot+sasl+TLS/SSL
date: 2016-10-11 18:47:15
categories:
- linux
- 网络服务
- mail
tags:
- linux
- 网络服务
- mail
keywords: postfix, dovecot, sasl, 邮件服务器
---
> 
这几天搭建centos邮件服务器可折腾的不少啊，网上的好多文档都有问题，还好，到目前为止总算搞好了；
包括 `dns mx记录` `sasl认证` `开启ssl/tls`等等

<!-- more -->

<pre><code class="language-bash line-numbers">yum -y install postfix dovecot cyrus*
</code></pre>

### 配置Postfix
<pre><code class="language-bash line-numbers"># 基本配置
cd /etc/postfix/
mv main.cf main.cf.bak
postconf -n &gt; main.cf       # 隐藏默认配置项(更简洁)

--- main.cf ---
myhostname = mail.zfl9.com      # mail主机名
mydomain = zfl9.com             # 域名
myorigin = $mydomain            # 邮件地址后缀
mydestination = $mydomain       # 邮件投递目标，一般mydomain即可 避免转发垃圾邮件
home_mailbox = Maildir/         # 设置本地邮件目录


# sasl认证
--- main.cf ---
smtpd_sasl_auth_enable = yes                # 开启sasl认证
smtpd_sasl_security_options = noanonymous   # 禁止匿名用户
smtpd_recipient_restrictions = permit_mynetworks,permit_sasl_authenticated,reject_unauth_destination


# 别名设置
## 默认不允许root使用邮箱账户，需要配置别名
--- /etc/aliases ---
root: admin     # 设置root别名为admin

postalias /etc/aliases      # 更新alias数据库

--- /etc/postfix/main.cf ---
alias_maps = hash:/etc/aliases      # 指定alias文件
alias_database = hash:/etc/aliases  # alias数据库


# ssl/tls配置
--- /etc/postfix/main.cf ---
smtpd_tls_security_level = encrypt      # 启用SSL加密认证
smtpd_tls_cert_file = /etc/pki/mail/server.crt
smtpd_tls_key_file = /etc/pki/mail/server.key
smtpd_tls_auth_only = yes               # 只允许TLS认证的客户端连接服务器

--- /etc/postfix/master.cf ---
smtps     inet  n       -       n       -       -       smtpd
  -o smtpd_tls_wrappermode=yes
</code></pre>

### 配置Dovecot
<pre><code class="language-bash line-numbers">cd /etc/dovecot/conf.d/

--- 10-auth.conf ---
disable_plaintext_auth = yes    # 禁止明文密码认证


--- 10-mail.conf ---
mail_location = maildir:~/Maildir


--- 10-ssl.conf ---
ssl = yes
ssl_cert = &lt;/etc/pki/mail/server.crt
ssl_key = &lt;/etc/pki/mail/server.key
</code></pre>

### 启动服务
<pre><code class="language-bash line-numbers">chkconfig postfix on
chkconfig dovecot on
chkconfig saslauthd on
service postfix start
service dovecot start
service saslauthd start

ss -lnp | egrep 'master|dovecot'
# 查看端口是否正常打开
smtp    25
pop3    110
imap    143
smtps   465
pops    995
imaps   993
</code></pre>
