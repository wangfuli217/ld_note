下面列出python开源项目的通常目录结构及说明：

    .tx/                                       如果你使用Transifex进行国际化的翻译工作，创建此目录
            config                           Transifex的配置文件
    $PROJ_NAME/                    按照你实际的项目名称创建目录。如果有多个子项目，就创建多个目录
    docs/                                    项目文档
    wiki/                                      如果有wiki，可以创建此目录
    scripts/                                 项目用到的各种脚本
    tests/                                    测试代码
    extras/                                  扩展，不属于项目必需的部分，但是与项目相关的sample、poc等，下面给出4个例子：
            dev_example/
            production_example/
            test1_poc/
            test2_poc/
    .gitignore                             版本控制文件，现在git比较流行
    AUTHORS                           作者清单
    INSTALL                              安装说明
    LICENSE                              版权声明
    MANIFEST.in                       装箱清单文件
    MAKEFILE                           编译脚本
    README                              项目说明文件，其他需要的目录下也可以放一个README文件，说明该目录的内容
    setup.py                               python模块的安装脚本