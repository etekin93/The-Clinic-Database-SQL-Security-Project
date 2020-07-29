--STEP 1
use master 
go
create database TouroClinic
go
use TouroClinic
go

create table EMPLOYEETYPE(
EmpTypeID int not null,
EmpTypeDescription varchar(20) not null,
constraint [PK_EmployeeType] primary key (EmpTypeID),
constraint [UIX_EmpTypeDescription] unique (EmpTypeDescription)
)

insert into EMPLOYEETYPE 
values(1,'DOCTOR'),
(2,'RECEPTIONIST'),
(3,'BOOKKEEPER'),
(4,'ACCOUNTANT'),
(5,'LABTECHNICIAN'),
(6,'NURSE'),
(7,'GUARD'),
(8,'ITAdmin'),
(9,'DBA')

create table PAYROLLTYPE(
PayrollTypeID int not null,
PayrollTypeDesc varchar (10) not null,
constraint [PK_PayrollType] primary key (PayrollTypeID),
constraint [UIX_PayrollTypeDesc] unique (PayrollTypeDesc)
);

insert into PAYROLLTYPE
values(1,'MONTHLY'),
(2,'WEEKLY'),
(3,'HOURLY')

create table EMPLOYEE(
EmployeeID int not null,
FirstName varchar(15) not null,
LastName varchar(35) not null,
Birthdate date not null,
SocialSecNum char (9) not null,
CellPhone char (10) not null,
HireDate date not null,
EmployeeType int not null,
PayrollType int not null,
CurrentPayAmount decimal (7,2),
TotalPayrollReceipts decimal (7,2),
constraint [PK_Employee] primary key (EmployeeID),
constraint [UIX_EmpSSNum] unique (SocialSecNum),
constraint [CHK_HireDate ] check (datediff(year,Birthdate,HireDate) >=18),
constraint [FK_EMP_EMPTYPE] foreign key (EmployeeType) references EMPLOYEETYPE(EmpTypeID),
constraint [FK_EMP_PAYROLLTYPE] foreign key (PayrollType) references PAYROLLTYPE(PayrollTypeID),
constraint [CHK_PAY] check ( CurrentPayAmount > 0 and CurrentPayAmount <= 30000)
);

create table SPECIALTYCODE(
SpecialtyID int not null,
SpecialtyCodeDesc varchar(20) not null,
constraint [PK_SpecialtyCODE] primary key (SpecialtyID),
constraint [UIX_SpecialtyCode] unique (SpecialtyCodeDesc)
)

insert into SPECIALTYCODE
values(1,'PEDIATRICS'),
(2,'CARDIOLOGY'),
(3,'PULMONOLOGY'),
(4,'RADIOLOGY'),
(5,'HEMOTOLOGY')


create table DOCTOR (
DoctorID int not null,
EmergencyPhoneNumber char(10) not null,
SpecialtyID int not null,
constraint [PK_DOCTOR] primary key (DoctorID),
constraint [FK_DOCTOR_EMPLOYEE] foreign key (DoctorID) references EMPLOYEE(EmployeeID),
constraint [FK_DOCTOR_SPECIALTY] foreign key (SpecialtyID) references SPECIALTYCODE(SpecialtyID)
);

create table PAYROLLTRANSACTIONS (
TransactionDate datetime not null,
EmpID int not null,
GrossPay decimal(5,2) not null,
TaxWithHeld decimal (5,2) not null default(0),
AddAmtWithHeld decimal (5,2) not null default(0),
NetPay decimal (5,2) not null,
constraint [PK_PayrollTrans] primary key (TransactionDate,EmpID),
constraint [FK_PayTrans_Emp] foreign key (EmpID) references EMPLOYEE(EmployeeID),
constraint [CHK_TAXAMT] check (TaxWithHeld < GrossPay),
constraint [CHK_NetPay] check (NetPay <=GrossPay)
);


