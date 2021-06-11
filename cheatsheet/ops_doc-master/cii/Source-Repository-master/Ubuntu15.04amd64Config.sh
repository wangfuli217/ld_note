#!/bin/bash
echo "vim"
sudo apt-get install vim
cp -r ./vim/.vim ~/
cp ./vim/.vimrc ~/
echo -e '\n'

echo "Synaptic"
sudo apt-get install Synaptic -y
echo -e '\n'

echo "qemu"
sudo apt-get install qemu -y
echo -e '\n'

echo "gcc-arm-linux-gnueabi"
sudo apt-get install gcc-arm-linux-gnueabi -y 
echo -e '\n'

echo "lib32 in amd64"
sudo apt-get install gcc-multilib -y
sudo apt-get install libglib2.0-0:i386 -y
echo -e '\n'

echo "tftp service"

echo "Please input tftpdir"
read tftpdir	#创建用于传输文件的目录
sudo mkdir $tftpdir   
sudo chmod 0777 $tftpdir
sudo apt-get install tftp-hpa tftpd-hpa xinetd -y
#sudo vi /etc/default/tftp-hpa
sudo touch /etc/default/tftpd-hpa
sudo chmod 0777 /etc/default/tftpd-hpa
sudo echo "TFTP_USERNAME=\"tftp\"" > /etc/default/tftpd-hpa
sudo echo "TFTP_DIRECTORY=\"$tftpdir\""	>> /etc/default/tftpd-hpa	#tftpd-hpa的服务目录,这个想建立在哪里都行
sudo echo "TFTP_ADDRESS=\"0.0.0.0:69\"" 	>> /etc/default/tftpd-hpa	#指定开发板地址，需要和主机的ip在同一个网段	
sudo echo "TFTP_OPTIONS=\"-l -c -s\""   	>> /etc/default/tftpd-hpa	#-c是可以上传文件的参数，-s是指定tftpd-hpa服务目录，上面已指定

sudo service tftpd-hpa restart
echo -e '\n'

echo "nfs service"
echo "Please input nfs dir"
read nfsdir
sudo mkdir $nfsdir
sudo apt-get install nfs-kernel-server nfs-common portmap -y
#sudo vi /etc/exports
sudo touch /etc/exports
sudo chmod 0777 /etc/exports
sudo echo "$nfsdir 192.168.1.*	(rw,sync,no_root_squash)" > /etc/exports
echo -e '\n'

echo "putty"
sudo apt-get install putty -y
echo -e '\n'

echo "ckermit"
sudo apt-get install ckermit -y
KERMRCDIR= ~/.kermrc
sudo echo "set line /dev/ttyUSB0" > $KERMRCDIR
sudo echo "set speed 115200" >> $KERMRCDIR
sudo echo "set carrier-watch off" >> $KERMRCDIR
sudo echo "set handshake none" >> $KERMRCDIR
sudo echo "set flow-control none" >> $KERMRCDIR
sudo echo "robust" >> $KERMRCDIR
sudo echo "set file type bin" >> $KERMRCDIR
sudo echo "set file name lit" >> $KERMRCDIR
sudo echo "set rec pack 1000" >> $KERMRCDIR
sudo echo "set send pack 1000" >> $KERMRCDIR
sudo echo "set window 5" >> $KERMRCDIR
sudo echo "c" >> $KERMRCDIR
echo -e '\n'

echo "kscope"
sudo apt-get install kscope -y
echo -e '\n'

echo "ctags"
sudo apt-get install ctags -y
echo -e '\n'

#sudo apt-get install fcitx-googlepinyin

echo "retext"	#MarkDown编辑器
sudo apt-get install retext -y
sudo apt-get install python-pygments -y	#语法高亮 
sudo apt-get install libjs-mathjax -y	#数学公式支持
echo -e '\n'

echo "qtcreator"
sudo apt-get install qtcreator -y
echo -e '\n'

echo "git"
sudo apt-get install git -y
echo -e '\n'

echo "wordpress"
sudo apt-get install wordpress -y
echo -e '\n'

echo "unity-tweak-tool"
sudo apt-get install unity-tweak-tool -y
echo -e '\n'

