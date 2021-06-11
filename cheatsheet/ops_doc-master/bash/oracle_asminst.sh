LOGMSG="logger -puser.alert -s "
#1. 信号捕捉，当脚本捕捉到信号SIGHUP(1)、SIGINT(2)和SIGQUIT(3)时，执行exit命令退出脚本。
trap 'exit' 1 2 3
#2. 如果当前Shell环境中指定ORACLE_TRACE变量的值为T，则通过执行set -x命令来启动脚本的跟踪功能。
case $ORACLE_TRACE in
    T) set -x ;;
esac
SAVE_PATH=/bin:/usr/bin:/etc:${PATH} ; export PATH
SAVE_LLP=$LD_LIBRARY_PATH
#3. $1，即当前脚本的第一个参数，通过查看init.d目录下调用该脚本的Shell脚本oracle，可以获悉该参数的值为$ORACLE_HOME环境变量的值。
ORACLE_HOME_LISTNER=$1
#4. 如果该值不存在，则给出错误提示信息，以及该脚本的合法使用方式。
if [ ! $ORACLE_HOME_LISTNER ] ; then
    echo "ORACLE_HOME_LISTNER is not SET, unable to auto-start Oracle Net Listener"
    echo "Usage: $0 ORACLE_HOME"
else
    LOG=$ORACLE_HOME_LISTNER/listener.log
    #5. 导出ORACLE_HOME环境变量的值，由于使用了export命令，该变量的值在子Shell中将同样有效。
    export ORACLE_HOME=$ORACLE_HOME_LISTNER
    #6. 判断$ORACLE_HOME_LISTNER/bin/tnslsnr文件是否有可执行权限，如果为真，则通过该命令启动Oracle监听，需要注意的是，由于在该行命令的末尾有一个&符号，这表示该命令将在后台执行。
    #7. 在启动监听时，将标准输出以追加的方式重定向到$LOG变量指向的文件，同时也将标准错误输出也执行到该文件。
    if [ -x $ORACLE_HOME_LISTNER/bin/tnslsnr ] ; then
        echo "$0: Starting Oracle Net Listener" >> $LOG 2>&1
        $ORACLE_HOME_LISTNER/bin/lsnrctl start >> $LOG 2>&1 &
        #8. 通过提取lsnrctl version的返回信息获取当前Oracle服务器的版本，该命令的返回结果为：
        #    LSNRCTL for Linux: Version 11.2.0.1.0 - Production on 14-DEC-2011 17:23:12
        #
        #    Copyright (c) 1991, 2009, Oracle.  All rights reserved.
        #
        #    Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC)))
        #    TNSLSNR for Linux: Version 11.2.0.1.0 - Production
        #        TNS for Linux: Version 11.2.0.1.0 - Production
        #        Unix Domain Socket IPC NT Protocol Adaptor for Linux: Version 11.2.0.1.0 - Production
        #        Oracle Bequeath NT Protocol Adapter for Linux: Version 11.2.0.1.0 - Production
        #        TCP    /IP NT Protocol Adapter for Linux: Version 11.2.0.1.0 - Production,,
        #    The command completed successfully
        #9. 在通过grep命令对以上结果进行过滤，只输出包含"LSNRCTL for"的行，其结果为：
        #    LSNRCTL for Linux: Version 11.2.0.1.0 - Production on 14-DEC-2011 17:25:21
        #10.通过cut命令对以上结果进行拆分，分隔符为-d选项指定的空格字符，-f5表示将输出拆分后的第五个字段，其结果为：
        #    11.2.0.1.0
        #11.通过cut命令对以上结果进行二次拆分，但是这次的分隔符改为点(.)，本次获取的字段为第一个字段，即11。    
        VER10LIST=`$ORACLE_HOME_LISTNER/bin/lsnrctl version | grep "LSNRCTL for " | cut -d' ' -f5 | cut -d'.' -f1`
        export VER10LIST
    else
        echo "Failed to auto-start Oracle Net Listener using $ORACLE_HOME_LISTNER/bin/tnslsnr"
    fi
fi

ORATAB=/etc/oratab
#12.我想此处代码的本意应为判断/etc/oratab文件是否以文件的形式存在，然而下面的写法将会使if判断永远为真，因此应改为if [ ! -f $ORATAB ]; then。-f用于判断其后的变量是否是为普通文件。如果该文件不存在，脚本将直接退出，退出值为1，表示失败。需要说明的是，在Linux中，通用的规则是返回0表示执行成功。
if [ ! $ORATAB ] ; then
    echo "$ORATAB not found"
    exit 1;
fi