-- STEP 2 
insert into EMPLOYEE
values
('1','Emre','Tekin','08-29-1993','123456789','3471112233','01-01-2019','5','3','500.00','10000.00'),
('2','Emir','Ozkara','05-08-1993','234567891','3471112244','03-01-2017','9','3','500.00','60000.00'),
('3','Ozgur','Varol','01-02-1980','345678912','3471112255','05-07-2017','8','3','500.00','45000.00'),
('4','David','Thompson','04-03-1964','456789123','3471112266','03-01-2016','4','3','600.00','87360.00'),
('5','Andrea','Brose','09-01-1985','567891234','3471112277','06-06-2017','6','3','550.00','45760.00'),
('6','Leslie','Habel','06-02-1976','678912345','3471112288','02-04-2015','3','3','400.00','62400.00'),
('7','Luca','Albertini','08-08-1989','789123456','3471112299','10-05-2018','7','3','400.00','11000.00'),
('8','Steven','Gerard','05-06-1981','891234567','3472223344','06-25-2016','2','3','425.00','71000.00'),
('9','Adam','Alan','04-04-1986','912345678','3472223355','01-19-2019','1','3','800.00','9600.00'),
('10','Jerome','John','09-23-1977','112345678','3472223366','10-12-2017','1','3','900.00','78000.00'),
('11','Clay','Cedric','08-13-1973','111234567','3472223377','04-25-2017','1','3','950.00','93600.00'),
('12','Carlos','Alvarez','11-26-1980','111123456','3472223388','01-25-2018','1','3','980.00','52000.00'),
('13','Gerald','Adams','06-29-1986','111113456','3472223399','01-18-2018','1','3','950.00','57000.00')


insert into DOCTOR
values
('9','3472223333','4'),
('10','3473334444','5'),
('11','3474445555','1'),
('12','3475556666','2'),
('13','3476667777','3')

insert into PAYROLLTRANSACTIONS
values
('04-06-2019','1','500.00','142.00','58.00','300.00'),
('04-20-2019','9','800.00','192.00','58.00','550.00'),
('04-20-2019','10','900.00','203.00','97.00','600.00')

--STEP 4
create login [TC\TC_DBAs] from windows
create login [TC\TC_ITAdmins] from windows
create login [TC\TC_ACCOUNTANTS] from windows
create login [TC\TC_BOOKKEEPERS] from windows
create login [TC\TC_RECEPTIONISTS] from windows
create login [TC\TC_DOCTORS] from windows


alter server role sysadmin add member [TC\TC_DBAs]


grant create any database to [TC\TC_ITAdmins]


--STEP 5
create role [TC_DBAsRole]
create role [TC_ITadminsRole]
create role [TC_ACCOUNTANTSRole]
create role [TC_BOOKKEEPERSRole]
create role [TC_RECEPTIONISTSRole]
create role [TC_DOCTORSRole]
--STEP 6 in saved as a different file.
create view EmployeeData (EmpID, Fname, Lname,CellPhone, EmpType)
as (select EmployeeID , Firstname,LastName,CellPhone, EmployeeType from EMPLOYEE)

SELECT * FROM EmployeeData
--STEP 7
create schema ACCOUNTING
create schema HR

alter schema HR transfer dbo.EmployeeType
alter schema HR transfer dbo.Employee
alter schema HR transfer dbo.SpecialtyCode
alter schema HR transfer dbo.Doctor

alter schema ACCOUNTING transfer dbo.PayrollType
alter schema ACCOUNTING transfer dbo.PayrollTransactions

--STEP 8 
grant insert, select, update , delete 
on schema::ACCOUNTING to TC_ACCOUNTANTSRole
grant execute on object::[dbo].[usp_payrollTransaction] to TC_BOOKKEEPERSRole
grant select on object::HR.DOCTOR to TC_RECEPTIONISTSRole 
grant select on object::dbo.EmployeeData to TC_RECEPTIONISTSRole 
grant select on object::HR.DOCTOR to TC_DOCTORSRole
grant select on object::HR.SPECIALTYCODE to TC_DOCTORSRole