echo "numix theme"
sudo apt-add-repository ppa:numix/ppa -y  
sudo apt-get update 
sudo apt-get install numix-icon-theme-circle numix-gtk-theme -y  
echo -e '\n'

echo "sam2p"
sudo apt-get install sam2p -y #转换图片格式的工具
echo -e '\n'

echo "python编译包"
sudo apt-get install python-distutils-extra -y
echo -e '\n'

echo "python3-setuptools"
sudo apt-get install python3-setuptools -y
echo -e '\n'

echo "python-pip"
sudo apt-get install python-pip -y
echo -e '\n'

echo "pyinstaller"
pip install pyinstaller
echo -e '\n'

echo "cmatrix"
sudo apt-get install cmatrix -y
echo -e '\n'

echo "oneko"
sudo apt-get install oneko -y
echo -e '\n'

echo "aafire"
sudo apt-get install libaa-bin -y
echo -e '\n'

echo "sl"
sudo apt-get install sl -y
echo -e '\n'

echo "cowsay"
sudo apt-get install cowsay -y
echo -e '\n'

echo "xcowsay"
sudo apt-get install xcowsay -y
echo -e '\n'

echo "xeyes"
sudo apt-get install xeyes -y
echo -e '\n'

echo "bb"
sudo apt-get install bb -y
echo -e '\n'

echo "toilet"
sudo apt-get install toilet -y
echo -e '\n'

echo "config ～/.bashrc"
Deja_alias=`grep 'alias c' ~/.bashrc`
Deja_export=`grep '^export' ~/.bashrc`
if [ "$Deja_alias" == "" ];then
	sudo echo "alias c=\"clear\"" >> ~/.bashrc
	sudo echo "alias cl=\"clear;ls\"" >> ~/.bashrc
	sudo echo "alias cdd=\"cd ~/Desktop\"">> ~/.bashrc
fi
if [ "$Deja_export" == "" ];then
	sudo echo "export PS1=\"\W $\"" >>~/.bashrc
	sudo echo "export PATH=\"$PATH:.\"" >>~/.bashrc
fi
sudo source ~/.bashrc
echo -e '\n'


echo "gconf-editor"
sudo apt-get install gconf-editor -y
echo -e '\n'

echo "firefox-flash"
sudo cp ./libflashplayer.so /usr/lib/mozilla/plugins/
echo -e '\n'

#echo "chromium"
#sudo apt-get install chromiumbrowser
#echo -e '\n'

#echo "chromium-flash"
#sudo cp ./libpepflashplayer.so /usr/lib/chromium-browser/plugins/
#sudo apt-get install pepperflashplugin-nonfree
#sudo update-pepperflashplugin-nonfree --install
#echo -e '\n'

echo "配置低电量休眠"
#cat <<EOF | sudo tee /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
sudo echo "[Re-enable hibernate by default]" >/etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
sudo echo "Identity=unix-user:$USER" >>/etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
sudo echo "Action=org.freedesktop.upower.hibernate" >>/etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
sudo echo "ResultActive=yes" >>/etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
#EOF
echo -e '\n'

echo "virtualbox"
sudo apt-get install virtualbox -y
echo -e '\n'

echo "pyQt4"
sudo apt-get install libxext6 libxext-dev libqt4-dev libqt4-gui libqt4-sql qt4-dev-tools qt4-doc qt4-designer qt4-qtconfig "python-qt4-*" python-qt4 -y
echo -e '\n'

echo "eric"
sudo apt-get install eric
echo -e '\n'

echo 'jekyII'
sudo apt-get install ruby
sudo gem install bundler
sudo gem install jekyll bundler
echo -e '\n'

echo 'uget'
sudo add-apt-repository ppa:plushuang-tw/uget-stable
sudo apt-get update
sudo apt-get install uget
echo -e '\n'

echo 'aria2'
sudo add-apt-repository ppa:t-tujikawa/ppa
sudo apt-get update
sudo apt-get install aria2
echo -e '\n'

echo 'openssl/opensslv.h'		#编译内核要用
sudo apt-get install libssl-dev
echo -e '\n'


