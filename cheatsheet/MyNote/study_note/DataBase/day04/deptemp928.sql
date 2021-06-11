drop table dept928 cascade constraints;
drop table emp928  cascade constraints;
create table dept928(
		did  number primary key,
		dname varchar2(30)
		);
create table emp928(
		eid number primary key,
		ename varchar2(30) not null,
		esalary number not null,
		dept_id constraint emp928_dept_id_fk references dept928(did) on delete set null
		);
	insert into dept928 values(1,'test1');
	insert into dept928 values(2,'test2');
	insert into emp928 values(1,'ea',5000,1);
	insert into emp928 values(2,'eb',7000,1);
	insert into emp928 values(3,'ec',8500,1);
	insert into emp928 values(4,'ed',12000,2);
	insert into emp928 values(5,'ee',18000,2);
	commit;
