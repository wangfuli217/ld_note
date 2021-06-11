http://www.cnblogs.com/hanford/p/6113359.html


codepage(Codepage的定义和历史)
{
字符内码(charcter code)指的是用来代表字符的内码.读者在输入和存储文档时都要使用内码,内码分为
    单字节内码 -- Single-Byte character sets (SBCS),可以支持256个字符编码.
    双字节内码 -- Double-Byte character sets)(DBCS),可以支持65000个字符编码.主要用来对大字符集的东方文字进行编码.
    codepage 指的是一个经过挑选的以特定顺序排列的字符内码列表,对于早期的单字节内码的语种,codepage中的内码顺序
使得系统可以按照此列表来根据键盘的输入值给出一个对应的内码.对于双字节内码,则给出的是MultiByte到Unicode的
对应表,这样就可以把以Unicode形式存放的字符转化为相应的字符内码,或者反之,在Linux核心中对应的函数就是utf8_mbtowc
和utf8_wctomb.

例如936代表简体中文. 950代表繁体中文.


1.1 CJK Codepage
    同 Extended Unix Coding ( EUC )编码大不一样的是,下面所有的远东 codepage 都利用了C1控制码 { =80..=9F } 做为首字节, 
使用ASCII值 { =40..=7E { 做为第二字节,这样才能包含多达数万个双字节字符,这表明在这种编码之中小于3F的ASCII值不一定
代表ASCII字符.

CP932:Shift-JIS包含日本语 
CP936:GBK 扩展了 EUC-CN 编码( GB 2312-80编码,包含 6763 个汉字)到Unicode (GB13000.1-93)中定义的20902个汉字,中国大陆使用
的是简体中文zh_CN.
CP949:韩文音节( 在C1中 )
CP950:是代替EUC-TW (CNS 11643-1992)的 Big5 编码(13072 繁体 zh_TW 中文字) 繁体中文,这些定义都在Ken Lunde的 CJK.INF中或
注意: Microsoft采用以上四种Codepage,因此要访问Microsoft的文件系统时必需采用上面的Codepage .


1 代码页
代码页也叫字符集，它有两个特点：
1、它是一个字符集合；
2、为了便于计算机处理。这个字符集合里，每个字符都有编码。
可用一个字符串表示代码页，如：GB2312、GBK、GB18030、Big5……也可以用一个整数表示代码页，如：20936表示GB2312、936表示GBK、54936表示GB18030、950表示Big5……

1.1 单字节字符集
代码页里，每个字符使用一个字节编码，这样的字符集就是单字节字符集SBCS（Single-byte Character Sets）

1.2 双字节字符集
代码页里，每个字符最多使用两个字节编码，这样的字符集就是双字节字符集DBCS（Double-byte Character Sets）

1.3 多字节字符集
代码页里，某些字符的编码超过了一个字节，这样的字符集就是多字节字符集MBCS（Multi-byte Character Sets）。显然，双字节字符集属于多字节字符集，反过来多字节字符集不一定是双字节字符集。因为，有些代码页会用两个以上的字节表示一个字符。如：UTF-7、UTF-8……。


}

codepage(Linux下Codepage的作用)
{

    在Linux下引入对Codepage的支持主要是为了访问FAT/VFAT/FAT32/NTFS/NCPFS等文件系统下的多语种文件名的问题,
目前在NTFS和FAT32/VFAT下的文件系统上都使用了Unicode,这就需要系统在读取这些文件名时动态将其转换为相应的语言编码.
因此引入了NLS支持.其相应的程序文件在/usr/src/linux/fs/nls下: 

实现了下列函数:

    extern int utf8_mbtowc(__u16 *, const __u8 *, int);
    extern int utf8_mbstowcs(__u16 *, const __u8 *, int);
    extern int utf8_wctomb(__u8 *, __u16, int);
    extern int utf8_wcstombs(__u8 *, const __u16 *, int);


这样在加载相应的文件系统时就可以用下面的参数来设置Codepage:

对于Codepage 437 来说

mount -t vfat /dev/hda1 /mnt/1 -o codepage=437,iocharset=cp437
}

codepage(Windows下Codepage的作用)
{
一、操作系统
window系统内部都是unicode的。文件夹名，文件名等都是unicode的，任何语言系统下都能正常显示。

二、输入法：
微软拼音输出的是Unicode的，智能ABC输出是简体中文的（所以智能ABC在非简体中文系统根本不能用，只能打英文）。

三、网页的textarea
网页的textarea是用unicode显示的。所以往里打什么字都能显示。而一些flash做的输入框就不行了。

四、Access2000
access里面保存的数据是unicode的，在任何语言系统下都能显示。
如果数据视图查看有些字符不正常，那是因为显示所用的字体不是Unicode字体，
换用Arial Unicode MS 字体就能全部显示了。（access帮助，搜索，输入unicode，有说明）

五、Word
word里的繁简转换，简体转换到繁体后，内码仍是简体中文的，其实只是简体中的繁体字。

六、ASP内部是Unicode的，所有文本都是Unicode存储的。需要时转换到指定字符集。

首先说下结论：
<%@ codepage=936%>简体中文
<%@ codepage=950%>繁体中文
<%@ codepage=65001%>UTF-8


API
枚举代码页:      可使用API函数EnumSystemCodePages，枚举系统的代码页。
查询代码页信息:  可使用GetCPInfoEx函数获得代码页的信息。
    结构CPINFOEX里，多字节编码的信息不全——只有首字节的范围信息，没有其它字节的范围信息。
    可以通过编码找出其余字节的范围信息。思路就是：调用WideCharToMultiByte函数，将0~0xFFFF
的UTF-16编码转换为指定代码页的编码，并确定各个字节的范围。

    宽窄字符串的转换由WideCharToMultiByte（宽字符串转换为多字节字符串）和MultiByteToWideChar
（多字节字符串转换为宽字符串）完成。
    WideCharToMultiByte和MultiByteToWideChar的实质工作主要就是查表。如下面的代码转换宽字符串"编码"为窄字符串：
    
    ".code_page"    setlocale(LC_ALL,".936");   设置代码页为936
    ""              setlocale(LC_ALL,"");       设置代码页为系统默认值对于简体中文而言就是936
    NULL            setlocale(LC_ALL,NULL);     获取设置，如：
setlocale(LC_ALL,"");之前调用setlocale(LC_ALL,NULL);将返回"C"
setlocale(LC_ALL,"");之后调用setlocale(LC_ALL,NULL);将返回"Chinese (Simplified)_People's Republic of China.936"


setlocale(LC_ALL,"Chinese (Traditional)_Taiwan.950");

rc文件
LANGUAGE LANG_CHINESE, SUBLANG_CHINESE_SIMPLIFIED
#pragma code_page(936)

查看注册表HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Nls\CodePage
}