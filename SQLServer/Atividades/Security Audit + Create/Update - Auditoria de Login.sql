USE [msdb]
GO

/****** Object:  Job [DBA - Ativa auditoria de Logins]    Script Date: 06/12/2023 10:12:29 ******/
EXEC msdb.dbo.sp_delete_job @job_id=N'DBA - Ativa auditoria de Logins', @delete_unused_schedule=1
GO


