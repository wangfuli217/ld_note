#1. /etc/oratab脚本的格式如下：
#    MyOrcl1:/opt/oracle/product/OraHome:Y
#    MyOrcl2:/opt/oracle/product/OraHome:N
#该文件的开头处有很多的注释说明，都是以#开头，这些注释需要在后面的处理中被忽略。在有用部分中，每行表示一个oracle实例，在同一行中，包含3个字段，他们之间用#冒号分隔，第一个字段为oracle的sid，第二个字段为oracle实例的主目录，最后一个字段表示本次启动是否拉起该实例，如果为Y则拉起，N则忽略。
#2. cat以管道的形式，将每行的都输出给while循环，作为其输入并赋值给LINE变量，如果到了$ORATAB文件的末尾，while循环将退出。
cat $ORATAB | while read LINE; do
    #3. 如果当前行以#开头后面跟随任意字符，则为注释说明，直接忽略即可。
    #4. 如果合法的数据行，用awk命令进行切分，并提取第一个域字段，即oracle的sid值，赋值给变量ORACLE_SID。如果该变量为空，则直接忽略，continue命令将回到循环的开头处。
    case $LINE in
        \#*)  ;;
        *)
        ORACLE_SID=`echo $LINE | awk -F: '{print $1}' -`
        if [ "$ORACLE_SID" = '*' ] ; then
            ORACLE_SID=""
            continue
        fi
        #5. 这里提取$LINE变量的最后一个字段，其中NF表示awk的输入行的字段数量，在本例中NF的值为3，$LINE的第三个域为状态字段，只有当该值为Y时才拉起该sid。
        if [ "`echo $LINE | awk -F: '{print $NF}' -`" = "Y" ] ; then
            #6. 通过cut命令截取ORACLE_SID的第一个字符，如果其值为加号(+)，则视其为asm instance。
            #7. 这里的cut命令可以替换为${ORACLE_SID:0:1}，0表示从变量$ORACLE_SID的第一个字符开始，取1个字符。
            if [ `echo $ORACLE_SID | cut -b 1` = '+' ]; then
                INST="ASM instance"
                ORACLE_HOME=`echo $LINE | awk -F: '{print $2}' -`
                export ORACLE_HOME
                LOG=$ORACLE_HOME/startup.log
                #8. 通过touch命令创建一个日志文件，同时赋予读权限。
                touch $LOG
                chmod a+r $LOG
                echo "Processing $INST \"$ORACLE_SID\": log file $ORACLE_HOME/startup.log"
                #9. 调用启动asm实例的函数，并将标准输出重定向到刚刚创建的日志文件，同时也将标准错误输出也重定向到该文件。
                startasminst >> $LOG 2>&1
            fi
        fi
        ;;
    esac
done

#10. 如果执行之上的操作失败，则直接退出脚本，退出值为2。
if [ "$?" != "0" ] ; then
    exit 2
fi
#11. 该部分将重新遍历/etc/oratab文件，并启动数据库实例。该段逻辑中的shell技巧和上面的逻辑基本相同，这里仅给出差异部分。
cat $ORATAB | while read LINE; do
    case $LINE in
        \#*) ;;
        *)
        ORACLE_SID=`echo $LINE | awk -F: '{print $1}' -`
        if [ "$ORACLE_SID" = '*' ] ; then
            ORACLE_SID=""
            continue
        fi
        # Proceed only if last field is 'Y'.
        if [ "`echo $LINE | awk -F: '{print $NF}' -`" = "Y" ] ; then
            #12. 这里和上面不同是，是判断ORACLE_SID的第一个字符不为加号(+)，这表示该实例为正常的数据库实例。
            if [ `echo $ORACLE_SID | cut -b 1` != '+' ]; then
                INST="Database instance"
                ORACLE_HOME=`echo $LINE | awk -F: '{print $2}' -`
                export ORACLE_HOME
                LOG=$ORACLE_HOME/startup.log
                touch $LOG
                chmod a+r $LOG
                echo "Processing $INST \"$ORACLE_SID\": log file $ORACLE_HOME/startup.log"
                startinst >> $LOG 2>&1
            fi
        fi
        ;;
    esac
