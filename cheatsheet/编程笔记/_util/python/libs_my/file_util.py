#!python
# -*- coding:utf-8 -*-
'''
Created on 2014/9/25
Updated on 2016/2/16
@author: Holemar

本模块专门处理文件用
'''
import os

__all__=('get_last_lines', 'remove')

def get_last_lines(file_path, num=1):
    '''
    @summary: 获取文件的最后几行
    @param {string} file_path: 要读取的文件路径
    @param {int} num: 要读取的行数(默认读取最后一行)
    @return {string | list<string>}: 最后几行内容的字符串列表(如果是只读取最后一行,则返回那一行字符串)
    '''
    blk_size_max = 4096
    n_lines = []
    with open(file_path, 'rb') as fp:
        fp.seek(0, os.SEEK_END)
        cur_pos = fp.tell()
        while cur_pos > 0 and len(n_lines) < num:
            blk_size = min(blk_size_max, cur_pos)
            fp.seek(cur_pos - blk_size, os.SEEK_SET)
            blk_data = fp.read(blk_size)
            assert len(blk_data) == blk_size
            lines = blk_data.split('\n')

            # adjust cur_pos
            if len(lines) <= 2:
                if len(lines[1]) > 0:
                    n_lines[0:0] = lines[1:]
                    cur_pos -= (blk_size - len(lines[0]))
                else:
                    n_lines[0:0] = lines[0:]
                    cur_pos -= blk_size
            elif len(lines) > 1 and len(lines[0]) > 0:
                n_lines[0:0] = lines[1:]
                cur_pos -= (blk_size - len(lines[0]))
            else:
                n_lines[0:0] = lines
                cur_pos -= blk_size
            fp.seek(cur_pos, os.SEEK_SET)
        fp.close()
    # 最后一行如果是空值，则删掉
    if len(n_lines) > 0 and len(n_lines[-1]) == 0:
        del n_lines[-1]
    # 返回内容
    res = n_lines[-num:]
    if num == 1 and len(res) == 1:
        res = res[0]
    return res

def remove(file_path):
    '''
    @summary: 删除文件
    @param {string} file_path: 要删除的文件路径
    '''
    file_path = os.path.abspath(file_path)
    if os.path.isfile(file_path):
        try:
            os.remove(file_path) # 不知道什么原因，这句会报错
        except:
            os.popen('del /q /f "%s"' % file_path)

def clear(file_path):
    '''
    @summary: 清空文件
    @param {string} file_path: 要删除的文件路径
    '''
    file_path = os.path.abspath(file_path)
    if os.path.isfile(file_path):
        try:
            open(file_path, mode="w").close()
        except:
            os.popen('echo""> "%s"' % file_path)
