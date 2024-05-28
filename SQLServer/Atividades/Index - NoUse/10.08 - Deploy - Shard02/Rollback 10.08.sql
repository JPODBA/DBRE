CREATE NONCLUSTERED INDEX [IX_Automation_LastRunTime]				            ON [dbo].[Automation] ([TriggerId] ASC, [LastRunTime] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  
CREATE NONCLUSTERED INDEX [IX_Automation_TriggerId2]				            ON [dbo].[Automation] ([TriggerId] ASC, [Suspended] ASC, [Enabled] ASC)  INCLUDE (AccountId, BlockTriggerByAutomation, EntityId, ExecuteNow, Id, LastRunTime, NextRunTime, Ordination, TriggerFilterId, TriggerRepeatIntervalLength, TriggerRepeatIntervalUnitId, TriggerRepeatStartDateTime) WITH (FILLFACTOR = 100) ON [INDEX];  
CREATE NONCLUSTERED INDEX [IX_Automation_Email_AutomationId]            ON [dbo].[Automation_Email] ([AutomationId] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  
CREATE NONCLUSTERED INDEX [IX_Automation_Email_Attachment_AttachmentId] ON [dbo].[Automation_Email_Attachment] ([AttachmentId] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  
CREATE NONCLUSTERED INDEX [IX_Automation_Log_ActionId]									ON [dbo].[Automation_Log] ([ActionId] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  
CREATE NONCLUSTERED INDEX [IX_Automation_Log_AutomationId]							ON [dbo].[Automation_Log] ([AutomationId] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  
CREATE NONCLUSTERED INDEX [IX_Automation_Log_DealId]										ON [dbo].[Automation_Log] ([DealId] ASC, [DateTime] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  
CREATE NONCLUSTERED INDEX [IX_Automation_Log_AutomationId2]							ON [dbo].[Automation_Log] ([AutomationId] ASC)  INCLUDE (ActionId, DateTime, DealId, Id, Success) WITH (FILLFACTOR = 100) ON [INDEX];  


CREATE NONCLUSTERED INDEX [IX_Automation_Log_DealId] ON [dbo].[Automation_Log] ([DealId] ASC, [DateTime] ASC) WITH (FILLFACTOR = 100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Automation_Log_DateTime] ON [dbo].[Automation_Log] ([DateTime] DESC) WITH (FILLFACTOR = 100) ON [INDEX];  


sp_helpindex '[Automation_Log]'