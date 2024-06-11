use Ploomes_CRM
go
CREATE NONCLUSTERED INDEX [IX_Automation_Log_Id_DealId] ON [dbo].[Automation_Log]
(
    [Id] DESC,
    [DealId] ASC
) ON INDEX_03
GO