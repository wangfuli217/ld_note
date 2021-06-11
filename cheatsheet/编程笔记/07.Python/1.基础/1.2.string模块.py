string.digits # 十进制数
string.hexdigits # 十六进制数
string.octdigits # 八进制数
string.letters # 英文字母
string.lowercase # 小写英文字母
string.uppercase # 大写英文字母
string.printable # 可输出在屏幕上的字符
string.punctuation # ASCII符号
string.whitespace


string.atof(s) # 将字符串转为浮点型数字
string.atoi(s, base=10) # 将字符串s转为整型数字, base指定数字的进制, 默认为十进制
string.capwords(s, sep=' ') # 将字符串中开头和sep后面的字母变成大写
string.maketrans(s, r) # 创建一个s到r的字典, 可以使用字符串对象的translate()方法来使用