--step 9
create user [Dbauser] for login [TC\TC_DBAs]
create user [ITadminuser] for login [TC\TC_ITAdmins]
create user [Accountantuser] for login [TC\TC_ACCOUNTANTS]
create user [Bookkeeperuser] for login [TC\TC_BOOKKEEPERS]
create user [Receptionistuser] for login [TC\TC_RECEPTIONISTS]
create user [DoctorUser] for login [TC\TC_DOCTORS]

-- STEP 10
alter role TC_DBAsRole add member [Dbauser] 
alter role TC_ITadminsRole add member [ITadminuser]
alter role TC_ACCOUNTANTSRole add member [Accountantuser]
alter role TC_BOOKKEEPERSRole add member [Bookkeeperuser]
alter role TC_RECEPTIONISTSRole add member [Receptionistuser]
alter role TC_DOCTORSRole add member [DoctorUser]








	--Step 16 server roles that were assigned
	   SELECT suser_name(role_principal_id) as ServerRole
     FROM sys.server_role_members  role
 JOIN sys.server_principals AS member  
    ON role.member_principal_id = member.principal_id  
	join sys.database_principals dp
	on dp.principal_id=member.principal_id

	--Step 16 server level permissions that were assigned
	SELECT distinct spe.permission_name
FROM sys.database_role_members AS DRM 
   INNER JOIN sys.database_principals AS MEM 
         ON DRM.member_principal_id = MEM.principal_id 
     INNER JOIN sys.server_principals AS SP 
         ON MEM.[sid] = SP.[sid] 
		 inner join sys.server_permissions as spe
		 on sp.principal_id= spe.grantee_principal_id

--STEP16 database level roles and permissions that were assigned
select permission_name As DatabasePermissions ,dp.name As DatabaseRoles  
from sys.database_role_members drm
inner join sys.database_permissions DPER 
   on drm.role_principal_id = DPER.grantee_principal_id
  inner join sys.database_principals dp 
   on drm.role_principal_id = dp.principal_id

--STEP 17 
select EmployeeID,FirstName ,LastName ,Birthdate ,SocialSecNum ,CellPhone ,
HireDate ,EmployeeType ,PayrollType ,CurrentPayAmount ,TotalPayrollReceipts 
from HR.EMPLOYEE

select DoctorID ,EmergencyPhoneNumber,SpecialtyID 
FROM HR.DOCTOR

select TransactionDate, EmpID, GrossPay ,TaxWithHeld ,AddAmtWithHeld ,NetPay
from ACCOUNTING.PAYROLLTRANSACTIONS




   


   SELECT suser_name(role_principal_id) as ServerRole
     FROM sys.server_role_members  role
 JOIN sys.server_principals AS member  
    ON role.member_principal_id = member.principal_id  
	join sys.database_principals dp
	on dp.principal_id=member.principal_id




select SUSER_NAME(member_principal_id),role_principal_id 
from sys.server_principals sp inner join sys.database_role_members srm
on sp.principal_id=srm.role_principal_id



	


--STEP 18
	create procedure [dbo].[usp_payrollTransaction]
(@EmployeeID int ,
@GrossPay decimal (5,2),
@TaxWithHeld decimal (5,2),
@AddAmtWithHeld decimal (5,2))
as
BEGIN TRY
BEGIN TRANSACTION
declare @NetPay decimal (5,2)
select @NetPay=(GrossPay-(TaxWithHeld+AddAmtWithHeld)) from ACCOUNTING.PAYROLLTRANSACTIONS

Insert into ACCOUNTING.PAYROLLTRANSACTIONS(TransactionDate,EmpID,GrossPay,
 TaxWithHeld,AddAmtWithHeld,NetPay)
 VALUES(GETDATE(),@EmployeeID,@GrossPay,@TaxWithHeld,@AddAmtWithHeld,
 @NetPay)

 Update HR.EMPLOYEE
 SET TotalPayrollReceipts=TotalPayrollReceipts+@GrossPay
 Where EmployeeID=@EmployeeID

COMMIT TRANSACTION
Print 'Committed Successfully'
END TRY
BEGIN CATCH
 IF @@TRANCOUNT > 0
 ROLLBACK TRANSACTION
Print 'Error in a script'
 END CATCH


GO
