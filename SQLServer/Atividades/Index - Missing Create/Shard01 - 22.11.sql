Select top 10 * from BA_DBA.dbo.DBA_MONITOR_MISSING_INDEX order by user_seeks desc
Select top 10 * from BA_DBA.dbo.DBA_MONITOR_MISSING_INDEX order by avg_user_impact desc

go 
use Ploomes_CRM
go
CREATE INDEX [IX_Cotacao_Revisao_Tabela_Produto_IDM01] ON [Ploomes_CRM].[dbo].[Cotacao_Revisao_Tabela_Produto] ([ContactProductId]) INCLUDE ([ID]) 
CREATE INDEX [IX_Ploomes_Cliente_Integration_IDM01] ON [Ploomes_CRM].[dbo].[Ploomes_Cliente_Integration] ([SyncCache]) INCLUDE ([Id], [AccountId], [IntegrationId], [IntegrationUserId]) 