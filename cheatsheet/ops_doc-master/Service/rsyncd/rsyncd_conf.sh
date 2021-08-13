# rsync�������������ļ�rsyncd.conf
rsync����Ҫ���������������ļ�:
rsyncd.conf(�������ļ�)
rsyncd.secrets(�����ļ�)
rsyncd.motd(rysnc��������Ϣ)
�����������ļ�(/etc/rsyncd/rsyncd.conf)�����ļ�Ĭ�ϲ����ڣ��봴����
mkdir /etc/rsyncd && touch /etc/rsyncd/rsyncd.conf && touch /etc/rsyncd/rsyncd.secrets && touch /etc/rsyncd/rsyncd.motd

# vi /etc/rsyncd.conf 

uid = root
gid = root
use chroot = no
max connections = 10
strict modes =yes
port = 873
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log

[user]
path = /data/DATA/smc/interface/logs/user_visit_daily/
comment = This is a test
ignore errors
read only = yes
hosts allow = 10.13.81.125
[dc]
path = /data/DATA/smc/interface/logs/dc/
comment = This is a test
ignore errors
read only = no
hosts allow = 10.13.81.47
#hosts allow = 10.10.70.155

rsync -azv --update yd125@10.13.81.130::user /opt/smc/activeuser/ > /dev/null 2>&1

--------------------------------------------------------------------------------
!!! ɾ��ȫ��ע��
######### ȫ�����ò��� ##########
port=873    # ָ��rsync�˿ڡ�Ĭ��873
uid = rsync # rsync����������û���Ĭ����nobody���ļ�����ɹ��������������uid
gid = rsync # rsync����������飬Ĭ����nobody���ļ�����ɹ������齫�����gid
use chroot = no # rsync daemon�ڴ���ǰ�Ƿ��л���ָ����pathĿ¼�£�������������
max connections = 200 # ָ���������������0��ʾû������
timeout = 300         # ȷ��rsync������������Զ�ȴ�һ�������Ŀͻ��ˣ�0��ʾ��Զ�ȴ�
motd file = /var/rsyncd/rsync.motd   # �ͻ������ӹ�����ʾ����Ϣ
pid file = /var/run/rsyncd.pid       # ָ��rsync daemon��pid�ļ�
lock file = /var/run/rsync.lock      # ָ�����ļ�
log file = /var/log/rsyncd.log       # ָ��rsync����־�ļ�����������־���͸�syslog
dont compress = *.gz *.tgz *.zip *.z *.Z *.rpm *.deb *.bz2  # ָ����Щ�ļ����ý���ѹ������
# address 10.1.4.44 # ָ��������IP��ַ
# log format = %t %a %m %f %b
###########����ָ��ģ�飬���趨ģ�����ò��������Դ������ģ��###########
[longshuai]        # ģ��ID
path = /longshuai/ # ָ����ģ���·�����ò�������ָ��������rsync����ǰ��Ŀ¼������ڡ�rsync�������ģ�鱾�ʾ��Ƿ��ʸ�·����
ignore errors      # ����ĳЩIO������Ϣ
read only = false  # ָ����ģ���Ƿ�ɶ�д�����ܷ��ϴ��ļ���false��ʾ�ɶ�д��true��ʾ�ɶ�����д������ģ��Ĭ�ϲ����ϴ�
write only = false # ָ����ģʽ�Ƿ�֧�����أ�����Ϊtrue��ʾ�ͻ��˲������ء�����ģ��Ĭ�Ͽ�����
list = false       # �ͻ���������ʾģ���б�ʱ����ģ���Ƿ���ʾ����������Ϊfalse���ģ��Ϊ����ģ�顣Ĭ��true
hosts allow = 192.168.10.0/24 # ָ���������ӵ���ģ��Ļ��������ip�ÿո����������������
hosts deny = 0.0.0.0/32   # ָ�����������ӵ���ģ��Ļ���
auth users = rsync_backup # ָ�����ӵ���ģ����û��б�ֻ���б�����û��������ӵ�ģ�飬�û����Ͷ�Ӧ���뱣����secrts file�У�
                          # ����ʹ�õĲ���ϵͳ�û������������û���������ʱ��Ĭ�������û��������ӣ���ʹ�õ�����������
secrets file = /etc/rsyncd.passwd # ����auth users�û��б���û��������룬ÿ�а���һ��username:passwd������"strict modes"
                                  # Ĭ��Ϊtrue�����Դ��ļ�Ҫ���rsync daemon�û����ɶ�д��ֻ��������auth users��ѡ�����Ч��
[xiaofang]    # ���¶�����ǵڶ���ģ��
path=/xiaofang/
read only = false
ignore errors
comment = anyone can access

--------------------------------------------------------------------------------
useradd -r -s /sbin/nologin rsync
mkdir /{longshuai,xiaofang}
chown -R rsync.rsync /{longshuai,xiaofang}

echo "rsync_backup:123456" >> /etc/rsyncd.passwd
chmod 600 /etc/rsyncd.passwd 

rsync --daemon


echo "123456" > /tmp/rsync_passwd
rsync --list-only --port 888 rsync_backup@192.168.10.107::longshuai/a/b --password-file=/tmp/rsync_passwd
����
rsync --list-only rsync://rsync_backup@192.168.10.107:888/longshuai/a/b --password-file=/tmp/rsync_passwd

# ������ͬ��
crontab -e:
# m h  dom mon dow   command
  0 3   *   *   *    /usr/local/bin/rsync_backup.sh --verbose

