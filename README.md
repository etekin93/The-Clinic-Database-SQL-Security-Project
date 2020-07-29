# The-Clinic-Database-SQL-Security-Project
In this project;
-Created and populated Touroclinic lab database with sample data.
-To provide security on server level, created organizational units, windows security groups (for employee types) and users in Windows Active Directory. Assigned each user to appropriate groups. 
-In Microsoft SQL Server, created logins for each Windows security group. Assigned appropriate server roles to logins. Created database roles for Touroclinic database and, created database users for each server login in Touroclinic database. Assigned appropriate database roles to database users.
-In client machine created TOURO CLINIC folder and within the TOURO CLINIC folder created two folders (DOCTOR FOLDER, ACCOUNTANT FOLDER). Prevented all TouroClinic security groups from accessing any folders on the local machine, besides for the Doctor and Accounting security groups.  Allowed the DOCTOR security group full rights the DOCTOR FOLDER and the Accounting security group full rights to the ACCOUNTANT FOLDER. Logged in to client machine as many times as the number of different users with different credentials each time to verify security rules.
Please, first see the project overview file,secondly populate sample database and, finally see the other steps.
