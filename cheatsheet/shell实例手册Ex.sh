
desc(patch_diff)
{
1. diff和patch是一对工具，在数学上来说，diff是对两个集合的差运算，patch是对两个集合的和运算。
2. diff比较两个文件或文件集合的差异，并记录下来，生成一个diff文件，这也是我们常说的patch文件，即补丁文件。
3. patch能将diff文件运用于 原来的两个集合之一，从而得到另一个集合。举个例子来说文件A和文件B,经过diff之后生成
    了补丁文件C,那么着个过程相当于 A -B = C ,那么patch的过程就是B+C = A 或A-C =B。
4. 因此我们只要能得到A, B, C三个文件中的任何两个，就能用diff和patch这对工具生成另外一个文件。

### 单个文件
diff –uN  from-file  to-file  > to-file.patch
patch –p0 < to-file.patch
patch –RE –p0 < to-file.patch
### 多个文件
diff –uNr  from-docu  to-docu > to-docu.patch
patch –p1 < to-docu.patch
patch –R –p1


patch usage examples:
 patch -p<n> < diff_file
 cat diff_file | patch -p<n>
 xzcat diff_file.xz | patch -p<n>
 bzcat diff_file.bz2 | patch -p<n>
 zcat diff_file.gz | patch -p<n>
Notes:
n: number of directory levels to skip in the le paths
You can reverse apply a patch with the-Roption
You can test a patch with--dry-runoption

cd linux-3.0
xzcat ../patch-3.1.xz | patch -p1
xzcat ../patch-3.1.3.xz | patch -p1
cd ..; mv linux-3.0 linux-3.1.3
}

diff()
{
    diff [options] from-file to-file
    -r 是一个递归选项，设置了这个选项，diff会将两个不同版本源代码目录中的所有对应文件全部都进行一次比较，
        包括子目录文件。
    -N 选项确保补丁文件将正确地处理已经创建或删除文件的情况。
    -u 选项以统一格式创建补丁文件，这种格式比缺省格式更紧凑些。

    diff -uN test0 test1 >test1.patch #生成test1的补丁文件
                                      # 这样将通过比较，生成test1的补丁文件。这里选项u表示使用同一格式输出这样
                                      #产生的输出便于阅读易于修改，N表示把不存在的文件看做empty的.就算文件
                                      #test0不存在，也会生成补丁。
    patch -p0 <test1.patch            #把test0通过打补丁变成test1文件
    patch <test1.patch                #把test0通过打补丁变成test1文件
                                      #这样，test0的内容将和test1的内容一样，但是文件名称还是test0。
                                      
    patch -RE -p0<test1.patch         # 把打过补丁的test0还原
    patch -R <test1.patch             # 把打过补丁的test0还原 

    
    diff -uNr prj0 prj1 > prj1.patch
    cp prj1.patch ./prj0
    cd prj0
    # 这样，把补丁文件复制到了prj0下面，然后将该文搜索件夹下面的文件"变成"prj1下的文件了.
    patch -p1 < prj1.patch 
    
    # 将打好补丁的prj0中的所有文件还原成为原来打补丁之前的文件：
    patch -R -p1 < prj1.patch

    
}

patch()
{
    patch [options] [originalfile [patchfile]]
    patch [选项] [原始文件 [补丁文件]]
    patch就是利用diff制作的补丁来实现源文件（夹）和目的文件（夹）的转换。这样说就意味着你可以有源文件（夹）――>目的文件（夹），也可以目的文件（夹）――>源文件（夹）
    
    -r 是一个递归选项，设置了这个选项，diff会将两个不同版本源代码目录中的所有对应文件全部都进行一次比较，包括子目录文件。
    -N 选项确保补丁文件将正确地处理已经创建或删除文件的情况。
    -u 选项以统一格式创建补丁文件，这种格式比缺省格式更紧凑些。
    -p0 选项从当前目录查找目的文件（夹）(直接使用补丁文件里面指定的路径)
    -p1 选项忽略掉第一层目录，从当前目录查找(去掉补丁文件指定路径最左的第1个'/'及前面所有内容)。
    -E 选项说明如果发现了空文件，那么就删除它
    -R 选项说明在补丁文件中的"新"文件和"旧"文件现在要调换过来了（实际上就是给新版本打补丁，让它变成老版本）
}

