1.实时切换
1.1 命令行->图形
startx
1.2 图形->命令行
Ctrl+Alt+F1--F6
2.启动默认
2.1 启动进入命令行
修改/etc/inittab文件
"id:3:initdefault"
2.2 启动进入图形界面
修改/etc/inittab文件
"id:5:initdefault"