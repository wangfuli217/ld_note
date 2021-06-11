#!/bin/sh

. /etc/BEV/scripts/BTopLocalServer/BTopServerTask.inc
. /etc/BEV/scripts/BTopLocalServer/BlueCountTask.inc

RAWDBFILE=./rawdata.db
CONFIGDBFILE=./config.db
SESSIONDBFILE=./session.db
DATADBFILE=./data.db

TASKDBFILE=./task.db

rm -f $TASKDBFILE

sqlite3 $TASKDBFILE < /etc/BEV/BlueCount/default/createBlueTasksDBSQL.sql

PROCESSED_DB_DBFILE=$CONFIGDBFILE
BTOP_SERVER_DBFILE=$RAWDBFILE
BCL_DB_FILE=$DATADBFILE
BTOP_SERVER_TASK_DB=$TASKDBFILE

tmpfile=tasks$$

echo "Generate tasks"
php generateTasks.php $tmpfile.t $tmpfile.q > $tmpfile

echo "Call bash functions"
source $tmpfile

rm -f $tmpfile

NBTRYMAX=1

echo "Read task file and translate tasks to SQL"
cat $tmpfile.t | (
    while read aline; do
	BTopServerTask_getAddTaskSQL "$aline" $NBTRYMAX >> $tmpfile
    done )

cat $tmpfile | sqlite3 $TASKDBFILE

echo "Apply query tasks to DB"
BCL_applyOnConfigDBFile $tmpfile.q

\rm -f $tmpfile $tmpfile.q $tmpfile.t

# PROCESS TASK

echo "PPTask" "process task"
echo "SELECT id, nbTry, nbTryMax, str FROM tasks;" | sqlite3 $TASKDBFILE | awk -F '|' '{ print "BTopServerTask_processATask '$tmpfile.q' " $1 " " $2 " " $3 " \"" $4 "\""}' > $tmpfile

echo "Call bash functions"
cat $tmpfile | (
    while read aline; do
	echo $aline
	eval $aline
	echo "************ RES = $?" > /tmp/toto
    done )

echo "Delete tasks"
cat $tmpfile.q | sqlite3 $TASKDBFILE

\rm -f $tmpfile $tmpfile.q

# BTopServerTask_processTasks

echo "PPTask" "end"


