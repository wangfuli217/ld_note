## 1. The SQLite Shell ##


# +--------------------------------+
# |                                |
# |     RUN THE COMMANDS BELOW     |
# |                                |
# +--------------------------------+
#
# /home/dq$ sqlite3 chinook.db
#
#  sqlite3> .tables
#  sqlite3> .headers on
#  sqlite3> .mode column
#  sqlite3> SELECT
#      ...>   track_id,
#      ...>   name,
#      ...>   album_id
#      ...> FROM track
#      ...> WHERE album_id = 3;
#  sqlite3> .help
#  sqlite3> .shell clear
#  sqlite3> .quit

## 2. Creating Tables ##


# +--------------------------------+
# |                                |
# |     RUN THE COMMANDS BELOW     |
# |                                |
# +--------------------------------+
#
# /home/dq$ sqlite3 new_database.db
#  sqlite3> CREATE TABLE user (
#      ...> user_id INTEGER,
#      ...> first_name TEXT,
#      ...> last_name TEXT
#      ...> );
#  sqlite3> .schema user
#  sqlite3> .quit
#
#
# +--------------------------------+
# |                                |
# |     👇 does the same as ☝️     |
# |                                |
# +--------------------------------+

sqlite3 new_database.db <<EOF
CREATE TABLE user (
    user_id INTEGER,
    first_name TEXT,
    last_name TEXT
);
EOF

## 3. Primary and Foreign Keys ##


# +--------------------------------+
# |                                |
# |     RUN THE COMMANDS BELOW     |
# |                                |
# +--------------------------------+
#
# /home/dq$ sqlite3 chinook.db
#  sqlite3> CREATE TABLE wishlist (
#      ...> wishlist_id INTEGER PRIMARY KEY,
#      ...> customer_id INTEGER,
#      ...> name TEXT,
#      ...> FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
#      ...> );
#  sqlite3> .quit
#
#
# +--------------------------------+
# |                                |
# |     👇 does the same as ☝️     |
# |                                |
# +--------------------------------+

sqlite3 chinook.db <<EOF
CREATE TABLE wishlist (
    wishlist_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    name TEXT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
EOF

## 4. Database Normalization ##


# +--------------------------------+
# |                                |
# |     RUN THE COMMANDS BELOW     |
# |                                |
# +--------------------------------+
#
# /home/dq$ sqlite3 chinook.db
#  sqlite3> CREATE TABLE wishlist_track (
#      ...> wishlist_id INTEGER,
#      ...> track_id INTEGER,
#      ...> PRIMARY KEY (wishlist_id, track_id),
#      ...> FOREIGN KEY (wishlist_id) REFERENCES wishlist(wishlist_id),
#      ...> FOREIGN KEY (track_id) REFERENCES track(track_id)
#      ...> );
#  sqlite3> .quit
#
#
# +--------------------------------+
# |                                |
# |     👇 does the same as ☝️     |
# |                                |
# +--------------------------------+

sqlite3 chinook.db <<EOF
CREATE TABLE wishlist_track (
    wishlist_id INTEGER,
    track_id INTEGER,
    PRIMARY KEY (wishlist_id, track_id),
    FOREIGN KEY (wishlist_id) REFERENCES wishlist(wishlist_id),
    FOREIGN KEY (track_id) REFERENCES track(track_id)
);
EOF

## 5. Inserting and Deleting Rows ##


# +--------------------------------+
# |                                |
# |     RUN THE COMMANDS BELOW     |
# |                                |
# +--------------------------------+
#
# /home/dq$ sqlite3 chinook.db
#  sqlite3> INSERT INTO wishlist
#      ...> VALUES
#      ...>     (1, 34, "Joao's awesome wishlist"),
#      ...>     (2, 18, "Amy loves pop");
#  sqlite3> INSERT INTO wishlist_track
#      ...> VALUES
#      ...>     (1, 1158),
#      ...>     (1, 2646),
#      ...>     (1, 1990),
#      ...>     (2, 3272),
#      ...>     (2, 3470);
#  sqlite3> .quit
#
#
# +--------------------------------+
# |                                |
# |     👇 does the same as ☝️     |
# |                                |
# +--------------------------------+

sqlite3 chinook.db <<EOF
INSERT INTO wishlist
VALUES
    (1, 34, "Joao's awesome wishlist"),
    (2, 18, "Amy loves pop");
INSERT INTO wishlist_track
VALUES
    (1, 1158),
    (1, 2646),
    (1, 1990),
    (2, 3272),
    (2, 3470);
EOF

## 6. Adding Columns to a Table ##


# +--------------------------------+
# |                                |
# |     RUN THE COMMANDS BELOW     |
# |                                |
# +--------------------------------+
#
# /home/dq$ sqlite3 chinook.db
#  sqlite3> ALTER TABLE wishlist
#      ...> ADD COLUMN active NUMERIC;
#  sqlite3> ALTER TABLE wishlist_track
#      ...> ADD COLUMN active NUMERIC;
#  sqlite3> .quit
#
#
# +--------------------------------+
# |                                |
# |     👇 does the same as ☝️     |
# |                                |
# +--------------------------------+

sqlite3 chinook.db <<EOF
ALTER TABLE wishlist
ADD COLUMN active NUMERIC;
ALTER TABLE wishlist_track
ADD COLUMN active NUMERIC;
EOF

## 7. Adding Values to Existing Rows ##


# +--------------------------------+
# |                                |
# |     RUN THE COMMANDS BELOW     |
# |                                |
# +--------------------------------+
#
# /home/dq$ sqlite3 chinook.db
#  sqlite3> UPDATE wishlist
#      ...> SET active = 1;
#  sqlite3> UPDATE wishlist_track
#      ...> SET active = 1;
#  sqlite3> .quit
#
#
# +--------------------------------+
# |                                |
# |     👇 does the same as ☝️     |
# |                                |
# +--------------------------------+

sqlite3 chinook.db <<EOF
UPDATE wishlist
SET active = 1;
UPDATE wishlist_track
SET active = 1;
EOF

## 8. Challenge: Adding Sales Tax Capabilities ##


# +--------------------------------+
# |                                |
# |     RUN THE COMMANDS BELOW     |
# |                                |
# +--------------------------------+
#
# /home/dq$ sqlite3 chinook.db
#  sqlite3> ALTER TABLE invoice
#      ...> ADD COLUMN tax NUMERIC;
#  sqlite3> ALTER TABLE invoice
#      ...> ADD COLUMN subtotal NUMERIC;
#  sqlite3> UPDATE invoice
#      ...> SET
#      ...>     tax = 0,
#      ...>     subtotal = total;
#  sqlite3> .quit
#
#
# +--------------------------------+
# |                                |
# |     👇 does the same as ☝️     |
# |                                |
# +--------------------------------+

sqlite3 chinook.db <<EOF
ALTER TABLE invoice
ADD COLUMN tax NUMERIC;
ALTER TABLE invoice
ADD COLUMN subtotal NUMERIC;
UPDATE invoice
SET
    tax = 0,
    subtotal = total;
EOF