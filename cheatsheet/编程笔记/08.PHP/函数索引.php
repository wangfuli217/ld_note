﻿PHP 函数索引
(共有 967 个函数)

Abs:                取得绝对值。
Acos:               取得反余弦值。
ada_afetch:         取得数据库的返回列。
ada_autocommit:     开关自动改动功能。
ada_close:          关闭 Adabas D 链接。
ada_commit:         改动 Adabas D 数据库。
ada_connect:        链接至 Adabas D 数据库。
ada_exec:           执行 SQL 指令。
ada_fetchrow:       取得返回一列。
ada_fieldname:      取得字段名称。
ada_fieldtype:      取得字段资料类型。
ada_freeresult:     释出返回资料的内存。
ada_numfields:      取得字段数目。
ada_numrows:        取得返回列数目。
ada_result:         取得返回资料。
ada_resultall:      返回 HTML 表格资料。
ada_rollback:       撤消当前交易。
AddSlashes:         字符串加入斜线。
apache_lookup_uri:  获得所有的 URI 相关信息。
apache_note:        获得及配置apache服务器的请求纪录。
array:              建立一个新的数组。
array_walk:         让使用者自订函数能处理数组中的每一个元素。
arsort:             将数组的值由大到小排序。
Asin:               取得反正弦值。
asort:              将数组的值由小到大排序。
aspell_check:       检查一个单字。
aspell_check-raw:   检查一个单字，即使拼错也不改变或修正。
aspell_new:         载入一个新的字典。
aspell_suggest:     检查一个单字，并提供拼写建议。
Atan:               取得反正切值。
Atan2:              计算二数的反正切值。
base64_decode($msg):将 BASE64 编码字符串解码。
base64_encode($msg):将字符串以 BASE64 编码。(可处理数据库中文冲突问题)锯箭法
basename:           返回不含路径的文件字符串。
base_convert:       转换数字的进位方式。
bcadd:              将二个高精确度数字相加。
bccomp:             比较二个高精确度数字。
bcdiv:              将二个高精确度数字相除。
bcmod:              取得高精确度数字的余数。
bcmul:              将二个高精确度数字相乘。
bcpow:              求一高精确度数字次方值。
bcscale:            配置程序中所有 BC 函数库的默认小数点位数。
bcsqrt:             求一高精确度数字的平方根。
bcsub:              将二个高精确度数字相减。
bin2hex:            二进位转成十六进位。
BinDec:             二进位转成十进位。
Ceil:               计算大于指定数的最小整数。
chdir:              改变目录。
checkdate:          验证日期的正确性。
checkdnsrr:         检查指定网址的 DNS 记录。
chgrp:              改变文件所属的群组。
chmod:              改变文件的属性。
Chop:               去除连续空白。
chown:              改变文件的拥有者。
Chr:                返回序数值的字符。
chunk_split:        将字符串分成小段。
clearstatcache:     清除文件状态快取。
closedir:           关闭目录 handle。
closelog:           关闭系统纪录。
connection_aborted: 若链接中断则返回 true。
connection_status:  取得连接状态。
connection_timeout: 若超过 PHP 程序执行时间则返回 true。
convert_cyr_string: 转换古斯拉夫字符串成其它字符串。
copy:               复制文件。
Cos:                余弦计算。
count:              计算变量或数组中的元素个数。
crypt:              将字符串用 DES 编码加密。
current:            返回数组中目前的元素。
date:               将服务器的时间格式化。    如：date("Y年m月d日 星期w H时i分s秒", time())
dbase_add_record:   加入资料到 dBase 资料表。
dbase_close:        关闭 dBase 资料表。
dbase_create:       建立 dBase 资料表。
dbase_delete_record:  删除 dBase 资料表的资料。
dbase_get_record:   取得 dBase 资料表的资料。
dbase_numfields:    取得 dBase 资料表的字段数。
dbase_numrecords:   取得 dBase 资料表的列数。
dbase_open:         打开 dBase 资料表。
dbase_pack:         清理 dBase 资料表。
dba_close:          关闭数据库。
dba_delete:         删除指定资料。
dba_exists:         检查键是否存在。
dba_fetch:          取回指定资料。
dba_firstkey:       取回首笔键值。
dba_insert:         加入资料。
dba_nextkey:        取回下笔键值。
dba_open:           打开数据库链接。
dba_optimize:       最佳化数据库。
dba_popen:          打开并保持数据库链接。
dba_replace:        改动或加入资料。
dba_sync:           数据库同步化。
dblist:             取得 DBM 的信息。
dbmclose:           关闭 DBM 数据库。
dbmdelete:          删除指定资料。
dbmexists:          检查键是否存在。
dbmfetch:           取回指定资料。
dbmfirstkey:        取回首笔键名。
dbminsert:          加入资料。
dbmnextkey:         取回下笔键值。
dbmopen:            打开 DBM 数据库链接。
dbmreplace:         改动或加入资料。
debugger_off:       关闭内建的 PHP 除错器。
debugger_on:        使用内建的 PHP 除错器。
DecBin:             十进位转二进位。
DecHex:             十进位转十六进位。
DecOct:             十进位转八进位。
define("常量名",值) 设定常量。
defined('常量')     返回此常量是否已被定义。
delete:             无用的项目。
die:                输出信息并中断 PHP 程序。
dir:                目录类别类。
dirname:            取得路径中的目录名。
diskfreespace:      取得目录所在的剩余可用空间。
dl:                 载入 PHP 扩充模块。
doubleval:          变量转成倍浮点数类型。
each:               返回数组中下一个元素的索引及值。
easter_date:        计算复活节日期。
easter_days:        计算复活节与三月廿一日之间日期数。
echo:               输出字符串。
empty:              判断变量是否已配置。
end:                将数组的内部指针指到最后的元素。
ereg:               字符串比对解析。
eregi:              字符串比对解析，与大小写无关。
eregi_replace:      字符串比对解析并取代，与大小写无关。
ereg_replace:       字符串比对解析并取代。
error_log:          送出一个错误信息。
error_reporting:    配置错误信息回报的等级。
escapeshellcmd:     除去字符串中的特殊符号。
eval:               将值代入字符串之中。
exec:               执行外部程序。
exit:               结束 PHP 程序。此页面之后的程序不再执行。
Exp:                自然对数 e 的次方值。
explode:            切开字符串。
extract:            汇入数组到符号表。
fclose:             关闭已打开的文件。
FDF_close:          关闭 FDF 文件。
FDF_create:         建立新的 FDF 文件。
FDF_get_file:       取得 /F 键的值。
FDF_get_status:     取得 /STATUS 键的值。
FDF_get_value:      取得字段的值。
FDF_next_field_name:下一字段的名称。
FDF_open:           打开 FDF 文件。
FDF_save:           将 FDF 文件存文件。
FDF_set_ap:         配置显示字段。
FDF_set_file:       配置 /F 键。
FDF_set_status:     配置 /STATUS 键。
FDF_set_value:      配置字段的值。
feof:               测试文件指针是否指到文件尾。
fgetc:              取得文件指针所指的字符。
fgetcsv:            取得文件指针所指行，并解析 CSV 字段。
fgets:              取得文件指针所指的行。(保留html标志)
fgetss:             取得文件指针所指的行，并去掉 HTML 语言标记。
file("file"):       将文件全部读入数组变量中。(数组中每个元素是文件的一行)
fileatime("file"):  取得文件最后的存取时间。
filectime("file"):  取得文件最后的改变时间。
filegroup:          取得文件所属的群组。
fileinode("file"):  取得文件的 inode 值。
filemtime("file"):  取得文件最后的修改时间。
fileowner("file"):  取得文件的拥有者(UID 值)。
fileperms:          取得文件的权限配置。
filepro:            读取 FilePro Map 文件。
filepro_fieldcount: 取得字段数目。
filepro_fieldname:  取得字段名称。
filepro_fieldtype:  取得字段类型。
filepro_fieldwidth: 取得字段宽度。
filepro_retrieve:   取得指定储存格资料。
filepro_rowcount:   取得列数目。
filesize("file"):   获得文件的大小(单位：字节)。
filetype("file"):   获得文件的类型。
file_exists:        检查文件是否存在。
flock:              锁住文件。
Floor:              计算小于指定数的最大整数。
flush:              清出输出缓冲区。
fopen:              打开文件或者 URL。
fpassthru:          输出所有剩余资料。
fputs:              写到文件指针。
fread:              位组的方式读取文件。
FrenchToJD:         将法国共和历法转换成为凯撒日计数。
fseek:              移动文件指针。
fsockopen:          打开网络的 Socket 链接。
ftell:              取得文件读写指针位置。
ftp_cdup:           回上层目录。
ftp_chdir:          改变路径。
ftp_connect:        打开 FTP 链接。
ftp_delete:         将文件删除。
ftp_fget:           下载文件，并存在已开的文件中。
ftp_fput:           上传已打开文件。
ftp_get:            下载文件。
ftp_login:          登入 FTP 服务器。
ftp_mdtm:           获得指定文件的最后修改时间。
ftp_mkdir:          建新目录。
ftp_nlist:          列出指定目录中所有文件。
ftp_pasv:           切换主被动传输模式。
ftp_put:            上传文件。
ftp_pwd:            取得目前所在路径。
ftp_quit:           关闭 FTP 连接。
ftp_rawlist:        详细列出指定目录中所有文件。
ftp_rename:         将文件改名。
ftp_rmdir:          删除目录。
ftp_size:           获得指定文件的大小。
ftp_systype:        显示服务器系统。
function_exists:    检查函数是否已定义。
fwrite:             二进位位方式写入文件。
getallheaders:      获得所有 HTTP 变量值。
getdate:            获得时间及日期信息。
getenv:             取得系统的环境变量
gethostbyaddr:      返回机器名称。
gethostbyname:      返回 IP 网址。
gethostbynamel:     返回机器名称的所有 IP。
GetImageSize:       取得图片的长宽。
getlastmod:         返回该网页的最后修改时间。
getmxrr:            取得指定网址 DNS 记录之 MX 字段。
getmyinode:         返回该网页的 inode 值。
getmypid:           返回 PHP 的行程代号。
getmyuid:           返回 PHP 的使用者代码。
getrandmax:         随机数的最大值。
getrusage:          返回系统资源使用率。
gettimeofday:       取得目前时间。
gettype:            取得变量的类型。
get_cfg_var:        取得 PHP 的配置选项值。
get_current_user:   取得 PHP 行程的拥有者名称。
get_magic_quotes_gpc:      取得 PHP 环境变量 magic_quotes_gpc 的值。
get_magic_quotes_runtime:  取得 PHP 环境变量 magic_quotes_runtime 的值。
get_meta_tags:      抽出文件所有 meta 标记的资料。
gmdate:             取得目前与 GMT 差后的时间。
gmmktime:           取得 UNIX 时间戳记的格林威治时间。
GregorianToJD:      将格里高里历法转换成为凯撒日计数。
gzclose:            关闭压缩文件。
gzeof:              判断是否在压缩文件尾。
gzfile:             读压缩文件到数组中。
gzgetc:             读压缩文件中的字符。
gzgets:             读压缩文件中的字符串。
gzgetss:            读压缩文件中的字符串，并去掉 HTML 指令。
gzopen:             打开压缩文件。
gzpassthru:         解压缩指针后全部资料。
gzputs:             资料写入压缩文件。
gzread:             压缩文件读出指定长度字符串。
gzrewind:           重设压缩文件指针。
gzseek:             设压缩文件指针至指定处。
gztell:             取得压缩文件指针处。
gzwrite:            资料写入压缩文件。
header:             送出 HTTP 协议的标头到浏览器
HexDec:             十六进位转十进位。
htmlentities:       将所有的字符都转成 HTML 字符串。
htmlspecialchars:   将特殊字符转成 HTML 格式。
hw_Children:        取得子类代码。
hw_ChildrenObj:     取得子类的类记录。
hw_Close:           关闭 Hyperwave 连接。
hw_Connect:         连上 Hyperwave 服务器。
hw_Cp:              复制类。
hw_Deleteobject:    删除类。
hw_DocByAnchor:     取得指定锚的文件类代码。
hw_DocByAnchorObj:          取得指定锚的文件类。
hw_DocumentAttributes:      取得指定文件类属性。
hw_DocumentBodyTag:         取得指定文件类的文件主体标记。
hw_DocumentContent:         取得指定文件类的内容。
hw_DocumentSetContent:      重设指定文件类的内容。
hw_DocumentSize:            取得文件大小。
hw_EditText:                改动文字档宁。
hw_Error:                   取得错误代码。
hw_ErrorMsg:                取得错误信息。
hw_Free_Document:           释放文件使用的内存。
hw_GetAnchors:              取得文件的链接锚。
hw_GetAnchorsObj:           取得文件的链接锚记录。
hw_GetAndLock:              取得并锁住类。
hw_GetChildColl:            取得子类们的 ID。
hw_GetChildCollObj:         取得子类们的资料。
hw_GetChildDocColl:         取得全部子文件聚集。
hw_GetChildDocCollObj:      取得全部子文件聚集记录。
hw_GetObject:               取得类。
hw_GetObjectByQuery:        搜寻类。
hw_GetObjectByQueryColl:    搜寻聚集类。
hw_GetObjectByQueryCollObj: 搜寻聚集类。
hw_GetObjectByQueryObj:     搜寻类。
hw_GetParents:              取得父类的 ID。
hw_GetParentsObj:           取得父类的资料。
hw_GetRemote:               取得远端文件。
hw_GetRemoteChildren:       取得远端的子文件。
hw_GetSrcByDestObj:         取得指定目的的文件内容。
hw_GetText:                 取得纯文字档宁。
hw_GetUsername:     目前使用者名字。
hw_Identify:        使用者身份确认。
hw_InCollections:   检查类聚集。
hw_Info:            连接信息。
hw_InsColl:         插入聚集。
hw_InsDoc:          插入文件。
hw_InsertDocument:  上传文件。
hw_InsertObject:    插入类记录。
hw_Modifyobject:    修改类记录。
hw_Mv:              移动类。
hw_New_Document:    建立新文件。
hw_Objrec2Array:    类记录转为数组。
hw_OutputDocument:  输出文件。
hw_pConnect:        连上 Hyperwave 服务器。
hw_PipeDocument:    取得文件。
hw_Root:            取得根类代码。
hw_Unlock:          取消锁定。
hw_Who:             列出目前使用者。
ibase_bind:         链接 PHP 变量到 InterBase 参数。
ibase_close:        关闭 InterBase 服务器连接。
ibase_connect:      打开 InterBase 服务器连接。
ibase_execute:      执行 SQL 的指令部分。
ibase_fetch_row:    返回单列的各字段。
ibase_free_query:   释放查询指令占用内存。
ibase_free_result:  释放返回占用内存。
ibase_pconnect:     保持 InterBase 服务器连接。
ibase_prepare:      分析 SQL 语法。
ibase_query:        送出一个 query 字符串。
ibase_timefmt:      配置时间格式。
ifxus_close_slob:   删除 slob 类。
ifxus_create_slob:  建立 slob 类。
ifxus_open_slob:    打开 slob 类。
ifxus_read_slob:    读取指定数目的 slob 类。
ifxus_seek_slob:    配置目前文件或找寻位置。
ifxus_tell_slob:    返回目前文件或找寻位置。
ifxus_write_slob:   将字符串写入 slob 类中。
ifx_affected_rows:  得到 Informix 最后操作影响的列数目。
ifx_blobinfile_mode:配置长位类模式。
ifx_byteasvarchar:  配置位组模式默认值。
ifx_close:          关闭 Informix 服务器连接。
ifx_connect:        打开 Informix 服务器连接。
ifx_copy_blob:      复制长位类。
ifx_create_blob:    建立长位类。
ifx_create_char:    建立字符类。
ifx_do:             执行已准备 query 字符串。
ifx_error:          取得 Informix 最后的错误。
ifx_errormsg:       取得 Informix 最后错误信息。
ifx_fetch_row:      返回单列的各字段。
ifx_fieldproperties:列出 Informix 的 SQL 字段属性。
ifx_fieldtypes:     列出 Informix 的 SQL 字段。
ifx_free_blob:      删除长位类。
ifx_free_char:      删除字符类。
ifx_free_result:    释放返回占用内存。
ifx_free_slob:      删除 slob 类。
ifx_getsqlca:       取得 query 后的 sqlca 信息。
ifx_get_blob:       取得长位类。
ifx_get_char:       取得字符类。
ifx_htmltbl_result: 将 query 返回资料转成 HTML 表格。
ifx_nullformat:     配置空字符模式默认值。
ifx_num_fields:     取得返回字段的数目。
ifx_num_rows:       取得返回列的数目。
ifx_pconnect:       打开 Informix 服务器持续连接。
ifx_prepare:        准备 query 字符串。
ifx_query:          送出一个 query 字符串。
ifx_textasvarchar:  配置文字模式默认值。
ifx_update_blob:    更改长位类。
ifx_update_char:    更改字符类。
ignore_user_abort:  连接中断后程序是否执行。
ImageArc:           画弧线。
ImageChar:          写出横向字符。
ImageCharUp:        写出直式字符。
ImageColorAllocate: 匹配颜色。
ImageColorAt:       取得图中指定点颜色的索引值。
ImageColorClosest:  计算色表中与指定颜色最接近者。
ImageColorExact:    计算色表上指定颜色索引值。
ImageColorResolve:  计算色表上指定或最接近颜色的索引值。
ImageColorSet:      配置色表上指定索引的颜色。
ImageColorsForIndex:    取得色表上指定索引的颜色。
ImageColorsTotal:       计算图的颜色数。
ImageColorTransparent:  指定透明背景色。
ImageCopyResized:       复制新图并调整大小。
ImageCreate:        建立新图。
ImageCreateFromGIF: 取出 GIF 图型。
ImageCreateFromPNG: 取出 PNG 图型。
ImageDashedLine:    绘虚线。
ImageDestroy:       结束图形。
ImageFill:          图形着色。
ImageFilledPolygon: 多边形区域着色。
ImageFilledRectangle:   矩形区域着色。
ImageFillToBorder:  指定颜色区域内着色。
ImageFontHeight:    取得字型的高度。
ImageFontWidth:     取得字型的宽度。
ImageGIF:           建立 GIF 图型。
ImageInterlace:     使用交错式显示与否。
ImageLine:          绘实线。
ImageLoadFont:      载入点阵字型。
ImagePNG:           建立 PNG 图型。
ImagePolygon:       绘多边形。
ImagePSBBox:        计算 PostScript 文字所占区域。
ImagePSEncodeFont:  PostScript 字型转成向量字。
ImagePSFreeFont:    卸下 PostScript 字型。
ImagePSLoadFont:    载入 PostScript 字型。
ImagePSText:        写 PostScript 文字到图中。
ImageRectangle:     绘矩形。
ImageSetPixel:      绘点。
ImageString:        绘横式字符串。
ImageStringUp:      绘直式字符串。
ImageSX:            取得图片的宽度。
ImageSY:            取得图片的高度。
ImageTTFBBox:       计算 TTF 文字所占区域。
ImageTTFText:       写 TTF 文字到图中。
imap_8bit:          将八位转成 qp 编码。
imap_alerts:        所有的警告信息。
imap_append:        附加字符串到指定的邮箱中。
imap_base64:        解 BASE64 编码。
imap_binary:        将八位转成 base64 编码。
imap_body:          读信的内文。
imap_check:         返回邮箱信息。
imap_clearflag_full:清除信件标志。
imap_close:         关闭 IMAP 链接。
imap_createmailbox: 建立新的信箱。
imap_delete:        标记欲删除邮件。
imap_deletemailbox: 删除既有信箱。
imap_errors:        所有的错误信息。
imap_expunge:       删除已标记的邮件。
imap_fetchbody:     从信件内文取出指定部分。
imap_fetchheader:   取得原始标头。
imap_fetchstructure:获取某信件的结构信息。
imap_getmailboxes:  取得全部信件详细信息。
imap_getsubscribed: 列出所有订阅邮箱。
imap_header:        获取某信件的标头信息。
imap_headers:       获取全部信件的标头信息。
imap_last_error:    最后的错误信息。
imap_listmailbox:   获取邮箱列示。
imap_listsubscribed:获取订阅邮箱列示。
imap_mailboxmsginfo:取得目前邮箱的信息。
imap_mail_copy:     复制指定信件到它处邮箱。
imap_mail_move:     移动指定信件到它处邮箱。
imap_msgno:         列出 UID 的连续信件。
imap_num_msg:       取得信件数。
imap_num_recent:    取得新进信件数。
imap_open:          打开 IMAP 链接。
imap_ping:          检查 IMAP 是否连接。
imap_qprint:        将 qp 编码转成八位。
imap_renamemailbox: 更改邮箱名字。
imap_reopen:        重开 IMAP 链接。
imap_rfc822_parse_adrlist:     解析电子邮件位址。
imap_rfc822_write_address:     电子邮件位址标准化。
imap_scanmailbox:   寻找信件有无特定字符串。
imap_search:        搜寻指定标准的信件。
imap_setflag_full:  配置信件标志。
imap_sort:          将信件标头排序。
imap_status:        目前的状态信息。
imap_subscribe:     订阅邮箱。
imap_uid:           取得信件 UID。
imap_undelete:      取消删除邮件标记。
imap_unsubscribe:   取消订阅邮箱。
implode:            将数组变成字符串。
intval:             变量转成整数类型。
iptcparse:          使用 IPTC 模块解析位资料。
isset:              判断变量是否已配置。
is_array:           判断变量类型是否为数组类型。
is_dir:             测试文件是否为目录。
is_double:          判断变量类型是否为倍浮点数类型。
is_executable:      测试文件是否为可执行文件。
is_file:            测试文件是否为正常文件。
is_float:           判断变量类型是否为浮点数类型。
is_int:             判断变量类型是否为整数类型。
is_integer:         判断变量类型是否为长整数类型。
is_link:            测试文件是否为链接文件。
is_long:            判断变量类型是否为长整数类型。
is_object:          判断变量类型是否为类类型。
is_readable:        测试文件是否可读取。
is_real:            判断变量类型是否为实数类型。
is_string:          判断变量类型是否为字符串类型。
is_writeable:       测试文件是否可写入。
JDDayOfWeek:        返回日期在周几。
JDMonthName:        返回月份名。
JDToFrench:         将凯撒日计数转换成为法国共和历法。
JDToGregorian:      将凯撒日计数 (Julian Day Count) 转换成为格里高里历法 (Gregorian date)。
JDToJewish:         将凯撒日计数转换成为犹太历法。
JDToJulian:         将凯撒日计数转换成为凯撒历法。
JewishToJD:         将犹太历法转换成为凯撒日计数。
join:               将数组变成字符串。
JulianToJD:         将凯撒历法转换成为凯撒日计数。
key:                取得数组中的索引资料。
ksort:              将数组的元素依索引排序。
ldap_add:           增加 LDAP 名录的条目。
ldap_bind:          系住 LDAP 目录。
ldap_close:         结束 LDAP 链接。
ldap_connect:       连上 LDAP 服务器。
ldap_count_entries: 搜寻结果的数目。
ldap_delete:        删除指定资源。
ldap_dn2ufn:        将 dn 转成易读的名字。
ldap_explode_dn:    切开 dn 的字段。
ldap_first_attribute: 取得第一笔资源的属性。
ldap_first_entry:   取得第一笔结果代号。
ldap_free_result:   释放返回资料内存。
ldap_get_attributes:取得返回资料的属性。
ldap_get_dn:        取得 DN 值。
ldap_get_entries:   取得全部返回资料。
ldap_get_values:    取得全部返回值。
ldap_list:          列出简表。
ldap_modify:        改变 LDAP 名录的属性。
ldap_mod_add:       增加 LDAP 名录的属性。
ldap_mod_del:       删除 LDAP 名录的属性。
ldap_mod_replace:   新的 LDAP 名录取代旧属性。
ldap_next_attribute:取得返回资料的下笔属性。
ldap_next_entry:    取得下一笔结果代号。
ldap_read:          取得目前的资料属性。
ldap_search:        列出树状简表。
ldap_unbind:        结束 LDAP 链接。
leak:               泄出内存。
link:               建立硬式链接。
linkinfo:           取得链接信息。
list:               列出数组中元素的值。
Log:                自然对数值。
Log10:              10 基底的对数值。
lstat:              取得链接文件相关信息。
ltrim:              去除连续空白。
mail:               寄出电子邮件。
max:                取得最大值。
mcrypt_cbc:         使用 CBC 将资料加/解密。
mcrypt_cfb:         使用 CFB 将资料加/解密。
mcrypt_create_iv:   从随机源将向量初始化。
mcrypt_ecb:         使用 ECB 将资料加/解密。
mcrypt_get_block_size:     取得编码方式的区块大小。
mcrypt_get_cipher_name:    取得编码方式的名称。
mcrypt_get_key_size:       取得编码钥匙大小。
mcrypt_ofb:          使用 OFB 将资料加/解密。
md5:                 计算字符串的 MD5 哈稀。
mhash:               计算哈稀值。
mhash_count:         取得哈稀 ID 的最大值。
mhash_get_block_size:取得哈稀方式的区块大小。
mhash_get_hash_name: 取得哈稀演算法名称。
microtime:           取得目前时间的 UNIX 时间戳记的百万分之一秒值。
min:                 取得最小值。
mkdir:               建立目录。
mktime:              取得 UNIX 时间戳记。
msql:                送出 query 字符串。
msql_affected_rows:  得到 mSQL 最后操作影响的列数目。
msql_close:          关闭 mSQL 数据库连接。
msql_connect:        打开 mSQL 数据库连接。
msql_createdb:       建立一个新的 mSQL 数据库。
msql_create_db:      建立一个新的 mSQL 数据库。
msql_data_seek:      移动内部返回指针。
msql_dbname:         取得目前所在数据库名称。
msql_dropdb:         删除指定的 mSQL 数据库。
msql_drop_db:        删除指定的 mSQL 数据库。
msql_error:          取得最后错误信息。
msql_fetch_array:    返回数组资料。
msql_fetch_field:    取得字段信息。
msql_fetch_object:   返回类资料。
msql_fetch_row:      返回单列的各字段。
msql_fieldflags:     获得字段的标志。
msql_fieldlen:       获得字段的长度。
msql_fieldname:      返回指定字段的名称。
msql_fieldtable:     获得字段的资料表 (table) 名称。
msql_fieldtype:      获得字段的类型。
msql_field_seek:     配置指针到返回值的某字段。
msql_freeresult:     释放返回占用内存。
msql_free_result:    释放返回占用内存。
msql_listdbs:        列出可用数据库 (database)。
msql_listfields:     列出指定资料表的字段 (field)。
msql_listtables:     列出指定数据库的资料表 (table)。
msql_list_dbs:       列出可用数据库 (database)。
msql_list_fields:    列出指定资料表的字段 (field)。
msql_list_tables:    列出指定数据库的资料表 (table)。
msql_numfields:      取得返回字段的数目。
msql_numrows:        取得返回列的数目。
msql_num_fields:     取得返回字段的数目。
msql_num_rows:       取得返回列的数目。
msql_pconnect:       打开 mSQL 服务器持续连接。
msql_query:          送出一个 query 字符串。
msql_regcase:        将字符串逐字返回大小写字符。
msql_result:         取得查询 (query) 的结果。
msql_selectdb:       选择一个数据库。
msql_select_db:      选择一个数据库。
msql_tablename:      返回指定资料表的名称。
mssql_affected_rows: 取得最后 query 影响的列数。
mssql_close:         关闭与数据库的连接。       参数：(mysql_connect('localhost', $user, $passwd))
mssql_connect:       连上数据库。
mssql_data_seek:     移动列指针。
mssql_fetch_array:   返回数组资料。
mssql_fetch_field:   取得字段信息。
mssql_fetch_object:  返回类资料。
mssql_fetch_row:     返回单列的各字段。
mssql_field_seek:    配置指针到返回值的某字段。
mssql_free_result:   释放返回占用内存。
mssql_num_fields:    取得返回字段的数目。
mssql_num_rows:      取得返回列的数目。
mssql_pconnect:      打开 MS SQL 服务器持续连接。
mssql_query:         送出一个 query 字符串。
mssql_result:        取得查询 (query) 的结果。
mssql_select_db:     选择一个数据库。
mt_getrandmax:       随机数的最大值。
mt_rand:             取得随机数值。
mt_srand:            配置随机数种子。
mysql_affected_rows: 得到 MySQL 最后操作影响的列数目。
mysql_close:         关闭 MySQL 服务器连接。
mysql_connect:       打开 MySQL 服务器连接。    参数：('localhost', $user, $passwd)
mysql_create_db:     建立一个 MySQL 新数据库。
mysql_data_seek:     移动内部返回指针。
mysql_db_query:      送查询字符串 (query) 到 MySQL 数据库。
mysql_drop_db:       移除数据库。
mysql_errno():       返回错误信息代码。
mysql_error:         返回错误信息。
mysql_fetch_array:   返回数组资料。   参数：(mysql_query($query语句), MYSQL_ASSOC))
mysql_fetch_field:   取得字段信息。
mysql_fetch_lengths: 返回单列各栏资料最大长度。
mysql_fetch_object:  返回类资料。
mysql_fetch_row:     返回单列的各字段。
mysql_field_flags:   获得目前字段的标志。
mysql_field_len:     获得目前字段的长度。
mysql_field_name:    返回指定字段的名称。
mysql_field_seek:    配置指针到返回值的某字段。
mysql_field_table:   获得目前字段的资料表 (table) 名称。
mysql_field_type:    获得目前字段的类型。
mysql_free_result:   释放返回占用内存。
mysql_insert_id:     返回最后一次使用 INSERT 指令的 ID。
mysql_list_dbs:      列出 MySQL 服务器可用的数据库 (database)。
mysql_list_fields:   列出指定资料表的字段 (field)。
mysql_list_tables:   列出指定数据库的资料表 (table)。
mysql_num_fields:    取得返回字段的数目。
mysql_num_rows:      取得返回列的数目。
mysql_pconnect:      打开 MySQL 服务器持续连接。
mysql_query:         送出一个 query 字符串。
mysql_result:        取得查询 (query) 的结果。
mysql_select_db:     选择一个数据库。          参数：($db) //数据库名，String类型
mysql_tablename:     取得资料表名称。
next:                将数组的内部指针向后移动。
nl2br:               将换行字符转成 <br>。
number_format:       格式化数字字符串。
OCIBindByName:          让动态 SQL 可使用 PHP 变量。
OCIColumnIsNULL:        测试返回行是否为空的。
OCIColumnSize:          取得字段类型的大小。
OCICommit:              将 Oracle 的交易处理付诸实行。
OCIDefineByName:        让 SELECT 指令可使用 PHP 变量。
OCIExecute:             执行 Oracle 的指令部分。
OCIFetch:               取得返回资料的一列 (row)。
OCIFetchInto:           取回 Oracle 资料放入数组。
OCILogOff:              关闭与 Oracle 的链接。
OCILogon:               打开与 Oracle 的链接。
OCINewDescriptor:       初始新的 LOB/FILE 描述。
OCINumRows:             取得受影响字段的数目。
OCIParse:               分析 SQL 语法。
OCIResult:              从目前列 (row) 的资料取得一栏 (column)。
OCIRollback:            撤消当前交易。
OctDec:                 八进位转十进位。
odbc_autocommit:        开关自动改动功能。
odbc_binmode:           配置二进位资料处理方式。
odbc_close:             关闭 ODBC 链接。
odbc_close_all:         关闭所有 ODBC 链接。
odbc_commit:            改动 ODBC 数据库。
odbc_connect:           链接至 ODBC 数据库。
odbc_cursor:            取得游标名。
odbc_do:                执行 SQL 指令。
odbc_exec:              执行 SQL 指令。
odbc_execute:           执行预置 SQL 指令。
odbc_fetch_into:        取得返回的指定列。
odbc_fetch_row:         取得返回一列。
odbc_field_len:         取得字段资料长度。
odbc_field_name:        取得字段名称。
odbc_field_type:        取得字段资料类型。
odbc_free_result:       释出返回资料的内存。
odbc_longreadlen:       配置返回栏的最大值。
odbc_num_fields:        取得字段数目。
odbc_num_rows:          取得返回列数目。
odbc_pconnect:          长期链接至 ODBC 数据库。
odbc_prepare:           预置 SQL 指令。
odbc_result:            取得返回资料。
odbc_result_all:        返回 HTML 表格资料。
odbc_rollback:          撤消当前交易。
odbc_setoption:         调整 ODBC 配置。
opendir:                打开目录 handle。
openlog:                打开系统纪录。
Ora_Bind:               链接 PHP 变量到 Oracle 参数。
Ora_Close:              关闭一个 Oracle 的 cursor。
Ora_ColumnName:         得到 Oracle 返回列 (Column) 的名称。
Ora_ColumnSize:         取得字段类型的大小。
Ora_ColumnType:         得到 Oracle 返回列 (Column) 的类型。
Ora_Commit:             将 Oracle 的交易处理付诸实行。
Ora_CommitOff:          关闭自动执行 Oracle 交易改动的功能。
Ora_CommitOn:           打开自动执行 Oracle 交易改动的功能。
Ora_Do:                 快速的 SQL 查询。
Ora_Error:              获得 Oracle 错误信息。
Ora_ErrorCode:          获得 Oracle 错误代码。
Ora_Exec:               执行 Oracle 的指令部分。
Ora_Fetch:              取得返回资料的一列 (row)。
Ora_FetchInto:          取回 Oracle 资料放入数组。
Ora_GetColumn:          从返回列 (row) 的资料取得一栏 (column)。
Ora_Logoff:             结束与 Oracle 的链接。
Ora_Logon:              打开与 Oracle 的链接。
Ora_Numcols:            取得字段的数目。
Ora_Open:               打开 Oracle 的 cursor。
Ora_Parse:              分析 SQL 语法。
Ora_PLogon:             打开与 Oracle 的长期链接。
Ora_Rollback:           撤消当前交易。
Ord:                    返回字符的序数值。
pack:                   压缩资料到位字符串之中。
parse_str:              解析 query 字符串成变量。
parse_url:              解析 URL 字符串。
passthru:               执行外部程序并不加处理输出资料。
pclose:                 关闭文件。
PDF_add_annotation:     加入注释。
PDF_add_outline:        目前页面加入书签。
PDF_arc:                绘弧。
PDF_begin_page:         启始 PDF 文件页面。
PDF_circle:             绘圆。
PDF_clip:               组合所有向量。
PDF_close:              关闭 PDF 文件。
PDF_closepath:               形成封闭的向量形状。
PDF_closepath_fill_stroke:   形成封闭的向量形状沿向量绘线并填满。
PDF_closepath_stroke:        形成封闭的向量形状并沿向量绘线。
PDF_close_image:        关闭图文件。
PDF_continue_text:      输出文字。
PDF_curveto:            绘贝氏曲线。
PDF_endpath:            关闭目前向量。
PDF_end_page:           关闭 PDF 文件页面。
PDF_execute_image:      放置 PDF 文件中图片到指定位置。
PDF_fill:               填满目前的向量。
PDF_fill_stroke:        填满目前的向量并沿向量绘线。
PDF_get_info:           返回文件信息。
PDF_lineto:             绘直线。
PDF_moveto:             配置处理的坐标点。
PDF_open:               建立新的 PDF 文件。
PDF_open_gif:           打开 GIF 图文件。
PDF_open_jpeg:          打开 JPEG 图文件。
PDF_open_memory_image:  打开内存图文件。
PDF_place_image:        放置图片到 PDF 文件指定位置。
PDF_put_image:          放置图片到 PDF 文件。
PDF_rect:               绘长方形。
PDF_restore:            还原环境变量。
PDF_rotate:             旋转类。
PDF_save:               储存环境变量。
PDF_scale:              缩放类。
PDF_setdash:            配置虚线样式。
PDF_setflat:            配置平滑值。
PDF_setgray:            指定绘图的颜色为灰阶并填入。
PDF_setgray_fill:       指定填入的颜色为灰阶。
PDF_setgray_stroke:     指定绘图的颜色为灰阶。
PDF_setlinecap:         配置 linecap 参数。
PDF_setlinejoin:        配置连接参数。
PDF_setlinewidth:       配置线宽。
PDF_setmiterlimit:      配置斜边界限。
PDF_setrgbcolor:        指定绘图的颜色为彩色并填入。
PDF_setrgbcolor_fill:   指定填入的颜色为彩色。
PDF_setrgbcolor_stroke: 指定绘图的颜色为彩色。
PDF_set_char_spacing:   配置字符间距。
PDF_set_duration:       配置二页的切换时间。
PDF_set_font:           配置使用的字型及大小。
PDF_set_horiz_scaling:  配置文字水平间距。
PDF_set_info_author:    配置文件作者。
PDF_set_info_creator:   配置建文件者字符串。
PDF_set_info_keywords:  配置文件的关键字。
PDF_set_info_subject:   配置文件主题。
PDF_set_info_title:     配置文件标题。
PDF_set_leading:        配置行距。
PDF_set_text_matrix:    配置文字矩阵。
PDF_set_text_pos:       配置文字位置。
PDF_set_text_rendering: 配置文字表现方式。
PDF_set_text_rise:      配置文字高度。
PDF_set_transition:     配置页的转换。
PDF_set_word_spacing:   配置字间距。
PDF_show:               输出字符串到 PDF 文件。
PDF_show_xy:            输出字符串到指定坐标。
PDF_stringwidth:        计算字符串的宽度。
PDF_stroke:             沿向量绘线。
PDF_translate:          移动原点。
pfsockopen:             打开网络的 Socket 持续链接。
pg_Close:               关闭 PostgreSQL 服务器连接。
pg_cmdTuples:           取得被 SQL 指令影响的资料笔数。
pg_Connect:             打开 PostgreSQL 服务器连接。
pg_DBname:              取得目前的数据库名称。
pg_ErrorMessage:        返回错误信息。
pg_Exec:                执行 query 指令。
pg_Fetch_Array:         返回数组资料。
pg_Fetch_Object:        返回类资料。
pg_Fetch_Row:           返回单列的各字段。
pg_FieldIsNull:         检查字段是否有资料。
pg_FieldName:           返回指定字段的名称。
pg_FieldNum:            取得指定字段的行数。
pg_FieldPrtLen:         计算可列示的长度。
pg_FieldSize:           计算指定字段的长度。
pg_FieldType:           获得目前字段的类型。
pg_FreeResult:          释放返回占用内存。
pg_GetLastOid:          取得最后的类代码。
pg_Host:                取得连接机器名称。
pg_loclose:             关闭大型类。
pg_locreate:            建立大型类。
pg_loopen:              打开大型类。
pg_loread:              读取大型类。
pg_loreadall:           读取大型类并输出。
pg_lounlink:            删除大型类。
pg_lowrite:             读取大型类。
pg_NumFields:           取得返回字段的数目。
pg_NumRows:             取得返回列的数目。
pg_Options:             取得连接机器选项。
pg_pConnect:            打开 PostgreSQL 服务器持续连接。
pg_Port:                取得连接机器埠号。
pg_Result:              取得查询 (query) 的结果。
pg_tty:                 取得连接机器终端机。
phpinfo():              返回 PHP 所有相关信息。
phpversion:             返回 PHP 版本信息。
pi:                     圆周率。
popen:                  打开文件。
pos:                    返回数组目前的元素。
pow:                    次方。
preg_match:             字符串比对解析。
preg_match_all:         字符串整体比对解析。
preg_replace:           字符串比对解析并取代。
preg_split:             将字符串依指定的规则切开。
prev:                   将数组的内部指针往前移动。
print:                  输出字符串。
printf:                 输出格式化字符串。
putenv:                 配置系统环境变量。
quoted_printable_decode: 将 qp 编码字符串转成 8 位字符串。
QuoteMeta:              加入引用符号。
rand("1111","9999"):    取得随机数值。(产生1111~9999范围内的一个随机数，这范围可自定义)
range:                  建立一个整数范围的数组。
rawurldecode:           从 URL 专用格式字符串还原成普通字符串。
rawurlencode:           将字符串编码成 URL 专用格式。
readdir:                读取目录 handle。
readfile:               输出文件。
readgzfile:             读出压缩文件。
readlink:               返回符号链接 (symbolic link) 目标文件。
recode_file:            记录文件或文件请求到记录中。
recode_string:               记录字符串到记录中。
register_shutdown_function:  定义 PHP 程序执行完成后执行的函数。
rename:                      更改文件名。
reset:                  将数组的指针指到数组第一个元素。
rewind:                 重置开文件的读写位置指针。
rewinddir:              重设目录 handle。
rmdir:                  删除目录。
round:                  四舍五入。
rsort:                  将数组的值由大到小排序。
sem_acquire:            捕获信号。
sem_get:                取得信号代码。
sem_release:            释出信号。
serialize:              储存资料到系统中。
session_decode:         Session 资料解码。
session_destroy:        结束 session。
session_encode:         Session 资料编码。
session_id:             存取目前 session 代号。
session_is_registered:  检查变量是否注册。
session_module_name:    存取目前 session 模块。
session_name:           存取目前 session 名称。
session_register:       注册新的变量。
session_save_path:      存取目前 session 路径。
session_start:          初始 session。
session_unregister:     删除已注册变量。
setcookie:              送出 Cookie 信息到浏览器。
setlocale:              配置地域化信息。
settype:                配置变量类型。
set_file_buffer:        配置文件缓冲区大小。
set_magic_quotes_runtime:   配置 magic_quotes_runtime 值。
set_socket_blocking:    切换搁置与无搁置模式。
set_time_limit:         配置该页最久执行时间。
shm_attach:             打开建立共享内存空间。
shm_detach:             中止共享内存空间链接。
shm_get_var:            取得内存空间中指定的变量。
shm_put_var:            加入或更新内存空间中的变量。
shm_remove:             清除内存空间。
shm_remove_var:         删除内存空间中指定的变量。
shuffle:                将数组的顺序弄混。
similar_text:           计算字符串相似度。
Sin:                    正弦计算。
sizeof:                 获知数组的大小。
sleep:                  暂停执行。
snmpget:                取得指定类识别码。
snmpwalk:               取得所有类。
snmpwalkoid:            取得网络本体树状信息。
snmp_get_quick_print:   取得 UCD 函数库中的 quick_print 值。
snmp_set_quick_print:   配置 UCD 函数库中的 quick_print 值。
solid_close:            关闭 solid 链接。
solid_connect:          链接至 solid 数据库。
solid_exec:             执行 SQL 指令。
solid_fetchrow:         取得返回一列。
solid_fieldname:        取得字段名称。
solid_fieldnum:         取得字段数目。
solid_freeresult:       释出返回资料的内存。
solid_numfields:        取得字段数目。
solid_numrows:          取得返回列数目。
solid_result:           取得返回资料。
sort:                   将数组排序。
soundex:                计算字符串的读音值
split:                  将字符串依指定的规则切开。
sprintf:                将字符串格式化。
sql_regcase:            将字符串逐字返回大小写字符。
Sqrt:                   开平方根。
srand:                  配置随机数种子。
stat:                   取得文件相关信息。
strchr:                 寻找第一个出现的字符。
strcmp:                 字符串比较。
strcspn:                不同字符串的长度。
strftime:               将服务器的时间本地格式化。
StripSlashes:           去掉反斜线字符。
strip_tags:             去掉 HTML 及 PHP 的标记。
strlen:                 取得字符串长度。
strpos:                 寻找字符串中某字符最先出现处。
strrchr:                取得某字符最后出现处起的字符串。
strrev:                 颠倒字符串。
strrpos:                寻找字符串中某字符最后出现处。
strspn:                 找出某字符串落在另一字符串遮罩的数目。
strstr:                 返回字符串中某字符串开始处至结束的字符串。
strtok:                 切开字符串。
strtolower:             字符串全转为小写。
strtoupper:             字符串全转为大写。
strtr:                  转换某些字符。
strval:                 将变量转成字符串类型。
str_replace:            字符串取代。
substr:                 取部份字符串。
sybase_affected_rows:   取得最后 query 影响的列数。
sybase_close:           关闭与数据库的连接。
sybase_connect:         连上数据库。
sybase_data_seek:       移动列指针。
sybase_fetch_array:     返回数组资料。
sybase_fetch_field:     取得字段信息。
sybase_fetch_object:    返回类资料。
sybase_fetch_row:       返回单列的各字段。
sybase_field_seek:      配置指针到返回值的某字段。
sybase_free_result:     释放返回占用内存。
sybase_num_fields:      取得返回字段的数目。
sybase_num_rows:        取得返回列的数目。
sybase_pconnect:        打开服务器持续连接。
sybase_query:           送出一个 query 字符串。
sybase_result:          取得查询 (query) 的结果。
sybase_select_db:       选择一个数据库。
symlink:                建立符号链接 (symbolic link)。
syslog:                 纪录至系统纪录。
system:                 执行外部程序并显示输出资料。
Tan:                    正切计算。
tempnam:                建立只一的临时文件。
time():                 取得目前时间的 UNIX 时间戳记。
touch:                  配置最后修改时间。
trim:                   截去字符串首尾的空格。
uasort:                 将数组依使用者自定的函数排序。
ucfirst:                将字符串第一个字符改大写。
ucwords:                将字符串每个字第一个字母改大写。
uksort:                 将数组的索引依使用者自定的函数排序。
umask:                  改变目前的文件属性遮罩 umask。
uniqid:                 产生只一的值。
unlink:                 删除文件。
unpack:                 解压缩位字符串资料。
unserialize:            取出系统资料。
unset:                  删除变量。
urldecode:              还原 URL 编码字符串。
urlencode:              将字符串以 URL 编码。
usleep:                 暂停执行。
usort:                  将数组的值依使用者自定的函数排序。
utf8_decode:            将 UTF-8 码转成 ISO-8859-1 码。
utf8_encode:            将 ISO-8859-1 码转成 UTF-8 码。
virtual:                完成apache服务器的子请求 (sub-request)。
vm_addalias:            加入新别名。
vm_adduser:             加入新使用者。
vm_delalias:            删除别名。
vm_deluser:             删除使用者。
vm_passwd:              改变使用者密码。
wddx_add_vars:                           将 WDDX 封包连续化。
wddx_deserialize:                        将 WDDX 封包解连续化。
wddx_packet_end:                         结束的 WDDX 封包。
wddx_packet_start:                       开始新的 WDDX 封包。
wddx_serialize_value:                    将单一值连续化。
wddx_serialize_vars:                     将多值连续化。
xml_error_string:                        取得 XML 错误字符串。
xml_get_current_byte_index:              取得目前解析为第几个位组。
xml_get_current_column_number:           获知目前解析的第几字段。
xml_get_current_line_number:             取得目前解析的行号。
xml_get_error_code:                      取得 XML 错误码。
xml_parse:                               解析 XML 文件。
xml_parser_create:                       初始 XML 解析器。
xml_parser_free:                         释放解析占用的内存。
xml_parser_get_option:                   取得解析使用的选项。
xml_parser_set_option:                   配置解析使用的选项。
xml_set_character_data_handler:          建立字符资料标头。
xml_set_default_handler:                 建立默认标头。
xml_set_element_handler:                 配置元素的标头。
xml_set_external_entity_ref_handler:     配置外部实体参引的标头。
xml_set_notation_decl_handler:           配置记法宣告的标头。
xml_set_object:                          使 XML 解析器用类。
xml_set_processing_instruction_handler:  建立处理指令标头。
xml_set_unparsed_entity_decl_handler:    配置未解析实体宣告的标头。
yp_errno:                                取得先前 YP 操作的错误码。
yp_err_string:                           取得先前 YP 操作的错误字符串。
yp_first:                                返回 map 上第一笔符合的资料。
yp_get_default_domain:                   取得机器的 Domain。
yp_master:                               取得 NIS 的 Master。
yp_match:                                取得指定资料。
yp_next:                                 指定 map 的下笔资料。
yp_order:                                返回 map 的序数。






