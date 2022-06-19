cmakemodules
cmakecommands
cmakepolicies
cmakevars
cmakeprops
cmakecompat

https://cmake.org/cmake/help/latest/manual/cmake.1.html

https://www.cnblogs.com/lidabo/p/13846872.html  # CMake CMake中构建静态库与动态库及其使用
https://www.cnblogs.com/lidabo/p/13794231.html

https://www.cnblogs.com/lsgxeva/p/9454431.html  # CMake 用法导览
https://www.cnblogs.com/lsgxeva/p/9454443.html  # CMake 手册详解  https://www.cnblogs.com/coderfenghc/tag/cmake/
https://www.cnblogs.com/lsgxeva/p/7804607.html  # CMAKE的使用
https://www.cnblogs.com/lsgxeva/p/7804602.html  # cmake 常用变量和常用环境变量查表手册


cmakecommands(){  cat - <<'cmakecommands'
命令就相当于命令行下操作系统提供的各种命令，重要性不言而喻；可以说，这些命令是CMake构建系统的骨架。CMake 2.8.3共有80条命令，分别是：
add_custom_command, add_custom_target, add_definitions, add_dependencies, add_executable, add_library, add_subdirectory, add_test, aux_source_directory, 
break, build_command, 
cmake_minimum_required, cmake_policy, configure_file, create_test_sourcelist, 
define_property, 
else, elseif, enable_language, enable_testing, endforeach, endfunction, endif, endmacro, endwhile, execute_process, export, 
file, find_file, find_library, find_package, find_path, find_program, fltk_wrap_ui, foreach, function, 
get_cmake_property, get_directory_property, get_filename_component, get_property, get_source_file_property, get_target_property, get_test_property, 
if, include, include_directories, include_external_msproject, include_regular_expression, install, 
link_directories, list, load_cache, load_command, 
macro, mark_as_advanced, math, message, 
option, output_required_files, 
project, 
qt_wrap_cpp, qt_wrap_ui, 
remove_definitions, return, 
separate_arguments, set, set_directory_properties, set_property, set_source_files_properties, set_target_properties, set_tests_properties, site_name, source_group, string, 
target_link_libraries, try_compile, try_run, 
unset, 
variable_watch, 
while。
cmakecommands
}


cmake_minimum_required(){  cat - <<'cmake_minimum_required'
cmake_minimum_required  设置一个工程所需要的最低CMake版本。
cmake_minimum_required(VERSION major[.minor[.patch[.tweak]]] [FATAL_ERROR])

如果CMake的当前版本低于指定的版本，它会停止处理工程文件，并报告错误。当指定的版本高于2.4时，它会隐含调用：
cmake_policy(VERSION major[.minor[.patch[.tweak]]])
从而将cmake的策略版本级别设置为指定的版本。当指定的版本是2.4或更低时，这条命令隐含调用：
cmake_policy(VERSION 2.4)
这将会启用对于CMake 2.4及更低版本的兼容性。
FATAL_ERROR选项是可以接受的，但是CMake 2.6及更高的版本会忽略它。如果它被指定，那么CMake 2.4及更低版本将会以错误告终而非仅仅给出个警告。

cmake_minimum_required(VERSION 2.6)  # libubox
cmake_minimum_required(VERSION 3.6)  # libhv

https://github.com/yszheda/wiki/wiki/CMake
CMake : 编译系统生成器
CPack : 包生成器
CTest : 系统检测驱动器
CDash : dashboard收集器
cmake_minimum_required
}

cmake_policy(){  cat - <<'cmake_policy'
cmake_policy  管理CMake的策略设置。
随着CMake的演变，有时为了搞定bug或改善现有特色的实现方法，改变现有的行为是必须的。
CMake的策略机制是在新的CMake版本带来行为上的改变时，用来帮助保持现有项目的构建的一种设计。
每个新的策略（行为改变）被赋予一个"CMP<NNNN>"格式的识别符，其中"<NNNN>"是一个整数索引。
每个策略相关的文档都会描述“旧行为”和“新行为”，以及引入该策略的原因。工程可以设置各种策略来选择期望的行为。
当CMake需要了解要用哪种行为的时候，它会检查由工程指定的一种设置。如果没有可用的设置，工程假定使用“旧行为”，并且会给出警告要求你设置工程的策略。

cmake_policy是用来设置“新行为”或“旧行为”的命令。如果支持单独设置策略，我们鼓励各项目根据CMake的版本来设置策略。
cmake_policy(VERSION major.minor[.patch[.tweak]])
    上述命令指定当前的CMakeLists.txt是为给定版本的CMake书写的。所有在指定的版本或更早的版本中引入的策略会被设置为使用“新行为”。所有在指定的版本之后引入的策略将会变为无效（unset）。该命令有效地为一个指定的CMake版本请求优先采用的行为，并且告知更新的CMake版本给出关于它们新策略的警告。命令中指定的策略版本必须至少是2.4，否则命令会报告一个错误。为了得到支持早于2.4版本的兼容性特性，查阅策略CMP0001的相关文档。
    cmake_policy(SET CMP<NNNN> NEW)
    cmake_policy(SET CMP<NNNN> OLD)
    对于某种给定的策略，该命令要求CMake使用新的或者旧的行为。对于一个指定的策略，那些依赖于旧行为的工程，通过设置策略的状态为OLD，可以禁止策略的警告。或者，用户可以让工程采用新行为，并且设置策略的状态为NEW。
cmake_policy(GET CMP<NNNN> <variable>)
    该命令检查一个给定的策略是否设置为旧行为或新行为。如果策略被设置，输出的变量值会是“OLD”或“NEW”，否则为空。
    CMake将策略设置保存在一个栈结构中，因此，cmake_policy命令产生的改变仅仅影响在栈顶端的元素。在策略栈中的一个新条目由各子路径自动管理，以此保护它的父路径及同层路径的策略设置。CMake也管理通过include()和find_package()命令加载的脚本中新加入的条目，除非调用时指定了NO_POLICY_SCOPE选项（另外可参考CMP0011）。cmake_policy命令提供了一种管理策略栈中自定义条目的接口：
   cmake_policy(PUSH)
   cmake_policy(POP)
    每个PUSH必须有一个配对的POP来去掉撤销改变。这对于临时改变策略设置比较有用。
    函数和宏会在它们被创建的时候记录策略设置，并且在它们被调用的时候使用记录前的策略。如果函数或者宏实现设置了策略，这个变化会通过调用者(caller)一直上传，自动传递到嵌套的最近的策略栈条目。
cmake_policy
}

configure_file(){  cat - <<'configure_file'
configure_file: 将一份文件拷贝到另一个位置并修改它的内容。
configure_file(<input> <output>
               [COPYONLY] [ESCAPE_QUOTES] [@ONLY])
               
将文件<input>拷贝到<output>然后替换文件内容中引用到的变量值。
如果<input>是相对路径，它被评估的基础路径是当前源码路径。<input>必须是一个文件，而不是个路径。
如果<output>是一个相对路径，它被评估的基础路径是当前二进制文件路径。
如果<output>是一个已有的路径，那么输入文件将会以它原来的名字放到那个路径下。

该命令替换掉在输入文件中，以${VAR}格式或@VAR@格式引用的任意变量，如同它们的值是由CMake确定的一样。 
如果一个变量还未定义，它会被替换为空。如果指定了COPYONLY选项，那么变量就不会展开。
如果指定了ESCAPE_QUOTES选项，那么所有被替换的变量将会按照C语言的规则被转义。该文件将会以CMake变量的当前值被配置。
如果指定了@ONLY选项，只有@VAR@格式的变量会被替换而${VAR}格式的变量则会被忽略。这对于配置使用${VAR}格式的脚本文件比较有用。

任何类似于#cmakedefine VAR的定义语句将会被替换为#define VAR或者/* #undef VAR */，视CMake中对VAR变量的设置而定。
任何类似于#cmakedefine01 VAR的定义语句将会被替换为#define VAR 1或#define VAR 0，视VAR被评估为TRUE或FALSE而定。

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/hconfig.h.in ${CMAKE_CURRENT_SOURCE_DIR}/hconfig.h)
configure_file
}

create_test_sourcelist(){  cat - <<'create_test_sourcelist'
create_test_sourcelist: 为构建测试程序创建一个测试驱动器和源码列表。
    create_test_sourcelist(sourceListName driverName
                        test1 test2 test3
                        EXTRA_INCLUDE include.h
                        FUNCTION function)
    测试驱动器是一个将很多小的测试代码连接为一个单一的可执行文件的程序。这在为了缩减总的需用空间而用很多大的库文件去构建静态可执行文件的时候，特别有用。
create_test_sourcelist
}

define_property(){  cat - <<'define_property'
define_property: 定义并描述（Document）自定义属性。
    define_property(<GLOBAL | DIRECTORY | TARGET | SOURCE |
                    TEST | VARIABLE | CACHED_VARIABLE>
                    PROPERTY <name> [INHERITED]
                    BRIEF_DOCS <brief-doc> [docs...]
                    FULL_DOCS <full-doc> [docs...])

在一个域（scope）中定义一个可以用set_property和get_property命令访问的属性。这个命令对于把文档和可以通过get_property命令得到的属性名称关联起来非常有用。第一个参数确定了这个属性可以使用的范围。它必须是下列值中的一个：
  GLOBAL    = 与全局命名空间相关联
  DIRECTORY = 与某一个目录相关联
  TARGET    = 与一个目标相关联
  SOURCE    = 与一个源文件相关联
  TEST      = 与一个以add_test命名的测试相关联
  VARIABLE  = 描述（document）一个CMake语言变量
  CACHED_VARIABLE = 描述（document）一个CMake语言缓存变量
  注意，与set_property和get_property不相同，不需要给出实际的作用域；只有作用域的类型才是重要的。PROPERTY选项必须有，它后面紧跟要定义的属性名。如果指定了INHERITED选项，那么如果get_property命令所请求的属性在该作用域中未设置，它会沿着链条向更高的作用域去搜索。DIRECTORY域向上是GLOBAL。TARGET，SOURCE和TEST向上是DIRECTORY。
  BRIEF_DOCS和FULL_DOCS选项后面的参数是和属性相关联的字符串，分别作为变量的简单描述和完整描述。在使用get_property命令时，对应的选项可以获取这些描述信息。
define_property
}


? /usr/bin/cmake -P cmake_install.cmake ? 在Makefile中
? /usr/bin/cmake -DCMAKE_INSTALL_DO_STRIP=1 -P cmake_install.cmake ?  在Makefile中

/usr/bin/cmake -DCMAKE_INSTALL_DO_STRIP=1 -P cmake_install.cmake # CMAKE_INSTALL_DO_STRIP=1 和 cmake_install.cmake
CMAKE_INCLUDE_PATH=/home/include cmake ..   # export CMAKE_INCLUDE_PATH
CMAKE_LIBRARY_PATH=/home/include cmake ..   # export CMAKE_LIBRARY_PATH
cmake -DCMAKE_CXX_COMPILER=xlc -DBUILD_TESTING:BOOL=ON ../foo #CMAKE_CXX_COMPILER=xlc 和 BUILD_TESTING:BOOL=ON

make clean          # 清理工程
make distclean      # cmake不支持

内部构建与外部构建
进入static目录，运行../configure –enable-static;make会在static目录生成wxGTK的静态库。
进入shared目录，运行../configure –enable-shared;make就会在shared目录生成动态库。

外部构建:
    一个最大的好处是，对于原有的工程没有任何影响，所有动作全部发生在编译目录。通过这一点，
也足以说服我们全部采用外部编译方式构建工程。

PROJECT(projectname [CXX] [C] [Java]){
cmake自动创建的环境变量  
PROJECT_BINARY_DIR    projectname_BINARY_DIR    /home/ubuntu/cmake/learning-cmake/hello-world/build
PROJECT_SOURCE_DIR    projectname_SOURCE_DIR    /home/ubuntu/cmake/learning-cmake/hello-world
PROJECT_BINARY_DIR    CMAKE_BINARY_DIR      # 工程的根目录
PROJECT_SOURCE_DIR    CMAKE_SOURCE_DIR      # 运行cmake命令的目录,通常是${PROJECT_SOURCE_DIR}/build
CMAKE_CURRENT_BINARY_DIR                    # CMakelists的根目录
CMAKE_CURRENT_SOURCE_DIR                    # target编译目录
PROJECT_NAME                                # 返回通过PROJECT指令定义的项目名称
指令定义工程名称。并可指定工程支持的语言，支持的语言列表是可以忽略的。
projectname_BINARY_DIR比PROJECT_BINARY_DIR在设计过程中耦合性大些。

作为工程名的HELLO和生成的可执行文件hello是没有任何关系的。
}

SET(VAR [VALUE] [CACHE TYPE DOCSTRING [FORCE]]){
1. SET指令可以用来显式的定义变量即可。
SET(SRC_LIST  main.c)  或 SET(SRC_LIST main.c t1.c t2.c)

SET(LIBS ${LIBS} ${LIBNL_LIBS}) # LIBS为原先SET变量；LIBNL_LIBS也为原先SET变量

}
EXECUTABLE_OUTPUT_PATH(可执行文件输出目录){
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)   # 可执行二进制的输出路径为build/bin

问题是，我应该把这两条指令写在工程的CMakeLists.txt还是src目录下的
CMakeLists.txt，把握一个简单的原则，在哪里ADD_EXECUTABLE或ADD_LIBRARY，
如果需要改变目标存放路径，就在哪里加入上述的定义。
}
LIBRARY_OUTPUT_PATH(中间静态和动态库输出路径){
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)      # 库的输出路径为build/lib

