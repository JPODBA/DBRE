use BA_DBA
GO
IF(OBJECT_ID('PR_DBA_INDEX_NOUSE')is null) exec ('Create procedure PR_DBA_INDEX_NOUSE as return')
GO
ALTER PROC PR_DBA_INDEX_NOUSE 
	@debug bit = 0 
AS
/************************************************************************
 Autor: Equipe DBA\João Paulo Oliveira
 Data de criação: 14/09/2022
 Data de Atualização: 23/11/2022 - Ajuste para puxar os dados de forma correta
 Data de Atualização: 01/02/2023 - Validação dos Processos criados. 
 Data de Atualização: 12/07/2023 - Validação dos Processos criados (NOVAMENTE). 
 Funcionalidade: Listar todos os indexes não utilizados
*************************************************************************/
BEGIN 
	set nocount on
	
	-- Se um dia voltar o EMAIL, deixa ai
	-- DECLARE @body VARCHAR(2000)
	
	If exists (select 1 from tempdb.dbo.sysobjects where name like '#nouse%')
		Drop table #nouse

	DECLARE @dbs TABLE (name varchar(100))
	Create table #nouse (
		Banco				 varchar(50),
		schemat			 varchar(100), -- tive que colocar um t ali para dar certo. Bizarro.
		Tabela			 varchar(100), 
		indice			 Varchar(250) collate Latin1_General_CI_AI, 
		Seek				 int, 
		Scan				 int, 
		Lookups			 int, 
		TotalAcesso  bigint,
		ultimoSeek   datetime, 
		UltimoScan   Datetime, 
		UltimoLookUp datetime, 
		DataInsert   datetime)

	declare @nomeBD varchar(100), 
					@varExec nvarchar(1000), 
					@varReturn varchar(max), 
					@rowCount int= 0,  
					@assunto varchar(50), 
					@msgErro varchar(30) = ''


	insert @dbs
	select 
		name
	from sys.databases
	where database_id > 4
		and name not in ('BA_DBA')
		and state_desc = 'ONLINE'
	order by 1

	
	IF(@debug = 1)Begin
		Select * from @dbs
	End

	while exists (select 1 from @dbs) 
	Begin
	  
		select top 1 @nomeBD = name from @dbs
		
	  select @varExec = '
		SELECT
			'''+@nomeBD+''',
			sc.name AS SchemaName,
			ob.name AS Table_name,
			id.name AS Index_name,
			us.user_seeks,
			us.user_scans,
			us.user_updates,
			(us.user_seeks + us.user_scans + us.user_lookups) [totalAcesso],
			us.last_user_scan,
			us.last_user_seek,
			us.last_user_lookup, 
			getdate()
		FROM '+@nomeBD+'.sys.dm_db_index_usage_stats us
		JOIN '+@nomeBD+'.sys.objects  ob ON us.OBJECT_ID = ob.OBJECT_ID
		JOIN '+@nomeBD+'.sys.indexes  id ON id.index_id = us.index_id AND us.OBJECT_ID = id.OBJECT_ID
		JOIN '+@nomeBD+'.sys.schemas  sc ON sc.schema_id = ob.schema_id
		WHERE us.user_lookups = 0
			AND us.user_seeks = 0
			AND us.user_scans = 0
			AND id.name not like ''PK%''
			AND id.name not like ''UK%''
			--AND sc.name not like ''sys%''						
		ORDER BY
				us.user_updates DESC
		 '
		insert #nouse
		exec master.dbo.sp_executeSql @varExec 

		IF(@debug = 1)
		Begin
		 select * from #nouse
		 Select @nomeBD as nomeDB
		END

		delete @dbs where name = @nomeBD	

	END 

	insert BA_DBA..DBA_MONITOR_INDEX_NOUSE
	select * from #nouse

	
	/*
	Desabilitado Ploomes. 


	Select @rowCount = 0
	Select @rowCount = count(1) from #nouse

	IF(@debug = 1) begin
		Select @rowCount as RrowCount
		Select * from #nouse
		--return
	END

	if (@rowCount > 0) begin
	
		Delete from BA_DBA.dbo.DBA_MONITOR_INDEX_NOUSE

		insert BA_DBA.dbo.DBA_MONITOR_INDEX_NOUSE
		select * from #nouse

		select @assunto = @@SERVERNAME + ' - Indexes NoUse.'
		
		Select @body ='Por favor checar na tabela de controle no BA_DBA -  DBA_MONITOR_INDEX_NOUSE'
			 
		--EXEC BA_DBA.dbo.sp_dba_manda_email
		--			@assunto  = @assunto,
		--			@mensagem = @body,
		--			@de       = 'alertadbenvio@lis2b.com.br',
		--			@para     = 'Joao.paulo@lis2b.com.br;',
		--			@tipo     = 'text/html'
		
	END -- IF
	*/

  
END -- PROC
GO 
--drop table BA_DBA..DBA_MONITOR_INDEX_NOUSE
IF(OBJECT_ID('BA_DBA..DBA_MONITOR_INDEX_NOUSE')is null)BEGIN
Create table DBA_MONITOR_INDEX_NOUSE (
	Banco					varchar(50), 
	schemat			 varchar(100), -- tive que colocar um t ali para dar certo. Bizarro.
	Tabela				varchar(100), 
	indice				Varchar(250), 
	Seek					int, 
	Scan					int, 
	Lookups				int, 
	TotalAcesso		bigint,
	ultimoSeek		datetime, 
	UltimoScan		Datetime, 
	UltimoLookUp  datetime,
	DataInsert   datetime)
END
GO
-- Exec BA_DBA.dbo.PR_DBA_INDEX_NOUSE  1

--select * from BA_DBA..DBA_MONITOR_INDEX_NOUSE
--select * from  BA_DBA..DBA_MONITOR_INDEX_NOUSE_HISTORICO





