USE BA_DBA
GO
IF (OBJECT_ID ('PR_DBA_CHECKDB')IS NULL) EXEC ('CREATE PROCEDURE PR_DBA_CHECKDB AS RETURN')
GO
ALTER PROC PR_DBA_CHECKDB	
	@Database Varchar(70) = null,
	@debug    bit = 0
AS
 /************************************************************************
 Autor: João Paulo Oliveira\DBA
 Data de criação: 01/05/2023
 Data de Atualização: 
 Funcionalidade: Verifica a integridade lógica e física de todos os objetos do banco de dados e salva em uma tabela
 de referência para a proc de backup (Por hora desabilitado). 
 *************************************************************************/
BEGIN
	SET NOCOUNT ON

	DECLARE @DB_NAME Varchar(70), 
					@DataIni Datetime,
					@MSG Varchar(170)

	Declare @Databases as table (DB varchar(100))

	IF(@Database is null) begin
	INSERT INTO @Databases
	SELECT	
		name
	FROM	SYS.databases
	WHERE	state_desc = 'ONLINE' 
		AND database_id > 4
	END
	ELSE
	BEGIN
		INSERT INTO @Databases
		SELECT	
			name
		FROM	SYS.databases
		WHERE	state_desc = 'ONLINE' 
			AND name = @Database
			AND database_id > 4
	END -- if

	IF (@debug = 1) 
	Begin 
		Select * from @Databases
		--return
	END

	While exists(select 1 from @Databases) BEGIN
		Select top 1 @DB_NAME = db from @Databases

		Select @DataIni = GETDATE()
		Select @MSG = 'DBCC CHECKDB: ' + @DB_NAME
		
		INSERT BA_DBA.dbo.DBA_LOGMANUTENCAO_CHECKDB  
			(DataIni, DB)
		Select @DataIni, @DB_NAME
		
		
		exec BA_DBA.dbo.pr_dba_cronometro

		DBCC CHECKDB (@DB_NAME) WITH NO_INFOMSGS;

			 
		IF (@@ERROR = 0)  
			update BA_DBA.dbo.DBA_LOGMANUTENCAO_CHECKDB  
			Set Status = 'Success'
			where DB = @DB_NAME
				and DataIni = @DataIni
		ELSE  
			Update BA_DBA.dbo.DBA_LOGMANUTENCAO_CHECKDB  
			Set Status = 'Failure'
			where DB = @DB_NAME
				and DataIni = @DataIni

		exec BA_DBA.dbo.pr_dba_cronometro @MSG

		update BA_DBA.dbo.DBA_LOGMANUTENCAO_CHECKDB  
		Set DataFim = getdate()
		where DB = @DB_NAME
			and DataIni = @DataIni

		update BA_DBA.dbo.DBA_LOGMANUTENCAO_CHECKDB  
		Set TempoDeExec_minutos = DATEDIFF(minute, DataIni, DataFim)
		where DB = @DB_NAME
			and DataIni = @DataIni

		IF(@debug = 1) Begin
			Select @DataIni as dataini, @DB_NAME as DB
			Select * from BA_DBA.dbo.DBA_LOGMANUTENCAO_CHECKDB 
			--Return
		END

		Delete from @Databases where DB = @DB_NAME

	END -- WHILE

	Delete from BA_DBA.dbo.DBA_LOGMANUTENCAO_CHECKDB  where DataIni <= CONVERT(CHAR(8),DATEADD(DAY, -5, GETDATE()),112)

END
GO 
IF(OBJECT_ID('BA_DBA.dbo.DBA_LOGMANUTENCAO_CHECKDB ') is null) BEGIN
Create table BA_DBA.dbo.DBA_LOGMANUTENCAO_CHECKDB  (
	DataIni							 Datetime, 
	DataFim							 Datetime,
	DB									 Varchar(70), 
	Status							 Varchar(150),
	TempoDeExec_minutos int
)
END
GO
-- DROP TABLE BA_DBA.dbo.DBA_LOGMANUTENCAO_CHECKDB  
-- Select * from BA_DBA.dbo.DBA_LOGMANUTENCAO_CHECKDB 
-- EXEC BA_DBA.DBO.PR_DBA_CHECKDB
-- DELETE FROM BA_DBA.dbo.DBA_LOGMANUTENCAO_CHECKDB 

--DBCC CHECKDB (BA_DBA) 

--IF (@@ERROR = 0)  
--	PRINT 'TESTE SUCESSO'
--ELSE  
--  PRINT 'TESTE FAILURE'

/**
Necessário testar no novo ambiente para validação de tempo, e sincronizar com os backups. 
**/