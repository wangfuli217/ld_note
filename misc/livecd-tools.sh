livecd(安装软件)
{
    sudo dnf install livecd-tools
}

livecd(安装首个 LiveCD)
{
  sudo livecd-iso-to-disk --reset-mbr --home-size-mb 1024 '/home/tekkamanninja/development/temp/Fedora-Live-Workstation-x86_64-23-10.iso' /dev/sdb1

    –reset-mbr 告诉 livecd-iso-to-disk 需要更新 U 盘（或存储器）的 MBR，这样系统才可以从 U 盘启动。作为被安装的首个 LiveCD 映像，这个是必须的。
    –home-size-mb 1024 （可选）告诉 livecd-iso-to-disk 创建一个1024MB 大小的 img 文件作为用户的home 分区，可以保留用户数据。注意：默认–encrypted-home ，建议在后面加上–unencrypted-home ，因为在实践过程中发现如果加密了home.img， 有可能导致 系统卡在启动阶段。原因是，在系统提示输入密码的时候，其他并行的启动信息输出阻碍了密码的输入，导致无法输入密码，系统无法挂载home.img, 卡死。这种情况出现在了F23 security lab LiveCD 中，在WorkStation LiveCD 中没有问题。
    如果你想自定义分区的标签，可以使用 –label <分区label> ,例如，–label "Fedora-LiveCD"
    *.iso 下载的 Fedora LiveCD 文件，不用多说了
    /dev/sdb1 是安装的目标 U 盘分区，注意： 是分区，并非整个U 盘。 你可提前分好区，但记得目标分区必须标示为"boot"，否则工具会提示并退出。

命令执行完毕后，你的 U 盘就是可以启动并安装 Fedora 的启动盘了。
安装多个 LiveCD 到同一分区（可选）
}

livecd(multi)
{
在完成了第一个 LiveCD 的安装之后，我发现，其实 livecd-iso-to-disk 是支持多映像安装的。 
第二个及之后 LiveCD 的安装 是的命令大致如下

    sudo livecd-iso-to-disk --multi --livedir "security" --home-size-mb 1024 --unencrypted-home '/home/tekkamanninja/Downloads/Fedora-Live-Security-x86_64-23-10.iso' /dev/sdb1
    sudo livecd-iso-to-disk --multi --livedir "server" '/home/tekkamanninja/Downloads/Fedora-Server-DVD-x86_64-23.iso' /dev/sdb1

与首个系统的主要区别在于： 添加了 –multi –livedir <安装目录名> 
这个选项是告诉 工具：此次的 LiveCD 映像 安装于 /dev/sdb1 根目录下的 <安装目录名> 目录，这样就不会与原先安装的 LiveCD 冲突了。 
只要你的 U 盘够大，要安装几个 LiveCD 映像 都可以。但是注意，在执行完此命令之后， 必须手动修改启动配置文件，否则你无法在启动时看到后面安装的 LiveCD 启动选项。


}

livecd(config)
{
以本文为例，先安装了 F23 Workstation LiveCD， 之后安装了security Live CD，所有需要将 /security/syslinux/syslinux.cfg 中的


    menu separator
    label linux0
    menu label ^Start Fedora Live
    kernel /security/syslinux/vmlinuz0
    append initrd=/security/syslinux/initrd0.img root=live:UUID=8fcd33eb-3dc2-4c04-8347-1b8099aa0d1c rootfstype=ext4 ro rd.live.image live_dir=security quiet rhgb rd.luks=0 rd.md=0 rd.dm=0


拷贝到 /syslinux/extlinux.conf 中。
}
