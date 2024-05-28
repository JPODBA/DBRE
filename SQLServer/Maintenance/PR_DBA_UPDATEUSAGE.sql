USE BA_DBA
Go
IF (OBJECT_ID('PR_DBA_UPDATEUSAGE') is null) exec ('Create procedure PR_DBA_UPDATEUSAGE as return')
GO
ALTER PROCEDURE PR_DBA_UPDATEUSAGE (
	@ba varchar(100) = null,
	@debug bit = 1)
AS
/************************************************************************
 Autor: Equipe DBA\João Paulo Oliveira	
 Data de criação: 01/08/2022
 Funcionalidade: Relata e corrige páginas e imprecisões na contagem de linhas nas visualizações do catálogo. 
 Essas imprecisões podem causar relatórios de uso de espaço incorretos retornados pelo procedimento armazenado do sistema sp_spaceused.
 Pode estar mostrando o tamanho errado das bases. Esse processo corrige isso. 
 *************************************************************************/
BEGIN
	SET NOCOUNT ON

	DECLARE @DB AS TABLE (DatabaseName varchar(100))
	
	Insert @DB
	Select 
		name 
	from Sys.databases 
	where database_id > 4
		and state = 0 
		and name = isNull(@ba, name)
		and user_access_desc = 'MULTI_USER'
		and state_desc = 'ONLINE'
		and is_read_only = 0
		--and name not in ('BA_DBA')
		
	IF(@debug = 1)
	BEGIN
		Select * from @DB order by 1
		--return
	END

	While exists (Select 1 from @DB)BEGIN
		Declare @Db_Name Varchar(100)
		Select @Db_Name = databasename from @DB 

		Exec BA_DBA.DBO.pr_dba_cronometro
		
		Declare @dataExec datetime = getdate()
    INSERT BA_DBA.DBO.DBA_LOGMANUTENCAO 
			(DataInicio, ba, procExecucao, erroId, erroLinha, erroMsg)
    select 
			@dataExec, @Db_Name, OBJECT_NAME(@@PROCID), 0, 0, null
		
		DBCC UPDATEUSAGE (@Db_Name) WITH NO_INFOMSGS; 

		update BA_DBA.DBO.DBA_LOGMANUTENCAO set DataFim = GETDATE() where DataInicio = @dataExec and ba = @Db_Name
		update BA_DBA.DBO.DBA_LOGMANUTENCAO set TempoDeExec_minutos = DATEDIFF(minute, DataInicio, DataFim) where DataInicio = @dataExec and ba = @Db_Name

		
		Exec BA_DBA.DBO.pr_dba_cronometro @Db_Name

		Delete from @DB where DatabaseName = @Db_Name
	
	END -- WHile

	Delete from BA_DBA.DBO.DBA_LOGMANUTENCAO where DataFim <= CONVERT(CHAR(8),DATEADD(WEEK, -2, GETDATE()),112)

END
GO
/** ----- Create table da DBA_LOGMANUTENCAO está no Script Proc Manutenção index ----------------- **/

-- Drop table BA_DBA.DBO.DBA_LOGMANUTENCAO
-- select * from BA_DBA.DBO.DBA_LOGMANUTENCAO
-- Exec BA_DBA.DBO.PR_DBA_UPDATEUSAGE