patch(文件的结构)
{
--- test1	2016-10-18 12:48:01.550794000 +0800
+++ test2	2016-10-18 12:48:23.869822000 +0800
@@ -1,4 +1,4 @@
-
-111111
+222222
 111111
+222222
 111111
\ No newline at end of file

补丁头： 补丁头是分别由---/+++开头的两行，用来表示要打补丁的文件。---开头表示旧文件，+++开头表示新文件。

补丁块： 一个补丁文件中可能包含以---/+++开头的很多节，每一节用来打一个补丁。所以在一个补丁文件中可以包含好多个补丁块。
        块是补丁中要修改的地方。它通常由一部分不用修改的东西开始和结束。他们只是用来表示要修改的位置。
        他们通常以@@开始，结束于另一个块的开始或者一个新的补丁头。
块的缩进：块会缩进一列，而这一列是用来表示这一行是要增加还是要删除的。                
          块的第一列
          +号表示这一行是要加上的。
          -号表示这一行是要删除的。
          没有加号也没有减号表示这里只是引用的而不需要修改。  
}

sed(替换)
{
sed -i.bak "s/SELINUX=enforcing/SELINUX=permissive/g" /etc/selinux/config
sed -i.bak "s/enabled=0/enabled=1/g" /etc/yum.repos.d/fedora.repo
sed -i.bak "s/enabled=0/enabled=1/g" /etc/yum.repos.d/fedora-updates.repo
sed -i.bak 's/\.[a-z].*//g' /etc/sysconfig/network
cat /etc/sysconfig/network
export ais_addr=`ip addr | grep "inet " | tail -n 1 | awk '{print $4}' | sed s/255/0/`
sed -i.bak "s/.*mcastaddr:.*/mcastaddr:\ $ais_mcast/g" /etc/corosync/corosync.conf
sed -i.bak "s/.*mcastport:.*/mcastport:\ $ais_port/g" /etc/corosync/corosync.conf
sed -i.bak "s/.*bindnetaddr:.*/bindnetaddr:\ $ais_addr/g" /etc/corosync/corosync.conf
}

