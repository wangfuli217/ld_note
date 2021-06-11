glob模块是最简单的模块之一，内容非常少。用它可以查找符合特定规则的文件路径名。

查找文件只用到三个匹配符：”*”, “?”, “[]”。
    ”*”匹配0个或多个字符；
    ”?”匹配单个字符；
    ”[]”匹配指定范围内的字符
    
import glob
 
#获取指定目录下的所有图片
print glob.glob(r"E:/Picture/*/*.jpg")
 
#获取上级目录的所有.py文件
print glob.glob(r'../*.py') #相对路径


glob.iglob
获取一个可编历对象，使用它可以逐个获取匹配的文件路径名。
import glob
 
#父目录中的.py文件
f = glob.iglob(r'../*.py')
 
print f #<generator object iglob at 0x00B9FF80>
 
for py in f:
    print py