done

#13. 该段代码逻辑的shell应用技巧和之前几段的基本雷同，这里我只是给出技巧上的差异部分。
cat $ORATAB | while read LINE;do
    case $LINE in
        \#*) ;;
        *)
        ORACLE_SID=`echo $LINE | awk -F: '{print $1}' -`
        if [ "$ORACLE_SID" = '*' ] ; then
            ORACLE_SID=""
            continue
        fi
        if [ "`echo $LINE | awk -F: '{print $NF}' -`" = "W" ] ; then
            W_ORACLE_SID=`echo $LINE | awk -F: '{print $1}' -`
            cat $ORATAB | while read LINE; do
                case $LINE in
                    \#*) ;;
                    *)
                    ORACLE_SID=`echo $LINE | awk -F: '{print $1}' -`
                    if [ "$ORACLE_SID" = '*' ] ; then
                        ORACLE_SID=""
                        continue
                    fi
                    if [ `echo $ORACLE_SID | cut -b 1` = '+' ]; then
                        INST="ASM instance"
                        ORACLE_HOME=`echo $LINE | awk -F: '{print $2}' -`
                        if [ -x $ORACLE_HOME/bin/srvctl ] ; then
                            COUNT=0
                            NODE=`olsnodes -l`
                            #14. 执行下面的命令，并将其结果用grep命令过滤，只保留包含$ORACLE_SID is running的行，这里$ORACLE_SID将完成变量替换。
                            RNODE=`srvctl status asm -n $NODE | grep "$ORACLE_SID is running"`
                            RC=$?
                            #15. 如果执行失败，将继续执行。
                            while [ "$RC" != "0" ]; do
                                #16. COUNT=$((COUNT+1))是另外一种进行数值型变量计算的表示方式。
                                COUNT=$((COUNT+1))
                                #17. -eq表示等于$COUNT等于5。
                                if [ $COUNT -eq 5 ] ; then
                                    $LOGMSG "Error: Timed out waiting on CRS to start ASM instance $ORACLE_SID"
                                    exit $COUNT
                                fi
                                $LOGMSG "Waiting for Oracle CRS service to start ASM instance $ORACLE_SID"
                                $LOGMSG "Wait $COUNT."
                                sleep 60
                                RNODE=`srvctl status asm -n $NODE | grep "$ORACLE_SID is running"`
                                RC=$?
                            done
                        else
                            $LOGMSG "Error: \"${W_ORACLE_SID}\" has dependency on ASM instance \"${ORACLE_SID}\""
                            $LOGMSG "Error: Need $ORACLE_HOME/bin/srvctl to check this dependency"
                        fi
                    fi
                    ;;
                esac
            done # innner while
        fi
        ;;
    esac
done # outer while

#18. 在该段代码逻辑中，主要是用于处理/etc/oratab文件中最后一个字段的值为W的情况，它表示所有的asm实例均已启动完毕，进入等待状态，此时将只能启动数据库实例。从Shell的应用技巧视角看，该段逻辑和之前的shell技巧没有太多差别，这里就不再一一给出注释说明了。
cat $ORATAB | while read LINE; do
    case $LINE in
        \#*) ;;
        *)
        ORACLE_SID=`echo $LINE | awk -F: '{print $1}' -`
        if [ "$ORACLE_SID" = '*' ] ; then
            ORACLE_SID=""
            continue
        fi
        if [ "`echo $LINE | awk -F: '{print $NF}' -`" = "W" ] ; then
            INST="Database instance"
            if [ `echo $ORACLE_SID | cut -b 1` = '+' ]; then
                $LOGMSG "Error: ${INST} \"${ORACLE_SID}\" NOT started"
                $LOGMSG "Error: incorrect usage: 'W' not allowed for ASM instances"
                continue
            fi
            ORACLE_HOME=`echo $LINE | awk -F: '{print $2}' -`
            export ORACLE_HOME
            LOG=$ORACLE_HOME/startup.log
            touch $LOG
            chmod a+r $LOG
            echo "Processing $INST \"$ORACLE_SID\": log file $ORACLE_HOME/startup.log"
            startinst >> $LOG 2>&1
        fi
        ;;
    esac
done