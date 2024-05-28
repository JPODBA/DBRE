SELECT TOP (1) 
    [Project2].[ID] AS [ID], 
    [Project2].[C1] AS [C1], 
    [Project2].[C2] AS [C2]
    FROM ( SELECT 
        [Extent1].[ID] AS [ID], 
        N'ff993600-2a1d-4c70-8249-319928c4a1ab' AS [C1], 
        N'Id' AS [C2]
        FROM [dbo].[SVw_Cotacao_Revisao] AS [Extent1]
        WHERE ([Extent1].[ID_Usuario] = 10029267) AND ((((DATEPART (year, [Extent1].[Data])) * 10000) + ((DATEPART (month, [Extent1].[Data])) * 100) + (DATEPART (day, [Extent1].[Data]))) <= ((2023 * 10000) + (12 * 100) + 31)) AND ((((DATEPART (year, [Extent1].[Data])) * 10000) + ((DATEPART (month, [Extent1].[Data])) * 100) + (DATEPART (day, [Extent1].[Data]))) >= ((2023 * 10000) + (1 * 100) + 1)) AND ([Extent1].[UltimaRevisao] = 1) AND ( EXISTS (SELECT 
            1 AS [C1]
            FROM [dbo].[SVw_Marcador_Item] AS [Extent2]
            WHERE ([Extent2].[ID_Oportunidade] IS NOT NULL) AND ([Extent1].[ID_Usuario] = [Extent2].[ID_Usuario]) AND ([Extent1].[ID_Oportunidade] = [Extent2].[ID_Oportunidade]) AND ([Extent2].[ID_Marcador] = 10047514)
        ))
    )  AS [Project2]
    ORDER BY [Project2].[ID] ASC

-- Tunning - EndPoint /Quotes

-- Drop index if exists [Usuario_Responsavel].IX_Usuario_Responsavel_ID_Responsavel
CREATE NONCLUSTERED INDEX IX_Usuario_Responsavel_ID_Responsavel
ON [dbo].[Usuario_Responsavel] ([ID_Responsavel],[ID_Tipo],[ID_Item])
INCLUDE ([ID_Usuario]) on INDEX_04

CREATE NONCLUSTERED INDEX IX_Cotacao_revisão_ID_Responsavel
ON [dbo].Cotacao_revisão (ID_Responsavel)
INCLUDE (ID) on INDEX_04

