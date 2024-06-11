USE [msdb]
GO

/****** Object:  Job [DBA - Log - Batch]    Script Date: 20/12/2023 09:41:48 ******/
EXEC msdb.dbo.sp_delete_job @job_name=N'DBA - Log - Batch', @delete_unused_schedule=1
GO
EXEC msdb.dbo.sp_delete_job @job_name=N'DBA - Log - CPU', @delete_unused_schedule=1
GO
EXEC msdb.dbo.sp_delete_job @job_name=N'DBA - Log - Dispara logs', @delete_unused_schedule=1
GO
EXEC msdb.dbo.sp_delete_job @job_name=N'DBA - Log - Memória', @delete_unused_schedule=1
GO
