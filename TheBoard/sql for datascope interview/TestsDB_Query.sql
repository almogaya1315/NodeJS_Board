use master

drop database TestsDB

create database [TestsDB]
go
use TestsDB

create table Students
(
StudentId int primary key identity,
StudentName varchar(50) not null 
)

create table Tests
(
TestId int primary key identity,
TestName varchar(50) not null,
TestDate date not null, 
StudentId int references Students(StudentId) not null
)

insert into Students (StudentName) values('lior matsliah')

select *
from dbo.Students

declare @date date = '2017-7-17'
insert into Tests (TestName, TestDate, StudentId) values('Test', @date, 1)

select *
from dbo.Tests

go
with StudentNamedLior as
(
select *
from Students
where StudentId = 1
),

TestNamedTest as
(
select *
from Tests
where TestId = 1
)

select s.StudentName[Student], t.TestName[Test], t.TestDate[Date] 
from StudentNamedLior s join TestNamedTest t on s.StudentId = t.StudentId

GO
CREATE TRIGGER display_date_change ON Tests --OR REPLACE
AFTER UPDATE --BEFORE DELETE OR INSERT
AS
	PRINT 'Trigger message!';
GO
--WHEN NEW.TestId > 0
--DECLARE 
--	@date_diff int
--BEGIN
--	date_diff := :NEW.TestDate - :OLD.TestDate;
--	dbms_output.put_line('Old date: ' || :OLD.TestDate);
--	dbms_output.put_line('New date: ' || :NEW.TestDate);
--	dbms_output.put_line('date diff: ' || :date_diff);
--END;

update Tests
set TestName = 'Trigger Test'
where TestId = 1

select s.StudentName
from Students s
where StudentId = 1
except --union all --intersect
select t.TestName
from Tests t
where TestId = 1


GO
create procedure test_procedure
	@var1 varchar(10),
	@var2 int
AS 
	--PRINT @var1

	--select *
	--from Students 
	--where StudentName like @var1 --contains(StudentName, @var1) 
	
	select *
	from Students 
	where StudentId = @var2 --contains(StudentName, @var1) 


GO
alter procedure test_procedure
	@student_id int,
	@student_name varchar(50) output
AS
	select @student_name = s.StudentName
	from Students s
	where s.StudentId = @student_id
	return 

	
declare @name varchar(50)
execute test_procedure 1, @student_name = @name output; --N'lior matsliah', 1
print @name