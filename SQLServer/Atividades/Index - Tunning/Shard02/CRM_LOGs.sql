CREATE INDEX [AutomationAttempt_DBA01] ON [Ploomes_CRM_Logs].[dbo].[AutomationAttempt] ([Executing], [Periodic]) INCLUDE ([Id], [AutomationId], [AutomationUserKey], [ItemId], [DateTime], [CurrentAttempt], [IterationCount], [AccountId], [ExecutingDate]) 
CREATE INDEX [AutomationAttempt_DBA02] ON [Ploomes_CRM_Logs].[dbo].[AutomationAttempt] ([AccountId]) INCLUDE ([Id], [AutomationId], [AutomationUserKey], [ItemId], [DateTime], [Executing], [CurrentAttempt], [IterationCount], [Periodic], [ExecutingDate]) 
CREATE INDEX [AutomationAttempt_DBA03] ON [Ploomes_CRM_Logs].[dbo].[AutomationAttempt] ([CurrentAttempt])
CREATE INDEX [WebhookAttempt_DBA01] ON [Ploomes_CRM_Logs].[dbo].[WebhookAttempt] ([CurrentAttempt]) 
CREATE INDEX [WebhookAttempt_DBA02] ON [Ploomes_CRM_Logs].[dbo].[WebhookAttempt] ([Executing]) INCLUDE ([Id], [AccountId], [WebhookId], [DateTime], [ExecutingDate])

 
select count(1) from [Ploomes_CRM_Logs].[dbo].[AutomationAttempt] (nolock)

sp_lock

kill 148      

SP_WHOISACTIVE

sp_WhoIsActive @get_locks = 1



sp_who2