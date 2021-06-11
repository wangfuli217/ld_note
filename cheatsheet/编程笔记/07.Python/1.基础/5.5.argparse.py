使用argparse模块

import argparse
parser = argparse.ArgumentParser(description='Search some files')   #命令描述

parser.add_argument(dest='filenames',metavar='filename', nargs='*') #参数存放在dest中, metavar 参数被用来生成帮助信息

parser.add_argument('-p', '--pat',metavar='pattern', required=True,
                    dest='patterns', action='append',               # action='append'用于将多个值合并
                    help='text pattern to search for')

parser.add_argument('-v', dest='verbose', action='store_true',      # action='store_true' 用于存放Boolean值
                    help='verbose mode')

parser.add_argument('-o', dest='outfile', action='store',           # action='store' 用于存放字符串
                    help='output file')

parser.add_argument('--speed', dest='speed', action='store',
                    choices={'slow','fast'}, default='slow',        # choices表示只能取设置的值. default表示默认值
                    help='search speed')

args = parser.parse_args()

# Output the collected arguments
print(args.filenames)
print(args.patterns)
print(args.verbose)
print(args.outfile)
print(args.speed)

# 调用一
bash % python3 search.py -h

usage: search.py [-h] [-p pattern] [-v] [-o OUTFILE] [--speed {slow,fast}]
			[filename [filename ...]]

Search some files

positional arguments:
	filename

optional arguments:
	-h, --help show this help message and exit
	-p pattern, --pat pattern
	text pattern to search for
	-v verbose mode
	-o OUTFILE output file
	--speed {slow,fast} search speed

# 调用二
bash % python3 search.py foo.txt bar.txt
usage: search.py [-h] -p pattern [-v] [-o OUTFILE] [--speed {fast,slow}]
		[filename [filename ...]]

search.py: error: the following arguments are required: -p/--pat

# 调用三
bash % python3 search.py -v -p spam --pat=eggs foo.txt bar.txt
filenames = ['foo.txt', 'bar.txt']
patterns = ['spam', 'eggs']
verbose = True
outfile = None
speed = slow

# 调用四
bash % python3 search.py -v -p spam --pat=eggs foo.txt bar.txt -o results
filenames = ['foo.txt', 'bar.txt']
patterns = ['spam', 'eggs']
verbose = True
outfile = results
speed = slow

# 调用五
bash % python3 search.py -v -p spam --pat=eggs foo.txt bar.txt -o results --speed=fast
filenames = ['foo.txt', 'bar.txt']
patterns = ['spam', 'eggs']
verbose = True
outfile = results
speed = fast

你可能还会碰到使用optparse 库解析选项的代码。尽管optparse 和argparse 很像，但是后者更先进，因此在新的程序中你应该使用它。



optparse getopt的替代者

1. 提供了getopt没有的功能，如类型转换、自动生成帮助信息等
    import optparse
    
    parser = optparse.OptionParser()
    parser.add_option('-a', action="store_true", default=False)
    parser.add_option('-b', action="store", dest="b")
    parser.add_option('-c', action="store", dest="c", type="int")
    
    print parser.parse_args(['-a', '-bval', '-c', '3'])

2. 对long参数的处理和short参数没有区别：
    import optparse
    
    parser = optparse.OptionParser()
    parser.add_option('--noarg', action="store_true", default=False)
    parser.add_option('--witharg', action="store", dest="witharg")
    parser.add_option('--witharg2', action="store", dest="witharg2", type="int")
    
    print parser.parse_args([ '--noarg', '--witharg', 'val', '--witharg2=3' ])

3. 返回-v参数的出现次数：
    import optparse
    
    parser = optparse.OptionParser()
    parser.add_option('-v', '--verbose', action="count", dest="verbose", default=0)
    
    options, remainder = parser.parse_args(['-v', '--verbose', '-v'])
    print options.verbose