use ITI

Select * from student

create Procedure getstud
as
Select * from student

--calling
getstud
exec getstud
execute getstud

alter Proc hr.getstbyadd @add varchar(20)
with encryption
as
   select st_id,st_fname
   from student
   where St_Address=@add

 --calling
getstbyadd 'cairo'
getstbyadd 'alex'

alter schema hr transfer getstbyadd

drop proc hr.getstbyadd

sp_helptext '[hr].getstbyadd'
----------------------------------
--DML  +SP

delete from topic where top_id=1

alter Proc DelTopic @tid int
as
	if not exists(select top_id from course where top_id=@tid)
		delete from topic where top_id=@tid
	else
		select 'table has relation'


Deltopic 3
----------------------------------------------------
--parameters
alter proc sumdata @x int=200,@y int=100
as
	select @x+@y
	
sumdata 10,70  --passing parameters by position
sumdata @y=6,@x=2  --passing Paramters by name	
sumdata 2
sumdata	
---------------------------------------------
--return values
alter schema dbo transfer hr.getstbyadd

alter Proc getstbyadd @add varchar(20)

as
   select st_id,st_fname
   from student
   where St_Address=@add

--calling
declare @t table(x int,y varchar(20))
insert into @t
execute getstbyadd 'cairo'	
select * from @t
select count(*) from @t

insert into tab5
execute getstbyadd 'alex'	
---------------------------------------------
create Proc getmydata @id int
as
	declare @age int
		select @age=st_age from student
		where st_id=@id
	return @age

declare @x int
execute @x=getmydata 1
select @x

alter Proc getmydata @id int,@age int output,@name varchar(20) output
as
		select @age=st_age,@name=st_fname from student
		where st_id=@id
	
declare @x int,@y varchar(20)
execute getmydata 3,@x output,@y output
select @x,@y
-------------------------------------------------------------------
alter Proc getmydata @age int output,@name varchar(20) output
as
		select @age=st_age,@name=st_fname from student
		where st_id=@age
	
declare @x int=3,@y varchar(20)
execute getmydata @x output,@y output
select @x,@y
-------------------------------------------
--dynamic query
create Proc getvalues @col varchar(20),@t varchar(40)
as
	execute('select '+@col+' from '+@t)

execute getvalues 'salary','instructor'

alter Proc getvalues @col varchar(20),@t varchar(40),@cond varchar(20)
as
	execute('select '+@col+' from '+@t+' where '+@cond)

execute getvalues '*','instructor','ins_id=1'
-----------------------------------------------------------
--3 types of SP
-----builtin SP
SP_bindrule  sp_unbindefault  sp_helptext  sp_helpconstraint  sp_rename sp_who sp_addtype

--user defined SP
getvalues  getstud   getstbyadd   sumdata

--Trigger
--special type of SP
--automatic call
--can't parameters
--implicit code listen ===>events
--triggers [tables]   insert   update  delete (log)       [tuncate,select]

insert into student(st_id,st_fname)
values(90,'ahmed')

Create trigger t1
on student
after insert
as
	select 'welcome to ITI'

insert into student(st_id,st_fname)
values(91,'ahmed')

create trigger t2
on student
for update
as
	select getdate(),suser_name(),db_name()

update student
	set st_Age+=1

create trigger t3
on student
instead of delete
as
	select 'not allowed' 

delete from student where st_id=90

create trigger t4
on department
instead of insert,update,delete
as
	select 'not allowed for user= '+suser_name()


alter table department disable trigger t4
alter table department enable trigger t4



update Department set Dept_Name='cloud'
where dept_id=30

-------------------------------------
alter trigger t5
on course
after update
as
	if update(crs_name)
		select 'welcome to ITI'
	else
		select getdate()

update course
	set crs_name='html5',crs_duration=100
where crs_id=-1




create trigger t10
on course 
after update
as
	select * from inserted
	select * from deleted

update course
	set crs_name='Cloud',crs_duration=100,top_id=1
where crs_id=400


create trigger t11
on course
instead of delete
as
	select 'not allowed to delete course name= '+(select crs_name from deleted)


delete from course where crs_id=1200
delete from course where crs_id=1100


create trigger t12
on student
instead of insert
as
	if format(getdate(),'dddd')='friday'
		select 'not allowed'
	else
		insert into student
		select * from inserted

create trigger t13
on student
after insert
as
	if format(getdate(),'dddd')='friday'
		begin
		select 'not allowed'
		delete from Student where st_id=(select st_id from inserted)
		end

insert into student
values(100,'ahmed')

------------------------------------------------------
create table history
(
 _user varchar(100),
 _date date,
 _oldid int,
 _Newid int
)


create trigger t20
on topic
instead of update
as
	if update(top_id)
		begin
			declare @old int,@new int
			select @old=top_id from deleted
			select @new=top_id from inserted
			insert into history
			values(suser_name(),getdate(),@old,@new)
		end

-----------------------------------------------------
--output

update instructor
	set salary=9000
output getdate(),suser_name()
where ins_id=4


delete from instructor
output deleted.ins_name
where ins_id=15

delete from instructor
where ins_id=14


update instructor
	set ins_id=500
output suser_name(),getdate(),deleted.ins_id,inserted.ins_id  into history
where ins_id=777
-------------------------------------------------------------------


delete from instructor
output suser_name(),getdate(),deleted.ins_id,NULL,'delete' into history
where ins_id=500

--------------------------------------------------------------------
--SP
--Trigger
--backup






















	 




