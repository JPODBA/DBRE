-- Endpoint: deals
SET STATISTICS IO ON;  
SET STATISTICS XML ON
SELECT 
    [GroupBy1].[A1] AS [C1]
    FROM ( SELECT 
        COUNT_BIG(1) AS [A1]
        FROM  [dbo].[SVw_Oportunidade] AS [Extent1]
        INNER JOIN [dbo].[SVw_Oportunidade] AS [Extent2] ON ([Extent1].[ID_Usuario] = [Extent2].[ID_Usuario]) AND ([Extent1].[ID_OportunidadeOrigem] = [Extent2].[ID])
        WHERE ([Extent1].[ID_Usuario] = 30001458) AND ([Extent2].[ID_Funil] = 42096) AND ( EXISTS (SELECT 
            1 AS [C1]
            FROM [dbo].[SVw_Campo_Valor_Oportunidade] AS [Extent3]
            WHERE ([Extent1].[ID_Usuario] = [Extent3].[ID_UsuarioView]) AND ([Extent1].[ID] = [Extent3].[ID_Oportunidade]) AND ([Extent3].[ID_Campo] = 231680) AND ([Extent3].[ValorInteiro] = 20490741)
        )) AND ( EXISTS (SELECT 
            1 AS [C1]
            FROM [dbo].[SVw_Campo_Valor_Oportunidade] AS [Extent4]
            WHERE ([Extent1].[ID_Usuario] = [Extent4].[ID_UsuarioView]) AND ([Extent1].[ID] = [Extent4].[ID_Oportunidade]) AND ([Extent4].[ID_Campo] = 191239) AND ((((DATEPART (year, [Extent4].[ValorDataHora])) * 10000) + ((DATEPART (month, [Extent4].[ValorDataHora])) * 100) + (DATEPART (day, [Extent4].[ValorDataHora]))) >= ((2023 * 10000) + (5 * 100) + 1))
        )) AND ( EXISTS (SELECT 
            1 AS [C1]
            FROM [dbo].[SVw_Campo_Valor_Oportunidade] AS [Extent5]
            WHERE ([Extent1].[ID_Usuario] = [Extent5].[ID_UsuarioView]) AND ([Extent1].[ID] = [Extent5].[ID_Oportunidade]) AND ([Extent5].[ID_Campo] = 191239) AND ((((DATEPART (year, [Extent5].[ValorDataHora])) * 10000) + ((DATEPART (month, [Extent5].[ValorDataHora])) * 100) + (DATEPART (day, [Extent5].[ValorDataHora]))) <= ((2023 * 10000) + (5 * 100) + 31))
        )) AND ([Extent1].[ID_Status2] = 2) AND (1 = 1) AND ([Extent1].[ID_Funil] = 39709)
    )  AS [GroupBy1]

SET STATISTICS IO OFF;
