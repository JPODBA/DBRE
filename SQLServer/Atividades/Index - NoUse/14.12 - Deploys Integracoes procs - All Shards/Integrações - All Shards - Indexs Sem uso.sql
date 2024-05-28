USE Ploomes_CRM
GO
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
WHERE ob.name in ('Campo_Valor_Task')
	And id.name not like 'PK%'
ORDER BY 4 DESC

-- Indexs sem uso.
DROP INDEX IF EXISTS Campo_Valor_Task.IX_Campo_Valor_Task_IntegerValue
DROP INDEX IF EXISTS Campo_Valor_Task.IX_Campo_Valor_Task_BoolValue
DROP INDEX IF EXISTS Campo_Valor_Task.IX_Campo_Valor_Task_DecimalValue
DROP INDEX IF EXISTS Campo_Valor_Task.IX_Campo_Valor_Task_DateTimeValue
