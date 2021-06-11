什么是SELinux
    SELinux是在进行程序/文件等权限设置依据的一个内核模块,是程序进程能访问系统资源的一道关卡,通常用于控制网络服务.
    SELinux是基于以策略规则制定特定程序访问特定文件的模式,即委托访问控制(MAC),我们之前用户访问文件,直接通过判断文件权限与用户对比,这种访问方式称为自主访问控制(DAC).
    DAC的一些缺陷:
        root具有最高权限
        用户取得进程来更改文件资源的访问权限
    而MAC是针对进程设置对文件的访问权限,通过提供一些策略来管理众多的进程与文件
    
SELinux运行模式
    SELinux是通过MAC方式控管进程的,其控管的主体是进程,而目标是文件资源,其相关性如下:
        主体(Subject)
            进程
        目标(Object)
            文件资源
        策略(Policy)
            由于进程与文件数量庞大,所有SELinux依据某些服务制定了基本的访问策略,这些策略内还会有详细的规则(rule)来制定不同服务的开放某些资源的程度
            targetd: 针对网络服务限制较多,本机限制较少
            strict:限制方面较严格
        安全上下文(security context)
            安全上下文是描述主体/目标的相关信息,只有当主体与目标的安全上下文匹配时,主体才能去访问目标.(当然,最后还要匹配目标的rwx权限)
            
安全上下文

安全上下文存在于文件的inode上,因为进程也是由文件触发的,所以主体进程也有安全上下文
SELinux下,只有当主体通过策略与安全上下文的匹配后,才能得到放行.而最主要的部分就是安全上下文.

1) 安全上下文的查看
文件安全上下文的查看: ls -Z
进程安全上下文的查看: ps -Z
安全上下文主要分为3个字段
Identify:role:type
    Identify：标明数据所有者的身份,值为:
        root root所有
        system_u 系统程序方面的标识,通常指服务进程
        user_u 一般用户
    role :表明数据的角色,比如程序,文件资源等
        object_r：代表文件资源
        system_r ： 代表进程
    type:安全上下文的比较字段
        domain:在主体的安全上下文中其type字段称为domain
        type: 在目标安全上下文其type字段称为type
        只有domain与type匹配后,安全上下文才匹配成功
        SELinux启动后会写入domain与type的映射表,匹配就是在映射表中搜索
        
        
安全上下文的修改
如果已知某文件的安全上下文的type字段错了,需要改回正常可以怎么做？

    chcon:指定修改安全上下文的字段
        格式 chcon [-R] [-t type] [-u user] [-r role] 文件或 chcon [-R] --reference=范例文件 文件
        参数: -R是级联修改 -t修改type字段 -u修改Identify字段 -r修改role字段
    restorecon:还原文件的默认安全上下文
        格式 restorecon [-Rv] 文件
        
        
SELinux的错误回报处理

当SELinux发生错误时,我们可以通过setroubleshoot或auditd服务收集SELinux的错误信息,并加以分析处理
1) setroubleshoot：SELinux错误信息写入/var/log/messages

首先我们需要确认安装setroubleshoot,并将其启动

当SELinux报告错误信息后,我们可以查看/var/log/messages,其会提供解决的方法.
2)auditd:SELinux日志信息写入/var/log/audit/audit.log

auditd会收集SELinux的日志信息,由于auditd信息庞大,可以借由audit2why来处理导入的audit信息




我们知道,一个主体进程能否读取目标文件的重点在于SELinuxde的策略以及策略下的各项规则,然后在通过该规则的定义去处理各文件的安全上下文.
1) 查看当前策略提供的信息:seinfo
    seinfo的参数有以下:
        b 列出当前策略提供的所有规则种类(bool值,表示该规则启动与否)
        t 列出所能提供的安全上下文中的type种类
        u 列出所能提供的安全上下文中的Identify种类
        r 列出所能提供的安全上下文中的role种类
    比如以下看出所有与httpd有关的规则: seinfo -b | grep httpd
    
2) 查看安全上下文type字段映射表:sesearch
    基本格式 sesearch [-a] [-s 主体type] [-t 目标type] [-b 策略bool]
        a 列出该类型或布尔值的所有相关信息
    比如我要查找目标文件类型为httpd_sys_content_t的有关信息
    sesearch -a -t httpd_sys_content_t
    输出结果
    allow 主体安全上下文类型 目标安全上下文类型 目标文件资源格式 
    
3) 查看/设置规则的状态:getsebool [-a] 规则bool与setsebool [-P] 规则bool=[0|1]
    我们通过getsebool来查看SELinux目前策略下的规则状态,-a是查看所有规则条款
    而setsebool来设置规则条款的状态 0-关闭 1-开启 -P直接写入配置文件
4) 默认目录的安全上下文查询与修改:semanage
    semanage的查询格式：semanage {user|port|interface|fcontext|login} -l (其中fcontext是用与安全上下文方面)
    semanage的修改格式 : semanage fcontext -{a|d|m} [-tru] file_spec
        a|d|m 增/删/改 一条安全上下文
        tru 对于安全上下文的类型/角色/身份上的处理
        file_spec 针对的目标文件或主体文件的路径名(如/srv/samba(/.*)?)