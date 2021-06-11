### Here文档的使用技巧 ###
# # 1. 通过sqlplus以dba的身份登录Oracle数据库服务器。
# #2. 在通过登录后，立即在sqlplus中执行oracle的脚本CreateMyTables和CreateMyViews。
# #3. 最后执行sqlplus的退出命令，退出sqlplus。自动化工作完成。
# /> sqlplus "/as sysdba" <<-SQL
# > @CreateMyTables
# > @CreateMyViews
# > exit
# > SQL