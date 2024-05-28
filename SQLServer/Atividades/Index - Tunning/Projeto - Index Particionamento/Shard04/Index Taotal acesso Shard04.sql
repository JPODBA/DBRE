-- ORDER BY TOTAL ACESSO
SELECT
	ob.name AS Table_name,
	id.name AS Index_name,
	us.user_seeks,
	us.user_scans,
	us.user_updates,
	(us.user_seeks + us.user_scans + us.user_lookups) [totalAcesso],
	us.last_user_scan,
	us.last_user_seek,
	us.last_user_lookup
into BA_DBA.dbo.DROP_DBA_INDEX_TOTALACESSO
FROM sys.dm_db_index_usage_stats us
JOIN sys.objects  ob ON us.OBJECT_ID = ob.OBJECT_ID
JOIN sys.indexes  id ON id.index_id = us.index_id AND us.OBJECT_ID = id.OBJECT_ID
JOIN sys.schemas  sc ON sc.schema_id = ob.schema_id
WHERE  us.user_scans > 0
	AND id.name not like 'PK%'
	AND id.name not like 'UK%'
	--AND sc.name not like ''sys%''						
ORDER BY
		[totalAcesso] DESC

		 
Select * from BA_DBA.dbo.DROP_DBA_INDEX_TOTALACESSO order by [totalAcesso] DESC