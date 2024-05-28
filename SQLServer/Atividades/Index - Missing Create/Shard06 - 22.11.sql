Select top 10 * from BA_DBA.dbo.DBA_MONITOR_MISSING_INDEX order by user_seeks desc
Select top 10 * from BA_DBA.dbo.DBA_MONITOR_MISSING_INDEX order by avg_user_impact desc

go 
use Ploomes_CRM
go 
CREATE INDEX [AutomationAttempt_IDM] ON [Ploomes_CRM_Logs].[dbo].[AutomationAttempt] ([Executing], [Periodic], [AccountId]) ON INDEX_02
go
sp_helpindex '[Timeline]'
CREATE INDEX [IX_Timeline_IDM01] ON [Ploomes_CRM].[dbo].[Timeline] ([ID_ClientePloomes], [Principal], [ID_TipoResponsavel]) 
INCLUDE ([ID_Cliente], [ID_Oportunidade], [ID_Usuario], [Cliente], [Oportunidade], [Usuario], [DataHora], [Venda], [ID_Venda], 
[ID_ResponsavelSecundario], [ID_TipoResponsavelSecundario], [ID_Documento], [Documento])