openssl()
{
    OpenSSL 是一个强大的安全套接字层密码库，囊括主要的密码算法、常用的密钥和证书封装管理功能及SSL协议，并提供丰富的应用程序
供测试或其它目的使用。

OpenSSL有两种运行模式：交互模式和批处理模式。
直接输入openssl回车进入交互模式，输入带命令选项的openssl进入批处理模式。

OpenSSL整个软件包大概可以分成三个主要的功能部分：密码算法库、SSL协议库以及应用程序。OpenSSL的目录结构自然也是围绕这三个功能部分进行规划的。


openssl(对称加密算法)
{
OpenSSL一共提供了8种对称加密算法，其中7种是分组加密算法，仅有的一种流加密算法是RC4。
这7种分组加密算法分别是AES、DES、Blowfish、CAST、IDEA、RC2、RC5，
都支持电子密码本模式（ECB）、加密分组链接模式（CBC）、加密反馈模式（CFB）和输出反馈模式（OFB）四种常用的分组密码加密模式。
其中，AES使用的加密反馈模式（CFB）和输出反馈模式（OFB）分组长度是128位，其它算法使用的则是64位。
事实上，DES算法里面不仅仅是常用的DES算法，还支持三个密钥和两个密钥3DES算法。 

# 对称加密应用例子
# 用DES3算法的CBC模式加密文件plaintext.doc，
# 加密结果输出到文件ciphertext.bin
# openssl enc -des3 -salt -in plaintext.doc -out ciphertext.bin

# 用DES3算法的OFB模式解密文件ciphertext.bin，
# 提供的口令为trousers，输出到文件plaintext.doc
# 注意：因为模式不同，该命令不能对以上的文件进行解密
# openssl enc -des-ede3-ofb -d -in ciphertext.bin -out plaintext.doc -pass pass:trousers

# 用Blowfish的CFB模式加密plaintext.doc，口令从环境变量PASSWORD中取
# 输出到文件ciphertext.bin
# openssl bf-cfb -salt -in plaintext.doc -out ciphertext.bin -pass env:PASSWORD

# 给文件ciphertext.bin用base64编码，输出到文件base64.txt
# openssl base64 -in ciphertext.bin -out base64.txt

# 用RC5算法的CBC模式加密文件plaintext.doc
# 输出到文件ciphertext.bin，
# salt、key和初始化向量(iv)在命令行指定
# openssl rc5 -in plaintext.doc -out ciphertext.bin -S C62CB1D49F158ADC -iv E9EDACA1BD7090C6 -K 89D4B1678D604FAA3DBFFD030A314B29

}

openssl(非对称加密算法)
{
OpenSSL一共实现了4种非对称加密算法，包括DH算法、RSA算法、DSA算法和椭圆曲线算法（EC）。
DH算法一般用户密钥交换。
RSA算法既可以用于密钥交换，也可以用于数字签名，当然，如果你能够忍受其缓慢的速度，那么也可以用于数据加密。
DSA算法则一般只用于数字签名。 

RSA
-----------------------
# 产生1024位RSA私匙，用3DES加密它，口令为trousers，
# 输出到文件rsaprivatekey.pem
# openssl genrsa -out rsaprivatekey.pem -passout pass:trousers -des3 1024

# 从文件rsaprivatekey.pem读取私匙，用口令trousers解密，
# 生成的公钥匙输出到文件rsapublickey.pem
# openssl rsa -in rsaprivatekey.pem -passin pass:trousers -pubout -out rsapubckey.pem

# 用公钥匙rsapublickey.pem加密文件plain.txt，
# 输出到文件cipher.txt
# openssl rsautl -encrypt -pubin -inkey rsapublickey.pem -in plain.txt -out cipher.txt

# 使用私钥匙rsaprivatekey.pem解密密文cipher.txt，
# 输出到文件plain.txt
# openssl rsautl -decrypt -inkey rsaprivatekey.pem -in cipher.txt -out plain.txt

# 用私钥匙rsaprivatekey.pem给文件plain.txt签名，
# 输出到文件signature.bin
# openssl rsautl -sign -inkey rsaprivatekey.pem -in plain.txt -out signature.bin

# 用公钥匙rsapublickey.pem验证签名signature.bin，
# 输出到文件plain.txt
# openssl rsautl -verify -pubin -inkey rsapublickey.pem -in signature.bin -out plain

# 从X.509证书文件cert.pem中获取公钥匙，
# 用3DES加密mail.txt
# 输出到文件mail.enc
# openssl smime -encrypt -in mail.txt -des3 -out mail.enc cert.pem

# 从X.509证书文件cert.pem中获取接收人的公钥匙，
# 用私钥匙key.pem解密S/MIME消息mail.enc，
# 结果输出到文件mail.txt
# openssl smime -decrypt -in mail.enc -recip cert.pem -inkey key.pem -out mail.txt

# cert.pem为X.509证书文件，用私匙key,pem为mail.txt签名，
# 证书被包含在S/MIME消息中，输出到文件mail.sgn
# openssl smime -sign -in mail.txt -signer cert.pem -inkey key.pem -out mail.sgn

# 验证S/MIME消息mail.sgn，输出到文件mail.txt
# 签名者的证书应该作为S/MIME消息的一部分包含在mail.sgn中
# openssl smime -verify -in mail.sgn -out mail.txt

DAS
--------------------------------------
# 生成1024位DSA参数集，并输出到文件dsaparam.pem
# openssl dsaparam -out dsaparam.pem 1024

# 使用参数文件dsaparam.pem生成DSA私钥匙，
# 采用3DES加密后输出到文件dsaprivatekey.pem
# openssl gendsa -out dsaprivatekey.pem -des3 dsaparam.pem

# 使用私钥匙dsaprivatekey.pem生成公钥匙，
# 输出到dsapublickey.pem
# openssl dsa -in dsaprivatekey.pem -pubout -out dsapublickey.pem

# 从dsaprivatekey.pem中读取私钥匙，解密并输入新口令进行加密，
# 然后写回文件dsaprivatekey.pem
# openssl dsa -in dsaprivatekey.pem -out dsaprivatekey.pem -des3 -passin
}

openssl(信息摘要算法)
{
OpenSSL实现了5种信息摘要算法，分别是MD2、MD5、MDC2、SHA（SHA1）和RIPEMD。SHA算法事实上包括了SHA和SHA1两种信息摘要算法，此外，
OpenSSL还实现了DSS标准中规定的两种信息摘要算法DSS和DSS1。 

# 用SHA1算法计算文件file.txt的哈西值，输出到stdout 
# openssl dgst -sha1 file.txt 

# 用SHA1算法计算文件file.txt的哈西值,输出到文件digest.txt 
# openssl sha1 -out digest.txt file.txt

# 用DSS1(SHA1)算法为文件file.txt签名,输出到文件dsasign.bin 
# 签名的private key必须为DSA算法产生的，保存在文件dsakey.pem中 
# openssl dgst -dss1 -sign dsakey.pem -out dsasign.bin file.txt 

# 用dss1算法验证file.txt的数字签名dsasign.bin， 
# 验证的private key为DSA算法产生的文件dsakey.pem 
# openssl dgst -dss1 -prverify dsakey.pem -signature dsasign.bin file.txt 

# 用sha1算法为文件file.txt签名,输出到文件rsasign.bin 
# 签名的private key为RSA算法产生的文件rsaprivate.pem 
# openssl sha1 -sign rsaprivate.pem -out rsasign.bin file.txt 

# 用sha1算法验证file.txt的数字签名rsasign.bin， 
# 验证的public key为RSA算法生成的rsapublic.pem 
# openssl sha1 -verify rsapublic.pem -signature rsasign.bin file.txt

}

openssl(密钥和证书管理)
{
密钥和证书管理是PKI的一个重要组成部分，OpenSSL为之提供了丰富的功能，支持多种标准。 
}


首先，OpenSSL实现了ASN.1的证书和密钥相关标准，提供了对证书、公钥、私钥、证书请求以及CRL等数据对象的DER、PEM和BASE64的编解码功能。OpenSSL提供了产生各种公开密钥对和对称密钥的方法、函数和应用程序，同时提供了对公钥和私钥的DER编解码功能。并实现了私钥的PKCS#12和PKCS#8的编解码功能。OpenSSL在标准中提供了对私钥的加密保护功能，使得密钥可以安全地进行存储和分发。 
在此基础上，OpenSSL实现了对证书的X.509标准编解码、PKCS#12格式的编解码以及PKCS#7的编解码功能。并提供了一种文本数据库，支持证书的管理功能，包括证书密钥产生、请求产生、证书签发、吊销和验证等功能。 

事实上，OpenSSL提供的CA应用程序就是一个小型的证书管理中心（CA），实现了证书签发的整个流程和证书管理的大部分机制。



# 使用生成因子2和随机的1024-bit的素数产生D0ffie-Hellman参数 
# 输出保存到文件dhparam.pem 
# openssl dhparam -out dhparam.pem -2 1024 

# 从dhparam.pem中读取Diffie-Hell参数，以C代码的形式 # 输出到stdout
# openssl dhparam -in dhparam.pem -noout -C

}