#13. checkversionmismatch是该脚本的自定义函数，用于判断客户端工具sqlplus和Oracle服务器之间的版本是否匹配。
checkversionmismatch() {
    if [ $VER10LIST ] ; then
        #14. 通过sqlplus -V获取sqlplus的版本，再该通过grep命令过滤，仅输出包含Release的行，其结果为：
        #    SQL*Plus: Release 11.2.0.1.0 Production
        #15. 基于以上结果，再通过两次cut命令的拆分，最后输出：11。这里cut的作用已经在上面的注释中给出。
        VER10INST=`sqlplus -V | grep "Release " | cut -d' ' -f3 | cut -d'.' -f1`
        #16. 如果服务器的版本($VER10LIST)小于sqlplus的版本(VER10INST)，将输出不匹配的提示信息。这里-lt用于比较数值型变量，表示A 小于 B。
        if [ $VER10LIST -lt $VER10INST ] ; then
            $LOGMSG "Listener version $VER10LIST NOT supported with Database version $VER10INST"
            $LOGMSG "Restart Oracle Net Listener using an alternate ORACLE_HOME_LISTNER:"
            $LOGMSG "lsnrctl start"
        fi
    fi
}

startinst() {
    export ORACLE_SID
    #17. 将oracle的bin目录放置到PATH环境变量中，已便于之后的直接调用。
    PATH=$ORACLE_HOME/bin:${SAVE_PATH} ; export PATH
    #18. LD_LIBRARY_PATH指出so文件所在的路径，这里将oracle所依赖的lib的路径赋值给该变量，以便oracle执行程序在启动时可以找到他们。
    LD_LIBRARY_PATH=${ORACLE_HOME}/lib:${SAVE_LLP} ; export LD_LIBRARY_PATH
    #19. 下面的变量是oracle启动时所需要的服务器实例初始化文件。
    PFILE=${ORACLE_HOME}/dbs/init${ORACLE_SID}.ora
    SPFILE=${ORACLE_HOME}/dbs/spfile${ORACLE_SID}.ora
    SPFILE1=${ORACLE_HOME}/dbs/spfile.ora
    
    echo ""
    echo "$0: Starting up database \"$ORACLE_SID\""
    date
    echo ""
    checkversionmismatch
    
    #20. 下面的代码逻辑用于区分当前服务器的版本是否为V6或V7，因为后面的启动逻辑需要为这两个版本做特殊处理。
    #21. 首先判断$ORACLE_HOME/bin/sqldba是否以普通文件的形式存在，如果存在，将通过sqldba命令获取版本信息。
    VERSION=undef
    if [ -f $ORACLE_HOME/bin/sqldba ] ; then
        SQLDBA=sqldba
        VERSION=`$ORACLE_HOME/bin/sqldba command=exit | awk '
            /SQL\*DBA: (Release|Version)/ {split($3, V, ".") ;
            print V[1]}'`
        #22. 如果版本为6，则什么也不用做，否则将VERSION变量的值统一为internal。
        case $VERSION in
            "6") ;;
            *) VERSION="internal"
        esac
    else
        #23. 再次判断$ORACLE_HOME/bin/svrmgrl是否以普通文件的形式存在，如果存在，SQLDBA的命令将为svrmgrl，版本为internal，否则SQLDBA命令将指向sqlplus。需要说明的是，不管是这里的svrmgrl还是上面的sqldba，都是为了向以前版本的兼容，才用SQLDBA来动态的表示他们，事实上，在我们后来的版本中，基本都是使用sqlplus。
        if [ -f $ORACLE_HOME/bin/svrmgrl ] ; then
            SQLDBA=svrmgrl
            VERSION="internal"
        else
            SQLDBA="sqlplus /nolog"
        fi
    fi   
    #24. 变量STATUS为1时表示正常值，其它值均表示oracle的进程已经拉起。
    #25. 先是判断$ORACLE_HOME/dbs/sgadef${ORACLE_SID}.dbf和$ORACLE_HOME/dbs/sgadef${ORACLE_SID}.ora这两个文件是否已经存在。其中${ORACLE_SID}表示变量，shell在执行时会使用该变量的实际值予以替换，这里之所有用花括号括起${ORACLE_SID}，而不是直接使用$ORACLE_SID，是因为如果这样使用的话，shell脚本会将$ORACLE_SID.ora视为一个变量。
    STATUS=1
    if [ -f $ORACLE_HOME/dbs/sgadef${ORACLE_SID}.dbf ] ; then
        STATUS="-1"
    fi
    if [ -f $ORACLE_HOME/dbs/sgadef${ORACLE_SID}.ora ] ; then
        STATUS="-1"
    fi
    #26. pmon是oracle的进程监控进程，是oracle服务器的核心进程之一。这里通过ps命令输出当前linux服务器所有进程的列表，再通过grep命令进行过滤，其中-w选择表示全词匹配，最后再通过一个grep命令过滤掉上一个grep命令，这里的-v表示取反，即不包含grep的行。
    pmon=`ps -ef | grep -w "ora_pmon_$ORACLE_SID"  | grep -v grep`
    if [ "$pmon" != "" ] ; then
        STATUS="-1"
        $LOGMSG "Warning: ${INST} \"${ORACLE_SID}\" already started."
    fi
    #27. 这里是判断数值型变量$STATUS是否为-1，即进程已经启动。
    if [ $STATUS -eq -1 ] ; then
        $LOGMSG "Warning: ${INST} \"${ORACLE_SID}\" possibly left running when system went down (system crash?)."
        $LOGMSG "Action: Notify Database Administrator."
        #28. 既然oracle服务器实例已经启动，这里就需要根据oracle的版本，用不同的工具和关闭语法shutdown已经启动的实例。
        case $VERSION in
            "6")  sqldba "command=shutdown abort" ;;
            "internal")  $SQLDBA $args <<EOF
        connect internal
        shutdown abort
