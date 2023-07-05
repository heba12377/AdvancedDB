use SD
----1---------
create default def1 as 'NY'
create rule r1 as @x in('NY','DS','KW')

sp_addtype loc,'nchar(2)'

sp_bindrule r1,loc
sp_bindefault def1,loc

create table Department(
DeptNo varchar(3) primary key,
DeptName varchar(20),
Location loc)

insert into Department(DeptNo,DeptName,Location)
values('d1','Research','NY')

insert into Department(DeptNo,DeptName,Location)
values('d2','Accounting','DS')

insert into Department(DeptNo,DeptName,Location)
values('d3','Markiting','KW')

select * from Department

-------------
create table Employee(
EmpNo int primary key,
EmpFName varchar(20) not null,
EmpLName varchar(20) not null,
DeptNo varchar(3),
Salary int unique,
constraint foreignKey foreign key (DeptNo) references Department (DeptNo)
)
 create rule salRule as @sal<6000
 sp_bindrule salRule,'Employee.Salary'

 insert into Employee(EmpNo,EmpFName,EmpLName,DeptNo,Salary)
 values(25348,'Mathew','Smith','d3',2500)

 insert into Employee(EmpNo,EmpFName,EmpLName,DeptNo,Salary)
 values(10102,'Ann','Jones','d3',3000)

 insert into Employee(EmpNo,EmpFName,EmpLName,DeptNo,Salary)
 values(18316,'John','Barrimore','d1',2400)
 
 select * from Employee

 alter table Employee add telephoneNumber varchar(11)

alter table Employee drop column telephoneNumber
-------------
-------2---------
create schema Company
alter schema Company transfer Department
alter schema Company transfer project

create schema HumanResource
alter schema HumanResource transfer Employee

---3-----------------
select CONSTRAINT_NAME, CONSTRAINT_TYPE 
from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where TABLE_NAME = 'Employee'
----4-------------------

create synonym Emp
for HumanResource.Employee

select * from Employee
select * from HumanResource.Employee
select * from Emp
select * from HumanResource.Emp
---------5---------
update Company.Project
set Budgut += Budgut * 0.1 
from Emp ,Works_on w
where Emp.EmpNo =  w.EmpNo and Emp.EmpNo = 10102

---6--------------

update Company.Department
set DeptName = 'Sales'
where DeptNo = (select DeptNo from Emp
				where EmpFName = 'Mathew')

select * from Company.Department

------7---------------
update Works_on
set Enter_Date = '12.12.2007'
from Emp , Works_on s,Company.Department d
where Emp.EmpNo = s.EmpNo and s.ProjectNo = 'p1'
and d.DeptNo = Emp.DeptNo and DeptName = 'Sales'

------8------
delete from Works_on
where EmpNo in (select EmpNo 
		from Emp,Company.Department d
		where d.DeptNo = Emp.DeptNo and d.Location ='KW')

	


