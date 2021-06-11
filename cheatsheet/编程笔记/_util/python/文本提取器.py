# -*- coding: cp936 -*-
#程序会自动提取程序所在目录下的所有后缀为x的纯文本格式的文件，并将在此目录下创建te_xt.txt收集文本。
import fileinput,sys
def lookup_file(x):
    #x必须为字符串
    import os,re,sys
    pat=r'.+\.%s'%x
    rootdir=sys.path[0]
    path=sys.argv[0]
    basename=os.path.basename(path)
    #得到自身文件名
    files=[]

    for parent,dirnames,filenames in os.walk(rootdir):
    #os.walk会返回一个三元组，文件名是这个三元组中第三个元素
        for filename in filenames:
            if re.search(pat,filename) and filename!=basename:
                files.append(filename)
                #找出脚本所在目录下的所有后缀为x的文件(不包含自身)

    return files


try:
    print'******Note: This program only supports plain text format.******'
    key=raw_input("Input the suffix(Eg:txt):")
    key=str(key)
    f=open(sys.path[0]+r'\te_xt.txt','w')
    filename=''
    n=0
    for line in fileinput.input(lookup_file(key)):
        filename1=fileinput.filename()
        if filename1 != filename:
            print(str(n)+" files processed.")
            n=n+1
            filename=filename1
            f.write('=====================*'+filename+'*=====================\n')
            f.write('')
        f.write(line)
finally:f.close()





