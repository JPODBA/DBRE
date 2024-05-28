Select top 10 * from BA_DBA.dbo.DBA_MONITOR_MISSING_INDEX order by user_seeks desc
Select top 10 * from BA_DBA.dbo.DBA_MONITOR_MISSING_INDEX order by avg_user_impact desc

go 
use Ploomes_CRM
go
sp_helpindex '[Ploomes_Cliente_Integration_CustomField]'
CREATE INDEX [IX_Ploomes_Cliente_Integration_CustomField_IDM01] ON [Ploomes_CRM].[dbo].[Ploomes_Cliente_Integration_CustomField] ([CustomFieldId]) INCLUDE ([FieldId]) 