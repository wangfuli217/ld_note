logrotate(nginx){

/data/log/nginx/*.log /data/log/nginx/*/*.log { # 对匹配上的日志文件进行切割
    weekly # 每周切割
    missingok     # 在日志轮循期间，任何错误将被忽略，例如“文件无法找到”之类的错误。
    rotate 6      # 保留 6 个备份
    compress     # 压缩
    delaycompress    # delaycompress 和 compress 一起使用时，转储的日志文件到下一次转储时才压缩
    notifempty     # 如果是空文件的话，不转储
    create 0644 www-data ymserver     # mode owner group 转储文件，使用指定的文件模式创建新的日志文件
    sharedscripts # 下面详细说
    prerotate # 在logrotate转储之前需要执行的指令，例如修改文件的属性等动作；必须独立成行
        if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
            run-parts /etc/logrotate.d/httpd-prerotate; \
        fi \
    endscript
    postrotate  # 在logrotate转储之后需要执行的指令，例如重新启动 (kill -HUP) 某个服务！必须独立成行
        [ -s /run/nginx.pid ] && kill -USR1 `cat /run/nginx.pid`
    endscript
    su root ymserver # 轮训日志时切换设置的用户/用户组来执行（默认是root），如果设置的user/group 没有权限去让文件容用 create 选项指定的拥有者 ，会触发错误。
}

}

logrotate(){
desc(){
如果要配置一个每日0点执行切割任务，怎么做到？我们的logrotate默认每天执行时间已经写到了/etc/cron.daily/目录下面，
而这个目录下面的任务执行时间上面也说了，在/etc/crontab里面定义了时6：25。我之前就有个这样的需求，看看下面的配置
}

/data/log/owan_web/chn_download_stat/chn_app_rec.log {
    copytruncate
    # weekly 注释了 但是会继承/etc/logrorate.conf的全局变量，也是weekly
    missingok
    rotate 10
    compress
    delaycompress
    size=1000M # 大小到达size开始转存
    notifempty
    create 664 www-data ymserver
    su root
    dateext       //这个参数很重要！就是切割后的日志文件以当前日期为格式结尾，如xxx.log-20131216这样,如果注释掉,切割出来是按数字递增,即前面说的 xxx.log-1这种格式
    compress      //是否通过gzip压缩转储以后的日志文件，如xxx.log-20131216.gz ；如果不需要压缩，注释掉就行
}
然后去root的crontab配置一个0点执行的任务
sudo crontab -l -u root
0 0 * * * /usr/sbin/logrotate /etc/logrotate.d/web_roteate -fv  >/tmp/logro.log 2>&1
}
