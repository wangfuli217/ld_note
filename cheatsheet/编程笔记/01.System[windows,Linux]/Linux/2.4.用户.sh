

查看用户
id 显示用户有效的uid(用户字)和gid(组名)
    用法 id [-ap] [user]
    id 显示自己的uid和gid。
    id root 显示root的uid和gid。
    id -a root 显示用户所在组的所有组名(如root用户，是所有组的组员)

users      显示在线用户(仅显示用户名)。当前系统由哪些用户登录了
who        显示在线用户，但比users更详细，包括用户名、终端号、登录时间、IP地址。
 who am i  仅显示自己，(但包括用户名、端口、登录时间、IP地址；信息量＝who)。
 whoami    也仅显示自己，但只有用户名(仅显示自己的有效的用户名)。
w          显示比who更多内容，还包括闲置时间、占CPU、平均占用CPU、执行命令。
           用法 w [ -hlsuw ] [ 用户 ]
whereis    查询命令所在目录以及帮助文档所在目录
           如: whereis bin   显示bin所在的目录，将显示为: /usr/local/bin
which      查询该命令所在目录(类似whereis)

su         改变用户，需再输入密码。在不退出登陆的情况下，切换到另外一个人的身份
           用法  su [-] [ username [ arg ... ] ]
 su -      相当于退出再重新登录。
           su -l 用户名(如果用户名缺省，则切换到root状态；将提示输入密码)

    分配root用户管理权限的方法:
           刚开始往往不知道root的密码，需要先为root设置一个密码： $ sudo passwd root
           之后会提示要输入root用户的密码，连续输入root密码，再使用：$ su
           就可以切换成超级管理员用户登陆了！

sudo su     # 切换成超级管理员

passwd 可以设置口令/修改密码


修改用户名
    sudo usermod -l new_name old_name
    注意: 不允许在当前用户下修改当前用户的名字。应该注销要修改的用户，用别的用户登录，然后执行命令。
