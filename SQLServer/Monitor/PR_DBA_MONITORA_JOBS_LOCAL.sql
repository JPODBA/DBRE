use BA_DBA
GO
IF OBJECT_ID('PR_DBA_MONITORA_JOBS_LOCAL') IS NULL 	exec ('Create procedure PR_DBA_MONITORA_JOBS_LOCAL as return')
GO
ALTER PROC PR_DBA_MONITORA_JOBS_LOCAL
		@debug bit = 0
AS
/************************************************************************
 Autor: João Paulo Olivera
 Data de criação: 16/09/2022
 Atualização: 08/05/2023
 Funcionalidade: Monitora os jobs com falha no dia e envia e-mail no caso de positivo.
*************************************************************************/
BEGIN

	SET NOCOUNT ON
				
	Create table #lista (
			 namee					VARCHAR(250)
			,enabledd				VARCHAR(10)
			,start_step_id  VARCHAR(250)
			,messagee				VARCHAR(MAX)
			,sql_message_id INT
			,run_status			VARCHAR(30)
			,run_date				DATE
			)
	
	INSERT INTO #lista
	SELECT distinct 
		sj.name, 
		CASE WHEN sj.enabled = 1 THEN 'Sim' ELSE 'Não' END AS 'Enabled',
		sj.start_step_id ,
		sjh.message,
		sjh.sql_message_id,
		CASE WHEN SJH.run_status = 0 THEN 'Falha'
				WHEN SJH.run_status = 1 THEN 'Sucesso'
				ELSE 'INDEFINIDO'
				END AS  'run_status',
		convert(date,convert(varchar,sjh.run_date))
	FROM	msdb.dbo.sysjobs sj
	join	msdb.dbo.sysjobactivity sja on sj.job_id = sja.job_id
	join	msdb.dbo.sysjobhistory sjh on	sjh.job_id = sja.job_id
	where	sjh.run_status = 0
		AND sjh.run_date >=  CONVERT(char(8),GETDATE()-1,112)
		AND sj.enabled = 1 --sjh.message like 'The job failed.%'

	
	IF @debug = 1
	BEGIN
		SELECT * FROM #lista
		--RETURN
	END

	insert INTO BA_DBA.dbo.DBA_MONITOR_JOBS_HISTORICO(
		 name
		,enabledd
		,start_step_id
		,messagee
		,sql_message_id
		,run_status
		,run_date
		,data_hist
		)
	SELECT
		 namee
		,enabledd
		,start_step_id
		,messagee
		,sql_message_id
		,run_status
		,run_date
		,GETDATE()
	From #lista


END --PROC
GO
IF OBJECT_ID('BA_DBA..DBA_MONITOR_JOBS_HISTORICO')IS NULL 
BEGIN
CREATE TABLE BA_DBA..DBA_MONITOR_JOBS_HISTORICO
		(
			name VARCHAR(250)
			,enabledd VARCHAR(10)
			,start_step_id VARCHAR(250)
			,messagee VARCHAR(MAX)
			,sql_message_id INT
			,run_status VARCHAR(30)
			,run_date date
			,data_hist datetime
		)
END
GO
--Delete from DBA_MONITOR_JOBS_HISTORICO
--Select * from DBA_MONITOR_JOBS_HISTORICO
--EXEC BA_DBA.DBO.PR_DBA_MONITORA_JOBS_LOCAL
	
	
	