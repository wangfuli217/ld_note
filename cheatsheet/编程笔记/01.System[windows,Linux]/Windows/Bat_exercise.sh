
1. 修改文件的修改日期
   复制文件，在文件名后面加上个“+,,”
   copy LeapFTP.exe+,,


2. 让“.bat”文件的文件名作为运行程序的参数

    // ************* example 2 start ****************
    @ echo off

    rem 计算目录名长度，长度为：%num%
    set str=%cd%
    :next1
    if not "%str%"=="" (
    rem 算术运算，使num的值自增1，相当于num++或者++num语句
    set /a num+=1
    rem 截取字符串，每次截短1
    set "str=%str:~1%"
    rem 跳转到next1标签: 这里利用goto和标签，构成循环结构
    goto next1
    )
    echo 目录的长度为：%num%

    :run
    rem 记录下文件名
    set args=%0
    set /a num+=2

    rem 字符串截取的需要，需要传递参数进行截取
    setlocal enabledelayedexpansion
    rem 截取出文件名:去除目录名和后缀名
    set args=!args:~%num%,-5!

    rem 运行 LeapFTP.exe 程序，并传递参数进去，参数可以多个，用空格隔开即可
    start LeapFTP.exe %args%
    // ************* example 2 end ****************



3. 用“.bat”文件的文件名作为运行程序的名称和参数
   并且，如果有转码工具的话，转换成简体来运行
   很类似上面一例
    // ************* example 3 start ****************
    @ echo off

    rem 计算目录名长度，长度为：%num%
    set str=%cd%
    :next1
    if not "%str%"=="" (
    rem 算术运算，使num的值自增1，相当于num++或者++num语句
    set /a num+=1
    rem 截取字符串，每次截短1
    set "str=%str:~1%"
    rem 跳转到next1标签: 这里利用goto和标签，构成循环结构
    goto next1
    )

    :run
    rem 记录下文件名
    set args=%0
    set /a num+=2

    rem 字符串截取的需要，需要传递参数进行截取
    setlocal enabledelayedexpansion
    rem 截取出文件名:去除目录名和后缀名
    set args=!args:~%num%,-5!

    rem 让本文件的文件名作为启动的程序名的参数
    rem start exe by chinese_simple
    if exist %SystemRoot%\AppPatch\AppLoc.exe (start %SystemRoot%\AppPatch\AppLoc.exe %args% /L0804) else (start %args%)

    // ************* example 3 end ****************


4.复制更新文件到工作目录“toWork”
    @echo off

    rem 配置信息
    set fromDir=D:\cvsclient\everunion\pili
    set toDir=D:\vs\pili
    set EXCLUDE=uncopy_toWork.txt
    set keepfile=toWork.txt

    rem 删除log等文件
    echo delete log ...
    del /a /s /q /f "%toDir%\logs\*"
    rmdir /q /s "%toDir%\logs"

    rem 创建/清空历史存档
    echo. >%keepfile%
    rem 复制更新文件1
    echo copy to Work ... aspx ... >>%keepfile%
    XCOPY "%fromDir%\src\aspx" "%toDir%\" /E /R /Y /D /C /EXCLUDE:%EXCLUDE% >>%keepfile%

    rem 复制更新文件2
    echo. >>%keepfile%
    echo copy to Work ... c# ... >>%keepfile%
    XCOPY "%fromDir%\src\c#" "%toDir%\classlib\" /E /R /Y /D /C /EXCLUDE:%EXCLUDE% >>%keepfile%

    rem 读取历史存档
    for /f "delims=" %%a in (%keepfile%) do echo. %%a

    echo.
    pause

