#!/bin/sh

CSV=$1
DB=$2

echo "Importing $1 into $2..."
sqlite3 $2 <<EOF
.mode csv
.import $1 data
EOF

echo "Creating Modules table..."
sqlite3 $2 <<EOF
CREATE TABLE Modules(id INTEGER PRIMARY KEY, Name TEXT);
INSERT INTO Modules SELECT DISTINCT null,Source from data;
EOF

echo "Creating Functions Table..."
sqlite3 $2 <<EOF
PRAGMA foreign_keys=on;
CREATE TABLE Functions(id INTEGER PRIMARY KEY, Name TEXT, Insts INTEGER, Hash INTEGER, ModuleID INTEGER, FOREIGN KEY (ModuleID) REFERENCES Modules(id));
INSERT INTO Functions SELECT null,FuncName,Insts,Hash,M.id FROM data T INNER JOIN Modules M ON T.Source = M.Name;
EOF

echo "Removing raw data and cleaning up..."
sqlite3 $2 <<EOF
DROP TABLE data;
vacuum;
EOF
