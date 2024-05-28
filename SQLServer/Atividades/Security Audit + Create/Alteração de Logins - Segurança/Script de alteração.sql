USE MASTER
GO
CREATE LOGIN [dba] WITH PASSWORD=N'Mtbr1241', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [dba]
GO
-- Create the server audit
CREATE SERVER AUDIT login_perm_audit
TO FILE ( FILEPATH ='C:\SQL_LOG_SECURITY\' );
GO
-- Enable the server audit
ALTER SERVER AUDIT login_perm_audit 
WITH (STATE = ON) ;
GO
CREATE SERVER AUDIT SPECIFICATION login_audit_spec
FOR SERVER AUDIT login_perm_audit
ADD (SERVER_PERMISSION_CHANGE_GROUP),
ADD (SERVER_PRINCIPAL_CHANGE_GROUP),
ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP)
WITH ( STATE =  ON )

GO  

SELECT 
	event_time,
	action_id, 
	statement,
	object_name, 
	database_name, 
	server_principal_name as AlteradoPor
FROM fn_get_audit_file( 'C:\SQL_LOG_SECURITY\*.sqlaudit' , DEFAULT , DEFAULT)
order by 1 desc;

ALTER LOGIN [fernando.lotti] WITH PASSWORD=N'03)ugp(P0)*HgKj'
CREATE LOGIN teste WITH PASSWORD=N'vxxxxx', DEFAULT_DATABASE=master, DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF  
GO 
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA - KILL Job Contigência', 
		@owner_login_name=N'dba'
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA - LOG - BATCH', 
		@owner_login_name=N'dba'
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA - LOG - CPU', 
		@owner_login_name=N'dba'
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA - LOG - DISPARA LOGS', 
		@owner_login_name=N'dba'
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA - LOG - MEMORIA', 
		@owner_login_name=N'dba'
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA - Manutenção de Indexs', 
		@owner_login_name=N'dba'
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA - Manutenção Low Critical', 
		@owner_login_name=N'dba'
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA - Monitor', 
		@owner_login_name=N'dba'
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA - Monitora Indexs', 
		@owner_login_name=N'dba'
GO
EXEC msdb.dbo.sp_update_job @job_name=N'ROTINA - Updates diários', 
		@owner_login_name=N'dba'
GO 
USE [BA_DBA]
GO
ALTER AUTHORIZATION ON DATABASE::[BA_DBA] TO [dba]
GO
use Master
GO
DROP LOGIN [backup]
GO
DROP LOGIN [rafael.prado]
GO
DROP LOGIN [joao.oliveira]
GO
/*------------------------------------------------------------------*/
ALTER SERVER ROLE [sysadmin] DROP MEMBER [ryan.brocco]
GO
USE [Ploomes_CRM]
GO
CREATE USER [ryan.brocco] FOR LOGIN [ryan.brocco]
GO
USE [Ploomes_CRM]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ryan.brocco]
GO
USE [Ploomes_CRM]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ryan.brocco]
GO
USE [Ploomes_CRM]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [ryan.brocco]
GO
USE [Ploomes_CRM]
GO
ALTER ROLE [db_owner] ADD MEMBER [ryan.brocco]
GO
USE [Ploomes_CRM_Logs]
GO
ALTER ROLE [db_owner] ADD MEMBER [ryan.brocco]
GO
/*------------------------------------------------------------------*/

ALTER SERVER ROLE [sysadmin] DROP MEMBER [fellipe.sena]
GO
USE [Ploomes_CRM_Logs]
GO
CREATE USER [fellipe.sena] FOR LOGIN [fellipe.sena]
GO
USE [Ploomes_CRM_Logs]
GO
ALTER ROLE [db_datareader] ADD MEMBER [fellipe.sena]
GO
USE [Ploomes_CRM_Logs]
GO
ALTER ROLE [db_owner] ADD MEMBER [fellipe.sena]
GO
/*------------------------------------------------------------------*/
/*------------------------------------------------------------------*/
/*------------------------------------------------------------------*/

USE [Ploomes_CRM]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_datawriter] TO [fellipe.sena]
GO
USE [Ploomes_CRM]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_ddladmin] TO [fellipe.sena]
GO
USE [Ploomes_CRM]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_owner] TO [fellipe.sena]
GO


USE [Ploomes_CRM]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_datareader] TO [ryan.brocco]
GO
USE [Ploomes_CRM]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_datawriter] TO [ryan.brocco]
GO
USE [Ploomes_CRM]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_ddladmin] TO [ryan.brocco]
GO
USE [Ploomes_CRM]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_owner] TO [ryan.brocco]
GO


sp_who2