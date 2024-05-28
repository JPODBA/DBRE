USE BA_DBA;  
GO 
IF (OBJECT_ID('PR_DBA_LOG_CPU')is null)exec ('Create proc PR_DBA_LOG_CPU as return')
GO
ALTER PROC PR_DBA_LOG_CPU
	@debug bit = 0
AS
/************************************************************************
 Autor:  DBA\João Paulo 
 Data de criação: 10/10/2020s
 Data de Atualização: 01/01/2024
 Funcionalidade: Generates log of usage processes per CPU Request.
*************************************************************************/
BEGIN
	SET NOCOUNT ON

	DECLARE @TIME DATETIME = GETDATE() 
	SELECT @TIME = CONVERT(CHAR(17), @TIME, 121)+'00'

	
	-- Catch queries that are using CPU due to lack of memory.
	iNSERT DBA_LOG_CPU_PRNAME
	SELECT 
		spid, 
		lastwaittype, 
		cpu, hostname, 
		program_name, 
		cmd, 
		nt_username, 
		loginame,
		GETDATE()
	FROM master..sysprocesses
	WHERE status = 'runnable'
		AND spid > 50 -- Eliminate system SPIDs
		AND spid <> @@SPID
		AND nt_username NOT LIKE 'SQLSERVERAGENT                                                                                                                  '
	ORDER BY 
		CPU 
	DESC

	--DELETE FROM DBA_LOG_CPU_PRNAME WHERE nt_username LIKE '%SQLSERVERAGENT%'
		
	iNSERT DBA_LOG_CPU
	SELECT 
	  s.session_id,
	  r.status, 
	  r.blocking_session_id,
	  wait_resource,
	  r.wait_time / (1000 * 60),
	  r.cpu_time,
	  r.logical_reads,
	  r.reads,
	  r.writes,
	  r.total_elapsed_time / (1000 * 60),
	  Substring(st.TEXT,(r.statement_start_offset / 2) + 1, ((CASE r.statement_end_offset	WHEN -1 THEN Datalength(st.TEXT) ELSE r.statement_end_offset END - r.statement_start_offset) / 2) + 1) AS statement_text,
	  r.command,
	  s.login_name,
	  s.host_name,
	  s.program_name,
	  s.last_request_end_time,
	  r.open_transaction_count,
		GETDATE() as Datainsert
	FROM sys.dm_exec_sessions AS s
	JOIN sys.dm_exec_requests AS r ON r.session_id = s.session_id
	CROSS APPLY sys.Dm_exec_sql_text(r.sql_handle) AS st
	WHERE r.session_id != @@SPID
		and NOT EXISTS (SELECT 1 
										FROM DBA_LOG_CPU DBA (NOLOCK) 
										WHERE DBA.session_id = s.session_id
											AND DBA.last_request_end_time = s.last_request_end_time
										AND DBA.last_request_end_time >= @TIME)		
		AND login_name NOT LIKE '%NT SERVICE\SQLSERVERAGENT%'
		AND login_name NOT LIKE '%joao.oliveira%'
	ORDER BY r.cpu_time desc

	--Delete from DBA_LOG_CPU where login_name = 'NT SERVICE\SQLSERVERAGENT'

	iNSERT DBA_LOG_CPU_BLK
	Select 
		spid, 
		blocked, 
		waittime, 
		lastwaittype, 
		cpu, 
		physical_io, 
		last_batch, 
		status, 
		hostname,
		program_name, 
		hostprocess, 
		net_address, 
		login_time, 
		GETDATE()
	From master.dbo.sysprocesses (NOLOCK)   
	Where spid > 50
		and spid <> @@spid 
		and dbid = 5 
		and cpu > 0
		and waittime > 0

		-- Table size control
		Delete from BA_DBA.DBO.DBA_LOG_CPU_PRNAME where Data_log < CONVERT(CHAR(8), DATEADD(HOUR, -2, GETDATE()), 112)
		Delete from BA_DBA.DBO.DBA_LOG_CPU where last_request_end_time < CONVERT(CHAR(8), DATEADD(HOUR, -2, GETDATE()), 112)
		Delete from BA_DBA.DBO.DBA_LOG_CPU_BLK where Data_log < CONVERT(CHAR(8), DATEADD(HOUR, -2, GETDATE()), 112)


	
	
END
GO 
IF(OBJECT_ID('DBA_LOG_CPU_PRNAME') IS NULL)
BEGIN
CREATE TABLE DBA_LOG_CPU_PRNAME (
	spid					SMALLINT    ,
	lastwaittype	NVARCHAR(64) ,
	cpu						INT					 ,
	hostname			NVARCHAR(256),
	program_name	NVARCHAR(256),
	cmd						NVARCHAR(256),
	nt_username		NVARCHAR(256),
	loginame			NVARCHAR(256),
	Data_log			DATETIME
)
END
GO 
IF(OBJECT_ID('DBA_LOG_CPU') IS NULL)
BEGIN 
CREATE TABLE DBA_LOG_CPU (
	session_id						  SMALLINT     ,
	status								  NVARCHAR(60) ,
	Blk_by								  SMALLINT		 ,
	wait_resource					  NVARCHAR(512),
	Wait_M								  INT					 ,
	cpu_time							  INT					 ,
	logical_reads					  BIGINT			 ,
	reads									  BIGINT			 ,
	writes								  BIGINT			 ,
	Elaps_M								  INT					 ,
	statement_text				  NVARCHAR(MAX),
	command								  NVARCHAR(256),
	login_name						  NVARCHAR(256),
	host_name							  NVARCHAR(256),
	program_name					  NVARCHAR(256),
	last_request_end_time	  DATETIME		 ,
	open_transaction_count	INT					 ,
	Data_log								DATETIME
)
END
GO 
IF(OBJECT_ID('DBA_LOG_CPU_BLK') IS NULL) 
BEGIN
CREATE TABLE  DBA_LOG_CPU_BLK(
	spid					SMALLINT	,
	blocked				SMALLINT	,
	waittime			BIGINT		,
	lastwaittype	NCHAR(64)	,
	cpu						INT				,
	physical_io		BIGINT		,
	last_batch		DATETIME	,
	status				NCHAR(256),
	hostname			NCHAR(256),
	program_name	NCHAR(256),
	hostprocess		NCHAR(20)	,
	net_address		NCHAR(25)	,
	login_time		DATETIME	, 
	Data_log			DATETIME
)
END
GO 

--DROP TABLE IF EXISTS DBA_LOG_CPU_PRNAME
--DROP TABLE IF EXISTS DBA_LOG_CPU
--DROP TABLE IF EXISTS DBA_LOG_CPU_BLK


--SELECT * FROM DBA_LOG_CPU_PRNAME
--SELECT * FROM DBA_LOG_CPU
--SELECT * FROM DBA_LOG_CPU_BLK

--EXEC BA_DBA.DBO.PR_DBA_LOG_CPU