USE BA_DBA
GO 
IF (OBJECT_ID ('PR_DBA_AUDITORIA_LOGIN') IS NULL) EXEC ('Create Procedure PR_DBA_AUDITORIA_LOGIN as return')
GO
ALTER PROC PR_DBA_AUDITORIA_LOGIN
	@Debug bit = 0
/************************************************************************
 Autor: João Paulo Oliveira
 Data de criação: 06/12/2023
 Data de Atualização: 26/02/2024 - Ajustando query de insert para não inserir dados demasiados ou sem uso.
 Data de Atualização: 26/03/2024 - Ajustando os logs do SQL e o motivo de não inserir a mudança que valida que de fato está funcionando. 
 Data de Atualização: 03/04/2024 - Fiz Inúmeros ajustes na procedure, visando melhorar os logs dela. Também criei a alteração de manutenção todo sabado. 

 Funcionalidade: Altera o STATE da auditoria de login para ON e cria logs para validações. 
*************************************************************************/
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @varExec				VARCHAR(MAX),
					@Varexec2				VARCHAR(MAX),
					@Error					VARCHAR(1000),
					@id							INT,
					@Data						DATE,
					@ServerName			VARCHAR(40), 
					@Rowcount				INT,
					@HoraInsert_now TIME, 
					@HoraInsert_Out TIME


	DROP TABLE IF EXISTS #Test_Auditoria
	CREATE TABLE #Test_Auditoria (id int primary key, Comando varchar(200))

	INSERT #Test_Auditoria SELECT 1, 'CREATE LOGIN teste WITH PASSWORD=N''vxxxxx'', DEFAULT_DATABASE=master, DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;'
	INSERT #Test_Auditoria SELECT 2, 'ALTER LOGIN teste WITH PASSWORD=N''03)ugp(P0)*HgKj'';'
	INSERT #Test_Auditoria SELECT 3, 'DROP LOGIN teste;'
	--CREATE LOGIN teste WITH PASSWORD=N'vxxxxx', DEFAULT_DATABASE=master, DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;

	SELECT @Data = CONVERT(CHAR(8), GETDATE(), 112)
	--- Execução do comando ---------------------------------------------------------------			
	EXEC BA_DBA.DBO.pr_dba_cronometro 

	INSERT BA_DBA.DBO.DBA_LOGAUDITORIA_LOGIN (DataInicio, DataFim, Servername, erroId,erroLinha, Msg)
	Select CONVERT(CHAR(8), @Data, 112), null, @@SERVERNAME, null, null, null 

	SELECT @HoraInsert_now = GETDATE()
	IF (@HoraInsert_now <= '06:01')
	BEGIN
		INSERT BA_DBA.DBO.DBA_VALIDA_INSERT (DATA, STATUS)
		SELECT GETDATE(), 'Executou'

		WHILE EXISTS (SELECT 1 FROM #Test_Auditoria) 
		BEGIN
				
			SELECT @Varexec2 = comando, @id = id FROM #Test_Auditoria ORDER BY id DESC

			EXEC(@Varexec2)								
			Select @Error = @@ERROR
					
			IF(@debug = 1)
			BEGIN	
				SELECT @Varexec2 as Varexec, @id as ID, @Error as Error
				SELECT * FROM #Test_Auditoria			
				--return
			END
		
			DELETE FROM #Test_Auditoria WHERE id = @id
	
		END	

	END -- IF
		
	IF (@DEBUG = 1)
	BEGIN
		SELECT @Data as Data_Debug
	END	

	BEGIN TRY	

		INSERT BA_DBA.DBO.DBA_VALIDA_INSERT (DATA, STATUS)
		SELECT GETDATE(), 'Inseriu'

		INSERT BA_DBA.DBO.DBA_LOG_SECURITY (
			Event_time, 
			session_id, 
			comando, 
			object_name, 
			Database_Name, 
			Alterado_por)
		SELECT 
			event_time,
			session_id, 
			statement,
			object_name, 
			database_name, 
			server_principal_name as AlteradoPor		
		FROM fn_get_audit_file( 'C:\SQL_LOG_SECURITY\*.sqlaudit' , DEFAULT , DEFAULT)
		Where event_time >= @Data
			and class_type = 'SL'
		ORDER BY 1 DESC;
		Select @@ROWCOUNT as RowCount1
	
	END TRY
	BEGIN CATCH
		
		DECLARE @ERROR_NUMBER int, @ERROR_LINE int, @ERROR_MESSAGE varchar(300)
		SELECT @ERROR_NUMBER = ERROR_NUMBER(), @ERROR_LINE = ERROR_LINE(), @ERROR_MESSAGE = ERROR_MESSAGE(), @ServerName = @@SERVERNAME
	
		IF (@DEBUG = 1)
		BEGIN
			SELECT @ERROR_NUMBER as ERROR_NUMBER1,  @ERROR_LINE as ERROR_LINE1, @ERROR_MESSAGE as ERROR_MESSAGE1, @ServerName as SERVERNAME1
		END	

		IF(@ERROR_NUMBER is not null)
		BEGIN
			UPDATE BA_DBA.DBO.DBA_LOGAUDITORIA_LOGIN 
			SET DataFim = GETDATE(), 
					erroId = @ERROR_NUMBER, 
					erroLinha = @ERROR_LINE, 
					Msg = @ERROR_MESSAGE 
			WHERE DataInicio = CONVERT(CHAR(8), GETDATE(), 112) 
				AND Servername = @ServerName		
		END

	
	END CATCH

	EXEC BA_DBA.DBO.pr_dba_cronometro 'Fim da Execução'
		
	UPDATE BA_DBA.DBO.DBA_LOGAUDITORIA_LOGIN 
	SET DataFim = getdate(), 
			Msg = 'Sucesso' 
	WHERE DataInicio >= CONVERT(CHAR(8), @Data, 112)
		AND Servername = @@SERVERNAME

	-- Deletando arquivos APNAS AOS SABADOS.

	DECLARE @SABADO INT = DATEPART(WEEKDAY, getdate())
	--select @SABADO
	
	IF(@SABADO = 7)
	BEGIN

		INSERT BA_DBA.DBO.DBA_VALIDA_INSERT (DATA, STATUS)
		SELECT GETDATE(), 'Del Sab'

		SELECT @varExec = 'USE MASTER; ALTER SERVER AUDIT Login_Audit WITH (STATE = OFF); ALTER SERVER AUDIT Audit_DDL_Databases WITH (STATE = OFF);'
		EXEC (@varExec)
		
		--Para não estourar o disco C por acidente. Por mais que seja pequeno, é uma boa prática deletar. 
		DECLARE @cmd VARCHAR(1000);
		SET @cmd = 'DEL C:\SQL_LOG_SECURITY\*.sqlaudit';
		EXEC xp_cmdshell @cmd;

		SELECT @varExec = 'USE MASTER; ALTER SERVER AUDIT Login_Audit WITH (STATE = ON); ALTER SERVER AUDIT Audit_DDL_Databases WITH (STATE = ON);'
		EXEC (@varExec)

	END
	
	-- Essa parte ta horrível sim! Mas, BIZARRAMENTE, só assim para não poluir. Fazer IN, ou algo mais generico sempre cagava, ai Deixei assim e fingi demência. 
	/* Ajustei o erro e era patético. Vou nem comentar pq passei vergonha. Mas agora sou pai, durmo pouco, ta ai minha desculpa.*/
	--DELETE FROM BA_DBA.DBO.DBA_LOG_SECURITY WHERE Comando LIKE 'UPDATE STATISTICS%'
	--DELETE FROM BA_DBA.DBO.DBA_LOG_SECURITY WHERE Comando LIKE 'ALTER INDEX%'
	--DELETE FROM BA_DBA.DBO.DBA_LOG_SECURITY WHERE Comando LIKE ''	
	--DELETE FROM BA_DBA.DBO.DBA_LOG_SECURITY WHERE Comando LIKE 'SET IDENTIY%'	
	--DELETE FROM BA_DBA.DBO.DBA_LOG_SECURITY WHERE Comando LIKE 'CREATE VIEW%'
	--DELETE FROM BA_DBA.DBO.DBA_LOG_SECURITY WHERE Comando LIKE 'EXEC%'	
	--DELETE FROM BA_DBA.DBO.DBA_LOG_SECURITY WHERE object_name LIKE 'Ploomes_Cliente_SupportAccess_Request%'	

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
--drop table if exists BA_DBA.DBO.DBA_LOG_SECURITY
IF (OBJECT_ID('BA_DBA.DBO.DBA_LOG_SECURITY')is null)
Begin 
Create table BA_DBA.DBO.DBA_LOG_SECURITY(
	Event_time					datetime, 
	session_id					int, 
	Comando   					varchar(max), 
	object_name					varchar(150), 
	Database_Name				varchar(150), 
	Alterado_por				varchar(150)
)
End
GO

IF (OBJECT_ID('BA_DBA.DBO.DBA_VALIDA_INSERT')is null)
Begin 
Create table BA_DBA.DBO.DBA_VALIDA_INSERT(
	ID		 INT IDENTITY (1,1) PRIMARY KEY,
	DATA	 DATETIME, 
	STATUS VARCHAR(10)
)
End
GO

--DELETE FROM BA_DBA.DBO.DBA_LOGAUDITORIA_LOGIN WHERE DATAINICIO = '2024-04-15'
--DELETE FROM BA_DBA.DBO.DBA_LOG_SECURITY WHERE EVENT_TIME >= '2024-04-15'
--DELETE FROM BA_DBA.DBO.DBA_VALIDA_INSERT WHERE data >= '2024-04-15'


--Select * from BA_DBA.DBO.DBA_LOGAUDITORIA_LOGIN ORDER BY 1 DESC
--Select * from BA_DBA.DBO.DBA_VALIDA_INSERT ORDER BY 1 DESC
--Select top 10 * from BA_DBA.DBO.DBA_LOG_SECURITY ORDER BY 1 DESC


--Exec BA_DBA.dbo.PR_DBA_AUDITORIA_LOGIN
--EXEC sp_configure 'show advanced options', 1;
--RECONFIGURE;
--EXEC sp_configure 'xp_cmdshell', 1;
--RECONFIGURE;

--SELECT name, is_state_enabled
--FROM sys.server_audits;