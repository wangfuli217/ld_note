#!/bin/bash

RAWDBFILE=./rawdata.db
CONFIGDBFILE=./config.db
SESSIONDBFILE=./session.db
DATADBFILE=./data.db

rm -f $CONFIGDBFILE $SESSIONDBFILE $DATADBFILE $RAWDBFILE


sqlite3 $SESSIONDBFILE < ../createTableSQL.sql
sqlite3 $SESSIONDBFILE <<EOF
INSERT INTO User VALUES ('admin','blue4eye','admin@localhost',2);
INSERT INTO User VALUES ('user','blue4eye','user@localhost',2);
INSERT INTO User VALUES ('jean','blue4eye', 'jean@localhost',1);
EOF

sqlite3 $CONFIGDBFILE < /etc/BEV/BlueCount/default/createBlueProcessedDBSQL.sql

# generate locations
sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO Locations VALUES (0, "France", "false");
INSERT INTO Locations VALUES (1, "Royaume-Uni", "false");
INSERT INTO Locations VALUES (2, "Irlande", "false");
INSERT INTO Locations VALUES (3, "Andorre", "false");
INSERT INTO Locations VALUES (4, "Espagne", "false");
INSERT INTO Locations VALUES (5, "Portugal", "false");
INSERT INTO Locations VALUES (6, "Monaco", "false");
INSERT INTO Locations VALUES (7, "Belgique", "false");
INSERT INTO Locations VALUES (8, "Luxembourg", "false");
INSERT INTO Locations VALUES (9, "Suisse", "false");
INSERT INTO Locations VALUES (10, "Italie", "false");
INSERT INTO Locations VALUES (11, "Allemagne", "false");
INSERT INTO Locations VALUES (12, "Pays-Bas", "false");
EOF

NBLOC=12

# generate doors
sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO Doors VALUES (0, "Manche", 0, 1);
INSERT INTO Doors VALUES (1, "Aughnacloy A5", 1, 2);
INSERT INTO Doors VALUES (2, "Middletown A3", 1, 2);
INSERT INTO Doors VALUES (3, "Teemore A509", 1, 2);
INSERT INTO Doors VALUES (4, "Pennyburn A2", 1, 2);
INSERT INTO Doors VALUES (5, "Newry A1", 1, 2);
INSERT INTO Doors VALUES (6, "Soldeu CG-2", 0, 3);
INSERT INTO Doors VALUES (7, "Sant Juli� de Loria CG-1", 3, 4);
INSERT INTO Doors VALUES (8, "Hendaye N10", 0, 4);
INSERT INTO Doors VALUES (9, "Ainhoa D20", 0, 4);
INSERT INTO Doors VALUES (10, "Saint Jean-Pied-de-Port D933", 0, 4);
INSERT INTO Doors VALUES (11, "Larrau D936", 0, 4);
INSERT INTO Doors VALUES (12, "Les Eaux-Chaudes D934", 0, 4);
INSERT INTO Doors VALUES (13, "Prats-de-Mollo-la-Preste D115", 0, 4);
INSERT INTO Doors VALUES (14, "Cerb�re N114", 0, 10);
INSERT INTO Doors VALUES (15, "Sospel D2204", 0, 10);
INSERT INTO Doors VALUES (16, "Tunnel de Frejus", 0, 10);
INSERT INTO Doors VALUES (17, "Larche D900", 0, 10);
INSERT INTO Doors VALUES (18, "Tunnel du Mont Blanc", 0, 10);
EOF

NBDOORS=19

