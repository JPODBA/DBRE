USE MASTER
GO
-- Drop (remove) a server audit
ALTER SERVER AUDIT Login_Audit WITH (STATE = OFF);
DROP SERVER AUDIT Login_Audit;

-- Create the server audit
CREATE SERVER AUDIT Login_Audit
TO FILE ( FILEPATH ='C:\SQL_LOG_SECURITY\' );
GO
-- Enable the server audit
ALTER SERVER AUDIT Login_Audit WITH (STATE = ON) ;
GO
CREATE SERVER AUDIT SPECIFICATION Login_Audit
FOR SERVER AUDIT Login_Audit
ADD (SERVER_PERMISSION_CHANGE_GROUP),
ADD (SERVER_PRINCIPAL_CHANGE_GROUP),
ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP),
ADD (LOGIN_CHANGE_PASSWORD_GROUP)
WITH (STATE = ON);

GO  

/*
Test

SELECT 
	event_time,
	action_id, 
	statement,
	object_name, 
	database_name, 
	server_principal_name as AlteradoPor
FROM fn_get_audit_file( 'C:\SQL_LOG_SECURITY\*.sqlaudit' , DEFAULT , DEFAULT)
order by 1 desc;

CREATE LOGIN teste WITH PASSWORD=N'vxxxxx', DEFAULT_DATABASE=master, DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF; 
ALTER LOGIN teste WITH PASSWORD=N'03)ugp(P0)*HgKj';
DROP LOGIN teste;

GO 
*/
