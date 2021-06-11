https://msdn.microsoft.com/en-us/windows/f0151s4x(v=vs.85).aspx

中文版
https://msdn.microsoft.com/zh-cn/library/d86zahxz(v=vs.120).aspx
https://msdn.microsoft.com/zh-cn/library/f0151s4x.aspx

    每个 strcoll 和 wcscoll 函数根据正在使用区域设置的代码页的 LC_COLLATE 类别设置比较两个字符串。 
每个 _mbscoll 函数根据正在使用的多字节代码页) 来比较这两个字符串。 只有在当前代码页中的字符集
排序和字典字符存在差异时， coll 函数才能使用，这些差异是字符串比较感兴趣的。 使用对应的 cmp 
函数仅测试字符串相等性。

strcoll 函数

SBCS        Unicode     MBCS        说明
strcoll     wcscoll     _mbscoll    排列两个字符串
_stricoll   _wcsicoll   _mbsicoll   排列两字符串 (不区分大小写)
_strncoll   _wcsncoll   _mbsncoll   比较两个字符串的第一个 count 字符
_strnicoll  _wcsnicoll  _mbsnicoll  比较两个字符串的第一个count字符 (不区分大小写) 

    单字节字符 (SBCS) 生成这些函数 (strcoll、stricoll、_strncoll和 _strnicoll) 将根据当前区域设置的 LC_COLLATE 
类别设置比较 string1 和 string2。 这些函数与 strcmp 函数对应的不同因为 strcoll 函数使用区域设置提供排序
序列的代码页的信息。 对于字符串比较。字符集顺序和字典的字符顺序不同的区域设置，应使用 strcoll 函数而不是
相应的 strcmp 函数。 有关LC_COLLATE的详细信息, 请参阅 setlocale。

    对于某些代码页和对应的字符集，该字符集的字符序列可能与字典字符排序不同。 在“C”区域设置，这不是用例：
ASCII 字符集中的字符排序与字符的字典排序相同。 但是，在某些欧洲代码页中，例如，在字符集中，字符“a”(值 0x61) 
位于字符“ä”(值 0xE4)之前，但是，在字典序列中，字符“ä”在字符"a"之前。 若要执行一个字典将在此类实例，
使用 strcoll 而不是 strcmp。 或者，可以使用在原始字符串的 strxfrm，然后对结果字符串使用 strcmp。

    strcoll 、stricoll、_strncoll和 _strnicoll 按正在使用区域设置的代码页自动处理多字节字符字符串，就像它们的
宽字符 (Unicode) 复制。 这些函数对多字节字符 (MBCS) 版本，但是，根据正在使用的多字节代码页排列基于基本字符类型
的字符串。

    由于 coll函数按字典顺序校对字符串的比较，而 cmp 函数简单地测试字符串的相等，coll 函数执行起来比cmp的相关
版本慢。 因此，coll函数只能使用在字符集顺序和当前代码页的字典字符顺序存在区别时，且该区别引起了字符串比较的不同。
