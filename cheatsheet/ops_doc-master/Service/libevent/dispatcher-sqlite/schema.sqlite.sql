create table tbl_member (
  `memberid` integer primary key autoincrement not null,
  `username` varchar(50),
  `password` varchar(32),
  `address1` varchar(128),
  `address2` varchar(128),
  `email1` varchar(80),
  `email2` varchar(80),
  `city` varchar(30),
  `pin` varchar(30),
  `profession` varchar(60),
  `ipaddr` varchar(15),
  `phone1` varchar(30)
);

create table tbl_friend (
  `memberid` integer,
  `freindid` integer,
  primary key ("memberid", "freindid")
);

create unique index `username` on `tbl_member` (`username` asc);

create view `tbl_friend_list` as select a.username, c.ipaddr, c.username as username_a
from tbl_member a inner join tbl_friend b on a.memberid=b.memberid 
inner join tbl_member c on b.freindid=c.memberid;