cmake_minimum_required(VERSION 2.8.4){
https://github.com/yszheda/wiki/wiki/CMake
CMake : 编译系统生成器
CPack : 包生成器
CTest : 系统检测驱动器
CDash : dashboard收集器
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

ADD_SUBDIRECTORY(source_dir [binary_dir] [EXCLUDE_FROM_ALL]){
source_dir       这个指令用于向当前工程添加存放源文件的子目录，
binary_dir       并可以指定中间二进制和目标二进制存放的位置。
EXCLUDE_FROM_ALL 参数的含义是将这个目录从编译过程中排除，

ADD_SUBDIRECTORY(src)
1. 定义了将src子目录加入工程，并指定编译目标二进制输出路径为bin目录。编译中间结果存放在build/src目录。
add_subdirectory(src bin)
2. 编译中间结果和编译目标二进制存放到bin目录下。
}

SUBDIRS(dir1 dir2...){
SUBDIRS(dir1 dir2...)，但是这个指令已经不推荐使用。它可以一次添加多个子目录，
并且，即使外部编译，子目录体系仍然会被保存。
如果我们在上面的例子中将ADD_SUBDIRECTORY (src bin)修改为SUBDIRS(src)。
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

ADD_DEFINITIONS(添加编译选项){
1. ADD_DEFINITIONS
向C/C++编译器添加-D定义，比如:
ADD_DEFINITIONS(-DENABLE_DEBUG  -DABC)，参数之间用空格分割。
如果你的代码中定义了#ifdef ENABLE_DEBUG #endif，这个代码块就会生效。
如果要添加其他的编译器开关，可以通过CMAKE_C_FLAGS变量和CMAKE_CXX_FLAGS变量设置。
}

ADD_DEPENDENCIES(说明依赖关系){
ADD_DEPENDENCIES(preload-seccomp syscall-names-h)
ADD_DEPENDENCIES(ujail capabilities-names-h)
ADD_DEPENDENCIES(utrace syscall-names-h)
ADD_DEPENDENCIES(preload-seccomp syscall-names-h)
}

cmake(cmake常用指令){
2. ADD_DEPENDENCIES
定义target依赖的其他target，确保在编译本target之前，其他的target已经被构建。
ADD_DEPENDENCIES(target-name depend-target1 depend-target2 ...)

3. ADD_EXECUTABLE、ADD_LIBRARY、ADD_SUBDIRECTORY前面已经介绍过了.

4. ADD_TEST与ENABLE_TESTING指令。
ENABLE_TESTING指令用来控制Makefile是否构建test目标，涉及工程所有目录。语法很简单，没有任何参数，
ENABLE_TESTING()，一般情况这个指令放在工程的主CMakeLists.txt中.
ADD_TEST指令的语法是:
ADD_TEST(testname Exename arg1 arg2 ...)
testname是自定义的test名称，Exename可以是构建的目标文件也可以是外部脚本等
等。后面连接传递给可执行文件的参数。如果没有在同一个CMakeLists.txt中打开
ENABLE_TESTING()指令，任何ADD_TEST都是无效的。
比如我们前面的Helloworld例子，可以在工程主CMakeLists.txt中添加
ADD_TEST(mytest ${PROJECT_BINARY_DIR}/bin/main)
ENABLE_TESTING()
生成Makefile后，就可以运行make test来执行测试了。

8，FILE指令
文件操作指令，基本语法为:
        FILE(WRITE filename "message to write"... )
        FILE(APPEND filename "message to write"... )
        FILE(READ filename variable)
        FILE(GLOB  variable [RELATIVE path] [globbing expressions]...)
        FILE(GLOB_RECURSE variable [RELATIVE path] [globbing expressions]...)
        FILE(REMOVE [directory]...)
        FILE(REMOVE_RECURSE [directory]...)
        FILE(MAKE_DIRECTORY [directory]...)
        FILE(RELATIVE_PATH variable directory file)
        FILE(TO_CMAKE_PATH path result)
        FILE(TO_NATIVE_PATH path result)
这里的语法都比较简单，不在展开介绍了。

9，INCLUDE指令，用来载入CMakeLists.txt文件，也用于载入预定义的cmake模块.
        INCLUDE(file1 [OPTIONAL])
        INCLUDE(module [OPTIONAL])
OPTIONAL参数的作用是文件不存在也不会产生错误。
你可以指定载入一个文件，如果定义的是一个模块，那么将在CMAKE_MODULE_PATH中搜
索这个模块并载入。
载入的内容将在处理到INCLUDE语句是直接执行。
二，INSTALL指令
INSTALL系列指令已经在前面的章节有非常详细的说明，这里不在赘述，可参考前面的安
装部分。
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

四，控制指令：
1,IF指令，基本语法为：
        IF(expression)
          # THEN section.
          COMMAND1(ARGS ...)
          另外一个指令是ELSEIF，总体把握一个原则，凡是出现IF的地方一定要有对应的
ENDIF.出现ELSEIF的地方，ENDIF是可选的。
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
2,WHILE
WHILE指令的语法是：
        WHILE(condition)
          COMMAND1(ARGS ...)
          COMMAND2(ARGS ...)
          ...
        ENDWHILE(condition)
其真假判断条件可以参考IF指令。
3,FOREACH
FOREACH指令的使用方法有三种形式：
1，列表
        FOREACH(loop_var arg1 arg2 ...)
          COMMAND1(ARGS ...)
          COMMAND2(ARGS ...)
          ...
        ENDFOREACH(loop_var)
2，范围
FOREACH(loop_var RANGE total)
ENDFOREACH(loop_var)
3. 范围和步进
FOREACH(loop_var RANGE start stop [step])
ENDFOREACH(loop_var)
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
cmake(生成目标){
#生成可执行文件
add_executable()
#生成库文件，不指定类型，默认生成静态库
add_library(foo [STATIC|SHARED|MODULE]foo1.c foo2.c)
}
cmake(怎样获得一个目录下的所有源文件){
    aux_source_directory(<dir> <variable>)
    将dir中所有源文件（不包括头文件）保存到变量variable中，然后可以add_executable 
(ss7gw ${variable})这样使用。
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