EOF
            ;;
            *)  $SQLDBA $args <<EOF
        connect / as sysdba
        shutdown abort
        quit
EOF
            ;;
        esac
        #29. $?是shell脚本的内置变量，用于判断上面关闭oracle服务器实例的操作是否成功，0表示成功，其他值均表示失败。
        if [ $? -eq 0 ] ; then
            STATUS=1
        else
            $LOGMSG "Error: ${INST} \"${ORACLE_SID}\" NOT started."
        fi
    fi
    if [ $STATUS -eq 1 ] ; then
        #30. 判断$SPFILE、$SPFILE1或$PFILE是否存在，-e表示其后面的变量表示的文件是否存在，-o表示这几个条件时间的或关系，即C语言中的||。
        #31. 根本oracle的版本，用不同的oracle工具启动oracle服务器实例，其中不同的工具所使用的语法也不同，这里我们主要需要关注的是sqlplus。
        #32. 在通过oracle工具启动服务器时，这里使用了shell中的HERE DOCUMENT，这样可以将一批命令一次性传递给sqlplus这样的oracle命令。
        if [ -e $SPFILE -o -e $SPFILE1 -o -e $PFILE ] ; then
            case $VERSION in
                "6")  sqldba command=startup ;;
                "internal") $SQLDBA <<EOF
            connect internal
            startup
EOF
                ;;
                *) $SQLDBA <<EOF
            connect / as sysdba
            startup
            quit
EOF
                ;;
            esac
            #33. 通过判断以上命令的返回值，来判断是否启动成功。
            if [ $? -eq 0 ] ; then
                echo ""
                echo "$0: ${INST} \"${ORACLE_SID}\" warm started."
            else
                $LOGMSG ""
                $LOGMSG "Error: ${INST} \"${ORACLE_SID}\" NOT started."
            fi
        else
            $LOGMSG ""
            $LOGMSG "No init file found for ${INST} \"${ORACLE_SID}\"."
            $LOGMSG "Error: ${INST} \"${ORACLE_SID}\" NOT started."
        fi
    fi
}

#34. 用于启动oracle的AMS实例的函数。
startasminst() {
    export ORACLE_SID
    #34. $LINE的值在后面的调用中会给出，该值源自oratab文件的输出，其内容为：MyOrcl:/opt/oracle/product/OraHome:Y
    #35. 这里使用awk命令提取第二个域字段，其中冒号(:)为各个域之间的分隔符，第二个变量($2)为当前实例的oracle主目录。
    ORACLE_HOME=`echo $LINE | awk -F: '{print $2}' -`
    export ORACLE_HOME
    
    #36. 判断$ORACLE_HOME/bin/crsctl是否有执行权限。
    if [ ! -x $ORACLE_HOME/bin/crsctl ]; then
        $LOGMSG "$ORACLE_HOME/bin/crsctl not found when attempting to start"
        $LOGMSG "  ASM instance $ORACLE_SID."
    else
        #37. 反复执行$ORACLE_HOME/bin/crsctl命令，直到其执行成功，或在执行15次失败后退出脚本。
        COUNT=0
        $ORACLE_HOME/bin/crsctl check css
        RC=$?
        #38. 判断crsctl命令是否执行成功，如果不等于表示执行失败，则继续执行。
        while [ "$RC" != "0" ]; do
            #39. 通过expr命令，将COUNT的变量值加一，这里也可以使用let命令，如((COUNT=COUNT+1))。
            COUNT=`expr $COUNT + 1`
            if [ $COUNT = 15 ] ; then
                # 15 tries with 20 sec interval => 5 minutes timeout
                $LOGMSG "Timed out waiting to start ASM instance $ORACLE_SID"
                $LOGMSG "  CSS service is NOT available."
                exit $COUNT
            fi
            $LOGMSG "Waiting for Oracle CSS service to be available before starting "
            $LOGMSG " ASM instance $ORACLE_SID. Wait $COUNT."
            #40. 每次执行之间都休眠20秒。
            sleep 20
            $ORACLE_HOME/bin/crsctl check css
            RC=$?
        done
    fi
    #41. asm在启动成功后，调用startinst函数启动该实例。
    startinst
}