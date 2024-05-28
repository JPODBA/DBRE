-- ORDER BY TOTAL ACESSO
SELECT
	sc.name AS SchemaName,
	ob.name AS Table_name,
	id.name AS Index_name,
	us.user_seeks,
	us.user_scans,
	us.user_updates,
	(us.user_seeks + us.user_scans + us.user_lookups) [totalAcesso],
	us.last_user_scan,
	us.last_user_seek,
	us.last_user_lookup
FROM sys.dm_db_index_usage_stats us
JOIN sys.objects  ob ON us.OBJECT_ID = ob.OBJECT_ID
JOIN sys.indexes  id ON id.index_id = us.index_id AND us.OBJECT_ID = id.OBJECT_ID
JOIN sys.schemas  sc ON sc.schema_id = ob.schema_id
WHERE id.name not like 'PK%'
	AND id.name not like 'UK%'
	and ob.name like 'cliente'	
	--and us.user_scans > 0
ORDER BY
		us.user_scans DESC
		
