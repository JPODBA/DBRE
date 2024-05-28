CREATE INDEX [WebhookAttempt_IDM] ON [Ploomes_CRM_Logs].[dbo].[WebhookAttempt] ([WebhookId], [Executing])

CREATE INDEX [Ploomes_Cliente_Integration_IDM] ON [Ploomes_CRM].[dbo].[Ploomes_Cliente_Integration] ([SyncCache]) 
INCLUDE ([Id], [AccountId], [IntegrationId], [IntegrationUserId]) ON INDEX_02