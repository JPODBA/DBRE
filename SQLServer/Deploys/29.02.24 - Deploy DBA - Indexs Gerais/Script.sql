--Deploy de indexs - 29/02

-- Central
CREATE INDEX [ix_Account_IDM01] ON [Ploomes_CRM].[dbo].[Account] ([AccountModelId], [Ghost]) INCLUDE ([Id]) ON [Primary]

-- Shard01
CREATE INDEX [ix_Ploomes_Cliente_Integration_CustomField_IDM01] ON [Ploomes_CRM].[dbo].[Ploomes_Cliente_Integration_CustomField] ([CustomFieldId]) INCLUDE ([FieldId]) on INDEX_02 

-- Shard02
CREATE INDEX [ix_Ploomes_Cliente_Integration_CustomField_IDM01] ON [Ploomes_CRM].[dbo].[Ploomes_Cliente_Integration_CustomField] ([CustomFieldId]) INCLUDE ([FieldId]) on INDEX_02 

--shard05
CREATE INDEX [ix_Integration_IDM01] ON [Integrations].[dbo].[Integration] ([AccountId], [ReplacedIn]) ON INDEX_02
CREATE INDEX [ix_Usuario_IDM02] ON [Ploomes_CRM].[dbo].[Usuario] ([ID_Criador],[Integracao]) ON INDEX_02
CREATE INDEX [ix_Campo_Valor_Order_IDM01] ON [Ploomes_CRM].[dbo].[Campo_Valor_Order] ([IntegerValue]) INCLUDE ([OrderId], [FieldId]) on INDEX_02 


--Shard06
-- VIsa melhorar a viwe Automation_Log
CREATE INDEX IX_Automation_Log_AccountId_DBA ON [Ploomes_CRM].[dbo].Automation_Log (AccountId, Suspended) on INDEX_02 


-- Shard10
CREATE INDEX [ix_WebhookAttempt_IDM01] ON [Ploomes_CRM_Logs].[dbo].[WebhookAttempt] ([WebhookId], [Executing]) ON [Primary]
CREATE INDEX [ix_WebhookAttempt_IDM02] ON [Ploomes_CRM_Logs].[dbo].[WebhookAttempt] ([Executing]) INCLUDE ([WebhookId])  ON [Primary]
CREATE INDEX [ix_AutomationAttempt_IDM01] ON [Ploomes_CRM_Logs].[dbo].[AutomationAttempt] ([AutomationId], [ItemId]) ON [Primary]

-- Modulo Analitcs
CREATE INDEX [ix_PanelFilterStatus_IDM01] ON [Ploomes_Reports].[dbo].[PanelFilterStatus] ([PanelFilterId]) INCLUDE ([UserId], [Actived], [Ordination]) ON [Primary]


-- SHANKYA
CREATE INDEX [IX_Integration_IDM02] ON [Integrations].[dbo].[Integration] ([AccountId], [ReplacedIn]) ON [Primary]
CREATE INDEX [IX_Integration_IDM03] ON [Integrations].[dbo].[Integration] ([ReplacedIn], [Halted],[Status], [NextSearchDate]) ON [Primary]