如EXECUTABLE_OUTPUT_PATH描述；
}

INSTALL(目标二进制、动态库、静态库以及文件、目录、脚本){
INSTALL指令用于定义安装规则，安装的内容可以包括目标二进制、动态库、静态库以及文件、目录、脚本等。

INSTALL指令包含了各种安装类型，我们需要一个个分开解释：
DESTDIR # 安装到指定的目录
PREFIX  # 安装到以PREFIX为前缀的目录        CMAKE_INSTALL_PREFIX

DESTDIR=
install:
    mkdir -p $(DESTDIR)/usr/bin
    install -m 755 hello $(DESTDIR)/usr/bin
---------------------------------------
DESTDIR=
PREFIX=/usr
install:
    mkdir -p $(DESTDIR)/$(PREFIX)/bin
    install -m 755 hello $(DESTDIR)/$(PREFIX)/bin
--------------------------------------- 
# 目的地，权限，配置。
# 不能够在cmake中指定文件名的支持重命名
# 静态库，动态库和可执行程序共享TARGETS这个目标。
TARGETS ：ARCHIVE|LIBRARY           # 编译生成的文件，ADD_LIBRARY生成的目标
TARGETS ：RUNTIME                   # 编译生成的文件，为ADD_EXECUTABLE生成的目标
FILES   : README和INSTALL COPYRIGHT # 帮助，安装和版权相关零碎文件
PROGRAMS: 
}

CMAKE_INSTALL_PREFIX(指定安装前缀路径){
CMAKE_INSTALL_PREFIX变量类似于configure  – 脚本的 prefix，常见的使用方法看起来是这个样子：
cmake -DCMAKE_INSTALL_PREFIX=/usr .

# cmake中默认定义了DCMAKE_INSTALL_PREFIX选项用实现--prefix的功能。

如果我没有定义CMAKE_INSTALL_PREFIX会安装到什么地方？你可以尝试以下，
cmake ..;make;make install，
你会发现CMAKE_INSTALL_PREFIX的默认定义是/usr/local
}

INSTALL(目标文件的安装){
目标文件的安装：
        INSTALL(TARGETS targets...
            [[ARCHIVE|LIBRARY|RUNTIME]
                        [DESTINATION <dir>]
                        [PERMISSIONS permissions...]
                        [CONFIGURATIONS
          [Debug|Release|...]]
                        [COMPONENT <component>]
                        [OPTIONAL]
                       ] [...])
1. 参数中的TARGETS后面跟的就是我们通过ADD_EXECUTABLE或者ADD_LIBRARY定义的
目标文件，可能是可执行二进制、动态库、静态库。
2. 目标类型也就相对应的有三种，ARCHIVE特指静态库，LIBRARY特指动态库，RUNTIME
特指可执行目标二进制。
3. DESTINATION定义了安装的路径，如果路径以/开头，那么指的是绝对路径，这时候
CMAKE_INSTALL_PREFIX其实就无效了。如果你希望使用CMAKE_INSTALL_PREFIX来
定义安装路径，就要写成相对路径，即不要以/开头，那么安装后的路径就是
${CMAKE_INSTALL_PREFIX}/<DESTINATION定义的路径>

举个简单的例子：
INSTALL(TARGETS myrun mylib mystaticlib
RUNTIME DESTINATION bin
LIBRARY DESTINATION lib
ARCHIVE DESTINATION libstatic
)
上面的例子会将：
可执行二进制myrun安装到${CMAKE_INSTALL_PREFIX}/bin目录
动态库libmylib安装到${CMAKE_INSTALL_PREFIX}/lib目录
静态库libmystaticlib安装到${CMAKE_INSTALL_PREFIX}/libstatic目录
特别注意的是你不需要关心TARGETS具体生成的路径，只需要写上TARGETS名称就可以
了。
}

INSTALL(普通文件的安装){
普通文件的安装： # 可以对普通安装的文件重命名。
        INSTALL(FILES files... DESTINATION <dir>
            [PERMISSIONS permissions...]
            [CONFIGURATIONS [Debug|Release|...]]
            [COMPONENT <component>]
            [RENAME <name>] [OPTIONAL])
可用于安装一般文件，并可以指定访问权限，文件名是此指令所在路径下的相对路径。
如果默认不定义权限PERMISSIONS，安装后的权限为：
OWNER_WRITE, OWNER_READ,  GROUP_READ,和WORLD_READ，即644权限。
}

INSTALL(非目标文件的可执行程序安装){
非目标文件的可执行程序安装(比如脚本之类)：
        INSTALL(PROGRAMS files... DESTINATION <dir>
            [PERMISSIONS permissions...]
            [CONFIGURATIONS [Debug|Release|...]]
            [COMPONENT <component>]
            [RENAME <name>] [OPTIONAL])
跟上面的FILES指令使用方法一样，唯一的不同是安装后权限为:
OWNER_EXECUTE, GROUP_EXECUTE, 和WORLD_EXECUTE，即755权限。

安装时CMAKE脚本的执行：
INSTALL([[SCRIPT <file>] [CODE <code>]] [...])
SCRIPT参数用于在安装时调用cmake脚本文件（也就是<abc>.cmake文件）
CODE参数用于执行CMAKE指令，必须以双引号括起来。比如：
INSTALL(CODE "MESSAGE(\"Sample install message.\")")
}

