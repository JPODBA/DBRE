Select 'sp_helpindex '''+name+'''' from sys.tables order by create_date desc

Select * from BA_DBA.dbo.DBA_ROLLBACK_DEPLOY_INDEX_LARGETABLES order by tabela
Select * from BA_DBA.dbo.DBA_ROLLBACK_DEPLOY_INDEX Where tabela like '%usuario%' order by tabela
sp_helpindex 'Tarefa'

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
	'WITH (FILLFACTOR = 100) ON [INDEX];' + CHAR(13) + CHAR(10) as [CreateIndex],
	'DROP INDEX IF EXISTS ['+ I.name +'] ON ['+ SCHEMA_NAME(T.schema_id) +'].['+ T.name +'];' +
	CHAR(13) + CHAR(10) AS [DropIndex]
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
WHERE I.is_primary_key = 0 AND I.is_unique_constraint = 0
and T.name not in (
'Oportunidade'
,'Cliente'
,'Ploomes_Cliente'
,'Usuario'
,'Tarefa'
,'Tarefa_Conclusao'
,'Produto'
)
Order by T.name