# iptables_drop_malice_ssh_ipaddr

使用 lastb 方式过滤恶意登入 SSH 脚本，又一次输入密码错误就会被记录在内，所以需要填写白名单到 neglect_ssh_list.txt 文件内，格式如下：
```
8.8.8.8
...
``` 
相关 crontab 实现方式已经写入 crontab.list 文件。
