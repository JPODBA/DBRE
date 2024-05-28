USE master;
GO
--DROP SERVER AUDIT Audit_DDL_Databases;
CREATE SERVER AUDIT Audit_DDL_Databases
TO FILE (FILEPATH = 'C:\SQL_LOG_SECURITY\')
WITH (ON_FAILURE = CONTINUE);
GO
ALTER SERVER AUDIT Audit_DDL_Databases WITH (STATE = ON);
GO
USE BA_DBA;
GO
CREATE DATABASE AUDIT SPECIFICATION Audit_DDL_Databases
FOR SERVER AUDIT Audit_DDL_Databases
ADD (SCHEMA_OBJECT_CHANGE_GROUP),
ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP);
GO
ALTER DATABASE AUDIT SPECIFICATION Audit_DDL_Databases WITH (STATE = ON);
GO
SELECT
	event_time, 
	server_principal_name AS Autor_Mudança, 
	target_server_principal_name, 
	server_instance_name, 
	database_name, 
	schema_name, 
	object_name,
	statement
FROM sys.fn_get_audit_file('C:\SQL_LOG_SECURITY\*.sqlaudit', DEFAULT, DEFAULT)
WHERE event_time >= CONVERT(CHAR(8), GETDATE(), 112);
GO



