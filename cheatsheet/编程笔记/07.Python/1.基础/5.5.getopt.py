    getopt模块是老派的命令行选项解析器, 兼容Unix函数getopt(). 
它解析一个参数序列, 如sys.argv, 返回(option, argument)对和其他非选项的参数序列.
支持的选项语法包括:
    -a
    -bval
    -b val
    –noarg
    –witharg=val
    –witharg val
    
函数参数
    getopt函数可带三个参数:
    第一个参数是待解析的参数序列, 它通常来自sys.argv[1:](忽略sys.arg[0], 因为它是程序名字).
    第二个参数是选项定义字符串用于指示单个字符选项. 如果一个选项需要一个参数, 那么选项字符之后会跟着个冒号. ## 这个冒号代表该选项的值.
    第三个参数, 如果使用的话, 应该是一个长类型选项名字序列. 长类型选项包含多个字符, 如–noarg或–witharg. 序列中的选项名字不应该包含前缀符’-‘. 如果任何一个长选项需要一个参数, 那么它需要后缀符”=”.
    短形式和长形式选项可以在一个调用中结合起来定义.
    
短形式选项
    如果一个程序需要带2个选项, -a和-b, b选项需要一个参数, 那么值应为”ab:”.
    print getopt.getopt(['-a', '-bval', '-c', 'val'], 'ab:c:')
    $ python getopt_short.py
    ([('-a', ''), ('-b', 'val'), ('-c', 'val')], [])
    
长形式选项
    如果程序带2个选项, -noarg和-witharg, 其参数序列应为[ ‘noarg’, ‘witharg=’ ].
    print getopt.getopt([ '--noarg', '--witharg', 'val', '--witharg2=another' ],'',[ 'noarg', 'witharg=', 'witharg2=' ])
    $ python getopt_long.py
    ([('--noarg', ''), ('--witharg', 'val'), ('--witharg2', 'another')], [])
    
接下来一个复杂点的例子, 它带5个选项: -o, -v, –output, –verbose, 和 –version. 选项-o, –output和–version需要携带参数.
    import getopt
    import sys
    
    version = '1.0'
    verbose = False
    output_filename = 'default.out'
    
    print 'ARGV :', sys.argv[1:]
    
    options, remainder = getopt.getopt(sys.argv[1:], 'o:v', ['output=',
                                        'verbose',
                                        'version=',
                        ])
    print 'OPTIONS :', options
    
    for opt, arg in options:
        if opt in ('-o', '--output'):
            output_filename = arg
        elif opt in ('-v', '--verbose'):
            verbose = True
        elif opt == '--version':
            version = arg
    
    print 'VERSION :', version
    print 'VERBOSE :', verbose
    print 'OUTPUT :', output_filename
    print 'REMAINING :', remainder
    
    
# python ./getopt_example.py
# python ./getopt_example.py -o foo
# python ./getopt_example.py -ofoo
# python ./getopt_example.py --output foo
# python ./getopt_example.py --output=foo

长形式选项的缩写
    对于长形式的选项, 我们可以不必全部拼写出来, 而只要提供一个唯一的前缀以确定到底是哪个选项即可:
    # python ./getopt_example.py --o foo
    如果唯一前缀不存在, 则会有抛出异常.
        # python ./getopt_example.py --ver 2.0
        
选项解析过程会在遇到第一个非选项参数之后马上停止.
    # python ./getopt_example.py -v not_an_option --output foo
    
    
GNU风格的选项解析
    gnu_getopt()函数允许选项和非选项参数以任意顺序混合在命令行中.
    import getopt
    import sys
    
    version = '1.0'
    verbose = False
    output_filename = 'default.out'
    
    print 'ARGV      :', sys.argv[1:]
    
    options, remainder = getopt.gnu_getopt(sys.argv[1:], 'o:v',
                ['output=',
                    'verbose',
                    'version=',
                    ])
    
    print 'OPTIONS   :', options
    
    for opt, arg in options:
        if opt in ('-o', '--output'):
            output_filename = arg
        elif opt in ('-v', '--verbose'):
            verbose = True
        elif opt == '--version':
            version = arg
    
    print 'VERSION   :', version
    print 'VERBOSE   :', verbose
    print 'OUTPUT    :', output_filename
    print 'REMAINING :', remainder
    
    输出结果如下:
    
    $ python ./getopt_gnu.py -v not_an_option --output foo

        