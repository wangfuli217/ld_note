tar(.tar)
{
tar [主选项+辅选项] 文件或者目录

解包：tar zxvf FileName.tar
打包：tar czvf FileName.tar DirName
tar -cvf /tmp/etc.tar /etc　　　　<==仅打包，不压缩！
tar -zcvf /tmp/etc.tar.gz /etc　　<==打包后，以 gzip 压缩
tar -jcvf /tmp/etc.tar.bz2 /etc　　<==打包后，以 bzip2 压缩

[主选项]
-c 创建新的档案文件。如果用户想备份一个目录或是一些文件，就要选择这个选项。
-r 把要存档的文件追加到档案文件的末尾。例如用户已经做好备份文件，又发现还有一个目录或是一些文件忘记备份了，这时可以使用该选项，将忘记的目录或文件追加到备份文件中。
-t 列出档案文件的内容，查看已经备份了哪些文件。
-u 更新文件。就是说，用新增的文件取代原备份文件，如果在备份文件中找不到要更新的文件，则把它追加到备份文件的最后。
-x 从档案文件中释放文件。

[辅助选项]
-z ：是否同时具有 gzip 的属性，亦即是否需要用 gzip 压缩或解压？ 一般格式为xx.tar.gz或xx. tgz
-j ：是否同时具有 bzip2 的属性，亦即是否需要用 bzip2 压缩或解压？一般格式为xx.tar.bz2  
-v ：压缩的过程中显示文件！这个常用
-f ：使用档名，请留意，在 f 之后要立即接档名喔！不要再加其他参数！
-p ：使用原文件的原来属性（属性不会依据使用者而变）
--exclude FILE：在压缩的过程中，不要将 FILE 打包！
-C,--directory DIR  转到指定的目录
}

gzip(.gz)
{
解压1：gunzip FileName.gz
解压2：gzip -d FileName.gz
压缩：gzip FileName
.tar.gz 和 .tgz
解压：tar zxvf FileName.tar.gz
压缩：tar zcvf FileName.tar.gz DirName
}

bzip2(.bz2,.bz)
{
.bz2
解压1：bzip2 -d FileName.bz2
解压2：bunzip2 FileName.bz2
压缩： bzip2 -z FileName
.tar.bz2
解压：tar jxvf FileName.tar.bz2
压缩：tar jcvf FileName.tar.bz2 DirName

.bz
解压1：bzip2 -d FileName.bz
解压2：bunzip2 FileName.bz
压缩：未知
.tar.bz
解压：tar jxvf FileName.tar.bz
压缩：未知

}

compress(.Z)
{
.Z
解压：uncompress FileName.Z
压缩：compress FileName
.tar.Z
解压：tar Zxvf FileName.tar.Z
压缩：tar Zcvf FileName.tar.Z DirName
}

zip(.zip)
{
.zip
解压：unzip FileName.zip
压缩：zip FileName.zip DirName
}

rar(.rar)
{
.rar
解压：rar a FileName.rar
压缩：rar e FileName.rar

rar请到：http://www.rarsoft.com/download.htm 下载！
解压后请将rar_static拷贝到/usr/bin目录（其他由$PATH环境变量指定的目录也可以）：
[root@www2 tmp]# cp rar_static /usr/bin/rar
}

lha()
{
.lha

解压：lha -e FileName.lha
压缩：lha -a FileName.lha FileName

lha请到：http://www.infor.kanazawa-it.ac.jp/~ishii/lhaunix/下载！
>解压后请将lha拷贝到/usr/bin目录（其他由$PATH环境变量指定的目录也可以）：
[root@www2 tmp]# cp lha /usr/bin/
}

rpm2cpio()
{
.rpm
解包：rpm2cpio FileName.rpm | cpio -div
}

ar()
{
.deb
解包：ar p FileName.deb data.tar.gz | tar zxf -
}
