use master
go
create database TouroClinic
go
use TouroClinic
go


create table EMPLOYEETYPE (
   EmpTypeID int not null,
   EmpTypeDescription varchar(20) not null,
   constraint [PK_EmployeeType] primary key (EmpTypeID),
   constraint [UIX_EmplTypeDesc]unique (EmpTypeDescription)

)

insert into EMPLOYEETYPE 
    values (1,'DOCTOR'),
           (2,'RECEPTIONIST'),
           (3,'BOOKKEEPER'),
           (4,'ACCOUNTANT'),
           (5,'LAB TECHNICIAN'),
           (6, 'NURSE'),
           (7, 'GUARD'),
(8, ‘ITAdmin’),
           ( 9, ‘DBA’)    


create table PAYROLLTYPE(
    PayrollTypeID int not null,
    PayrollTypeDesc varchar(10) not null,
    constraint [PK_PayrollType] primary key (PayrollTypeID),
    constraint [UIX_PayrollTypeDesc] unique(PayrollTypeDesc)

);

insert into PAYROLLTYPE
values (1, 'MONTHLY'),
       (2, 'WEEKLY'),
       (3, 'HOURLY')
       
       

create table EMPLOYEE(
   EmployeeID int not null,
   FirstName varchar(15) not null,
   LastName varchar(35) not null,
   Birthdate date not null,
   SocialSecNum  char (9) not null,
   CellPhone char(10)not null,
   HireDate date not null,
   EmployeeType int not null,
   PayrollType int not null,   
   CurrentPayAmount decimal(7,2),
   TotalPayrollReceipts decimal(7,2),
   constraint [PK_Employee] primary key (EmployeeID),
   constraint [UIX_EmpSSNum]unique (SocialSecNum),
   constraint [CHK_HireDate] check (dateDiff(year,birthdate,hiredate)>=18),
   constraint [FK_EMP_EMPTYPE] foreign key (EmployeeType)
      references EMPLOYEETYPE(EmpTypeID),
   constraint [FK_EMP_PAYROLLTYPE] foreign key (PayrollType)
     references PAYROLLTYPE(PayrollTypeID)  ,
    constraint [CHK_PAY] check (  CurrentPayAmount > 0 and
        CurrentPayAmount <=30000)
      
 );



create table SPECIALTYCODE(
   SpecialtyID int not null,
   SpecialtyCodeDesc varchar(20) not null,
   constraint [PK_SpecialtyCODE] primary key (SpecialtyID),
   constraint [UIX_SpecialtyCode] unique(SpecialtyCodeDesc)
)

insert into SPECIALTYCODE
  values (1, 'PEDIATRICS'),
          (2, 'CARDIOLOGY'),
          (3, 'PULMONOLOGY'),
          (4,'RADIOLOGY'),
          (5,'HEMOTOLOGY')
           
  

CREATE TABLE DOCTOR(
	DoctorID int NOT NULL,
	EmergencyPhoneNumber char(10) NOT NULL,
	SpecialtyID int NOT NULL,
 CONSTRAINT [PK_DOCTOR] PRIMARY KEY (DoctorID) ,
 constraint [FK_DOCTOR_EMPLOYEE] foreign key (DoctorID)
   references Employee(EmployeeID),
  constraint [FK_DOCTOR_SPECIALTY] foreign key (SpecialtyID)
   references SpecialtyCode ( SpecialtyID)
   );
create table PAYROLLTRANSACTIONS(
   TransactionDate date not null,
   EmpID int not null,
   GrossPay decimal(5,2) not null,
   TaxWithHeld decimal(5,2) not null default (0),
   AddAmtWithHeld decimal (5,2) not null default (0),
   NetPay decimal(5,2) not null,
   constraint [PK_PayrollTrans] primary key (TransactionDate,EmpID),
   constraint [FK_PayTrans_Emp] foreign key (EmpID)
    references Employee(EmployeeID),
   constraint [CHK_TAXAMT] check ( TaxWithHeld < GrossPay),
   constraint [CHK_NetPay] check (NetPay <= grosspay)
);