5.文件夹同步(源目录已经删除的，也会同步删除)
    rem 文件夹同步
    rem 需设置来源文件夹,自动同步到目标文件夹;来源文件夹删除的,目标文件夹也相应删除
    rem 目标文件可指定位置,不指定的话默认是本文件所在文件夹
    @echo off

    rem 0. 配置
    rem 来源文件夹
    set fromDR=E:\本机\hh
    rem 目标文件夹
    set toDR=%cd%\hh


    rem 1. 更新文件

    rem 默认复制到此批处理所在文件夹
    if "%toDR%" == "" set toDR=%cd%

    rem 开始复制
    echo 更新文件...
    XCOPY "%fromDR%" "%toDR%\" /S /R /Y /D /C /H /K
    echo.


    rem 2. 删除来源文件夹已经删除的文件

    rem 复制自身
    if "%toDR%" == "%cd%"  ( XCOPY /R /Y /D /C /H /K %0 "%fromDR%\" )

    rem 计算目标文件夹名长度,长度为：%num1%
    set str=%toDR%
    set /a num1=0
    :next1
    if not "%str%"=="" (
        rem 算术运算, 使num的值自增1, 相当于 num1++ 语句
        set /a num1+=1
        rem 截取字符串, 每次截短1
        set "str=%str:~1%"
        rem 跳转到next1标签: 这里利用goto和标签, 构成循环结构
        goto next1
    )
    rem echo 目标文件夹的长度为：%num1%

    rem 盘符会被自动去掉
    set /a num1-=2


    rem 字符串截取的需要, 需要传递参数进行截取
    setlocal enabledelayedexpansion

    echo 删除源文件夹不存在的文件夹...
    for /R "%toDR%" /D %%a in (*) do (
        set "str=!%%a!"
        set "str=!str:~%num1%!"
        rem 显示出要删除的文件夹
        if not exist "%fromDR%!str!" echo %%a
        if not exist "%fromDR%!str!" rmdir /q /s "%%a"
    )
    echo.

    echo 删除源文件夹不存在的文件...
    for /R "%toDR%" %%b in (*) do (
        set "str=!%%b!"
        set "str=!str:~%num1%!"
        rem 显示出要删除的文件
        if not exist "%fromDR%!str!" echo %%b
        if not exist "%fromDR%!str!" del /a /s /q /f "%%b"
    )
    echo.


    rem 3. 删除临时保存到来源文件夹的自身
    if not "%toDR%" == "%cd%"  goto end

    set "str=!%0!"
    set /a num1+=1
    set "str=!str:~%num1%,-1!"

    del /a /s /q /f "%fromDR%\%str%"

    :end
    pause


6. 输出所有开机自动启动的项目(xp可以，但win7不行):
    @echo off
    rem 考虑到程序并非都安装在系统盘下，所以还要用!str:~-1!来截取盘符
    rem 如果路径中含有N个中文字符的话，此路径的最后N个字符将不显示(一个中文字符占两个字符位)
    rem code by jm 2006-7-27
    setlocal enabledelayedexpansion
    echo.
    echo 开机自启动的程序有：
    echo.
    for /f "skip=4 tokens=1* delims=:" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run') do (
        set str=%%i
        set var=%%j
        set "var=!var:"=!"
        if not "!var:~-1!"=="=" echo !str:~-2!:!var!
    )
    pause

7. 文件内容替换
   注意，替换时空行及“!”会丢失，需要在源文件的“!”前加上“^”来保留它。
    rem 把dd.txt中的abc替换成123
    @echo off

    set f="dd.txt"
    set src=abc
    set dst=123

    setlocal enabledelayedexpansion
    for /f "usebackq delims=" %%a in (%f%) do (
        rem 重新编写这个文件
        if not defined flag cd.>%f%&set flag=1
        rem 替换
        set v=%%a
        set v=!v:%src%=%dst%!
        echo.!v!>>%f%
    )
    endlocal
    pause

8. telnet 所有ip 或者端口
    rem 探测 192.168.1.2 ~ 192.168.1.255 各台机的80端口是否开放
    For /l %%i in (2,1,255) do ( telnet 192.168.1.%%i 80 )
    PAUSE

    rem 探测主机 192.168.1.1 的各端口是否开放
    For /l %%i in (1,1,65535) do ( telnet 192.168.1.1 %%i )
    PAUSE

9. 遍历各子目录
    @echo off
    title %~n0

    rem 被复制的目录
    set "from=E:\00\Dropbox\MyNotes"
    rem 复制到的目录,这里是写本文件所在目录
    set "toDR=%~dp0"
    set "EXCLUDE=uncopy.txt"

    echo.
    ECHO 复制首目录的内容...
    XCOPY "%from%" "%toDR%" /R /Y /D /C /EXCLUDE:%EXCLUDE%
    ECHO.

    ECHO 复制各个子目录的内容...
    for /f "delims=" %%a in ('dir /ad /b "%from%"') do (
        XCOPY "%from%\%%a" "%toDR%%%a\" /R /Y /D /C /EXCLUDE:%EXCLUDE%
    )
    ECHO.

    rem 前面只复制首目录 和 第一层子目录, 是为了提高效率, 因为往往只修改第一层子目录的内容
    echo 复制所有内容...
    XCOPY "%from%" "%toDR%" /S /R /Y /D /C /H /K
    echo.

10. 当前日期及时间
    For /f "tokens=1, 2, 3, 4 delims=-/. " %%j In ('Date /T') do set nowTime=%%j年%%k月%%l日
    For /f "tokens=1,2,3 delims=: " %%j In ('TIME /T') do set nowTime=%nowTime%%%j时%%k分
    ECHO %nowTime%
