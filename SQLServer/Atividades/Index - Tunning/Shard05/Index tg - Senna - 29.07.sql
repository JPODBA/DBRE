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
WHERE 
--id.name not like 'PK%'
    --AND id.name not like 'UK%'
    --AND us.user_seeks = 0
    ob.name = 'Usuario_Responsavel'
    --and id.name = 'IX_Oportunidade_ID_Funil2'
ORDER BY
        [totalAcesso] DESC

--sp_helpindex 'Usuario_Responsavel'

CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_DBA] ON [dbo].[Usuario_Responsavel]
(
    [ID_Tipo] ASC,
    [ID_Usuario] ASC,
    [ID_Item] ASC
)WITH (FILLFACTOR = 100) ON [INDEX_02]
GO

CREATE NONCLUSTERED INDEX [IX_Oportunidade_Colaborador_Usuario_DBA] ON [dbo].[Oportunidade_Colaborador_Usuario]
(
    [ID_Usuario] ASC,
    [Sistema] ASC
)WITH (FILLFACTOR = 100) ON [INDEX_02]
GO