INSTALL(目录的安装){
目录的安装：
        INSTALL(DIRECTORY dirs... DESTINATION <dir>
            [FILE_PERMISSIONS permissions...]
            [DIRECTORY_PERMISSIONS permissions...]
            [USE_SOURCE_PERMISSIONS]
            [CONFIGURATIONS [Debug|Release|...]]
            [COMPONENT <component>]
            [[PATTERN <pattern> | REGEX <regex>]
             [EXCLUDE] [PERMISSIONS permissions...]] [...])
这里主要介绍其中的DIRECTORY、PATTERN以及PERMISSIONS参数。
DIRECTORY后面连接的是所在Source目录的相对路径，但务必注意：
abc和abc/有很大的区别。
1.1 如果目录名不以/结尾，那么这个目录将被安装为目标路径下的abc，
1.2 如果目录名以/结尾，代表将这个目录中的内容安装到目标路径，但不包括这个目录本身。
2. PATTERN用于使用正则表达式进行过滤，
3. PERMISSIONS用于指定PATTERN过滤后的文件权限。

INSTALL(DIRECTORY icons scripts/ DESTINATION share/myproj
            PATTERN "CVS" EXCLUDE
            PATTERN "scripts/*"
            PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
                    GROUP_EXECUTE GROUP_READ)
这条指令的执行结果是：
将icons目录安装到<prefix>/share/myproj，将scripts/中的内容安装到
<prefix>/share/myproj
不包含目录名为CVS的目录，对于scripts/*   文件指定权限为OWNER_EXECUTE 
OWNER_WRITE OWNER_READ GROUP_EXECUTE GROUP_READ.
}

INSTALL(安装时CMAKE脚本的执行){
安装时CMAKE脚本的执行：
INSTALL([[SCRIPT <file>] | [CODE <code>]] [...])
1. SCRIPT参数用于在安装时调用cmake脚本文件（也就是<abc>.cmake文件）
2. CODE参数用于执行CMAKE指令，必须以双引号括起来。比如：
INSTALL(CODE "MESSAGE(\"Sample install message.\")")
}

MESSAGE([SEND_ERROR | STATUS | FATAL_ERROR] "message to display" ...){
这个指令用于向终端输出用户定义的信息，包含了三种类型:
SEND_ERROR，产生错误，生成过程被跳过。 # 从CMakeList.txt生成makefile过程中跳出
SATUS ，输出前缀为--的信息。           # 显示
FATAL_ERROR，立即终止所有cmake过程.    # 从cmake构建工程过程中退出
}

ADD_EXECUTABLE(生成可执行文件){

# ADD_EXECUTABLE(hello ${SRC_LIST})
定义了这个工程会生成一个文件名为hello的可执行文件，相关的源文件是SRC_LIST中定义的源文件列表，
}
ADD_LIBRARY(生成静态库和动态库){
指令ADD_LIBRARY
ADD_LIBRARY(libname    [SHARED|STATIC|MODULE]
  [EXCLUDE_FROM_ALL]
        source1 source2 ... sourceN)
你不需要写全libhello.so，只需要填写hello即可，cmake系统会自动为你生成libhello.X
类型有三种:SHARED，动态库 STATIC，静态库; MODULE，在使用dyld的系统有效，如果不支持dyld，则被当作SHARED对待。

# EXCLUDE_FROM_ALL参数的意思是这个库不会被默认构建，除非有其他的组件依赖或者手工构建。

1. 如何通过ADD_LIBRARY指令构建动态库和静态库。
2. 如何通过SET_TARGET_PROPERTIES同时构建同名的动态库和静态库。
3. 如何通过SET_TARGET_PROPERTIES控制动态库版本
}
ADD_LIBRARY(添加静态库){
ADD_LIBRARY(hello STATIC ${LIBHELLO_SRC})

    然后再在build目录进行外部编译，我们会发现，静态库根本没有被构建，仍然只生成了一个动态库。因为hello作为
一个target是不能重名的，所以，静态库构建指令无效。
如果我们把上面的hello修改为hello_static:
ADD_LIBRARY(hello_static STATIC ${LIBHELLO_SRC})
就可以构建一个libhello_static.a的静态库了。

}
add_custom_comand(生成指定的文件（文件组）的生成命令){
    add_custom_command: 增加客制化的构建规则到生成的构建系统中。对于add_custom_command，有两种使用形式。
# 第一种是为了生成输出文件，添加一条自定义命令。
# 在编译时拷贝文件之add_custom_comand 和 add_custom_target
add_custom_command(OUTPUT output1 [output2 ...]
                     COMMAND command1[ARGS] [args1...]
                     [COMMAND command2 [ARGS] [args2...] ...]
                     [MAIN_DEPENDENCYdepend]
                     [DEPENDS[depends...]]
                     [IMPLICIT_DEPENDS<lang1> depend1 ...]
                     [WORKING_DIRECTORYdir]
                     [COMMENT comment] [VERBATIM] [APPEND])

    不要同时在多个相互独立的目标中执行上述命令产生相同的文件，主要是为了防止冲突产生。如果有多条命令，
它们将会按顺序执行。ARGS是为了向后兼容，使用过程中可以忽略。MAIN_DEPENDENCY完全是可选的，

    第二种形式是为某个目标如库或可执行程序添加一个客制命令。这对于要在构建一个目标之前或之后执行一些操作
非常有用。该命令本身会成为目标的一部分，仅在目标本身被构建时才会执行。如果该目标已经构建，命令将不会执行。
 add_custom_command(TARGET target
                     PRE_BUILD | PRE_LINK| POST_BUILD
                     COMMAND command1[ARGS] [args1...]
                     [COMMAND command2[ARGS] [args2...] ...]
                     [WORKING_DIRECTORYdir]
                     [COMMENT comment][VERBATIM])

命令执行的时机由如下参数决定： 
  PRE_BUILD - 命令将会在其他依赖项执行前执行
  PRE_LINK - 命令将会在其他依赖项执行完后执行
  POST_BUILD - 命令将会在目标构建完后执行。
---------------------------------------
add_custom_command(TARGET dbus-1 POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy "$<TARGET_FILE:dbus-1>" "$<TARGET_FILE_DIR:dbus-1>/${CMAKE_SHARED_LIBRARY_PREFIX}dbus-1
${CMAKE_SHARED_LIBRARY_SUFFIX}"
            COMMENT "Create non versioned dbus-1 library for legacy applications"
        )
}
add_custom_target(){
    add_custom_target: 增加一个没有输出的目标，使得它总是被构建。  add_custom_target(Name [ALL] [command1 [args1...]]
                        [COMMAND command2 [args2...] ...]
                        [DEPENDS depend depend depend ... ]
                        [WORKING_DIRECTORY dir]
                        [COMMENT comment] [VERBATIM]
                        [SOURCES src1 [src2...]])
# 在编译时拷贝文件之add_custom_comand 和 add_custom_target
    增加一个指定名字的目标，并执行指定的命令。该目标没有输出文件，总是被认为是过期的，即使是在试图用目标的
名字创建一个文件。使用ADD_CUSTOM_COMMAND命令来创建一个具有依赖项的文件。默认情况下，没有任何目标会依赖该
客制目标。使用ADD_DEPENDENCIES 来添加依赖项或成为别的目标的依赖项。如果指定了ALL选项，那就表明该目标会被
添加到默认的构建目标，使得它每次都被运行。(该命令的名称不能命名为 ALL). 命令和参数都是可选的，如果没有指定，
将会创建一个空目标。如果设置了WORKING_DIRECTORY ，那么该命令将会在指定的目录中运行。如果它是个相对路径，
那它会被解析为相对于当前源码目录对应的构建目录。如果设置了 COMMENT，在构建的时候，该值会被当成信息在执行
该命令之前显示。DEPENDS参数可以是文件和同一目录中的其他客制命令的输出。
    如果指定了VERBATIM， 所有传递给命令的参数将会被适当地转义。建议使用该选项。
    SOURCES选项指定了包含进该客制目标的额外的源文件。即使这些源文件没有构建规则，但是它们会被增加到IDE的
工程文件中以方便编辑。

add_custom_target(check COMMAND ctest -R ^test-.*) # dbus
add_custom_target(help-options
    cmake -LH 
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)     # dbus
add_custom_target(doc 
        COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_BINARY_DIR}/Doxyfile
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    ) # dbus
}

SET_TARGET_PROPERTIES(设置输出的名称){
SET_TARGET_PROPERTIES，其基本语法是：
SET_TARGET_PROPERTIES(target1 target2 ...
              PROPERTIES prop1 value1
              prop2 value2 ...)
    这条指令可以用来设置输出的名称，对于动态库，还可以用来指定动态库版本和API版本。
    在本例中，我们需要作的是向lib/CMakeLists.txt中添加一条：
SET_TARGET_PROPERTIES(hello_static PROPERTIES OUTPUT_NAME "hello")
这样，我们就可以同时得到libhello.so/libhello.a两个库了。
-------------------------------------------------------------------------------
    1. cmake在构建一个新的target时，会尝试清理掉其他使用这个名字的库，因为，在构建libhello.a时，
就会清理掉libhello.so.

SET_TARGET_PROPERTIES(hello PROPERTIES CLEAN_DIRECT_OUTPUT 1)
SET_TARGET_PROPERTIES(hello_static PROPERTIES CLEAN_DIRECT_OUTPUT 1)

CLEAN_DIRECT_OUTPUT：这时候，我们再次进行构建，会发现build/lib目录中同时生成了libhello.so和libhello.a

-------------------------------------------------------------------------------
动态库版本号
libhello.so.1.2
libhello.so ->libhello.so.1
libhello.so.1->libhello.so.1.2

SET_TARGET_PROPERTIES(hello PROPERTIES VERSION 1.2 SOVERSION 1)
VERSION指代动态库版本，SOVERSION指代API版本。
}
GET_TARGET_PROPERTY(获得输出的名称){
GET_TARGET_PROPERTY(VAR target property)
具体用法如下例，我们向lib/CMakeListst.txt中添加：
GET_TARGET_PROPERTY(OUTPUT_VALUE hello_static OUTPUT_NAME)
MESSAGE(STATUS "This is the hello_static OUTPUT_NAME:" ${OUTPUT_VALUE})
}

INCLUDE_DIRECTORIES([AFTER|BEFORE] [SYSTEM] dir1 dir2 ...){

    这条指令可以用来向工程添加多个特定的头文件搜索路径，路径之间用空格分割，如果路径
中包含了空格，可以使用双引号将它括起来，默认的行为是追加到当前的头文件搜索路径的
后面，你可以通过两种方式来进行控制搜索路径添加的方式：
１，CMAKE_INCLUDE_DIRECTORIES_BEFORE，通过SET这个cmake变量为on，可以
将添加的头文件搜索路径放在已有路径的前面。
２，通过AFTER或者BEFORE参数，也可以控制是追加还是置前。
}

LINK_DIRECTORIES(directory1 directory2 ...){
这个指令非常简单，添加非标准的共享库搜索路径，比如，在工程内部同时存在共享库和可
执行二进制，在编译时就需要指定一下这些共享库的路径。这个例子中我们没有用到这个指
令。

如何通过INCLUDE_DIRECTORIES指令加入非标准的头文件搜索路径。
如何通过LINK_DIRECTORIES指令加入非标准的库文件搜索路径。
如果通过TARGET_LINK_LIBRARIES为库或可执行二进制加入库链接。
并解释了如果链接到静态库。
}

TARGET_LINK_LIBRARIES(指定可执行文件链接的动态库){
TARGET_LINK_LIBRARIES(target library1
                      <debug | optimized> library2
                      ...)
这个指令可以用来为target添加需要链接的共享库，本例中是一个可执行文件，但是同样
可以用于为自己编写的共享库添加共享库链接。

TARGET_LINK_LIBRARIES(main libhello.so)   TARGET_LINK_LIBRARIES(main hello)
TARGET_LINK_LIBRARIES(main libhello.a) 
}

CMAKE_INCLUDE_PATH(环境变量,非cmake变量){
务必注意，这两个是环境变量而不是cmake变量。
使用方法是要在bash中用export或者在csh中使用set命令设置或者
CMAKE_INCLUDE_PATH=/home/include cmake ..等方式。

export CMAKE_INCLUDE_PATH=/usr/include/hello
}

CMAKE_LIBRARY_PATH(环境变量,非cmake变量){
务必注意，这两个是环境变量而不是cmake变量。
使用方法是要在bash中用export或者在csh中使用set命令设置或者
CMAKE_LIBRARY_PATH=/home/include cmake ..等方式。
}
FIND_LIBRARY(在指定路径中搜索库名称){}
FIND_PATH(在指定路径中搜索文件名){
FIND_PATH用来在指定路径中搜索文件名。
FIND_PATH(myHeader NAMES hello.h PATHS /usr/include /usr/include/hello)
---------------------------------------
export CMAKE_INCLUDE_PATH=/usr/include/hello
然后在头文件中将INCLUDE_DIRECTORIES(/usr/include/hello)替换为：
FIND_PATH(myHeader hello.h)
IF(myHeader)
INCLUDE_DIRECTORIES(${myHeader})
ENDIF(myHeader)
这里我们没有指定路径，但是，cmake仍然可以帮我们找到hello.h存放的路径，就是因
为我们设置了环境变量CMAKE_INCLUDE_PATH

如果你不使用FIND_PATH，CMAKE_INCLUDE_PATH变量的设置是没有作用的，你不能指
望它会直接为编译器命令添加参数-I<CMAKE_INCLUDE_PATH>。
以此为例，CMAKE_LIBRARY_PATH可以用在FIND_LIBRARY中。
同样，因为这些变量直接为FIND_指令所使用，所以所有使用FIND_指令的cmake模块都会受益。
}

add_subdirectory(){ cat - <<'add_subdirectory'
为构建添加一个子路径。
add_subdirectory(source_dir [binary_dir] 
               [EXCLUDE_FROM_ALL])
这条命令的作用是为构建添加一个子路径。source_dir选项指定了CMakeLists.txt源文件和代码文件的位置。
如果source_dir是一个相对路径，那么source_dir选项会被解释为相对于当前的目录，但是它也可以是一个绝对路径。
binary_dir选项指定了输出文件的路径。如果binary_dir是相对路径，它将会被解释为相对于当前输出路径，但是它也可以是一个绝对路径。
如果没有指定binary_dir，binary_dir的值将会是没有做任何相对路径展开的source_dir，这也是通常的用法。
在source_dir指定路径下的CMakeLists.txt将会在当前输入文件的处理过程执行到该命令之前，立即被CMake处理。

如果指定了EXCLUDE_FROM_ALL选项，在子路径下的目标默认不会被包含到父路径的ALL目标里，并且也会被排除在IDE工程文件之外。
用户必须显式构建在子路径下的目标，比如一些示范性的例子工程就是这样。
典型地，子路径应该包含它自己的project()命令调用，这样会在子路径下产生一份完整的构建系统（比如VS IDE的solution文件）
注意，目标间的依赖性要高于这种排除行为。如果一个被父工程构建的目标依赖于在这个子路径下的目标，被依赖的目标会被包含到父工程的构建系统中，以满足依赖性的要求。

ADD_SUBDIRECTORY(lua)
ADD_SUBDIRECTORY(examples)
ADD_SUBDIRECTORY(tests)
ADD_SUBDIRECTORY(cram)
ADD_SUBDIRECTORY(fuzz)

add_subdirectory(src)
1. 定义了将src子目录加入工程，并指定编译目标二进制输出路径为bin目录。编译中间结果存放在build/src目录。
add_subdirectory(src bin)
2. 编译中间结果和编译目标二进制存放到bin目录下。
}

SUBDIRS(dir1 dir2...){
SUBDIRS(dir1 dir2...)，但是这个指令已经不推荐使用。它可以一次添加多个子目录，
并且，即使外部编译，子目录体系仍然会被保存。
如果我们在上面的例子中将ADD_SUBDIRECTORY (src bin)修改为SUBDIRS(src)。
add_subdirectory
}

add_test(){ cat - <<'add_test'
add_test 以指定的参数为工程添加一个测试。
add_test(testname Exename arg1 arg2 ... )
如果已经运行过了ENABLE_TESTING命令，这个命令将为当前路径添加一个测试目标。如果ENABLE_TESTING还没有运行过，该命令啥事都不做。
    测试是由测试子系统运行的，它会以指定的参数执行Exename文件。Exename或者是由该工程构建的可执行文件，也可以是系统上自带的任意可执行文件(比如tclsh)。
该测试会在CMakeList.txt文件的当前工作路径下运行，这个路径与二进制树上的路相对应。 

add_test(NAME <name> [CONFIGURATIONS [Debug|Release|...]]
       COMMAND <command> [arg1 [arg2 ...]])
       
如果COMMAND选项指定了一个可执行目标(用add_executable创建)，它会自动被在构建时创建的可执行文件所替换。
如果指定了CONFIGURATIONS选项，那么该测试只有在列出的某一个配置下才会运行。

在COMMAND选项后的参数可以使用"生成器表达式"，它的语法是"$<...>"。这些表达式会在构建系统生成期间，以及构建配置的专有信息的产生期间被评估。合法的表达式是：
  $<CONFIGURATION>          = 配置名称
  $<TARGET_FILE:tgt>        = 主要的二进制文件(.exe, .so.1.2, .a)
  $<TARGET_LINKER_FILE:tgt> = 用于链接的文件(.a, .lib, .so)
  $<TARGET_SONAME_FILE:tgt> = 带有.so.的文件(.so.3)
    其中，"tgt"是目标的名称。目标文件表达式TARGET_FILE生成了一个完整的路径，但是它的_DIR和_NAME版本可以生成目录以及文件名部分：
  $<TARGET_FILE_DIR:tgt>/$<TARGET_FILE_NAME:tgt>
  $<TARGET_LINKER_FILE_DIR:tgt>/$<TARGET_LINKER_FILE_NAME:tgt>
  $<TARGET_SONAME_FILE_DIR:tgt>/$<TARGET_SONAME_FILE_NAME:tgt>
    用例：
    add_test(NAME mytest
            COMMAND testDriver --config $<CONFIGURATION>
                                --exe $<TARGET_FILE:myexe>)
　　这段代码创建了一个名为mytest的测试，它执行的命令是testDriver工具，传递的参数包括配置名，以及由目标生成的可执行文件myexe的完整路径。

ubusd/test-fuzz
ADD_TEST(
  NAME ${name}
  COMMAND ${name} -max_len=256 -timeout=10 -max_total_time=300 ${CMAKE_CURRENT_SOURCE_DIR}/corpus
)
ubusd/test-fuzz
ADD_TEST(
  NAME cram
  COMMAND ${PYTHON_VENV_CRAM} ${test_cases}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

4. ADD_TEST与ENABLE_TESTING指令。
ENABLE_TESTING指令用来控制Makefile是否构建test目标，涉及工程所有目录。语法很简单，没有任何参数，
ENABLE_TESTING()，一般情况这个指令放在工程的主CMakeLists.txt中.

ADD_TEST指令的语法是:
ADD_TEST(testname Exename arg1 arg2 ...)
testname是自定义的test名称，Exename可以是构建的目标文件也可以是外部脚本等等。后面连接传递给可执行文件的参数。
如果没有在同一个CMakeLists.txt中打开ENABLE_TESTING()指令，任何ADD_TEST都是无效的。
比如我们前面的Helloworld例子，可以在工程主CMakeLists.txt中添加
ADD_TEST(mytest ${PROJECT_BINARY_DIR}/bin/main)
ENABLE_TESTING()
生成Makefile后，就可以运行make test来执行测试了。
add_test
}


CMAKE(){
1. cmake自定义变量的方式
SET(HELLO_SRC main.c)，

2. cmake常用变量：
2.1 CMAKE_BINARY_DIR          CMAKE_SOURCE_DIR
    PROJECT_BINARY_DIR        PROJECT_SOURCE_DIR
    <projectname>_BINARY_DIR  <projectname>_SOURCE_DIR
    
2.2 CMAKE_CURRENT_SOURCE_DIR  # 当前处理的CMakeLists.txt所在的路径
指的是当前处理的CMakeLists.txt所在的路径，比如上面我们提到的src子目录。

2.3 CMAKE_CURRRENT_BINARY_DIR # target编译目录 使用ADD_SURDIRECTORY(src bin)可以更改此变量的值
如果是in-source编译，它跟CMAKE_CURRENT_SOURCE_DIR一致，如果是out-of-source编译，他指的是target编译目录。
使用我们上面提到的ADD_SUBDIRECTORY(src bin)可以更改这个变量的值。
使用SET(EXECUTABLE_OUTPUT_PATH <新路径>)并不会对这个变量造成影响，它仅仅修改了最终目标文件存放的路径。

2.4 CMAKE_CURRENT_LIST_FILE # 输出调用这个变量的CMakeLists.txt的完整路径
2.5 CMAKE_CURRENT_LIST_LINE # 输出这个变量所在的行

2.6 CMAKE_MODULE_PATH # 定义自己的cmake模块所在的路径 
这个变量用来定义自己的cmake模块所在的路径。如果你的工程比较复杂，有可能会自己
编写一些cmake模块，这些cmake模块是随你的工程发布的，为了让cmake在处理
CMakeLists.txt时找到这些模块，你需要通过SET指令，将自己的cmake模块路径设置一下。
比如
SET(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)这时候你就可以通过INCLUDE指令来调用自己的模块了。

2.7 EXECUTABLE_OUTPUT_PATH和LIBRARY_OUTPUT_PATH
分别用来重新定义最终结果的存放目录，前面我们已经提到了这两个变量。

2.9 PROJECT_NAME # 返回通过PROJECT指令定义的项目名称。
3.0 CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS # 用来控制IF ELSE语句的书写方式
-------------------------------------------------------------------------------
cmake调用环境变量的方式
使用$ENV{NAME}指令就可以调用系统的环境变量了。比如
MESSAGE(STATUS "HOME dir: $ENV{HOME}")
设置环境变量的方式是：
SET(ENV{变量名} 值)

1. CMAKE_INCLUDE_CURRENT_DIR  
自动添加CMAKE_CURRENT_BINARY_DIR和CMAKE_CURRENT_SOURCE_DIR到当前处理的CMakeLists.txt。
相当于在每个CMakeLists.txt加入：
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})

2. CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE
将工程提供的头文件目录始终至于系统头文件目录的前面，当你定义的头文件确实跟系统发生冲突时可以提供一些帮助。

3. CMAKE_INCLUDE_PATH和CMAKE_LIBRARY_PATH
-------------------------------------------------------------------------------
系统信息
1. CMAKE_MAJOR_VERSION，CMAKE  # 主版本号，比如2.4.6中的2
2. CMAKE_MINOR_VERSION，CMAKE  # 次版本号，比如2.4.6中的4
3. CMAKE_PATCH_VERSION，CMAKE  # 补丁等级，比如2.4.6 中的6
4. CMAKE_SYSTEM，              # 系统名称，比如Linux-2.6.22
5. CMAKE_SYSTEM_NAME           # 不包含版本的系统名，比如Linux
6. CMAKE_SYSTEM_VERSION，      # 系统版本，比如2.6.22
7. CMAKE_SYSTEM_PROCESSOR，    # 处理器名称，比如i686.
8. UNIX，                      #  在所有的类UNIX平台为TRUE，包括OS X和cygwin
9. WIN32，                     #  在所有的win32平台为TRUE，包括cygwin
-------------------------------------------------------------------------------
主要的开关选项：
1，CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS，用来控制IF ELSE语句的书写方式，在
下一节语法部分会讲到。
2，BUILD_SHARED_LIBS # 这个开关用来控制默认的库编译方式，如果不进行设置，使用ADD_LIBRARY并没有指定库
                     # 类型的情况下，默认编译生成的库都是静态库。
                     # 如果SET(BUILD_SHARED_LIBS ON)后，默认生成的为动态库。
3，CMAKE_C_FLAGS     # 设置C编译选项，也可以通过指令ADD_DEFINITIONS()添加。
4，CMAKE_CXX_FLAGS   # 设置C++编译选项，也可以通过指令ADD_DEFINITIONS()添加。

}

cmake_file(){ cat - <<'cmake_file'
文件操作命令
file(WRITE filename "message to write"... )
file(APPEND filename "message to write"... )
file(READ filename variable [LIMIT numBytes] [OFFSET offset] [HEX])
file(STRINGS filename variable [LIMIT_COUNT num]
   [LIMIT_INPUT numBytes] [LIMIT_OUTPUT numBytes]
   [LENGTH_MINIMUM numBytes] [LENGTH_MAXIMUM numBytes]
   [NEWLINE_CONSUME] [REGEX regex]
   [NO_HEX_CONVERSION])
file(GLOB variable [RELATIVE path] [globbing expressions]...)
file(GLOB_RECURSE variable [RELATIVE path] 
   [FOLLOW_SYMLINKS] [globbing expressions]...)
file(RENAME <oldname> <newname>)
file(REMOVE [file1 ...])
file(REMOVE_RECURSE [file1 ...])
file(MAKE_DIRECTORY [directory1 directory2 ...])
file(RELATIVE_PATH variable directory file)
file(TO_CMAKE_PATH path result)
file(TO_NATIVE_PATH path result)
file(DOWNLOAD url file [TIMEOUT timeout] [STATUS status] [LOG log]
   [EXPECTED_MD5 sum] [SHOW_PROGRESS])

WRITE选项将会写一条消息到名为filename的文件中。如果文件已经存在，该命令会覆盖已有的文件；如果文件不存在，它将创建该文件。
APPEND选项和WRITE选项一样，将会写一条消息到名为filename的文件中，只是该消息会附加到文件末尾。
READ选项将会读一个文件中的内容并将其存储在变量里。读文件的位置从offset开始，最多读numBytes个字节。如果指定了HEX参数，二进制代码将会转换为十六进制表达方式，并存储在变量里。
STRINGS将会从一个文件中将一个ASCII字符串的list解析出来，然后存储在variable变量中。文件中的二进制数据会被忽略。回车换行符会被忽略。
    STRINGS也可以用在Intel的Hex和Motorola的S-记录文件；读取它们时，它们会被自动转换为二进制格式。可以使用NO_HEX_CONVERSION选项禁止这项功能。
    LIMIT_COUNT选项设定了返回的字符串的最大数量。
    LIMIT_INPUT设置了从输入文件中读取的最大字节数。
    LIMIT_OUTPUT设置了在输出变量中存储的最大字节数。
    LENGTH_MINIMUM设置了要返回的字符串的最小长度；小于该长度的字符串会被忽略。
    LENGTH_MAXIMUM设置了返回字符串的最大长度；更长的字符串会被分割成不长于最大长度的字符串。
    NEWLINE_CONSUME选项允许新行被包含到字符串中，而不是终止它们。
    REGEX选项指定了一个待返回的字符串必须满足的正则表达式。典型的使用方式是：
    file(STRINGS myfile.txt myfile)
    该命令在变量myfile中存储了一个list，该list中每个项是输入文件中的一行文本。
    GLOB选项将会为所有匹配查询表达式的文件生成一个文件list，并将该list存储进变量variable里。文件名查询表达式与正则表达式类似，只不过更加简单。
如果为一个表达式指定了RELATIVE标志，返回的结果将会是相对于给定路径的相对路径。文件名查询表达式的例子有：
        *.cxx      - 匹配所有扩展名为cxx的文件。
        *.vt?      - 匹配所有扩展名是vta,...,vtz的文件。
        f[3-5].txt - 匹配文件f3.txt, f4.txt, f5.txt。
　　GLOB_RECURSE选项将会生成一个类似于通常的GLOB选项的list，只是它会寻访所有那些匹配目录的子路径并同时匹配查询表达式的文件。
作为符号链接的子路径只有在给定FOLLOW_SYMLINKS选项或者cmake策略CMP0009被设置为NEW时，才会被寻访到。

    使用递归查询的例子有：
    /dir/*.py  - 匹配所有在/dir及其子目录下的python文件。

    MAKE_DIRECTORY选项将会创建指定的目录，如果它们的父目录不存在时，同样也会创建。（类似于mkdir命令——译注）
    RENAME选项对同一个文件系统下的一个文件或目录重命名。（类似于mv命令——译注）
    REMOVE选项将会删除指定的文件，包括在子路径下的文件。（类似于rm命令——译注）
    REMOVE_RECURSE选项会删除给定的文件以及目录，包括非空目录。（类似于rm -r 命令——译注）
    RELATIVE_PATH选项会确定从direcroty参数到指定文件的相对路径。
    TO_CMAKE_PATH选项会把path转换为一个以unix的 / 开头的cmake风格的路径。输入可以是一个单一的路径，也可以是一个系统路径，比如"$ENV{PATH}"。注意，在调用TO_CMAKE_PATH的ENV周围的双引号只能有一个参数(Note the double quotes around the ENV call TO_CMAKE_PATH only takes one argument. 原文如此。quotes和后面的takes让人后纠结，这句话翻译可能有误。欢迎指正——译注)。
    TO_NATIVE_PATH选项与TO_CMAKE_PATH选项很相似，但是它会把cmake风格的路径转换为本地路径风格：windows下用\，而unix下用/。
    DOWNLOAD 将给定的URL下载到指定的文件中。如果指定了LOG var选项，下载日志将会被输出到var中。
    如果指定了STATUS var选项，下载操作的状态会被输出到var中。该状态返回值是一个长度为2的list。list的第一个元素是操作的数字返回值，第二个返回值是错误的字符串值。
    错误信息如果是数字0，操作中没有发生错误。
    如果指定了TIMEOUT time选项，在time秒之后，操作会超时退出；time应该是整数。
    如果指定了EXPECTED_MD5 sum选项，下载操作会认证下载的文件的实际MD5和是否与期望值匹配。如果不匹配，操作将返回一个错误。如果指定了SHOW_PROGRESS选项，进度信息会以状态信息的形式被打印出来，直到操作完成。
    
    file命令还提供了COPY和INSTALL两种格式：
    file(<COPY|INSTALL> files... DESTINATION <dir>
       [FILE_PERMISSIONS permissions...]
       [DIRECTORY_PERMISSIONS permissions...]
       [NO_SOURCE_PERMISSIONS] [USE_SOURCE_PERMISSIONS]
       [FILES_MATCHING]
       [[PATTERN <pattern> | REGEX <regex>]
        [EXCLUDE] [PERMISSIONS permissions...]] [...])
　　COPY版本把文件、目录以及符号连接拷贝到一个目标文件夹。相对输入路径的评估是基于当前的源代码目录进行的，相对目标路径的评估是基于当前的构建目录进行的。
复制过程将保留输入文件的时间戳；并且如果目标路径处存在同名同时间戳的文件，复制命令会把它优化掉。赋值过程将保留输入文件的访问权限，除非显式指定权限或指定NO_SOURCE_PERMISSIONS选项
（默认是USE_SOURCE_PERMISSIONS）。参见install(DIRECTORY)命令中关于权限（permissions），PATTERN，REGEX和EXCLUDE选项的文档。
INSTALL版本与COPY版本只有十分微小的差别：它会打印状态信息，并且默认使用NO_SOURCE_PERMISSIONS选项。install命令生成的安装脚本使用这个版本（它会使用一些没有在文档中涉及的内部使用的选项。）

libubox: FILE(GLOB headers *.h)
libubox: FILE(GLOB scripts sh/*.sh)
libubox: FILE(GLOB test_cases "test-*.c")
libubox: FILE(GLOB test_cases "test_*.t")
cmake_file
}
cmake_include(){ cat - <<'cmake_include'
CMD#45 : include 从给定的文件中读取CMake的列表文件。  # Load and run CMake code from a file or module.
    include(<file|module> [OPTIONAL] [RESULT_VARIABLE <VAR>]
                          [NO_POLICY_SCOPE])
    从给定的文件中读取CMake的清单文件代码。在清单文件中的命令会被立即处理，就像它们是写在这条include命令展开的地方一样。如果指定了OPTIONAL选项，那么如果被包含文件不存在的话，不会报错。如果指定了RESULT_VARIABLE选项，那么var或者会被设置为被包含文件的完整路径，或者是NOTFOUND，表示没有找到该文件。
    如果指定的是一个模块（module）而不是一个文件，查找的对象会变成路径CMAKE_MODULE_PATH下的文件<modulename>.camke。
    参考cmake_policy()命令文档中关于NO_POLICY_SCOPE选项的讨论。

INCLUDE指令，用来载入CMakeLists.txt文件，也用于载入预定义的cmake模块.
        INCLUDE(file1 [OPTIONAL])
        INCLUDE(module [OPTIONAL])
OPTIONAL参数的作用是文件不存在也不会产生错误。
你可以指定载入一个文件，如果定义的是一个模块，那么将在CMAKE_MODULE_PATH中搜索这个模块并载入。载入的内容将在处理到INCLUDE语句是直接执行。

libubox:INCLUDE(CheckLibraryExists)
libubox:INCLUDE(CheckFunctionExists)
libubox:INCLUDE(FindPkgConfig)

procd:INCLUDE(GNUInstallDirs)
cmake_include
}

cmake_find(){ cat - <<'cmake_find'
三，FIND_指令
FIND_系列指令主要包含一下指令：
FIND_FILE(<VAR> name1 path1 path2 ...)    # VAR变量代表找到的文件全路径，包含文件名
FIND_LIBRARY(<VAR> name1 path1 path2 ...) # VAR变量表示找到的库全路径，包含库文件名
FIND_PATH(<VAR> name1 path1 path2 ...)    # VAR变量代表包含这个文件的路径。
FIND_PROGRAM(<VAR> name1 path1 path2 ...) # VAR变量代表包含这个程序的全路径。
FIND_PACKAGE(<name> [major.minor] [QUIET] [NO_MODULE]
                 [[REQUIRED|COMPONENTS] [componets...]])
用来调用预定义在CMAKE_MODULE_PATH下的Find<name>.cmake模块，你也可以自己
定义Find<name>模块，通过SET(CMAKE_MODULE_PATH dir)将其放入工程的某个目录
中供工程使用，我们在后面的章节会详细介绍FIND_PACKAGE的使用方法和Find模块的
编写。
FIND_LIBRARY示例：
FIND_LIBRARY(libX X11 /usr/lib)
IF(NOT libX)
MESSAGE(FATAL_ERROR “libX not found”)
ENDIF(NOT libX)
cmake_find
}

find_file(){ cat - <<'find_file'
find_file(<VAR> name1 [path1 path2 ...])        查找一个文件的完整路径
这是该命令的精简格式，对于大多数场合它都足够了。它与命令find_file(<VAR> name1 [PATHS path1 path2 ...])是等价的。
find_file(
             <VAR>
             name | NAMES name1 [name2 ...]
             [HINTS path1 [path2 ... ENV var]]
             [PATHS path1 [path2 ... ENV var]]
             [PATH_SUFFIXES suffix1 [suffix2 ...]]
             [DOC "cache documentation string"]
             [NO_DEFAULT_PATH]
             [NO_CMAKE_ENVIRONMENT_PATH]
             [NO_CMAKE_PATH]
             [NO_SYSTEM_ENVIRONMENT_PATH]
             [NO_CMAKE_SYSTEM_PATH]
             [CMAKE_FIND_ROOT_PATH_BOTH |
              ONLY_CMAKE_FIND_ROOT_PATH |
              NO_CMAKE_FIND_ROOT_PATH]
            )
一个名字是<VAR>的缓存条目变量会被创建，用来存储该命令的结果。
如果发现了文件的一个完整路径，该结果会被存储到该变量里并且搜索过程不会再重复，除非该变量被清除。
如果什么都没发现，搜索的结果将会是<VAR>-NOTFOUND；并且在下一次以相同的变量调用find_file时，该搜索会重新尝试。
被搜索的文件的文件名由NAMES选项后的名字列表指定。附加的其他搜索位置可以在PATHS选项之后指定。
如果ENV var在HINTS或PATHS段中出现，环境变量var将会被读取然后被转换为一个系统级环境变量，并存储在一个cmake风格的路径list中。
比如，使用ENV PATH将会将系统的path变量列出来。在DOC之后的变量将会用于cache中的文档字符串（documentation string）。PATH_SUFFIXES指定了在每个搜索路径下的需要搜索的子路径。

如果指定了NO_DEFAULT_PATH选项，那么在搜索时不会附加其它路径。如果没有指定NO_DEFAULT_PATH选项，搜索过程如下：
1、在cmake特有的cache变量中指定的搜索路径搜索。这些路径用于在命令行里用-DVAR=value被设置。如果使用了NO_CMAKE_PATH选项，该路径会被跳过。搜索路径还包括：  
    对于每个在CMAKE_PREFIX_PATH中的路径<prefix>，<prefix>/include  
    变量：CMAKE_INCLUDE_PATH
    变量：CMAKE_FRAMEWORK_PATH
2、在cmake特定的环境变量中指定的搜索路径搜索。该路径会在用户的shell配置中被设置。如果指定了NO_CMAKE_ENVIRONMENT_PATH选项，该路径会被跳过。搜索路径还包括：
    对于每个在CMAKE_PREFIX_PATH中的路径<prefix>，<prefix>/include  
    变量：CMAKE_INCLUDE_PATH
    变量：CMAKE_FRAMEWORK_PATH
3、由HINTS选项指定的搜索路径。这些路径是由系统内省（introspection）时计算出来的路径，比如已经发现的其他项的位置所提供的痕迹。硬编码的参考路径应该使用PATHS选项指定。
4、搜索标准的系统环境变量。如果指定NO_SYSTEM_ENVIRONMENT_PATH选项，搜索路径将跳过其后的参数。搜索路径包括环境变量PATH个INCLUDE。
5、查找在当前系统的平台文件中定义的cmake变量。如果指定了NO_CMAKE_SYSTEM_PATH选项，该路径会被跳过。其他的搜索路径还包括：
    对于每个在CMAKE_PREFIX_PATH中的路径<prefix>，<prefix>/include  
    变量：CMAKE_SYSTEM_INCLUDE_PATH
    变量：CMAKE_SYSTEM_FRAMEWORK_PATH
6、搜索由PATHS选项指定的路径或者在命令的简写版本中指定的路径。这一般是一些硬编码的参考路径。在Darwin后者支持OS X框架的系统上，cmake变量CMAKE_FIND_FRAMWORK可以设置为空或者下述值之一：
    "FIRST"  - 在标准库或者头文件之前先查找框架。对于Darwin系统，这是默认的。
    "LAST"   - 在标准库或头文件之后再查找框架。
    "ONLY"   - 只查找框架。
    "NEVER" - 从不查找框架。

　　在Darwin或者支持OS X Application Bundles的系统上，cmake变量CMAKE_FIND_APPBUNDLE可以被设置为空，或者下列值之一：
   "FIRST"  - 在标准程序之前查找application bundles，这也是Darwin系统的默认选项。
   "LAST"   - 在标准程序之后查找application bundlesTry。
   "ONLY"   - 只查找application bundles。
   "NEVER" - 从不查找application bundles。
　　CMake的变量CMAKE_FIND_ROOT_PATH指定了一个或多个在所有其它搜索路径之前的搜索路径。该选项很有效地将给定位置下的整个搜索路径的最优先路径进行了重新指定。默认情况下，它是空的。当交叉编译一个指向目标环境下的根目录中的目标时，CMake也会搜索那些路径；该变量这时显得非常有用。默认情况下，首先会搜索在CMAKE_FIND_ROOT_PATH变量中列出的路径，然后才是非根路径。设置CMAKE_FIND_ROOT_PATH_MODE_INCLUDE变量可以调整该默认行为。该行为可以在每次调用时被手动覆盖。通过使用CMAKE_FIND_ROOT_PATH_BOTH变量，搜索顺序将会是上述的那样。如果使用了NO_CMAKE_FIND_ROOT_PATH变量，那么CMAKE_FIND_ROOT_PATH将不会被用到。如果使用了ONLY_CMAKE_FIND_ROOT_PATH变量，那么只有CMAKE_FIND_ROOT_PATH中的路径（即re-rooted目录——译注）会被搜索。
　　一般情况下，默认的搜索顺序是从最具体的路径到最不具体的路径。只要用NO_*选项多次调用该命令，工程就可以覆盖该顺序。
    find_file(<VAR> NAMES name PATHS paths... NO_DEFAULT_PATH)
    find_file(<VAR> NAMES name)
　　只要这些调用中的一个成功了，返回变量就会被设置并存储在cache中；然后该命令就不会再继续查找了。
find_file
}

find_library(){ cat - <<'find_library'
    find_library(<VAR> name1 [path1 path2 ...]) # 查找一个库文件
    这是该命令的简写版本，在大多数场合下都已经够用了。它与命令find_library(<VAR> name1 [PATHS path1 path2 ...])等价。
    find_library(
            <VAR>
            name | NAMES name1 [name2 ...]
            [HINTS path1 [path2 ... ENV var]]
            [PATHS path1 [path2 ... ENV var]]
            [PATH_SUFFIXES suffix1 [suffix2 ...]]
            [DOC "cache documentation string"]
            [NO_DEFAULT_PATH]
            [NO_CMAKE_ENVIRONMENT_PATH]
            [NO_CMAKE_PATH]
            [NO_SYSTEM_ENVIRONMENT_PATH]
            [NO_CMAKE_SYSTEM_PATH]
            [CMAKE_FIND_ROOT_PATH_BOTH |
            ONLY_CMAKE_FIND_ROOT_PATH |
            NO_CMAKE_FIND_ROOT_PATH]
            )
    该命令用来查找一个库文件。一个名为<VAR>的cache条目会被创建来存储该命令的结果。
如果找到了该库文件，那么结果会存储在该变量里，并且搜索过程将不再重复，除非该变量被清空。
如果没有找到，结果变量将会是<VAR>-NOTFOUND，并且在下次使用相同变量调用find_library命令时，搜索过程会再次尝试。
    在NAMES参数后列出的文件名是要被搜索的库名。附加的搜索位置在PATHS参数后指定。
如果再HINTS或者PATHS字段中设置了ENV变量var，环境变量var将会被读取并从系统环境变量转换为一个cmake风格的路径list。例如，指定ENV PATH是获取系统path变量并将其转换为cmake的list的一种方式。
在DOC之后的参数用来作为cache中的注释字符串。PATH_SUFFIXES选项指定了每个搜索路径下待搜索的子路径。

ubusd:  FIND_LIBRARY(ubox_library NAMES libubox.a)
ubusd:  FIND_LIBRARY(blob_library NAMES libblobmsg_json.a)
ubusd:  FIND_LIBRARY(ubox_library NAMES ubox)
ubusd:  FIND_LIBRARY(blob_library NAMES blobmsg_json)
ubusd:  FIND_LIBRARY(json NAMES json-c json)

libubox: FIND_LIBRARY(json NAMES json-c)
libubox: FIND_LIBRARY(json NAMES json-c json)

procd:FIND_LIBRARY(ubox NAMES ubox)
procd:FIND_LIBRARY(ubus NAMES ubus)
procd:FIND_LIBRARY(blobmsg_json NAMES blobmsg_json)
procd:FIND_LIBRARY(json_script NAMES json_script)
procd:FIND_LIBRARY(json NAMES json-c json)
find_library
}
find_package(){ cat - <<'find_package'
find_package(<package> [version] [EXACT] [QUIET]
           [[REQUIRED|COMPONENTS] [components...]]
           [NO_POLICY_SCOPE])
    查找并加载外来工程的设置。该命令会设置<package>_FOUND变量，用来指示要找的包是否被找到了。如果这个包被找到了，与它相关的信息可以通过包自身记载的变量中得到。
    QUIET选项将会禁掉包没有被发现时的警告信息。
    REQUIRED选项表示如果报没有找到的话，cmake的过程会终止，并输出警告信息。在REQUIRED选项之后，
    或者如果没有指定REQUIRED选项但是指定了COMPONENTS选项，在它们的后面可以列出一些与包相关的部件清单（components list）
    。[version]参数需要一个版本号，它是正在查找的包应该兼容的版本号（格式是major[.minor[.patch[.tweak]]]）。
    EXACT选项要求该版本号必须精确匹配。如果在find-module内部对该命令的递归调用没有给定[version]参数，那么[version]和EXACT选项会自动地从外部调用前向继承。对版本的支持目前只存在于包和包之间

./tests/cram/CMakeLists.txt:1:FIND_PACKAGE(PythonInterp 3 REQUIRED)
find_package
}
find_path(){ cat - <<'find_path'
find_path 搜索包含某个文件的路径
   find_path(<VAR> name1 [path1 path2 ...])
　　在多数情况下，使用上述的精简命令格式就足够了。它与命令find_path(<VAR> name1 [PATHS path1 path2 ...])等价。
   find_path(
             <VAR>
             name | NAMES name1 [name2 ...]
             [HINTS path1 [path2 ... ENV var]]
             [PATHS path1 [path2 ... ENV var]]
             [PATH_SUFFIXES suffix1 [suffix2 ...]]
             [DOC "cache documentation string"]
             [NO_DEFAULT_PATH]
             [NO_CMAKE_ENVIRONMENT_PATH]
             [NO_CMAKE_PATH]
             [NO_SYSTEM_ENVIRONMENT_PATH]
             [NO_CMAKE_SYSTEM_PATH]
             [CMAKE_FIND_ROOT_PATH_BOTH |
              ONLY_CMAKE_FIND_ROOT_PATH |
              NO_CMAKE_FIND_ROOT_PATH]
            )
　　该命令用于给定名字文件所在的路径。一条名为<VAR>的cache条目会被创建，并存储该命令的执行结果。
如果在某个路径下发现了该文件，该结果会被存储到该变量中；除非该变量被清除，该次搜索不会继续进行。
如果没有找到，存储的结果将会是<VAR>-NOTFOUND，并且当下一次以相同的变量名调用find_path命令时，该命令会再一次尝试搜索该文件。
需要搜索的文件名通过在NAMES选项后面的列出来的参数来确定。附加的搜索位置可以在PATHS选项之后指定。
如果在PATHS或者HINTS命令中还指定了ENV var选项，环境变量var将会被读取并从一个系统环境变量转换为一个cmake风格的路径list。
比如，ENV PATH是列出系统path变量的一种方法。参数DOC将用来作为该变量在cache中的注释。PATH_SUFFIXES指定了在每个搜索路径下的附加子路径。

ubusd/procd: FIND_PATH(ubox_include_dir libubox/usock.h)
find_path
}
find_program(){ cat - <<'find_program'
FIND_PROGRAM(PKG_CONFIG pkg-config)
这是该命令的精简格式，它在大多数场合下都够用了。命令find_program(<VAR> name1 [PATHS path1 path2 ...])是它的等价形式。
   find_program(
             <VAR>
             name | NAMES name1 [name2 ...]
             [HINTS path1 [path2 ... ENV var]]
             [PATHS path1 [path2 ... ENV var]]
             [PATH_SUFFIXES suffix1 [suffix2 ...]]
             [DOC "cache documentation string"]
             [NO_DEFAULT_PATH]
             [NO_CMAKE_ENVIRONMENT_PATH]
             [NO_CMAKE_PATH]
             [NO_SYSTEM_ENVIRONMENT_PATH]
             [NO_CMAKE_SYSTEM_PATH]
             [CMAKE_FIND_ROOT_PATH_BOTH |
              ONLY_CMAKE_FIND_ROOT_PATH |
              NO_CMAKE_FIND_ROOT_PATH]
            )

　　该命令用于查找程序。一个名为<VAR>的cache条目会被创建用来存储该命令的结果。
如果该程序被找到了，结果会存储在该变量中，搜索过程将不会再重复，除非该变量被清除。
如果没有找到，结果将会是<VAR>-NOTFOUND，并且下次以相同的变量调用该命令时，还会做搜索的尝试。被搜索的程序的名字由NAMES选项后列出的参数指定。附加的搜索位置可以在PATHS参数后指定。
如果在HINTS或者PATHS选项后有ENV var参数，环境变量var将会被读取并从系统环境变量转换为cmake风格的路径list。
比如ENV PATH是一种列出所有系统path变量的方法。DOC后的参数将会被用作cache中的注释字符串。PATH_SUFFIXES指定了在每个搜索路径下要检查的附加子路径。
ubusd:  FIND_PROGRAM(PKG_CONFIG pkg-config)
find_program
}

cmake_builtin_variables(){ cat - <<'cmake_builtin_variables'
CMAKE_CXX_COMPILE_FEATURES
CMAKE_CXX_EXTENSIONS
CMAKE_CXX_STANDARD
CMAKE_CXX_STANDARD_REQUIRED
CMAKE_C_COMPILE_FEATURES
CMAKE_C_EXTENSIONS
CMAKE_C_STANDARD
CMAKE_C_STANDARD_REQUIRED
cmake_builtin_variables
}

cmake_if(){ cat - <<'cmake_if'
1,IF指令，基本语法为：
IF(expression)
# THEN section.
COMMAND1(ARGS ...)
另外一个指令是ELSEIF，总体把握一个原则，凡是出现IF的地方一定要有对应的ENDIF.出现ELSEIF的地方，ENDIF是可选的。

表达式的使用方法如下:
IF(var)，如果变量不是：空，0，N, NO, OFF, FALSE, NOTFOUND或
<var>_NOTFOUND时，表达式为真。
IF(NOT var )，与上述条件相反。
IF(var1 AND var2)，当两个变量都为真是为真。
IF(var1 OR var2)，当两个变量其中一个为真时为真。
IF(COMMAND cmd)，当给定的cmd确实是命令并可以调用是为真。
IF(EXISTS dir)或者IF(EXISTS file)，当目录名或者文件名存在时为真。
IF(file1  IS_NEWER_THAN file2)，当file1比file2新，或者file1/file2其
中有一个不存在时为真，文件名请使用完整路径。
IF(IS_DIRECTORY dirname)，当dirname是目录时，为真。
IF(variable MATCHES regex)
IF(string MATCHES regex)
当给定的变量或者字符串能够匹配正则表达式regex时为真。比如：
IF("hello" MATCHES "ell")
MESSAGE("true")
ENDIF("hello" MATCHES "ell")
IF(variable LESS number)
IF(string LESS number)
IF(variable GREATER number)
IF(string GREATER number)
IF(variable EQUAL number)
IF(string EQUAL number)
数字比较表达式
IF(variable STRLESS string)
IF(string STRLESS string)
IF(variable STRGREATER string)
IF(string STRGREATER string)
IF(variable STREQUAL string)
IF(string STREQUAL string)
按照字母序的排列进行比较.
IF(DEFINED variable)，如果变量被定义，为真。
cmake_if
}

cmake_while(){ cat - <<'cmake_while'
2,WHILE
WHILE指令的语法是：
        WHILE(condition)
          COMMAND1(ARGS ...)
          COMMAND2(ARGS ...)
          ...
        ENDWHILE(condition)
其真假判断条件可以参考IF指令。

cmake_while
}

cmake_foreach(){ cat - <<'cmake_foreach'
FOREACH指令的使用方法有三种形式：
1. 列表: 对一个list中的每一个变量执行一组命令
FOREACH(loop_var arg1 arg2 ...)
  COMMAND1(ARGS ...)
  COMMAND2(ARGS ...)
  ...
ENDFOREACH(loop_var)
所有的foreach和与之匹配的endforeach命令之间的命令会被记录下来而不会被调用。
等到遇到endforeach命令时，先前被记录下来的命令列表中的每条命令都会为list中的每个变量调用一遍。在每次迭代中，循环变量${loop_var}将会被设置为list中的当前变量值。


2，范围
foreach(loop_var RANGE total)              ENDFOREACH(loop_var)
foreach(loop_var RANGE start stop [step])  ENDFOREACH(loop_var)
foreach命令也可以遍历一个人为生成的数据区间。遍历的方式有三种：
  如果指定了一个数字，区间是[0, total]。
  如果指定了两个数字，区间将会是第一个数字到第二个数字。
  第三个数字是从第一个数字遍历到第二个数字时的步长。

3. 范围和步进
foreach(loop_var IN [LISTS [list1 [...]]]
                      [ITEMS [item1 [...]]])
ENDFOREACH(loop_var)
精确遍历一个项组成的list。LISTS选项后面是需要被遍历的list变量的名字，包括空元素（一个空字符串是一个零长度list）。ITEMS选项结束了list参数的解析，然后在迭代中引入所有在其后出现的项。

cmake_foreach
}

FIND(){
对于系统预定义的Find<name>.cmake模块，使用方法一般如上例所示：
每一个模块都会定义以下几个变量
• <name>_FOUND 
• <name>_INCLUDE_DIR or <name>_INCLUDES 
• <name>_LIBRARY or <name>_LIBRARIES 
你可以通过<name>_FOUND来判断模块是否被找到，如果没有找到，按照工程的需要关闭
某些特性、给出提醒或者中止编译，上面的例子就是报出致命错误并终止构建。
如果<name>_FOUND为真，则将<name>_INCLUDE_DIR加入INCLUDE_DIRECTORIES，
将<name>_LIBRARY加入TARGET_LINK_LIBRARIES中。

FIND_PACKAGE(<name> [major.minor] [QUIET] [NO_MODULE]
                 [[REQUIRED|COMPONENTS] [componets...]])
前面的CURL例子中我们使用了最简单的FIND_PACKAGE指令，其实他可以使用多种参数，
QUIET参数，对应与我们编写的FindHELLO   中的HELLO_FIND_QUIETLY，如果不指定
这个参数，就会执行：
MESSAGE(STATUS "Found Hello: ${HELLO_LIBRARY}")
REQUIRED参数，其含义是指这个共享库是否是工程必须的，如果使用了这个参数，说明这
个链接库是必备库，如果找不到这个链接库，则工程不能编译。对应于
FindHELLO.cmake   模块中的HELLO_FIND_REQUIRED变量。

}

option(){

答案当然是有的，强大的CMake为我们准备了--option这个命令，给我们作为默认初始值并且作为定义值的候选。
option(address "This is a option for address" ON)
此时表示，如果用户没有定义过address,那我address的默认值就是ON,如果用户在命令行显示改变过address的值比如为OFF,那么在脚本中address的值就是OFF。
}
synopsis(){
1，变量使用${}方式取值，但是在IF控制语句中是直接使用变量名
2，指令(参数1 参数2...)
参数使用括弧括起，参数之间使用空格或分号分开。
以上面的ADD_EXECUTABLE指令为例，如果存在另外一个func.c源文件，就要写成：
ADD_EXECUTABLE(hello main.c func.c)或者
ADD_EXECUTABLE(hello main.c;func.c)
3，指令是大小写无关的，参数和变量是大小写相关的。但，推荐你全部使用大写指令。
上面的MESSAGE指令我们已经用到了这条规则：
MESSAGE(STATUS "This is BINARY dir" ${HELLO_BINARY_DIR})
也可以写成：
MESSAGE(STATUS "This is BINARY dir ${HELLO_BINARY_DIR}")
}

cross(arm-linux-gcc交叉编译器){
1. 通过在CMakeLists.txt中指定交叉编译器的方法
在CMakeLists.txt一开始加入相关设置：

#告知当前使用的是交叉编译方式，必须配置
SET(CMAKE_SYSTEM_NAME Linux)

#指定C交叉编译器,必须配置
#或交叉编译器使用绝对地址
SET(CMAKE_C_COMPILER "arm-linux-gcc")

#指定C++交叉编译器
SET(CMAKE_CXX_COMPILER "arm-linux-g++")

#不一定需要设置
#指定交叉编译环境安装目录...
# 代表了一系列的相关文件夹路径的根路径的变更，比如你设置了/opt/arm/,所有的Find_xxx.cmake都会优先根据
# 这个路径下的/usr/lib,/lib等进行查找，然后才会去你自己的/usr/lib和/lib进行查找，如果你有一些库是不被
# 包含在/opt/arm里面的，你也可以显示指定多个值给CMAKE_FIND_ROOT_PATH,比如
# set(CMAKE_FIND_ROOT_PATH /opt/arm /opt/inst)

SET(CMAKE_FIND_ROOT_PATH "...")

# 从来不在指定目录下查找工具程序
# NEVER表示不在你CMAKE_FIND_ROOT_PATH下进行查找，
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# 只在指定目录下查找库文件
# ONLY表示只在CMAKE_FIND_ROOT_PATH路径下查找，
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)

# 只在指定目录下查找头文件
# BOTH表示先查找这个路径，再查找全局路径，
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)


CMAKE_FIND_ROOT_PATH_MODE_LIBRARY: 对FIND_LIBRARY()起作用，表示在链接的时候的库的相关选项，
因此这里需要设置成ONLY来保证我们的库是在交叉环境中找的.

CMAKE_FIND_ROOT_PATH_MODE_INCLUDE: 对FIND_PATH()和FIND_FILE()起作用，一般来说也是ONLY,如果你想改变，
一般也是在相关的FIND命令中增加option来改变局部设置，有NO_CMAKE_FIND_ROOT_PATH,ONLY_CMAKE_FIND_ROOT_PATH,
BOTH_CMAKE_FIND_ROOT_PATH.

 BOOST_ROOT： 对于需要boost库的用户来说，相关的boost库路径配置也需要设置，因此这里的路径即ARM下的boost路径，
 里面有include和lib。
}

CMAKE_TOOLCHAIN_FILE(){
--------------------------------------- Toolchain-eldk-ppc74xx.cmake
# this one is important
SET(CMAKE_SYSTEM_NAME Linux)
#this one not so much
SET(CMAKE_SYSTEM_VERSION 1)

# specify the cross compiler
SET(CMAKE_C_COMPILER   /opt/eldk-2007-01-19/usr/bin/ppc_74xx-gcc)
SET(CMAKE_CXX_COMPILER /opt/eldk-2007-01-19/usr/bin/ppc_74xx-g++)

# where is the target environment 
SET(CMAKE_FIND_ROOT_PATH  /opt/eldk-2007-01-19/ppc_74xx /home/alex/eldk-ppc74xx-inst)

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
--------------------------------------- Toolchain-eldk-ppc74xx.cmake
cd build
build$ cmake -DCMAKE_TOOLCHAIN_FILE=~/Toolchain-eldk-ppc74xx.cmake ..


    CMake给交叉编译预留了一个很好的变量即CMAKE_TOOLCHAIN_FILE,它定义了一个文件的路径，这个文件即
toolChain,里面set了一系列你需要改变的变量和属性，包括C_COMPILER,CXX_COMPILER,如果用Qt的话需要更改
QT_QMAKE_EXECUTABLE以及如果用BOOST的话需要更改的BOOST_ROOT(具体查看相关Findxxx.cmake里面指定的路径)。
CMake为了不让用户每次交叉编译都要重新输入这些命令，因此它带来toolChain机制，简而言之就是一个cmake脚本，
内嵌了你需要改变以及需要set的所有交叉环境的设置。
}

cmake(获取命令帮助){
1. 获取命令帮助
cmake --help-commands
这个命令将给出所有cmake内置的命令的详细帮助，一般不知道自己要找什么或者想随机翻翻得时候，可以用这个。
另外也可以用如下的办法层层缩小搜索范围：
cmake --help-commands-list
cmake --help-commands-list|grep find
}
cmake(查询变量){
cmake --help-variable-list | grep CMAKE | grep HOST
这里查找所有CMake自己定义的builtin变量；一般和系统平台相关。
如果希望将所有生成的可执行文件、库放在同一的目录下，可以如此做：
# Targets directory
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${target_dir}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${target_dir}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${target_dir}/bin)
这里的target_dir是一个实现设置好的绝对路径。（CMake里边绝对路径比相对路径更少出问题，如果可能尽量用绝对路径）
}
cmake(属性查询){
属性查询
cmake --help-property-list | grep NAME
Property一般很少需要直接改动，除非你想修改一些默认的行为，譬如修改生成的动态库文件的soname等。
cmake --help-property OUTPUT_NAME
}
cmake(CMake模组){
    用于查找常用的模块，譬如boost，bzip2, python等。通过简单的include命令包含预定义的模块，
就可以得到一些模块执行后定义好的变量，非常方便。
# Find boost 1.40
INCLUDE(FindBoost)
find_package(Boost 1.40.0 COMPONENTS thread unit_test_framework)
if(NOT Boost_FOUND)
message(STATUS "BOOST not found, test will not succeed!")
endif()
一般开头部分的解释都相当有用，可满足80%需求：
cmake --help-module FindBoost | head -40
}
cmake(如何根据其生成的中间文件查看一些关键信息){
    CMake相比较于autotools的一个优势就在于其生成的中间文件组织的很有序，并且清晰易懂，
不像autotools会生成天书一样的庞然大物（10000+的不鲜见）。
    一般CMake对应的Makefile都是有层级结构的，并且会根据你的CMakeLists.txt间的相对结构在binary directory
里边生成相应的目录结构。
譬如对于某一个target，一般binary tree下可以找到一个文件夹: CMakeFiles/.dir/,比如：
skyscribe@skyscribe:~/program/ltesim/bld/dev/simcluster/CMakeFiles/SIMCLUSTER.dir$ ls -l
total 84
-rw-r--r-- 1 skyscribe skyscribe 52533 2009-12-12 12:20 build.make
-rw-r--r-- 1 skyscribe skyscribe 1190 2009-12-12 12:20 cmake_clean.cmake
-rw-r--r-- 1 skyscribe skyscribe 4519 2009-12-12 12:20 DependInfo.cmake
-rw-r--r-- 1 skyscribe skyscribe 94 2009-12-12 12:20 depend.make
-rw-r--r-- 1 skyscribe skyscribe 573 2009-12-12 12:20 flags.make
-rw-r--r-- 1 skyscribe skyscribe 1310 2009-12-12 12:20 link.txt
-rw-r--r-- 1 skyscribe skyscribe 406 2009-12-12 12:20 progress.make
drwxr-xr-x 2 skyscribe skyscribe 4096 2009-12-12 12:20 src
    这里，每一个文件都是个很短小的文本文件，内容相当清晰明了。
build.make一般包含中间生成文件的依赖规则，DependInfo.cmake一般包含源代码文件自身的依赖规则。
    比较重要的是flags.make和link.txt，前者一般包含了类似于GCC的-I的相关信息，如搜索路径，宏定义等；
后者则包含了最终生成target时候的linkage信息，库搜索路径等。 这些信息在出现问题的时候是个很好的辅助调试手段。
}
cmake(文件查找、路径相关){
include_directories（）用于添加头文件的包含搜索路径
cmake --help-command include_directories
link_directories()用于添加查找库文件的搜索路径
cmake --help-command link_directories
}
cmake(库查找){
    一般外部库的link方式可以通过两种方法来做，一种是显示添加路径，采用link_directories()， 
一种是通过find_library()去查找对应的库的绝对路径。后一种方法是更好的，因为它可以减少不少潜在的冲突。
    
    一般find_library会根据一些默认规则来搜索文件，如果找到，将会set传入的第一个变量参数、否则，
对应的参数不被定义，并且有一个xxx-NOTFOUND被定义；可以通过这种方式来调试库搜索是否成功。
    
    对于库文件的名字而言，动态库搜索的时候会自动搜索libxxx.so (xxx.dll),静态库则是libxxx.a（xxx.lib），
对于动态库和静态库混用的情况，可能会出现一些混乱，需要格外小心；一般尽量做匹配连接。
}
cmake(rpath){
所谓的rpath是和动态库的加载运行相关的。我一般采用如下的方式取代默认添加的rpath：
# RPATH and library search setting
SET(CMAKE_SKIP_BUILD_RPATH FALSE)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/nesim/lib")
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
}
cmake(CMake内调用环境变量){
通过$ENV{VAR}访问环境变量；
通过[HKEY_CURRENT_USER\\Software\\path1\\path2;key]访问Windows注册表；
}
cmake(指定编译器){
CMake通过制定模组检查编译器 Modules/CMakeDeterminCCompiler.cmake Modules/CMakeDeterminCXXCompiler.cmake
可以设置环境变量指定编译器，如：$ENV{CC}/$ENV{CXX}
或者使用CMake命令行变量指定，语法：-DCACHE_VAR:TYPE=VALUE
例子： cmake -DCMAKE_CXX_COMPILER=xlc -DBUILD_TESTING:BOOL=ON ../foo
}
cmake(指定编译标志){
设置编译环境变量
LDFLAGS= XXX #设置link标志
CXXFLAGS= XXX #初始化CMAKE_CXX_FLAGS
CFLAGS= XXX #初始化CMAKE_C_FLAGS
}
cmake(CMake的依赖分析){
依赖分析，使用四个文件depend.make,flags.make,build.make,DependInfo.cmake.depend.make
}
add_executable(){ cat - <<'add_executable'
add_executable: 使用给定的源文件，为工程引入一个可执行文件。
add_executable(<name> [WIN32] [MACOSX_BUNDLE]
                 [EXCLUDE_FROM_ALL]
                 source1 source2 ... sourceN)

引入一个名为<name>的可执行目标，该目标会由调用该命令时在源文件列表中指定的源文件来构建。
<name>对应于逻辑目标名字，并且在工程范围内必须是全局唯一的。被构建的可执行目标的实际文件名将根据具体的本地平台创建出来(比如<name>.exe或者仅仅是<name>)。
默认情况下，可执行文件将会在构建树的路径下被创建，对应于该命令被调用的源文件树的路径。
如果要改变这个位置，查看RUNTIME_OUTPUT_DIRECTORY目标属性的相关文档。
如果要改变最终文件名的<name>部分，查看OUTPUT_NAME目标属性的相关文档。
如果指定了MACOSX_BUNDLE选项，对应的属性会附加在创建的目标上。查看MACOSX_BUNDLE目标属性的文档可以找到更多的细节。
如果指定了EXCLUDE_FROM_ALL选项，对应的属性将会设置在被创建的目标上。查看EXCLUDE_FROM_ALL目标属性的文档可以找到更多的细节。

使用下述格式，add_executable命令也可以用来创建导入的（IMPORTED）可执行目标：
# add_executable(<name> IMPORTED)
一个导入的可执行目标引用了一个位于工程之外的可执行文件。
该格式不会生成构建这个目标的规则。该目标名字的作用域在它被创建的路径以及底层路径有效。它可以像在该工程内的其他任意目标一样被引用。
导入可执行文件为类似于add_custom_command之类的命令引用它提供了便利。

关于导入的可执行文件的细节可以通过设置以IMPORTED_开头的属性来指定。这类属性中最重要的是IMPORTED_LOCATION（以及它对应于具体配置的版本IMPORTED_LOCATION_<CONFIG>）；该属性指定了执行文件主文件在磁盘上的位置。查看IMPORTED_*属性的文档来获得更多信息。
libhv:add_executable(hloop_test hloop_test.c)
libhv:add_executable(htimer_test htimer_test.c)
libhv:add_executable(nc nc.c)
libhv:add_executable(tinyhttpd tinyhttpd.c)
libhv:add_executable(tcp_echo_server tcp_echo_server.c)
libhv:add_executable(tcp_chat_server tcp_chat_server.c)

libubox: ADD_EXECUTABLE(${name}-san ${name}.c)
libubox: ADD_EXECUTABLE(jshn jshn.c)
libubox: ADD_EXECUTABLE(ustream-example ustream-example.c)
libubox: ADD_EXECUTABLE(json_script-example json_script-example.c)
libubox: ADD_EXECUTABLE(${name} ${name}.c)
libubox: ADD_EXECUTABLE(${name} ${name}.c)

ubusd:   ADD_EXECUTABLE(${name}-san ${name}.c)
ubusd:   ADD_EXECUTABLE(ubusd ubusd_main.c)
ubusd:   ADD_EXECUTABLE(cli cli.c)
ubusd:   ADD_EXECUTABLE(server server.c count.c)
ubusd:   ADD_EXECUTABLE(client client.c count.c)
ubusd:   ADD_EXECUTABLE(${name} ${name}.c)
ubusd:   ADD_EXECUTABLE(${name} ${name}.c)
add_executable
}

add_library(){ cat - <<'add_library'
add_library 使用指定的源文件向工程中添加一个库。
add_library(<name> [STATIC | SHARED | MODULE]
              [EXCLUDE_FROM_ALL]
              source1 source2 ... sourceN)
添加一个名为<name>的库文件，该库文件将会根据调用的命令里列出的源文件来创建。<name>对应于逻辑目标名称，而且在一个工程的全局域内必须是唯一的。
待构建的库文件的实际文件名根据对应平台的命名约定来构造（比如lib<name>.a或者<name>.lib）。
指定STATIC，SHARED，或者MODULE参数用来指定要创建的库的类型。
    STATIC库是目标文件的归档文件，在链接其它目标的时候使用。
    SHARED库会被动态链接，在运行时被加载。
    MODULE库是不会被链接到其它目标中的插件，但是可能会在运行时使用dlopen-系列的函数动态链接。
如果没有类型被显式指定，这个选项将会根据变量 BUILD_SHARED_LIBS 的当前值是否为真决定是STATIC还是SHARED。

默认状态下，库文件将会在于源文件目录树的构建目录树的位置被创建，该命令也会在这里被调用。
查阅ARCHIVE_OUTPUT_DIRECTORY，LIBRARY_OUTPUT_DIRECTORY，和RUNTIME_OUTPUT_DIRECTORY这三个目标属性的文档来改变这一位置。查阅OUTPUT_NAME目标属性的文档来改变最终文件名的<name>部分。

如果指定了EXCLUDE_FROM_ALL属性，对应的一些属性会在目标被创建时被设置。查阅EXCLUDE_FROM_ALL的文档来获取该属性的细节。

使用下述格式，add_library命令也可以用来创建导入的库目标：
# add_library(<name> <SHARED|STATIC|MODULE|UNKNOWN> IMPORTED)
导入的库目标是引用了在工程外的一个库文件的目标。没有生成构建这个库的规则。这个目标名字的作用域在它被创建的路径及以下有效。
add_library可以向任何在该工程内构建的目标一样被引用。导入库为类似于target_link_libraries命令中引用它提供了便利。
关于导入库细节可以通过指定那些以IMPORTED_的属性设置来指定。其中最重要的属性是IMPORTED_LOCATION（以及它的具体配置版本，IMPORTED_LOCATION_<CONFIG>），add_library指定了主库文件在磁盘上的位置。
查阅IMPORTED_*属性的文档获取更多的信息。

libubox: ADD_LIBRARY(ubox SHARED ${SOURCES})
libubox: ADD_LIBRARY(ubox-static STATIC ${SOURCES})
libubox: ADD_LIBRARY(blobmsg_json SHARED blobmsg_json.c)
libubox: ADD_LIBRARY(blobmsg_json-static STATIC blobmsg_json.c)
libubox: ADD_LIBRARY(json_script SHARED json_script.c)
libubox: ADD_LIBRARY(uloop_lua MODULE uloop.c)

ubusd : ADD_LIBRARY(ubus STATIC ${LIB_SOURCES})
ubusd : ADD_LIBRARY(ubus SHARED ${LIB_SOURCES})
ubusd : ADD_LIBRARY(ubusd_library STATIC ubusd.c ubusd_proto.c ubusd_id.c ubusd_obj.c ubusd_event.c ubusd_acl.c ubusd_monitor.c)
ubusd : ADD_LIBRARY(ubus_lua MODULE ubus.c)
add_library
}

aux_source_directory(){  cat - <<'aux_source_directory'
aux_source_directory  查找在某个路径下的所有源文件。
aux_source_directory(<dir> <variable>)
搜集所有在指定路径下的源文件的文件名，将输出结果列表储存在指定的<variable>变量中。
该命令主要用在那些使用显式模板实例化的工程上。模板实例化文件可以存储在Templates子目录下，然后可以使用这条命令自动收集起来；这样可以避免手工罗列所有的实例。

使用该命令来避免为一个库或可执行目标写源文件的清单，是非常具有吸引力的。但是如果该命令貌似可以发挥作用，那么CMake就不需要生成一个感知新的源文件何时被加进来的构建系统了(也就是说，新文件的加入，并不会导致CMakeLists.txt过时，从而不能引起CMake重新运行。——译注)。
正常情况下，生成的构建系统能够感知它何时需要重新运行CMake，因为需要修改CMakeLists.txt来引入一个新的源文件。
当源文件仅仅是加到了该路径下，但是没有修改这个CMakeLists.txt文件，使用者只能手动重新运行CMake来产生一个包含这个新文件的构建系统。
aux_source_directory
}
break(){  cat - <<'break'
break 从一个包围该命令的foreach或while循环中跳出。
    break()
    从包围它的foreach循环或while循环中跳出。
break
}
build_command(){  cat - <<'build_command'
build_command  获取构建该工程的命令行。
build_command(<variable>
      [CONFIGURATION <config>]
      [PROJECT_NAME <projname>]
      [TARGET <target>])

把给定的变量<variable>设置成一个字符串，其中包含使用由变量CMAKE_GENERATOR确定的项目构建工具，去构建某一个工程的某一个目标配置的命令行。
对于多配置生成器，如果忽略CONFIGURATION选项，CMake将会选择一个合理的默认值；而对于单配置生成器，该选项会被忽略。
如果PROJECT_NAME选项被忽略，得到的命令行用来构建当前构建树上的顶层工程。
如果TARGET选项被忽略，得到的命令行可以用来构建所有目标，比较高效的用法是构建目标all或者ALL_BUILD。
build_command(<cachevariable> <makecommand>)
不推荐使用以上的这种格式，但对于后相兼容还是有用的。只要可以，就要使用第一种格式。
这种格式将变量<cachevariable>设置为一个字符串，其中包含从构建树的根目录，用<makecommand>指定的构建工具构建这个工程的命令。<makecommand>应该是指向msdev，devenv，nmake，make或者是一种最终用户指定的构建工具的完整路径。
build_command
}


cmake(怎样指定项目编译目标){
project命令指定}
cmake(怎样添加动态库和静态库){
target_link_libraries命令添加即可
}
cmake(怎样指定头文件与库文件路径){
include_directories与link_directories
可以多次调用以设置多个路径
link_directories仅对其后面的targets起作用
}
cmake(怎样区分debug、release版本){
建立debug/release两目录，分别在其中执行cmake -DCMAKE_BUILD_TYPE=Debug（或Release），需要编译不同版本时进入不同目录执行make即可；
Debug版会使用参数-g；Release版使用-O3 –DNDEBUG

另一种设置方法——例如DEBUG版设置编译参数DDEBUG
IF(DEBUG_mode)
    add_definitions(-DDEBUG)
ENDIF()

在执行cmake时增加参数即可，例如cmake -D DEBUG_mode=ON
}
cmake(怎样设置条件编译){
例如debug版设置编译选项DEBUG，并且更改不应改变CMakelist.txt
    使用option command，eg：
    option(DEBUG_mode "ON for debug or OFF for release" ON)
    IF(DEBUG_mode)
    add_definitions(-DDEBUG)
    ENDIF()
    使其生效的方法：首先cmake生成makefile，然后make edit_cache编辑编译选项；Linux下会打开一个文本框，可以更改，该完后再make生成目标文件——emacs不支持make edit_cache；
    局限：这种方法不能直接设置生成的makefile，而是必须使用命令在make前设置参数；对于debug、release版本，相当于需要两个目录，分别先cmake一次，然后分别make edit_cache一次；
    期望的效果：在执行cmake时直接通过参数指定一个开关项，生成相应的makefile——可以这样做，例如cmake –DDEBUGVERSION=ON
}
cmake(怎样添加编译宏定义){
使用add_definitions命令，见命令部分说明
}
cmake(怎样添加编译依赖项){
    用于确保编译目标项目前依赖项必须先构建好
    add_dependencies
}
cmake(怎样指定目标文件目录){
    建立一个新的目录，在该目录中执行cmake生成Makefile文件，这样编译结果会保存在该目录——类似
    SET_TARGET_PROPERTIES(ss7gw PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${BIN_DIR}")
}
cmake(怎样打印make的输出){
make VERBOSE=1
}


add_custom_command(){ cat - <<'add_custom_command'
add_custom_command 为生成的构建系统添加一条自定义的构建规则。

add_custom_command命令有两种主要的功能；第一种是为了生成输出文件，添加一条自定义命令。
# add_custom_command(OUTPUT output1 [output2 ...] 
#                   COMMAND command1 [ARGS] [args1...]
#                  [COMMAND command2 [ARGS] [args2...] ...]
#                  [MAIN_DEPENDENCY depend]
#                  [DEPENDS [depends...]]
#                  [IMPLICIT_DEPENDS <lang1> depend1 ...]
#                  [WORKING_DIRECTORY dir]
#                  [COMMENT comment] [VERBATIM] [APPEND])
这种命令格式定义了一条生成指定的文件（文件组）的生成命令。
在相同路径下创建的目标（CMakeLists.txt文件）——任何自定义命令的输出都作为它的源文件——被设置了一条规则：在构建的时候，使用指定的命令来生成这些文件。
如果一个输出文件名是相对路径，它将被解释成相对于构建树路径的相对路径，并且与当前源码路径是对应的。
注意，MAIN_DEPENDENCY完全是可选的，它用来向visual studio建议在何处停止自定义命令。对于各种类型的makefile而言，这条命令创建了一个格式如下的新目标：
OUTPUT: MAIN_DEPENDENCY DEPENDS
    COMMAND
如果指定了多于一条的命令，它们会按顺序执行。ARGS参数是可选的，它的存在是为了保持向后兼容，以后会被忽略掉。

第二种格式为一个目标——比如一个库文件或者可执行文件——添加一条自定义命令。
这种格式可以用于目标构建前或构建后的一些操作。这条命令会成为目标的一部分，并且只有目标被构建时才会执行。如果目标已经构建了，该目标将不会执行。
# add_custom_command(TARGET target
#                     PRE_BUILD | PRE_LINK | POST_BUILD
#                     COMMAND command1 [ARGS] [args1...]
#                     [COMMAND command2 [ARGS] [args2...] ...]
#                     [WORKING_DIRECTORY dir]
#                     [COMMENT comment] [VERBATIM])
这条命令定义了一个与指定目标的构建过程相关的新命令。新命令在何时执行，由下述的选项决定：
    PRE_BUILD  - 在所有其它的依赖之前执行；
    PRE_LINK   - 在所有其它的依赖之后执行；
    POST_BUILD - 在目标被构建之后执行；
注意，只有Visual Studio 7或更高的版本才支持PRE_BUILD。对于其他的生成器，PRE_BUILD会被当做PRE_LINK来对待。
如果指定了WORKING_DIRECTORY选项，这条命令会在给定的路径下执行。
如果设置了COMMENT选项，后跟的参数会在构建时、以构建信息的形式、在命令执行之前显示出来。
如果指定了APPEND选项，COMMAND以及DEPENDS选项的值会附加到第一个输出文件的自定义命令上。在此之前，必须有一次以相同的输出文件作为参数的对该命令的调用。
在当前版本下，如果指定了APPEND选项，COMMENT, WORKING_DIRECTORY和MAIN_DEPENDENCY选项会被忽略掉，不过未来有可能会用到。

如果指定了VERBATIM选项，所有该命令的参数将会合适地被转义，以便构建工具能够以原汁原味的参数去调用那些构建命令。
注意，在add_custom_command能看到这些参数之前，CMake语言处理器会对这些参数做一层转义处理。推荐使用VERBATIM参数，因为它能够保证正确的行为。当VERBATIM未指定时，CMake的行为依赖于平台，因为CMake没有针对某一种工具的特殊字符采取保护措施。

如果自定义命令的输出并不是实际的磁盘文件，应该使用SET_SOURCE_FILES_PROPERTIES命令将该输出的属性标记为SYMBOLIC。
如果COMMAND选项指定了一个可执行目标（由ADD_EXECUTABLE命令创建的目标），在构建时，它会自动被可执行文件的位置所替换。而且，一个目标级的依赖性将会被添加进去，这样这个可执行目标将会在所有依赖于该自定义命令的结果的目标之前被构建。不过，任何时候重编译这个可执行文件，这种特性并不会引入一个会引起自定义命令重新运行的文件级依赖。

DEPENDS选项指定了该命令依赖的文件。如果依赖的对象是同一目录（CMakeLists.txt文件）下另外一个自定义命令的输出，CMake会自动将其它自定义命令带到这个命令中来。
如果DEPENDS指定了任何类型的目标（由ADD_*命令创建），一个目标级的依赖性将会被创建，以保证该目标在任何其它目标使用这个自定义命令的输出之前，该目标已经被创建了。
而且，如果该目标是可执行文件或库文件，一个文件级依赖将会被创建，用来引发自定义命令在目标被重编译时的重新运行。
add_custom_command
}


add_custom_target(){ cat - <<'add_custom_target'
add_custom_target 添加一个目标，它没有输出；这样它就总是会被构建。
# add_custom_target(Name [ALL] [command1 [args1...]]
#                     [COMMAND command2 [args2...] ...]
#                     [DEPENDS depend depend depend ... ]
#                     [WORKING_DIRECTORY dir]
#                     [COMMENT comment] [VERBATIM]
#                     [SOURCES src1 [src2...]])

用Name选项给定的名字添加一个目标，这个目标会引发给定的那些命令。这个目标没有输出文件，并且总是被认为是过时的，即使那些命令试图去创建一个与该目标同名的文件。
使用ADD_CUSTOM_COMMAND命令可以生成一个带有依赖性的文件。
默认情况下，没有目标会依赖于自定义目标。使用ADD_DEPENDENCIES命令可以添加依赖于该目标或者被该目标依赖的目标。
如果指定了ALL选项，这表明这个目标应该被添加到默认的构建目标中，这样它每次都会被构建（命令的名字不能是ALL）。
命令和选项是可选的；如果它们没有被指定，将会产生一个空目标。
如果设定了WORKING_DIRECTORY参数，该命令会在它指定的路径下执行。
如果指定了COMMENT选项，后跟的参数将会在构件的时候，在命令执行之前，被显示出来。
DEPENDS 选项后面列出来的依赖目标可以引用add_custom_command命令在相同路径下（CMakeLists.txt）生成的输出和文件。
SOURCES 选项指定了会被包含到自定义目标中的附加的源文件。指定的源文件将会被添加到IDE的工程文件中，方便在没有构建规则的情况下能够编辑。

# add_custom_target(libhv DEPENDS hv)
# add_custom_target(libhv_static DEPENDS hv_static)
# add_custom_target(examples DEPENDS ${EXAMPLES})
# add_custom_target(unittest DEPENDS
mkdir_p
rmdir_p
date
hatomic_test
hthread_test
hmutex_test
connect_test
socketpair_test
base64
md5
sha1
hstring_test
hpath_test
ls
ifconfig
defer_test
synchronized_test
threadpool_test
objectpool_test
nslookup
ping
ftp
sendmail
)

ubusd:   ADD_CUSTOM_TARGET(prepare-cram-venv ALL DEPENDS ${PYTHON_VENV_CRAM})
libubox: ADD_CUSTOM_TARGET(prepare-cram-venv ALL DEPENDS ${PYTHON_VENV_CRAM})

procd :ADD_CUSTOM_TARGET(syscall-names-h DEPENDS syscall-names.h)
procd :ADD_CUSTOM_TARGET(capabilities-names-h DEPENDS capabilities-names.h)
add_custom_target
}


add_definitions(){ cat - <<'add_definitions'
add_definitions 为源文件的编译添加由-D引入的define flag。
add_definitions(-DFOO -DBAR ...)
在编译器的命令行上，为当前路径以及下层路径的源文件加入一些define flag。这个命令可以用来引入任何flag，但是它的原意是用来引入预处理器的定义。
那些以-D或/D开头的、看起来像预处理器定义的flag，会被自动加到当前路径的COMPILE_DEFINITIONS属性中。

1. ADD_DEFINITIONS
向C/C++编译器添加-D定义，比如:
ADD_DEFINITIONS(-DENABLE_DEBUG  -DABC)，参数之间用空格分割。
如果你的代码中定义了#ifdef ENABLE_DEBUG #endif，这个代码块就会生效。
如果要添加其他的编译器开关，可以通过CMAKE_C_FLAGS变量和CMAKE_CXX_FLAGS变量设置。

libhv: add_definitions(-DDEBUG)
libhv: add_definitions(-DNDEBUG)
libhv: add_definitions(-DENABLE_IPV6)
libhv: add_definitions(-DENABLE_UDS)
libhv: add_definitions(-DUSE_MULTIMAP)
libhv: add_definitions(-DWITH_CURL)
libhv: add_definitions(-DWITH_NGHTTP2)
libhv: add_definitions(-DWITH_OPENSSL)
libhv: add_definitions(-DWITH_GNUTLS)
libhv: add_definitions(-DWITH_MBEDTLS)
libhv: add_definitions(-D_WIN32_WINNT=0x0600)
libhv: add_definitions(-DENABLE_WINDUMP)
libhv: add_definitions(-D_WIN32_WINNT=0x600)
libhv: add_definitions(-DHV_SOURCE=1)

procd: ADD_DEFINITIONS(-Os -ggdb -Wall -Werror --std=gnu99 -Wmissing-declarations)
procd: ADD_DEFINITIONS(-DUDEV_DEBUG -g3)
procd: ADD_DEFINITIONS(-DEARLY_PATH="${EARLY_PATH}")
procd: ADD_DEFINITIONS(-DZRAM_TMPFS)
procd: ADD_DEFINITIONS(-DDISABLE_INIT)
procd: ADD_DEFINITIONS(-DSECCOMP_SUPPORT)
procd: ADD_DEFINITIONS(-Os -ggdb -Wall -Werror --std=gnu99 -Wmissing-declarations)

libubox: ADD_DEFINITIONS(-Wall -Werror)
libubox: ADD_DEFINITIONS(-Wextra -Werror=implicit-function-declaration)
libubox: ADD_DEFINITIONS(-Wformat -Werror=format-security -Werror=format-nonliteral)
libubox: ADD_DEFINITIONS(-Os -std=gnu99 -g3 -Wmissing-declarations -Wno-unused-parameter)
libubox: ADD_DEFINITIONS(-DJSONC)
libubox: ADD_DEFINITIONS(-O1 -Wall -Werror --std=gnu99 -g3)
libubox: ADD_DEFINITIONS(-Os -Wall -Werror --std=gnu99 -g3 -I.. ${LUA_CFLAGS})

ubusd: ADD_DEFINITIONS(-DUBUS_UNIX_SOCKET="${UBUS_UNIX_SOCKET}")
ubusd: ADD_DEFINITIONS(-DUBUS_MAX_MSGLEN=${UBUS_MAX_MSGLEN})
ubusd: ADD_DEFINITIONS(-I..)
add_definitions
}

add_dependencies(){ cat - <<'add_dependencies'
add_dependencies 为顶层目标引入一个依赖关系。 说明依赖关系
ADD_DEPENDENCIES(target-name depend-target1 depend-target2 ...) # 定义target依赖的其他target，确保在编译本target之前，其他的target已经被构建。

add_dependencies(target-name depend-target1
                 depend-target2 ...)
    让一个顶层目标依赖于其他的顶层目标。一个顶层目标是由命令ADD_EXECUTABLE，ADD_LIBRARY，或者ADD_CUSTOM_TARGET产生的目标。
为这些命令的输出引入依赖性可以保证某个目标在其他的目标之前被构建。查看ADD_CUSTOM_TARGET和ADD_CUSTOM_COMMAND命令的DEPENDS选项，可以了解如何根据自定义规则引入文件级的依赖性。
查看SET_SOURCE_FILES_PROPERTIES命令的OBJECT_DEPENDS选项，可以了解如何为目标文件引入文件级的依赖性。

procd: ADD_DEPENDENCIES(preload-seccomp syscall-names-h)
procd: ADD_DEPENDENCIES(ujail           capabilities-names-h)
procd: ADD_DEPENDENCIES(utrace          syscall-names-h)
add_dependencies
}
