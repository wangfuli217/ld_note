下载Raspbian镜像，并写入TF卡
SSH登录树莓派，修改密码，启用root用户，并允许root用户SSH登录(这步可不做)
运行raspi-config，扩展TF卡分区，调整时区，禁用图形界面，等等...
apt-get update
安装samba，apache2，aria2，vim，等等...
配置aria2，samba，apache2，等等...
如果要外网访问，记得在路由器上开放22等端口，但记得80端口是没用的

sudo apt-get install ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy # 将系统设置为中文。设置成中文后需要下载中文字体


wget http://director.downloads.raspberrypi.org/raspbian/images/raspbian-2017-07-05/2017-07-05-raspbian-jessie.zip

/boot/cmdline.txt  
ip=192.168.1.17
user=pi
password=raspberry

apt-get update
apt-get upgrade
apt-get dist-upgrade

hostnamectl # 看到当前 Raspbian 系统版本是 Raspbian GNU/Linux 8 (jessie):


删除原文件所有内容，jessie 用以下内容取代：
deb http://mirrors.aliyun.com/raspbian/raspbian/ jessie main contrib non-free rpi 
deb-src http://mirrors.aliyun.com/raspbian/raspbian/ jessie main contrib non-free rpi



https://github.com/coderbunker/Shanghai-Linux-Meetup/wiki/Building-a-virtual-Raspberry-Pi
## Building a virtual Raspberry Pi
#1) get a raspbian image
save it on your host and unpack it
    mkdir ~/rpi
    cd ~/rpi
    wget http://director.downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2017-04-10/2017-04-10-raspbian-jessie-lite.zip .
    unzip 2017-04-10-raspbian-jessie-lite.zip
#2) tweak the image file to be working in a virtual environment (qemu/kvm)
    $ sudo mount ~/rpi/2017-03-02-raspbian-jessie-lite.img -o loop,offset=70254592 /mnt
    $ sudo vim ld.so.preload (and comment out the line in there)
    $ cd /
    $ sudo umount /mnt
#3) get a custom kernel for the virtual rpi we will be running
Raspbian kernel for qemu and howto: https://github.com/dhruvvyas90/qemu-rpi-kernel
we will be using the newest one (kernel-qemu-4.4.34-jessie)
    wget https://raw.githubusercontent.com/dhruvvyas90/qemu-rpi-kernel/master/kernel-qemu-4.4.34-jessie
#4) run the virtual machine (using the kernel from #3)
    $ qemu-system-arm -kernel /path/to/kernel-qemu-4.4.34-jessie -cpu arm1176 -m 256 -M versatilepb -append "root=/dev/sda2 panic=1 $ rootfstype=ext4 rw" -drive "file=/path/to/rpi/2017-04-10-raspbian-jessie-lite.img,index=0,media=disk,format=raw" -nographic -vnc :0
#5) Access your virtual Raspberry Pi
doubled port forwarding has to be applied
    from another terminal
    $ ssh user@server -L 9999:localhost:9999 (access the host)
    $ ssh coder@10.1.80.203 -L 9999:localhost:5900 (access virtual rpi)
    
    
    