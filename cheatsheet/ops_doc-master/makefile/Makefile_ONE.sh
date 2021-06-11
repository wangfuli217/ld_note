#一、MAKE中的自动变量：
    $@: 表示target的名字
    $%: 仅当目标是函数库文件中，表示规则中的目标成员名。例如，如果一个目标是"foo.a(bar.o)"，那么，"$%"就是"bar.o"，"$@"就是 "foo.a"。
    $<: 表示第一个依赖条件的名字
    $?: 表示所有比target更新的依赖条件的名字列表
    $^: 表示所有依赖条件的名字，同时去除依赖列表中重复的条件
    $+: 同$^的功能基本相同，但是他并不去除依赖列表中的重复条件
    自动变量的另外一类扩展为,其中D为directory,F为File
    $(@D): 如果$@为/sbin/ifconfig 那么$(@D)为sbin
    $(@F): 如果$@为/sbin/ifconfig 那么$(@F)为ifconfig
    其他自动变量均依此类推.

二、虚拟路径：
    VPATH=variables (这里VPATH是内部变量)
    vpath pattern directory-list (这里vpath是内部指令)

    表示make搜寻target和prerequisite的目录，但是命令部分不会利用虚拟目录，他可以包含一组以空格分开的目录列表。
    VPATH=include src
    vpath %.c src1 src2    (目录可以有多个，模式只能有一个)
    vpath %.h include

三、后缀规则：
    .SUFFIXES: .out .a .ln .o .c .cc .C .cpp .p .f .F .r .y .l 以上是后缀规则中的缺省内置规则。
    .SUFFIXES: .pdf .fo .html .xml，表示自定义的后缀规则。
    .SUFFIXES: 如果没有定义任何必要条件，则表示打算删除所有的缺省后缀规则。
   
    .o.cpp:
        g++ -I ./include -c $< -o $@
    等效于
    %.o: %.cpp
        g++ -I ./include -c $< -o $@

四、常用命令行选项：

    make -n = --just-print         只是显示命令，但并不真正执行他们，方便用于调试
    make -f = --file                    可以灵性制定makefile的名字
    make -C = --directory          指出makefile的执行目录
    make -s = --silent               所有的命令都不显示
    make -i = --ignore-errors     忽略命令中失败的命令，仍然继续执行
    make -B = --always-make    认为所有的目标都需要更新（重编译）。
    make -e = --environment-overrides 指明环境变量的值覆盖makefile中定义的变量的值。
    make -h = --help
    make -I = --include-dir         指定一个被包含makefile的搜索目标。可以使用多个“-I”参数来指定多个目录
    make -r = --no-builtin-rule   禁止make使用任何隐含规则
    make -v = --version
    make -w = --print-directory  输出运行makefile之前和之后的信息。这个参数对于跟踪嵌套式调用make时很有用。
    make -o = --old-file             不重新生成的指定的<file>，即使这个目标的依赖文件新于它。