# generate all oriented doors automatically
tmpfile="od.$$"
echo sqlite3 $CONFIGDBFILE '<<EOF' > $tmpfile
i=0
j=0
while [ $i -lt $NBDOORS ] ; do
echo INSERT INTO OrientedDoors VALUES\($j, $i, 1\)\; >> $tmpfile
echo INSERT INTO CountersAssoc VALUES\(\"$j\", $j\)\; >> $tmpfile
echo INSERT INTO CountersAvailable VALUES\(\"$j\", \"localhost\", \"test\"\)\; >> $tmpfile
let j++
echo INSERT INTO OrientedDoors VALUES\($j, $i, 2\)\; >> $tmpfile
echo INSERT INTO CountersAssoc VALUES\(\"$j\", $j\)\; >> $tmpfile
echo INSERT INTO CountersAvailable VALUES\(\"$j\", \"localhost\", \"test\"\)\; >> $tmpfile
let i++
let j++
done
echo 'EOF' >> $tmpfile
source $tmpfile

rm -f $tmpfile

# generate area
sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO Areas VALUES (0, "Benelux");
INSERT INTO Areas VALUES (1, "Peninsule Ib�rique");
INSERT INTO Areas VALUES (2, "Europe");
EOF

# generate area location assoc
sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO AreaLocationAssoc VALUES (0, 7);
INSERT INTO AreaLocationAssoc VALUES (0, 8);
INSERT INTO AreaLocationAssoc VALUES (0, 12);
INSERT INTO AreaLocationAssoc VALUES (1, 4);
INSERT INTO AreaLocationAssoc VALUES (1, 5);
INSERT INTO AreaLocationAssoc VALUES (2, 0);
INSERT INTO AreaLocationAssoc VALUES (2, 1);
INSERT INTO AreaLocationAssoc VALUES (2, 2);
INSERT INTO AreaLocationAssoc VALUES (2, 3);
INSERT INTO AreaLocationAssoc VALUES (2, 6);
INSERT INTO AreaLocationAssoc VALUES (2, 9);
INSERT INTO AreaLocationAssoc VALUES (2, 10);
INSERT INTO AreaLocationAssoc VALUES (2, 11);
EOF

# generate area area assoc
sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO AreaAreaAssoc VALUES (2, 0);
INSERT INTO AreaAreaAssoc VALUES (2, 1);
EOF

# generate door groups
sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO DoorGroups VALUES (0, "Les Pyr�n�es");
INSERT INTO DoorGroups VALUES (1, "Les Alpes");
EOF

# generate door group assoc
sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO DoorGroupAssoc VALUES (0, 8, 1);
INSERT INTO DoorGroupAssoc VALUES (0, 9, 1);
INSERT INTO DoorGroupAssoc VALUES (0, 10, 1);
INSERT INTO DoorGroupAssoc VALUES (0, 11, 1);
INSERT INTO DoorGroupAssoc VALUES (0, 12, 1);
INSERT INTO DoorGroupAssoc VALUES (0, 13, 1);
INSERT INTO DoorGroupAssoc VALUES (1, 14, 1);
INSERT INTO DoorGroupAssoc VALUES (1, 15, 1);
INSERT INTO DoorGroupAssoc VALUES (1, 16, 1);
INSERT INTO DoorGroupAssoc VALUES (1, 17, 1);
INSERT INTO DoorGroupAssoc VALUES (1, 18, 1);
EOF

# generate door group location assoc
sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO DoorGroupLocationAssoc VALUES (0, 0);
INSERT INTO DoorGroupLocationAssoc VALUES (1, 0);
EOF

# add calendars values
sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO Calendars VALUES (0, "Default");
INSERT INTO Calendars VALUES (1, "Apr�s-midi");
EOF

sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO CalData VALUES (0, 0, 0, "Dimanche", "sunday", "%", "%", 0);
INSERT INTO CalData VALUES (1, 0, 1, "Samedi", "saturday", "8h30", "12h30", 1);
INSERT INTO CalData VALUES (2, 0, 2, "Autres", "%", "8h30", "18h30", 1);
EOF

# add processing table value
tmpfile="dcp.$$"
echo sqlite3 $CONFIGDBFILE '<<EOF' > $tmpfile
i=0
while [ $i -lt $NBDOORS ] ; do
echo INSERT INTO DoorCountingProcessing VALUES\($i, $i\)\; >> $tmpfile
let i++
done
echo 'EOF' >> $tmpfile
source $tmpfile
rm -f $tmpfile

sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO DoorGroupCountingProcessing VALUES (0, 0);
INSERT INTO DoorGroupCountingProcessing VALUES (1, 1);
EOF

tmpfile="lcp.$$"
echo sqlite3 $CONFIGDBFILE '<<EOF' > $tmpfile
i=0
while [ $i -lt $NBLOC ] ; do
echo INSERT INTO LocationCountingProcessing VALUES\($i, $i\)\; >> $tmpfile
let i++
done
echo 'EOF' >> $tmpfile
source $tmpfile
rm -f $tmpfile

sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO AreaCountingProcessing VALUES (0, 0);
INSERT INTO AreaCountingProcessing VALUES (1, 1);
INSERT INTO AreaCountingProcessing VALUES (2, 2);
EOF

sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO AreaNumberingProcessing VALUES (0, 0);
INSERT INTO AreaNumberingProcessing VALUES (1, 1);
INSERT INTO AreaNumberingProcessing VALUES (2, 2);
EOF

sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO AreaWaitingTimeProcessing VALUES (0, 1, 0, 1);
EOF


# init the function list used to compute the data
sqlite3 $CONFIGDBFILE <<EOF
INSERT INTO AutomaticallyComputedTableInfo VALUES("OrientedDoorCounting_MINUTE","OrientedDoorCounting","MINUTE",1,"BCL_getOrientedDoorWithSensor","BCTask_OrientedDoorCounting_MINUTE","2007-07-16 10:58:00");
INSERT INTO AutomaticallyComputedTableInfo VALUES("LocationNumbering_MINUTE","LocationNumbering","MINUTE",1,"BCL_getLocationWithSensor","BCTask_LocationNumbering_MINUTE","2007-07-16 10:58:00");
INSERT INTO AutomaticallyComputedTableInfo VALUES("AreaNumbering_MINUTE","AreaNumbering","MINUTE",1,"BCL_getAreaNumberingProcessingIds","BCTask_AreaNumbering_MINUTE","2007-07-16 10:58:00");
INSERT INTO AutomaticallyComputedTableInfo VALUES("DoorCounting_MINUTE","DoorCounting","MINUTE",1,"BCL_getDoorCountingProcessingIds","BCTask_DoorCounting_MINUTE","2007-07-16 10:58:00");
INSERT INTO AutomaticallyComputedTableInfo VALUES("DoorGroupCounting_MINUTE","DoorGroupCounting","MINUTE",1,"ProcessedDB_getDoorGroupCountingProcessingIds","BCTask_DoorGroupCounting_MINUTE","2007-07-16 10:58:00");
INSERT INTO AutomaticallyComputedTableInfo VALUES("LocationCounting_MINUTE","LocationCounting","MINUTE",1,"ProcessedDB_getLocationCountingProcessingIds","BCTask_LocationCounting_MINUTE","2007-07-16 10:58:00");
INSERT INTO AutomaticallyComputedTableInfo VALUES("AreaCounting_MINUTE","AreaCounting","MINUTE",1,"ProcessedDB_getAreaCountingProcessingIds","BCTask_AreaCounting_MINUTE","2007-07-16 10:58:00");
INSERT INTO AutomaticallyComputedTableInfo VALUES("AreaWaitingTime_MINUTE","AreaWaitingTime","MINUTE",1,"ProcessedDB_getAreaWaitingTimeProcessingIds","BCTask_AreaWaitingTime_MINUTE","2007-07-16 10:58:00");
EOF

# generate the raw counter value table
# generate the BCL table
source /etc/BEV/scripts/BlueCountLanguage.inc
BTOP_SERVER_DBFILE=$RAWDBFILE
BCL_DB_FILE=$DATADBFILE
BTopServer_installDB
BCL_installDB

# generate counting values
php generateCounts.php | sqlite3 -echo $RAWDBFILE

# fill databases
# ./pushTasks.sh


