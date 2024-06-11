USE BA_DBA
GO 
IF (OBJECT_ID ('PR_DBA_AUDITORIA_LOGIN') IS NULL) EXEC ('Create Procedure PR_DBA_AUDITORIA_LOGIN as return')
GO
ALTER PROC PR_DBA_AUDITORIA_LOGIN
	@Debug bit = 0
/************************************************************************
 Autor: João Paulo Oliveira
 Data de criação: 06/12/2023
 Data de Atualização:   
 Funcionalidade: Altera o STATE da auditoria de login para ON e cria logs para validações. 
*************************************************************************/
AS
BEGIN

	SET NOCOUNT ON
	
	DELETE FROM BA_DBA.DBO.DBA_LOG_SECURITY

	DECLARE @varExec    VARCHAR(MAX),
					@Varexec2   VARCHAR(MAX),
					@Error      VARCHAR(1000),
					@id		      INT,
					@Data       DATE,
					@ServerName VARCHAR(40)


	DROP TABLE IF EXISTS #Test_Auditoria
	CREATE TABLE #Test_Auditoria (id int primary key, Comando varchar(200))

	INSERT #Test_Auditoria SELECT 1, 'CREATE LOGIN teste WITH PASSWORD=N''vxxxxx'', DEFAULT_DATABASE=master, DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;'
	INSERT #Test_Auditoria SELECT 2, 'ALTER LOGIN teste WITH PASSWORD=N''03)ugp(P0)*HgKj'';'
	INSERT #Test_Auditoria SELECT 3, 'DROP LOGIN teste;'


	IF (@Debug = 1)
	BEGIN
		Select * From #Test_Auditoria
	END
			
	
	BEGIN TRY  
		--- Execução do comando ---------------------------------------------------------------

			
		EXEC BA_DBA.DBO.pr_dba_cronometro 

		INSERT BA_DBA.DBO.DBA_LOGAUDITORIA_LOGIN (DataInicio, DataFim, Servername, erroId,erroLinha, Msg)
		Select CONVERT(CHAR(8), GETDATE(), 112), null, @@SERVERNAME, null, null, null
			 
		SELECT @varExec = 'USE MASTER; ALTER SERVER AUDIT Login_Audit WITH (STATE = ON) ;'
		
		EXEC (@varExec)
		SELECT @Error = @@ERROR
					
		IF(@debug = 1)
		BEGIN
			
			SELECT * FROM #Test_Auditoria
			SELECT @Error as Error, @varExec as Varexec
			--return
		END

		IF (@Error = 0)
		BEGIN

	

			WHILE EXISTS (SELECT 1 FROM #Test_Auditoria) 
			BEGIN 
			
				SELECT @Varexec2 = comando, @id = id FROM #Test_Auditoria ORDER BY id DESC

				--SELECT @Varexec2, @id
				EXEC(@Varexec2)								

				DELETE FROM #Test_Auditoria WHERE id = @id

			END
			
			SELECT @Data = CONVERT(CHAR(8), GETDATE(), 112)
			
			INSERT BA_DBA.DBO.DBA_LOG_SECURITY
			SELECT 
				event_time,
				action_id, 
				statement,
				object_name, 
				database_name, 
				server_principal_name as AlteradoPor
			FROM fn_get_audit_file( 'C:\SQL_LOG_SECURITY\*.sqlaudit' , DEFAULT , DEFAULT)
			--WHERE event_time >= CONVERT(CHAR(8), GETDATE(), 112)
			ORDER BY 1 DESC;


			--PRINT 'Aqui 3'
			
		END
		
															
		EXEC BA_DBA.DBO.pr_dba_cronometro 'Fim da Execução'
		--- Fim da Execução ---------------------------------------------------------------------

	
	END TRY  																				
	BEGIN CATCH  		
	
		Declare @ERROR_NUMBER int, @ERROR_LINE int, @ERROR_MESSAGE varchar(300)

		SELECT @ERROR_NUMBER = ERROR_NUMBER(), @ERROR_LINE = ERROR_LINE(), @ERROR_MESSAGE = ERROR_MESSAGE(), @ServerName = @@SERVERNAME
		
		UPDATE BA_DBA.DBO.DBA_LOGAUDITORIA_LOGIN 
		SET DataFim = GETDATE(), 
				erroId = @ERROR_NUMBER, 
				erroLinha = @ERROR_LINE, 
				Msg = @ERROR_MESSAGE 
		WHERE DataInicio = CONVERT(CHAR(8), GETDATE(), 112) 
			AND Servername = @ServerName

		RETURN		
	
	END CATCH;   

	--PRINT 'AQUI 4'

	Select @ServerName = @@SERVERNAME

	UPDATE BA_DBA.DBO.DBA_LOGAUDITORIA_LOGIN 
	SET DataFim = getdate(), 
			Msg = 'Sucesso' 
	WHERE DataInicio >= @Data
		AND Servername = @ServerName
	

END
GO
--drop table if exists BA_DBA.DBO.DBA_LOGAUDITORIA_LOGIN
IF (OBJECT_ID('BA_DBA.DBO.DBA_LOGAUDITORIA_LOGIN')is null)
Begin 
Create table BA_DBA.DBO.DBA_LOGAUDITORIA_LOGIN(
	DataInicio					date, 
	DataFim							datetime, 
	Servername					varchar(100), 
	erroId							int, 
	erroLinha						int, 
	Msg							    Varchar(200)
)
End
GO
--DROP TABLE IF EXISTS BA_DBA.DBO.DBA_LOG_SECURITY
IF (OBJECT_ID('BA_DBA.DBO.DBA_LOG_SECURITY')is null)
Begin 
Create table BA_DBA.DBO.DBA_LOG_SECURITY(
	Event_time					datetime, 
	Action_id						char(10), 
	Comando   					varchar(300), 
	object_name					varchar(50), 
	Database_Name				varchar(50), 
	Alterado_por				varchar(100)
)
End
GO

--DELETE FROM BA_DBA.DBO.DBA_LOG_SECURITY 
--delete from BA_DBA.DBO.DBA_LOGAUDITORIA_LOGIN


--Select * from BA_DBA.DBO.DBA_LOGAUDITORIA_LOGIN
--Select * from BA_DBA.DBO.DBA_LOG_SECURITY ORDER BY 1 DESC


--exec BA_DBA.dbo.PR_DBA_AUDITORIA_LOGIN
GO
USE [msdb]
GO

/****** Object:  Job [DBA - Ativa auditoria de Logins]    Script Date: 06/12/2023 17:40:58 ******/
EXEC msdb.dbo.sp_delete_job @job_name=N'DBA - Ativa auditoria de Logins', @delete_unused_schedule=1
GO

USE [msdb]
GO

/****** Object:  Job [DBA - Ativa auditoria de Logins]    Script Date: 06/12/2023 17:40:24 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 06/12/2023 17:40:24 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - Ativa auditoria de Logins', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Nenhuma descrição disponível.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'dba', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ALTER SERVER AUDIT]    Script Date: 06/12/2023 17:40:25 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ALTER SERVER AUDIT', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec BA_DBA.dbo.PR_DBA_AUDITORIA_LOGIN', 
		@database_name=N'master', 
		@flags=8
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Occurs every day at 06:00:00', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20231002, 
		@active_end_date=99991231, 
		@active_start_time=60000, 
		@active_end_time=235959, 
		@schedule_uid=N'006fed1d-3c19-4cd8-8e7c-9a8e17b65128'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


