

import dis, marshal

def read_pyc(file_path):
    '''可以近似反编译，当然还需要继续整理才可以反编译出来'''
    f = open(file_path, 'rb')
    magic = f.read(4) # =0xD1 0xF2 0x0D 0x0A，4字节，简单校验.pyc的魔数
    mtime = f.read(4) # .pyc对应的源文件的修改时间,时间戳
    code = marshal.load(f)
    dis.dis(code)

read_pyc('demo.pyc')
