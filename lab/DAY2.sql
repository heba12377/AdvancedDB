use ITI
----------1-----------
create function getMonth(@date date)
returns varchar(20)
begin
	declare @name varchar(20)
	select @name = FORMAT(@date,'MMMM')
	return @name
end

select dbo.getMonth('2000-03-12')

-------2----------------
create function valueBetween(@first int ,@secound int)
returns @t table(
		Numbers int 
	)
as
begin
	declare @i int = @first
	while @i < @secound - 1
		begin
			set @i += 1
			insert into @t
			select @i
		end
	return
end


select * from valueBetween(1,5)

-----------3------------
create function getDName(@sid int)
returns table
as 
return
(
	select Dept_Name,CONCAT(St_Fname,' ', St_Lname ) as fullName
	from Student s ,Department d
	where s.Dept_Id = d.Dept_Id and s.St_Id = @sid
)

select * from getDName(6)

-----------4-------------
alter function UsreMessage(@sid int)
returns varchar(150)
begin
	declare @f varchar(20),@l varchar(20),@message varchar(150)
	select @f =  St_Fname
			  from Student
			  where St_Id = @sid
	select @l =  St_Lname
			from Student
			where St_Id = @sid
	if (@f is NULL and @l is NULL)
		select @message = 'first name and last name is null'
	else if(@f is NULL)
		select  @message ='first name is null'
	else if(@l is NULL)
		select @message = 'last name is null'
	else
		select @message ='first name and last name is not null'
	return @message
end

select dbo.UsreMessage(1)

---------5--------------

alter function display(@mid int)
returns table
as 
return
(
	select Dept_Name, Dept_Manager, Manager_hiredate, Ins_Name as Manager_Name 
	from Department D, Instructor I
	where @mid = D.Dept_Manager AND I.Ins_Id = D.Dept_Manager
)

select * from display(1)

--------6----------

create function Strin(@string varchar(50))
returns @t table(
		StudentNames varchar(50)
	)
as
begin
	if @string='fullname'
		insert @t
		select isnull(st_fname+' '+st_lname,'') 
		from student

	else if @string='firstname'
		insert  into @t
		select isnull(st_fname,'')
		from student
	else if @string='lastname'
		insert  into @t
		select isnull(St_Lname,'')
		from student
	return
end


select * from Strin('lastname')

--------7-----------

select St_Id ,substring(St_Fname,1,len(St_Fname) - 1) as firstName 
from Student

---8--------

update Stud_Course
set Grade = ''
from Department d,Stud_Course c,Student s
where d.Dept_Id = s.Dept_Id and s.St_Id = c.St_Id and Dept_Name = 'SD'


------Bouns------
--2---
declare @i int = 3000

while(@i < 6000)
begin
	insert into Student(St_Id,St_Fname,St_Lname)
	values(@i,'Jann','Smith')
set @i += 1
end
select @@ROWCOUNT