livecd(��װ���)
{
    sudo dnf install livecd-tools
}

livecd(��װ�׸� LiveCD)
{
  sudo livecd-iso-to-disk --reset-mbr --home-size-mb 1024 '/home/tekkamanninja/development/temp/Fedora-Live-Workstation-x86_64-23-10.iso' /dev/sdb1

    �Creset-mbr ���� livecd-iso-to-disk ��Ҫ���� U �̣���洢������ MBR������ϵͳ�ſ��Դ� U ����������Ϊ����װ���׸� LiveCD ӳ������Ǳ���ġ�
    �Chome-size-mb 1024 ����ѡ������ livecd-iso-to-disk ����һ��1024MB ��С�� img �ļ���Ϊ�û���home ���������Ա����û����ݡ�ע�⣺Ĭ�ϨCencrypted-home �������ں�����ϨCunencrypted-home ����Ϊ��ʵ�������з������������home.img�� �п��ܵ��� ϵͳ���������׶Ρ�ԭ���ǣ���ϵͳ��ʾ���������ʱ���������е�������Ϣ����谭����������룬�����޷��������룬ϵͳ�޷�����home.img, ���������������������F23 security lab LiveCD �У���WorkStation LiveCD ��û�����⡣
    ��������Զ�������ı�ǩ������ʹ�� �Clabel <����label> ,���磬�Clabel "Fedora-LiveCD"
    *.iso ���ص� Fedora LiveCD �ļ������ö�˵��
    /dev/sdb1 �ǰ�װ��Ŀ�� U �̷�����ע�⣺ �Ƿ�������������U �̡� �����ǰ�ֺ��������ǵ�Ŀ����������ʾΪ"boot"�����򹤾߻���ʾ���˳���

����ִ����Ϻ���� U �̾��ǿ�����������װ Fedora ���������ˡ�
��װ��� LiveCD ��ͬһ��������ѡ��
}

livecd(multi)
{
������˵�һ�� LiveCD �İ�װ֮���ҷ��֣���ʵ livecd-iso-to-disk ��֧�ֶ�ӳ��װ�ġ� 
�ڶ�����֮�� LiveCD �İ�װ �ǵ������������

    sudo livecd-iso-to-disk --multi --livedir "security" --home-size-mb 1024 --unencrypted-home '/home/tekkamanninja/Downloads/Fedora-Live-Security-x86_64-23-10.iso' /dev/sdb1
    sudo livecd-iso-to-disk --multi --livedir "server" '/home/tekkamanninja/Downloads/Fedora-Server-DVD-x86_64-23.iso' /dev/sdb1

���׸�ϵͳ����Ҫ�������ڣ� ����� �Cmulti �Clivedir <��װĿ¼��> 
���ѡ���Ǹ��� ���ߣ��˴ε� LiveCD ӳ�� ��װ�� /dev/sdb1 ��Ŀ¼�µ� <��װĿ¼��> Ŀ¼�������Ͳ�����ԭ�Ȱ�װ�� LiveCD ��ͻ�ˡ� 
ֻҪ��� U �̹���Ҫ��װ���� LiveCD ӳ�� �����ԡ�����ע�⣬��ִ���������֮�� �����ֶ��޸����������ļ����������޷�������ʱ�������氲װ�� LiveCD ����ѡ�


}

livecd(config)
{
�Ա���Ϊ�����Ȱ�װ�� F23 Workstation LiveCD�� ֮��װ��security Live CD��������Ҫ�� /security/syslinux/syslinux.cfg �е�


    menu separator
    label linux0
    menu label ^Start Fedora Live
    kernel /security/syslinux/vmlinuz0
    append initrd=/security/syslinux/initrd0.img root=live:UUID=8fcd33eb-3dc2-4c04-8347-1b8099aa0d1c rootfstype=ext4 ro rd.live.image live_dir=security quiet rhgb rd.luks=0 rd.md=0 rd.dm=0


������ /syslinux/extlinux.conf �С�
}
