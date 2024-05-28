Select * from BA_DBA.dbo.DBA_MONITOR_MISSING_INDEX order by 6 desc

--drop index if exists [Oportunidade_Funil].[Oportunidade_Funil_IDM01]
CREATE INDEX [ix_Oportunidade_Funil_IDM01] ON [Ploomes_CRM].[dbo].[Oportunidade_Funil] ([Suspenso]) INCLUDE ([ID_ClientePloomes]) on index_04
--sp_helpindex 'Oportunidade_Funil'

CREATE INDEX [ix_Field_IDM01] ON [Ploomes_CRM].[dbo].[Field] ([AccountId], [Dynamic]) 
INCLUDE ([Key], [FieldId]) on index_04

CREATE INDEX [ix_Campo_Valor_Order_IDM01] ON [Ploomes_CRM].[dbo].[Campo_Valor_Order] ([FieldId],[OrderId]) 
INCLUDE ([DateTimeValue]) on index_04

CREATE INDEX [ix_Campo_Valor_Cliente_IDM01] ON [Ploomes_CRM].[dbo].[Campo_Valor_Cliente] ([ID_Campo], [ValorBooleano]) 
INCLUDE ([ID_Cliente]) on index_04

CREATE INDEX [ix_Oportunidade_IDM01] ON [Ploomes_CRM].[dbo].[Oportunidade] ([ID_Cliente], [Suspenso],[ID_Funil]) on index_04

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
WHERE ob.name in ('Oportunidade', 'Campo_Valor_Cliente', 'Campo_Valor_Order', 'Field','Oportunidade_Funil')
	and id.name like '%IDM%'
ORDER BY 5 DESC

