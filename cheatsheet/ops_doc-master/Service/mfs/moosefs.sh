mfsmaster()
{
useradd mfs -s /sbin/nologin
./configure --prefix=/usr/local/mfs --with-default-user=mfs --with-default-group=mfs
make
make install
cd /usr/local/mfs/etc/
cp mfsmaster.cfg.dist mfsmaster.cfg
cp mfsexports.cfg.dist mfsexports.cfg
vim mfsmaster.cfg
vim mfsexports.cfg
cd ..
cd var/
mfs/
cp metadata.mfs.empty metadata.mfs
cat metadata.mfs
/usr/local/mfs/sbin/mfsmaster start 
ps axu | grep mfsmaster
lsof -i
tail -f /var/log/messages

# /usr/local/mfs/sbin/mfsmaster start|stop|restart|info|reload

#config
mfsmaster.cfg
mfsexports.cfg
metadata.mfs

}

mfsweb()
{
启动： /usr/local/mfs/sbin/mfscgiserv
停止： kill /usr/local/mfs/sbin/mfscgiserv 
}

mfschunkserver()
{
useradd mfs -s /sbin/nologin
./configure --prefix=/usr/local/mfs --with-default-user=mfs --with-default-group=mfs
make
make install
cd /usr/local/mfs/etc/
cp mfschunkserver.cfg.dist mfschunkserver.cfg
cp mfshdd.cfg.dist mfshdd.cfg
/usr/local/mfs/sbin/mfschunkserver start
ps axu |grep mfs
tail -f /var/log/messages

# /usr/local/mfs/sbin/mfschunkserver start|stop|restart|info|reload

#config
mfschunkserver.cfg
mfshdd.cfg
}


mfsclient()
{
yum install kernel.x86_64 kernel-devel.x86_64 kernel-headers.x86_64
###reboot server####
yum install fuse.x86_64 fuse-devel.x86_64 fuse-libs.x86_64
modprobe fuse

useradd mfs -s /sbin/nologin
./configure --prefix=/usr/local/mfs --with-default-user=mfs --with-default-group=mfs 
--enable-mfsmount
make 
make install

cd /mnt/
mkdir mfs
/usr/local/mfs/bin/mfsmount /mnt/mfs/ -H 192.168.28.242
mkdir mfsmeta
/usr/local/mfs/bin/mfsmount -m /mnt/mfsmeta/ -H 192.168.28.242

}


mfstool()
{
设置副本 的份数，推荐3份
/usr/local/mfs/bin/mfssetgoal -r 3 /mnt/mfs
查看某文件
/usr/local/mfs/bin/mfsgetgoal  /mnt/mfs
查看目录信息
/usr/local/mfs/bin/mfsdirinfo -H /mnt/mfs

}

##192.168.10.118
cd /root/flex/dfscgiserv/dfscgiserv/app
nohup python dfscgi.py -d -f etc/rddfs-web.ini&

##192.168.10.116
ip a add 192.168.13.1/16 dev bond0
ip a add 192.168.13.2/16 dev bond0
ip a add 192.168.13.3/16 dev bond0
ip a add 192.168.13.4/16 dev bond0
ip a add 192.168.13.5/16 dev bond0
ip a add 192.168.13.6/16 dev bond0

/home/wangfl/encode/sbin/dfsmaster start
/home/wangfl/encode/sbin/dfschunkserver -c /home/wangfl/encode/cs1/dfschunkserver.cfg start
/home/wangfl/encode/sbin/dfschunkserver -c /home/wangfl/encode/cs2/dfschunkserver.cfg start
/home/wangfl/encode/sbin/dfschunkserver -c /home/wangfl/encode/cs3/dfschunkserver.cfg start
/home/wangfl/encode/sbin/dfschunkserver -c /home/wangfl/encode/cs4/dfschunkserver.cfg start
/home/wangfl/encode/sbin/dfschunkserver -c /home/wangfl/encode/cs5/dfschunkserver.cfg start
/home/wangfl/encode/sbin/dfschunkserver -c /home/wangfl/encode/cs6/dfschunkserver.cfg start

cd /home/wangfl/dfscgiserv
nohup python psutil_rpc.py -b 192.168.13.1 &
nohup python psutil_rpc.py -b 192.168.13.2 &
nohup python psutil_rpc.py -b 192.168.13.3 &
nohup python psutil_rpc.py -b 192.168.13.4 &
nohup python psutil_rpc.py -b 192.168.13.5 &
nohup python psutil_rpc.py -b 192.168.13.6 &
nohup python psutil_rpc.py -b 192.168.10.116 &


/home/rdfs/sbin/dfschunkserver -c /home/rdfs/chunkserver/100/dfschunkserver.cfg start

