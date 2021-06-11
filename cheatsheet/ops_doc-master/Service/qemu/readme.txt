/usr/libexec/qemu-kvm  -hda vyos.qcow2 -m 1G -enable-kvm -serial telnet:192.168.10.109:3355,server,nowait -vnc 192.168.10.109:2 -vga cirrus
注意IP地址192.168.10.109



# http://brezular.com/2014/07/12/vyos-x64-installation-on-qemu/           ---- src
# http://brezular.com/2015/10/06/gre-over-ipsec-tunnel-between-cisco-and-vyos/  ---- GRE cisco
-------------------------------------------------------------------------------
deploy_vyos.sh 和 install_vyos.exp
--------
# chmod +x deploy_vyos.sh
# chmod +x install_vyos.exp
# 
# ./deploy_vyos.sh
# ./install_vyos.exp
-------------------------------------------------------------------------------
User_Guide Main_Page 和 release
--------
https://wiki.vyos.net/wiki/User_Guide
https://wiki.vyos.net/wiki/Main_Page
http://mirror.easyspeedy.com/vyos/iso/release/

http://brezular.com/2010/09/25/how-to-install/

https://wiki.vyos.net/wiki/User_documentation

-------------------------------------------------------------------------------
1. Download VyOS x64 Installation ISO
$ wget http://0.uk.mirrors.vyos.net/iso/release/1.1.0/vyos-1.1.0-amd64.iso

2. Create VMware Virtual Disk
$ /usr/local/bin/qemu-img create -f vmdk vyos-1.1.0-amd64.img 1G

3. Start Qemu Disk with Attached VyOS ISO
$ /usr/local/bin/qemu-system-x86_64 -boot d -cdrom ./vyos-1.1.0-amd64.iso -hda vyos-1.1.0-amd64.vmdk -enable-kvm -m 1G -serial telnet:localhost:3355,server,nowait

Connect to VyOS console with the telnet command:
$ telnet localhost 3355

4. VyOS Installation
vyos@vyos:~$sudo su
root@vyos:/home/vyos#mount -t ext4 /dev/sda1 /tmp
install system


5. Stop Generating New Name for Ethernet Interfaces with Changed MAC Address
vyos@vyos:~$ sudo su
root@vyatta:/home/vyatta#mv /tmp/lib/udev/vyatta_net_name /tmp/lib/udev/vyatta_net_name.bak
root@vyatta:/home/vyatta#mv /tmp/lib64/udev/vyatta_net_name /tmp/lib64/udev/vyatta_net_name.bak
root@vyatta:/home/vyatta#sed -i 's/2367abef/00/g' /tmp/lib/udev/rules.d/75-persistent-net-generator.rules
root@vyatta:/home/vyatta#sed -i 's/2367abef/00/g' /tmp/lib64/udev/rules.d/75-persistent-net-generator.rules

6. Change Boot Order
root@vyatta:/home/vyatta#sed -i 's/set default=0/set default=1/g' /tmp/boot/grub/grub.cfg
