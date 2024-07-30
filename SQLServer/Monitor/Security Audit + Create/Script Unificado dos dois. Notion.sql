USE MASTER
GO

-- Create the server audit - Precisar criar uma pasta no C: do server de nome SQL_LOG_SECURITY 
CREATE SERVER AUDIT Login_Audit
TO FILE ( FILEPATH ='C:\SQL_LOG_SECURITY\' );
GO
-- Enable the server audit
ALTER SERVER AUDIT Login_Audit WITH (STATE = ON) ;
GO
ALTER SERVER AUDIT SPECIFICATION Login_Audit
FOR SERVER AUDIT Login_Audit
ADD (SERVER_PERMISSION_CHANGE_GROUP),
ADD (SERVER_PRINCIPAL_CHANGE_GROUP),
ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP),
ADD (LOGIN_CHANGE_PASSWORD_GROUP)
WITH (STATE = OFF);
GO  
ALTER SERVER AUDIT SPECIFICATION Login_Audit  WITH (STATE = ON) ;

--ALTER SERVER AUDIT Login_Audit WITH (STATE = OFF);
--DROP SERVER AUDIT Login_Audit;
--ALTER SERVER AUDIT SPECIFICATION Login_Audit  WITH (STATE = OFF) ;
--DROP DATABASE AUDIT SPECIFICATION Login_Audit;  
  
--GO 

--DROP SERVER AUDIT Audit_DDL_Databases;
CREATE SERVER AUDIT Audit_DDL_Databases
TO FILE (FILEPATH = 'C:\SQL_LOG_SECURITY\')
WITH (ON_FAILURE = CONTINUE);
GO
ALTER SERVER AUDIT Audit_DDL_Databases WITH (STATE = ON);
GO
USE Ploomes_CRM;
GO
ALTER DATABASE AUDIT SPECIFICATION Audit_DDL_Databases WITH (STATE = OFF);
ALTER DATABASE AUDIT SPECIFICATION Audit_DDL_Databases
FOR SERVER AUDIT Audit_DDL_Databases
ADD (SCHEMA_OBJECT_CHANGE_GROUP),
ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP);
GO
ALTER DATABASE AUDIT SPECIFICATION Audit_DDL_Databases WITH (STATE = ON);
GO
--ALTER SERVER AUDIT Audit_DDL_Databases WITH (STATE = OFF);
--DROP SERVER AUDIT Audit_DDL_Databases;
--ALTER SERVER AUDIT SPECIFICATION Audit_DDL_Databases WITH (STATE = OFF);
--DROP DATABASE AUDIT SPECIFICATION Audit_DDL_Databases;  
/*
SELECT 
	event_time,
	action_id, 
	statement,
	object_name, 
	database_name, 
	server_principal_name as AlteradoPor
FROM fn_get_audit_file( 'C:\SQL_LOG_SECURITY\*.sqlaudit' , DEFAULT , DEFAULT)
order by 1 desc;

-- Testando auditoria criada
CREATE LOGIN teste WITH PASSWORD=N'vxxxxx', DEFAULT_DATABASE=master, DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF; 
ALTER LOGIN teste WITH PASSWORD=N'03)ugp(P0)*HgKj';
DROP LOGIN teste;

Use ploomes_CRM
go

create table Teste (id Int)
alter table teste add idade int
drop table Teste

select * from sys.server_audits
select * from sys.server_audit_specifications
GO 
*/