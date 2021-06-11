#!/bin/bash
#
# \file profileQuery.sh
# \author fab
# \parameters $1 database name
#

database=$1

echo "*** ProfileQuery :"
echo "******************"
echo "database = $database"
echo -n "FlowData size = "
echo "select count(*) from FlowData;" | sqlite3 $database
echo "******************"

echo "*** Profiling a query :"
echo "***********************"
QUERY="select sum(fin.value), sum(fout.value), sum(fin.value - fout.value), strftime('%H',min(fin.ts)) 
from CountersAssoc as assoc1, CountersAssoc as assoc2, FlowData as fin, FlowData as fout 
where fin.ts=fout.ts 
and fin.id=assoc1.id and assoc1.src=2 
and fout.id=assoc2.id and assoc2.dst=2 
and date(fin.ts)='2007-01-31' group by strftime('%H', fin.ts);" 
echo "$QUERY"
echo "***********************"
echo "start = "`date`
echo "***********************"
time echo $QUERY | sqlite3 $database
echo "***********************"
echo "end = "`date`
echo "***********************"

echo "*** Profiling a query :"
echo "***********************"
QUERY="select E.v, S.v, E.v - S.v, strftime('%H', E.ts) 
       from (select sum(value) as v, ts from FlowData where date(ts)='2007-01-31' and id=0 group by strftime('%H', ts)) as E, 
            (select sum(value) as v, ts from FlowData where date(ts)='2007-01-31' and id=1 group by strftime('%H', ts)) as S 
       where E.ts=S.ts;"
echo "$QUERY"
echo "***********************"
echo "start = "`date`
echo "***********************"
time echo $QUERY | sqlite3 $database
echo "***********************"
echo "end = "`date`
echo "***********************"

