select * from sys.master_files
go

Drop table if exists #DBA
SELECT 
    i.name AS IndexName,
    df.name AS DataFileName,
    df.physical_name AS DataFilePath,
    SUM(s.[used_page_count]) * 8 AS IndexSizeKB
into #DBA
FROM sys.indexes i
JOIN sys.partitions            p ON i.object_id = p.object_id AND i.index_id = p.index_id
JOIN sys.allocation_units		  au ON p.partition_id = au.container_id
JOIN sys.master_files					df ON au.data_space_id = df.data_space_id
JOIN sys.dm_db_partition_stats s ON s.[object_id] = i.[object_id] AND s.[index_id] = i.[index_id]
WHERE df.type = 0  -- Data files only, not log files
	and i.[name] NOT LIKE 'PK%'
	AND i.[name] NOT LIKE 'UK%'
	and df.database_id = 5
	--and df.name = 'Ploomes_CRM_INDEX'	
GROUP BY i.[name], df.name, df.physical_name
ORDER BY 
    IndexSizeKB DESC;

GO

--delete from #DBA where IndexSizeKB <= 9017848
--delete from #DBA where datafileName = 'Ploomes_CRM_INDEX_02'
--Select * from #DBA order by IndexSizeKB desc
GO

SELECT 
	T.name as tabela,
	I.name as IndexName, 
	'CREATE ' + CASE WHEN I.is_unique = 1 THEN ' UNIQUE ' ELSE '' END +
	I.type_desc COLLATE DATABASE_DEFAULT + ' INDEX [' +
	I.name + '] ON [' + SCHEMA_NAME(T.schema_id) + '].[' + T.name + '] (' + STUFF(
	(SELECT ', [' + C.name + CASE WHEN IC.is_descending_key = 0 THEN '] ASC' ELSE '] DESC' END
	    FROM sys.index_columns IC INNER JOIN sys.columns C ON  IC.object_id = C.object_id  AND IC.column_id = C.column_id
	    WHERE IC.is_included_column = 0 AND IC.object_id = I.object_id AND IC.index_id = I.Index_id
	    FOR XML PATH('')), 1, 2, '')  + ') ' +
	ISNULL(' INCLUDE (' + IncludedColumns + ') ', '') +
	ISNULL(' WHERE ' + I.filter_definition, '') + 
	'WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];' + CHAR(13) + CHAR(10) as [CreateIndex],
	'DROP INDEX IF EXISTS ['+ I.name +'] ON ['+ SCHEMA_NAME(T.schema_id) +'].['+ T.name +'];' +
	CHAR(13) + CHAR(10) AS [DropIndex]
FROM    sys.indexes I INNER JOIN   
				#DBA           dba on dba.IndexName = I.name INNER JOIN  
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
	and dba.IndexSizeKB <= 9017848
Order by T.name