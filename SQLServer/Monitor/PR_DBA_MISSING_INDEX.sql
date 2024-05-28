USE BA_DBA
GO
IF (object_id('PR_DBA_MISSING_INDEX') is null) exec ('create proc PR_DBA_MISSING_INDEX as return')
GO
ALTER PROC PR_DBA_MISSING_INDEX 
	@DB varchar(70) = null,
	@debug bit = 1
AS
/************************************************************************
 Autor: João Paulo Oliveira
 Data de criação: 12/09/2022
 Data de Atualização: 23/11/2022 - Ajuste sobre carga de dados e histórico. 
 Data de Atualização: 01/02/2023 - Validação dos Processos criados. 
 Data de Atualização: 10/08/2023 - Tirando o delte da tabela e o History. Também incluindo um delete depois de 3 meses. 
  Funcionalidade: Coleta informações de índices que precisam ser criados. 
*************************************************************************/
BEGIN
  SET NOCOUNT ON 
	
  Declare @varExec varchar(2000), 
					@count tinyint, 
					@dbname varchar(50), 
					@dataDelete datetime = GETDATE() -7
  
	Declare @sysdb table (rowId tinyint identity, name varchar(50))

  Insert @sysdb (name) 
	Select 
		name 
	From master.DBO.sysdatabases (nolock) 
	Where (status & 512) <> 512 /*offline (ALTER DATABASE)*/ 
		and (status & 1024) <> 1024 /*read only (ALTER DATABASE)*/ 
		and dbid > 4 
		and name = isNull(@DB,name) 
		and name not in ('BA_DBA', 'Ploomes_CRM_Logs')
	order by name
  
	While exists (Select 1 from @sysdb) begin

		-- Iniciando as Variaveis
		Select @varExec = '', @dbname = '' 
    
		Select top 1 @dbname = name from @sysdb
    raiserror (@dbname,0,1) with nowait

    select @varExec = '
    use '+@dbname+';

		INSERT BA_DBA.DBO.DBA_MONITOR_MISSING_INDEX
    SELECT TOP 20
			convert(char(8),getdate(),112) [data],
			'''+@@SERVERNAME+''' [servidor],
			DB_NAME(dm_mid.database_id) [db],
			OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) [tabela],
			dm_migs.avg_user_impact, --*(dm_migs.user_seeks+dm_migs.user_scans) as  Avg_Estimated_Impact,
			dm_migs.user_seeks,
			dm_migs.user_scans,
			dm_migs.last_user_seek AS Last_User_Seek,
			left(dm_mid.equality_columns,500),
			left(dm_mid.inequality_columns,500),
			left(dm_mid.included_columns,500),
			''CREATE INDEX ['' + OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id)+''_IDM]''+ --''_''
			+ '' ON '' + dm_mid.statement
			+ '' ('' + ISNULL (dm_mid.equality_columns,'''')
			+ CASE WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns IS NOT NULL THEN '','' ELSE
			'''' END
			+ ISNULL (dm_mid.inequality_columns, '''')
			+ '')''
			+ ISNULL ('' INCLUDE ('' + dm_mid.included_columns + '') WITH (ONLINE=ON)'', '' ON INDEX_02'') AS Create_Statement
    FROM sys.dm_db_missing_index_groups dm_mig
    INNER JOIN sys.dm_db_missing_index_group_stats dm_migs ON dm_migs.group_handle = dm_mig.index_group_handle
    INNER JOIN sys.dm_db_missing_index_details dm_mid      ON dm_mig.index_handle = dm_mid.index_handle
    WHERE OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) not like ''%sys%''
		ORDER BY user_seeks  DESC   
    '
		    
		EXEC (@varExec)

		IF(@debug = 1) 
		Begin
			Select * from BA_DBA.DBO.DBA_MONITOR_MISSING_INDEX			
		end
    
		Delete from @sysdb where name = @dbname
  end

	Delete From BA_DBA.dbo.DBA_MONITOR_MISSING_INDEX Where data <= CONVERT(CHAR(8),DATEADD(MONTH, -3, GETDATE()),112) 	 

end --proc
go
--delete from BA_DBA..DBA_MONITOR_MISSING_INDEX
if (OBJECT_ID('BA_DBA..DBA_MONITOR_MISSING_INDEX') is null) begin
  --drop Table DBA_MONITOR_MISSING_INDEX
 create Table BA_DBA.DBO.DBA_MONITOR_MISSING_INDEX (
   data								datetime             NOT NULL,
   servidor						varchar(50)          NOT NULL,
   db									varchar(50)          NOT NULL,
   tabela							varchar(100)         NOT NULL,
   avg_user_impact		float                NOT NULL,
   user_seeks					bigint               NOT NULL,
   user_scans					bigint               NOT NULL,
   last_User_Seek			datetime             NOT NULL,
   equality_columns   varchar(500)         NULL,
   inequality_columns varchar(500)         NULL,
   included_columns   varchar(500)         NULL,
   create_Statement   varchar(4000)        NOT NULL
     --CONSTRAINT DBA_MONITOR_MISSING_INDEX_PK PRIMARY KEY CLUSTERED (data, db, tabela, Create_Statement) ON [PRIMARY]
  );
end
GO 
drop Table if exists DBA_MONITOR_MISSING_INDEX_HISTORY
-- Select * from BA_DBA..DBA_MONITOR_MISSING_INDEX (nolock)  Order by user_seeks desc
--exec BA_DBA.dbo.PR_DBA_MISSING_INDEX @debug = 1
