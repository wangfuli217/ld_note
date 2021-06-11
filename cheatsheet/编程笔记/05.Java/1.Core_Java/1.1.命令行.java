
JAVAC的帮助，命令行输入: javac
    编译：javac ＊＊＊.java
        用法: javac <options> <source files>
        用法：javac <选项> <源文件>

    其中，可能的选项包括：
      -g                      生成所有调试信息
      -g:none                 不生成任何调试信息
      -g:{lines,vars,source}  只生成某些调试信息
      -nowarn                 不生成任何警告
      -verbose                输出有关编译器正在执行的操作的消息
      -deprecation            输出使用已过时的 API 的源位置
      -classpath <路径>       指定查找用户类文件和注释处理程序的位置
      -cp <路径>              同上(是 classpath 的缩写)
      -sourcepath <路径>      指定查找输入源文件的位置
      -bootclasspath <路径>   覆盖引导类文件的位置
      -extdirs <目录>         覆盖安装的扩展目录的位置
      -endorseddirs <目录>    覆盖签名的标准路径的位置
      -proc:{none,only}       控制是否执行注释处理和/或编译。
      -processor <class1>[,<class2>,<class3>...]
                              要运行的注释处理程序的名称；绕过默认的搜索进程
      -processorpath <路径>   指定查找注释处理程序的位置
      -d <目录>               指定存放生成的类文件的位置，默认与程序同目录
      -s <目录>               指定存放生成的源文件的位置
      -implicit:{none,class}  指定是否为隐式引用文件生成类文件
      -encoding <编码>        指定源文件使用的字符编码，默认用平台预设的转换码
      -source <版本>          提供与指定版本的源兼容性
      -target <版本>          生成特定 VM 版本的类文件
      -version                版本信息
      -help                   输出标准选项的提要
      -Akey[=value]           传递给注释处理程序的选项
      -X                      输出非标准选项的提要
      -J<标志>                直接将 <标志> 传递给运行时系统
      -nowarn                 设置不警告编译错误


命令行输入:  java
    运行(虚拟机)： java ＊＊＊

    Usage: java [-options] class [args...]
           (to execute a class)
       or  java [-options] -jar jarfile [args...]
           (to execute a jar file)

    where options include:
        -d32          use a 32-bit data model if available
        -d64          use a 64-bit data model if available
        -client       to select the "client" VM
        -server       to select the "server" VM
        -hotspot   is a synonym for the "client" VM [deprecated] The default VM is client.
        -cp <class search path of directories and zip/jar files>
        -classpath <class search path of directories and zip/jar files>
                      A : separated list of directories, JAR archives,
                      and ZIP archives to search for class files.
        -D<name>=<value>          set a system property
        -verbose[:class|gc|jni]   enable verbose output要求编译器显示正在编译的文件和正在加载的类别等。
        -version                  print product version and exit
        -version:<value>          require the specified version to run
        -showversion  print product version and continue
        -jre-restrict-search | -jre-no-restrict-search
                      include/exclude user private JREs in the version search
        -? -help                  print this help message
        -X                        print help on non-standard options
        -ea[:<packagename>...|:<classname>]
        -enableassertions[:<packagename>...|:<classname>]     enable assertions
        -da[:<packagename>...|:<classname>]
        -disableassertions[:<packagename>...|:<classname>]    disable assertions
        -esa | -enablesystemassertions                        enable system assertions
        -dsa | -disablesystemassertions                       disable system assertions
        -agentlib:<libname>[=<options>]
                     load native agent library <libname>, e.g. -agentlib:hprof
                     see also, -agentlib:jdwp=help and -agentlib:hprof=help
        -agentpath:<pathname>[=<options>]     load native agent library by full pathname
        -javaagent:<jarpath>[=<options>]
                     load Java programming language agent, see java.lang.instrument
        -splash:<imagepath>                   show splash screen with specified image




