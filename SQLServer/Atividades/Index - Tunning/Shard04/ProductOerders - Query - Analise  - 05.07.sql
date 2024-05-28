-- OrdersProducts 
SET STATISTICS IO ON;  
SET STATISTICS XML ON
SELECT TOP (9) 
    [Project3].[ID_Usuario] AS [ID_Usuario], 
    [Project3].[C1] AS [C1], 
    [Project3].[C2] AS [C2], 
    [Project3].[Total] AS [Total], 
    [Project3].[C3] AS [C3], 
    [Project3].[ID_Venda] AS [ID_Venda], 
    [Project3].[C4] AS [C4], 
    [Project3].[ID] AS [ID], 
    [Project3].[C5] AS [C5], 
    [Project3].[C6] AS [C6], 
    [Project3].[C7] AS [C7], 
    [Project3].[ID_Produto] AS [ID_Produto], 
    [Project3].[C8] AS [C8], 
    [Project3].[C9] AS [C9], 
    [Project3].[C10] AS [C10], 
    [Project3].[Descricao] AS [Descricao], 
    [Project3].[C11] AS [C11], 
    [Project3].[ID_Grupo] AS [ID_Grupo], 
    [Project3].[C12] AS [C12], 
    [Project3].[C13] AS [C13]
    FROM ( SELECT 
        [Project1].[ID_Usuario] AS [ID_Usuario], 
        [Project1].[ID] AS [ID], 
        [Project1].[ID_Venda] AS [ID_Venda], 
        [Project1].[ID_Produto] AS [ID_Produto], 
        [Project1].[Total] AS [Total], 
        [Project1].[ID_Grupo] AS [ID_Grupo], 
        [Project1].[Descricao] AS [Descricao], 
        N'fc144523-a041-445d-b363-3e504133a356' AS [C1], 
        N'Total' AS [C2], 
        N'OrderId' AS [C3], 
        N'Id' AS [C4], 
        N'Product' AS [C5], 
        N'fc144523-a041-445d-b363-3e504133a356' AS [C6], 
        N'Id' AS [C7], 
        N'Group' AS [C8], 
        N'fc144523-a041-445d-b363-3e504133a356' AS [C9], 
        N'Name' AS [C10], 
        N'Id' AS [C11], 
        CASE WHEN ([Project1].[ID_Grupo] IS NULL) THEN cast(1 as bit) ELSE cast(0 as bit) END AS [C12], 
        CASE WHEN ([Project1].[ID_Produto] IS NULL) THEN cast(1 as bit) ELSE cast(0 as bit) END AS [C13]
        FROM ( SELECT 
            [Extent1].[ID_Usuario] AS [ID_Usuario], 
            [Extent1].[ID] AS [ID], 
            [Extent1].[ID_Venda] AS [ID_Venda], 
            [Extent1].[ID_Produto] AS [ID_Produto], 
            [Extent1].[Total] AS [Total], 
            [Extent1].[ContactProductId] AS [ContactProductId], 
            [Extent3].[Data] AS [Data], 
            [Extent4].[ID_Grupo] AS [ID_Grupo], 
            [Extent5].[Descricao] AS [Descricao]
            FROM     [dbo].[SVw_Venda_Produto] AS [Extent1]
            INNER JOIN [dbo].[Vw_Venda_Produto] AS [Extent2] ON ([Extent1].[ID] = [Extent2].[ID]) AND ([Extent1].[ID_Usuario] = [Extent2].[ID_Usuario])
            LEFT OUTER JOIN [dbo].[SVw_Venda] AS [Extent3] ON ([Extent1].[ID_Usuario] = [Extent3].[ID_Usuario]) AND ([Extent1].[ID_Venda] = [Extent3].[ID])
            LEFT OUTER JOIN [dbo].[SVw_Produto] AS [Extent4] ON ([Extent1].[ID_Usuario] = [Extent4].[ID_Usuario]) AND ([Extent1].[ID_Produto] = [Extent4].[ID])
            LEFT OUTER JOIN [dbo].[SVw_Produto_Grupo] AS [Extent5] ON ([Extent4].[ID_Usuario] = [Extent5].[ID_Usuario]) AND ([Extent4].[ID_Grupo] = [Extent5].[ID])
            WHERE [Extent2].[ID_Usuario] = 30000824
        )  AS [Project1]
        WHERE ((((DATEPART (year, [Project1].[Data])) * 10000) + ((DATEPART (month, [Project1].[Data])) * 100) + (DATEPART (day, [Project1].[Data]))) <= ((2023 * 10000) + (7 * 100) + 5)) AND ((((DATEPART (year, [Project1].[Data])) * 10000) + ((DATEPART (month, [Project1].[Data])) * 100) + (DATEPART (day, [Project1].[Data]))) >= ((2023 * 10000) + (1 * 100) + 5)) AND ( EXISTS (SELECT 
            1 AS [C1]
            FROM   [dbo].[SVw_Cliente_Produto] AS [Extent6]
            LEFT OUTER JOIN [dbo].[SVw_Cliente] AS [Extent7] ON ([Extent6].[ViewUserId] = [Extent7].[ID_Usuario]) AND ([Extent6].[ContactId] = [Extent7].[ID])
            INNER JOIN [dbo].[SVw_Campo_Valor_Cliente] AS [Extent8] ON ([Extent7].[ID_Usuario] = [Extent8].[ID_UsuarioView]) AND ([Extent7].[ID] = [Extent8].[ID_Cliente])
            WHERE ([Project1].[ID_Usuario] = [Extent6].[ViewUserId]) AND ([Project1].[ContactProductId] = [Extent6].[Id]) AND ([Extent8].[ID_Campo] = 144805) AND ([Extent8].[ValorInteiro] = 9190947)
        )) AND (1 = 1) AND ([Project1].[ID] > 0)
    )  AS [Project3]
    ORDER BY [Project3].[ID] ASC

SET STATISTICS IO OFF;


--sp_helpindex 'cliente'
--ID_ClientePloomes, ID_Responsavel, ID_Importacao
--CREATE INDEX IX_Cliente_ID_ClientePloomes2 ON cliente (ID_ClientePloomes, ID_Responsavel, ID_Importacao) on INDEX_04
--GO
--drop index if exists cliente.IX_Cliente_ID_ClientePloomes2


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
WHERE ob.name in ('Cliente')
--Where id.name not like 'PK%'
ORDER BY 5 DESC





