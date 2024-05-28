SELECT 
    [GroupBy1].[A1] AS [C1]
    FROM ( SELECT 
        COUNT_BIG(1) AS [A1]
        FROM [dbo].[SVw_Cliente] AS [Extent1]
        WHERE ([Extent1].[ID_Usuario] = 99451) AND ((([Extent1].[ID_Tipo] = 1) AND ( EXISTS (SELECT 
            1 AS [C1]
            FROM [dbo].[SVw_Campo_Valor_Cliente] AS [Extent2]
            WHERE ([Extent1].[ID_Usuario] = [Extent2].[ID_UsuarioView]) AND ([Extent1].[ID] = [Extent2].[ID_Cliente]) 
						AND ([Extent2].[ID_Campo] = 209874) AND ([Extent2].[ValorInteiro] = 18094894)
        ))) OR (([Extent1].[ID_Tipo] = 2) AND ([Extent1].[ID_Cliente] IS NULL) AND ( EXISTS (SELECT 
            1 AS [C1]
            FROM [dbo].[SVw_Campo_Valor_Cliente] AS [Extent3]
            WHERE ([Extent1].[ID_Usuario] = [Extent3].[ID_UsuarioView]) AND ([Extent1].[ID] = [Extent3].[ID_Cliente]) 
						AND ([Extent3].[ID_Campo] = 209874) AND ([Extent3].[ValorInteiro] = 18094894)
        ))))
    )  AS [GroupBy1]


USE [Ploomes_CRM]

--drop index if exists Cliente.IX_Cliente_Suspenso
CREATE NONCLUSTERED INDEX IX_Cliente_Suspenso ON [dbo].[Cliente] ([Suspenso]) INCLUDE ([ID_ClientePloomes],[ID_Tipo],[ID_Cliente]) ON INDEX_04

--drop index if exists Notificacao.IX_Notificacao_ID_Usuario
CREATE INDEX IX_Notificacao_ID_Usuario ON [Ploomes_CRM].[dbo].[Notificacao] ([ID_Usuario], [Visto], [AccountId]) ON INDEX_04
--sp_helpindex'Notificacao'

CREATE INDEX IX_WebHook_AccountId_02 ON [Ploomes_CRM].[dbo].[WebHook] ([AccountId], [EntityId], [ActionId], [Active], [Suspended], [SecondaryEntityId]) 
INCLUDE ([CallbackUrl], [ValidationKey], [CreatorId], [CreateDate], [UpdaterId], [UpdateDate], [UserWebhook]) ON INDEX_04
--sp_helpindex 'WebHook'
