ALTER DATABASE EMG
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

ALTER DATABASE Ploomes_CRM_Logs
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;


-- Renomear a tabela de EMG para Ploomes_CRM_Logs
ALTER DATABASE Ploomes_CRM_Logs MODIFY NAME = Ploomes_CRM_Logs_OLD;

-- Renomear a tabela Ploomes_CRM_Logs para Ploomes_CRM_Logs_OLD
ALTER DATABASE EMG MODIFY NAME = Ploomes_CRM_Logs;

--EXEC sp_rename 'Teste', 'Teste1';
use master
go
ALTER DATABASE Ploomes_CRM_Logs
SET MULTI_USER WITH ROLLBACK IMMEDIATE;;

ALTER DATABASE Ploomes_CRM_Logs_OLD
SET MULTI_USER;


go 
use Ploomes_CRM_Logs
go 
select top 10 * from event (nolock)

use EMG
CREATE NONCLUSTERED INDEX [IX_API_DateTime] ON [dbo].[API] ([DateTime] DESC) WITH (FILLFACTOR = 100) 
CREATE NONCLUSTERED INDEX [IX_API_UserId] ON [dbo].[API] ([UserId] ASC) WITH (FILLFACTOR = 100)
CREATE NONCLUSTERED INDEX [IX_AutomationAttempt_AccountId] ON [dbo].[AutomationAttempt] ([AccountId] ASC, [Periodic] ASC, [Executing] ASC) WITH (FILLFACTOR = 100)
CREATE NONCLUSTERED INDEX [IX_AutomationAttempt_AutomationId] ON [dbo].[AutomationAttempt] ([AutomationId] ASC, [ItemId] ASC) WITH (FILLFACTOR = 100) 
CREATE NONCLUSTERED INDEX [IX_AutomationAttempt_ExecutingDate] ON [dbo].[AutomationAttempt] ([Executing] DESC, [ExecutingDate] ASC) WITH (FILLFACTOR = 100)
CREATE NONCLUSTERED INDEX [IX_AutomationAttempt_IDM01] ON [dbo].[AutomationAttempt] ([Executing] ASC, [Periodic] ASC)  INCLUDE (AccountId, AutomationId,
AutomationUserKey, CurrentAttempt, DateTime, ExecutingDate, ItemId, IterationCount) WITH (FILLFACTOR = 100) 

CREATE NONCLUSTERED INDEX [IX_ChangeLogAttempt_ExecutingDate] ON [dbo].[ChangeLogAttempt] ([Executing] DESC, [ExecutingDate] ASC) WITH (FILLFACTOR = 100)   
CREATE NONCLUSTERED INDEX [IX_ChangeReportAttempt_ExecutingDate] ON [dbo].[ChangeReportAttempt] ([Executing] DESC, [ExecutingDate] ASC) WITH (FILLFACTOR = 100)
CREATE NONCLUSTERED INDEX [IX_ChangeReportAttempt_ItemId] ON [dbo].[ChangeReportAttempt] ([ItemId] ASC) WITH (FILLFACTOR = 100) ;  
CREATE NONCLUSTERED INDEX [IX_IdentityProviderAttempt_ExecutingDate] ON [dbo].[IdentityProviderAttempt] ([Executing] DESC, [ExecutingDate] ASC) WITH (FILLFACTOR = 100) 
CREATE NONCLUSTERED INDEX [IX_SocketEvent_ExecutingDate] ON [dbo].[SocketEvent] ([Executing] DESC, [ExecutingDate] ASC) WITH (FILLFACTOR = 100) 
CREATE NONCLUSTERED INDEX [IX_TableSyncAttempt_ExecutingDate] ON [dbo].[TableSyncAttempt] ([Executing] DESC, [ExecutingDate] ASC) WITH (FILLFACTOR = 100)   
CREATE NONCLUSTERED INDEX [IX_WebhookAttempt_WebhookId] ON [dbo].[WebhookAttempt] ([WebhookId] ASC, [Executing] ASC) WITH (FILLFACTOR = 100) 
CREATE NONCLUSTERED INDEX [IX_WebhookAttempt_ExecutingDate] ON [dbo].[WebhookAttempt] ([Executing] DESC, [ExecutingDate] ASC) WITH (FILLFACTOR = 100)  
CREATE NONCLUSTERED INDEX [IX_CustomerHealthAttempt] ON [dbo].[CustomerHealthAttempt] ([Executing] DESC, [ExecutingDate] ASC) WITH (FILLFACTOR = 100)  