name()
{
1. 最常见的缩写，取每个单词的首字母，如
2. 如果首字母后为“h”，通常保留
3. 递归缩写[3]也属于这一类，如：
4. 如果只有一个单词，通常取每个音节的首字母：
5. 对于目录，通常使用前几个字母作为缩写：
6. 缩写的其它情况
7. 如果某种缩写比较深入人心，例如“mesg”代表“message”，在新的复合缩写中，将沿用这种缩写方式
8. 有些缩写中，第一个字母“g”，代表“GNU”
}
最常见的缩写，取每个单词的首字母，如
cd   Change Directory
dd   Disk Dump
df   Disk Free
du   Disk Usage
pwd  Print Working Directory
ps   Processes Status
PS   Prompt Strings
su   Substitute User
rc   Run Command
Tcl  Tool Command Language
cups Common Unix Printing System
apt  Advanced Packaging Tool
bg   BackGround
ping Packet InterNet Grouper

如果首字母后为“h”，通常保留
chsh  CHange SHell
chmod CHange MODe
chown CHange OWNer
chgrp CHange GRouP
bash  Bourne Again SHell
zsh   Z SHell
ksh   Korn SHell
ssh   Secure SHell
递归缩写[3]也属于这一类，如：
GNU GNU's	Not	Unix
PHP PHP:	Hypertext	Preprocessor
RPM RPM	Package	Manager
WINE WINE	Is	Not	an	Emulator
PNG PNG's	Not	GIF
nano Nano s	ANOther	editor

有些缩写可能有多种定义，如：
`rpm`
RPM	Package	Manager
RedHat	Package	Manager
`bc`
Basic	Calculator
Better	Calculator

如果只有一个单词，通常取每个音节的首字母：
cp CoPy
ln LiNk
ls LiSt
mv MoVe
rm ReMove

对于目录，通常使用前几个字母作为缩写：
bin BINaries
dev DEVices
etc ETCetera
lib LIBrary
var VARiable
proc PROCesses
sbin Superuser	BINaries
tmp TeMPorary
usr Unix	Shared	Resources

这种缩写的其它情况
diff DIFFerences
cal CALendar
cat CATenate
ed EDitor
exec EXECute
tab TABle
regexp REGular	EXPression