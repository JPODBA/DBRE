USE Ploomes_CRM
GO
IF (OBJECT_ID ('PR_DBA_CONTIGENCIA_DROPINDEX') IS NULL) EXEC ('Create Procedure PR_DBA_CONTIGENCIA_DROPINDEX as return')
GO
CREATE OR ALTER PROC PR_DBA_CONTIGENCIA_DROPINDEX
	@Debug bit = 0
/************************************************************************
 Autor: João Paulo Oliveira \ DBA
 Data de criação: 17/04/2024
 Data de Atualização: 
 Funcionalidade: 
*************************************************************************/
AS
BEGIN
	
	DROP TABLE IF EXISTS DBA_CONTIGENCIA_DROP
	DROP TABLE IF EXISTS #DROP_ROLLBACK
	DROP TABLE IF EXISTS #INDEX_DROP


	SELECT 
		T.name as tabela,
		I.name as IndexName, 
		-- Uncommnent line below to include checking for index exists as part of the script
		--'IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = '''+ I.name +''') ' +
		'CREATE ' + CASE WHEN I.is_unique = 1 THEN ' UNIQUE ' ELSE '' END +
		I.type_desc COLLATE DATABASE_DEFAULT + ' INDEX [' +
		I.name + '] ON [' + SCHEMA_NAME(T.schema_id) + '].[' + T.name + '] (' + STUFF(
		(SELECT ', [' + C.name + CASE WHEN IC.is_descending_key = 0 THEN '] ASC' ELSE '] DESC' END
				FROM sys.index_columns IC INNER JOIN sys.columns C ON  IC.object_id = C.object_id  AND IC.column_id = C.column_id
				WHERE IC.is_included_column = 0 AND IC.object_id = I.object_id AND IC.index_id = I.Index_id
				FOR XML PATH('')), 1, 2, '')  + ') ' +
		ISNULL(' INCLUDE (' + IncludedColumns + ') ', '') +
		ISNULL(' WHERE ' + I.filter_definition, '') + 
		'WITH (FILLFACTOR = 100) ON [PRIMARY];' + CHAR(13) + CHAR(10) as [CreateIndex],
		'DROP INDEX IF EXISTS ['+ I.name +'] ON ['+ SCHEMA_NAME(T.schema_id) +'].['+ T.name +'];' +
		CHAR(13) + CHAR(10) AS [DropIndex]
	INTO #DROP_ROLLBACK
	FROM    sys.indexes I INNER JOIN        
					sys.tables T ON  T.object_id = I.object_id INNER JOIN       
					sys.stats ST ON  ST.object_id = I.object_id AND ST.stats_id = I.index_id INNER JOIN 
					sys.data_spaces DS ON  I.data_space_id = DS.data_space_id INNER JOIN 
					sys.filegroups FG ON  I.data_space_id = FG.data_space_id LEFT OUTER JOIN 
					(SELECT * FROM 
							(SELECT IC2.object_id, IC2.index_id,
									STUFF((SELECT ', ' + C.name FROM sys.index_columns IC1 INNER JOIN 
											sys.columns C ON C.object_id = IC1.object_id
													AND C.column_id = IC1.column_id
													AND IC1.is_included_column = 1
											WHERE  IC1.object_id = IC2.object_id AND IC1.index_id = IC2.index_id
											GROUP BY IC1.object_id, C.name, index_id  FOR XML PATH('')
									), 1, 2, '') as IncludedColumns
							FROM sys.index_columns IC2
							GROUP BY IC2.object_id, IC2.index_id) tmp1
							WHERE IncludedColumns IS NOT NULL
					) tmp2
					ON tmp2.object_id = I.object_id AND tmp2.index_id = I.index_id
	WHERE I.is_primary_key = 0 
		AND I.is_unique_constraint = 0
	Order by T.name

	Select 
		COUNT(indice) as Count_Vezes_Natabela, 
		indice AS indice, tabela AS tabela, ultimoSeek AS ultimoSeek, totalacesso AS totalacesso,
		'Drop index if exists '+tabela+'.'+indice+';' AS Comando
	INTO #INDEX_DROP
	From BA_DBA..DBA_MONITOR_INDEX_NOUSE
	group by indice, tabela, ultimoSeek, totalacesso
	Having COUNT(indice) > 15
	order by COUNT(indice) desc

	--SELECT 
	--	DR.* 
	--FROM #DROP_ROLLBACK DR
	--JOIN #INDEX_DROP    DM (NOLOCK) ON DM.indice = DR.IndexName
	
	SELECT 
		DR.* 
	INTO DBA_CONTIGENCIA_DROP 
	FROM #DROP_ROLLBACK DR
	JOIN #INDEX_DROP    DM (NOLOCK) ON DM.indice = DR.IndexName

	SELECT * FROM DBA_CONTIGENCIA_DROP

END