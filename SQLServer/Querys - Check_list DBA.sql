use BA_DBA
go 
SELECT sqlserver_start_time FROM sys.dm_os_sys_info
GO
exec master.dbo.xp_servicecontrol 'QUERYSTATE', 'MSSQLServer'
exec master.dbo.xp_servicecontrol 'QUERYSTATE', 'SQLServerAgent'
GO
SELECT available_physical_memory_kb/1024 as "Total Memory MB free para uso",
       available_physical_memory_kb/(total_physical_memory_kb*1.0)*100 AS "% Memory Free", 
			 total_physical_memory_kb/1024 as GB_Total
FROM sys.dm_os_sys_memory
GO
Select top 1 *, @@SERVERNAME from DBA_LOGMANUTENCAO where ba not like 'Ploomes_CRM_Logs' and procExecucao not like '%PR_DBA_UPDATESTATS%' order by DataInicio desc
GO
Select top 1 *, @@SERVERNAME from DBA_LOGMANUTENCAO where procExecucao like 'PR_DBA_UPDATESTATS%' and ba not in ('BA_DBA', 'Ploomes_CRM_Logs') order by DataInicio desc
go
Select top 1 *, @@SERVERNAME from DBA_LOGMANUTENCAO_CHECKDB where DB not in ('BA_DBA', 'Ploomes_CRM_Logs') order by DataIni desc
go
Select top 1 *, @@SERVERNAME from DBA_MONITOR_JOBS_HISTORICO where run_date >= convert(char(8), getdate(), 112)
Select top 1 *, @@SERVERNAME from DBA_MONITOR_JOBS_HISTORICO where run_date >= convert(char(8), getdate()-2, 112)
Go 
Select top 3 *, @@SERVERNAME from DBA_MONITOR_ESPAÇO_DISK WHERE Livre <= 15 ORDER BY Data_Horário DESC
GO 
Select *, @@SERVERNAME from DBA_LOGMANUTENCAO_INDEX where horaInicio >= convert(char(8), getdate(), 112) -- 800 De média de index feitos
GO 
exec msdb.dbo.sp_get_composite_job_info @execution_status = 1
GO
USE msdb;
go
SELECT distinct job.name AS JobName, run_status, run_date, run_duration
FROM dbo.sysjobs job
JOIN dbo.sysjobhistory history ON job.job_id = history.job_id
WHERE run_date >= CONVERT(CHAR(8), GETDATE(), 112)
	and job.name = 'Backup Diferencial'
	--and job.name = 'Backup Diferencial'
ORDER BY run_date DESC;
go

--select * FROM fn_get_audit_file( 'C:\SQL_LOG_SECURITY\*.sqlaudit' , DEFAULT , DEFAULT)
GO
Select top 2 * from BA_DBA.DBO.DBA_LOGAUDITORIA_LOGIN ORDER BY 1 DESC

-- Tem que retornar um "Executou" - "Inseriu"
Select top 4 * from BA_DBA.dbo.DBA_VALIDA_INSERT where data >= CONVERT(char(8), getdate()-1, 112)

-- Ele só inseri as mudanças na segunda execução. 
Select * from BA_DBA.DBO.DBA_LOG_SECURITY where Event_time >= CONVERT(char(8), getdate()-1, 112) ORDER BY 1 DESC

Select 
	COUNT(indice) as Count_Vezes_Natabela, 
	indice, tabela, ultimoSeek, totalacesso,
	'Drop index if exists '+tabela+'.'+indice+';'
From BA_DBA..DBA_MONITOR_INDEX_NOUSE
group by indice, tabela, ultimoSeek, totalacesso
Having COUNT(indice) > 15
order by COUNT(indice) desc

--SELECT top 1 '1' FROM Ploomes_CRM..DBA_CONTIGENCIA_DROP

go 
USE BA_DBA
GO
SELECT 
	SUM(user_seeks) as Seeks_hits,
	equality_columns, 
	tabela,
	create_Statement, 
	AVG(avg_user_impact)
FROM DBA_MONITOR_MISSING_INDEX 
GROUP BY 
	equality_columns,
	create_Statement, 
	tabela
HAVING SUM(user_seeks) >= 50000	AND AVG(avg_user_impact) >= 50
ORDER BY SUM(user_seeks) DESC
GO
go 
SELECT 
	sys.databases.name,  
	CONVERT(VARCHAR,SUM(size)*8/1024/1024)+' GB' AS [Total disk space]  
FROM sys.databases   
JOIN sys.master_files  oN  sys.databases.database_id=sys.master_files.database_id  
WHERE sys.databases.name = 'BA_DBA'
GROUP BY sys.databases.name  
ORDER BY 2 desc

USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA - Ativa auditoria de Logins',	@enabled=1
go
go
Select top 3 * from BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG Order by DataFim desc
Select top 3 * from BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO where DatahoraFim_exec_proc is not null  Order by DatahoraFim_exec_proc desc
--Select count(1) From Ploomes_CRM.dbo.Automation_log (Nolock) WHERE DATETIME <= '2023-10-16' --- SEMPRE COLOCAR A DATA MIN

